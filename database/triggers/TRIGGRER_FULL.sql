/*
 * COMBINED TRIGGERS & FUNCTIONS SCRIPT
 * Berisi logika otomatisasi untuk:
 * 1. Top 3 Genres Collection
 * 2. Block Logic
 * 3. Review Timestamp
 * 4. Playlist Reorder
 * 5. Playlist Collaborators Fix
 * 6. Tour Date Validation
 * 7. Song Rating Update
 * 8. Artist Follow Count
 * 9. Pre-release Date Validation
 * 10. Collection Rating Update
 */

--------------------------------------------------------------------------------
-- 1. UPDATE COLLECTION TOP 3 GENRES
-- Mengupdate tabel collection_top_3_genres berdasarkan lagu di collections_songs
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_collection_top3_genres()
RETURNS TRIGGER AS $$
DECLARE
    top_genre RECORD;
BEGIN
    -- Hapus data lama untuk collection ini
    DELETE FROM collection_top_3_genres
    WHERE collection_id = NEW.collection_id;

    -- Ambil 3 genre paling sering muncul dari lagu-lagu collection
    FOR top_genre IN
        SELECT sg.genre_id
        FROM songs_genres sg
        JOIN collections_songs cs ON sg.song_id = cs.song_id
        WHERE cs.collection_id = NEW.collection_id
        GROUP BY sg.genre_id
        ORDER BY COUNT(*) DESC
        LIMIT 3
    LOOP
        -- Insert ke COLLECTION_TOP_3_GENRES
        INSERT INTO collection_top_3_genres (collection_id, genre_id)
        VALUES (NEW.collection_id, top_genre.genre_id);
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_collection_top3_genres
AFTER INSERT OR UPDATE ON collections_songs
FOR EACH ROW
EXECUTE FUNCTION update_collection_top3_genres();


--------------------------------------------------------------------------------
-- 2. ENFORCE BLOCK LOGIC
-- Menghapus hubungan follow jika user saling blokir
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION enforce_block_logic()
RETURNS TRIGGER AS $$
BEGIN
    -- Hapus hubungan follow kedua arah
    DELETE FROM follow_users
    WHERE (follower_id = NEW.blocker_id AND followed_id = NEW.blocked_id)
       OR (follower_id = NEW.blocked_id AND followed_id = NEW.blocker_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_block_cleanup
AFTER INSERT ON block_users
FOR EACH ROW
EXECUTE FUNCTION enforce_block_logic();


--------------------------------------------------------------------------------
-- 3. UPDATE REVIEW TIMESTAMP
-- Update timestamp saat review atau rating diedit
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_review_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    -- Jika kolom review atau rating berubah
    IF NEW.review IS DISTINCT FROM OLD.review
       OR NEW.rating IS DISTINCT FROM OLD.rating THEN

        NEW."TIMESTAMP" = CURRENT_TIMESTAMP;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_review_timestamp
BEFORE UPDATE ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_review_timestamp();


--------------------------------------------------------------------------------
-- 4. REORDER PLAYLIST SEQUENCE
-- Menggeser nomor urut lagu saat ada lagu yang dihapus dari playlist
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION reorder_playlist_sequence()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE add_songs_playlists
    SET no_urut = no_urut - 1
    WHERE playlist_id = OLD.playlist_id
    AND no_urut > OLD.no_urut;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_reorder_playlist_delete
AFTER DELETE ON add_songs_playlists
FOR EACH ROW
EXECUTE FUNCTION reorder_playlist_sequence();


--------------------------------------------------------------------------------
-- 5. FIX PLAYLIST COLLABORATORS
-- Mengubah kepemilikan lagu di playlist jika status collaborative dimatikan
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fix_playlist_collaborators()
RETURNS TRIGGER AS $$
BEGIN
    -- Jika sebelumnya collaborative dan sekarang tidak collaborative
    IF OLD.iscollaborative = TRUE AND NEW.iscollaborative = FALSE THEN

        -- Update semua lagu yang ditambahkan oleh user lain menjadi milik owner playlist
        UPDATE add_songs_playlists
        SET user_id = NEW.user_id
        WHERE playlist_id = NEW.playlist_id
        AND user_id <> NEW.user_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_fix_playlist_collaborators
AFTER UPDATE OF iscollaborative ON playlists
FOR EACH ROW
EXECUTE FUNCTION fix_playlist_collaborators();


--------------------------------------------------------------------------------
-- 6. VALIDATE TOUR DATE
-- Memastikan tanggal tour tidak di masa lalu
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validate_tour_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tour_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'Tour date (%s) shouldnt be before today (%s)', NEW.tour_date, CURRENT_DATE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_tour_date
BEFORE INSERT OR UPDATE ON tours
FOR EACH ROW
EXECUTE FUNCTION validate_tour_date();


--------------------------------------------------------------------------------
-- 7. UPDATE SONG RATING
-- Menghitung ulang rata-rata rating lagu di tabel songs
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_song_rating()
RETURNS TRIGGER AS $$
DECLARE
    v_new_rating NUMERIC(5,2);
BEGIN
    -- Hitung ulang rata-rata rating untuk song
    SELECT AVG(song_rating)
    INTO v_new_rating
    FROM rate_songs
    WHERE song_id = COALESCE(NEW.song_id, OLD.song_id);

    -- Update ke tabel songs
    UPDATE songs
    SET song_rating = v_new_rating
    WHERE song_id = COALESCE(NEW.song_id, OLD.song_id);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_song_rating
AFTER INSERT OR UPDATE OR DELETE ON rate_songs
FOR EACH ROW
EXECUTE FUNCTION update_song_rating();


--------------------------------------------------------------------------------
-- 8. UPDATE ARTIST FOLLOW COUNT
-- Menambah/mengurangi counter follower di tabel artists
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_artist_follow_count()
RETURNS TRIGGER AS $$
BEGIN
    -- FOLLOW -> INSERT
    IF TG_OP = 'INSERT' THEN
        UPDATE artists
        SET follower_count = COALESCE(follower_count, 0) + 1
        WHERE artist_id = NEW.artist_id;
    END IF;

    -- UNFOLLOW -> DELETE
    IF TG_OP = 'DELETE' THEN
        UPDATE artists
        SET follower_count = COALESCE(follower_count, 0) - 1
        WHERE artist_id = OLD.artist_id;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_artist_follow_count
AFTER INSERT OR DELETE ON follow_artists
FOR EACH ROW
EXECUTE FUNCTION update_artist_follow_count();


--------------------------------------------------------------------------------
-- 9. VALIDATE PRERELEASE DATE
-- Validasi logika tanggal rilis album (Prerelease vs Released)
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validate_prerelease_date()
RETURNS TRIGGER AS $$
BEGIN
    -- RULE 1: prerelease must be future
    IF NEW.isPrerelease = TRUE
       AND NEW.collection_release_date <= CURRENT_DATE THEN
        RAISE EXCEPTION
            'If isPrerelease = TRUE, then release_date (%s) must be in the future.',
            NEW.collection_release_date;
    END IF;

    -- RULE 2: NOT prerelease must be today or past
    IF NEW.isPrerelease = FALSE
       AND NEW.collection_release_date > CURRENT_DATE THEN
        RAISE EXCEPTION
            'If isPrerelease = FALSE, release_date (%s) cannot be in the future.',
            NEW.collection_release_date;
    END IF;

    -- RULE 3: If release date is today -> force prerelease = FALSE
    IF NEW.collection_release_date = CURRENT_DATE THEN
        NEW.isPrerelease := FALSE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_prerelease_date
BEFORE INSERT OR UPDATE ON collections
FOR EACH ROW
EXECUTE FUNCTION validate_prerelease_date();


--------------------------------------------------------------------------------
-- 10. UPDATE COLLECTION RATING
-- Menghitung ulang rata-rata rating collection berdasarkan review
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_collection_rating()
RETURNS TRIGGER AS $$
DECLARE
    v_new_rating NUMERIC(5,2);
BEGIN
    -- Hitung ulang rating dari seluruh review untuk collection
    SELECT AVG(rating)
    INTO v_new_rating
    FROM reviews
    WHERE collection_id = COALESCE(NEW.collection_id, OLD.collection_id);

    -- Update ke tabel collections
    UPDATE collections
    SET collection_rating = v_new_rating
    WHERE collection_id = COALESCE(NEW.collection_id, OLD.collection_id);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_collection_rating
AFTER INSERT OR UPDATE OR DELETE ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_collection_rating();