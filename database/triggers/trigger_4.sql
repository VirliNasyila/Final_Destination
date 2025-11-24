
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