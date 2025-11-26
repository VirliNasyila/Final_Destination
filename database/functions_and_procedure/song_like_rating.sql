-- Function get_song_detail
CREATE OR REPLACE FUNCTION get_song_detail(p_song_id INT)
RETURNS TABLE (
    song_id INT,
    song_title VARCHAR,
    song_duration INT,
    song_release_date DATE,
    song_rating NUMERIC,
    artist_name VARCHAR,
    genre_name VARCHAR,
    collection_title VARCHAR,
    nomor_disc INT,
    nomor_track INT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        -- Ambil ID lagu, judul lagu, durasi lagu, tanggal rilis lagu, rating lagu
        s.song_id,
        s.song_title,
        s.song_duration,
        s.song_release_date,
        s.song_rating,

        a.artist_name,                -- artis dari CREATE_SONGS)
        g.genre_name,                 -- genre lagu dari SONGS_GENRES)
        c.collection_title,           -- dari collection
        cs.nomor_disc,                -- nomor disc lagu dalam collection
        cs.nomor_track                -- nomor track lagu dalam collection

    FROM SONGS s

    -- ARTIST
    LEFT JOIN CREATE_SONGS cr ON s.song_id = cr.song_id  -- Join untuk dapat artist_id dari CREATE_SONGS
    LEFT JOIN ARTISTS a ON cr.artist_id = a.artist_id

    -- GENRE 
    LEFT JOIN SONGS_GENRES sg ON s.song_id = sg.song_id
    LEFT JOIN GENRES g ON sg.genre_id = g.genre_id

    -- COLLECTION / ALBUM
    LEFT JOIN COLLECTIONS_SONGS cs ON s.song_id = cs.song_id
    LEFT JOIN COLLECTIONS c ON cs.collection_id = c.collection_id

    WHERE s.song_id = p_song_id;   -- Filter hanya lagu dengan ID sesuai parameter
END;
$$ LANGUAGE plpgsql;

-- PROCEDURE toggle_like_song
CREATE OR REPLACE PROCEDURE toggle_like_song( 
    p_user_id INT, -- Parameter input: ID user yang ingin like/unlike lagu
    p_song_id INT  -- Parameter input: ID lagu yang ingin di like/unlike
) 
LANGUAGE plpgsql 
AS $$ 
DECLARE 
    v_exists INT;  -- Variabel untuk mengecek record like_songs sudah ada apa belum
BEGIN 
    -- 1. Cek apakah user ada 
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN 
        RAISE EXCEPTION 'User dengan ID % tidak ditemukan', p_user_id; 
    END IF; 

    -- 2. Cek apakah lagu ada 
    IF NOT EXISTS (SELECT 1 FROM songs WHERE song_id = p_song_id) THEN 
        RAISE EXCEPTION 'Song dengan ID % tidak ditemukan', p_song_id; 
    END IF; 
	
    -- 3. Cek apakah sudah like 
    SELECT COUNT(*) INTO v_exists 
    FROM like_songs 
    WHERE user_id = p_user_id 
      AND song_id = p_song_id; 
    -- 4. Jika sudah LIKE → UNLIKE 
    IF v_exists > 0 THEN 
        DELETE FROM like_songs  -- Hapus record like (unlike)
        WHERE user_id = p_user_id 
          AND song_id = p_song_id; 
        RAISE NOTICE 'UNLIKE berhasil untuk song_id=% oleh user_id=%', 
            p_song_id, p_user_id; 
    -- 5. Jika belum LIKE → LIKE 
    ELSE 
        INSERT INTO like_songs (song_id, user_id)  -- Tambah record like baru
        VALUES (p_song_id, p_user_id); 
        RAISE NOTICE 'LIKE berhasil untuk song_id=% oleh user_id=%', 
            p_song_id, p_user_id; 
    END IF; 
END; 
$$; 

-- cek like
CALL toggle_like_song(1,10);

-- cek hasil 
SELECT * FROM like_songs WHERE user_id = 1 AND song_id = 10;

-- cek unlike
CALL toggle_like_song(1,10);

-- PROCEDURE rate_song
CREATE OR REPLACE PROCEDURE rate_song( 
    p_user_id INT,  -- Parameter input: ID user yang memberi rating
    p_song_id INT,  -- Parameter input: ID lagu yang dirating
    p_rating NUMERIC  -- Parameter input: nilai rating lagu
) 
LANGUAGE plpgsql 
AS $$ 
BEGIN 
    -- Cek apakah user sudah pernah memberi rating 
    IF EXISTS ( 
        SELECT 1 FROM rate_songs 
        WHERE user_id = p_user_id 
          AND song_id = p_song_id 
    ) THEN 
        -- Kalo sudah ada rating → update rating lama dan timestamp 
        UPDATE rate_songs 
        SET song_rating = p_rating,  -- Set rating baru
            "TIMESTAMP" = CURRENT_TIMESTAMP  -- Update waktu rating terakhir
        WHERE user_id = p_user_id 
          AND song_id = p_song_id;  -- update record user & lagu
    ELSE 
        -- Jika belum ada rating → insert rating baru
        INSERT INTO rate_songs (user_id, song_id, song_rating) 
        VALUES (p_user_id, p_song_id, p_rating);   -- Masukkan record baru
    END IF; 
END; 
$$;

-- cek 
SELECT * FROM RATE_SONGS;

-- Cek insert rating
CALL rate_song(1,10,5);

-- cek 
SELECT * FROM RATE_SONGS;

-- update rating
CALL rate_song(1, 10, 3);

-- cek hasil 
SELECT * FROM RATE_SONGS WHERE song_id = 10;


-- Function get_song_audio_features
-- Deskripsi: Mengambil fitur audio dari sebuah lagu
-- Input: p_song_id (INT) -> ID lagu yang ingin diambil fiturnya
-- Output: Tabel berisi song_id, song_title, valence, accousticness, danceability, energy
CREATE OR REPLACE FUNCTION get_song_audio_features(p_song_id INT)
RETURNS TABLE (
    song_id INT,                -- ID lagu
    song_title VARCHAR,          -- Judul lagu
    valence DECIMAL(4,3),       -- Valence lagu
    acousticness DECIMAL(4,3),  -- Acousticness lagu
    danceability DECIMAL(4,3),  -- Danceability lagu
    energy DECIMAL(4,3)         -- Energy lagu
) AS $$
BEGIN
    -- Mengambil data audio features dari tabel SONGS berdasarkan song_id
    RETURN QUERY
    SELECT 
        s.song_id,
        s.song_title,
        s.valence,  -- seberapa “positif/ceria”
        s.accousticness,   -- seberapa akustik
        s.danceability, -- dance 
        s.energy -- seberapa enejik
    FROM songs s
    WHERE s.song_id = p_song_id;

    -- Jika song_id tidak ada, hasilnya akan kosong
END;
$$ LANGUAGE plpgsql;

-- cek
-- coba panggil funciton dengan song_id
SELECT * FROM get_song_audio_features(3);  

-- cek song_id nya yg gak ada di data
SELECT * FROM get_song_audio_features(500);  

