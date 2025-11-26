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

-- -- cek
-- -- Data sebelum/sesudah trigger bekerja
-- SELECT add_song_pl_id, user_id, playlist_id, song_id
-- FROM add_songs_playlists
-- WHERE playlist_id = 2

-- -- Ubah playlist collaborative --> tidak collab
-- UPDATE playlists
-- SET iscollaborative = false
-- WHERE playlist_id = 2;

-- SELECT * FROM PLAYLISTS;
