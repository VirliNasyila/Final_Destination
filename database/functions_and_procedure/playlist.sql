--  Procedure Create Playlist
CREATE OR REPLACE PROCEDURE create_playlist(
    p_user_id INT,
    p_title VARCHAR,
    p_ispublic BOOLEAN,
    p_iscollaborative BOOLEAN,
    p_description TEXT,
    p_cover VARCHAR,
    p_isonprofile BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
   INSERT INTO playlists (
       user_id,
       playlist_cover,
       playlist_title,
       ispublic,
       iscollaborative,
       playlist_desc,
       isonprofile,
       playlist_date_created
   )
   VALUES (
       p_user_id,
       p_cover,
       p_title,
       p_ispublic,
       p_iscollaborative,
       p_description,
       p_isonprofile,
       CURRENT_DATE
   );

   RAISE NOTICE 'Playlist created successfully.';
END;
$$;

-- CALL user_id, playlist_title, ispublic, iscollaborative, playlist_desc, playlist_cover, isonprofile
CALL create_playlist(5, 'cek procedure', true, false, 'Santai sore', 'cover.png', true);

-- cek 
SELECT *
FROM playlists;


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

-- cek (user_id, playlist_id, song_id)
CALL add_song_to_playlist(2, 10, 5);

SELECT *
FROM add_songs_playlists
WHERE playlist_id = 10
ORDER BY no_urut;


-- PROCEDURE remove_song_from_playlist
CREATE OR REPLACE PROCEDURE remove_song_from_playlist(
    p_playlist_id INT,  -- Parameter input: ID playlist yang ingin dihapus lagunya
    p_song_id INT  -- Parameter input: ID lagu yang ingin dihapus
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INT;  -- Variabel untuk mengecek apakah lagu ada di playlist
BEGIN
    -- Cek apakah lagu ada di playlist
    SELECT COUNT(*)
    INTO v_exists
    FROM add_songs_playlists
    WHERE playlist_id = p_playlist_id
      AND song_id = p_song_id;

    IF v_exists = 0 THEN
		-- Kalo lagu tidak ditemukan di playlist,
        RAISE EXCEPTION 'Lagu % tidak ditemukan di playlist %.', p_song_id, p_playlist_id;
    END IF;

    -- Hapus lagu dari playlist
    DELETE FROM add_songs_playlists
    WHERE playlist_id = p_playlist_id
      AND song_id = p_song_id;

    -- Perbaiki nomor urut (re-order) supaya urutan lagu tetap berurutan
    WITH ordered AS (
        SELECT 
            add_song_pl_id,  -- Ambil ID record
            ROW_NUMBER() OVER (ORDER BY no_urut) AS new_no  -- Hitung nomor urut baru
        FROM add_songs_playlists
        WHERE playlist_id = p_playlist_id  -- Hanya untuk playlist yang sama
    )
    UPDATE add_songs_playlists asp
    SET no_urut = o.new_no  -- Update no_urut sesuai urutan baru
    FROM ordered o
    WHERE asp.add_song_pl_id = o.add_song_pl_id;  -- Cocokin dengan ID record nya

END;
$$;

-- hapus lagu (song_id 30) dari playlist 10
CALL remove_song_from_playlist(10, 30);

-- cek hasil
SELECT *
FROM add_songs_playlists
WHERE playlist_id = 10
ORDER BY no_urut;


-- Function: get_playlist_detail
CREATE OR REPLACE FUNCTION get_playlist_detail(p_playlist_id INT)
RETURNS TABLE (
    playlist_id INT,
    playlist_title VARCHAR,
    playlist_cover VARCHAR,
    playlist_desc TEXT,
    song_no INT,
    song_id INT,
    song_title VARCHAR,
    song_duration INT,
    added_by_username VARCHAR
)
AS $$
BEGIN
	-- Ambil data playlist + daftar lagu + siapa yang menambahkan lagu
    RETURN QUERY
    SELECT 
        p.playlist_id,
        p.playlist_title,
        p.playlist_cover,
        p.playlist_desc,
        asp.no_urut AS song_no,  -- nomor urut lagu di playlist
        s.song_id,
        s.song_title,
        s.song_duration,
        u.username AS added_by_username -- username yang menambahkan lagu
    FROM PLAYLISTS p
	-- Join ke tabel add_songs_playlists untuk mendapatkan daftar lagu yang ada di playlist
    JOIN ADD_SONGS_PLAYLISTS asp ON p.playlist_id = asp.playlist_id 
    JOIN SONGS s ON asp.song_id = s.song_id  -- Join ke tabel songs untuk mengambil detail lagu
    JOIN USERS u ON asp.user_id = u.user_id  -- Join ke tabel users untuk mengetahui siapa yang nambahin lagu
    WHERE p.playlist_id = p_playlist_id  -- Filter hanya playlist yang sesuai dengan parameter input
    ORDER BY asp.no_urut; -- urutkan lagu sesuai nomor urut
END;
$$ LANGUAGE plpgsql;

-- cek detail playlist id 1
SELECT * FROM get_playlist_detail(1);


-- Function: get_playlist_tracks
CREATE OR REPLACE FUNCTION get_playlist_tracks(p_playlist_id INT)
RETURNS TABLE (
    song_no INT,
    song_id INT,
    song_title VARCHAR,
    song_duration INT,
    collection_id INT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        asp.no_urut AS song_no, -- nomor urut lagu di playlist
        s.song_id,
        s.song_title,
        s.song_duration,
        cs.collection_id   -- null jika lagu tidak ada di collection
    FROM ADD_SONGS_PLAYLISTS asp  -- Ambil tabel lagu yang ditambahkan ke playlist (alias asp)
    JOIN SONGS s ON asp.song_id = s.song_id
    LEFT JOIN COLLECTIONS_SONGS cs ON s.song_id = cs.song_id -- cek lagu di collection mana
    WHERE asp.playlist_id = p_playlist_id  -- ambil lagu dari playlist tertentu
    ORDER BY asp.no_urut;  -- Urut sesuai nomor urut di playlist
END;
$$ LANGUAGE plpgsql;

-- cek lihat lagu-lagu di playlist dengan ID = 1
SELECT * 
FROM get_playlist_tracks(1);



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