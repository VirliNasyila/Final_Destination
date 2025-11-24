
-- Trigger
CREATE TRIGGER trg_update_song_rating
AFTER INSERT OR UPDATE OR DELETE
ON rate_songs
FOR EACH ROW
EXECUTE FUNCTION update_song_rating();


SELECT * FROM songs;
-- cek 
-- Insert rating baru
INSERT INTO rate_songs (user_id, song_id, song_rating)
VALUES (2, 2, 4);

-- Update rating song
UPDATE rate_songs
SET song_rating = 5
WHERE user_id = 2 AND song_id = 2;

-- Update rating song
UPDATE rate_songs
SET song_rating = 5
WHERE user_id = 3 AND song_id = 2;

-- Insert baru
INSERT INTO rate_songs (user_id, song_id, song_rating) 
VALUES (3, 2, 3);

-- Delete
DELETE FROM rate_songs
WHERE user_id = 2 AND song_id = 2;

SELECT song_id, song_rating FROM songs WHERE song_id = 2;


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