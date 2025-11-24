

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