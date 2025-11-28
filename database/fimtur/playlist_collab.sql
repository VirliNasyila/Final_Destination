CREATE OR REPLACE FUNCTION fix_playlist_collaborators()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.iscollaborative = TRUE AND NEW.iscollaborative = FALSE THEN

        UPDATE add_songs_playlists
        SET user_id = NEW.user_id 
        WHERE playlist_id = NEW.playlist_id
        AND user_id <> NEW.user_id; -- Hanya ubah punya orang lain
        
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_fix_playlist_collaborators
AFTER UPDATE OF iscollaborative ON playlists
FOR EACH ROW
EXECUTE FUNCTION fix_playlist_collaborators();

-- function buat cek owner playlist 
CREATE OR REPLACE FUNCTION get_user_created_playlists(p_user_id INT)
RETURNS TABLE (
    id INT,
    title VARCHAR,
    privacy VARCHAR,
    total_tracks BIGINT
) 
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.playlist_id,
        p.playlist_title,
        (CASE WHEN p.ispublic THEN 'Public' ELSE 'Private' END)::VARCHAR,
        COUNT(asp.song_id)
    FROM playlists p
    LEFT JOIN add_songs_playlists asp ON p.playlist_id = asp.playlist_id
    WHERE p.user_id = p_user_id
    GROUP BY p.playlist_id
    ORDER BY p.playlist_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM playlists
WHERE playlist_id = 10;

SELECT * FROM get_user_created_playlists(6);

-- set true iscollaborative
UPDATE playlists SET iscollaborative = TRUE
WHERE playlist_id = 10;

-- coba insert lagu 
INSERT INTO add_songs_playlists (playlist_id, song_id, user_id, no_urut)
VALUES (10, 55, 2, 1); 

INSERT INTO add_songs_playlists (playlist_id, song_id, user_id, no_urut)
VALUES (10, 52, 2, 1); 


-- cek
SELECT * FROM add_songs_playlists WHERE playlist_id = 10;

-- set false iscollaborativenya
UPDATE playlists SET iscollaborative = FALSE WHERE playlist_id = 10;

-- cek lagi
SELECT * FROM add_songs_playlists WHERE playlist_id = 10;



