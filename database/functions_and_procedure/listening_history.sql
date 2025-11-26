--  PROCEDURE log_listen
CREATE OR REPLACE PROCEDURE log_listen(
    p_user_id INT,  -- Parameter input: ID user yang mendengarkan lagu, ID lagu yang didengarkan, durasi lagu yang didengarkan (dalam detik)
    p_song_id INT,
    p_duration INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists_listen INT;  -- Variabel untuk menyimpan jumlah record listens yang sudah ada untuk user & song
BEGIN
    -- VALIDASI USER
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User % tidak ditemukan', p_user_id;
    END IF;

    -- VALIDASI SONG
    IF NOT EXISTS (SELECT 1 FROM songs WHERE song_id = p_song_id) THEN
        RAISE EXCEPTION 'Song % tidak ditemukan', p_song_id;
    END IF;

    -- VALIDASI DURASI
    IF p_duration <= 0 THEN
        RAISE EXCEPTION 'Duration harus > 0';
    END IF;

    -- CEK APAKAH USER SUDAH PERNAH MENDENGARKAN LAGU INI
    SELECT COUNT(*)  -- Hitung jumlah record listens untuk user & song
    INTO v_exists_listen   -- Simpan hasil hitungan ke variabel v_exists_listen
    FROM listens
    WHERE user_id = p_user_id
      AND song_id = p_song_id;

    -- INSERT LISTEN BARU  → listen_count + 1
    IF v_exists_listen = 0 THEN  -- Jika user belum pernah mendengarkan lagu ini
        
        INSERT INTO listens (listen_id, user_id, song_id, duration_listened)
        VALUES (
            (SELECT COALESCE(MAX(listen_id), 0) + 1 FROM listens),  -- akan generate listen_id baru secara increment
            p_user_id,
            p_song_id,
            p_duration
        );

        -- TAMBAH COUNTER LISTEN HANYA UNTUK INSERT
        UPDATE songs
        SET listen_count = COALESCE(listen_count, 0) + 1   -- Increment listen_count lagu
        WHERE song_id = p_song_id;

    -- UPDATE LISTEN LAMA → TIDAK MENAMBAH COUNTER
    ELSE
        
        UPDATE listens
        SET duration_listened = p_duration,  -- Update durasi terakhir mendengarkan
            "TIMESTAMP" = CURRENT_TIMESTAMP  -- Update timestamp terakhir
        WHERE user_id = p_user_id
          AND song_id = p_song_id;

    END IF;

END;
$$;


-- Funtion get_recently_played
CREATE OR REPLACE FUNCTION get_recently_played(
    p_user_id INT,    -- Parameter input ID user
    p_limit INT DEFAULT 10 -- Limit jumlah hasil yang ditampilkan
)
RETURNS TABLE (
    song_id INT,  -- Mengambil ID lagu dari tabel songs
    song_title VARCHAR,   -- Mengambil judul lagu dari tabel songs
    duration_listened INT,  -- Durasi mendengarkan dalam bentuk detik
    last_play TIMESTAMP  -- Timestamp kapan lagu diputar
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.song_id,
        s.song_title,
        l.duration_listened, -- dalam detik 
        l."TIMESTAMP" AS last_play 
    FROM listens l
    JOIN songs s ON s.song_id = l.song_id  -- Join tabel listens dengan songs berdasarkan song_id
    WHERE l.user_id = p_user_id   -- Memfilter hanya record yang sesuai user yang diminta
    ORDER BY l."TIMESTAMP" DESC  -- Mengurutkan dari pemutaran terbaru
    LIMIT p_limit;  -- Membatasi jumlah record sesuai parameter p_limit
END;
$$;