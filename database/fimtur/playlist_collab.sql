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

SELECT * FROM playlists
WHERE playlist_id = 10;

-- Procedure add_song_to_playlist
CREATE OR REPLACE PROCEDURE add_song_to_playlist(
    p_user_id INT,  -- Parameter input: ID user yang ingin menambahkan lagu
    p_playlist_id INT,  -- Parameter input: ID playlist tujuan
    p_song_id INT  -- Parameter input: ID lagu yang ingin ditambahkan
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_owner_id INT;  -- Variabel untuk menyimpan ID pemilik playlist
    v_is_collab BOOLEAN;
    v_exists INT;  -- Variabel untuk mengecek apakah lagu sudah ada di playlist
    v_last_no_urut INT; -- Variabel untuk menentukan nomor urut lagu terakhir
BEGIN
    -- Cek apakah playlist ada
    SELECT user_id, isCollaborative
    INTO v_owner_id, v_is_collab
    FROM playlists
    WHERE playlist_id = p_playlist_id;

    IF NOT FOUND THEN
	-- Kalo playlist tidak ditemukan,
        RAISE EXCEPTION 'Playlist % tidak ditemukan.', p_playlist_id;
    END IF;

    -- Cek duplikasi lagu
    SELECT COUNT(*)
    INTO v_exists
    FROM add_songs_playlists
    WHERE playlist_id = p_playlist_id
      AND song_id = p_song_id;

    IF v_exists > 0 THEN
	-- Kalo lagu sudah ada di playlist,
        RAISE EXCEPTION 'Lagu % sudah ada di playlist %.', p_song_id, p_playlist_id;
    END IF;

    -- Cek kepemilikan playlist (non-collaborative)
    IF v_is_collab = FALSE AND p_user_id <> v_owner_id THEN
        RAISE EXCEPTION 
            'Playlist ini non-collaborative. Hanya pemilik (user_id = %) yang dapat menambahkan lagu.',
            v_owner_id;
    END IF;

    -- Hitung nomor urut otomatis
    SELECT COALESCE(MAX(no_urut), 0)
    INTO v_last_no_urut
    FROM add_songs_playlists
    WHERE playlist_id = p_playlist_id;

    v_last_no_urut := v_last_no_urut + 1;  -- Tambah 1 untuk nomor urut lagu baru

    -- Insert lagu ke playlist
    INSERT INTO add_songs_playlists (
        user_id,
        playlist_id,
        song_id,
        no_urut
    ) VALUES (
        p_user_id,
        p_playlist_id,
        p_song_id,
        v_last_no_urut
    );

END;
$$;

SELECT * FROM playlists
WHERE playlist_id = 10;

-- set true iscollaborative
UPDATE playlists SET iscollaborative = TRUE
WHERE playlist_id = 10;


CALL add_song_to_playlist(2, 10, 5);
-- cek
SELECT * FROM add_songs_playlists WHERE playlist_id = 10;

-- set false iscollaborativenya
UPDATE playlists SET iscollaborative = FALSE WHERE playlist_id = 10;

-- cek lagi
SELECT * FROM add_songs_playlists WHERE playlist_id = 10;


