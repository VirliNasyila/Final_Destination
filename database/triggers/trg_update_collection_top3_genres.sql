-- Update_collection_top3_genres
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


-- trigger
CREATE TRIGGER trg_update_collection_top3_genres
AFTER INSERT OR UPDATE ON collections_songs
FOR EACH ROW
EXECUTE FUNCTION update_collection_top3_genres();


-- SELECT * FROM collections_songs;
-- -- cek
-- -- Update supaya trigger jalan
-- UPDATE collections_songs
-- SET nomor_track = nomor_track
-- WHERE collection_id = 1;

-- UPDATE collections_songs
-- SET nomor_track = nomor_track
-- WHERE collection_id = 2;

-- -- Lihat hasil top 3 genre
-- SELECT * FROM collection_top_3_genres
-- WHERE collection_id = 1;

-- SELECT * FROM collection_top_3_genres
-- WHERE collection_id = 2;

-- SELECT * FROM collection_top_3_genres;
