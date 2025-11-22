-- Trigger review collection, akan mengubah collection_rating
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

-- trigger perubahan rating insert review, update review, delete review
CREATE TRIGGER trg_update_collection_rating
AFTER INSERT OR UPDATE OR DELETE
ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_collection_rating();

SELECT * FROM reviews;

-- cek
-- insert collection_rating
INSERT INTO reviews (review, rating, review_id, user_id, collection_id)
VALUES ('bagussss', 5, 1, 10, 1);

SELECT collection_rating FROM collections WHERE collection_id = 1;

-- update collection_rating nya
UPDATE reviews
SET rating = 3
WHERE review_id = 1;

-- delete review
DELETE FROM reviews WHERE review_id = 1;



-- Trigger follow–unfollow artis
CREATE OR REPLACE FUNCTION update_artist_follow_count()
RETURNS TRIGGER AS $$
BEGIN
    -- FOLLOW → INSERT
    IF TG_OP = 'INSERT' THEN
        UPDATE artists
        SET follower_count = COALESCE(follower_count, 0) + 1
        WHERE artist_id = NEW.artist_id;
    END IF;

    -- UNFOLLOW → DELETE
    IF TG_OP = 'DELETE' THEN
        UPDATE artists
        SET follower_count = COALESCE(follower_count, 0) - 1
        WHERE artist_id = OLD.artist_id;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- trigger
CREATE TRIGGER trg_update_artist_follow_count
AFTER INSERT OR DELETE
ON follow_artists   
FOR EACH ROW
EXECUTE FUNCTION update_artist_follow_count();

-- cek
-- follow
INSERT INTO follow_artists (user_id, artist_id)
VALUES (9, 4);

INSERT INTO follow_artists (user_id, artist_id)
VALUES (10, 4);

-- unfollow
DELETE FROM follow_artists
WHERE user_id = 9 AND artist_id = 4;
DELETE FROM follow_artists

SELECT follower_count FROM artists WHERE artist_id = 4;

SELECT * FROM artists;

-- Function: Update user_id lagu ketika playlist tidak lagi collaborative
CREATE OR REPLACE FUNCTION fix_playlist_collaborators()
RETURNS TRIGGER AS $$
BEGIN
    -- Jika sebelumnya collaborative dan sekarang tidak collaborative
    IF OLD.iscollaborative = TRUE AND NEW.iscollaborative = FALSE THEN
        
        -- Update semua lagu yang ditambahkan oleh user lain
        UPDATE add_songs_playlists
        SET user_id = NEW.user_id
        WHERE playlist_id = NEW.playlist_id
        AND user_id <> NEW.user_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: berjalan ketika playlist di-update
CREATE TRIGGER trg_fix_playlist_collaborators
AFTER UPDATE OF iscollaborative
ON playlists
FOR EACH ROW
EXECUTE FUNCTION fix_playlist_collaborators();

-- cek 
-- Data sebelum/sesudah trigger bekerja
SELECT add_song_pl_id, user_id, playlist_id, song_id
FROM add_songs_playlists
WHERE playlist_id = 2

-- Ubah playlist collaborative --> tidak collab
UPDATE playlists
SET iscollaborative = false
WHERE playlist_id = 2;

SELECT * FROM PLAYLISTS;


-- FUNCTION untuk update timestamp saat review/rating berubah
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

-- TRIGGER
CREATE TRIGGER trg_update_review_timestamp
BEFORE UPDATE
ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_review_timestamp();

-- cek
-- tabel review
SELECT * FROM reviews;

-- update review timestamp
UPDATE reviews
SET review = 'Review baru test trigger'
WHERE review_id = 1;

-- update rating timestamp
UPDATE reviews
SET rating = rating + 1
WHERE review_id = 1;



-- FUNCTION: otomatis matikan prerelease saat tanggal rilis tiba
CREATE OR REPLACE FUNCTION prerelease_check_logic()
RETURNS TRIGGER AS $$
BEGIN
    -- Jika ini prerelease dan hari ini sudah sama dengan tanggal rilis
    IF NEW.isPrerelease = TRUE
       AND CURRENT_DATE = NEW.collection_release_date THEN
        
        NEW.isPrerelease := FALSE; 
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- TRIGGER: aktif sebelum INSERT / UPDATE
CREATE TRIGGER trg_prerelease_check
BEFORE INSERT OR UPDATE ON collections
FOR EACH ROW
EXECUTE FUNCTION prerelease_check_logic();

-- cek
-- case insert data yg tanggal rilis nya hari ini
INSERT INTO collections (
    collection_id, collection_title, collection_type,
    collection_cover, collection_release_date,
    collection_rating, isPrerelease
)
VALUES (
    999, 'Test Prerelease', 'Album',
    NULL, CURRENT_DATE, NULL, TRUE
);

SELECT collection_id, isPrerelease, collection_release_date
FROM collections
WHERE collection_id = 999;


-- case insert data tanggal rilis nya besok
INSERT INTO collections (
    collection_id, collection_title, collection_type,
    collection_cover, collection_release_date,
    collection_rating, isPrerelease
)
VALUES (
    1000, 'Test Tomorrow', 'Album',
    NULL, CURRENT_DATE + 1, NULL, TRUE
);

SELECT collection_id, isPrerelease, collection_release_date
FROM collections
WHERE collection_id = 1000;

-- update data pada hari rilis
UPDATE collections
SET collection_release_date = CURRENT_DATE,
    isPrerelease = true
WHERE collection_id = 1000;

SELECT collection_id, isPrerelease, collection_release_date
FROM collections
WHERE collection_id = 1000;