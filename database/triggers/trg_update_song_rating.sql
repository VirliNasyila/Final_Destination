-- Update song rating
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


-- Trigger
CREATE TRIGGER trg_update_song_rating
AFTER INSERT OR UPDATE OR DELETE
ON rate_songs
FOR EACH ROW
EXECUTE FUNCTION update_song_rating();


-- SELECT * FROM songs;
-- -- cek
-- -- Insert rating baru
-- INSERT INTO rate_songs (user_id, song_id, song_rating)
-- VALUES (2, 2, 4);

-- -- Update rating song
-- UPDATE rate_songs
-- SET song_rating = 5
-- WHERE user_id = 2 AND song_id = 2;

-- -- Update rating song
-- UPDATE rate_songs
-- SET song_rating = 5
-- WHERE user_id = 3 AND song_id = 2;

-- -- Insert baru
-- INSERT INTO rate_songs (user_id, song_id, song_rating)
-- VALUES (3, 2, 3);

-- -- Delete
-- DELETE FROM rate_songs
-- WHERE user_id = 2 AND song_id = 2;

-- SELECT song_id, song_rating FROM songs WHERE song_id = 2;
