--
-- PostgreSQL database dump
--

\restrict nmLYIEM71PRun2S6QvZ1VFwOQqZzgscfG4Z3mzcWCsh6ZF9xyaYFjN84fxAzhv6

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-12-05 11:57:09 WIB

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 28246)
-- Name: pg_cron; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA pg_catalog;


--
-- TOC entry 3957 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_cron; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_cron IS 'Job scheduler for PostgreSQL';


--
-- TOC entry 8 (class 2615 OID 31309)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3958 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 3 (class 3079 OID 31930)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 3960 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 355 (class 1255 OID 32149)
-- Name: add_artist_promotion(integer, integer, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_artist_promotion(IN p_artist_id integer, IN p_collection_id integer, IN p_comment text)
    LANGUAGE plpgsql
    AS $$
BEGIN

    -- cek artist valid
    IF NOT EXISTS (SELECT 1 FROM artists WHERE artist_id = p_artist_id) THEN
        RAISE EXCEPTION 'Artist_id % not found', p_artist_id;
    END IF;

    -- cek collection ada
    IF NOT EXISTS (SELECT 1 FROM collections WHERE collection_id = p_collection_id) THEN
        RAISE EXCEPTION 'Collection_id % not found', p_collection_id;
    END IF;

    --validasi, apakah koleksi ini dirilis oleh artis tersebut?
    IF NOT EXISTS (SELECT 1 FROM releases WHERE artist_id = p_artist_id
        AND collection_id = p_collection_id
    ) THEN
        RAISE EXCEPTION 'Artist % cannot promote collection %, because it does not belong to them',
            p_artist_id, p_collection_id;
    END IF;

    --jika sudah pernah promosi -> update komentar
    IF EXISTS (SELECT 1 FROM artist_promotion WHERE artist_id = p_artist_id
        AND collection_id = p_collection_id
    ) THEN
        UPDATE artist_promotion SET komentar_promosi = p_comment WHERE artist_id = p_artist_id
        AND collection_id = p_collection_id;

        RAISE NOTICE 'Promotion updated successfully';
        RETURN;
    END IF;

    --jika belum -> insert baru
    INSERT INTO artist_promotion(artist_id, collection_id, komentar_promosi)
    VALUES (p_artist_id, p_collection_id, p_comment);
    RAISE NOTICE 'Promotion added successfully';
END;
$$;


ALTER PROCEDURE public.add_artist_promotion(IN p_artist_id integer, IN p_collection_id integer, IN p_comment text) OWNER TO postgres;

--
-- TOC entry 351 (class 1255 OID 32145)
-- Name: add_song_to_playlist(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_song_to_playlist(IN p_user_id integer, IN p_playlist_id integer, IN p_song_id integer)
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


ALTER PROCEDURE public.add_song_to_playlist(IN p_user_id integer, IN p_playlist_id integer, IN p_song_id integer) OWNER TO postgres;

--
-- TOC entry 350 (class 1255 OID 32144)
-- Name: create_playlist(integer, character varying, boolean, boolean, text, character varying, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.create_playlist(IN p_user_id integer, IN p_title character varying, IN p_ispublic boolean, IN p_iscollaborative boolean, IN p_description text, IN p_cover character varying, IN p_isonprofile boolean)
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


ALTER PROCEDURE public.create_playlist(IN p_user_id integer, IN p_title character varying, IN p_ispublic boolean, IN p_iscollaborative boolean, IN p_description text, IN p_cover character varying, IN p_isonprofile boolean) OWNER TO postgres;

--
-- TOC entry 357 (class 1255 OID 32151)
-- Name: create_review(text, numeric, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.create_review(IN p_review_text text, IN p_rating numeric, IN p_user_id integer, IN p_collection_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_review_id INT;
BEGIN
    -- cek user
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User_id % not found', p_user_id;
    END IF;

    -- cek collection
    IF NOT EXISTS (SELECT 1 FROM collections WHERE collection_id = p_collection_id) THEN
        RAISE EXCEPTION 'Collection_id % not found', p_collection_id;
    END IF;

    -- cek review kosong
    IF p_review_text IS NULL OR LENGTH(TRIM(p_review_text)) = 0 THEN
        RAISE EXCEPTION 'Review text cannot be empty';
    END IF;

    -- cek apakah user sudah review koleksi ini
    IF EXISTS (SELECT 1 FROM reviews WHERE user_id = p_user_id
		AND collection_id = p_collection_id
    ) THEN
        RAISE EXCEPTION 'User has already reviewed this collection';
    END IF;

    -- ambil review_id dari sequence
    SELECT NEXTVAL('seq_reviews_id')
    INTO v_review_id;

    -- insert review (trigger akan update timestamp jika review diganti)
    INSERT INTO reviews(review, rating, "TIMESTAMP", review_id, user_id, collection_id)
    VALUES (p_review_text, p_rating, CURRENT_TIMESTAMP, v_review_id, p_user_id, p_collection_id);

    RAISE NOTICE 'Review created with ID %', v_review_id;
END;
$$;


ALTER PROCEDURE public.create_review(IN p_review_text text, IN p_rating numeric, IN p_user_id integer, IN p_collection_id integer) OWNER TO postgres;

--
-- TOC entry 336 (class 1255 OID 32163)
-- Name: delete_expired_tours(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_expired_tours() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM tours
    WHERE tour_date < CURRENT_DATE;
END;
$$;


ALTER FUNCTION public.delete_expired_tours() OWNER TO postgres;

--
-- TOC entry 305 (class 1255 OID 31924)
-- Name: enforce_block_logic(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.enforce_block_logic() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Hapus hubungan follow kedua arah
    DELETE FROM follow_users
    WHERE (follower_id = NEW.blocker_id AND followed_id = NEW.blocked_id)
       OR (follower_id = NEW.blocked_id AND followed_id = NEW.blocker_id);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.enforce_block_logic() OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 31910)
-- Name: fix_playlist_collaborators(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fix_playlist_collaborators() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.fix_playlist_collaborators() OWNER TO postgres;

--
-- TOC entry 342 (class 1255 OID 32136)
-- Name: get_album_total_duration(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_album_total_duration(p_collection_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_total_seconds INT;
BEGIN
    -- Aggregation: SUM (Menjumlahkan nilai durasi)
    SELECT SUM(s.song_duration)
    INTO v_total_seconds
    FROM collections_songs cs
    JOIN songs s ON cs.song_id = s.song_id
    WHERE cs.collection_id = p_collection_id;

    RETURN COALESCE(v_total_seconds, 0);
END;
$$;


ALTER FUNCTION public.get_album_total_duration(p_collection_id integer) OWNER TO postgres;

--
-- TOC entry 335 (class 1255 OID 32131)
-- Name: get_artist_content(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_artist_content(p_artist_id integer, p_type text) RETURNS TABLE(content_type text, content_id integer, title text, extra_info text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- ========== SONGS ==========
    IF p_type = 'songs' THEN
        RETURN QUERY
        SELECT
            'song',
            v.song_id,
            v.song_title ::TEXT,
            'Album: ' || COALESCE(v.album_name, '-') || ' • Popularity: ' || v.popularity
        FROM view_full_song_details v
        WHERE v.artist_name ILIKE (
            SELECT '%' || artist_name || '%'
            FROM artists WHERE artist_id = p_artist_id
        )
        ORDER BY v.popularity DESC;

    -- ========== COLLECTIONS ==========
    ELSIF p_type = 'collections' THEN
        RETURN QUERY
        SELECT
            'collection',
            c.collection_id,
            c.collection_title ::TEXT,
            c.collection_type ::TEXT
        FROM releases r
        JOIN collections c ON c.collection_id = r.collection_id
        WHERE r.artist_id = p_artist_id;

    -- ========== TOURS ==========
    ELSIF p_type = 'tours' THEN
        RETURN QUERY
        SELECT
            'tour',
            t.tour_id,
            t.tour_name ::TEXT,
            t.venue || ' • ' || t.tour_date
        FROM artists_tours at
        JOIN tours t ON t.tour_id = at.tour_id
        WHERE at.artist_id = p_artist_id;

    -- ========== PROMOTIONS ==========
    ELSIF p_type = 'promotions' THEN
        RETURN QUERY
        SELECT
            'promotion',
            ap.collection_id,
            c.collection_title ::TEXT,
            ap.komentar_promosi
        FROM artist_promotion ap
        LEFT JOIN collections c ON c.collection_id = ap.collection_id
        WHERE ap.artist_id = p_artist_id;

    ELSE
        RAISE EXCEPTION 'Invalid type: %, valid types: songs, collections, tours, promotions', p_type;
    END IF;

END;
$$;


ALTER FUNCTION public.get_artist_content(p_artist_id integer, p_type text) OWNER TO postgres;

--
-- TOC entry 334 (class 1255 OID 32130)
-- Name: get_artist_detail(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_artist_detail(p_artist_id integer) RETURNS TABLE(artist_id integer, artist_name character varying, bio text, artist_pfp character varying, banner character varying, artist_email character varying, monthly_listener_count bigint, follower_count bigint, total_albums bigint, total_tracks bigint)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM view_artist_profile_header v WHERE v.artist_id = p_artist_id;
END;
$$;


ALTER FUNCTION public.get_artist_detail(p_artist_id integer) OWNER TO postgres;

--
-- TOC entry 341 (class 1255 OID 32135)
-- Name: get_artist_total_plays(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_artist_total_plays(p_artist_id integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_total_plays BIGINT;
BEGIN
    SELECT COUNT(l.listen_id)
    INTO v_total_plays
    FROM create_songs cs
    JOIN listens l ON cs.song_id = l.song_id
    WHERE cs.artist_id = p_artist_id;

    RETURN COALESCE(v_total_plays, 0);
END;
$$;


ALTER FUNCTION public.get_artist_total_plays(p_artist_id integer) OWNER TO postgres;

--
-- TOC entry 356 (class 1255 OID 32150)
-- Name: get_artist_tours(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_artist_tours(p_artist_id integer) RETURNS TABLE(tour_id integer, tour_name text, venue text, tour_date date)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.tour_id,
        t.tour_name ::TEXT,
        t.venue ::TEXT,
        t.tour_date
    FROM artists_tours at
    JOIN tours t ON t.tour_id = at.tour_id
    WHERE at.artist_id = p_artist_id
    ORDER BY t.tour_date ASC;
END;
$$;


ALTER FUNCTION public.get_artist_tours(p_artist_id integer) OWNER TO postgres;

--
-- TOC entry 344 (class 1255 OID 32138)
-- Name: get_collection_average_rating(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_collection_average_rating(p_collection_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_rating NUMERIC;
BEGIN
    -- Mengambil nilai yang sudah dihitung oleh trigger
    SELECT COLLECTION_RATING
    INTO v_rating
    FROM COLLECTIONS
    WHERE COLLECTION_ID = p_collection_id;

    RETURN COALESCE(v_rating, 0);
END;
$$;


ALTER FUNCTION public.get_collection_average_rating(p_collection_id integer) OWNER TO postgres;

--
-- TOC entry 345 (class 1255 OID 32139)
-- Name: get_collection_detail(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_collection_detail(p_collection_id integer) RETURNS TABLE(collection_id integer, collection_title text, collection_type text, collection_cover text, release_date date, rating numeric, is_prerelease boolean, total_tracks bigint, total_artists bigint)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.collection_id,
        c.collection_title ::TEXT,
        c.collection_type ::TEXT,
        c.collection_cover ::TEXT,
        c.collection_release_date,
        c.collection_rating,
        c.isprerelease,
        (SELECT COUNT(*) FROM collections_songs cs 
         WHERE cs.collection_id = c.collection_id) AS total_tracks,
        (SELECT COUNT(DISTINCT r.artist_id)
         FROM releases r
         WHERE r.collection_id = c.collection_id) AS total_artists
    FROM collections c
    WHERE c.collection_id = p_collection_id;
END;
$$;


ALTER FUNCTION public.get_collection_detail(p_collection_id integer) OWNER TO postgres;

--
-- TOC entry 343 (class 1255 OID 32137)
-- Name: get_collection_genres(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_collection_genres(p_collection_id integer) RETURNS TABLE(genre_id integer, genre_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        g.genre_id,
        g.genre_name
    FROM COLLECTION_TOP_3_GENRES ct3g
    JOIN GENRES g ON g.genre_id = ct3g.genre_id
    WHERE ct3g.collection_id = p_collection_id;
END;
$$;


ALTER FUNCTION public.get_collection_genres(p_collection_id integer) OWNER TO postgres;

--
-- TOC entry 346 (class 1255 OID 32140)
-- Name: get_collection_tracks(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_collection_tracks(p_collection_id integer) RETURNS TABLE(track_number integer, song_id integer, song_title text, artist_name text, duration integer, popularity numeric, song_file text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        cs.nomor_track,
        v.song_id,
        v.song_title ::TEXT,
        v.artist_name ::TEXT,
        v.song_duration,
        v.popularity,
        v.song_file ::TEXT
    FROM collections_songs cs
    JOIN view_full_song_details v ON v.song_id = cs.song_id
    WHERE cs.collection_id = p_collection_id
    ORDER BY cs.nomor_disc, cs.nomor_track;
END;
$$;


ALTER FUNCTION public.get_collection_tracks(p_collection_id integer) OWNER TO postgres;

--
-- TOC entry 367 (class 1255 OID 32161)
-- Name: get_followers(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_followers(p_user_id integer) RETURNS TABLE(follower_id integer, follower_username character varying, follower_email character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT u.user_id, u.username, u. user_email
    FROM follow_users
    JOIN users u ON fu.follower_id = u.user_id
    WHERE fu.followed_id = p_user_id
    ORDER BY u.username;
END;
$$;


ALTER FUNCTION public.get_followers(p_user_id integer) OWNER TO postgres;

--
-- TOC entry 368 (class 1255 OID 32162)
-- Name: get_following(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_following(p_user_id integer) RETURNS TABLE(following_id integer, following_username character varying, following_email character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT u.user_id, u.username, u. user_email
    FROM follow_users
    JOIN users u ON fu.followed_id = u.user_id
    WHERE fu.follower_id = p_user_id
    ORDER BY u.username;
END;
$$;


ALTER FUNCTION public.get_following(p_user_id integer) OWNER TO postgres;

--
-- TOC entry 347 (class 1255 OID 32141)
-- Name: get_new_releases(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_new_releases(p_limit integer) RETURNS TABLE(collection_id integer, title text, artist_name text, release_date date, total_tracks bigint)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.collection_id,
        c.collection_title ::TEXT,
        STRING_AGG(DISTINCT a.artist_name, ', ') AS artist_name,
        c.collection_release_date,
        COUNT(cs.song_id) AS total_tracks
    FROM collections c
    LEFT JOIN releases r ON r.collection_id = c.collection_id
    LEFT JOIN artists a ON a.artist_id = r.artist_id
    LEFT JOIN collections_songs cs ON cs.collection_id = c.collection_id
    GROUP BY
        c.collection_id,
        c.collection_title,
        c.collection_release_date
    ORDER BY c.collection_release_date DESC
    LIMIT p_limit;
END;
$$;


ALTER FUNCTION public.get_new_releases(p_limit integer) OWNER TO postgres;

--
-- TOC entry 353 (class 1255 OID 32147)
-- Name: get_playlist_detail(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_playlist_detail(p_playlist_id integer) RETURNS TABLE(playlist_id integer, playlist_title character varying, playlist_cover character varying, playlist_desc text, song_no integer, song_id integer, song_title character varying, song_duration integer, added_by_username character varying)
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.get_playlist_detail(p_playlist_id integer) OWNER TO postgres;

--
-- TOC entry 340 (class 1255 OID 32134)
-- Name: get_playlist_duration_minutes(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_playlist_duration_minutes(p_playlist_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_total_sec INT;
BEGIN
    SELECT SUM(s.song_duration)
    INTO v_total_sec
    FROM songs s
    JOIN add_songs_playlists asp ON s.song_id = asp.song_id
    WHERE asp.playlist_id = p_playlist_id;

    RETURN COALESCE(v_total_sec / 60, 0);
END;
$$;


ALTER FUNCTION public.get_playlist_duration_minutes(p_playlist_id integer) OWNER TO postgres;

--
-- TOC entry 354 (class 1255 OID 32148)
-- Name: get_playlist_tracks(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_playlist_tracks(p_playlist_id integer) RETURNS TABLE(song_no integer, song_id integer, song_title character varying, song_duration integer, collection_id integer)
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.get_playlist_tracks(p_playlist_id integer) OWNER TO postgres;

--
-- TOC entry 349 (class 1255 OID 32143)
-- Name: get_recently_played(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_recently_played(p_user_id integer, p_limit integer DEFAULT 10) RETURNS TABLE(song_id integer, song_title character varying, duration_listened integer, last_play timestamp without time zone)
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


ALTER FUNCTION public.get_recently_played(p_user_id integer, p_limit integer) OWNER TO postgres;

--
-- TOC entry 363 (class 1255 OID 32157)
-- Name: get_song_audio_features(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_song_audio_features(p_song_id integer) RETURNS TABLE(song_id integer, song_title character varying, valence numeric, acousticness numeric, danceability numeric, energy numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_song_audio_features(p_song_id integer) OWNER TO postgres;

--
-- TOC entry 339 (class 1255 OID 32133)
-- Name: get_song_average_rating(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_song_average_rating(p_song_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    avg_rating NUMERIC;
BEGIN
    SELECT AVG(r.song_rating)
    INTO avg_rating
    FROM rate_songs r
    WHERE r.song_id = p_song_id;

    RETURN avg_rating;
END;
$$;


ALTER FUNCTION public.get_song_average_rating(p_song_id integer) OWNER TO postgres;

--
-- TOC entry 360 (class 1255 OID 32154)
-- Name: get_song_detail(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_song_detail(p_song_id integer) RETURNS TABLE(song_id integer, song_title character varying, song_duration integer, song_release_date date, song_rating numeric, artist_name character varying, genre_name character varying, collection_title character varying, nomor_disc integer, nomor_track integer)
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.get_song_detail(p_song_id integer) OWNER TO postgres;

--
-- TOC entry 348 (class 1255 OID 32142)
-- Name: log_listen(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.log_listen(IN p_user_id integer, IN p_song_id integer, IN p_duration integer)
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


ALTER PROCEDURE public.log_listen(IN p_user_id integer, IN p_song_id integer, IN p_duration integer) OWNER TO postgres;

--
-- TOC entry 365 (class 1255 OID 32159)
-- Name: login_user(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.login_user(p_user_email character varying, p_raw_pw character varying) RETURNS TABLE(user_id integer, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_user_id INT4;
    v_pw_hash VARCHAR(255);
BEGIN
    --cek apakah username sudah terdaftar atau belum
    SELECT u.user_id, u.pw_hash
    INTO v_user_id, v_pw_hash
    FROM users u
    WHERE u.user_email = p_user_email;

    --jika email belum terdaftar
    IF v_user_id IS NULL THEN
        RETURN QUERY SELECT NULL::INT4, 'Email not registered'::TEXT;
        RETURN;
    END IF;

    --cek password
    IF crypt(p_raw_pw, v_pw_hash) <> v_pw_hash THEN
        RETURN QUERY SELECT NULL::INT4, 'Invalid password'::TEXT;
        RETURN;
    END IF;

    --else, berhasil login
    RETURN QUERY SELECT v_user_id, 'Login successful'::TEXT;
	RETURN;
END;
$$;


ALTER FUNCTION public.login_user(p_user_email character varying, p_raw_pw character varying) OWNER TO postgres;

--
-- TOC entry 362 (class 1255 OID 32156)
-- Name: rate_song(integer, integer, numeric); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.rate_song(IN p_user_id integer, IN p_song_id integer, IN p_rating numeric)
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


ALTER PROCEDURE public.rate_song(IN p_user_id integer, IN p_song_id integer, IN p_rating numeric) OWNER TO postgres;

--
-- TOC entry 337 (class 1255 OID 32164)
-- Name: recalc_listen_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recalc_listen_count() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE songs s
    SET listen_count = sub.cnt
    FROM (
        SELECT song_id, COUNT(*) AS cnt
        FROM listens
        GROUP BY song_id
    ) sub
    WHERE s.song_id = sub.song_id;
END;
$$;


ALTER FUNCTION public.recalc_listen_count() OWNER TO postgres;

--
-- TOC entry 371 (class 1255 OID 32165)
-- Name: recalculate_all_song_popularity(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recalculate_all_song_popularity() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- hitung play maksimum dalam 30 hari terakhir
    WITH play_counts AS (
        SELECT
            song_id,
            COUNT(*) AS plays_30
        FROM listens
        WHERE "TIMESTAMP" >= CURRENT_DATE - INTERVAL '30 days'
        GROUP BY song_id
    ),
    max_play AS (
        SELECT MAX(plays_30) AS max_plays FROM play_counts
    )
    UPDATE songs s
    SET popularity =
        CASE
            WHEN pc.plays_30 IS NULL THEN 0   -- tidak ada play sama sekali -> 0
            WHEN mp.max_plays = 0 THEN 0      -- kalau kosong
            ELSE ROUND( (pc.plays_30::numeric / mp.max_plays::numeric) * 100 )
        END
    FROM play_counts pc, max_play mp
    WHERE s.song_id = pc.song_id;
END;
$$;


ALTER FUNCTION public.recalculate_all_song_popularity() OWNER TO postgres;

--
-- TOC entry 369 (class 1255 OID 32166)
-- Name: recalculate_monthly_listeners(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recalculate_monthly_listeners() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE artists a
    SET monthly_listener_count = sub.cnt
    FROM (
        SELECT
            cs.artist_id,
            COUNT(DISTINCT l.user_id) AS cnt
        FROM listens l
        JOIN create_songs cs ON cs.song_id = l.song_id
        WHERE DATE_TRUNC('month', l."TIMESTAMP") = DATE_TRUNC('month', CURRENT_DATE)
        GROUP BY cs.artist_id
    ) sub
    WHERE a.artist_id = sub.artist_id;
END;
$$;


ALTER FUNCTION public.recalculate_monthly_listeners() OWNER TO postgres;

--
-- TOC entry 364 (class 1255 OID 32158)
-- Name: register_user(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.register_user(p_username character varying, p_raw_pw character varying, p_user_email character varying) RETURNS TABLE(user_id integer, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_user_id INT4;
    v_pw_hash TEXT;
BEGIN
    --cek apakah email sudah dipakai atau belum
    IF EXISTS (SELECT 1 FROM users WHERE user_email = p_user_email) THEN
        RETURN QUERY SELECT NULL::INT, 'Email already registered'::TEXT;
        RETURN;
    END IF;

    --cek apakah username sudah dipakai atau belum
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
        RETURN QUERY SELECT NULL::INT, 'Username already taken'::TEXT;
        RETURN;
    END IF;

    --hash password menggunakan bcrypt
    v_pw_hash := crypt(p_raw_pw, gen_salt('bf'));

	--generate user_id dari sequence
	SELECT nextval('seq_users_id') INTO v_user_id;
	
    --insert user baru, user_id dari sequence
    INSERT INTO users (user_id, username, pw_hash, user_email)
    VALUES (v_user_id, p_username, v_pw_hash, p_user_email);
    RETURN QUERY SELECT v_user_id, 'Registration successful'::TEXT;
	RETURN;
END;
$$;


ALTER FUNCTION public.register_user(p_username character varying, p_raw_pw character varying, p_user_email character varying) OWNER TO postgres;

--
-- TOC entry 352 (class 1255 OID 32146)
-- Name: remove_song_from_playlist(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.remove_song_from_playlist(IN p_playlist_id integer, IN p_song_id integer)
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


ALTER PROCEDURE public.remove_song_from_playlist(IN p_playlist_id integer, IN p_song_id integer) OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 31912)
-- Name: reorder_playlist_sequence(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reorder_playlist_sequence() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE add_songs_playlists
    SET no_urut = no_urut - 1
    WHERE playlist_id = OLD.playlist_id
    AND no_urut > OLD.no_urut;
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.reorder_playlist_sequence() OWNER TO postgres;

--
-- TOC entry 359 (class 1255 OID 32153)
-- Name: search(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search(keyword text, type text) RETURNS TABLE(result_type text, id integer, title text, info text, extra_info text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- ============================
    -- TYPE: SONG
    -- ============================
    IF type = 'song' THEN
        RETURN QUERY
        SELECT
            'song' AS result_type,
            v.song_id AS id,
            v.song_title ::TEXT AS title,
            'Artist: ' || COALESCE(v.artists_name, '-') AS info,
            'Album: ' || COALESCE(v.album_name, '-') ||
            ' | Popularity: ' || COALESCE(v.popularity, 0) AS extra_info
        FROM view_full_song_details v
        WHERE v.song_title ILIKE '%' || keyword || '%'
           OR v.artists_name ILIKE '%' || keyword || '%'
           OR v.album_name ILIKE '%' || keyword || '%'
        ORDER BY v.popularity DESC NULLS LAST;

    -- ============================
    -- TYPE: COLLECTION (ALBUM)
    -- ============================
    ELSIF type = 'collection' THEN
        RETURN QUERY
        SELECT
            'collection',
            c.collection_id,
            c.collection_title ::TEXT,
            'Artist: ' || COALESCE(aa.album_artists,'-') AS info,
            'Release: ' || COALESCE(c.collection_release_date::TEXT, '-') AS extra_info
        FROM collections c
        JOIN (
            SELECT collection_id,
                STRING_AGG(artist_name, ', ') AS album_artists
            FROM releases r
            JOIN artists a ON a.artist_id = r.artist_id
            GROUP BY collection_id
        ) aa ON aa.collection_id = c.collection_id
        WHERE c.collection_title ILIKE '%' || keyword || '%'
           OR aa.album_artists ILIKE '%' || keyword || '%';

    -- ============================
    -- TYPE: PLAYLIST
    -- ============================
    ELSIF type = 'playlist' THEN
        RETURN QUERY
        SELECT
            'playlist',
            p.playlist_id,
            p.playlist_title ::TEXT,
            COALESCE(p.playlist_desc, ''),
            COUNT(asp.song_id)::TEXT AS extra
        FROM playlists p
        LEFT JOIN add_songs_playlists asp ON asp.playlist_id = p.playlist_id
        LEFT JOIN view_full_song_details v ON v.song_id = asp.song_id
        WHERE p.playlist_title ILIKE '%' || keyword || '%'
           OR COALESCE(p.playlist_desc, '') ILIKE '%' || keyword || '%'
           OR v.song_title ILIKE '%' || keyword || '%'
           OR v.artists_name ILIKE '%' || keyword || '%'
           OR v.album_name ILIKE '%' || keyword || '%'
        GROUP BY p.playlist_id, p.playlist_title, p.playlist_desc;

    -- ============================
    -- TYPE: ARTIST
    -- ============================
    ELSIF type = 'artist' THEN
        RETURN QUERY
        SELECT
            'artist',
            v.artist_id,
            v.artist_name ::TEXT,
            v.follower_count::TEXT || ' followers',
            'Albums: ' || total_albums || ' | Tracks: ' || total_tracks AS extra
        FROM view_artist_profile_header v
        WHERE v.artist_name ILIKE '%' || keyword || '%';

    -- ============================
    -- TYPE: USER
    -- ============================
    ELSIF type = 'user' THEN
        RETURN QUERY
        SELECT
            'user',
            u.user_id,
            u.username ::TEXT,
            u.followers_count::TEXT || ' followers',
            'Following: ' || u.following_count || 
            ' | Public playlists: ' || u.public_playlists AS extra
        FROM view_user_library_stats u
        WHERE u.username ILIKE '%' || keyword || '%';

    ELSE
        RAISE EXCEPTION 'Invalid type: %, valid types = song | artist | collection | playlist | user', type;
    END IF;
END;
$$;


ALTER FUNCTION public.search(keyword text, type text) OWNER TO postgres;

--
-- TOC entry 338 (class 1255 OID 32132)
-- Name: toggle_follow_artist(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.toggle_follow_artist(IN p_user_id integer, IN p_artist_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- cek user valid
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User_id % not found', p_user_id;
    END IF;

    -- cek artist valid
    IF NOT EXISTS (SELECT 1 FROM artists WHERE artist_id = p_artist_id) THEN
        RAISE EXCEPTION 'Artist_id % not found', p_artist_id;
    END IF;

    -- jika sudah follow -> UNFOLLOW
    IF EXISTS (
        SELECT 1 FROM follow_artists
        WHERE user_id = p_user_id AND artist_id = p_artist_id
    ) THEN
        DELETE FROM follow_artists
        WHERE user_id = p_user_id AND artist_id = p_artist_id;

        RAISE NOTICE 'Unfollowed artist %', p_artist_id;
        RETURN;
    END IF;

    -- jika belum follow -> FOLLOW
    INSERT INTO follow_artists(user_id, artist_id)
    VALUES (p_user_id, p_artist_id);

    RAISE NOTICE 'Followed artist %', p_artist_id;

END;
$$;


ALTER PROCEDURE public.toggle_follow_artist(IN p_user_id integer, IN p_artist_id integer) OWNER TO postgres;

--
-- TOC entry 366 (class 1255 OID 32160)
-- Name: toggle_follow_user(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.toggle_follow_user(IN p_follower_id integer, IN p_followed_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_exists BOOLEAN;
BEGIN
    --tidak boleh follow/unfollow diri sendiri
    IF p_follower_id = p_followed_id THEN
        RAISE EXCEPTION 'User cannot follow/unfollow themselves';
    END IF;

    --cek apakah kedua user valid
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_follower_id) THEN
        RAISE EXCEPTION 'Follower user_id % not found', p_follower_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_followed_id) THEN
        RAISE EXCEPTION 'Followed user_id % not found', p_followed_id;
    END IF;

    --cek apakah sudah follow, jika sudah -> unfollow
    SELECT EXISTS (SELECT 1 FROM follow_users 
        WHERE follower_id = p_follower_id AND followed_id = p_followed_id) 
    INTO v_exists;

    IF v_exists THEN
        --delete relationship from follow_users
        DELETE from follow_users 
            WHERE follower_id = p_follower_id AND followed_id = p_followed_id;
        RAISE NOTICE 'Unfollow successful';
        RETURN;
    END IF;

    --jika belum follow -> follow
    --insert ke table follow_users
    INSERT INTO follow_users VALUES (p_follower_id, p_followed_id);
	RAISE NOTICE 'Follow successful';
    
END;$$;


ALTER PROCEDURE public.toggle_follow_user(IN p_follower_id integer, IN p_followed_id integer) OWNER TO postgres;

--
-- TOC entry 358 (class 1255 OID 32152)
-- Name: toggle_like_review(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.toggle_like_review(IN p_user_id integer, IN p_review_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_exists BOOLEAN;
BEGIN
    -- cek user
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User_id % not found', p_user_id;
    END IF;

    -- cek review
    IF NOT EXISTS (SELECT 1 FROM reviews WHERE review_id = p_review_id) THEN
        RAISE EXCEPTION 'Review_id % not found', p_review_id;
    END IF;

    --cek toggle
    SELECT EXISTS (SELECT 1 FROM like_reviews WHERE review_id = p_review_id AND user_id = p_user_id)
    INTO v_exists;

    --jika sudah like -> unlike
    IF v_exists THEN
        DELETE FROM like_reviews WHERE review_id = p_review_id AND user_id = p_user_id;
        RAISE NOTICE 'Review % unliked by user %', p_review_id, p_user_id;
        RETURN;
    END IF;

    -- jika belum like -> insert like
    INSERT INTO like_reviews VALUES (p_review_id, p_user_id);
    RAISE NOTICE 'Review % liked by user %', p_review_id, p_user_id;
END;
$$;


ALTER PROCEDURE public.toggle_like_review(IN p_user_id integer, IN p_review_id integer) OWNER TO postgres;

--
-- TOC entry 361 (class 1255 OID 32155)
-- Name: toggle_like_song(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.toggle_like_song(IN p_user_id integer, IN p_song_id integer)
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


ALTER PROCEDURE public.toggle_like_song(IN p_user_id integer, IN p_song_id integer) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 31914)
-- Name: update_artist_follow_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_artist_follow_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- FOLLOW → INSERT
    IF TG_OP = 'INSERT' THEN
        UPDATE artists
        SET follower_count = COALESCE(follower_count, 0) + 1
        WHERE artist_id = NEW.artist_id;
    END IF;

    -- UNFOLLOW → DELETE
    IF TG_OP = 'DELETE' THEN
        UPDATE artists
        SET follower_count = COALESCE(follower_count, 0) - 1
        WHERE artist_id = OLD.artist_id;
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_artist_follow_count() OWNER TO postgres;

--
-- TOC entry 301 (class 1255 OID 31916)
-- Name: update_collection_rating(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_collection_rating() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_new_rating NUMERIC(5,2);
BEGIN
    -- Hitung ulang rating dari seluruh review untuk collection
    SELECT AVG(rating)
    INTO v_new_rating
    FROM reviews
    WHERE collection_id = COALESCE(NEW.collection_id, OLD.collection_id);

    -- Update ke tabel collections
    UPDATE collections
    SET collection_rating = v_new_rating
    WHERE collection_id = COALESCE(NEW.collection_id, OLD.collection_id);

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_collection_rating() OWNER TO postgres;

--
-- TOC entry 302 (class 1255 OID 31918)
-- Name: update_collection_top3_genres(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_collection_top3_genres() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    top_genre RECORD; -- Variabel RECORD untuk menampung hasil looping genre teratas
BEGIN
    -- Hapus data lama untuk collection ini (supaya bisa di isi ulang dari nol  )
    DELETE FROM collection_top_3_genres
    WHERE collection_id = NEW.collection_id;  -- Hanya untuk collection yang sama dengan row yang baru diubah/ditambah


    -- Ambil 3 genre paling sering muncul dari lagu-lagu collection
    FOR top_genre IN
        SELECT sg.genre_id  -- Mengambil genre_id
        FROM songs_genres sg  
        JOIN collections_songs cs ON sg.song_id = cs.song_id  -- Menghubungkan genre ke lagu dalam sebuah collection
        WHERE cs.collection_id = NEW.collection_id  -- Filter berdasarkan collection yang sedang di-update
        GROUP BY sg.genre_id  -- Mengelompokkan berdasarkan genre
        ORDER BY COUNT(*) DESC  -- Urutkan berdasarkan jumlah kemunculan genre terbanyak
        LIMIT 3  -- Ambil hanya 3 genre teratas
    LOOP
        -- Insert ke COLLECTION_TOP_3_GENRES
        INSERT INTO collection_top_3_genres (collection_id, genre_id)  -- Tambahkan satu per satu genre ke tabel top 3
        VALUES (NEW.collection_id, top_genre.genre_id);   -- Mengisi collection_id dan genre_id hasil loop
    END LOOP;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_collection_top3_genres() OWNER TO postgres;

--
-- TOC entry 370 (class 1255 OID 32167)
-- Name: update_prerelease_daily(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_prerelease_daily() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE collections
    SET isPrerelease = FALSE
    WHERE isPrerelease = TRUE
      AND collection_release_date <= CURRENT_DATE;
END;
$$;


ALTER FUNCTION public.update_prerelease_daily() OWNER TO postgres;

--
-- TOC entry 303 (class 1255 OID 31920)
-- Name: update_review_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_review_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Jika kolom review atau rating berubah
    IF NEW.review IS DISTINCT FROM OLD.review
       OR NEW.rating IS DISTINCT FROM OLD.rating THEN

        NEW."TIMESTAMP" = CURRENT_TIMESTAMP;

    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_review_timestamp() OWNER TO postgres;

--
-- TOC entry 304 (class 1255 OID 31922)
-- Name: update_song_rating(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_song_rating() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.update_song_rating() OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 31926)
-- Name: validate_prerelease_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_prerelease_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- RULE 1: prerelease must be future
    IF NEW.isPrerelease = TRUE  -- Jika isPrerelease = TRUE
       AND NEW.collection_release_date <= CURRENT_DATE THEN   -- Tetapi tanggal rilis tidak di masa depan
        RAISE EXCEPTION
            'If isPrerelease = TRUE, then release_date (%s) must be in the future.',  -- Pesan error
            NEW.collection_release_date;
    END IF;

    -- RULE 2: NOT prerelease must be today or past
    IF NEW.isPrerelease = FALSE  -- Jika isPrerelease = FALSE
       AND NEW.collection_release_date > CURRENT_DATE THEN -- Tetapi tanggal rilis berada di masa depan
        RAISE EXCEPTION
            'If isPrerelease = FALSE, release_date (%s) cannot be in the future.',  -- Pesan error
            NEW.collection_release_date;   -- Menampilkan tanggal yang salah
    END IF;

    -- RULE 3: If release date is today → force prerelease = FALSE
    IF NEW.collection_release_date = CURRENT_DATE THEN   -- Jika tanggal rilis sama dengan hari ini
        NEW.isPrerelease := FALSE;  -- isPrerelease menjadi FALSE
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_prerelease_date() OWNER TO postgres;

--
-- TOC entry 307 (class 1255 OID 31928)
-- Name: validate_tour_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_tour_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.tour_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'Tour date (%s) shouldnt be before today (%s)', NEW.tour_date, CURRENT_DATE;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_tour_date() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 31311)
-- Name: add_songs_playlists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.add_songs_playlists (
    add_song_pl_id integer NOT NULL,
    user_id integer NOT NULL,
    playlist_id integer NOT NULL,
    song_id integer NOT NULL,
    no_urut integer NOT NULL,
    "TIMESTAMP" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_playlist_order_positive CHECK ((no_urut > 0))
);


ALTER TABLE public.add_songs_playlists OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 31352)
-- Name: artist_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artist_promotion (
    artist_id integer NOT NULL,
    collection_id integer NOT NULL,
    komentar_promosi text
);


ALTER TABLE public.artist_promotion OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 31327)
-- Name: artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artists (
    artist_id integer NOT NULL,
    artist_name character varying(255) NOT NULL,
    bio text,
    monthly_listener_count bigint DEFAULT 0,
    artist_pfp character varying(2048),
    artist_email character varying(320) NOT NULL,
    banner character varying(2048),
    follower_count bigint DEFAULT 0,
    CONSTRAINT chk_artistname_no_whitespace CHECK ((length(TRIM(BOTH FROM artist_name)) > 0)),
    CONSTRAINT chk_listener_positive CHECK ((monthly_listener_count >= 0))
);


ALTER TABLE public.artists OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 31342)
-- Name: artists_tours; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artists_tours (
    tour_id integer NOT NULL,
    artist_id integer NOT NULL
);


ALTER TABLE public.artists_tours OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 31374)
-- Name: block_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.block_users (
    blocker_id integer NOT NULL,
    blocked_id integer NOT NULL,
    CONSTRAINT chk_no_self_block CHECK ((blocker_id <> blocked_id))
);


ALTER TABLE public.block_users OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 31364)
-- Name: blocklist_artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blocklist_artists (
    artist_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.blocklist_artists OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 31408)
-- Name: collection_library; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collection_library (
    user_id integer NOT NULL,
    collection_id integer NOT NULL
);


ALTER TABLE public.collection_library OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 31418)
-- Name: collection_top_3_genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collection_top_3_genres (
    collection_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE public.collection_top_3_genres OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 31384)
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    collection_id integer NOT NULL,
    collection_title character varying(255) NOT NULL,
    collection_type character varying(50) NOT NULL,
    collection_cover character varying(2048),
    collection_release_date date NOT NULL,
    collection_rating numeric(3,0),
    isprerelease boolean,
    CONSTRAINT chk_collection_type_valid CHECK (((collection_type)::text = ANY ((ARRAY['Album'::character varying, 'EP'::character varying, 'Single'::character varying, 'Compilation'::character varying])::text[])))
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 31396)
-- Name: collections_songs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections_songs (
    song_id integer NOT NULL,
    collection_id integer NOT NULL,
    nomor_disc integer NOT NULL,
    nomor_track integer NOT NULL,
    CONSTRAINT chk_disc_track_positive CHECK (((nomor_disc > 0) AND (nomor_track > 0)))
);


ALTER TABLE public.collections_songs OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 31428)
-- Name: create_songs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.create_songs (
    song_id integer NOT NULL,
    artist_id integer NOT NULL
);


ALTER TABLE public.create_songs OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 31438)
-- Name: follow_artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.follow_artists (
    user_id integer NOT NULL,
    artist_id integer NOT NULL,
    "TIMESTAMP" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.follow_artists OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 31450)
-- Name: follow_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.follow_users (
    follower_id integer NOT NULL,
    followed_id integer NOT NULL,
    CONSTRAINT chk_no_self_follow CHECK ((follower_id <> followed_id))
);


ALTER TABLE public.follow_users OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 31460)
-- Name: genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genres (
    genre_id integer NOT NULL,
    genre_name character varying(255) NOT NULL
);


ALTER TABLE public.genres OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 31468)
-- Name: like_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.like_reviews (
    review_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.like_reviews OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 31478)
-- Name: like_songs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.like_songs (
    song_id integer NOT NULL,
    user_id integer NOT NULL,
    "TIMESTAMP" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.like_songs OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 31490)
-- Name: listens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.listens (
    listen_id integer NOT NULL,
    user_id integer NOT NULL,
    song_id integer NOT NULL,
    duration_listened integer NOT NULL,
    "TIMESTAMP" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.listens OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 31520)
-- Name: pl_library; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pl_library (
    user_id integer NOT NULL,
    playlist_id integer NOT NULL
);


ALTER TABLE public.pl_library OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 31504)
-- Name: playlists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.playlists (
    playlist_id integer NOT NULL,
    user_id integer NOT NULL,
    playlist_cover character varying(2048),
    playlist_title character varying(255) NOT NULL,
    ispublic boolean DEFAULT false NOT NULL,
    iscollaborative boolean DEFAULT false NOT NULL,
    playlist_desc text,
    isonprofile boolean NOT NULL,
    playlist_date_created date NOT NULL
);


ALTER TABLE public.playlists OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 31530)
-- Name: rate_songs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rate_songs (
    user_id integer NOT NULL,
    song_id integer NOT NULL,
    song_rating numeric(3,0) NOT NULL,
    "TIMESTAMP" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_rate_song_range CHECK (((song_rating >= (1)::numeric) AND (song_rating <= (100)::numeric)))
);


ALTER TABLE public.rate_songs OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 31543)
-- Name: releases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.releases (
    collection_id integer NOT NULL,
    artist_id integer NOT NULL
);


ALTER TABLE public.releases OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 31553)
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    review text,
    rating numeric(3,0) NOT NULL,
    "TIMESTAMP" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    review_id integer NOT NULL,
    user_id integer NOT NULL,
    collection_id integer NOT NULL,
    CONSTRAINT chk_review_rating_range CHECK (((rating >= (1)::numeric) AND (rating <= (100)::numeric)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 31858)
-- Name: seq_add_songs_playlist_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_add_songs_playlist_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_add_songs_playlist_id OWNER TO postgres;

--
-- TOC entry 3961 (class 0 OID 0)
-- Dependencies: 263
-- Name: seq_add_songs_playlist_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_add_songs_playlist_id OWNED BY public.add_songs_playlists.add_song_pl_id;


--
-- TOC entry 253 (class 1259 OID 31838)
-- Name: seq_artists_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_artists_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_artists_id OWNER TO postgres;

--
-- TOC entry 3962 (class 0 OID 0)
-- Dependencies: 253
-- Name: seq_artists_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_artists_id OWNED BY public.artists.artist_id;


--
-- TOC entry 257 (class 1259 OID 31846)
-- Name: seq_collections_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_collections_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_collections_id OWNER TO postgres;

--
-- TOC entry 3963 (class 0 OID 0)
-- Dependencies: 257
-- Name: seq_collections_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_collections_id OWNED BY public.collections.collection_id;


--
-- TOC entry 258 (class 1259 OID 31848)
-- Name: seq_genres_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_genres_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_genres_id OWNER TO postgres;

--
-- TOC entry 3964 (class 0 OID 0)
-- Dependencies: 258
-- Name: seq_genres_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_genres_id OWNED BY public.genres.genre_id;


--
-- TOC entry 262 (class 1259 OID 31856)
-- Name: seq_listens_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_listens_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_listens_id OWNER TO postgres;

--
-- TOC entry 3965 (class 0 OID 0)
-- Dependencies: 262
-- Name: seq_listens_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_listens_id OWNED BY public.listens.listen_id;


--
-- TOC entry 256 (class 1259 OID 31844)
-- Name: seq_playlists_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_playlists_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_playlists_id OWNER TO postgres;

--
-- TOC entry 3966 (class 0 OID 0)
-- Dependencies: 256
-- Name: seq_playlists_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_playlists_id OWNED BY public.playlists.playlist_id;


--
-- TOC entry 259 (class 1259 OID 31850)
-- Name: seq_reviews_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_reviews_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_reviews_id OWNER TO postgres;

--
-- TOC entry 3967 (class 0 OID 0)
-- Dependencies: 259
-- Name: seq_reviews_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_reviews_id OWNED BY public.reviews.review_id;


--
-- TOC entry 248 (class 1259 OID 31569)
-- Name: socials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.socials (
    social_id integer NOT NULL,
    artist_id integer NOT NULL,
    social_media_link character varying(2048) NOT NULL
);


ALTER TABLE public.socials OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 31854)
-- Name: seq_socials_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_socials_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_socials_id OWNER TO postgres;

--
-- TOC entry 3968 (class 0 OID 0)
-- Dependencies: 261
-- Name: seq_socials_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_socials_id OWNED BY public.socials.social_id;


--
-- TOC entry 249 (class 1259 OID 31581)
-- Name: songs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs (
    song_id integer NOT NULL,
    song_file character varying(320) NOT NULL,
    song_title character varying(255) NOT NULL,
    listen_count bigint DEFAULT 0,
    song_credits text,
    song_duration integer NOT NULL,
    valence numeric(4,3),
    accousticness numeric(4,3),
    danceability numeric(4,3),
    energy numeric(4,3),
    popularity numeric(3,0),
    song_release_date date NOT NULL,
    song_rating numeric(3,0),
    CONSTRAINT chk_song_duration_positive CHECK ((song_duration > 0)),
    CONSTRAINT chk_song_metrics CHECK (((valence >= (0)::numeric) AND (valence <= (1)::numeric) AND ((danceability >= (0)::numeric) AND (danceability <= (1)::numeric)) AND ((energy >= (0)::numeric) AND (energy <= (1)::numeric)) AND ((accousticness >= (0)::numeric) AND (accousticness <= (1)::numeric)))),
    CONSTRAINT chk_song_popularity_range CHECK (((popularity >= (0)::numeric) AND (popularity <= (100)::numeric)))
);


ALTER TABLE public.songs OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 31840)
-- Name: seq_songs_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_songs_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_songs_id OWNER TO postgres;

--
-- TOC entry 3969 (class 0 OID 0)
-- Dependencies: 254
-- Name: seq_songs_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_songs_id OWNED BY public.songs.song_id;


--
-- TOC entry 251 (class 1259 OID 31605)
-- Name: tours; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tours (
    tour_id integer NOT NULL,
    tour_date date NOT NULL,
    tour_name character varying(255) NOT NULL,
    venue character varying(255) NOT NULL
);


ALTER TABLE public.tours OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 31852)
-- Name: seq_tours_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_tours_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_tours_id OWNER TO postgres;

--
-- TOC entry 3970 (class 0 OID 0)
-- Dependencies: 260
-- Name: seq_tours_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_tours_id OWNED BY public.tours.tour_id;


--
-- TOC entry 252 (class 1259 OID 31617)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    user_pfp character varying(2048),
    pw_hash character varying(255) NOT NULL,
    user_email character varying(320) NOT NULL,
    region character varying(50),
    country character varying(50),
    CONSTRAINT chk_email_format CHECK (((user_email)::text ~~ '%_@__%.__%'::text)),
    CONSTRAINT chk_pw_hash_length CHECK ((length((pw_hash)::text) >= 8)),
    CONSTRAINT chk_username_no_whitespace CHECK ((length(TRIM(BOTH FROM username)) > 0))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 31842)
-- Name: seq_users_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_users_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_users_id OWNER TO postgres;

--
-- TOC entry 3971 (class 0 OID 0)
-- Dependencies: 255
-- Name: seq_users_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seq_users_id OWNED BY public.users.user_id;


--
-- TOC entry 250 (class 1259 OID 31595)
-- Name: songs_genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs_genres (
    genre_id integer NOT NULL,
    song_id integer NOT NULL
);


ALTER TABLE public.songs_genres OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 31890)
-- Name: view_album_tracklist; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_album_tracklist AS
 WITH album_artists AS (
         SELECT r.collection_id,
            string_agg(DISTINCT (a.artist_name)::text, ', '::text ORDER BY (a.artist_name)::text) AS album_artists
           FROM (public.releases r
             JOIN public.artists a ON ((r.artist_id = a.artist_id)))
          GROUP BY r.collection_id
        ), song_artists AS (
         SELECT crs.song_id,
            string_agg(DISTINCT (a.artist_name)::text, ', '::text ORDER BY (a.artist_name)::text) AS song_artists
           FROM (public.create_songs crs
             JOIN public.artists a ON ((crs.artist_id = a.artist_id)))
          GROUP BY crs.song_id
        )
 SELECT c.collection_id,
    c.collection_title,
    aa.album_artists,
    cs.nomor_disc,
    cs.nomor_track,
    s.song_title,
    sa.song_artists,
    to_char(((s.song_duration || ' second'::text))::interval, 'MI:SS'::text) AS duration
   FROM ((((public.collections c
     JOIN album_artists aa ON ((c.collection_id = aa.collection_id)))
     JOIN public.collections_songs cs ON ((c.collection_id = cs.collection_id)))
     JOIN public.songs s ON ((cs.song_id = s.song_id)))
     LEFT JOIN song_artists sa ON ((sa.song_id = s.song_id)))
  ORDER BY c.collection_id, cs.nomor_disc, cs.nomor_track;


ALTER VIEW public.view_album_tracklist OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 31905)
-- Name: view_artist_profile_header; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_artist_profile_header AS
 WITH total_albums AS (
         SELECT releases.artist_id,
            count(*) AS total_albums
           FROM public.releases
          GROUP BY releases.artist_id
        ), total_tracks AS (
         SELECT create_songs.artist_id,
            count(*) AS total_tracks
           FROM public.create_songs
          GROUP BY create_songs.artist_id
        )
 SELECT a.artist_id,
    a.artist_name,
    a.bio,
    a.artist_pfp,
    a.banner,
    a.artist_email,
    a.monthly_listener_count,
    a.follower_count,
    COALESCE(alb.total_albums, (0)::bigint) AS total_albums,
    COALESCE(trk.total_tracks, (0)::bigint) AS total_tracks
   FROM ((public.artists a
     LEFT JOIN total_albums alb ON ((a.artist_id = alb.artist_id)))
     LEFT JOIN total_tracks trk ON ((a.artist_id = trk.artist_id)));


ALTER VIEW public.view_artist_profile_header OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 31885)
-- Name: view_full_song_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_full_song_details AS
 SELECT s.song_id,
    s.song_title,
    string_agg(DISTINCT (a.artist_name)::text, ', '::text) AS artist_names,
    c.collection_title AS album_name,
    s.song_duration,
    s.popularity,
    s.song_file,
    to_char(((s.song_duration || ' second'::text))::interval, 'MI:SS'::text) AS duration_formatted
   FROM ((((public.songs s
     JOIN public.create_songs cs ON ((s.song_id = cs.song_id)))
     JOIN public.artists a ON ((cs.artist_id = a.artist_id)))
     LEFT JOIN public.collections_songs c_s ON ((s.song_id = c_s.song_id)))
     LEFT JOIN public.collections c ON ((c_s.collection_id = c.collection_id)))
  GROUP BY s.song_id, s.song_title, c.collection_title, s.song_duration, s.popularity, s.song_file;


ALTER VIEW public.view_full_song_details OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 31895)
-- Name: view_top_charts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_top_charts AS
 WITH song_artists AS (
         SELECT crs.song_id,
            string_agg(DISTINCT (a.artist_name)::text, ', '::text ORDER BY (a.artist_name)::text) AS artists
           FROM (public.create_songs crs
             JOIN public.artists a ON ((a.artist_id = crs.artist_id)))
          GROUP BY crs.song_id
        ), song_album AS (
         SELECT DISTINCT ON (cs.song_id) cs.song_id,
            c.collection_title AS album
           FROM (public.collections_songs cs
             LEFT JOIN public.collections c ON ((c.collection_id = cs.collection_id)))
          ORDER BY cs.song_id, c.collection_title
        )
 SELECT row_number() OVER (ORDER BY s.popularity DESC) AS rank,
    s.song_title,
    sa.artists,
    al.album,
    s.popularity
   FROM ((public.songs s
     LEFT JOIN song_artists sa ON ((sa.song_id = s.song_id)))
     LEFT JOIN song_album al ON ((al.song_id = s.song_id)))
  WHERE (s.popularity IS NOT NULL)
  ORDER BY s.popularity DESC;


ALTER VIEW public.view_top_charts OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 31900)
-- Name: view_user_library_stats; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_user_library_stats AS
 WITH pub_playlists AS (
         SELECT playlists.user_id,
            count(*) AS public_playlists
           FROM public.playlists
          WHERE (playlists.ispublic = true)
          GROUP BY playlists.user_id
        ), following_users AS (
         SELECT follow_users.follower_id AS user_id,
            count(*) AS follow_users_count
           FROM public.follow_users
          GROUP BY follow_users.follower_id
        ), following_artists AS (
         SELECT follow_artists.user_id,
            count(*) AS follow_artists_count
           FROM public.follow_artists
          GROUP BY follow_artists.user_id
        ), followers AS (
         SELECT follow_users.followed_id AS user_id,
            count(*) AS followers_count
           FROM public.follow_users
          GROUP BY follow_users.followed_id
        )
 SELECT u.user_id,
    u.username,
    u.user_pfp,
    COALESCE(pp.public_playlists, (0)::bigint) AS public_playlists,
    (COALESCE(fu.follow_users_count, (0)::bigint) + COALESCE(fa.follow_artists_count, (0)::bigint)) AS following_count,
    COALESCE(fr.followers_count, (0)::bigint) AS followers_count
   FROM ((((public.users u
     LEFT JOIN pub_playlists pp ON ((pp.user_id = u.user_id)))
     LEFT JOIN following_users fu ON ((fu.user_id = u.user_id)))
     LEFT JOIN following_artists fa ON ((fa.user_id = u.user_id)))
     LEFT JOIN followers fr ON ((fr.user_id = u.user_id)));


ALTER VIEW public.view_user_library_stats OWNER TO postgres;

--
-- TOC entry 3537 (class 2604 OID 31859)
-- Name: add_songs_playlists add_song_pl_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.add_songs_playlists ALTER COLUMN add_song_pl_id SET DEFAULT nextval('public.seq_add_songs_playlist_id'::regclass);


--
-- TOC entry 3539 (class 2604 OID 31839)
-- Name: artists artist_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists ALTER COLUMN artist_id SET DEFAULT nextval('public.seq_artists_id'::regclass);


--
-- TOC entry 3542 (class 2604 OID 31847)
-- Name: collections collection_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections ALTER COLUMN collection_id SET DEFAULT nextval('public.seq_collections_id'::regclass);


--
-- TOC entry 3544 (class 2604 OID 31849)
-- Name: genres genre_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres ALTER COLUMN genre_id SET DEFAULT nextval('public.seq_genres_id'::regclass);


--
-- TOC entry 3546 (class 2604 OID 31857)
-- Name: listens listen_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listens ALTER COLUMN listen_id SET DEFAULT nextval('public.seq_listens_id'::regclass);


--
-- TOC entry 3548 (class 2604 OID 31845)
-- Name: playlists playlist_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playlists ALTER COLUMN playlist_id SET DEFAULT nextval('public.seq_playlists_id'::regclass);


--
-- TOC entry 3553 (class 2604 OID 31851)
-- Name: reviews review_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN review_id SET DEFAULT nextval('public.seq_reviews_id'::regclass);


--
-- TOC entry 3554 (class 2604 OID 31855)
-- Name: socials social_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socials ALTER COLUMN social_id SET DEFAULT nextval('public.seq_socials_id'::regclass);


--
-- TOC entry 3555 (class 2604 OID 31841)
-- Name: songs song_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs ALTER COLUMN song_id SET DEFAULT nextval('public.seq_songs_id'::regclass);


--
-- TOC entry 3557 (class 2604 OID 31853)
-- Name: tours tour_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tours ALTER COLUMN tour_id SET DEFAULT nextval('public.seq_tours_id'::regclass);


--
-- TOC entry 3558 (class 2604 OID 31843)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.seq_users_id'::regclass);


--
-- TOC entry 3526 (class 0 OID 28249)
-- Dependencies: 223
-- Data for Name: job; Type: TABLE DATA; Schema: cron; Owner: postgres
--

INSERT INTO cron.job VALUES (3, '20 0 * * *', 'SELECT recalc_listen_count();', 'localhost', 5432, 'sbd_tubes_music', 'postgres', true, 'recalc_listen_count_daily');
INSERT INTO cron.job VALUES (5, '10 0 * * *', 'SELECT recalculate_monthly_listeners();', 'localhost', 5432, 'sbd_tubes_music', 'postgres', true, 'recalculate_monthly_listeners_daily');
INSERT INTO cron.job VALUES (6, '0 0 * * *', 'SELECT update_prerelease_daily();', 'localhost', 5432, 'sbd_tubes_music', 'postgres', true, 'update_prerelease_job_daily');
INSERT INTO cron.job VALUES (1, '56 9 * * *', 'SELECT recalc_listen_count();', 'localhost', 5432, 'sbd_tubes_music', 'postgres', true, 'delete_expired_tours_daily');
INSERT INTO cron.job VALUES (4, '15 0 * * *', 'SELECT recalculate_all_song_popularity();', 'localhost', 5432, 'sbd_tubes_music', 'postgres', true, 'recalculate_song_popularity_daily');
INSERT INTO cron.job VALUES (10, '37 3 * * *', 'SELECT recalculate_all_song_popularity();', 'localhost', 5432, 'sbd_tubes_music', 'postgres', true, 'recalculate_song_popularity_test');


--
-- TOC entry 3528 (class 0 OID 28276)
-- Dependencies: 225
-- Data for Name: job_run_details; Type: TABLE DATA; Schema: cron; Owner: postgres
--

INSERT INTO cron.job_run_details VALUES (4, 1, 46875, 'sbd_tubes_music', 'postgres', 'SELECT recalculate_all_song_popularity();', 'succeeded', '1 row', '2025-12-01 07:15:00.027416+07', '2025-12-01 07:15:00.047988+07');
INSERT INTO cron.job_run_details VALUES (3, 2, 47386, 'sbd_tubes_music', 'postgres', 'SELECT recalc_listen_count();', 'succeeded', '1 row', '2025-12-01 07:20:00.009329+07', '2025-12-01 07:20:00.016725+07');
INSERT INTO cron.job_run_details VALUES (1, 3, 86596, 'sbd_tubes_music', 'postgres', 'SELECT recalc_listen_count();', 'succeeded', '1 row', '2025-12-01 16:56:00.039403+07', '2025-12-01 16:56:00.054983+07');
INSERT INTO cron.job_run_details VALUES (10, 4, 354704, 'sbd_tubes_music', 'postgres', 'SELECT recalculate_all_song_popularity();', 'succeeded', '1 row', '2025-12-05 10:33:00.034318+07', '2025-12-05 10:33:00.048708+07');
INSERT INTO cron.job_run_details VALUES (10, 5, 355037, 'sbd_tubes_music', 'postgres', 'SELECT recalculate_all_song_popularity();', 'succeeded', '1 row', '2025-12-05 10:34:00.017529+07', '2025-12-05 10:34:00.022182+07');
INSERT INTO cron.job_run_details VALUES (10, 6, 355112, 'sbd_tubes_music', 'postgres', 'SELECT recalculate_all_song_popularity();', 'succeeded', '1 row', '2025-12-05 10:36:00.011787+07', '2025-12-05 10:36:00.023378+07');
INSERT INTO cron.job_run_details VALUES (10, 7, 355126, 'sbd_tubes_music', 'postgres', 'SELECT recalculate_all_song_popularity();', 'succeeded', '1 row', '2025-12-05 10:37:00.01845+07', '2025-12-05 10:37:00.026679+07');


--
-- TOC entry 3914 (class 0 OID 31311)
-- Dependencies: 226
-- Data for Name: add_songs_playlists; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.add_songs_playlists VALUES (1, 1, 1, 34, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (2, 1, 1, 66, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (3, 1, 1, 7, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (4, 1, 1, 88, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (5, 1, 1, 24, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (6, 1, 1, 92, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (7, 2, 2, 60, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (8, 2, 2, 22, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (9, 2, 2, 19, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (10, 2, 2, 23, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (11, 2, 3, 92, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (12, 2, 3, 59, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (13, 2, 3, 33, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (14, 2, 3, 88, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (15, 3, 4, 55, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (16, 3, 4, 91, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (17, 3, 4, 6, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (18, 3, 4, 13, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (19, 3, 4, 64, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (20, 4, 5, 43, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (21, 4, 5, 91, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (22, 4, 5, 30, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (23, 4, 5, 22, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (24, 4, 5, 7, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (25, 4, 5, 38, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (26, 5, 6, 47, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (27, 5, 6, 44, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (28, 5, 6, 31, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (29, 5, 6, 49, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (30, 6, 7, 85, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (31, 6, 7, 96, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (32, 6, 7, 74, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (33, 6, 7, 63, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (34, 6, 8, 85, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (35, 6, 8, 97, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (36, 6, 8, 69, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (37, 6, 8, 58, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (38, 6, 8, 1, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (39, 6, 8, 49, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (40, 7, 9, 69, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (41, 7, 9, 39, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (42, 7, 9, 9, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (43, 7, 9, 49, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (44, 7, 10, 68, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (45, 7, 10, 73, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (46, 7, 10, 94, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (47, 7, 10, 67, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (48, 7, 10, 35, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (49, 7, 10, 56, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (50, 8, 11, 12, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (51, 8, 11, 39, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (52, 8, 11, 6, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (53, 8, 11, 52, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (54, 8, 12, 63, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (55, 8, 12, 10, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (56, 8, 12, 79, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (57, 9, 13, 61, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (58, 9, 13, 92, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (59, 9, 13, 53, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (60, 9, 13, 56, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (61, 9, 13, 89, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (62, 9, 13, 7, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (63, 9, 13, 41, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (64, 9, 13, 46, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (65, 10, 14, 52, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (66, 10, 14, 13, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (67, 10, 14, 21, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (68, 11, 15, 4, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (69, 11, 15, 80, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (70, 11, 15, 30, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (71, 11, 15, 37, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (72, 11, 15, 27, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (73, 11, 16, 41, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (74, 11, 16, 15, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (75, 11, 16, 83, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (76, 11, 16, 13, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (77, 12, 17, 68, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (78, 12, 17, 82, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (79, 12, 17, 96, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (80, 12, 17, 46, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (81, 12, 17, 64, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (82, 12, 17, 7, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (83, 12, 17, 42, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (84, 13, 18, 6, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (85, 13, 18, 38, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (86, 13, 18, 62, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (87, 13, 18, 7, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (88, 14, 19, 79, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (89, 14, 19, 84, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (90, 14, 19, 35, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (91, 14, 19, 14, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (92, 14, 19, 85, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (93, 15, 20, 36, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (94, 15, 20, 49, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (95, 15, 20, 72, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (96, 16, 21, 41, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (97, 16, 21, 20, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (98, 16, 21, 89, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (99, 16, 22, 2, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (100, 16, 22, 61, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (101, 16, 22, 62, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (102, 16, 22, 69, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (103, 17, 23, 74, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (104, 17, 23, 85, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (105, 17, 23, 14, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (106, 17, 23, 82, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (107, 17, 23, 41, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (108, 17, 23, 24, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (109, 17, 24, 44, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (110, 17, 24, 14, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (111, 17, 24, 52, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (112, 17, 24, 50, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (113, 17, 24, 80, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (114, 18, 25, 95, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (115, 18, 25, 70, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (116, 18, 25, 17, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (117, 18, 26, 6, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (118, 18, 26, 53, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (119, 18, 26, 30, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (120, 18, 26, 66, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (121, 18, 26, 50, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (122, 18, 26, 85, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (123, 18, 26, 11, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (124, 18, 26, 48, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (125, 19, 27, 100, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (126, 19, 27, 51, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (127, 19, 27, 79, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (128, 19, 27, 77, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (129, 19, 27, 66, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (130, 19, 27, 45, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (131, 19, 27, 91, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (132, 19, 27, 60, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (133, 20, 28, 14, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (134, 20, 28, 88, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (135, 20, 28, 91, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (136, 20, 28, 46, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (137, 20, 28, 25, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (138, 20, 28, 72, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (139, 20, 28, 70, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (140, 20, 28, 47, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (141, 21, 29, 81, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (142, 21, 29, 100, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (143, 21, 29, 57, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (144, 21, 29, 41, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (145, 21, 29, 16, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (146, 21, 29, 82, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (147, 21, 29, 65, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (148, 21, 29, 51, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (149, 21, 30, 76, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (150, 21, 30, 78, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (151, 21, 30, 47, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (152, 21, 30, 19, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (153, 21, 30, 67, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (154, 21, 30, 2, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (155, 22, 31, 77, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (156, 22, 31, 59, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (157, 22, 31, 35, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (158, 22, 31, 28, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (159, 22, 31, 23, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (160, 22, 31, 13, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (161, 22, 31, 98, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (162, 23, 32, 38, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (163, 23, 32, 46, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (164, 23, 32, 69, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (165, 23, 32, 10, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (166, 23, 32, 32, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (167, 23, 32, 67, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (168, 24, 33, 65, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (169, 24, 33, 28, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (170, 24, 33, 34, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (171, 24, 33, 83, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (172, 24, 34, 81, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (173, 24, 34, 21, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (174, 24, 34, 18, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (175, 24, 34, 100, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (176, 25, 35, 60, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (177, 25, 35, 86, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (178, 25, 35, 63, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (179, 25, 35, 88, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (180, 25, 35, 87, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (181, 26, 36, 23, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (182, 26, 36, 77, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (183, 26, 36, 2, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (184, 26, 36, 67, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (185, 26, 37, 49, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (186, 26, 37, 35, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (187, 26, 37, 88, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (188, 26, 37, 94, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (189, 26, 37, 74, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (190, 27, 38, 56, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (191, 27, 38, 57, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (192, 27, 38, 100, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (193, 27, 38, 82, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (194, 27, 38, 13, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (195, 28, 39, 37, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (196, 28, 39, 4, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (197, 28, 39, 26, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (198, 29, 40, 77, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (199, 29, 40, 1, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (200, 29, 40, 42, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (201, 30, 41, 94, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (202, 30, 41, 8, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (203, 30, 41, 38, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (204, 30, 41, 62, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (205, 30, 41, 25, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (206, 30, 42, 100, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (207, 30, 42, 92, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (208, 30, 42, 82, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (209, 30, 42, 3, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (210, 30, 42, 49, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (211, 31, 43, 27, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (212, 31, 43, 32, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (213, 31, 43, 88, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (214, 31, 43, 90, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (215, 31, 43, 85, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (216, 31, 43, 66, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (217, 32, 44, 84, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (218, 32, 44, 85, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (219, 32, 44, 35, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (220, 32, 44, 90, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (221, 32, 44, 86, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (222, 32, 44, 76, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (223, 32, 44, 79, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (224, 32, 45, 55, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (225, 32, 45, 79, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (226, 32, 45, 29, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (227, 32, 45, 89, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (228, 32, 45, 92, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (229, 32, 45, 43, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (230, 32, 45, 73, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (231, 32, 45, 66, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (232, 33, 46, 3, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (233, 33, 46, 33, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (234, 33, 46, 50, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (235, 33, 47, 81, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (236, 33, 47, 8, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (237, 33, 47, 2, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (238, 34, 48, 19, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (239, 34, 48, 3, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (240, 34, 48, 40, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (241, 34, 48, 29, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (242, 34, 48, 34, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (243, 34, 48, 48, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (244, 34, 48, 61, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (245, 34, 48, 45, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (246, 35, 49, 80, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (247, 35, 49, 52, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (248, 35, 49, 19, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (249, 35, 49, 91, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (250, 35, 49, 59, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (251, 35, 49, 42, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (252, 36, 50, 46, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (253, 36, 50, 33, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (254, 36, 50, 4, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (255, 36, 50, 60, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (256, 36, 50, 79, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (257, 36, 50, 61, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (258, 37, 51, 13, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (259, 37, 51, 89, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (260, 37, 51, 56, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (261, 37, 51, 35, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (262, 37, 51, 20, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (263, 37, 51, 53, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (264, 37, 51, 91, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (265, 37, 51, 92, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (266, 37, 52, 58, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (267, 37, 52, 88, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (268, 37, 52, 79, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (269, 37, 52, 96, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (270, 37, 52, 73, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (271, 37, 52, 86, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (272, 37, 52, 56, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (273, 38, 53, 43, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (274, 38, 53, 56, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (275, 38, 53, 36, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (276, 38, 53, 17, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (277, 38, 53, 75, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (278, 39, 54, 68, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (279, 39, 54, 28, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (280, 39, 54, 49, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (281, 39, 54, 63, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (282, 39, 54, 23, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (283, 40, 55, 21, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (284, 40, 55, 28, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (285, 40, 55, 49, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (286, 40, 55, 63, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (287, 40, 55, 34, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (288, 40, 55, 72, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (289, 40, 55, 70, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (290, 40, 55, 15, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (291, 41, 56, 32, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (292, 41, 56, 41, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (293, 41, 56, 89, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (294, 41, 56, 50, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (295, 41, 56, 78, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (296, 41, 56, 84, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (297, 41, 56, 51, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (298, 41, 57, 58, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (299, 41, 57, 69, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (300, 41, 57, 27, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (301, 41, 57, 12, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (302, 41, 57, 78, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (303, 41, 57, 67, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (304, 42, 58, 87, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (305, 42, 58, 46, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (306, 42, 58, 96, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (307, 42, 58, 79, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (308, 42, 58, 74, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (309, 42, 58, 56, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (310, 42, 58, 77, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (311, 42, 59, 21, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (312, 42, 59, 25, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (313, 42, 59, 43, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (314, 42, 59, 11, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (315, 42, 59, 32, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (316, 43, 60, 9, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (317, 43, 60, 77, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (318, 43, 60, 81, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (319, 43, 60, 33, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (320, 43, 61, 27, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (321, 43, 61, 43, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (322, 43, 61, 37, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (323, 43, 61, 60, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (324, 43, 61, 73, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (325, 43, 61, 69, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (326, 44, 62, 85, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (327, 44, 62, 15, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (328, 44, 62, 38, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (329, 44, 62, 16, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (330, 44, 62, 8, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (331, 45, 63, 25, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (332, 45, 63, 56, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (333, 45, 63, 4, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (334, 45, 63, 86, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (335, 45, 63, 29, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (336, 45, 63, 49, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (337, 45, 63, 71, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (338, 46, 64, 72, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (339, 46, 64, 16, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (340, 46, 64, 67, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (341, 46, 64, 3, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (342, 46, 64, 43, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (343, 46, 65, 67, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (344, 46, 65, 7, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (345, 46, 65, 97, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (346, 47, 66, 6, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (347, 47, 66, 56, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (348, 47, 66, 49, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (349, 47, 66, 61, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (350, 47, 66, 3, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (351, 47, 66, 98, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (352, 47, 66, 68, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (353, 47, 66, 60, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (354, 47, 67, 82, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (355, 47, 67, 2, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (356, 47, 67, 30, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (357, 47, 67, 67, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (358, 47, 67, 95, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (359, 47, 67, 92, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (360, 47, 67, 80, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (361, 47, 67, 15, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (362, 48, 68, 49, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (363, 48, 68, 74, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (364, 48, 68, 93, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (365, 48, 68, 42, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (366, 48, 69, 99, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (367, 48, 69, 6, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (368, 48, 69, 24, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (369, 48, 69, 58, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (370, 48, 69, 93, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (371, 48, 69, 38, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (372, 48, 69, 69, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (373, 48, 69, 98, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (374, 49, 70, 83, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (375, 49, 70, 92, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (376, 49, 70, 60, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (377, 49, 71, 22, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (378, 49, 71, 1, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (379, 49, 71, 20, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (380, 49, 71, 87, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (381, 50, 72, 11, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (382, 50, 72, 91, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (383, 50, 72, 72, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (384, 50, 72, 49, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (385, 50, 72, 20, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (386, 50, 72, 30, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (387, 50, 72, 74, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (388, 51, 73, 53, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (389, 51, 73, 61, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (390, 51, 73, 56, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (391, 51, 73, 20, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (392, 51, 73, 85, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (393, 51, 73, 30, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (394, 51, 74, 66, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (395, 51, 74, 84, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (396, 51, 74, 50, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (397, 51, 74, 65, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (398, 51, 74, 13, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (399, 51, 74, 42, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (400, 51, 74, 21, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (401, 51, 74, 93, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (402, 52, 75, 10, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (403, 52, 75, 51, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (404, 52, 75, 84, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (405, 52, 75, 26, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (406, 52, 75, 5, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (407, 52, 75, 43, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (408, 52, 75, 23, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (409, 52, 76, 22, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (410, 52, 76, 63, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (411, 52, 76, 58, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (412, 52, 76, 65, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (413, 52, 76, 10, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (414, 52, 76, 51, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (415, 53, 77, 28, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (416, 53, 77, 87, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (417, 53, 77, 86, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (418, 53, 77, 47, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (419, 53, 77, 60, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (420, 53, 77, 3, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (421, 53, 77, 41, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (422, 53, 78, 44, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (423, 53, 78, 98, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (424, 53, 78, 87, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (425, 53, 78, 32, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (426, 53, 78, 78, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (427, 54, 79, 77, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (428, 54, 79, 91, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (429, 54, 79, 65, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (430, 54, 79, 13, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (431, 54, 79, 66, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (432, 54, 79, 18, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (433, 54, 79, 81, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (434, 54, 79, 16, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (435, 54, 80, 7, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (436, 54, 80, 9, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (437, 54, 80, 80, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (438, 54, 80, 3, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (439, 54, 80, 47, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (440, 54, 80, 39, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (441, 55, 81, 35, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (442, 55, 81, 97, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (443, 55, 81, 99, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (444, 55, 81, 43, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (445, 55, 81, 86, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (446, 55, 81, 59, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (447, 55, 81, 39, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (448, 55, 82, 35, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (449, 55, 82, 31, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (450, 55, 82, 46, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (451, 55, 82, 97, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (452, 56, 83, 6, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (453, 56, 83, 27, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (454, 56, 83, 68, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (455, 57, 84, 69, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (456, 57, 84, 49, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (457, 57, 84, 13, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (458, 58, 85, 50, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (459, 58, 85, 74, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (460, 58, 85, 47, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (461, 58, 85, 99, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (462, 58, 85, 60, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (463, 58, 85, 62, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (464, 59, 86, 9, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (465, 59, 86, 80, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (466, 59, 86, 15, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (467, 59, 87, 14, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (468, 59, 87, 70, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (469, 59, 87, 64, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (470, 60, 88, 16, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (471, 60, 88, 65, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (472, 60, 88, 96, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (473, 60, 88, 74, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (474, 61, 89, 94, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (475, 61, 89, 90, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (476, 61, 89, 41, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (477, 61, 89, 79, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (478, 61, 89, 60, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (479, 61, 89, 10, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (480, 61, 89, 68, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (481, 61, 89, 54, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (482, 62, 90, 2, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (483, 62, 90, 38, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (484, 62, 90, 94, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (485, 62, 90, 82, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (486, 62, 91, 91, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (487, 62, 91, 57, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (488, 62, 91, 2, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (489, 63, 92, 6, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (490, 63, 92, 11, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (491, 63, 92, 10, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (492, 63, 92, 44, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (493, 63, 92, 51, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (494, 63, 92, 21, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (495, 63, 93, 61, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (496, 63, 93, 68, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (497, 63, 93, 6, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (498, 64, 94, 48, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (499, 64, 94, 47, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (500, 64, 94, 59, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (501, 64, 94, 12, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (502, 64, 94, 39, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (503, 64, 94, 41, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (504, 64, 94, 63, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (505, 65, 95, 6, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (506, 65, 95, 63, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (507, 65, 95, 77, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (508, 65, 96, 33, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (509, 65, 96, 77, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (510, 65, 96, 31, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (511, 65, 96, 40, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (512, 65, 96, 70, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (513, 66, 97, 70, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (514, 66, 97, 91, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (515, 66, 97, 81, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (516, 67, 98, 83, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (517, 67, 98, 64, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (518, 67, 98, 92, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (519, 67, 99, 44, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (520, 67, 99, 19, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (521, 67, 99, 70, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (522, 67, 99, 45, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (523, 67, 99, 77, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (524, 67, 99, 87, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (525, 68, 100, 58, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (526, 68, 100, 75, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (527, 68, 100, 31, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (528, 68, 100, 27, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (529, 68, 100, 47, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (530, 68, 100, 6, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (531, 68, 100, 54, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (532, 68, 100, 64, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (533, 68, 101, 24, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (534, 68, 101, 21, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (535, 68, 101, 43, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (536, 68, 101, 2, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (537, 68, 101, 68, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (538, 68, 101, 77, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (539, 69, 102, 83, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (540, 69, 102, 29, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (541, 69, 102, 33, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (542, 69, 102, 6, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (543, 69, 102, 93, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (544, 70, 103, 87, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (545, 70, 103, 22, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (546, 70, 103, 17, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (547, 70, 103, 18, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (548, 70, 103, 90, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (549, 70, 103, 35, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (550, 70, 103, 78, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (551, 70, 104, 6, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (552, 70, 104, 87, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (553, 70, 104, 61, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (554, 70, 104, 10, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (555, 71, 105, 8, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (556, 71, 105, 36, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (557, 71, 105, 76, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (558, 71, 105, 74, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (559, 71, 105, 19, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (560, 71, 105, 30, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (561, 71, 105, 6, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (562, 71, 106, 21, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (563, 71, 106, 67, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (564, 71, 106, 15, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (565, 71, 106, 27, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (566, 71, 106, 7, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (567, 71, 106, 45, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (568, 72, 107, 46, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (569, 72, 107, 71, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (570, 72, 107, 98, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (571, 72, 107, 7, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (572, 72, 108, 83, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (573, 72, 108, 22, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (574, 72, 108, 17, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (575, 72, 108, 51, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (576, 72, 108, 93, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (577, 72, 108, 38, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (578, 72, 108, 16, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (579, 73, 109, 55, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (580, 73, 109, 6, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (581, 73, 109, 44, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (582, 73, 109, 18, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (583, 73, 110, 95, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (584, 73, 110, 34, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (585, 73, 110, 92, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (586, 73, 110, 75, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (587, 74, 111, 45, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (588, 74, 111, 92, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (589, 74, 111, 91, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (590, 74, 111, 66, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (591, 74, 111, 48, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (592, 74, 111, 33, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (593, 74, 111, 81, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (594, 75, 112, 39, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (595, 75, 112, 89, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (596, 75, 112, 98, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (597, 75, 112, 97, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (598, 75, 112, 3, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (599, 75, 112, 100, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (600, 75, 112, 10, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (601, 75, 112, 38, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (602, 75, 113, 72, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (603, 75, 113, 40, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (604, 75, 113, 70, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (605, 75, 113, 19, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (606, 75, 113, 23, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (607, 75, 113, 12, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (608, 75, 113, 22, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (609, 76, 114, 41, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (610, 76, 114, 11, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (611, 76, 114, 54, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (612, 76, 114, 50, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (613, 76, 114, 17, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (614, 76, 114, 60, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (615, 76, 114, 93, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (616, 76, 115, 97, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (617, 76, 115, 12, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (618, 76, 115, 69, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (619, 77, 116, 56, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (620, 77, 116, 95, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (621, 77, 116, 38, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (622, 77, 116, 49, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (623, 77, 116, 26, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (624, 77, 117, 60, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (625, 77, 117, 12, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (626, 77, 117, 94, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (627, 77, 117, 56, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (628, 77, 117, 5, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (629, 78, 118, 77, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (630, 78, 118, 55, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (631, 78, 118, 21, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (632, 78, 118, 14, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (633, 78, 118, 22, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (634, 79, 119, 20, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (635, 79, 119, 87, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (636, 79, 119, 62, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (637, 79, 119, 81, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (638, 79, 119, 51, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (639, 79, 119, 38, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (640, 79, 119, 71, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (641, 79, 119, 43, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (642, 79, 120, 57, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (643, 79, 120, 23, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (644, 79, 120, 20, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (645, 79, 120, 72, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (646, 79, 120, 60, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (647, 80, 121, 42, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (648, 80, 121, 87, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (649, 80, 121, 38, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (650, 80, 121, 81, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (651, 80, 121, 79, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (652, 80, 121, 100, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (653, 80, 121, 17, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (654, 80, 121, 92, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (655, 81, 122, 71, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (656, 81, 122, 55, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (657, 81, 122, 65, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (658, 81, 122, 2, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (659, 81, 122, 13, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (660, 81, 122, 62, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (661, 81, 122, 29, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (662, 81, 122, 41, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (663, 81, 123, 35, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (664, 81, 123, 67, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (665, 81, 123, 16, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (666, 81, 123, 66, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (667, 81, 123, 92, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (668, 81, 123, 36, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (669, 81, 123, 13, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (670, 82, 124, 31, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (671, 82, 124, 53, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (672, 82, 124, 92, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (673, 82, 124, 99, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (674, 82, 124, 7, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (675, 82, 125, 2, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (676, 82, 125, 1, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (677, 82, 125, 29, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (678, 82, 125, 49, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (679, 82, 125, 66, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (680, 82, 125, 72, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (681, 83, 126, 77, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (682, 83, 126, 58, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (683, 83, 126, 22, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (684, 84, 127, 25, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (685, 84, 127, 83, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (686, 84, 127, 34, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (687, 84, 127, 89, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (688, 84, 127, 33, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (689, 85, 128, 56, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (690, 85, 128, 38, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (691, 85, 128, 58, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (692, 86, 129, 66, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (693, 86, 129, 79, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (694, 86, 129, 65, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (695, 86, 129, 95, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (696, 86, 129, 45, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (697, 86, 130, 78, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (698, 86, 130, 48, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (699, 86, 130, 89, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (700, 87, 131, 39, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (701, 87, 131, 78, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (702, 87, 131, 27, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (703, 87, 131, 81, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (704, 87, 131, 8, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (705, 88, 132, 15, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (706, 88, 132, 77, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (707, 88, 132, 64, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (708, 88, 132, 2, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (709, 88, 132, 59, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (710, 89, 133, 64, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (711, 89, 133, 32, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (712, 89, 133, 55, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (713, 89, 133, 93, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (714, 89, 133, 17, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (715, 89, 133, 5, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (716, 89, 133, 99, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (717, 89, 134, 62, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (718, 89, 134, 36, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (719, 89, 134, 56, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (720, 89, 134, 75, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (721, 89, 134, 44, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (722, 89, 134, 94, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (723, 89, 134, 30, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (724, 89, 134, 100, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (725, 90, 135, 71, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (726, 90, 135, 87, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (727, 90, 135, 83, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (728, 90, 135, 2, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (729, 90, 135, 16, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (730, 91, 136, 83, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (731, 91, 136, 63, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (732, 91, 136, 57, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (733, 91, 137, 31, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (734, 91, 137, 45, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (735, 91, 137, 3, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (736, 91, 137, 60, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (737, 92, 138, 14, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (738, 92, 138, 38, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (739, 92, 138, 49, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (740, 92, 138, 79, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (741, 92, 138, 16, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (742, 92, 139, 91, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (743, 92, 139, 16, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (744, 92, 139, 4, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (745, 92, 139, 61, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (746, 92, 139, 41, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (747, 92, 139, 42, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (748, 92, 139, 72, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (749, 93, 140, 53, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (750, 93, 140, 72, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (751, 93, 140, 94, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (752, 93, 140, 2, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (753, 93, 140, 24, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (754, 94, 141, 4, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (755, 94, 141, 71, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (756, 94, 141, 42, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (757, 94, 141, 53, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (758, 94, 141, 27, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (759, 95, 142, 93, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (760, 95, 142, 75, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (761, 95, 142, 94, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (762, 95, 142, 2, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (763, 95, 142, 18, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (764, 95, 142, 36, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (765, 95, 142, 34, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (766, 96, 143, 98, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (767, 96, 143, 83, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (768, 96, 143, 52, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (769, 96, 143, 18, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (770, 97, 144, 5, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (771, 97, 144, 53, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (772, 97, 144, 24, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (773, 97, 144, 88, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (774, 97, 144, 86, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (775, 97, 144, 66, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (776, 97, 144, 40, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (777, 98, 145, 95, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (778, 98, 145, 44, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (779, 98, 145, 38, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (780, 98, 145, 54, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (781, 98, 145, 81, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (782, 98, 145, 82, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (783, 98, 145, 93, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (784, 98, 146, 2, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (785, 98, 146, 67, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (786, 98, 146, 63, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (787, 98, 146, 93, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (788, 99, 147, 87, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (789, 99, 147, 22, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (790, 99, 147, 3, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (791, 99, 147, 19, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (792, 99, 147, 58, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (793, 99, 147, 50, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (794, 99, 147, 6, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (795, 100, 148, 19, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (796, 100, 148, 33, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (797, 100, 148, 26, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (798, 100, 148, 92, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (799, 100, 148, 65, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.add_songs_playlists VALUES (800, 7, 10, 5, 7, '2025-12-01 09:47:53.816885');


--
-- TOC entry 3917 (class 0 OID 31352)
-- Dependencies: 229
-- Data for Name: artist_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.artist_promotion VALUES (6, 6, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (8, 8, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (9, 9, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (12, 12, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (13, 13, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (14, 14, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (15, 15, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (16, 16, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (20, 20, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (22, 22, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (23, 24, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (24, 25, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (27, 34, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (28, 29, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (30, 31, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (33, 35, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (34, 36, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (35, 37, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (37, 39, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (42, 45, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (43, 46, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (44, 47, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (46, 81, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (47, 50, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (50, 53, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (55, 69, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (57, 71, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (62, 76, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (63, 77, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (67, 85, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (68, 86, 'Check my new stuff!');
INSERT INTO public.artist_promotion VALUES (70, 89, 'Check my new stuff!');


--
-- TOC entry 3915 (class 0 OID 31327)
-- Dependencies: 227
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.artists VALUES (58, 'Jennifer Lopez', NULL, 13748794, 'https://i.scdn.co/image/ab6761610000e5eb48e24f77a03f78a00cfda0bb', 'contact.58@label.com', NULL, 0);
INSERT INTO public.artists VALUES (17, 'CKay', NULL, 1730684, 'https://i.scdn.co/image/ab6761610000e5eb0c09347b3eb8879406da7dca', 'contact.17@label.com', NULL, 2);
INSERT INTO public.artists VALUES (45, 'Tungevaag', NULL, 176031, 'https://i.scdn.co/image/ab6761610000e5eb234623bc1c596eb2f3d94180', 'contact.45@label.com', NULL, 1);
INSERT INTO public.artists VALUES (24, 'Queen', NULL, 55453661, 'https://i.scdn.co/image/b040846ceba13c3e9c125d68389491094e7f2982', 'contact.24@label.com', NULL, 2);
INSERT INTO public.artists VALUES (22, 'Woza Logan', NULL, 697, 'https://i.scdn.co/image/ab6761610000e5ebd9038398713e24bcbdb4602c', 'contact.22@label.com', NULL, 2);
INSERT INTO public.artists VALUES (20, 'BJ Lips', NULL, 169951, 'https://i.scdn.co/image/ab6761610000e5eb84848d263662f164b2d3d37c', 'contact.20@label.com', NULL, 1);
INSERT INTO public.artists VALUES (43, 'Bibio', NULL, 276061, 'https://i.scdn.co/image/ab6761610000e5ebc6f8c3e1e5db20e02a26bcf2', 'contact.43@label.com', NULL, 4);
INSERT INTO public.artists VALUES (70, 'G.E.M.', NULL, 3537769, 'https://i.scdn.co/image/ab6761610000e5eb8b385b6aa7b47570adbeff7b', 'contact.70@label.com', NULL, 4);
INSERT INTO public.artists VALUES (4, 'Jeff Buckley', NULL, 2342147, 'https://i.scdn.co/image/67779606c7f151618a28f62b1d24fb514d39dacf', 'contact.4@label.com', NULL, 2);
INSERT INTO public.artists VALUES (7, 'Rihanna', NULL, 69619520, 'https://i.scdn.co/image/ab6761610000e5ebcb565a8e684e3be458d329ac', 'contact.7@label.com', NULL, 7);
INSERT INTO public.artists VALUES (67, 'Bring Me The Horizon', NULL, 6671498, 'https://i.scdn.co/image/ab6761610000e5ebe7c9399d0b5d813c20cbec65', 'contact.67@label.com', NULL, 1);
INSERT INTO public.artists VALUES (42, 'Ravyn Lenae', NULL, 875307, 'https://i.scdn.co/image/ab6761610000e5eb138d70fe372dedacdca53b61', 'contact.42@label.com', NULL, 3);
INSERT INTO public.artists VALUES (33, 'The Walters', NULL, 1062601, 'https://i.scdn.co/image/ab6761610000e5ebb63c6c447c9c484c6e87d509', 'contact.33@label.com', NULL, 5);
INSERT INTO public.artists VALUES (68, 'Bad Bunny', NULL, 103722263, 'https://i.scdn.co/image/ab6761610000e5eb81f47f44084e0a09b5f0fa13', 'contact.68@label.com', NULL, 2);
INSERT INTO public.artists VALUES (40, 'Nirvana', NULL, 23618098, 'https://i.scdn.co/image/84282c28d851a700132356381fcfbadc67ff498b', 'contact.40@label.com', NULL, 4);
INSERT INTO public.artists VALUES (32, 'Indila', NULL, 2579892, 'https://i.scdn.co/image/ab6761610000e5eb6cd07d169e7e2ec94193a1d2', 'contact.32@label.com', NULL, 3);
INSERT INTO public.artists VALUES (5, 'Ariana Grande', NULL, 107890555, 'https://i.scdn.co/image/ab6761610000e5eb6725802588d7dc1aba076ca5', 'contact.5@label.com', NULL, 3);
INSERT INTO public.artists VALUES (50, 'Nicky Jam', NULL, 20708998, 'https://i.scdn.co/image/ab6761610000e5eb45780f160ed896e42b6d17b0', 'contact.50@label.com', NULL, 2);
INSERT INTO public.artists VALUES (14, 'Edison Lighthouse', NULL, 68513, 'https://i.scdn.co/image/ab6761610000e5ebd4463af78a41ea5b1bd481d7', 'contact.14@label.com', NULL, 1);
INSERT INTO public.artists VALUES (57, 'Judika', NULL, 7004398, 'https://i.scdn.co/image/ab6761610000e5eb182818f4b3724670f8c5e9f5', 'contact.57@label.com', NULL, 3);
INSERT INTO public.artists VALUES (10, 'SLANDER', NULL, 596027, 'https://i.scdn.co/image/ab6761610000e5eb9b8109ae98ff2e165c89ba72', 'contact.10@label.com', NULL, 2);
INSERT INTO public.artists VALUES (47, 'Elvis Presley', NULL, 11071673, 'https://i.scdn.co/image/ab6761610000e5eb9a93e273380982dff84c0d7c', 'contact.47@label.com', NULL, 5);
INSERT INTO public.artists VALUES (8, 'SECRET NUMBER', NULL, 264376, 'https://i.scdn.co/image/ab6761610000e5eb4a0c6368275d8c1886b6f553', 'contact.8@label.com', NULL, 6);
INSERT INTO public.artists VALUES (25, 'Lexz', NULL, 17057, 'https://i.scdn.co/image/ab6761610000e5ebd043eac149a5f3e13f18e742', 'contact.25@label.com', NULL, 4);
INSERT INTO public.artists VALUES (34, 'Mitski', NULL, 11124491, 'https://i.scdn.co/image/ab6761610000e5eb4bdb3888818637acb71c4a13', 'contact.34@label.com', NULL, 4);
INSERT INTO public.artists VALUES (11, 'Selena Gomez & The Scene', NULL, 10416656, 'https://i.scdn.co/image/469b6a74f5ddca9560e9f5137842e3772c8576c0', 'contact.11@label.com', NULL, 5);
INSERT INTO public.artists VALUES (52, 'Sabrina Carpenter', NULL, 27207975, 'https://i.scdn.co/image/ab6761610000e5eb78e45cfa4697ce3c437cb455', 'contact.52@label.com', NULL, 3);
INSERT INTO public.artists VALUES (35, 'Vierra', NULL, 2488673, 'https://i.scdn.co/image/ab6761610000e5ebce05aec92bc5b3e81205ff73', 'contact.35@label.com', NULL, 7);
INSERT INTO public.artists VALUES (54, 'Wale', NULL, 4302565, 'https://i.scdn.co/image/ab6761610000e5eb273bdadffd7138dcbd7b79c3', 'contact.54@label.com', NULL, 2);
INSERT INTO public.artists VALUES (51, 'Hindia', NULL, 11551080, 'https://i.scdn.co/image/ab6761610000e5eb8022c4a018990cd93a9ddfe0', 'contact.51@label.com', NULL, 5);
INSERT INTO public.artists VALUES (19, 'The Cardigans', NULL, 1690913, 'https://i.scdn.co/image/ab6761610000e5eb4458cf04006a95a1afa067f0', 'contact.19@label.com', NULL, 2);
INSERT INTO public.artists VALUES (31, 'iKON', NULL, 3592128, 'https://i.scdn.co/image/ab6761610000e5eb8eb5e57e526ceb14f06ea203', 'contact.31@label.com', NULL, 2);
INSERT INTO public.artists VALUES (28, 'TV Girl', NULL, 12789946, 'https://i.scdn.co/image/ab6761610000e5ebd80695211689a9c8c3fee3b0', 'contact.28@label.com', NULL, 4);
INSERT INTO public.artists VALUES (27, 'Taylor Swift', NULL, 146900170, 'https://i.scdn.co/image/ab6761610000e5ebe2e8e7ff002a4afda1c7147e', 'contact.27@label.com', NULL, 6);
INSERT INTO public.artists VALUES (26, 'Ellie Goulding', NULL, 13272083, 'https://i.scdn.co/image/ab6761610000e5eb69266d088d2ab5c74e028863', 'contact.26@label.com', NULL, 4);
INSERT INTO public.artists VALUES (65, 'Rombongan Bodonk Koplo', NULL, 39789, 'https://i.scdn.co/image/ab6761610000e5eb20ca1bfde697b09680fd7347', 'contact.65@label.com', NULL, 4);
INSERT INTO public.artists VALUES (36, 'Monotone Gift', NULL, 7, 'https://i.scdn.co/image/ab6742d3000053b7fa659bc7be038134fc2be2b3', 'contact.36@label.com', NULL, 5);
INSERT INTO public.artists VALUES (9, 'Freddie Mercury', NULL, 7008639, 'https://i.scdn.co/image/ab6761610000e5eb1052b77abd7f89485562d797', 'contact.9@label.com', NULL, 2);
INSERT INTO public.artists VALUES (59, 'Al-Ghazali', NULL, 68752, 'https://i.scdn.co/image/ab67616d0000b273c2737e0f45f4cc433ba69b11', 'contact.59@label.com', NULL, 6);
INSERT INTO public.artists VALUES (29, 'Kendrick Lamar', NULL, 45023550, 'https://i.scdn.co/image/ab6761610000e5eb39ba6dcd4355c03de0b50918', 'contact.29@label.com', NULL, 5);
INSERT INTO public.artists VALUES (62, 'Lana Del Rey', NULL, 52502926, 'https://i.scdn.co/image/ab6761610000e5ebb99cacf8acd5378206767261', 'contact.62@label.com', NULL, 2);
INSERT INTO public.artists VALUES (69, 'BTS', NULL, 81487075, 'https://i.scdn.co/image/ab6761610000e5ebd642648235ebf3460d2d1f6a', 'contact.69@label.com', NULL, 2);
INSERT INTO public.artists VALUES (1, 'Laufey', NULL, 8703092, 'https://i.scdn.co/image/ab6761610000e5eb98c2527b85500f68f53084f2', 'contact.1@label.com', NULL, 7);
INSERT INTO public.artists VALUES (53, 'Lost Sky', NULL, 353718, 'https://i.scdn.co/image/ab6761610000e5ebc5a27c631d60a8b0c99eff59', 'contact.53@label.com', NULL, 6);
INSERT INTO public.artists VALUES (6, 'BLACKPINK', NULL, 56471290, 'https://i.scdn.co/image/ab6761610000e5eb9b57f5eccf180a0049be84b3', 'contact.6@label.com', NULL, 9);
INSERT INTO public.artists VALUES (3, 'Kristen Bell', NULL, 165183, 'https://i.scdn.co/image/4696b636f6be50265a1226814629eea4ed48a8e6', 'contact.3@label.com', NULL, 5);
INSERT INTO public.artists VALUES (41, 'SEU Worship', NULL, 199035, 'https://i.scdn.co/image/ab6761610000e5ebec3b45dab30f22021ec19f51', 'contact.41@label.com', NULL, 4);
INSERT INTO public.artists VALUES (73, 'Snarky Puppy', NULL, 764233, 'https://i.scdn.co/image/ab6761610000e5eb7fcb79b9805f93d9cedb5346', 'contact.73@label.com', NULL, 2);
INSERT INTO public.artists VALUES (60, 'The Weeknd', NULL, 114242793, 'https://i.scdn.co/image/ab6761610000e5eb9e528993a2820267b97f6aae', 'contact.60@label.com', NULL, 6);
INSERT INTO public.artists VALUES (30, 'Justin Bieber', NULL, 85439022, 'https://i.scdn.co/image/ab6761610000e5ebaf20f7db5288bce9beede034', 'contact.30@label.com', NULL, 6);
INSERT INTO public.artists VALUES (16, 'Beyoncé', NULL, 41384984, 'https://i.scdn.co/image/ab6761610000e5eb7eaa373538359164b843f7c0', 'contact.16@label.com', NULL, 4);
INSERT INTO public.artists VALUES (46, 'The Corrs', NULL, 1271944, 'https://i.scdn.co/image/ab6761610000e5ebde0ef21e54809a4c88a81ab6', 'contact.46@label.com', NULL, 5);
INSERT INTO public.artists VALUES (15, 'Little Mix', NULL, 12327089, 'https://i.scdn.co/image/ab6761610000e5eb08cd53940cbf5813ee5fe565', 'contact.15@label.com', NULL, 1);
INSERT INTO public.artists VALUES (66, 'Elevation Worship', NULL, 5163604, 'https://i.scdn.co/image/ab6761610000e5eb6fa137c74960a6a81f11ee70', 'contact.66@label.com', NULL, 5);
INSERT INTO public.artists VALUES (12, 'Delaney Bailey', NULL, 294480, 'https://i.scdn.co/image/ab6761610000e5eb89415c6dbafb0a674deb07a5', 'contact.12@label.com', NULL, 6);
INSERT INTO public.artists VALUES (71, 'Illusion Hills', NULL, 10274, 'https://i.scdn.co/image/ab6761610000e5eb0f87226b7190eec016873fb6', 'contact.71@label.com', NULL, 3);
INSERT INTO public.artists VALUES (44, 'Jamiroquai', NULL, 2779061, 'https://i.scdn.co/image/ab6761610000e5eb7e6dca959714339b69e9718d', 'contact.44@label.com', NULL, 4);
INSERT INTO public.artists VALUES (55, 'Bazzi', NULL, 5512461, 'https://i.scdn.co/image/ab6761610000e5eb901476fdd0fd274362d445db', 'contact.55@label.com', NULL, 5);
INSERT INTO public.artists VALUES (56, 'Melly Goeslaw', NULL, 1516832, 'https://i.scdn.co/image/ab6761610000e5eb92e8b7d478b17586c9329a60', 'contact.56@label.com', NULL, 5);
INSERT INTO public.artists VALUES (18, 'Billie Eilish', NULL, 119716727, 'https://i.scdn.co/image/ab6761610000e5eb4a21b4760d2ecb7b0dcdc8da', 'contact.18@label.com', NULL, 8);
INSERT INTO public.artists VALUES (61, 'Kahitna', NULL, 1294721, 'https://i.scdn.co/image/ab6761610000e5ebe8b3eb71335b453ac794067e', 'contact.61@label.com', NULL, 4);
INSERT INTO public.artists VALUES (21, 'LOVELI LORI', NULL, 213521, 'https://i.scdn.co/image/ab6761610000e5ebae07056ccd6afb4cb53deef4', 'contact.21@label.com', NULL, 5);
INSERT INTO public.artists VALUES (38, 'Céline Dion', NULL, 10412991, 'https://i.scdn.co/image/ab6761610000e5ebc3b380448158e7b6e5863cde', 'contact.38@label.com', NULL, 4);
INSERT INTO public.artists VALUES (37, 'Imagine Dragons', NULL, 58554322, 'https://i.scdn.co/image/ab6761610000e5ebab47d8dae2b24f5afe7f9d38', 'contact.37@label.com', NULL, 4);
INSERT INTO public.artists VALUES (2, 'IU', NULL, 9453595, 'https://i.scdn.co/image/ab6761610000e5eb789f38042e5ef8911fc3826b', 'contact.2@label.com', NULL, 8);
INSERT INTO public.artists VALUES (39, 'Sody', NULL, 175902, 'https://i.scdn.co/image/ab6761610000e5eb0a6460f02b3e357370501916', 'contact.39@label.com', NULL, 6);
INSERT INTO public.artists VALUES (72, 'PSYCHIC FEVER from EXILE TRIBE', NULL, 108656, 'https://i.scdn.co/image/ab6761610000e5eb7e966497c8cfa0b2a0f71a73', 'contact.72@label.com', NULL, 7);
INSERT INTO public.artists VALUES (63, 'Clean Bandit', NULL, 6004496, 'https://i.scdn.co/image/ab6761610000e5eb70d80b8ab8e193aef64223ec', 'contact.63@label.com', NULL, 8);
INSERT INTO public.artists VALUES (49, '.Feast', NULL, 5100085, 'https://i.scdn.co/image/ab6761610000e5eb16f030ca05d4d917cdc2eb5e', 'contact.49@label.com', NULL, 3);
INSERT INTO public.artists VALUES (48, 'Nujabes', NULL, 1555885, 'https://i.scdn.co/image/ab6761610000e5eb57f19d2f179b00207bfb3155', 'contact.48@label.com', NULL, 5);
INSERT INTO public.artists VALUES (23, 'MeloMance', NULL, 397198, 'https://i.scdn.co/image/ab6761610000e5eba0e601a6151cf62e4ff2ced2', 'contact.23@label.com', NULL, 7);
INSERT INTO public.artists VALUES (64, 'Daniel Caesar', NULL, 11472410, 'https://i.scdn.co/image/ab6761610000e5ebe4d94f7cbebb17504c25d419', 'contact.64@label.com', NULL, 3);
INSERT INTO public.artists VALUES (13, 'Reality Club', NULL, 645788, 'https://i.scdn.co/image/ab6761610000e5ebd9a9a4eb30f0a26c250e47e1', 'contact.13@label.com', NULL, 6);


--
-- TOC entry 3916 (class 0 OID 31342)
-- Dependencies: 228
-- Data for Name: artists_tours; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.artists_tours VALUES (1, 58);
INSERT INTO public.artists_tours VALUES (2, 39);
INSERT INTO public.artists_tours VALUES (3, 39);
INSERT INTO public.artists_tours VALUES (4, 32);
INSERT INTO public.artists_tours VALUES (4, 19);
INSERT INTO public.artists_tours VALUES (5, 50);


--
-- TOC entry 3919 (class 0 OID 31374)
-- Dependencies: 231
-- Data for Name: block_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.block_users VALUES (43, 100);
INSERT INTO public.block_users VALUES (84, 67);
INSERT INTO public.block_users VALUES (31, 84);
INSERT INTO public.block_users VALUES (19, 74);
INSERT INTO public.block_users VALUES (13, 51);


--
-- TOC entry 3918 (class 0 OID 31364)
-- Dependencies: 230
-- Data for Name: blocklist_artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.blocklist_artists VALUES (56, 81);
INSERT INTO public.blocklist_artists VALUES (3, 61);
INSERT INTO public.blocklist_artists VALUES (13, 58);
INSERT INTO public.blocklist_artists VALUES (9, 54);
INSERT INTO public.blocklist_artists VALUES (64, 36);


--
-- TOC entry 3922 (class 0 OID 31408)
-- Dependencies: 234
-- Data for Name: collection_library; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.collection_library VALUES (1, 3);
INSERT INTO public.collection_library VALUES (2, 25);
INSERT INTO public.collection_library VALUES (3, 17);
INSERT INTO public.collection_library VALUES (4, 6);
INSERT INTO public.collection_library VALUES (5, 46);
INSERT INTO public.collection_library VALUES (6, 11);
INSERT INTO public.collection_library VALUES (7, 60);
INSERT INTO public.collection_library VALUES (8, 78);
INSERT INTO public.collection_library VALUES (9, 4);
INSERT INTO public.collection_library VALUES (10, 70);
INSERT INTO public.collection_library VALUES (11, 68);
INSERT INTO public.collection_library VALUES (12, 74);
INSERT INTO public.collection_library VALUES (13, 16);
INSERT INTO public.collection_library VALUES (14, 73);
INSERT INTO public.collection_library VALUES (15, 73);
INSERT INTO public.collection_library VALUES (16, 81);
INSERT INTO public.collection_library VALUES (17, 91);
INSERT INTO public.collection_library VALUES (18, 57);
INSERT INTO public.collection_library VALUES (19, 26);
INSERT INTO public.collection_library VALUES (20, 75);
INSERT INTO public.collection_library VALUES (21, 6);
INSERT INTO public.collection_library VALUES (22, 77);
INSERT INTO public.collection_library VALUES (23, 87);
INSERT INTO public.collection_library VALUES (24, 38);
INSERT INTO public.collection_library VALUES (25, 67);
INSERT INTO public.collection_library VALUES (26, 60);
INSERT INTO public.collection_library VALUES (27, 68);
INSERT INTO public.collection_library VALUES (28, 68);
INSERT INTO public.collection_library VALUES (29, 61);
INSERT INTO public.collection_library VALUES (30, 2);
INSERT INTO public.collection_library VALUES (31, 64);
INSERT INTO public.collection_library VALUES (32, 37);
INSERT INTO public.collection_library VALUES (33, 24);
INSERT INTO public.collection_library VALUES (34, 10);
INSERT INTO public.collection_library VALUES (35, 47);
INSERT INTO public.collection_library VALUES (36, 35);
INSERT INTO public.collection_library VALUES (37, 65);
INSERT INTO public.collection_library VALUES (38, 77);
INSERT INTO public.collection_library VALUES (39, 58);
INSERT INTO public.collection_library VALUES (40, 44);
INSERT INTO public.collection_library VALUES (41, 3);
INSERT INTO public.collection_library VALUES (42, 64);
INSERT INTO public.collection_library VALUES (43, 35);
INSERT INTO public.collection_library VALUES (44, 11);
INSERT INTO public.collection_library VALUES (45, 29);
INSERT INTO public.collection_library VALUES (46, 71);
INSERT INTO public.collection_library VALUES (47, 12);
INSERT INTO public.collection_library VALUES (48, 88);
INSERT INTO public.collection_library VALUES (49, 11);
INSERT INTO public.collection_library VALUES (50, 65);
INSERT INTO public.collection_library VALUES (51, 88);
INSERT INTO public.collection_library VALUES (52, 13);
INSERT INTO public.collection_library VALUES (53, 36);
INSERT INTO public.collection_library VALUES (54, 16);
INSERT INTO public.collection_library VALUES (55, 55);
INSERT INTO public.collection_library VALUES (56, 87);
INSERT INTO public.collection_library VALUES (57, 27);
INSERT INTO public.collection_library VALUES (58, 48);
INSERT INTO public.collection_library VALUES (59, 24);
INSERT INTO public.collection_library VALUES (60, 13);
INSERT INTO public.collection_library VALUES (61, 63);
INSERT INTO public.collection_library VALUES (62, 26);
INSERT INTO public.collection_library VALUES (63, 71);
INSERT INTO public.collection_library VALUES (64, 53);
INSERT INTO public.collection_library VALUES (65, 49);
INSERT INTO public.collection_library VALUES (66, 51);
INSERT INTO public.collection_library VALUES (67, 14);
INSERT INTO public.collection_library VALUES (68, 22);
INSERT INTO public.collection_library VALUES (69, 13);
INSERT INTO public.collection_library VALUES (70, 2);
INSERT INTO public.collection_library VALUES (71, 43);
INSERT INTO public.collection_library VALUES (72, 61);
INSERT INTO public.collection_library VALUES (73, 29);
INSERT INTO public.collection_library VALUES (74, 87);
INSERT INTO public.collection_library VALUES (75, 24);
INSERT INTO public.collection_library VALUES (76, 81);
INSERT INTO public.collection_library VALUES (77, 81);
INSERT INTO public.collection_library VALUES (78, 61);
INSERT INTO public.collection_library VALUES (79, 17);
INSERT INTO public.collection_library VALUES (80, 75);
INSERT INTO public.collection_library VALUES (81, 4);
INSERT INTO public.collection_library VALUES (82, 22);
INSERT INTO public.collection_library VALUES (83, 59);
INSERT INTO public.collection_library VALUES (84, 76);
INSERT INTO public.collection_library VALUES (85, 32);
INSERT INTO public.collection_library VALUES (86, 64);
INSERT INTO public.collection_library VALUES (87, 92);
INSERT INTO public.collection_library VALUES (88, 41);
INSERT INTO public.collection_library VALUES (89, 43);
INSERT INTO public.collection_library VALUES (90, 5);
INSERT INTO public.collection_library VALUES (91, 47);
INSERT INTO public.collection_library VALUES (92, 39);
INSERT INTO public.collection_library VALUES (93, 41);
INSERT INTO public.collection_library VALUES (94, 25);
INSERT INTO public.collection_library VALUES (95, 64);
INSERT INTO public.collection_library VALUES (96, 48);
INSERT INTO public.collection_library VALUES (97, 51);
INSERT INTO public.collection_library VALUES (98, 44);
INSERT INTO public.collection_library VALUES (99, 85);
INSERT INTO public.collection_library VALUES (100, 24);


--
-- TOC entry 3923 (class 0 OID 31418)
-- Dependencies: 235
-- Data for Name: collection_top_3_genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.collection_top_3_genres VALUES (3, 2);
INSERT INTO public.collection_top_3_genres VALUES (3, 1);
INSERT INTO public.collection_top_3_genres VALUES (4, 2);
INSERT INTO public.collection_top_3_genres VALUES (4, 1);
INSERT INTO public.collection_top_3_genres VALUES (5, 3);
INSERT INTO public.collection_top_3_genres VALUES (6, 1);
INSERT INTO public.collection_top_3_genres VALUES (7, 2);
INSERT INTO public.collection_top_3_genres VALUES (7, 3);
INSERT INTO public.collection_top_3_genres VALUES (8, 1);
INSERT INTO public.collection_top_3_genres VALUES (9, 2);
INSERT INTO public.collection_top_3_genres VALUES (9, 1);
INSERT INTO public.collection_top_3_genres VALUES (10, 4);
INSERT INTO public.collection_top_3_genres VALUES (10, 6);
INSERT INTO public.collection_top_3_genres VALUES (11, 6);
INSERT INTO public.collection_top_3_genres VALUES (11, 2);
INSERT INTO public.collection_top_3_genres VALUES (12, 2);
INSERT INTO public.collection_top_3_genres VALUES (12, 1);
INSERT INTO public.collection_top_3_genres VALUES (13, 8);
INSERT INTO public.collection_top_3_genres VALUES (14, 6);
INSERT INTO public.collection_top_3_genres VALUES (14, 5);
INSERT INTO public.collection_top_3_genres VALUES (15, 7);
INSERT INTO public.collection_top_3_genres VALUES (15, 3);
INSERT INTO public.collection_top_3_genres VALUES (16, 6);
INSERT INTO public.collection_top_3_genres VALUES (16, 3);
INSERT INTO public.collection_top_3_genres VALUES (17, 10);
INSERT INTO public.collection_top_3_genres VALUES (17, 9);
INSERT INTO public.collection_top_3_genres VALUES (18, 2);
INSERT INTO public.collection_top_3_genres VALUES (18, 8);
INSERT INTO public.collection_top_3_genres VALUES (19, 13);
INSERT INTO public.collection_top_3_genres VALUES (20, 12);
INSERT INTO public.collection_top_3_genres VALUES (20, 1);
INSERT INTO public.collection_top_3_genres VALUES (21, 4);
INSERT INTO public.collection_top_3_genres VALUES (21, 2);
INSERT INTO public.collection_top_3_genres VALUES (22, 14);
INSERT INTO public.collection_top_3_genres VALUES (22, 15);
INSERT INTO public.collection_top_3_genres VALUES (23, 11);
INSERT INTO public.collection_top_3_genres VALUES (23, 12);
INSERT INTO public.collection_top_3_genres VALUES (24, 2);
INSERT INTO public.collection_top_3_genres VALUES (24, 1);
INSERT INTO public.collection_top_3_genres VALUES (25, 17);
INSERT INTO public.collection_top_3_genres VALUES (25, 18);
INSERT INTO public.collection_top_3_genres VALUES (26, 9);
INSERT INTO public.collection_top_3_genres VALUES (26, 17);
INSERT INTO public.collection_top_3_genres VALUES (27, 17);
INSERT INTO public.collection_top_3_genres VALUES (27, 18);
INSERT INTO public.collection_top_3_genres VALUES (28, 13);
INSERT INTO public.collection_top_3_genres VALUES (28, 8);
INSERT INTO public.collection_top_3_genres VALUES (29, 1);
INSERT INTO public.collection_top_3_genres VALUES (29, 5);
INSERT INTO public.collection_top_3_genres VALUES (30, 19);
INSERT INTO public.collection_top_3_genres VALUES (30, 20);
INSERT INTO public.collection_top_3_genres VALUES (31, 13);
INSERT INTO public.collection_top_3_genres VALUES (31, 7);
INSERT INTO public.collection_top_3_genres VALUES (32, 1);
INSERT INTO public.collection_top_3_genres VALUES (33, 21);
INSERT INTO public.collection_top_3_genres VALUES (35, 4);
INSERT INTO public.collection_top_3_genres VALUES (35, 20);
INSERT INTO public.collection_top_3_genres VALUES (36, 10);
INSERT INTO public.collection_top_3_genres VALUES (36, 16);
INSERT INTO public.collection_top_3_genres VALUES (37, 22);
INSERT INTO public.collection_top_3_genres VALUES (38, 6);
INSERT INTO public.collection_top_3_genres VALUES (38, 3);
INSERT INTO public.collection_top_3_genres VALUES (39, 21);
INSERT INTO public.collection_top_3_genres VALUES (39, 3);
INSERT INTO public.collection_top_3_genres VALUES (40, 23);
INSERT INTO public.collection_top_3_genres VALUES (41, 10);
INSERT INTO public.collection_top_3_genres VALUES (41, 5);
INSERT INTO public.collection_top_3_genres VALUES (42, 13);
INSERT INTO public.collection_top_3_genres VALUES (42, 19);
INSERT INTO public.collection_top_3_genres VALUES (43, 24);
INSERT INTO public.collection_top_3_genres VALUES (43, 17);
INSERT INTO public.collection_top_3_genres VALUES (44, 26);
INSERT INTO public.collection_top_3_genres VALUES (44, 25);
INSERT INTO public.collection_top_3_genres VALUES (45, 29);
INSERT INTO public.collection_top_3_genres VALUES (45, 28);
INSERT INTO public.collection_top_3_genres VALUES (46, 31);
INSERT INTO public.collection_top_3_genres VALUES (46, 30);
INSERT INTO public.collection_top_3_genres VALUES (47, 32);
INSERT INTO public.collection_top_3_genres VALUES (48, 33);
INSERT INTO public.collection_top_3_genres VALUES (49, 34);
INSERT INTO public.collection_top_3_genres VALUES (50, 35);
INSERT INTO public.collection_top_3_genres VALUES (50, 36);
INSERT INTO public.collection_top_3_genres VALUES (34, 6);
INSERT INTO public.collection_top_3_genres VALUES (34, 7);
INSERT INTO public.collection_top_3_genres VALUES (34, 21);
INSERT INTO public.collection_top_3_genres VALUES (51, 37);
INSERT INTO public.collection_top_3_genres VALUES (53, 41);
INSERT INTO public.collection_top_3_genres VALUES (53, 40);
INSERT INTO public.collection_top_3_genres VALUES (55, 22);
INSERT INTO public.collection_top_3_genres VALUES (55, 8);
INSERT INTO public.collection_top_3_genres VALUES (56, 3);
INSERT INTO public.collection_top_3_genres VALUES (57, 3);
INSERT INTO public.collection_top_3_genres VALUES (58, 3);
INSERT INTO public.collection_top_3_genres VALUES (59, 3);
INSERT INTO public.collection_top_3_genres VALUES (62, 2);
INSERT INTO public.collection_top_3_genres VALUES (62, 21);
INSERT INTO public.collection_top_3_genres VALUES (63, 3);
INSERT INTO public.collection_top_3_genres VALUES (64, 39);
INSERT INTO public.collection_top_3_genres VALUES (64, 8);
INSERT INTO public.collection_top_3_genres VALUES (60, 39);
INSERT INTO public.collection_top_3_genres VALUES (60, 22);
INSERT INTO public.collection_top_3_genres VALUES (60, 38);
INSERT INTO public.collection_top_3_genres VALUES (65, 34);
INSERT INTO public.collection_top_3_genres VALUES (65, 9);
INSERT INTO public.collection_top_3_genres VALUES (66, 39);
INSERT INTO public.collection_top_3_genres VALUES (66, 38);
INSERT INTO public.collection_top_3_genres VALUES (67, 22);
INSERT INTO public.collection_top_3_genres VALUES (67, 8);
INSERT INTO public.collection_top_3_genres VALUES (61, 3);
INSERT INTO public.collection_top_3_genres VALUES (54, 22);
INSERT INTO public.collection_top_3_genres VALUES (54, 8);
INSERT INTO public.collection_top_3_genres VALUES (68, 22);
INSERT INTO public.collection_top_3_genres VALUES (68, 8);
INSERT INTO public.collection_top_3_genres VALUES (52, 8);
INSERT INTO public.collection_top_3_genres VALUES (52, 39);
INSERT INTO public.collection_top_3_genres VALUES (52, 38);
INSERT INTO public.collection_top_3_genres VALUES (69, 21);
INSERT INTO public.collection_top_3_genres VALUES (69, 1);
INSERT INTO public.collection_top_3_genres VALUES (70, 22);
INSERT INTO public.collection_top_3_genres VALUES (70, 42);
INSERT INTO public.collection_top_3_genres VALUES (71, 42);
INSERT INTO public.collection_top_3_genres VALUES (71, 43);
INSERT INTO public.collection_top_3_genres VALUES (72, 36);
INSERT INTO public.collection_top_3_genres VALUES (72, 20);
INSERT INTO public.collection_top_3_genres VALUES (73, 22);
INSERT INTO public.collection_top_3_genres VALUES (74, 10);
INSERT INTO public.collection_top_3_genres VALUES (74, 35);
INSERT INTO public.collection_top_3_genres VALUES (75, 22);
INSERT INTO public.collection_top_3_genres VALUES (75, 44);
INSERT INTO public.collection_top_3_genres VALUES (76, 29);
INSERT INTO public.collection_top_3_genres VALUES (76, 26);
INSERT INTO public.collection_top_3_genres VALUES (77, 15);
INSERT INTO public.collection_top_3_genres VALUES (77, 30);
INSERT INTO public.collection_top_3_genres VALUES (78, 26);
INSERT INTO public.collection_top_3_genres VALUES (78, 19);
INSERT INTO public.collection_top_3_genres VALUES (79, 45);
INSERT INTO public.collection_top_3_genres VALUES (79, 49);
INSERT INTO public.collection_top_3_genres VALUES (80, 42);
INSERT INTO public.collection_top_3_genres VALUES (80, 43);
INSERT INTO public.collection_top_3_genres VALUES (81, 34);
INSERT INTO public.collection_top_3_genres VALUES (82, 23);
INSERT INTO public.collection_top_3_genres VALUES (83, 50);
INSERT INTO public.collection_top_3_genres VALUES (83, 26);
INSERT INTO public.collection_top_3_genres VALUES (84, 51);
INSERT INTO public.collection_top_3_genres VALUES (84, 26);
INSERT INTO public.collection_top_3_genres VALUES (85, 55);
INSERT INTO public.collection_top_3_genres VALUES (85, 56);
INSERT INTO public.collection_top_3_genres VALUES (86, 41);
INSERT INTO public.collection_top_3_genres VALUES (86, 57);
INSERT INTO public.collection_top_3_genres VALUES (87, 1);
INSERT INTO public.collection_top_3_genres VALUES (88, 52);
INSERT INTO public.collection_top_3_genres VALUES (88, 50);
INSERT INTO public.collection_top_3_genres VALUES (89, 60);
INSERT INTO public.collection_top_3_genres VALUES (89, 59);
INSERT INTO public.collection_top_3_genres VALUES (90, 64);
INSERT INTO public.collection_top_3_genres VALUES (91, 65);
INSERT INTO public.collection_top_3_genres VALUES (92, 70);
INSERT INTO public.collection_top_3_genres VALUES (92, 66);
INSERT INTO public.collection_top_3_genres VALUES (2, 1);
INSERT INTO public.collection_top_3_genres VALUES (2, 2);
INSERT INTO public.collection_top_3_genres VALUES (2, 4);


--
-- TOC entry 3920 (class 0 OID 31384)
-- Dependencies: 232
-- Data for Name: collections; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.collections VALUES (2, 'Love wins all', 'Single', 'https://i.scdn.co/image/ab67616d0000b273b79a12d47af18d1d83a5caf9', '2024-01-24', NULL, false);
INSERT INTO public.collections VALUES (7, 'Unapologetic (Deluxe)', 'Album', 'https://i.scdn.co/image/ab67616d0000b2736dee21d6cd1823e4d6231d37', '2012-12-11', NULL, false);
INSERT INTO public.collections VALUES (16, '4', 'Album', 'https://i.scdn.co/image/ab67616d0000b273ff5429125128b43572dbdccd', '2011-06-24', NULL, false);
INSERT INTO public.collections VALUES (27, 'Delirium (Deluxe)', 'Album', 'https://i.scdn.co/image/ab67616d0000b2736bdee14242f244d9d6ddf2fd', '2015-11-06', NULL, false);
INSERT INTO public.collections VALUES (34, 'Fearless (Taylor''s Version)', 'Album', 'https://i.scdn.co/image/ab67616d0000b273a48964b5d9a3d6968ae3e0de', '2021-04-09', NULL, false);
INSERT INTO public.collections VALUES (35, 'I Love You So', 'Single', 'https://i.scdn.co/image/ab67616d0000b2739214ff0109a0e062f8a6cf0f', '2014-11-28', NULL, false);
INSERT INTO public.collections VALUES (37, 'Love, Love & Love', 'Album', 'https://i.scdn.co/image/ab67616d0000b27318c5ae00eb3bee52e169d232', '2011-02-01', NULL, false);
INSERT INTO public.collections VALUES (42, 'Love Me Like You (Live from The Get Weird Tour: Wembley Arena, 2016)', 'Single', 'https://i.scdn.co/image/ab67616d0000b27354ae9131dca8aa2e14bc4309', '2016-01-01', NULL, false);
INSERT INTO public.collections VALUES (50, 'Love Me (Live On The Ed Sullivan Show, October 28, 1956)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b71d183a42e910f224ece8566f', '1956-10-28', NULL, false);
INSERT INTO public.collections VALUES (52, 'Membangun & Menghancurkan', 'Album', 'https://i.scdn.co/image/ab67616d0000b273c800b90e2092a5328f699117', '2024-08-30', NULL, false);
INSERT INTO public.collections VALUES (58, 'Espresso', 'Single', 'https://i.scdn.co/image/ab67616d0000b273659cd4673230913b3918e0d5', '2024-04-12', NULL, false);
INSERT INTO public.collections VALUES (66, 'Berita Kehilangan', 'Single', 'https://i.scdn.co/image/ab67616d0000b2732692d77a74b0da1756009e98', '2018-08-10', NULL, false);
INSERT INTO public.collections VALUES (68, 'Menari Dengan Bayangan', 'Album', 'https://i.scdn.co/image/ab67616d0000b273d623688488865906052ef96b', '2019-11-29', NULL, false);
INSERT INTO public.collections VALUES (79, 'Calon Mantu Idaman (feat. Ncum)', 'Single', 'https://i.scdn.co/image/ab67616d0000b2732120cd815e807ae193648e7e', '2025-05-16', NULL, false);
INSERT INTO public.collections VALUES (81, 'Toss the Feathers (Live at Royal Albert Hall)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b752720d68948bbe137e18bed8', '2000-01-01', NULL, false);
INSERT INTO public.collections VALUES (83, 'Dancing (feat. Joe L Barnes & Tiffany Hudson) [Live]', 'Single', 'https://i.scdn.co/image/ab6742d3000053b7f9d7a4f85a5d3eebc67e3a72', '2022-03-04', NULL, false);
INSERT INTO public.collections VALUES (85, 'liMOusIne (feat. AURORA) [Live from Japan]', 'Single', 'https://i.scdn.co/image/ab6742d3000053b74049f1eb089da6e39e713780', '2024-09-27', NULL, false);
INSERT INTO public.collections VALUES (87, 'IDOL (feat. Nicki Minaj)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b79dbc80140da729e739e98acf', '2018-09-07', NULL, false);
INSERT INTO public.collections VALUES (1, 'Lover Girl', 'Single', 'https://i.scdn.co/image/ab67616d0000b273be1e41eda793059fb9129bff', '2025-06-25', 90, false);
INSERT INTO public.collections VALUES (29, 'French Exit', 'Album', 'https://i.scdn.co/image/ab67616d0000b273e1bc1af856b42dd7fdba9f84', '2014-06-05', 24, false);
INSERT INTO public.collections VALUES (89, '别勉强 (feat. Eric 周兴哲)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b7df2465199311a9818648a284', '2020-06-29', 93, false);
INSERT INTO public.collections VALUES (86, 'MIA (feat. Drake)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b733af09e1cbe925d1c71adf24', '2020-01-01', 33, false);
INSERT INTO public.collections VALUES (63, 'Please Please Please', 'Single', 'https://i.scdn.co/image/ab67616d0000b273de84adf0e48248ea2d769c3e', '2024-06-06', 92, false);
INSERT INTO public.collections VALUES (21, 'Love For You', 'Single', 'https://i.scdn.co/image/ab67616d0000b27374a94c8c0c6b1e9f38ff7cfe', '2022-05-21', 57, false);
INSERT INTO public.collections VALUES (91, 'SH♡TGUN feat. JIMMY, WEESA, ぺろぺろきゃんでー', 'Single', 'https://i.scdn.co/image/ab6742d3000053b75606a26f0dd447d668dbb5f8', '2024-12-27', 60, false);
INSERT INTO public.collections VALUES (11, 'When The Sun Goes Down', 'Album', 'https://i.scdn.co/image/ab67616d0000b2731c8193de8d62b2ffa49a09db', '2011-01-01', 85, false);
INSERT INTO public.collections VALUES (75, 'Titik Nadir', 'Single', 'https://i.scdn.co/image/ab67616d0000b2735cfcb24701901b0e53ce4fae', '2025-06-24', 50, false);
INSERT INTO public.collections VALUES (26, 'Love Story (Slowed & Reverb)', 'Single', 'https://i.scdn.co/image/ab67616d0000b273eb5476754e53fda9feb40458', '2022-11-10', 39, false);
INSERT INTO public.collections VALUES (23, 'love nwantiti (feat. Dj Yo! & AX''EL) [Remix]', 'Single', 'https://i.scdn.co/image/ab67616d0000b27339bb326b58346f99b8692745', '2021-09-09', 42, false);
INSERT INTO public.collections VALUES (74, 'Hurry Up Tomorrow', 'Album', 'https://i.scdn.co/image/ab67616d0000b273982320da137d0de34410df61', '2025-01-31', 52, false);
INSERT INTO public.collections VALUES (17, 'CKay The First', 'Album', 'https://i.scdn.co/image/ab67616d0000b273405fdad252857e01dbced96a', '2019-08-30', 99, false);
INSERT INTO public.collections VALUES (61, 'Short n'' Sweet', 'Album', 'https://i.scdn.co/image/ab67616d0000b273fd8d7a8d96871e791cb1f626', '2024-08-23', 43, false);
INSERT INTO public.collections VALUES (5, 'My Everything (Deluxe)', 'Album', 'https://i.scdn.co/image/ab67616d0000b273deec12a28d1e336c5052e9aa', '2014-08-22', 32, false);
INSERT INTO public.collections VALUES (65, 'The Gifted', 'Album', 'https://i.scdn.co/image/ab67616d0000b273af4a0e9eaf7a6f4ecaed385f', '2013-06-25', 59, false);
INSERT INTO public.collections VALUES (3, 'Frozen (Original Motion Picture Soundtrack / Deluxe Edition)', 'Compilation', 'https://i.scdn.co/image/ab67616d0000b273a985e1e7c6b095da213eaa7c', '2013-01-01', 41, false);
INSERT INTO public.collections VALUES (22, 'Love - Amapiano Remix', 'Single', 'https://i.scdn.co/image/ab67616d0000b273d55bd2fde9c2a40387347326', '2025-01-06', 72, false);
INSERT INTO public.collections VALUES (56, 'Manchild', 'Single', 'https://i.scdn.co/image/ab67616d0000b273062c6573009fdebd43de443b', '2025-06-05', 90, false);
INSERT INTO public.collections VALUES (59, 'Feather (Sped Up)', 'Single', 'https://i.scdn.co/image/ab67616d0000b27320bc45d92ee8e4e2097ed635', '2023-08-04', 78, false);
INSERT INTO public.collections VALUES (92, 'Snarky Puppy feat. KNOWER - One Hope', 'Single', 'https://i.scdn.co/image/ab6742d3000053b7b7342edecc85f4756061b05d', '2016-01-01', 56, false);
INSERT INTO public.collections VALUES (73, 'Kesayanganku (feat. Chelsea Shania) [From "Samudra Cinta"]', 'Single', 'https://i.scdn.co/image/ab67616d0000b273c2737e0f45f4cc433ba69b11', '2020-01-10', 63, false);
INSERT INTO public.collections VALUES (78, 'Freudian', 'Album', 'https://i.scdn.co/image/ab67616d0000b27305ac3e026324594a31fad7fb', '2017-08-25', 41, false);
INSERT INTO public.collections VALUES (71, 'Judika Mencari Cinta', 'Album', 'https://i.scdn.co/image/ab67616d0000b273a37335873ed72dc558ec6889', '2013-05-13', 21, false);
INSERT INTO public.collections VALUES (72, 'Love?', 'Album', 'https://i.scdn.co/image/ab67616d0000b273d7b2aa3834b82b1cbe899a48', '2011-04-29', 61, false);
INSERT INTO public.collections VALUES (10, 'Love Is Gone (Acoustic)', 'Single', 'https://i.scdn.co/image/ab67616d0000b2733892a2a2c261629f34bb5536', '2019-11-13', 51, false);
INSERT INTO public.collections VALUES (38, 'รักคือ...', 'Single', 'https://i.scdn.co/image/ab6742d3000053b7fa659bc7be038134fc2be2b3', '2004-01-01', 76, false);
INSERT INTO public.collections VALUES (67, 'Lagipula Hidup Akan Berakhir', 'Album', 'https://i.scdn.co/image/ab67616d0000b273d58121433ea3e6c4822ac494', '2023-07-07', 65, false);
INSERT INTO public.collections VALUES (70, 'Melly', 'Album', 'https://i.scdn.co/image/ab67616d0000b273a6bce4cd942caea821e1ba76', '1999-11-26', 50, false);
INSERT INTO public.collections VALUES (14, 'Love Grows (Where My Rosemary Goes) & Other Gems', 'Album', 'https://i.scdn.co/image/ab67616d0000b2739a0011cc9d31cf969b656905', '1970-01-01', 86, false);
INSERT INTO public.collections VALUES (45, 'Bird''s Eye', 'Album', 'https://i.scdn.co/image/ab67616d0000b273ef985ba96e76a9574cc68a30', '2024-08-09', 65, false);
INSERT INTO public.collections VALUES (31, 'My World', 'Album', 'https://i.scdn.co/image/ab67616d0000b2737c3bb9f74a98f60bdda6c9a7', '2009-01-01', 76, false);
INSERT INTO public.collections VALUES (44, 'Love Like You (feat. Kenzie Walker) [Live]', 'Single', 'https://i.scdn.co/image/ab6742d3000053b787d17907544797de345be1c5', '2020-07-31', 48, false);
INSERT INTO public.collections VALUES (20, 'Cum n Cocaine', 'Single', 'https://i.scdn.co/image/ab67616d0000b273afe31aa89995bd44ba17457d', '2021-08-02', 49, false);
INSERT INTO public.collections VALUES (39, 'Love Of Mine', 'Single', 'https://i.scdn.co/image/ab6742d3000053b7b241b2f69a9086e1764cfc64', '2022-09-01', 63, false);
INSERT INTO public.collections VALUES (47, 'Love Foolosophy (Live in Verona)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b7e1cddc4aaa85f30ea2a134f1', '2002-01-01', 54, false);
INSERT INTO public.collections VALUES (55, 'Tarian Penghancur Raya', 'Single', 'https://i.scdn.co/image/ab67616d0000b273bf3e3b7cec2030618845107b', '2019-11-08', 59, false);
INSERT INTO public.collections VALUES (49, 'Love to Love You (Live at Royal Albert Hall)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b7677908f7deca10b5e20d29bf', '2000-01-01', 60, false);
INSERT INTO public.collections VALUES (77, 'What Is Love? (Deluxe Edition)', 'Album', 'https://i.scdn.co/image/ab67616d0000b2735c66e925d8fe4c92ebfb49ed', '2018-11-30', 94, false);
INSERT INTO public.collections VALUES (41, 'Love''s a Waste (feat. James Smith) [Live at Metropolis, London, 2020]', 'Single', 'https://i.scdn.co/image/ab6742d3000053b76a19e49e9db09896ab125a07', '2020-02-14', 45, false);
INSERT INTO public.collections VALUES (13, 'Reality Club Presents…', 'Album', 'https://i.scdn.co/image/ab67616d0000b273c607bcd8355681ab4fac2968', '2023-05-26', 44, false);
INSERT INTO public.collections VALUES (4, 'Grace', 'Album', 'https://i.scdn.co/image/ab67616d0000b273afc2d1d2c8703a10aeded0af', '1994-01-01', 60, false);
INSERT INTO public.collections VALUES (25, 'In Love', 'Compilation', 'https://i.scdn.co/image/ab67616d0000b2730bbcf6b2907196b95a3d0c38', '2017-02-10', 55, false);
INSERT INTO public.collections VALUES (24, 'Love, Maybe (A Business Proposal OST Special Track)', 'Single', 'https://i.scdn.co/image/ab67616d0000b27347d4fcf597d9aee2d5a34e8e', '2022-02-18', 66, false);
INSERT INTO public.collections VALUES (46, 'lovers'' carvings (Live Acoustic)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b71f35755543c12c138cf742a2', '2009-06-22', 69, false);
INSERT INTO public.collections VALUES (32, 'Return', 'Album', 'https://i.scdn.co/image/ab67616d0000b27348f4704427189fe1957d2871', '2018-01-25', 56, false);
INSERT INTO public.collections VALUES (6, 'THE ALBUM', 'Album', 'https://i.scdn.co/image/ab67616d0000b2731895052324f123becdd0d53d', '2020-10-02', 61, false);
INSERT INTO public.collections VALUES (60, 'Abdi Lara Insani', 'Album', 'https://i.scdn.co/image/ab67616d0000b273471f8a4822a3ca180612d006', '2022-04-22', 87, false);
INSERT INTO public.collections VALUES (82, 'To Love You More feat. Taro Hakase (Live in Memphis, 1997)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b71b62d7d6dcc92bb6dd39efb5', '1998-01-01', 41, false);
INSERT INTO public.collections VALUES (33, 'Mini World (Deluxe)', 'Album', 'https://i.scdn.co/image/ab67616d0000b273eb5b8d192f9b4dfc67e4834d', '2014-11-17', 82, false);
INSERT INTO public.collections VALUES (18, 'Giving you all you want and more', 'Compilation', 'https://i.scdn.co/image/ab67616d0000b27314dcfb7581bf14f6ce8e6d67', '2021-10-05', 65, false);
INSERT INTO public.collections VALUES (88, 'Runnin (feat. Brandon Lake) [Live]', 'Single', 'https://i.scdn.co/image/ab6742d3000053b75173ea02ba931154d48b2f13', '2023-05-19', 59, false);
INSERT INTO public.collections VALUES (51, 'Modal Soul', 'Album', 'https://i.scdn.co/image/ab67616d0000b273912cc8fe2e9a53d328757a41', '2005-11-11', 86, false);
INSERT INTO public.collections VALUES (19, 'First Band On The Moon (Remastered)', 'Album', 'https://i.scdn.co/image/ab67616d0000b2730aac8ca880151fda470e91af', '1996-01-01', 56, false);
INSERT INTO public.collections VALUES (28, 'Fearless (Big Machine Radio Release Special)', 'Album', 'https://i.scdn.co/image/ab67616d0000b27360cb9332e8c8c7d8e50854b3', '2008-11-11', 51, false);
INSERT INTO public.collections VALUES (84, 'Easy (feat. Jonsal Barrientes) [Live]', 'Single', 'https://i.scdn.co/image/ab6742d3000053b7012dd917a0314e7b5e8d0dc6', '2024-07-12', 67, false);
INSERT INTO public.collections VALUES (64, 'Peradaban', 'Single', 'https://i.scdn.co/image/ab67616d0000b273a8701a073f15323f29e39d56', '2018-07-13', 71, false);
INSERT INTO public.collections VALUES (40, 'Loved Me Back to Life (Live in Quebec City)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b74eedab8aa8b8c6ffc2fb8e32', '2013-09-17', 90, false);
INSERT INTO public.collections VALUES (76, 'Did you know that there''s a tunnel under Ocean Blvd', 'Album', 'https://i.scdn.co/image/ab67616d0000b27359ae8cf65d498afdd5585634', '2023-03-24', 66, false);
INSERT INTO public.collections VALUES (90, 'illusion hills feat KAIRO - so bad (official music video)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b79f163b0677aa13df4ea9896f', '2025-02-26', 68, false);
INSERT INTO public.collections VALUES (9, 'Mr Bad Guy (Special Edition)', 'Album', 'https://i.scdn.co/image/ab67616d0000b273eb9b9159e1ecb0614c2fc945', '2019-10-10', 36, false);
INSERT INTO public.collections VALUES (36, 'The Land Is Inhospitable and So Are We', 'Album', 'https://i.scdn.co/image/ab67616d0000b27334f21d3047d85440dfa37f10', '2023-09-15', 52, false);
INSERT INTO public.collections VALUES (80, 'BIRDS OF A FEATHER (ISOLATED VOCALS/Visualizer)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b73caba4166f723ff8af50d77c', '2024-09-25', 54, false);
INSERT INTO public.collections VALUES (30, 'DAMN.', 'Album', 'https://i.scdn.co/image/ab67616d0000b2738b52c6b9bc4e43d873869699', '2017-04-14', 72, false);
INSERT INTO public.collections VALUES (12, '(i would have followed you)', 'Album', 'https://i.scdn.co/image/ab67616d0000b27390cd5ef3c0d264115d0f32f0', '2022-12-16', 68, false);
INSERT INTO public.collections VALUES (57, 'emails i can''t send', 'Album', 'https://i.scdn.co/image/ab67616d0000b273700f7bf79c9f063ad0362bdf', '2022-07-15', 52, false);
INSERT INTO public.collections VALUES (54, 'Lagipula Hidup Akan Berakhir', 'Album', 'https://i.scdn.co/image/ab67616d0000b27349bdf0e981cbba25d48b44e0', '2023-07-21', 48, false);
INSERT INTO public.collections VALUES (15, 'Get Weird (Expanded Edition)', 'Album', 'https://i.scdn.co/image/ab67616d0000b273c6e0126da7f7476dd752b926', '2015-11-06', 60, false);
INSERT INTO public.collections VALUES (69, 'Beautiful (feat. Camila Cabello)', 'Single', 'https://i.scdn.co/image/ab67616d0000b27305559264ebef3889709826cf', '2018-08-02', 61, false);
INSERT INTO public.collections VALUES (48, 'Love Me Anyway', 'Single', 'https://i.scdn.co/image/ab6742d3000053b7ac0427bdec757e1e00ba5775', '2022-07-22', 51, false);
INSERT INTO public.collections VALUES (8, 'Love, Maybe (A Business Proposal OST Part.5)', 'Single', 'https://i.scdn.co/image/ab67616d0000b2739ba0f46373fe18f26c31bb55', '2022-03-14', 31, false);
INSERT INTO public.collections VALUES (62, 'Fearless Pt. II', 'Single', 'https://i.scdn.co/image/ab67616d0000b273df7c14e866cf14a259563ca1', '2017-12-23', 96, false);
INSERT INTO public.collections VALUES (43, 'Love Buzz (1992/Live at Reading)', 'Single', 'https://i.scdn.co/image/ab6742d3000053b73999ef916f6bb61b2a94bb33', '2009-01-01', 63, false);
INSERT INTO public.collections VALUES (53, 'X (feat. Maluma & Ozuna) [Remix]', 'Single', 'https://i.scdn.co/image/ab67616d0000b2734b1734e4d48786063992ce04', '2018-06-29', 71, false);


--
-- TOC entry 3921 (class 0 OID 31396)
-- Dependencies: 233
-- Data for Name: collections_songs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.collections_songs VALUES (1, 1, 1, 1);
INSERT INTO public.collections_songs VALUES (2, 2, 1, 1);
INSERT INTO public.collections_songs VALUES (3, 3, 1, 4);
INSERT INTO public.collections_songs VALUES (4, 4, 1, 7);
INSERT INTO public.collections_songs VALUES (5, 5, 1, 9);
INSERT INTO public.collections_songs VALUES (6, 6, 1, 5);
INSERT INTO public.collections_songs VALUES (7, 7, 1, 5);
INSERT INTO public.collections_songs VALUES (8, 8, 1, 1);
INSERT INTO public.collections_songs VALUES (9, 9, 1, 11);
INSERT INTO public.collections_songs VALUES (10, 10, 1, 1);
INSERT INTO public.collections_songs VALUES (11, 11, 1, 1);
INSERT INTO public.collections_songs VALUES (12, 12, 1, 2);
INSERT INTO public.collections_songs VALUES (13, 13, 1, 10);
INSERT INTO public.collections_songs VALUES (14, 14, 1, 1);
INSERT INTO public.collections_songs VALUES (15, 15, 1, 2);
INSERT INTO public.collections_songs VALUES (16, 16, 1, 1);
INSERT INTO public.collections_songs VALUES (17, 17, 1, 2);
INSERT INTO public.collections_songs VALUES (18, 18, 1, 15);
INSERT INTO public.collections_songs VALUES (19, 19, 1, 7);
INSERT INTO public.collections_songs VALUES (20, 20, 1, 5);
INSERT INTO public.collections_songs VALUES (21, 21, 1, 1);
INSERT INTO public.collections_songs VALUES (22, 22, 1, 1);
INSERT INTO public.collections_songs VALUES (23, 23, 1, 1);
INSERT INTO public.collections_songs VALUES (24, 24, 1, 1);
INSERT INTO public.collections_songs VALUES (25, 25, 2, 11);
INSERT INTO public.collections_songs VALUES (26, 26, 1, 1);
INSERT INTO public.collections_songs VALUES (27, 27, 1, 9);
INSERT INTO public.collections_songs VALUES (28, 28, 1, 6);
INSERT INTO public.collections_songs VALUES (29, 29, 1, 9);
INSERT INTO public.collections_songs VALUES (30, 30, 1, 10);
INSERT INTO public.collections_songs VALUES (31, 31, 1, 7);
INSERT INTO public.collections_songs VALUES (32, 32, 1, 1);
INSERT INTO public.collections_songs VALUES (33, 33, 1, 14);
INSERT INTO public.collections_songs VALUES (34, 34, 1, 3);
INSERT INTO public.collections_songs VALUES (35, 35, 1, 1);
INSERT INTO public.collections_songs VALUES (36, 36, 1, 7);
INSERT INTO public.collections_songs VALUES (37, 37, 1, 2);
INSERT INTO public.collections_songs VALUES (38, 38, 1, 1);
INSERT INTO public.collections_songs VALUES (39, 39, 1, 1);
INSERT INTO public.collections_songs VALUES (40, 40, 1, 1);
INSERT INTO public.collections_songs VALUES (41, 41, 1, 1);
INSERT INTO public.collections_songs VALUES (42, 42, 1, 1);
INSERT INTO public.collections_songs VALUES (43, 43, 1, 1);
INSERT INTO public.collections_songs VALUES (44, 44, 1, 1);
INSERT INTO public.collections_songs VALUES (45, 45, 1, 7);
INSERT INTO public.collections_songs VALUES (46, 46, 1, 1);
INSERT INTO public.collections_songs VALUES (47, 47, 1, 1);
INSERT INTO public.collections_songs VALUES (48, 48, 1, 1);
INSERT INTO public.collections_songs VALUES (49, 49, 1, 1);
INSERT INTO public.collections_songs VALUES (50, 50, 1, 1);
INSERT INTO public.collections_songs VALUES (51, 34, 1, 1);
INSERT INTO public.collections_songs VALUES (52, 51, 1, 1);
INSERT INTO public.collections_songs VALUES (53, 52, 1, 4);
INSERT INTO public.collections_songs VALUES (54, 53, 1, 1);
INSERT INTO public.collections_songs VALUES (55, 54, 2, 12);
INSERT INTO public.collections_songs VALUES (56, 55, 1, 1);
INSERT INTO public.collections_songs VALUES (57, 56, 1, 1);
INSERT INTO public.collections_songs VALUES (58, 57, 1, 9);
INSERT INTO public.collections_songs VALUES (59, 58, 1, 1);
INSERT INTO public.collections_songs VALUES (60, 59, 1, 2);
INSERT INTO public.collections_songs VALUES (61, 60, 1, 5);
INSERT INTO public.collections_songs VALUES (62, 61, 1, 1);
INSERT INTO public.collections_songs VALUES (63, 62, 1, 1);
INSERT INTO public.collections_songs VALUES (64, 63, 1, 1);
INSERT INTO public.collections_songs VALUES (65, 64, 1, 1);
INSERT INTO public.collections_songs VALUES (66, 60, 1, 2);
INSERT INTO public.collections_songs VALUES (67, 65, 1, 10);
INSERT INTO public.collections_songs VALUES (68, 66, 1, 1);
INSERT INTO public.collections_songs VALUES (69, 67, 1, 9);
INSERT INTO public.collections_songs VALUES (70, 54, 2, 11);
INSERT INTO public.collections_songs VALUES (71, 61, 1, 6);
INSERT INTO public.collections_songs VALUES (72, 68, 1, 8);
INSERT INTO public.collections_songs VALUES (73, 68, 1, 12);
INSERT INTO public.collections_songs VALUES (74, 54, 1, 9);
INSERT INTO public.collections_songs VALUES (75, 68, 1, 15);
INSERT INTO public.collections_songs VALUES (76, 52, 1, 8);
INSERT INTO public.collections_songs VALUES (77, 69, 1, 1);
INSERT INTO public.collections_songs VALUES (78, 70, 1, 4);
INSERT INTO public.collections_songs VALUES (79, 71, 1, 14);
INSERT INTO public.collections_songs VALUES (80, 72, 1, 1);
INSERT INTO public.collections_songs VALUES (81, 73, 1, 1);
INSERT INTO public.collections_songs VALUES (82, 74, 1, 13);
INSERT INTO public.collections_songs VALUES (83, 75, 1, 1);
INSERT INTO public.collections_songs VALUES (84, 76, 1, 13);
INSERT INTO public.collections_songs VALUES (85, 77, 1, 4);
INSERT INTO public.collections_songs VALUES (86, 78, 1, 2);
INSERT INTO public.collections_songs VALUES (87, 79, 1, 1);
INSERT INTO public.collections_songs VALUES (88, 80, 1, 1);
INSERT INTO public.collections_songs VALUES (89, 81, 1, 1);
INSERT INTO public.collections_songs VALUES (90, 82, 1, 1);
INSERT INTO public.collections_songs VALUES (91, 83, 1, 1);
INSERT INTO public.collections_songs VALUES (92, 84, 1, 1);
INSERT INTO public.collections_songs VALUES (93, 85, 1, 1);
INSERT INTO public.collections_songs VALUES (94, 86, 1, 1);
INSERT INTO public.collections_songs VALUES (95, 87, 1, 1);
INSERT INTO public.collections_songs VALUES (96, 88, 1, 1);
INSERT INTO public.collections_songs VALUES (97, 89, 1, 1);
INSERT INTO public.collections_songs VALUES (98, 90, 1, 1);
INSERT INTO public.collections_songs VALUES (99, 91, 1, 1);
INSERT INTO public.collections_songs VALUES (100, 92, 1, 1);
INSERT INTO public.collections_songs VALUES (5, 2, 1, 2);
INSERT INTO public.collections_songs VALUES (3, 2, 1, 3);


--
-- TOC entry 3924 (class 0 OID 31428)
-- Dependencies: 236
-- Data for Name: create_songs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.create_songs VALUES (1, 1);
INSERT INTO public.create_songs VALUES (2, 2);
INSERT INTO public.create_songs VALUES (3, 3);
INSERT INTO public.create_songs VALUES (4, 4);
INSERT INTO public.create_songs VALUES (5, 5);
INSERT INTO public.create_songs VALUES (6, 6);
INSERT INTO public.create_songs VALUES (7, 7);
INSERT INTO public.create_songs VALUES (8, 8);
INSERT INTO public.create_songs VALUES (9, 9);
INSERT INTO public.create_songs VALUES (10, 10);
INSERT INTO public.create_songs VALUES (11, 11);
INSERT INTO public.create_songs VALUES (12, 12);
INSERT INTO public.create_songs VALUES (13, 13);
INSERT INTO public.create_songs VALUES (14, 14);
INSERT INTO public.create_songs VALUES (15, 15);
INSERT INTO public.create_songs VALUES (16, 16);
INSERT INTO public.create_songs VALUES (17, 17);
INSERT INTO public.create_songs VALUES (18, 18);
INSERT INTO public.create_songs VALUES (19, 19);
INSERT INTO public.create_songs VALUES (20, 20);
INSERT INTO public.create_songs VALUES (21, 21);
INSERT INTO public.create_songs VALUES (22, 22);
INSERT INTO public.create_songs VALUES (23, 17);
INSERT INTO public.create_songs VALUES (24, 23);
INSERT INTO public.create_songs VALUES (25, 24);
INSERT INTO public.create_songs VALUES (26, 25);
INSERT INTO public.create_songs VALUES (27, 26);
INSERT INTO public.create_songs VALUES (28, 27);
INSERT INTO public.create_songs VALUES (29, 28);
INSERT INTO public.create_songs VALUES (30, 29);
INSERT INTO public.create_songs VALUES (31, 30);
INSERT INTO public.create_songs VALUES (32, 31);
INSERT INTO public.create_songs VALUES (33, 32);
INSERT INTO public.create_songs VALUES (34, 27);
INSERT INTO public.create_songs VALUES (35, 33);
INSERT INTO public.create_songs VALUES (36, 34);
INSERT INTO public.create_songs VALUES (37, 35);
INSERT INTO public.create_songs VALUES (38, 36);
INSERT INTO public.create_songs VALUES (39, 37);
INSERT INTO public.create_songs VALUES (40, 38);
INSERT INTO public.create_songs VALUES (41, 39);
INSERT INTO public.create_songs VALUES (42, 15);
INSERT INTO public.create_songs VALUES (43, 40);
INSERT INTO public.create_songs VALUES (44, 41);
INSERT INTO public.create_songs VALUES (45, 42);
INSERT INTO public.create_songs VALUES (46, 43);
INSERT INTO public.create_songs VALUES (47, 44);
INSERT INTO public.create_songs VALUES (48, 45);
INSERT INTO public.create_songs VALUES (49, 46);
INSERT INTO public.create_songs VALUES (50, 47);
INSERT INTO public.create_songs VALUES (51, 27);
INSERT INTO public.create_songs VALUES (52, 48);
INSERT INTO public.create_songs VALUES (53, 49);
INSERT INTO public.create_songs VALUES (54, 50);
INSERT INTO public.create_songs VALUES (55, 51);
INSERT INTO public.create_songs VALUES (56, 49);
INSERT INTO public.create_songs VALUES (57, 52);
INSERT INTO public.create_songs VALUES (58, 52);
INSERT INTO public.create_songs VALUES (59, 52);
INSERT INTO public.create_songs VALUES (60, 52);
INSERT INTO public.create_songs VALUES (61, 49);
INSERT INTO public.create_songs VALUES (62, 52);
INSERT INTO public.create_songs VALUES (63, 53);
INSERT INTO public.create_songs VALUES (64, 52);
INSERT INTO public.create_songs VALUES (65, 49);
INSERT INTO public.create_songs VALUES (66, 49);
INSERT INTO public.create_songs VALUES (67, 54);
INSERT INTO public.create_songs VALUES (68, 49);
INSERT INTO public.create_songs VALUES (69, 51);
INSERT INTO public.create_songs VALUES (70, 51);
INSERT INTO public.create_songs VALUES (71, 52);
INSERT INTO public.create_songs VALUES (72, 51);
INSERT INTO public.create_songs VALUES (73, 51);
INSERT INTO public.create_songs VALUES (74, 51);
INSERT INTO public.create_songs VALUES (75, 51);
INSERT INTO public.create_songs VALUES (76, 49);
INSERT INTO public.create_songs VALUES (77, 55);
INSERT INTO public.create_songs VALUES (78, 56);
INSERT INTO public.create_songs VALUES (79, 57);
INSERT INTO public.create_songs VALUES (80, 58);
INSERT INTO public.create_songs VALUES (81, 59);
INSERT INTO public.create_songs VALUES (82, 60);
INSERT INTO public.create_songs VALUES (83, 61);
INSERT INTO public.create_songs VALUES (84, 62);
INSERT INTO public.create_songs VALUES (85, 63);
INSERT INTO public.create_songs VALUES (86, 64);
INSERT INTO public.create_songs VALUES (87, 65);
INSERT INTO public.create_songs VALUES (88, 18);
INSERT INTO public.create_songs VALUES (89, 46);
INSERT INTO public.create_songs VALUES (90, 38);
INSERT INTO public.create_songs VALUES (91, 66);
INSERT INTO public.create_songs VALUES (92, 66);
INSERT INTO public.create_songs VALUES (93, 67);
INSERT INTO public.create_songs VALUES (94, 68);
INSERT INTO public.create_songs VALUES (95, 69);
INSERT INTO public.create_songs VALUES (96, 66);
INSERT INTO public.create_songs VALUES (97, 70);
INSERT INTO public.create_songs VALUES (98, 71);
INSERT INTO public.create_songs VALUES (99, 72);
INSERT INTO public.create_songs VALUES (100, 73);


--
-- TOC entry 3925 (class 0 OID 31438)
-- Dependencies: 237
-- Data for Name: follow_artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.follow_artists VALUES (1, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (1, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (1, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (2, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (2, 49, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (2, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (3, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (3, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (3, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (4, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (4, 42, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (4, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (5, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (5, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (5, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (6, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (6, 25, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (6, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (7, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (7, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (7, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (8, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (8, 17, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (8, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (9, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (9, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (9, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (10, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (10, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (10, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (11, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (11, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (11, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (12, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (12, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (12, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (13, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (13, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (13, 17, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (14, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (14, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (14, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (15, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (15, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (15, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (16, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (16, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (16, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (17, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (17, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (17, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (18, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (18, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (18, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (19, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (19, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (19, 50, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (20, 71, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (20, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (20, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (21, 57, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (21, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (21, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (22, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (22, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (22, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (23, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (23, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (23, 31, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (24, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (24, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (24, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (25, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (25, 24, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (25, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (26, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (26, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (26, 62, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (27, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (27, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (27, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (28, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (28, 45, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (28, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (29, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (29, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (29, 24, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (30, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (30, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (30, 49, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (31, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (31, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (31, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (32, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (32, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (32, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (33, 32, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (33, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (33, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (34, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (34, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (34, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (35, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (35, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (35, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (36, 20, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (36, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (36, 25, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (37, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (37, 28, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (37, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (38, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (38, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (38, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (39, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (39, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (39, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (40, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (40, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (40, 25, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (41, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (41, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (41, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (42, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (42, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (42, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (43, 32, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (43, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (43, 28, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (44, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (44, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (44, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (45, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (45, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (45, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (46, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (46, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (46, 42, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (47, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (47, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (47, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (48, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (48, 57, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (48, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (49, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (49, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (49, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (50, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (50, 28, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (50, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (51, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (51, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (51, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (52, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (52, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (52, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (53, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (53, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (53, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (54, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (54, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (54, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (55, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (55, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (55, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (56, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (56, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (56, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (57, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (57, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (57, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (58, 42, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (58, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (58, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (59, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (59, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (59, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (60, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (60, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (60, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (61, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (61, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (61, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (62, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (62, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (62, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (63, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (63, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (63, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (64, 32, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (64, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (64, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (65, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (65, 73, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (65, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (66, 50, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (66, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (66, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (67, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (67, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (67, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (68, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (68, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (68, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (69, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (69, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (69, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (70, 14, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (70, 57, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (70, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (71, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (71, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (71, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (72, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (72, 71, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (72, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (73, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (73, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (73, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (74, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (74, 25, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (74, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (75, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (75, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (75, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (76, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (76, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (76, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (77, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (77, 54, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (77, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (78, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (78, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (78, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (79, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (79, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (79, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (80, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (80, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (80, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (81, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (81, 54, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (81, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (82, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (82, 31, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (82, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (83, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (83, 28, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (83, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (84, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (84, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (84, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (85, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (85, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (85, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (86, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (86, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (86, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (87, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (87, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (87, 62, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (88, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (88, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (88, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (89, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (89, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (89, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (90, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (90, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (90, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (91, 73, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (91, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (91, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (92, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (92, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (92, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (93, 15, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (93, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (93, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (94, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (94, 71, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (94, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (95, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (95, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (95, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (96, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (96, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (96, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (97, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (97, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (97, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (98, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (98, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (98, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (99, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (99, 49, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (99, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (100, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (100, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.follow_artists VALUES (100, 13, '2025-11-28 12:44:38.188574');


--
-- TOC entry 3926 (class 0 OID 31450)
-- Dependencies: 238
-- Data for Name: follow_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.follow_users VALUES (1, 48);
INSERT INTO public.follow_users VALUES (1, 89);
INSERT INTO public.follow_users VALUES (2, 43);
INSERT INTO public.follow_users VALUES (2, 92);
INSERT INTO public.follow_users VALUES (3, 78);
INSERT INTO public.follow_users VALUES (3, 12);
INSERT INTO public.follow_users VALUES (4, 17);
INSERT INTO public.follow_users VALUES (4, 19);
INSERT INTO public.follow_users VALUES (5, 40);
INSERT INTO public.follow_users VALUES (5, 97);
INSERT INTO public.follow_users VALUES (6, 20);
INSERT INTO public.follow_users VALUES (6, 94);
INSERT INTO public.follow_users VALUES (7, 61);
INSERT INTO public.follow_users VALUES (7, 92);
INSERT INTO public.follow_users VALUES (8, 67);
INSERT INTO public.follow_users VALUES (8, 62);
INSERT INTO public.follow_users VALUES (9, 52);
INSERT INTO public.follow_users VALUES (9, 88);
INSERT INTO public.follow_users VALUES (10, 16);
INSERT INTO public.follow_users VALUES (10, 13);
INSERT INTO public.follow_users VALUES (11, 9);
INSERT INTO public.follow_users VALUES (11, 20);
INSERT INTO public.follow_users VALUES (12, 74);
INSERT INTO public.follow_users VALUES (12, 41);
INSERT INTO public.follow_users VALUES (13, 53);
INSERT INTO public.follow_users VALUES (13, 66);
INSERT INTO public.follow_users VALUES (14, 29);
INSERT INTO public.follow_users VALUES (14, 51);
INSERT INTO public.follow_users VALUES (15, 80);
INSERT INTO public.follow_users VALUES (15, 61);
INSERT INTO public.follow_users VALUES (16, 99);
INSERT INTO public.follow_users VALUES (16, 73);
INSERT INTO public.follow_users VALUES (17, 36);
INSERT INTO public.follow_users VALUES (17, 41);
INSERT INTO public.follow_users VALUES (18, 11);
INSERT INTO public.follow_users VALUES (18, 43);
INSERT INTO public.follow_users VALUES (19, 89);
INSERT INTO public.follow_users VALUES (19, 27);
INSERT INTO public.follow_users VALUES (20, 67);
INSERT INTO public.follow_users VALUES (20, 25);
INSERT INTO public.follow_users VALUES (21, 97);
INSERT INTO public.follow_users VALUES (21, 60);
INSERT INTO public.follow_users VALUES (22, 94);
INSERT INTO public.follow_users VALUES (23, 27);
INSERT INTO public.follow_users VALUES (23, 59);
INSERT INTO public.follow_users VALUES (24, 65);
INSERT INTO public.follow_users VALUES (24, 8);
INSERT INTO public.follow_users VALUES (25, 82);
INSERT INTO public.follow_users VALUES (25, 30);
INSERT INTO public.follow_users VALUES (26, 24);
INSERT INTO public.follow_users VALUES (26, 36);
INSERT INTO public.follow_users VALUES (27, 10);
INSERT INTO public.follow_users VALUES (27, 43);
INSERT INTO public.follow_users VALUES (28, 97);
INSERT INTO public.follow_users VALUES (28, 8);
INSERT INTO public.follow_users VALUES (29, 53);
INSERT INTO public.follow_users VALUES (29, 71);
INSERT INTO public.follow_users VALUES (30, 95);
INSERT INTO public.follow_users VALUES (30, 73);
INSERT INTO public.follow_users VALUES (31, 50);
INSERT INTO public.follow_users VALUES (31, 19);
INSERT INTO public.follow_users VALUES (32, 39);
INSERT INTO public.follow_users VALUES (32, 40);
INSERT INTO public.follow_users VALUES (33, 63);
INSERT INTO public.follow_users VALUES (33, 30);
INSERT INTO public.follow_users VALUES (34, 59);
INSERT INTO public.follow_users VALUES (34, 42);
INSERT INTO public.follow_users VALUES (35, 64);
INSERT INTO public.follow_users VALUES (35, 85);
INSERT INTO public.follow_users VALUES (36, 31);
INSERT INTO public.follow_users VALUES (36, 86);
INSERT INTO public.follow_users VALUES (37, 42);
INSERT INTO public.follow_users VALUES (37, 81);
INSERT INTO public.follow_users VALUES (38, 32);
INSERT INTO public.follow_users VALUES (38, 26);
INSERT INTO public.follow_users VALUES (39, 58);
INSERT INTO public.follow_users VALUES (39, 53);
INSERT INTO public.follow_users VALUES (40, 85);
INSERT INTO public.follow_users VALUES (40, 49);
INSERT INTO public.follow_users VALUES (41, 5);
INSERT INTO public.follow_users VALUES (41, 52);
INSERT INTO public.follow_users VALUES (42, 5);
INSERT INTO public.follow_users VALUES (42, 68);
INSERT INTO public.follow_users VALUES (43, 69);
INSERT INTO public.follow_users VALUES (43, 13);
INSERT INTO public.follow_users VALUES (44, 5);
INSERT INTO public.follow_users VALUES (44, 74);
INSERT INTO public.follow_users VALUES (45, 72);
INSERT INTO public.follow_users VALUES (45, 5);
INSERT INTO public.follow_users VALUES (46, 20);
INSERT INTO public.follow_users VALUES (46, 3);
INSERT INTO public.follow_users VALUES (47, 94);
INSERT INTO public.follow_users VALUES (47, 74);
INSERT INTO public.follow_users VALUES (48, 64);
INSERT INTO public.follow_users VALUES (48, 13);
INSERT INTO public.follow_users VALUES (49, 10);
INSERT INTO public.follow_users VALUES (49, 95);
INSERT INTO public.follow_users VALUES (50, 91);
INSERT INTO public.follow_users VALUES (50, 20);
INSERT INTO public.follow_users VALUES (51, 78);
INSERT INTO public.follow_users VALUES (51, 94);
INSERT INTO public.follow_users VALUES (52, 36);
INSERT INTO public.follow_users VALUES (52, 31);
INSERT INTO public.follow_users VALUES (53, 5);
INSERT INTO public.follow_users VALUES (53, 51);
INSERT INTO public.follow_users VALUES (54, 44);
INSERT INTO public.follow_users VALUES (54, 79);
INSERT INTO public.follow_users VALUES (55, 41);
INSERT INTO public.follow_users VALUES (55, 28);
INSERT INTO public.follow_users VALUES (56, 92);
INSERT INTO public.follow_users VALUES (56, 55);
INSERT INTO public.follow_users VALUES (57, 78);
INSERT INTO public.follow_users VALUES (57, 50);
INSERT INTO public.follow_users VALUES (58, 72);
INSERT INTO public.follow_users VALUES (58, 49);
INSERT INTO public.follow_users VALUES (59, 66);
INSERT INTO public.follow_users VALUES (59, 18);
INSERT INTO public.follow_users VALUES (60, 63);
INSERT INTO public.follow_users VALUES (60, 81);
INSERT INTO public.follow_users VALUES (61, 2);
INSERT INTO public.follow_users VALUES (61, 7);
INSERT INTO public.follow_users VALUES (62, 79);
INSERT INTO public.follow_users VALUES (62, 43);
INSERT INTO public.follow_users VALUES (63, 43);
INSERT INTO public.follow_users VALUES (63, 88);
INSERT INTO public.follow_users VALUES (64, 99);
INSERT INTO public.follow_users VALUES (64, 18);
INSERT INTO public.follow_users VALUES (65, 34);
INSERT INTO public.follow_users VALUES (65, 99);
INSERT INTO public.follow_users VALUES (66, 2);
INSERT INTO public.follow_users VALUES (67, 54);
INSERT INTO public.follow_users VALUES (67, 59);
INSERT INTO public.follow_users VALUES (68, 25);
INSERT INTO public.follow_users VALUES (68, 94);
INSERT INTO public.follow_users VALUES (69, 93);
INSERT INTO public.follow_users VALUES (69, 99);
INSERT INTO public.follow_users VALUES (70, 32);
INSERT INTO public.follow_users VALUES (70, 73);
INSERT INTO public.follow_users VALUES (71, 51);
INSERT INTO public.follow_users VALUES (71, 45);
INSERT INTO public.follow_users VALUES (72, 48);
INSERT INTO public.follow_users VALUES (72, 46);
INSERT INTO public.follow_users VALUES (73, 79);
INSERT INTO public.follow_users VALUES (73, 81);
INSERT INTO public.follow_users VALUES (74, 77);
INSERT INTO public.follow_users VALUES (74, 47);
INSERT INTO public.follow_users VALUES (75, 40);
INSERT INTO public.follow_users VALUES (75, 44);
INSERT INTO public.follow_users VALUES (76, 14);
INSERT INTO public.follow_users VALUES (76, 50);
INSERT INTO public.follow_users VALUES (77, 38);
INSERT INTO public.follow_users VALUES (78, 33);
INSERT INTO public.follow_users VALUES (78, 2);
INSERT INTO public.follow_users VALUES (79, 43);
INSERT INTO public.follow_users VALUES (79, 3);
INSERT INTO public.follow_users VALUES (80, 59);
INSERT INTO public.follow_users VALUES (80, 8);
INSERT INTO public.follow_users VALUES (81, 84);
INSERT INTO public.follow_users VALUES (81, 39);
INSERT INTO public.follow_users VALUES (82, 30);
INSERT INTO public.follow_users VALUES (82, 16);
INSERT INTO public.follow_users VALUES (83, 93);
INSERT INTO public.follow_users VALUES (83, 90);
INSERT INTO public.follow_users VALUES (84, 98);
INSERT INTO public.follow_users VALUES (84, 16);
INSERT INTO public.follow_users VALUES (85, 4);
INSERT INTO public.follow_users VALUES (85, 80);
INSERT INTO public.follow_users VALUES (86, 24);
INSERT INTO public.follow_users VALUES (86, 84);
INSERT INTO public.follow_users VALUES (87, 35);
INSERT INTO public.follow_users VALUES (87, 29);
INSERT INTO public.follow_users VALUES (88, 27);
INSERT INTO public.follow_users VALUES (88, 56);
INSERT INTO public.follow_users VALUES (89, 90);
INSERT INTO public.follow_users VALUES (89, 70);
INSERT INTO public.follow_users VALUES (90, 46);
INSERT INTO public.follow_users VALUES (90, 29);
INSERT INTO public.follow_users VALUES (91, 75);
INSERT INTO public.follow_users VALUES (91, 58);
INSERT INTO public.follow_users VALUES (92, 40);
INSERT INTO public.follow_users VALUES (92, 76);
INSERT INTO public.follow_users VALUES (93, 19);
INSERT INTO public.follow_users VALUES (93, 35);
INSERT INTO public.follow_users VALUES (94, 66);
INSERT INTO public.follow_users VALUES (94, 25);
INSERT INTO public.follow_users VALUES (95, 47);
INSERT INTO public.follow_users VALUES (95, 81);
INSERT INTO public.follow_users VALUES (96, 37);
INSERT INTO public.follow_users VALUES (96, 75);
INSERT INTO public.follow_users VALUES (97, 29);
INSERT INTO public.follow_users VALUES (97, 90);
INSERT INTO public.follow_users VALUES (98, 13);
INSERT INTO public.follow_users VALUES (98, 87);
INSERT INTO public.follow_users VALUES (99, 82);
INSERT INTO public.follow_users VALUES (99, 10);
INSERT INTO public.follow_users VALUES (100, 83);
INSERT INTO public.follow_users VALUES (100, 64);


--
-- TOC entry 3927 (class 0 OID 31460)
-- Dependencies: 239
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.genres VALUES (1, 'k-pop');
INSERT INTO public.genres VALUES (2, 'k-ballad');
INSERT INTO public.genres VALUES (3, 'pop');
INSERT INTO public.genres VALUES (4, 'melodic bass');
INSERT INTO public.genres VALUES (5, 'dubstep');
INSERT INTO public.genres VALUES (6, 'future bass');
INSERT INTO public.genres VALUES (7, 'edm');
INSERT INTO public.genres VALUES (8, 'indonesian indie');
INSERT INTO public.genres VALUES (9, 'afrobeats');
INSERT INTO public.genres VALUES (10, 'afrobeat');
INSERT INTO public.genres VALUES (11, 'afro r&b');
INSERT INTO public.genres VALUES (12, 'afropop');
INSERT INTO public.genres VALUES (13, 'swedish pop');
INSERT INTO public.genres VALUES (14, 'gqom');
INSERT INTO public.genres VALUES (15, 'amapiano');
INSERT INTO public.genres VALUES (16, 'classic rock');
INSERT INTO public.genres VALUES (17, 'rock');
INSERT INTO public.genres VALUES (18, 'glam rock');
INSERT INTO public.genres VALUES (19, 'hip hop');
INSERT INTO public.genres VALUES (20, 'west coast hip hop');
INSERT INTO public.genres VALUES (21, 'french pop');
INSERT INTO public.genres VALUES (22, 'indonesian pop');
INSERT INTO public.genres VALUES (23, 'variété française');
INSERT INTO public.genres VALUES (24, 'grunge');
INSERT INTO public.genres VALUES (25, 'worship');
INSERT INTO public.genres VALUES (26, 'christian');
INSERT INTO public.genres VALUES (27, 'christian pop');
INSERT INTO public.genres VALUES (28, 'alternative r&b');
INSERT INTO public.genres VALUES (29, 'indie soul');
INSERT INTO public.genres VALUES (30, 'ambient folk');
INSERT INTO public.genres VALUES (31, 'downtempo');
INSERT INTO public.genres VALUES (32, 'acid jazz');
INSERT INTO public.genres VALUES (33, 'big room');
INSERT INTO public.genres VALUES (34, 'celtic rock');
INSERT INTO public.genres VALUES (35, 'rockabilly');
INSERT INTO public.genres VALUES (36, 'rock and roll');
INSERT INTO public.genres VALUES (37, 'jazz rap');
INSERT INTO public.genres VALUES (38, 'indonesian rock');
INSERT INTO public.genres VALUES (39, 'indorock');
INSERT INTO public.genres VALUES (40, 'reggaeton');
INSERT INTO public.genres VALUES (41, 'latin');
INSERT INTO public.genres VALUES (42, 'malay');
INSERT INTO public.genres VALUES (43, 'malay pop');
INSERT INTO public.genres VALUES (44, 'indonesian jazz');
INSERT INTO public.genres VALUES (45, 'hipdut');
INSERT INTO public.genres VALUES (46, 'lagu timur');
INSERT INTO public.genres VALUES (47, 'dangdut');
INSERT INTO public.genres VALUES (48, 'koplo');
INSERT INTO public.genres VALUES (49, 'funkot');
INSERT INTO public.genres VALUES (50, 'ccm');
INSERT INTO public.genres VALUES (51, 'gospel');
INSERT INTO public.genres VALUES (52, 'pop worship');
INSERT INTO public.genres VALUES (53, 'metalcore');
INSERT INTO public.genres VALUES (54, 'emo');
INSERT INTO public.genres VALUES (55, 'screamo');
INSERT INTO public.genres VALUES (56, 'post-hardcore');
INSERT INTO public.genres VALUES (57, 'trap latino');
INSERT INTO public.genres VALUES (58, 'urbano latino');
INSERT INTO public.genres VALUES (59, 'mandopop');
INSERT INTO public.genres VALUES (60, 'c-pop');
INSERT INTO public.genres VALUES (61, 'cantopop');
INSERT INTO public.genres VALUES (62, 'taiwanese pop');
INSERT INTO public.genres VALUES (63, 'gufeng');
INSERT INTO public.genres VALUES (64, 'hyperpop');
INSERT INTO public.genres VALUES (65, 'j-pop');
INSERT INTO public.genres VALUES (66, 'jazz fusion');
INSERT INTO public.genres VALUES (67, 'jazz funk');
INSERT INTO public.genres VALUES (68, 'jazz');
INSERT INTO public.genres VALUES (69, 'funk rock');
INSERT INTO public.genres VALUES (70, 'nu jazz');


--
-- TOC entry 3928 (class 0 OID 31468)
-- Dependencies: 240
-- Data for Name: like_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.like_reviews VALUES (137, 82);
INSERT INTO public.like_reviews VALUES (15, 42);
INSERT INTO public.like_reviews VALUES (51, 6);
INSERT INTO public.like_reviews VALUES (129, 21);
INSERT INTO public.like_reviews VALUES (27, 71);
INSERT INTO public.like_reviews VALUES (11, 49);
INSERT INTO public.like_reviews VALUES (66, 41);
INSERT INTO public.like_reviews VALUES (119, 89);
INSERT INTO public.like_reviews VALUES (115, 90);
INSERT INTO public.like_reviews VALUES (139, 32);
INSERT INTO public.like_reviews VALUES (89, 21);
INSERT INTO public.like_reviews VALUES (74, 28);
INSERT INTO public.like_reviews VALUES (28, 79);
INSERT INTO public.like_reviews VALUES (71, 71);
INSERT INTO public.like_reviews VALUES (78, 25);
INSERT INTO public.like_reviews VALUES (7, 15);
INSERT INTO public.like_reviews VALUES (38, 3);
INSERT INTO public.like_reviews VALUES (109, 30);
INSERT INTO public.like_reviews VALUES (5, 83);
INSERT INTO public.like_reviews VALUES (128, 12);
INSERT INTO public.like_reviews VALUES (98, 81);
INSERT INTO public.like_reviews VALUES (105, 12);
INSERT INTO public.like_reviews VALUES (69, 39);
INSERT INTO public.like_reviews VALUES (135, 58);
INSERT INTO public.like_reviews VALUES (36, 41);
INSERT INTO public.like_reviews VALUES (76, 97);
INSERT INTO public.like_reviews VALUES (57, 7);
INSERT INTO public.like_reviews VALUES (26, 93);
INSERT INTO public.like_reviews VALUES (136, 49);
INSERT INTO public.like_reviews VALUES (56, 73);


--
-- TOC entry 3929 (class 0 OID 31478)
-- Dependencies: 241
-- Data for Name: like_songs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.like_songs VALUES (41, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (86, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (71, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (99, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (43, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (41, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (24, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (53, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (61, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (29, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (74, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (35, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (23, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (77, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (14, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (19, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (76, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (46, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (9, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (83, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (3, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (38, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (1, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (32, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (15, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (76, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (95, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (73, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (34, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (66, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (88, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (64, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (27, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (37, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (19, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (12, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (14, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (1, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (6, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (85, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (95, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (67, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (52, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (34, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (75, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (37, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (88, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (50, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (92, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (61, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (80, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (68, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (30, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (55, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (20, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (92, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (22, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (34, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (11, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (92, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (48, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (96, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (66, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (84, 14, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (21, 14, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (29, 14, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (76, 14, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (92, 14, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (18, 15, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (76, 15, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (2, 15, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (8, 15, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (86, 15, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (67, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (4, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (16, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (63, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (43, 17, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (5, 17, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (77, 17, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (32, 17, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (95, 17, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (32, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (25, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (7, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (98, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (62, 18, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (39, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (5, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (19, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (100, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (48, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (99, 20, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (39, 20, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (47, 20, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (96, 20, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (5, 20, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (39, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (89, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (66, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (38, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (77, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (36, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (22, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (37, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (98, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (83, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (58, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (11, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (36, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (63, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (49, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (47, 24, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (7, 24, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (62, 24, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (6, 24, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (11, 24, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (12, 25, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (90, 25, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (85, 25, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (75, 25, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (8, 25, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (22, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (18, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (33, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (24, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (54, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (20, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (30, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (45, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (1, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (21, 28, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (28, 28, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (96, 28, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (72, 28, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (83, 28, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (4, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (76, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (41, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (83, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (46, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (52, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (84, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (44, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (54, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (16, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (54, 31, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (15, 31, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (66, 31, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 31, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (41, 31, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (4, 32, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (29, 32, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (26, 32, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (81, 32, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (42, 32, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (5, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (47, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (30, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (79, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (31, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (36, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (53, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (67, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (4, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (19, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (67, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (43, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (35, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (85, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (32, 35, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (90, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (11, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (57, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (54, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (63, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (45, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (53, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (20, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (6, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (22, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (15, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (25, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (35, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (99, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (78, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (8, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (16, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (17, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (57, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (83, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (50, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (10, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (1, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (31, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (48, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (36, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (93, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (16, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (24, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (55, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (85, 42, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (43, 42, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (19, 42, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (94, 42, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (82, 42, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (88, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (56, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (61, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (75, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (21, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (80, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (73, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (92, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (8, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (13, 45, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (52, 45, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (39, 45, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (20, 45, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (64, 45, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (32, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (26, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (5, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (96, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (10, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (68, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (73, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (66, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (94, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (19, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (80, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (41, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (49, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (3, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (27, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 49, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (74, 49, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (38, 49, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (40, 49, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (4, 49, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (42, 50, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (51, 50, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (82, 50, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (22, 50, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (77, 50, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (48, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (98, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (17, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (66, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (76, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (99, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (89, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (24, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (92, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (52, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (67, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (59, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (97, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (94, 54, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (71, 54, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (64, 54, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (96, 54, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (37, 54, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (19, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (78, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (42, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (14, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (18, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (32, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (66, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (93, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (11, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (33, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (4, 57, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (85, 57, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (51, 57, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (23, 57, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (43, 57, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (78, 58, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 58, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (87, 58, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (35, 58, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (100, 58, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (29, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (86, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (71, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (54, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (46, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (7, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (6, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (98, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (64, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (31, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (82, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (46, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (56, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (100, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (1, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (23, 62, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (66, 62, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (8, 62, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (99, 62, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (6, 62, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (72, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (46, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (82, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (68, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (4, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (44, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (83, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (70, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (23, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (33, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (9, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (13, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (84, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (37, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (35, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (29, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (59, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (98, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (83, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (47, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (77, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (45, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (22, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (96, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (79, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (52, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (88, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (19, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (83, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (8, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (39, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (94, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (36, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (33, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (44, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (43, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (76, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (45, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (17, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (1, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (88, 71, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (44, 71, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (36, 71, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (54, 71, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (3, 71, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (68, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (28, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (36, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (97, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (40, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (88, 73, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (44, 73, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (2, 73, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (22, 73, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (59, 73, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (70, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (80, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (9, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (79, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (83, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (24, 75, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (51, 75, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (87, 75, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (85, 75, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 75, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (61, 76, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (84, 76, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (29, 76, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (22, 76, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (11, 76, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (55, 77, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (75, 77, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (80, 77, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (9, 77, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (56, 77, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (9, 78, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (90, 78, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (13, 78, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (37, 78, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (71, 78, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (98, 79, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (69, 79, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (17, 79, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (68, 79, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (35, 79, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (80, 80, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (91, 80, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (88, 80, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (57, 80, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (82, 80, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (3, 81, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (45, 81, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (41, 81, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (12, 81, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (26, 81, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (21, 82, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (35, 82, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (11, 82, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (30, 82, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (47, 82, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (72, 83, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (96, 83, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (80, 83, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (17, 83, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (19, 83, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (39, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (68, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (53, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (86, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (26, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (43, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (67, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (45, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (28, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (6, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (98, 86, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (87, 86, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (2, 86, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (84, 86, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (27, 86, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (57, 87, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (3, 87, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (22, 87, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (5, 87, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (33, 87, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (100, 88, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (12, 88, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (23, 88, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (86, 88, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (74, 88, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (39, 89, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (46, 89, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (63, 89, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (22, 89, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (86, 89, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (60, 90, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (55, 90, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (70, 90, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (43, 90, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (63, 90, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (90, 91, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (84, 91, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (5, 91, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (33, 91, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (86, 91, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (25, 92, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (29, 92, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (18, 92, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (58, 92, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (35, 92, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (9, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (31, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (100, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (10, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (93, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (71, 94, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (64, 94, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (65, 94, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (45, 94, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (4, 94, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (55, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (29, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (91, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (7, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (4, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (84, 96, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (82, 96, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (40, 96, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (48, 96, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (46, 96, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (15, 97, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (10, 97, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (71, 97, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (26, 97, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (35, 97, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (85, 98, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (80, 98, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (52, 98, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (59, 98, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (82, 98, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (85, 99, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (6, 99, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (59, 99, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (68, 99, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (17, 99, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (62, 100, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (95, 100, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (65, 100, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (55, 100, '2025-11-28 12:44:38.188574');
INSERT INTO public.like_songs VALUES (14, 100, '2025-11-28 12:44:38.188574');


--
-- TOC entry 3930 (class 0 OID 31490)
-- Dependencies: 242
-- Data for Name: listens; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.listens VALUES (1, 17, 52, 241, '2025-11-27 21:48:11');
INSERT INTO public.listens VALUES (2, 75, 33, 173, '2025-11-27 21:48:24');
INSERT INTO public.listens VALUES (3, 14, 6, 165, '2025-11-27 21:50:13');
INSERT INTO public.listens VALUES (4, 25, 83, 195, '2025-11-27 21:50:31');
INSERT INTO public.listens VALUES (5, 29, 26, 81, '2025-11-27 21:49:41');
INSERT INTO public.listens VALUES (6, 6, 25, 190, '2025-11-27 21:50:47');
INSERT INTO public.listens VALUES (7, 2, 86, 85, '2025-11-27 21:48:39');
INSERT INTO public.listens VALUES (8, 56, 61, 234, '2025-11-27 21:49:15');
INSERT INTO public.listens VALUES (9, 72, 63, 127, '2025-11-27 21:45:59');
INSERT INTO public.listens VALUES (10, 68, 63, 212, '2025-11-27 21:45:33');
INSERT INTO public.listens VALUES (11, 88, 24, 118, '2025-11-27 21:49:18');
INSERT INTO public.listens VALUES (12, 19, 53, 126, '2025-11-27 21:49:44');
INSERT INTO public.listens VALUES (13, 59, 32, 53, '2025-11-27 21:48:01');
INSERT INTO public.listens VALUES (14, 42, 50, 26, '2025-11-27 21:49:26');
INSERT INTO public.listens VALUES (15, 26, 45, 72, '2025-11-27 21:47:06');
INSERT INTO public.listens VALUES (16, 75, 55, 32, '2025-11-27 21:47:07');
INSERT INTO public.listens VALUES (17, 80, 1, 245, '2025-11-27 21:48:58');
INSERT INTO public.listens VALUES (18, 68, 15, 265, '2025-11-27 21:48:35');
INSERT INTO public.listens VALUES (19, 83, 84, 77, '2025-11-27 21:49:40');
INSERT INTO public.listens VALUES (20, 67, 13, 28, '2025-11-27 21:47:46');
INSERT INTO public.listens VALUES (21, 51, 15, 243, '2025-11-27 21:49:48');
INSERT INTO public.listens VALUES (22, 29, 98, 230, '2025-11-27 21:51:03');
INSERT INTO public.listens VALUES (23, 17, 21, 145, '2025-11-27 21:51:13');
INSERT INTO public.listens VALUES (24, 45, 88, 211, '2025-11-27 21:46:41');
INSERT INTO public.listens VALUES (25, 36, 71, 111, '2025-11-27 21:46:43');
INSERT INTO public.listens VALUES (26, 64, 23, 219, '2025-11-27 21:49:29');
INSERT INTO public.listens VALUES (27, 69, 47, 118, '2025-11-27 21:46:12');
INSERT INTO public.listens VALUES (28, 12, 87, 264, '2025-11-27 21:48:40');
INSERT INTO public.listens VALUES (29, 72, 6, 48, '2025-11-27 21:50:58');
INSERT INTO public.listens VALUES (30, 71, 41, 28, '2025-11-27 21:50:59');
INSERT INTO public.listens VALUES (31, 96, 94, 73, '2025-11-27 21:49:49');
INSERT INTO public.listens VALUES (32, 89, 20, 141, '2025-11-27 21:48:47');
INSERT INTO public.listens VALUES (33, 59, 55, 170, '2025-11-27 21:48:02');
INSERT INTO public.listens VALUES (34, 86, 51, 27, '2025-11-27 21:47:21');
INSERT INTO public.listens VALUES (35, 87, 88, 134, '2025-11-27 21:49:34');
INSERT INTO public.listens VALUES (36, 41, 41, 271, '2025-11-27 21:46:46');
INSERT INTO public.listens VALUES (37, 73, 90, 124, '2025-11-27 21:49:21');
INSERT INTO public.listens VALUES (38, 96, 72, 158, '2025-11-27 21:50:44');
INSERT INTO public.listens VALUES (39, 89, 95, 200, '2025-11-27 21:50:56');
INSERT INTO public.listens VALUES (40, 70, 11, 46, '2025-11-27 21:46:53');
INSERT INTO public.listens VALUES (41, 8, 84, 164, '2025-11-27 21:49:11');
INSERT INTO public.listens VALUES (42, 78, 10, 243, '2025-11-27 21:49:51');
INSERT INTO public.listens VALUES (43, 22, 12, 135, '2025-11-27 21:50:51');
INSERT INTO public.listens VALUES (44, 2, 98, 189, '2025-11-27 21:51:10');
INSERT INTO public.listens VALUES (45, 66, 39, 41, '2025-11-27 21:48:53');
INSERT INTO public.listens VALUES (46, 51, 25, 15, '2025-11-27 21:48:04');
INSERT INTO public.listens VALUES (47, 32, 100, 229, '2025-11-27 21:48:49');
INSERT INTO public.listens VALUES (48, 88, 9, 134, '2025-11-27 21:50:44');
INSERT INTO public.listens VALUES (49, 12, 72, 229, '2025-11-27 21:46:58');
INSERT INTO public.listens VALUES (50, 43, 46, 113, '2025-11-27 21:49:31');
INSERT INTO public.listens VALUES (51, 82, 85, 168, '2025-11-27 21:50:27');
INSERT INTO public.listens VALUES (52, 35, 19, 93, '2025-11-27 21:45:43');
INSERT INTO public.listens VALUES (53, 74, 67, 289, '2025-11-27 21:47:29');
INSERT INTO public.listens VALUES (54, 35, 63, 199, '2025-11-27 21:50:18');
INSERT INTO public.listens VALUES (55, 67, 23, 173, '2025-11-27 21:45:56');
INSERT INTO public.listens VALUES (56, 61, 47, 17, '2025-11-27 21:50:48');
INSERT INTO public.listens VALUES (57, 69, 12, 223, '2025-11-27 21:47:23');
INSERT INTO public.listens VALUES (58, 20, 78, 248, '2025-11-27 21:48:23');
INSERT INTO public.listens VALUES (59, 65, 72, 188, '2025-11-27 21:50:42');
INSERT INTO public.listens VALUES (60, 38, 71, 40, '2025-11-27 21:50:11');
INSERT INTO public.listens VALUES (61, 46, 89, 82, '2025-11-27 21:47:38');
INSERT INTO public.listens VALUES (62, 93, 63, 190, '2025-11-27 21:46:13');
INSERT INTO public.listens VALUES (63, 27, 4, 107, '2025-11-27 21:45:33');
INSERT INTO public.listens VALUES (64, 52, 98, 134, '2025-11-27 21:49:27');
INSERT INTO public.listens VALUES (65, 73, 35, 275, '2025-11-27 21:46:27');
INSERT INTO public.listens VALUES (66, 9, 90, 88, '2025-11-27 21:50:15');
INSERT INTO public.listens VALUES (67, 66, 3, 137, '2025-11-27 21:50:17');
INSERT INTO public.listens VALUES (68, 99, 11, 108, '2025-11-27 21:50:46');
INSERT INTO public.listens VALUES (69, 82, 100, 125, '2025-11-27 21:51:08');
INSERT INTO public.listens VALUES (70, 88, 89, 238, '2025-11-27 21:49:53');
INSERT INTO public.listens VALUES (71, 84, 31, 151, '2025-11-27 21:49:44');
INSERT INTO public.listens VALUES (72, 97, 33, 191, '2025-11-27 21:48:18');
INSERT INTO public.listens VALUES (73, 16, 52, 19, '2025-11-27 21:46:05');
INSERT INTO public.listens VALUES (74, 32, 90, 201, '2025-11-27 21:46:39');
INSERT INTO public.listens VALUES (75, 53, 57, 101, '2025-11-27 21:46:49');
INSERT INTO public.listens VALUES (76, 59, 61, 202, '2025-11-27 21:48:09');
INSERT INTO public.listens VALUES (77, 31, 100, 216, '2025-11-27 21:45:49');
INSERT INTO public.listens VALUES (78, 42, 39, 128, '2025-11-27 21:45:25');
INSERT INTO public.listens VALUES (79, 48, 14, 135, '2025-11-27 21:45:39');
INSERT INTO public.listens VALUES (80, 73, 27, 84, '2025-11-27 21:45:24');
INSERT INTO public.listens VALUES (81, 54, 38, 163, '2025-11-27 21:49:50');
INSERT INTO public.listens VALUES (82, 58, 77, 146, '2025-11-27 21:46:03');
INSERT INTO public.listens VALUES (83, 43, 30, 116, '2025-11-27 21:45:37');
INSERT INTO public.listens VALUES (84, 64, 26, 162, '2025-11-27 21:46:46');
INSERT INTO public.listens VALUES (85, 17, 28, 119, '2025-11-27 21:47:19');
INSERT INTO public.listens VALUES (86, 61, 55, 124, '2025-11-27 21:48:04');
INSERT INTO public.listens VALUES (87, 65, 53, 59, '2025-11-27 21:49:16');
INSERT INTO public.listens VALUES (88, 25, 82, 214, '2025-11-27 21:50:21');
INSERT INTO public.listens VALUES (89, 81, 92, 96, '2025-11-27 21:45:42');
INSERT INTO public.listens VALUES (90, 98, 28, 267, '2025-11-27 21:47:09');
INSERT INTO public.listens VALUES (91, 15, 59, 87, '2025-11-27 21:48:59');
INSERT INTO public.listens VALUES (92, 69, 47, 25, '2025-11-27 21:49:59');
INSERT INTO public.listens VALUES (93, 78, 29, 14, '2025-11-27 21:50:18');
INSERT INTO public.listens VALUES (94, 33, 91, 287, '2025-11-27 21:50:05');
INSERT INTO public.listens VALUES (95, 17, 29, 227, '2025-11-27 21:50:25');
INSERT INTO public.listens VALUES (96, 49, 70, 126, '2025-11-27 21:48:49');
INSERT INTO public.listens VALUES (97, 49, 38, 221, '2025-11-27 21:49:02');
INSERT INTO public.listens VALUES (98, 51, 43, 214, '2025-11-27 21:47:20');
INSERT INTO public.listens VALUES (99, 1, 88, 181, '2025-11-27 21:49:21');
INSERT INTO public.listens VALUES (100, 80, 18, 196, '2025-11-27 21:48:15');
INSERT INTO public.listens VALUES (101, 4, 50, 34, '2025-11-27 21:48:18');
INSERT INTO public.listens VALUES (102, 56, 46, 164, '2025-11-27 21:45:53');
INSERT INTO public.listens VALUES (103, 82, 52, 12, '2025-11-27 21:50:44');
INSERT INTO public.listens VALUES (104, 25, 100, 27, '2025-11-27 21:46:31');
INSERT INTO public.listens VALUES (105, 47, 51, 260, '2025-11-27 21:50:52');
INSERT INTO public.listens VALUES (106, 4, 35, 50, '2025-11-27 21:50:55');
INSERT INTO public.listens VALUES (107, 38, 48, 52, '2025-11-27 21:49:46');
INSERT INTO public.listens VALUES (108, 55, 85, 286, '2025-11-27 21:49:13');
INSERT INTO public.listens VALUES (109, 12, 16, 178, '2025-11-27 21:49:06');
INSERT INTO public.listens VALUES (110, 6, 69, 253, '2025-11-27 21:48:40');
INSERT INTO public.listens VALUES (111, 33, 42, 143, '2025-11-27 21:49:00');
INSERT INTO public.listens VALUES (112, 16, 19, 185, '2025-11-27 21:49:39');
INSERT INTO public.listens VALUES (113, 59, 53, 163, '2025-11-27 21:50:38');
INSERT INTO public.listens VALUES (114, 71, 94, 246, '2025-11-27 21:51:10');
INSERT INTO public.listens VALUES (115, 51, 45, 116, '2025-11-27 21:50:25');
INSERT INTO public.listens VALUES (116, 49, 76, 123, '2025-11-27 21:48:02');
INSERT INTO public.listens VALUES (117, 19, 1, 123, '2025-11-27 21:46:59');
INSERT INTO public.listens VALUES (118, 12, 58, 119, '2025-11-27 21:45:25');
INSERT INTO public.listens VALUES (119, 14, 63, 158, '2025-11-27 21:47:19');
INSERT INTO public.listens VALUES (120, 44, 55, 13, '2025-11-27 21:50:57');
INSERT INTO public.listens VALUES (121, 21, 45, 274, '2025-11-27 21:45:22');
INSERT INTO public.listens VALUES (122, 72, 31, 272, '2025-11-27 21:48:56');
INSERT INTO public.listens VALUES (123, 34, 77, 235, '2025-11-27 21:49:57');
INSERT INTO public.listens VALUES (124, 2, 82, 134, '2025-11-27 21:50:32');
INSERT INTO public.listens VALUES (125, 37, 64, 43, '2025-11-27 21:49:12');
INSERT INTO public.listens VALUES (126, 82, 9, 74, '2025-11-27 21:46:02');
INSERT INTO public.listens VALUES (127, 22, 20, 16, '2025-11-27 21:47:36');
INSERT INTO public.listens VALUES (128, 78, 46, 297, '2025-11-27 21:50:05');
INSERT INTO public.listens VALUES (129, 5, 72, 230, '2025-11-27 21:46:02');
INSERT INTO public.listens VALUES (130, 87, 84, 195, '2025-11-27 21:50:00');
INSERT INTO public.listens VALUES (131, 15, 93, 91, '2025-11-27 21:48:19');
INSERT INTO public.listens VALUES (132, 45, 45, 27, '2025-11-27 21:45:43');
INSERT INTO public.listens VALUES (133, 16, 93, 114, '2025-11-27 21:47:31');
INSERT INTO public.listens VALUES (134, 42, 72, 194, '2025-11-27 21:47:39');
INSERT INTO public.listens VALUES (135, 7, 29, 54, '2025-11-27 21:50:26');
INSERT INTO public.listens VALUES (136, 7, 11, 75, '2025-11-27 21:50:47');
INSERT INTO public.listens VALUES (137, 19, 73, 279, '2025-11-27 21:50:42');
INSERT INTO public.listens VALUES (138, 39, 6, 193, '2025-11-27 21:48:55');
INSERT INTO public.listens VALUES (139, 59, 10, 187, '2025-11-27 21:49:17');
INSERT INTO public.listens VALUES (140, 26, 53, 97, '2025-11-27 21:51:10');
INSERT INTO public.listens VALUES (141, 54, 77, 184, '2025-11-27 21:49:19');
INSERT INTO public.listens VALUES (142, 3, 77, 21, '2025-11-27 21:46:46');
INSERT INTO public.listens VALUES (143, 43, 29, 234, '2025-11-27 21:46:59');
INSERT INTO public.listens VALUES (144, 41, 92, 100, '2025-11-27 21:47:24');
INSERT INTO public.listens VALUES (145, 75, 78, 203, '2025-11-27 21:47:28');
INSERT INTO public.listens VALUES (146, 50, 86, 25, '2025-11-27 21:46:36');
INSERT INTO public.listens VALUES (147, 46, 24, 113, '2025-11-27 21:45:21');
INSERT INTO public.listens VALUES (148, 80, 58, 257, '2025-11-27 21:47:14');
INSERT INTO public.listens VALUES (149, 76, 92, 134, '2025-11-27 21:46:18');
INSERT INTO public.listens VALUES (150, 28, 35, 160, '2025-11-27 21:51:10');
INSERT INTO public.listens VALUES (151, 10, 74, 50, '2025-11-27 21:45:37');
INSERT INTO public.listens VALUES (152, 28, 59, 258, '2025-11-27 21:50:39');
INSERT INTO public.listens VALUES (153, 59, 57, 181, '2025-11-27 21:50:05');
INSERT INTO public.listens VALUES (154, 85, 3, 275, '2025-11-27 21:46:57');
INSERT INTO public.listens VALUES (155, 32, 2, 22, '2025-11-27 21:49:27');
INSERT INTO public.listens VALUES (156, 27, 1, 237, '2025-11-27 21:50:20');
INSERT INTO public.listens VALUES (157, 97, 73, 174, '2025-11-27 21:46:31');
INSERT INTO public.listens VALUES (158, 22, 66, 256, '2025-11-27 21:48:41');
INSERT INTO public.listens VALUES (159, 47, 95, 93, '2025-11-27 21:46:58');
INSERT INTO public.listens VALUES (160, 60, 47, 213, '2025-11-27 21:46:15');
INSERT INTO public.listens VALUES (161, 18, 39, 167, '2025-11-27 21:47:46');
INSERT INTO public.listens VALUES (162, 5, 84, 118, '2025-11-27 21:46:40');
INSERT INTO public.listens VALUES (163, 73, 42, 295, '2025-11-27 21:47:48');
INSERT INTO public.listens VALUES (164, 81, 6, 59, '2025-11-27 21:46:35');
INSERT INTO public.listens VALUES (165, 27, 83, 76, '2025-11-27 21:50:26');
INSERT INTO public.listens VALUES (166, 67, 73, 241, '2025-11-27 21:50:32');
INSERT INTO public.listens VALUES (167, 62, 43, 253, '2025-11-27 21:49:55');
INSERT INTO public.listens VALUES (168, 28, 25, 85, '2025-11-27 21:50:50');
INSERT INTO public.listens VALUES (169, 92, 87, 204, '2025-11-27 21:49:44');
INSERT INTO public.listens VALUES (170, 29, 78, 118, '2025-11-27 21:45:30');
INSERT INTO public.listens VALUES (171, 43, 81, 115, '2025-11-27 21:48:16');
INSERT INTO public.listens VALUES (172, 96, 89, 268, '2025-11-27 21:46:27');
INSERT INTO public.listens VALUES (173, 53, 95, 183, '2025-11-27 21:49:41');
INSERT INTO public.listens VALUES (174, 50, 78, 218, '2025-11-27 21:50:47');
INSERT INTO public.listens VALUES (175, 58, 18, 45, '2025-11-27 21:47:20');
INSERT INTO public.listens VALUES (176, 89, 8, 211, '2025-11-27 21:45:22');
INSERT INTO public.listens VALUES (177, 61, 22, 197, '2025-11-27 21:47:46');
INSERT INTO public.listens VALUES (178, 11, 8, 51, '2025-11-27 21:45:45');
INSERT INTO public.listens VALUES (179, 17, 63, 222, '2025-11-27 21:47:34');
INSERT INTO public.listens VALUES (180, 45, 8, 119, '2025-11-27 21:48:42');
INSERT INTO public.listens VALUES (181, 75, 53, 264, '2025-11-27 21:49:21');
INSERT INTO public.listens VALUES (182, 74, 45, 30, '2025-11-27 21:50:15');
INSERT INTO public.listens VALUES (183, 44, 94, 63, '2025-11-27 21:49:59');
INSERT INTO public.listens VALUES (184, 83, 15, 137, '2025-11-27 21:46:02');
INSERT INTO public.listens VALUES (185, 32, 28, 166, '2025-11-27 21:47:43');
INSERT INTO public.listens VALUES (186, 93, 12, 32, '2025-11-27 21:49:14');
INSERT INTO public.listens VALUES (187, 54, 93, 283, '2025-11-27 21:47:22');
INSERT INTO public.listens VALUES (188, 77, 51, 177, '2025-11-27 21:48:54');
INSERT INTO public.listens VALUES (189, 26, 15, 98, '2025-11-27 21:46:44');
INSERT INTO public.listens VALUES (190, 66, 40, 281, '2025-11-27 21:47:57');
INSERT INTO public.listens VALUES (191, 2, 84, 39, '2025-11-27 21:46:30');
INSERT INTO public.listens VALUES (192, 77, 15, 209, '2025-11-27 21:47:55');
INSERT INTO public.listens VALUES (193, 56, 92, 218, '2025-11-27 21:47:23');
INSERT INTO public.listens VALUES (194, 41, 21, 217, '2025-11-27 21:46:41');
INSERT INTO public.listens VALUES (195, 35, 83, 139, '2025-11-27 21:49:10');
INSERT INTO public.listens VALUES (196, 80, 71, 293, '2025-11-27 21:46:58');
INSERT INTO public.listens VALUES (197, 100, 70, 104, '2025-11-27 21:46:01');
INSERT INTO public.listens VALUES (198, 21, 96, 139, '2025-11-27 21:50:22');
INSERT INTO public.listens VALUES (199, 52, 39, 231, '2025-11-27 21:47:48');
INSERT INTO public.listens VALUES (200, 7, 60, 50, '2025-11-27 21:48:28');
INSERT INTO public.listens VALUES (201, 29, 5, 199, '2025-11-27 21:47:10');
INSERT INTO public.listens VALUES (202, 29, 73, 250, '2025-11-27 21:50:26');
INSERT INTO public.listens VALUES (203, 66, 35, 154, '2025-11-27 21:47:11');
INSERT INTO public.listens VALUES (204, 99, 73, 116, '2025-11-27 21:49:00');
INSERT INTO public.listens VALUES (205, 54, 87, 214, '2025-11-27 21:48:26');
INSERT INTO public.listens VALUES (206, 12, 43, 296, '2025-11-27 21:47:20');
INSERT INTO public.listens VALUES (207, 75, 70, 56, '2025-11-27 21:47:15');
INSERT INTO public.listens VALUES (208, 73, 38, 176, '2025-11-27 21:50:33');
INSERT INTO public.listens VALUES (209, 73, 42, 261, '2025-11-27 21:48:08');
INSERT INTO public.listens VALUES (210, 18, 56, 71, '2025-11-27 21:47:15');
INSERT INTO public.listens VALUES (211, 19, 20, 54, '2025-11-27 21:48:52');
INSERT INTO public.listens VALUES (212, 96, 71, 77, '2025-11-27 21:46:29');
INSERT INTO public.listens VALUES (213, 39, 15, 38, '2025-11-27 21:46:39');
INSERT INTO public.listens VALUES (214, 32, 80, 280, '2025-11-27 21:49:53');
INSERT INTO public.listens VALUES (215, 75, 82, 205, '2025-11-27 21:47:43');
INSERT INTO public.listens VALUES (216, 91, 45, 158, '2025-11-27 21:46:05');
INSERT INTO public.listens VALUES (217, 93, 71, 203, '2025-11-27 21:49:28');
INSERT INTO public.listens VALUES (218, 32, 37, 82, '2025-11-27 21:45:39');
INSERT INTO public.listens VALUES (219, 20, 85, 33, '2025-11-27 21:50:18');
INSERT INTO public.listens VALUES (220, 81, 75, 208, '2025-11-27 21:47:24');
INSERT INTO public.listens VALUES (221, 11, 32, 205, '2025-11-27 21:46:43');
INSERT INTO public.listens VALUES (222, 66, 41, 39, '2025-11-27 21:50:55');
INSERT INTO public.listens VALUES (223, 27, 22, 107, '2025-11-27 21:49:07');
INSERT INTO public.listens VALUES (224, 12, 34, 67, '2025-11-27 21:46:30');
INSERT INTO public.listens VALUES (225, 16, 49, 151, '2025-11-27 21:49:30');
INSERT INTO public.listens VALUES (226, 76, 89, 17, '2025-11-27 21:50:17');
INSERT INTO public.listens VALUES (227, 9, 53, 115, '2025-11-27 21:50:17');
INSERT INTO public.listens VALUES (228, 7, 41, 47, '2025-11-27 21:49:44');
INSERT INTO public.listens VALUES (229, 24, 60, 67, '2025-11-27 21:47:18');
INSERT INTO public.listens VALUES (230, 32, 23, 10, '2025-11-27 21:45:47');
INSERT INTO public.listens VALUES (231, 38, 97, 242, '2025-11-27 21:47:52');
INSERT INTO public.listens VALUES (232, 89, 99, 162, '2025-11-27 21:49:49');
INSERT INTO public.listens VALUES (233, 60, 25, 108, '2025-11-27 21:49:45');
INSERT INTO public.listens VALUES (234, 59, 86, 42, '2025-11-27 21:46:46');
INSERT INTO public.listens VALUES (235, 43, 13, 23, '2025-11-27 21:49:06');
INSERT INTO public.listens VALUES (236, 58, 57, 13, '2025-11-27 21:49:28');
INSERT INTO public.listens VALUES (237, 79, 36, 87, '2025-11-27 21:47:26');
INSERT INTO public.listens VALUES (238, 61, 49, 161, '2025-11-27 21:47:55');
INSERT INTO public.listens VALUES (239, 12, 4, 225, '2025-11-27 21:46:02');
INSERT INTO public.listens VALUES (240, 64, 69, 118, '2025-11-27 21:47:33');
INSERT INTO public.listens VALUES (241, 4, 34, 97, '2025-11-27 21:46:14');
INSERT INTO public.listens VALUES (242, 97, 41, 216, '2025-11-27 21:49:12');
INSERT INTO public.listens VALUES (243, 77, 93, 38, '2025-11-27 21:51:03');
INSERT INTO public.listens VALUES (244, 63, 14, 122, '2025-11-27 21:50:57');
INSERT INTO public.listens VALUES (245, 17, 26, 156, '2025-11-27 21:48:58');
INSERT INTO public.listens VALUES (246, 85, 17, 215, '2025-11-27 21:49:05');
INSERT INTO public.listens VALUES (247, 27, 24, 239, '2025-11-27 21:48:30');
INSERT INTO public.listens VALUES (248, 58, 91, 102, '2025-11-27 21:49:52');
INSERT INTO public.listens VALUES (249, 40, 56, 22, '2025-11-27 21:49:44');
INSERT INTO public.listens VALUES (250, 100, 24, 129, '2025-11-27 21:48:02');
INSERT INTO public.listens VALUES (251, 17, 9, 241, '2025-12-01 09:54:46.66021');
INSERT INTO public.listens VALUES (252, 17, 9, 241, '2025-12-05 10:24:48.645793');
INSERT INTO public.listens VALUES (253, 17, 9, 241, '2025-12-05 10:24:48.657543');


--
-- TOC entry 3932 (class 0 OID 31520)
-- Dependencies: 244
-- Data for Name: pl_library; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pl_library VALUES (1, 143);
INSERT INTO public.pl_library VALUES (2, 11);
INSERT INTO public.pl_library VALUES (3, 143);
INSERT INTO public.pl_library VALUES (4, 105);
INSERT INTO public.pl_library VALUES (5, 82);
INSERT INTO public.pl_library VALUES (6, 93);
INSERT INTO public.pl_library VALUES (7, 135);
INSERT INTO public.pl_library VALUES (8, 22);
INSERT INTO public.pl_library VALUES (9, 49);
INSERT INTO public.pl_library VALUES (10, 99);
INSERT INTO public.pl_library VALUES (11, 116);
INSERT INTO public.pl_library VALUES (12, 100);
INSERT INTO public.pl_library VALUES (13, 133);
INSERT INTO public.pl_library VALUES (14, 11);
INSERT INTO public.pl_library VALUES (15, 4);
INSERT INTO public.pl_library VALUES (16, 99);
INSERT INTO public.pl_library VALUES (17, 147);
INSERT INTO public.pl_library VALUES (18, 146);
INSERT INTO public.pl_library VALUES (19, 52);
INSERT INTO public.pl_library VALUES (20, 118);
INSERT INTO public.pl_library VALUES (21, 105);
INSERT INTO public.pl_library VALUES (22, 114);
INSERT INTO public.pl_library VALUES (23, 25);
INSERT INTO public.pl_library VALUES (24, 40);
INSERT INTO public.pl_library VALUES (25, 52);
INSERT INTO public.pl_library VALUES (26, 11);
INSERT INTO public.pl_library VALUES (27, 62);
INSERT INTO public.pl_library VALUES (28, 147);
INSERT INTO public.pl_library VALUES (29, 4);
INSERT INTO public.pl_library VALUES (30, 39);
INSERT INTO public.pl_library VALUES (31, 69);
INSERT INTO public.pl_library VALUES (32, 138);
INSERT INTO public.pl_library VALUES (33, 131);
INSERT INTO public.pl_library VALUES (34, 53);
INSERT INTO public.pl_library VALUES (35, 98);
INSERT INTO public.pl_library VALUES (36, 60);
INSERT INTO public.pl_library VALUES (37, 50);
INSERT INTO public.pl_library VALUES (38, 14);
INSERT INTO public.pl_library VALUES (39, 62);
INSERT INTO public.pl_library VALUES (40, 126);
INSERT INTO public.pl_library VALUES (41, 8);
INSERT INTO public.pl_library VALUES (42, 26);
INSERT INTO public.pl_library VALUES (43, 77);
INSERT INTO public.pl_library VALUES (44, 90);
INSERT INTO public.pl_library VALUES (45, 58);
INSERT INTO public.pl_library VALUES (46, 24);
INSERT INTO public.pl_library VALUES (47, 12);
INSERT INTO public.pl_library VALUES (48, 142);
INSERT INTO public.pl_library VALUES (49, 5);
INSERT INTO public.pl_library VALUES (50, 77);
INSERT INTO public.pl_library VALUES (51, 107);
INSERT INTO public.pl_library VALUES (52, 90);
INSERT INTO public.pl_library VALUES (53, 4);
INSERT INTO public.pl_library VALUES (54, 110);
INSERT INTO public.pl_library VALUES (55, 33);
INSERT INTO public.pl_library VALUES (56, 121);
INSERT INTO public.pl_library VALUES (57, 132);
INSERT INTO public.pl_library VALUES (58, 139);
INSERT INTO public.pl_library VALUES (59, 53);
INSERT INTO public.pl_library VALUES (60, 22);
INSERT INTO public.pl_library VALUES (61, 86);
INSERT INTO public.pl_library VALUES (62, 102);
INSERT INTO public.pl_library VALUES (63, 45);
INSERT INTO public.pl_library VALUES (64, 74);
INSERT INTO public.pl_library VALUES (65, 14);
INSERT INTO public.pl_library VALUES (66, 10);
INSERT INTO public.pl_library VALUES (67, 74);
INSERT INTO public.pl_library VALUES (68, 10);
INSERT INTO public.pl_library VALUES (69, 67);
INSERT INTO public.pl_library VALUES (70, 73);
INSERT INTO public.pl_library VALUES (71, 83);
INSERT INTO public.pl_library VALUES (72, 103);
INSERT INTO public.pl_library VALUES (73, 96);
INSERT INTO public.pl_library VALUES (74, 41);
INSERT INTO public.pl_library VALUES (75, 85);
INSERT INTO public.pl_library VALUES (76, 55);
INSERT INTO public.pl_library VALUES (77, 134);
INSERT INTO public.pl_library VALUES (78, 49);
INSERT INTO public.pl_library VALUES (79, 148);
INSERT INTO public.pl_library VALUES (80, 64);
INSERT INTO public.pl_library VALUES (81, 36);
INSERT INTO public.pl_library VALUES (82, 141);
INSERT INTO public.pl_library VALUES (83, 143);
INSERT INTO public.pl_library VALUES (84, 110);
INSERT INTO public.pl_library VALUES (85, 68);
INSERT INTO public.pl_library VALUES (86, 66);
INSERT INTO public.pl_library VALUES (87, 34);
INSERT INTO public.pl_library VALUES (88, 105);
INSERT INTO public.pl_library VALUES (89, 111);
INSERT INTO public.pl_library VALUES (90, 75);
INSERT INTO public.pl_library VALUES (91, 90);
INSERT INTO public.pl_library VALUES (92, 29);
INSERT INTO public.pl_library VALUES (93, 9);
INSERT INTO public.pl_library VALUES (94, 53);
INSERT INTO public.pl_library VALUES (95, 111);
INSERT INTO public.pl_library VALUES (96, 128);
INSERT INTO public.pl_library VALUES (97, 144);
INSERT INTO public.pl_library VALUES (98, 31);
INSERT INTO public.pl_library VALUES (99, 148);
INSERT INTO public.pl_library VALUES (100, 106);


--
-- TOC entry 3931 (class 0 OID 31504)
-- Dependencies: 243
-- Data for Name: playlists; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.playlists VALUES (10, 7, NULL, 'Maiores odio aliquam', true, false, 'My playlist', true, '2025-06-02');
INSERT INTO public.playlists VALUES (1, 1, NULL, 'Vel quis', true, true, 'My playlist', true, '2025-09-09');
INSERT INTO public.playlists VALUES (2, 2, NULL, 'Ut quibusdam quae', true, true, 'My playlist', true, '2025-09-19');
INSERT INTO public.playlists VALUES (3, 2, NULL, 'Soluta quidem', true, true, 'My playlist', true, '2025-08-05');
INSERT INTO public.playlists VALUES (4, 3, NULL, 'Aliquam magnam', true, true, 'My playlist', true, '2025-09-27');
INSERT INTO public.playlists VALUES (5, 4, NULL, 'Fugit ducimus ratione', true, true, 'My playlist', true, '2025-04-02');
INSERT INTO public.playlists VALUES (6, 5, NULL, 'Dignissimos', true, true, 'My playlist', true, '2025-02-07');
INSERT INTO public.playlists VALUES (7, 6, NULL, 'Sapiente tenetur', true, true, 'My playlist', true, '2025-01-14');
INSERT INTO public.playlists VALUES (8, 6, NULL, 'Vel maiores nesciunt', true, true, 'My playlist', true, '2025-02-08');
INSERT INTO public.playlists VALUES (9, 7, NULL, 'Amet odit ab', true, true, 'My playlist', true, '2025-10-09');
INSERT INTO public.playlists VALUES (11, 8, NULL, 'Sequi facilis libero', true, true, 'My playlist', true, '2025-11-04');
INSERT INTO public.playlists VALUES (12, 8, NULL, 'Nostrum nemo quidem', true, true, 'My playlist', true, '2025-06-01');
INSERT INTO public.playlists VALUES (13, 9, NULL, 'Quos quas rem', true, true, 'My playlist', true, '2025-05-07');
INSERT INTO public.playlists VALUES (14, 10, NULL, 'Voluptatibus', true, true, 'My playlist', true, '2025-04-15');
INSERT INTO public.playlists VALUES (15, 11, NULL, 'Voluptatum nemo', true, true, 'My playlist', true, '2025-06-17');
INSERT INTO public.playlists VALUES (16, 11, NULL, 'Animi quae', true, true, 'My playlist', true, '2025-03-03');
INSERT INTO public.playlists VALUES (17, 12, NULL, 'Amet eum', true, true, 'My playlist', true, '2025-03-02');
INSERT INTO public.playlists VALUES (18, 13, NULL, 'Fuga ipsum', true, true, 'My playlist', true, '2025-09-27');
INSERT INTO public.playlists VALUES (19, 14, NULL, 'Corporis repudiandae quasi', true, true, 'My playlist', true, '2025-04-26');
INSERT INTO public.playlists VALUES (20, 15, NULL, 'Ullam dignissimos voluptatum', true, true, 'My playlist', true, '2025-01-15');
INSERT INTO public.playlists VALUES (21, 16, NULL, 'Dignissimos voluptate excepturi', true, true, 'My playlist', true, '2025-01-06');
INSERT INTO public.playlists VALUES (22, 16, NULL, 'Nam voluptate', true, true, 'My playlist', true, '2025-06-09');
INSERT INTO public.playlists VALUES (23, 17, NULL, 'Amet aliquam facere', true, true, 'My playlist', true, '2025-01-12');
INSERT INTO public.playlists VALUES (24, 17, NULL, 'Quibusdam magni dolores', true, true, 'My playlist', true, '2025-03-07');
INSERT INTO public.playlists VALUES (25, 18, NULL, 'Incidunt architecto commodi', true, true, 'My playlist', true, '2025-04-26');
INSERT INTO public.playlists VALUES (26, 18, NULL, 'Porro fuga illo', true, true, 'My playlist', true, '2025-04-12');
INSERT INTO public.playlists VALUES (27, 19, NULL, 'Earum eos harum', true, true, 'My playlist', true, '2025-07-07');
INSERT INTO public.playlists VALUES (28, 20, NULL, 'Deserunt ullam', true, true, 'My playlist', true, '2025-05-25');
INSERT INTO public.playlists VALUES (29, 21, NULL, 'Blanditiis quidem perferendis', true, true, 'My playlist', true, '2025-01-26');
INSERT INTO public.playlists VALUES (30, 21, NULL, 'Autem', true, true, 'My playlist', true, '2025-04-20');
INSERT INTO public.playlists VALUES (31, 22, NULL, 'Quam fugit sint', true, true, 'My playlist', true, '2025-09-03');
INSERT INTO public.playlists VALUES (32, 23, NULL, 'Magni quidem', true, true, 'My playlist', true, '2025-11-20');
INSERT INTO public.playlists VALUES (33, 24, NULL, 'Odit unde nostrum', true, true, 'My playlist', true, '2025-08-25');
INSERT INTO public.playlists VALUES (34, 24, NULL, 'Culpa esse', true, true, 'My playlist', true, '2025-07-24');
INSERT INTO public.playlists VALUES (35, 25, NULL, 'Quis alias', true, true, 'My playlist', true, '2025-02-18');
INSERT INTO public.playlists VALUES (36, 26, NULL, 'Cupiditate inventore', true, true, 'My playlist', true, '2025-11-20');
INSERT INTO public.playlists VALUES (37, 26, NULL, 'Excepturi pariatur dolorem', true, true, 'My playlist', true, '2025-07-08');
INSERT INTO public.playlists VALUES (38, 27, NULL, 'Omnis repudiandae quidem', true, true, 'My playlist', true, '2025-01-04');
INSERT INTO public.playlists VALUES (39, 28, NULL, 'Dignissimos atque', true, true, 'My playlist', true, '2025-07-16');
INSERT INTO public.playlists VALUES (40, 29, NULL, 'Provident fugiat', true, true, 'My playlist', true, '2025-05-13');
INSERT INTO public.playlists VALUES (41, 30, NULL, 'Perspiciatis at', true, true, 'My playlist', true, '2025-05-02');
INSERT INTO public.playlists VALUES (42, 30, NULL, 'Quis reiciendis', true, true, 'My playlist', true, '2025-04-30');
INSERT INTO public.playlists VALUES (43, 31, NULL, 'Eaque perferendis dolorum', true, true, 'My playlist', true, '2025-08-01');
INSERT INTO public.playlists VALUES (44, 32, NULL, 'Vero itaque aliquid', true, true, 'My playlist', true, '2025-02-05');
INSERT INTO public.playlists VALUES (45, 32, NULL, 'Similique explicabo', true, true, 'My playlist', true, '2025-10-24');
INSERT INTO public.playlists VALUES (46, 33, NULL, 'Est ea reprehenderit', true, true, 'My playlist', true, '2025-07-20');
INSERT INTO public.playlists VALUES (47, 33, NULL, 'Voluptatibus fuga', true, true, 'My playlist', true, '2025-10-06');
INSERT INTO public.playlists VALUES (48, 34, NULL, 'Quidem', true, true, 'My playlist', true, '2025-10-21');
INSERT INTO public.playlists VALUES (49, 35, NULL, 'Maxime tempora nulla', true, true, 'My playlist', true, '2025-09-26');
INSERT INTO public.playlists VALUES (50, 36, NULL, 'Mollitia eos', true, true, 'My playlist', true, '2025-02-21');
INSERT INTO public.playlists VALUES (51, 37, NULL, 'Incidunt debitis', true, true, 'My playlist', true, '2025-09-29');
INSERT INTO public.playlists VALUES (52, 37, NULL, 'Fugiat voluptatum quos', true, true, 'My playlist', true, '2025-04-06');
INSERT INTO public.playlists VALUES (53, 38, NULL, 'Vitae numquam quis', true, true, 'My playlist', true, '2025-03-07');
INSERT INTO public.playlists VALUES (54, 39, NULL, 'Deleniti nesciunt laboriosam', true, true, 'My playlist', true, '2025-10-05');
INSERT INTO public.playlists VALUES (55, 40, NULL, 'Officia enim commodi', true, true, 'My playlist', true, '2025-05-16');
INSERT INTO public.playlists VALUES (56, 41, NULL, 'Recusandae saepe deleniti', true, true, 'My playlist', true, '2025-08-20');
INSERT INTO public.playlists VALUES (57, 41, NULL, 'Veniam sed minima nam', true, true, 'My playlist', true, '2025-05-22');
INSERT INTO public.playlists VALUES (58, 42, NULL, 'Eveniet architecto', true, true, 'My playlist', true, '2025-07-05');
INSERT INTO public.playlists VALUES (59, 42, NULL, 'Harum provident architecto', true, true, 'My playlist', true, '2025-09-29');
INSERT INTO public.playlists VALUES (60, 43, NULL, 'Expedita architecto', true, true, 'My playlist', true, '2025-07-09');
INSERT INTO public.playlists VALUES (61, 43, NULL, 'Beatae explicabo debitis', true, true, 'My playlist', true, '2025-01-18');
INSERT INTO public.playlists VALUES (62, 44, NULL, 'Aliquid sunt', true, true, 'My playlist', true, '2025-10-23');
INSERT INTO public.playlists VALUES (63, 45, NULL, 'Quaerat magnam', true, true, 'My playlist', true, '2025-01-12');
INSERT INTO public.playlists VALUES (64, 46, NULL, 'Rerum illum adipisci', true, true, 'My playlist', true, '2025-08-08');
INSERT INTO public.playlists VALUES (65, 46, NULL, 'Dolorum error accusamus', true, true, 'My playlist', true, '2025-04-11');
INSERT INTO public.playlists VALUES (66, 47, NULL, 'Vero', true, true, 'My playlist', true, '2025-10-20');
INSERT INTO public.playlists VALUES (67, 47, NULL, 'Molestias rem', true, true, 'My playlist', true, '2025-06-02');
INSERT INTO public.playlists VALUES (68, 48, NULL, 'Quaerat voluptas autem deserunt', true, true, 'My playlist', true, '2025-09-22');
INSERT INTO public.playlists VALUES (69, 48, NULL, 'Cum possimus sint', true, true, 'My playlist', true, '2025-11-02');
INSERT INTO public.playlists VALUES (70, 49, NULL, 'Saepe laudantium', true, true, 'My playlist', true, '2025-04-11');
INSERT INTO public.playlists VALUES (71, 49, NULL, 'Natus esse quia', true, true, 'My playlist', true, '2025-05-25');
INSERT INTO public.playlists VALUES (72, 50, NULL, 'Facilis nisi libero possimus', true, true, 'My playlist', true, '2025-09-29');
INSERT INTO public.playlists VALUES (73, 51, NULL, 'Vero mollitia fugiat', true, true, 'My playlist', true, '2025-08-07');
INSERT INTO public.playlists VALUES (74, 51, NULL, 'At necessitatibus saepe', true, true, 'My playlist', true, '2025-11-19');
INSERT INTO public.playlists VALUES (75, 52, NULL, 'Minus sed', true, true, 'My playlist', true, '2025-04-24');
INSERT INTO public.playlists VALUES (76, 52, NULL, 'Optio perferendis dicta', true, true, 'My playlist', true, '2025-10-25');
INSERT INTO public.playlists VALUES (77, 53, NULL, 'Dolor accusamus possimus', true, true, 'My playlist', true, '2025-06-10');
INSERT INTO public.playlists VALUES (78, 53, NULL, 'Mollitia ipsam', true, true, 'My playlist', true, '2025-01-03');
INSERT INTO public.playlists VALUES (79, 54, NULL, 'Maiores consequatur repudiandae', true, true, 'My playlist', true, '2025-03-04');
INSERT INTO public.playlists VALUES (80, 54, NULL, 'Officiis pariatur cum', true, true, 'My playlist', true, '2025-10-19');
INSERT INTO public.playlists VALUES (81, 55, NULL, 'Quas dolores', true, true, 'My playlist', true, '2025-07-21');
INSERT INTO public.playlists VALUES (82, 55, NULL, 'Debitis exercitationem', true, true, 'My playlist', true, '2025-01-02');
INSERT INTO public.playlists VALUES (83, 56, NULL, 'Animi quo odit', true, true, 'My playlist', true, '2025-01-06');
INSERT INTO public.playlists VALUES (84, 57, NULL, 'Aliquam qui aliquid', true, true, 'My playlist', true, '2025-07-29');
INSERT INTO public.playlists VALUES (85, 58, NULL, 'Animi consequuntur quibusdam', true, true, 'My playlist', true, '2025-04-21');
INSERT INTO public.playlists VALUES (86, 59, NULL, 'Expedita possimus', true, true, 'My playlist', true, '2025-06-20');
INSERT INTO public.playlists VALUES (87, 59, NULL, 'Sequi delectus', true, true, 'My playlist', true, '2025-02-26');
INSERT INTO public.playlists VALUES (88, 60, NULL, 'Reprehenderit occaecati possimus quidem', true, true, 'My playlist', true, '2025-11-17');
INSERT INTO public.playlists VALUES (89, 61, NULL, 'Saepe saepe id', true, true, 'My playlist', true, '2025-02-13');
INSERT INTO public.playlists VALUES (90, 62, NULL, 'Inventore aliquam magni', true, true, 'My playlist', true, '2025-08-24');
INSERT INTO public.playlists VALUES (91, 62, NULL, 'Iusto minima accusamus ullam', true, true, 'My playlist', true, '2025-05-22');
INSERT INTO public.playlists VALUES (92, 63, NULL, 'Deserunt vero nihil', true, true, 'My playlist', true, '2025-09-02');
INSERT INTO public.playlists VALUES (93, 63, NULL, 'Doloribus eos', true, true, 'My playlist', true, '2025-11-10');
INSERT INTO public.playlists VALUES (94, 64, NULL, 'Enim quisquam ratione', true, true, 'My playlist', true, '2025-11-04');
INSERT INTO public.playlists VALUES (95, 65, NULL, 'Atque tenetur fugiat', true, true, 'My playlist', true, '2025-10-01');
INSERT INTO public.playlists VALUES (96, 65, NULL, 'Quasi eos', true, true, 'My playlist', true, '2025-02-17');
INSERT INTO public.playlists VALUES (97, 66, NULL, 'Suscipit pariatur', true, true, 'My playlist', true, '2025-11-01');
INSERT INTO public.playlists VALUES (98, 67, NULL, 'Sapiente corrupti', true, true, 'My playlist', true, '2025-07-21');
INSERT INTO public.playlists VALUES (99, 67, NULL, 'A nulla sed', true, true, 'My playlist', true, '2025-11-11');
INSERT INTO public.playlists VALUES (100, 68, NULL, 'Vel atque a', true, true, 'My playlist', true, '2025-02-25');
INSERT INTO public.playlists VALUES (101, 68, NULL, 'Aperiam voluptate rem', true, true, 'My playlist', true, '2025-08-25');
INSERT INTO public.playlists VALUES (102, 69, NULL, 'Commodi temporibus', true, true, 'My playlist', true, '2025-10-10');
INSERT INTO public.playlists VALUES (103, 70, NULL, 'Accusantium perspiciatis sapiente', true, true, 'My playlist', true, '2025-09-16');
INSERT INTO public.playlists VALUES (104, 70, NULL, 'Vel voluptatibus maiores', true, true, 'My playlist', true, '2025-11-15');
INSERT INTO public.playlists VALUES (105, 71, NULL, 'Culpa sequi explicabo', true, true, 'My playlist', true, '2025-08-17');
INSERT INTO public.playlists VALUES (106, 71, NULL, 'Non doloremque aspernatur', true, true, 'My playlist', true, '2025-02-24');
INSERT INTO public.playlists VALUES (107, 72, NULL, 'At provident', true, true, 'My playlist', true, '2025-08-01');
INSERT INTO public.playlists VALUES (108, 72, NULL, 'Consequatur saepe id', true, true, 'My playlist', true, '2025-01-31');
INSERT INTO public.playlists VALUES (109, 73, NULL, 'Labore in', true, true, 'My playlist', true, '2025-02-10');
INSERT INTO public.playlists VALUES (110, 73, NULL, 'Neque ex ducimus', true, true, 'My playlist', true, '2025-01-17');
INSERT INTO public.playlists VALUES (111, 74, NULL, 'Nulla nesciunt nemo', true, true, 'My playlist', true, '2025-11-20');
INSERT INTO public.playlists VALUES (112, 75, NULL, 'Eius', true, true, 'My playlist', true, '2025-04-27');
INSERT INTO public.playlists VALUES (113, 75, NULL, 'Nihil magni illum', true, true, 'My playlist', true, '2025-07-02');
INSERT INTO public.playlists VALUES (114, 76, NULL, 'Unde minima', true, true, 'My playlist', true, '2025-04-09');
INSERT INTO public.playlists VALUES (115, 76, NULL, 'Nobis repudiandae facere', true, true, 'My playlist', true, '2025-04-03');
INSERT INTO public.playlists VALUES (116, 77, NULL, 'Ducimus minima pariatur', true, true, 'My playlist', true, '2025-02-01');
INSERT INTO public.playlists VALUES (117, 77, NULL, 'Impedit cupiditate harum', true, true, 'My playlist', true, '2025-02-27');
INSERT INTO public.playlists VALUES (118, 78, NULL, 'In at corrupti', true, true, 'My playlist', true, '2025-01-01');
INSERT INTO public.playlists VALUES (119, 79, NULL, 'Deleniti nemo eligendi laborum', true, true, 'My playlist', true, '2025-06-17');
INSERT INTO public.playlists VALUES (120, 79, NULL, 'Eaque nesciunt ex', true, true, 'My playlist', true, '2025-08-18');
INSERT INTO public.playlists VALUES (121, 80, NULL, 'Laudantium quaerat', true, true, 'My playlist', true, '2025-05-19');
INSERT INTO public.playlists VALUES (122, 81, NULL, 'Fugit commodi', true, true, 'My playlist', true, '2025-02-08');
INSERT INTO public.playlists VALUES (123, 81, NULL, 'Esse quis', true, true, 'My playlist', true, '2025-07-16');
INSERT INTO public.playlists VALUES (124, 82, NULL, 'Quis unde quas', true, true, 'My playlist', true, '2025-03-01');
INSERT INTO public.playlists VALUES (125, 82, NULL, 'Iusto delectus dolorum', true, true, 'My playlist', true, '2025-11-15');
INSERT INTO public.playlists VALUES (126, 83, NULL, 'Porro fugit', true, true, 'My playlist', true, '2025-05-10');
INSERT INTO public.playlists VALUES (127, 84, NULL, 'Repudiandae sint occaecati', true, true, 'My playlist', true, '2025-01-07');
INSERT INTO public.playlists VALUES (128, 85, NULL, 'Dolor distinctio minima', true, true, 'My playlist', true, '2025-06-21');
INSERT INTO public.playlists VALUES (129, 86, NULL, 'Voluptatum', true, true, 'My playlist', true, '2025-01-04');
INSERT INTO public.playlists VALUES (130, 86, NULL, 'Natus ipsa modi', true, true, 'My playlist', true, '2025-07-24');
INSERT INTO public.playlists VALUES (131, 87, NULL, 'Beatae dolorum ullam', true, true, 'My playlist', true, '2025-10-12');
INSERT INTO public.playlists VALUES (132, 88, NULL, 'Deleniti explicabo', true, true, 'My playlist', true, '2025-11-16');
INSERT INTO public.playlists VALUES (133, 89, NULL, 'Iure quo', true, true, 'My playlist', true, '2025-05-24');
INSERT INTO public.playlists VALUES (134, 89, NULL, 'Enim ducimus soluta', true, true, 'My playlist', true, '2025-03-26');
INSERT INTO public.playlists VALUES (135, 90, NULL, 'Cupiditate eligendi ullam ipsa', true, true, 'My playlist', true, '2025-07-10');
INSERT INTO public.playlists VALUES (136, 91, NULL, 'Error quod expedita', true, true, 'My playlist', true, '2025-11-05');
INSERT INTO public.playlists VALUES (137, 91, NULL, 'Quam ducimus sapiente', true, true, 'My playlist', true, '2025-03-06');
INSERT INTO public.playlists VALUES (138, 92, NULL, 'Incidunt reprehenderit possimus', true, true, 'My playlist', true, '2025-05-19');
INSERT INTO public.playlists VALUES (139, 92, NULL, 'Assumenda', true, true, 'My playlist', true, '2025-02-15');
INSERT INTO public.playlists VALUES (140, 93, NULL, 'Eum necessitatibus', true, true, 'My playlist', true, '2025-04-04');
INSERT INTO public.playlists VALUES (141, 94, NULL, 'Voluptate praesentium tenetur', true, true, 'My playlist', true, '2025-02-13');
INSERT INTO public.playlists VALUES (142, 95, NULL, 'Ab asperiores', true, true, 'My playlist', true, '2025-04-14');
INSERT INTO public.playlists VALUES (143, 96, NULL, 'Non blanditiis', true, true, 'My playlist', true, '2025-09-20');
INSERT INTO public.playlists VALUES (144, 97, NULL, 'Molestiae enim blanditiis', true, true, 'My playlist', true, '2025-05-06');
INSERT INTO public.playlists VALUES (145, 98, NULL, 'Animi eos labore', true, true, 'My playlist', true, '2025-10-09');
INSERT INTO public.playlists VALUES (146, 98, NULL, 'Molestiae pariatur labore', true, true, 'My playlist', true, '2025-01-14');
INSERT INTO public.playlists VALUES (147, 99, NULL, 'Atque sed', true, true, 'My playlist', true, '2025-09-08');
INSERT INTO public.playlists VALUES (148, 100, NULL, 'Placeat culpa sunt alias', true, true, 'My playlist', true, '2025-08-13');


--
-- TOC entry 3933 (class 0 OID 31530)
-- Dependencies: 245
-- Data for Name: rate_songs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rate_songs VALUES (1, 64, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (1, 82, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (1, 39, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (2, 65, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (2, 58, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (2, 82, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (3, 61, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (3, 76, 49, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (3, 19, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (4, 65, 14, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (4, 74, 78, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (4, 29, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (5, 73, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (5, 40, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (5, 75, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (6, 62, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (6, 53, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (6, 20, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (7, 11, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (7, 73, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (7, 8, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (8, 52, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (8, 43, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (8, 41, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (9, 52, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (9, 96, 87, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (9, 51, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (10, 3, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (10, 59, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (10, 27, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (11, 53, 96, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (11, 60, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (11, 30, 88, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (12, 58, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (12, 17, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (12, 95, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (13, 81, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (13, 20, 89, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (13, 73, 58, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (14, 64, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (14, 69, 91, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (14, 42, 49, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (15, 75, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (15, 70, 65, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (15, 36, 75, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (16, 55, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (16, 42, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (16, 14, 54, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (17, 18, 91, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (17, 42, 83, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (17, 19, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (18, 81, 88, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (18, 32, 89, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (18, 49, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (19, 61, 24, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (19, 60, 91, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (19, 27, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (20, 59, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (20, 11, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (20, 23, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (21, 16, 80, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (21, 99, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (21, 23, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (22, 49, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (22, 4, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (22, 85, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (23, 84, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (23, 97, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (23, 10, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (24, 45, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (24, 46, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (24, 6, 76, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (25, 98, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (25, 57, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (25, 17, 96, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (26, 3, 100, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (26, 23, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (26, 92, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (27, 50, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (27, 24, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (27, 75, 20, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (28, 8, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (28, 41, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (28, 38, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (29, 59, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (29, 30, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (29, 19, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (30, 2, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (30, 91, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (30, 99, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (31, 39, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (31, 27, 15, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (31, 62, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (32, 49, 55, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (32, 37, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (32, 28, 61, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (33, 3, 100, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (33, 7, 11, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (33, 100, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (34, 38, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (34, 13, 81, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (34, 35, 38, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (35, 56, 81, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (35, 16, 15, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (35, 3, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (36, 89, 90, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (36, 36, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (36, 90, 97, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (37, 54, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (37, 17, 95, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (37, 77, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (38, 23, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (38, 1, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (38, 47, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (39, 40, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (39, 23, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (39, 17, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (40, 1, 94, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (40, 45, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (40, 44, 83, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (41, 65, 76, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (41, 80, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (41, 14, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (42, 94, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (42, 46, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (42, 43, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (43, 10, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (43, 66, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (43, 30, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (44, 32, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (44, 23, 77, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (44, 66, 4, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (45, 87, 96, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (45, 73, 62, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (45, 19, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (46, 92, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (46, 91, 63, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (46, 51, 42, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (47, 78, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (47, 80, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (47, 51, 92, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (48, 51, 94, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (48, 57, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (48, 64, 39, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (49, 30, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (49, 39, 17, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (49, 70, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (50, 26, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (50, 72, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (50, 14, 50, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (51, 38, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (51, 10, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (51, 35, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (52, 8, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (52, 94, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (52, 72, 83, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (53, 100, 45, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (53, 76, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (53, 27, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (54, 2, 81, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (54, 42, 24, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (54, 96, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (55, 51, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (55, 8, 89, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (55, 2, 30, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (56, 45, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (56, 15, 90, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (56, 6, 3, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (57, 93, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (57, 19, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (57, 47, 19, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (58, 84, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (58, 71, 32, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (58, 96, 62, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (59, 55, 99, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (59, 59, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (59, 90, 87, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (60, 65, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (60, 49, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (60, 58, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (61, 99, 25, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (61, 17, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (61, 27, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (62, 48, 6, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (62, 75, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (62, 34, 71, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (63, 12, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (63, 30, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (63, 42, 31, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (64, 54, 82, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (64, 51, 72, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (64, 63, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (65, 79, 5, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (65, 52, 2, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (65, 99, 64, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (66, 36, 23, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (66, 1, 98, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (66, 74, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (67, 18, 50, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (67, 63, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (67, 35, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (68, 28, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (68, 32, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (68, 61, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (69, 28, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (69, 72, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (69, 44, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (70, 79, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (70, 36, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (70, 54, 34, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (71, 14, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (71, 36, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (71, 29, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (72, 81, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (72, 87, 7, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (72, 61, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (73, 100, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (73, 61, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (73, 43, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (74, 6, 40, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (74, 22, 33, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (74, 72, 48, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (75, 14, 8, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (75, 33, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (75, 45, 42, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (76, 6, 37, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (76, 16, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (76, 97, 60, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (77, 21, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (77, 78, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (77, 69, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (78, 100, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (78, 51, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (78, 25, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (79, 78, 14, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (79, 53, 99, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (79, 95, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (80, 41, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (80, 50, 86, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (80, 77, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (81, 22, 99, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (81, 67, 85, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (81, 32, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (82, 2, 46, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (82, 36, 52, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (82, 5, 91, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (83, 82, 77, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (83, 93, 26, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (83, 80, 75, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (84, 6, 41, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (84, 67, 20, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (84, 80, 68, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (85, 32, 74, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (85, 27, 16, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (85, 30, 21, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (86, 95, 29, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (86, 15, 76, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (86, 53, 36, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (87, 15, 90, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (87, 81, 82, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (87, 44, 87, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (88, 68, 98, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (88, 97, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (88, 96, 22, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (89, 32, 56, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (89, 94, 59, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (89, 9, 44, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (90, 15, 87, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (90, 23, 88, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (90, 35, 9, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (91, 51, 20, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (91, 94, 89, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (91, 31, 70, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (92, 67, 28, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (92, 24, 67, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (92, 27, 43, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (93, 64, 17, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (93, 83, 50, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (93, 96, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (94, 71, 27, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (94, 79, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (94, 3, 97, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (95, 43, 76, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (95, 57, 75, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (95, 53, 12, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (96, 7, 1, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (96, 65, 90, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (96, 25, 66, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (97, 12, 84, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (97, 84, 93, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (97, 85, 69, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (98, 28, 51, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (98, 89, 83, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (98, 74, 13, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (99, 46, 53, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (99, 50, 47, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (99, 4, 80, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (100, 42, 10, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (100, 95, 82, '2025-11-28 12:44:38.188574');
INSERT INTO public.rate_songs VALUES (100, 57, 84, '2025-11-28 12:44:38.188574');


--
-- TOC entry 3934 (class 0 OID 31543)
-- Dependencies: 246
-- Data for Name: releases; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.releases VALUES (1, 1);
INSERT INTO public.releases VALUES (2, 2);
INSERT INTO public.releases VALUES (3, 3);
INSERT INTO public.releases VALUES (4, 4);
INSERT INTO public.releases VALUES (5, 5);
INSERT INTO public.releases VALUES (6, 6);
INSERT INTO public.releases VALUES (7, 7);
INSERT INTO public.releases VALUES (8, 8);
INSERT INTO public.releases VALUES (9, 9);
INSERT INTO public.releases VALUES (10, 10);
INSERT INTO public.releases VALUES (11, 11);
INSERT INTO public.releases VALUES (12, 12);
INSERT INTO public.releases VALUES (13, 13);
INSERT INTO public.releases VALUES (14, 14);
INSERT INTO public.releases VALUES (15, 15);
INSERT INTO public.releases VALUES (16, 16);
INSERT INTO public.releases VALUES (17, 17);
INSERT INTO public.releases VALUES (18, 18);
INSERT INTO public.releases VALUES (19, 19);
INSERT INTO public.releases VALUES (20, 20);
INSERT INTO public.releases VALUES (21, 21);
INSERT INTO public.releases VALUES (22, 22);
INSERT INTO public.releases VALUES (23, 17);
INSERT INTO public.releases VALUES (24, 23);
INSERT INTO public.releases VALUES (25, 24);
INSERT INTO public.releases VALUES (26, 25);
INSERT INTO public.releases VALUES (27, 26);
INSERT INTO public.releases VALUES (28, 27);
INSERT INTO public.releases VALUES (29, 28);
INSERT INTO public.releases VALUES (30, 29);
INSERT INTO public.releases VALUES (31, 30);
INSERT INTO public.releases VALUES (32, 31);
INSERT INTO public.releases VALUES (33, 32);
INSERT INTO public.releases VALUES (34, 27);
INSERT INTO public.releases VALUES (35, 33);
INSERT INTO public.releases VALUES (36, 34);
INSERT INTO public.releases VALUES (37, 35);
INSERT INTO public.releases VALUES (38, 36);
INSERT INTO public.releases VALUES (39, 37);
INSERT INTO public.releases VALUES (40, 38);
INSERT INTO public.releases VALUES (41, 39);
INSERT INTO public.releases VALUES (42, 15);
INSERT INTO public.releases VALUES (43, 40);
INSERT INTO public.releases VALUES (44, 41);
INSERT INTO public.releases VALUES (45, 42);
INSERT INTO public.releases VALUES (46, 43);
INSERT INTO public.releases VALUES (47, 44);
INSERT INTO public.releases VALUES (48, 45);
INSERT INTO public.releases VALUES (49, 46);
INSERT INTO public.releases VALUES (50, 47);
INSERT INTO public.releases VALUES (51, 48);
INSERT INTO public.releases VALUES (52, 49);
INSERT INTO public.releases VALUES (53, 50);
INSERT INTO public.releases VALUES (54, 51);
INSERT INTO public.releases VALUES (55, 49);
INSERT INTO public.releases VALUES (56, 52);
INSERT INTO public.releases VALUES (57, 52);
INSERT INTO public.releases VALUES (58, 52);
INSERT INTO public.releases VALUES (59, 52);
INSERT INTO public.releases VALUES (60, 49);
INSERT INTO public.releases VALUES (61, 52);
INSERT INTO public.releases VALUES (62, 53);
INSERT INTO public.releases VALUES (63, 52);
INSERT INTO public.releases VALUES (64, 49);
INSERT INTO public.releases VALUES (65, 54);
INSERT INTO public.releases VALUES (66, 49);
INSERT INTO public.releases VALUES (67, 51);
INSERT INTO public.releases VALUES (68, 51);
INSERT INTO public.releases VALUES (69, 55);
INSERT INTO public.releases VALUES (70, 56);
INSERT INTO public.releases VALUES (71, 57);
INSERT INTO public.releases VALUES (72, 58);
INSERT INTO public.releases VALUES (73, 59);
INSERT INTO public.releases VALUES (74, 60);
INSERT INTO public.releases VALUES (75, 61);
INSERT INTO public.releases VALUES (76, 62);
INSERT INTO public.releases VALUES (77, 63);
INSERT INTO public.releases VALUES (78, 64);
INSERT INTO public.releases VALUES (79, 65);
INSERT INTO public.releases VALUES (80, 18);
INSERT INTO public.releases VALUES (81, 46);
INSERT INTO public.releases VALUES (82, 38);
INSERT INTO public.releases VALUES (83, 66);
INSERT INTO public.releases VALUES (84, 66);
INSERT INTO public.releases VALUES (85, 67);
INSERT INTO public.releases VALUES (86, 68);
INSERT INTO public.releases VALUES (87, 69);
INSERT INTO public.releases VALUES (88, 66);
INSERT INTO public.releases VALUES (89, 70);
INSERT INTO public.releases VALUES (90, 71);
INSERT INTO public.releases VALUES (91, 72);
INSERT INTO public.releases VALUES (92, 73);


--
-- TOC entry 3935 (class 0 OID 31553)
-- Dependencies: 247
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.reviews VALUES ('Sint expedita repudiandae distinctio.', 39, '2025-11-28 12:44:38.188574', 1, 1, 10);
INSERT INTO public.reviews VALUES ('Ducimus aliquid itaque porro.', 28, '2025-11-28 12:44:38.188574', 2, 2, 46);
INSERT INTO public.reviews VALUES ('Nisi pariatur deleniti iusto debitis.', 100, '2025-11-28 12:44:38.188574', 3, 2, 57);
INSERT INTO public.reviews VALUES ('Numquam sapiente voluptates hic recusandae.', 90, '2025-11-28 12:44:38.188574', 4, 3, 1);
INSERT INTO public.reviews VALUES ('Nihil beatae libero consequatur incidunt corporis.', 26, '2025-11-28 12:44:38.188574', 5, 4, 43);
INSERT INTO public.reviews VALUES ('Soluta dolorum placeat officiis assumenda.', 83, '2025-11-28 12:44:38.188574', 6, 4, 46);
INSERT INTO public.reviews VALUES ('Consequatur omnis perferendis quaerat.', 24, '2025-11-28 12:44:38.188574', 7, 5, 29);
INSERT INTO public.reviews VALUES ('Minus vitae officia repellat ab.', 46, '2025-11-28 12:44:38.188574', 8, 5, 86);
INSERT INTO public.reviews VALUES ('Assumenda voluptates ea laboriosam.', 57, '2025-11-28 12:44:38.188574', 9, 6, 53);
INSERT INTO public.reviews VALUES ('Est nam non occaecati commodi vero.', 47, '2025-11-28 12:44:38.188574', 10, 7, 25);
INSERT INTO public.reviews VALUES ('Vel adipisci quasi molestias.', 75, '2025-11-28 12:44:38.188574', 11, 8, 76);
INSERT INTO public.reviews VALUES ('Molestiae necessitatibus cupiditate nostrum pariatur esse praesentium fugit.', 44, '2025-11-28 12:44:38.188574', 12, 9, 59);
INSERT INTO public.reviews VALUES ('Asperiores eligendi laboriosam nemo.', 74, '2025-11-28 12:44:38.188574', 13, 10, 12);
INSERT INTO public.reviews VALUES ('Corporis facilis dignissimos vitae reiciendis aut.', 65, '2025-11-28 12:44:38.188574', 14, 10, 41);
INSERT INTO public.reviews VALUES ('Aspernatur qui perspiciatis aliquid minima fugiat cupiditate.', 94, '2025-11-28 12:44:38.188574', 15, 11, 56);
INSERT INTO public.reviews VALUES ('Sapiente veritatis id.', 53, '2025-11-28 12:44:38.188574', 16, 11, 92);
INSERT INTO public.reviews VALUES ('Quasi maxime cum sint iusto voluptate tempora.', 100, '2025-11-28 12:44:38.188574', 17, 12, 38);
INSERT INTO public.reviews VALUES ('Quaerat cupiditate a tenetur.', 77, '2025-11-28 12:44:38.188574', 18, 13, 32);
INSERT INTO public.reviews VALUES ('Temporibus magnam ipsam.', 22, '2025-11-28 12:44:38.188574', 19, 13, 26);
INSERT INTO public.reviews VALUES ('Ipsam minus harum quis dolorem facere.', 93, '2025-11-28 12:44:38.188574', 20, 14, 51);
INSERT INTO public.reviews VALUES ('Ipsa tempora similique minima eos.', 93, '2025-11-28 12:44:38.188574', 21, 14, 89);
INSERT INTO public.reviews VALUES ('Iusto in ut.', 76, '2025-11-28 12:44:38.188574', 22, 15, 30);
INSERT INTO public.reviews VALUES ('Enim quo deserunt mollitia enim sint.', 20, '2025-11-28 12:44:38.188574', 23, 16, 86);
INSERT INTO public.reviews VALUES ('Deleniti veniam esse atque aspernatur pariatur.', 99, '2025-11-28 12:44:38.188574', 24, 16, 14);
INSERT INTO public.reviews VALUES ('Minima molestiae fugit veniam nam placeat cumque.', 52, '2025-11-28 12:44:38.188574', 25, 17, 90);
INSERT INTO public.reviews VALUES ('Quas cupiditate tempore nostrum.', 92, '2025-11-28 12:44:38.188574', 26, 18, 63);
INSERT INTO public.reviews VALUES ('Debitis beatae debitis necessitatibus illo.', 27, '2025-11-28 12:44:38.188574', 27, 18, 70);
INSERT INTO public.reviews VALUES ('Odio vel ullam perferendis repudiandae magni.', 67, '2025-11-28 12:44:38.188574', 28, 19, 39);
INSERT INTO public.reviews VALUES ('Rem dolorum sunt voluptatem.', 57, '2025-11-28 12:44:38.188574', 29, 19, 21);
INSERT INTO public.reviews VALUES ('Blanditiis voluptas nostrum.', 40, '2025-11-28 12:44:38.188574', 30, 20, 82);
INSERT INTO public.reviews VALUES ('Expedita nostrum totam qui.', 50, '2025-11-28 12:44:38.188574', 31, 20, 69);
INSERT INTO public.reviews VALUES ('Itaque adipisci ex eum magni reprehenderit.', 60, '2025-11-28 12:44:38.188574', 32, 21, 91);
INSERT INTO public.reviews VALUES ('Eius esse vero harum.', 24, '2025-11-28 12:44:38.188574', 33, 21, 10);
INSERT INTO public.reviews VALUES ('Fugit dolorum adipisci ducimus.', 45, '2025-11-28 12:44:38.188574', 34, 22, 41);
INSERT INTO public.reviews VALUES ('Cupiditate nulla voluptatem vero impedit ad necessitatibus.', 85, '2025-11-28 12:44:38.188574', 35, 23, 11);
INSERT INTO public.reviews VALUES ('Facere asperiores quod quam.', 46, '2025-11-28 12:44:38.188574', 36, 24, 26);
INSERT INTO public.reviews VALUES ('Neque veritatis amet sunt aperiam aspernatur.', 80, '2025-11-28 12:44:38.188574', 37, 25, 55);
INSERT INTO public.reviews VALUES ('Placeat quod quis vel fugiat incidunt.', 33, '2025-11-28 12:44:38.188574', 38, 25, 19);
INSERT INTO public.reviews VALUES ('Unde omnis debitis error libero.', 50, '2025-11-28 12:44:38.188574', 39, 26, 75);
INSERT INTO public.reviews VALUES ('Alias nihil cupiditate impedit minima laborum vitae.', 82, '2025-11-28 12:44:38.188574', 40, 27, 33);
INSERT INTO public.reviews VALUES ('Quae repudiandae molestiae voluptatem tenetur.', 82, '2025-11-28 12:44:38.188574', 41, 27, 45);
INSERT INTO public.reviews VALUES ('Voluptates id dolorem fugiat ex.', 48, '2025-11-28 12:44:38.188574', 42, 28, 26);
INSERT INTO public.reviews VALUES ('Deleniti aliquid id ea quisquam aspernatur.', 66, '2025-11-28 12:44:38.188574', 43, 29, 67);
INSERT INTO public.reviews VALUES ('Ea dicta repellendus unde quaerat porro eligendi.', 73, '2025-11-28 12:44:38.188574', 44, 30, 36);
INSERT INTO public.reviews VALUES ('Odio culpa consequuntur neque nostrum cupiditate in explicabo.', 42, '2025-11-28 12:44:38.188574', 45, 30, 23);
INSERT INTO public.reviews VALUES ('Enim at ex officia dolorem sint.', 24, '2025-11-28 12:44:38.188574', 46, 31, 48);
INSERT INTO public.reviews VALUES ('Ab soluta maxime aspernatur deleniti.', 95, '2025-11-28 12:44:38.188574', 47, 32, 49);
INSERT INTO public.reviews VALUES ('Eaque soluta odio vel quasi ea nemo.', 96, '2025-11-28 12:44:38.188574', 48, 33, 10);
INSERT INTO public.reviews VALUES ('Nostrum earum cum nesciunt tempore optio.', 70, '2025-11-28 12:44:38.188574', 49, 33, 76);
INSERT INTO public.reviews VALUES ('Voluptatem occaecati et dolorum inventore possimus eligendi cumque.', 84, '2025-11-28 12:44:38.188574', 50, 34, 43);
INSERT INTO public.reviews VALUES ('Expedita ad error.', 100, '2025-11-28 12:44:38.188574', 51, 34, 24);
INSERT INTO public.reviews VALUES ('Explicabo eveniet deleniti beatae error veniam magni.', 52, '2025-11-28 12:44:38.188574', 52, 35, 74);
INSERT INTO public.reviews VALUES ('Atque in impedit provident corrupti perspiciatis.', 99, '2025-11-28 12:44:38.188574', 53, 36, 17);
INSERT INTO public.reviews VALUES ('A suscipit quisquam laborum odio soluta architecto.', 39, '2025-11-28 12:44:38.188574', 54, 36, 8);
INSERT INTO public.reviews VALUES ('Doloremque doloremque numquam atque.', 82, '2025-11-28 12:44:38.188574', 55, 37, 22);
INSERT INTO public.reviews VALUES ('Et sapiente temporibus eum.', 98, '2025-11-28 12:44:38.188574', 56, 37, 64);
INSERT INTO public.reviews VALUES ('Voluptatem culpa commodi delectus accusantium consectetur.', 23, '2025-11-28 12:44:38.188574', 57, 38, 5);
INSERT INTO public.reviews VALUES ('Cupiditate recusandae asperiores facere optio autem soluta.', 84, '2025-11-28 12:44:38.188574', 58, 39, 31);
INSERT INTO public.reviews VALUES ('Accusantium temporibus totam voluptate corporis quas rem.', 43, '2025-11-28 12:44:38.188574', 59, 39, 61);
INSERT INTO public.reviews VALUES ('Illo voluptatum quia excepturi asperiores est voluptate debitis.', 83, '2025-11-28 12:44:38.188574', 60, 40, 67);
INSERT INTO public.reviews VALUES ('Amet repellendus veritatis minima perspiciatis unde accusantium sit.', 41, '2025-11-28 12:44:38.188574', 61, 41, 5);
INSERT INTO public.reviews VALUES ('Dolore quo dolorem id sunt rerum accusantium.', 59, '2025-11-28 12:44:38.188574', 62, 41, 65);
INSERT INTO public.reviews VALUES ('Reiciendis magni aspernatur suscipit minima.', 41, '2025-11-28 12:44:38.188574', 63, 42, 3);
INSERT INTO public.reviews VALUES ('Illo consequuntur enim quas porro.', 47, '2025-11-28 12:44:38.188574', 64, 42, 47);
INSERT INTO public.reviews VALUES ('Eligendi occaecati commodi ducimus aspernatur.', 86, '2025-11-28 12:44:38.188574', 65, 43, 45);
INSERT INTO public.reviews VALUES ('Numquam occaecati incidunt in quasi quod.', 45, '2025-11-28 12:44:38.188574', 66, 44, 10);
INSERT INTO public.reviews VALUES ('Explicabo eaque doloremque sit fugit.', 62, '2025-11-28 12:44:38.188574', 67, 45, 22);
INSERT INTO public.reviews VALUES ('Dolor dicta cumque eum dolor.', 73, '2025-11-28 12:44:38.188574', 68, 46, 53);
INSERT INTO public.reviews VALUES ('Sapiente quibusdam aperiam inventore.', 26, '2025-11-28 12:44:38.188574', 69, 47, 24);
INSERT INTO public.reviews VALUES ('Repellendus omnis necessitatibus voluptas libero placeat.', 100, '2025-11-28 12:44:38.188574', 70, 48, 59);
INSERT INTO public.reviews VALUES ('Eius illum corrupti fuga impedit dolores.', 86, '2025-11-28 12:44:38.188574', 71, 49, 56);
INSERT INTO public.reviews VALUES ('Perspiciatis architecto sed qui aperiam nesciunt distinctio.', 91, '2025-11-28 12:44:38.188574', 72, 50, 76);
INSERT INTO public.reviews VALUES ('Sit corporis rem dicta ullam consequuntur.', 70, '2025-11-28 12:44:38.188574', 73, 51, 67);
INSERT INTO public.reviews VALUES ('Dolorum nihil quia consequuntur excepturi.', 75, '2025-11-28 12:44:38.188574', 74, 52, 6);
INSERT INTO public.reviews VALUES ('Et tenetur quis dicta suscipit iusto quasi.', 90, '2025-11-28 12:44:38.188574', 75, 53, 59);
INSERT INTO public.reviews VALUES ('Sequi expedita recusandae et libero veniam quo.', 58, '2025-11-28 12:44:38.188574', 76, 53, 92);
INSERT INTO public.reviews VALUES ('Facere quam earum modi dolores cupiditate.', 63, '2025-11-28 12:44:38.188574', 77, 54, 73);
INSERT INTO public.reviews VALUES ('Cumque autem magni voluptatibus voluptatum culpa culpa.', 66, '2025-11-28 12:44:38.188574', 78, 55, 6);
INSERT INTO public.reviews VALUES ('Consectetur molestias non aut nihil.', 41, '2025-11-28 12:44:38.188574', 79, 55, 78);
INSERT INTO public.reviews VALUES ('A alias fugiat dolorum temporibus alias quis.', 54, '2025-11-28 12:44:38.188574', 80, 56, 32);
INSERT INTO public.reviews VALUES ('Laboriosam eaque explicabo ex reiciendis tempora.', 28, '2025-11-28 12:44:38.188574', 81, 56, 8);
INSERT INTO public.reviews VALUES ('Dolorem nobis perspiciatis voluptas sequi magni consectetur.', 21, '2025-11-28 12:44:38.188574', 82, 57, 71);
INSERT INTO public.reviews VALUES ('Soluta quo repudiandae ad repudiandae.', 61, '2025-11-28 12:44:38.188574', 83, 57, 72);
INSERT INTO public.reviews VALUES ('Quas a facilis non.', 52, '2025-11-28 12:44:38.188574', 84, 58, 10);
INSERT INTO public.reviews VALUES ('Officia ut consequuntur maiores numquam assumenda a.', 51, '2025-11-28 12:44:38.188574', 85, 58, 38);
INSERT INTO public.reviews VALUES ('Quidem esse ut laboriosam quisquam quidem facilis.', 58, '2025-11-28 12:44:38.188574', 86, 59, 4);
INSERT INTO public.reviews VALUES ('Adipisci similique in voluptates.', 52, '2025-11-28 12:44:38.188574', 87, 60, 54);
INSERT INTO public.reviews VALUES ('Cum ea soluta nesciunt.', 41, '2025-11-28 12:44:38.188574', 88, 61, 67);
INSERT INTO public.reviews VALUES ('Provident vero maiores.', 73, '2025-11-28 12:44:38.188574', 89, 61, 70);
INSERT INTO public.reviews VALUES ('Blanditiis esse totam iste vitae consequuntur reprehenderit.', 31, '2025-11-28 12:44:38.188574', 90, 62, 48);
INSERT INTO public.reviews VALUES ('Consectetur excepturi voluptas quaerat ullam veritatis.', 72, '2025-11-28 12:44:38.188574', 91, 62, 14);
INSERT INTO public.reviews VALUES ('Laudantium nostrum saepe libero mollitia praesentium sint.', 26, '2025-11-28 12:44:38.188574', 92, 63, 45);
INSERT INTO public.reviews VALUES ('Minima ullam magni animi ducimus veniam.', 67, '2025-11-28 12:44:38.188574', 93, 64, 31);
INSERT INTO public.reviews VALUES ('Sapiente deleniti architecto magni quam placeat.', 77, '2025-11-28 12:44:38.188574', 94, 65, 88);
INSERT INTO public.reviews VALUES ('Iure veniam molestias consectetur recusandae id adipisci ratione.', 51, '2025-11-28 12:44:38.188574', 95, 65, 15);
INSERT INTO public.reviews VALUES ('Mollitia minima voluptatum.', 26, '2025-11-28 12:44:38.188574', 96, 66, 57);
INSERT INTO public.reviews VALUES ('Perspiciatis sequi repellendus aperiam ducimus minus.', 48, '2025-11-28 12:44:38.188574', 97, 67, 44);
INSERT INTO public.reviews VALUES ('At hic provident quia doloremque.', 49, '2025-11-28 12:44:38.188574', 98, 68, 20);
INSERT INTO public.reviews VALUES ('Nulla aspernatur dolor minus reprehenderit dolorum.', 59, '2025-11-28 12:44:38.188574', 99, 69, 39);
INSERT INTO public.reviews VALUES ('Voluptatibus delectus facilis ducimus est.', 56, '2025-11-28 12:44:38.188574', 100, 70, 90);
INSERT INTO public.reviews VALUES ('Natus et corporis.', 30, '2025-11-28 12:44:38.188574', 101, 71, 55);
INSERT INTO public.reviews VALUES ('Necessitatibus accusamus ullam voluptatem cupiditate.', 61, '2025-11-28 12:44:38.188574', 102, 71, 47);
INSERT INTO public.reviews VALUES ('Accusamus ea veniam dignissimos sunt.', 68, '2025-11-28 12:44:38.188574', 103, 72, 55);
INSERT INTO public.reviews VALUES ('Deleniti blanditiis provident.', 24, '2025-11-28 12:44:38.188574', 104, 72, 49);
INSERT INTO public.reviews VALUES ('Praesentium autem nihil impedit magni officiis id quia.', 94, '2025-11-28 12:44:38.188574', 105, 73, 77);
INSERT INTO public.reviews VALUES ('Reiciendis quaerat perferendis perspiciatis quam mollitia illum eum.', 25, '2025-11-28 12:44:38.188574', 106, 73, 41);
INSERT INTO public.reviews VALUES ('A debitis magni aspernatur.', 44, '2025-11-28 12:44:38.188574', 107, 74, 13);
INSERT INTO public.reviews VALUES ('Exercitationem sit ea dolor rerum.', 62, '2025-11-28 12:44:38.188574', 108, 74, 4);
INSERT INTO public.reviews VALUES ('Facere nisi nihil rem veniam a quidem.', 63, '2025-11-28 12:44:38.188574', 109, 75, 25);
INSERT INTO public.reviews VALUES ('Nesciunt laboriosam quo.', 71, '2025-11-28 12:44:38.188574', 110, 75, 24);
INSERT INTO public.reviews VALUES ('Facilis earum pariatur facilis pariatur quidem.', 97, '2025-11-28 12:44:38.188574', 111, 76, 46);
INSERT INTO public.reviews VALUES ('Modi libero est.', 54, '2025-11-28 12:44:38.188574', 112, 77, 6);
INSERT INTO public.reviews VALUES ('Nulla consectetur nam.', 38, '2025-11-28 12:44:38.188574', 113, 77, 32);
INSERT INTO public.reviews VALUES ('Perferendis ex omnis dolor.', 50, '2025-11-28 12:44:38.188574', 114, 78, 6);
INSERT INTO public.reviews VALUES ('Mollitia iusto eius.', 87, '2025-11-28 12:44:38.188574', 115, 78, 60);
INSERT INTO public.reviews VALUES ('Soluta labore cupiditate optio nulla impedit doloribus repudiandae.', 42, '2025-11-28 12:44:38.188574', 116, 79, 82);
INSERT INTO public.reviews VALUES ('Autem blanditiis officiis aspernatur aperiam perspiciatis.', 81, '2025-11-28 12:44:38.188574', 117, 79, 33);
INSERT INTO public.reviews VALUES ('Vero deleniti nesciunt fuga culpa explicabo natus.', 58, '2025-11-28 12:44:38.188574', 118, 80, 84);
INSERT INTO public.reviews VALUES ('Ipsum similique quae magnam libero.', 65, '2025-11-28 12:44:38.188574', 119, 81, 18);
INSERT INTO public.reviews VALUES ('Quia quas atque temporibus a cumque error.', 41, '2025-11-28 12:44:38.188574', 120, 82, 88);
INSERT INTO public.reviews VALUES ('Occaecati eos architecto ratione repellat occaecati animi.', 78, '2025-11-28 12:44:38.188574', 121, 83, 51);
INSERT INTO public.reviews VALUES ('Voluptas ut sequi sapiente nesciunt.', 78, '2025-11-28 12:44:38.188574', 122, 84, 19);
INSERT INTO public.reviews VALUES ('Corporis exercitationem veniam.', 51, '2025-11-28 12:44:38.188574', 123, 85, 28);
INSERT INTO public.reviews VALUES ('Quaerat nihil distinctio in excepturi rerum.', 76, '2025-11-28 12:44:38.188574', 124, 86, 84);
INSERT INTO public.reviews VALUES ('Aspernatur porro inventore repellat deserunt.', 37, '2025-11-28 12:44:38.188574', 125, 86, 9);
INSERT INTO public.reviews VALUES ('Facilis delectus odit nostrum.', 43, '2025-11-28 12:44:38.188574', 126, 87, 64);
INSERT INTO public.reviews VALUES ('Maiores id veritatis laborum suscipit sed ipsam.', 90, '2025-11-28 12:44:38.188574', 127, 88, 40);
INSERT INTO public.reviews VALUES ('Provident culpa molestias quasi adipisci inventore facilis consequuntur.', 26, '2025-11-28 12:44:38.188574', 128, 89, 76);
INSERT INTO public.reviews VALUES ('Incidunt optio id expedita ullam ea ut.', 96, '2025-11-28 12:44:38.188574', 129, 90, 90);
INSERT INTO public.reviews VALUES ('Culpa alias fugit aliquid.', 35, '2025-11-28 12:44:38.188574', 130, 90, 9);
INSERT INTO public.reviews VALUES ('Nulla illum expedita.', 31, '2025-11-28 12:44:38.188574', 131, 91, 36);
INSERT INTO public.reviews VALUES ('Impedit placeat maiores sed cum.', 54, '2025-11-28 12:44:38.188574', 132, 91, 80);
INSERT INTO public.reviews VALUES ('Quo sunt placeat culpa.', 68, '2025-11-28 12:44:38.188574', 133, 92, 30);
INSERT INTO public.reviews VALUES ('Architecto quia aut maiores blanditiis.', 61, '2025-11-28 12:44:38.188574', 134, 93, 12);
INSERT INTO public.reviews VALUES ('Deleniti accusamus necessitatibus saepe dolor officiis autem error.', 69, '2025-11-28 12:44:38.188574', 135, 94, 43);
INSERT INTO public.reviews VALUES ('Quod laudantium sit repudiandae inventore.', 57, '2025-11-28 12:44:38.188574', 136, 94, 15);
INSERT INTO public.reviews VALUES ('Ullam consequatur impedit qui modi.', 29, '2025-11-28 12:44:38.188574', 137, 95, 57);
INSERT INTO public.reviews VALUES ('Amet ullam nulla alias hic delectus.', 44, '2025-11-28 12:44:38.188574', 138, 96, 54);
INSERT INTO public.reviews VALUES ('Eaque dolor laudantium in quos atque.', 71, '2025-11-28 12:44:38.188574', 139, 97, 15);
INSERT INTO public.reviews VALUES ('Consequuntur distinctio ipsa.', 71, '2025-11-28 12:44:38.188574', 140, 97, 69);
INSERT INTO public.reviews VALUES ('Eveniet adipisci sapiente porro perferendis repellendus.', 99, '2025-11-28 12:44:38.188574', 141, 98, 48);
INSERT INTO public.reviews VALUES ('Est aspernatur aspernatur.', 25, '2025-11-28 12:44:38.188574', 142, 98, 8);
INSERT INTO public.reviews VALUES ('Quibusdam ea explicabo praesentium saepe dolores soluta repellat.', 96, '2025-11-28 12:44:38.188574', 143, 99, 62);
INSERT INTO public.reviews VALUES ('Porro possimus sint quidem quae voluptatum.', 73, '2025-11-28 12:44:38.188574', 144, 100, 43);
INSERT INTO public.reviews VALUES ('Ab numquam accusamus aliquam perferendis ratione.', 84, '2025-11-28 12:44:38.188574', 145, 100, 53);


--
-- TOC entry 3936 (class 0 OID 31569)
-- Dependencies: 248
-- Data for Name: socials; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.socials VALUES (1, 1, 'https://instagram.com/artist_1');
INSERT INTO public.socials VALUES (2, 2, 'https://instagram.com/artist_2');
INSERT INTO public.socials VALUES (3, 3, 'https://instagram.com/artist_3');
INSERT INTO public.socials VALUES (4, 4, 'https://instagram.com/artist_4');
INSERT INTO public.socials VALUES (5, 5, 'https://instagram.com/artist_5');
INSERT INTO public.socials VALUES (6, 6, 'https://instagram.com/artist_6');
INSERT INTO public.socials VALUES (7, 7, 'https://instagram.com/artist_7');
INSERT INTO public.socials VALUES (8, 8, 'https://instagram.com/artist_8');
INSERT INTO public.socials VALUES (9, 9, 'https://instagram.com/artist_9');
INSERT INTO public.socials VALUES (10, 10, 'https://instagram.com/artist_10');
INSERT INTO public.socials VALUES (11, 11, 'https://instagram.com/artist_11');
INSERT INTO public.socials VALUES (12, 12, 'https://instagram.com/artist_12');
INSERT INTO public.socials VALUES (13, 13, 'https://instagram.com/artist_13');
INSERT INTO public.socials VALUES (14, 14, 'https://instagram.com/artist_14');
INSERT INTO public.socials VALUES (15, 15, 'https://instagram.com/artist_15');
INSERT INTO public.socials VALUES (16, 16, 'https://instagram.com/artist_16');
INSERT INTO public.socials VALUES (17, 17, 'https://instagram.com/artist_17');
INSERT INTO public.socials VALUES (18, 18, 'https://instagram.com/artist_18');
INSERT INTO public.socials VALUES (19, 19, 'https://instagram.com/artist_19');
INSERT INTO public.socials VALUES (20, 20, 'https://instagram.com/artist_20');
INSERT INTO public.socials VALUES (21, 21, 'https://instagram.com/artist_21');
INSERT INTO public.socials VALUES (22, 22, 'https://instagram.com/artist_22');
INSERT INTO public.socials VALUES (23, 23, 'https://instagram.com/artist_23');
INSERT INTO public.socials VALUES (24, 24, 'https://instagram.com/artist_24');
INSERT INTO public.socials VALUES (25, 25, 'https://instagram.com/artist_25');
INSERT INTO public.socials VALUES (26, 26, 'https://instagram.com/artist_26');
INSERT INTO public.socials VALUES (27, 27, 'https://instagram.com/artist_27');
INSERT INTO public.socials VALUES (28, 28, 'https://instagram.com/artist_28');
INSERT INTO public.socials VALUES (29, 29, 'https://instagram.com/artist_29');
INSERT INTO public.socials VALUES (30, 30, 'https://instagram.com/artist_30');
INSERT INTO public.socials VALUES (31, 31, 'https://instagram.com/artist_31');
INSERT INTO public.socials VALUES (32, 32, 'https://instagram.com/artist_32');
INSERT INTO public.socials VALUES (33, 33, 'https://instagram.com/artist_33');
INSERT INTO public.socials VALUES (34, 34, 'https://instagram.com/artist_34');
INSERT INTO public.socials VALUES (35, 35, 'https://instagram.com/artist_35');
INSERT INTO public.socials VALUES (36, 36, 'https://instagram.com/artist_36');
INSERT INTO public.socials VALUES (37, 37, 'https://instagram.com/artist_37');
INSERT INTO public.socials VALUES (38, 38, 'https://instagram.com/artist_38');
INSERT INTO public.socials VALUES (39, 39, 'https://instagram.com/artist_39');
INSERT INTO public.socials VALUES (40, 40, 'https://instagram.com/artist_40');
INSERT INTO public.socials VALUES (41, 41, 'https://instagram.com/artist_41');
INSERT INTO public.socials VALUES (42, 42, 'https://instagram.com/artist_42');
INSERT INTO public.socials VALUES (43, 43, 'https://instagram.com/artist_43');
INSERT INTO public.socials VALUES (44, 44, 'https://instagram.com/artist_44');
INSERT INTO public.socials VALUES (45, 45, 'https://instagram.com/artist_45');
INSERT INTO public.socials VALUES (46, 46, 'https://instagram.com/artist_46');
INSERT INTO public.socials VALUES (47, 47, 'https://instagram.com/artist_47');
INSERT INTO public.socials VALUES (48, 48, 'https://instagram.com/artist_48');
INSERT INTO public.socials VALUES (49, 49, 'https://instagram.com/artist_49');
INSERT INTO public.socials VALUES (50, 50, 'https://instagram.com/artist_50');
INSERT INTO public.socials VALUES (51, 51, 'https://instagram.com/artist_51');
INSERT INTO public.socials VALUES (52, 52, 'https://instagram.com/artist_52');
INSERT INTO public.socials VALUES (53, 53, 'https://instagram.com/artist_53');
INSERT INTO public.socials VALUES (54, 54, 'https://instagram.com/artist_54');
INSERT INTO public.socials VALUES (55, 55, 'https://instagram.com/artist_55');
INSERT INTO public.socials VALUES (56, 56, 'https://instagram.com/artist_56');
INSERT INTO public.socials VALUES (57, 57, 'https://instagram.com/artist_57');
INSERT INTO public.socials VALUES (58, 58, 'https://instagram.com/artist_58');
INSERT INTO public.socials VALUES (59, 59, 'https://instagram.com/artist_59');
INSERT INTO public.socials VALUES (60, 60, 'https://instagram.com/artist_60');
INSERT INTO public.socials VALUES (61, 61, 'https://instagram.com/artist_61');
INSERT INTO public.socials VALUES (62, 62, 'https://instagram.com/artist_62');
INSERT INTO public.socials VALUES (63, 63, 'https://instagram.com/artist_63');
INSERT INTO public.socials VALUES (64, 64, 'https://instagram.com/artist_64');
INSERT INTO public.socials VALUES (65, 65, 'https://instagram.com/artist_65');
INSERT INTO public.socials VALUES (66, 66, 'https://instagram.com/artist_66');
INSERT INTO public.socials VALUES (67, 67, 'https://instagram.com/artist_67');
INSERT INTO public.socials VALUES (68, 68, 'https://instagram.com/artist_68');
INSERT INTO public.socials VALUES (69, 69, 'https://instagram.com/artist_69');
INSERT INTO public.socials VALUES (70, 70, 'https://instagram.com/artist_70');
INSERT INTO public.socials VALUES (71, 71, 'https://instagram.com/artist_71');
INSERT INTO public.socials VALUES (72, 72, 'https://instagram.com/artist_72');
INSERT INTO public.socials VALUES (73, 73, 'https://instagram.com/artist_73');


--
-- TOC entry 3937 (class 0 OID 31581)
-- Dependencies: 249
-- Data for Name: songs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.songs VALUES (51, '/stream/audio_default.mp3', 'Fearless (Taylor’s Version)', 3, NULL, 241, 0.545, 0.070, 0.082, 0.397, 50, '2021-04-09', 59);
INSERT INTO public.songs VALUES (67, '/stream/audio_default.mp3', 'Bad (feat. Rihanna) - Remix', 1, NULL, 238, 0.407, 0.147, 0.428, 0.401, 17, '2013-06-25', 44);
INSERT INTO public.songs VALUES (83, '/stream/audio_default.mp3', 'Titik Nadir (feat. Monita Tahalea)', 3, NULL, 245, 0.647, 0.931, 0.833, 0.891, 50, '2025-06-24', 50);
INSERT INTO public.songs VALUES (35, '/stream/audio_default.mp3', 'I Love You So', 4, NULL, 160, 0.811, 0.229, 0.067, 0.334, 67, '2014-11-28', 48);
INSERT INTO public.songs VALUES (31, '/stream/audio_default.mp3', 'Love Me', 2, NULL, 191, 0.443, 0.977, 0.215, 0.805, 33, '2009-01-01', 70);
INSERT INTO public.songs VALUES (32, '/stream/audio_default.mp3', 'LOVE SCENARIO', 2, NULL, 209, 0.478, 0.619, 0.548, 0.969, 33, '2018-01-25', 57);
INSERT INTO public.songs VALUES (9, '/stream/audio_default.mp3', 'Love Me Like There''s No Tomorrow - Special Edition', 3, NULL, 225, 0.974, 0.449, 0.701, 0.030, 83, '2019-10-10', 44);
INSERT INTO public.songs VALUES (15, '/stream/audio_default.mp3', 'Love Me Like You', 6, NULL, 197, 0.627, 0.506, 0.957, 0.113, 100, '2015-11-06', 86);
INSERT INTO public.songs VALUES (24, '/stream/audio_default.mp3', 'Love, Maybe', 4, NULL, 185, 0.296, 0.488, 0.530, 0.674, 67, '2022-02-18', 37);
INSERT INTO public.songs VALUES (94, '/stream/audio_default.mp3', 'MIA (feat. Drake)', 3, NULL, 217, 0.833, 0.961, 0.420, 0.619, 50, '2020-01-01', 67);
INSERT INTO public.songs VALUES (64, '/stream/audio_default.mp3', 'Please Please Please', 1, NULL, 186, 0.058, 0.270, 0.247, 0.001, 17, '2024-06-06', 32);
INSERT INTO public.songs VALUES (27, '/stream/audio_default.mp3', 'Love Me Like You Do - From "Fifty Shades Of Grey"', 1, NULL, 252, 0.281, 0.127, 0.377, 0.875, 17, '2015-11-06', 33);
INSERT INTO public.songs VALUES (23, '/stream/audio_default.mp3', 'love nwantiti (feat. Dj Yo! & AX''EL) - Remix', 3, NULL, 188, 0.263, 0.322, 0.190, 0.069, 50, '2021-09-09', 48);
INSERT INTO public.songs VALUES (86, '/stream/audio_default.mp3', 'Best Part (feat. H.E.R.)', 3, NULL, 209, 0.550, 0.965, 0.494, 0.149, 50, '2017-08-25', NULL);
INSERT INTO public.songs VALUES (88, '/stream/audio_default.mp3', 'BIRDS OF A FEATHER - ISOLATED VOCALS/Visualizer', 3, NULL, 210, 0.499, 0.879, 0.798, 0.540, 50, '2024-09-25', NULL);
INSERT INTO public.songs VALUES (60, '/stream/audio_default.mp3', 'Feather - Sped Up', 2, NULL, 153, 0.403, 0.321, 0.243, 0.824, 33, '2023-08-04', 55);
INSERT INTO public.songs VALUES (11, '/stream/audio_default.mp3', 'Love You Like A Love Song', 3, NULL, 188, 0.080, 0.113, 0.531, 0.352, 50, '2011-01-01', 44);
INSERT INTO public.songs VALUES (20, '/stream/audio_default.mp3', 'Love Potions', 3, NULL, 173, 0.869, 0.277, 0.337, 0.778, 50, '2021-08-02', 91);
INSERT INTO public.songs VALUES (13, '/stream/audio_default.mp3', 'Love Epiphany', 2, NULL, 338, 0.886, 0.549, 0.812, 0.357, 33, '2023-05-26', 81);
INSERT INTO public.songs VALUES (98, '/stream/audio_default.mp3', 'illusion hills feat KAIRO - so bad (official music video)', 3, NULL, 182, 0.672, 0.321, 0.612, 0.055, 50, '2025-02-26', 66);
INSERT INTO public.songs VALUES (40, '/stream/audio_default.mp3', 'Loved Me Back to Life - Live in Quebec City', 1, NULL, 235, 0.895, 0.788, 0.124, 0.831, 17, '2013-09-17', 16);
INSERT INTO public.songs VALUES (37, '/stream/audio_default.mp3', 'Terlalu Lama', 1, NULL, 247, 0.660, 0.264, 0.017, 0.186, 17, '2011-02-01', 84);
INSERT INTO public.songs VALUES (56, '/stream/audio_default.mp3', 'Tarian Penghancur Raya', 2, NULL, 240, 0.954, 0.766, 0.357, 0.758, 33, '2019-11-08', 81);
INSERT INTO public.songs VALUES (62, '/stream/audio_default.mp3', 'Taste', 0, NULL, 157, 0.060, 0.636, 0.709, 0.759, 87, '2024-08-23', 25);
INSERT INTO public.songs VALUES (70, '/stream/audio_default.mp3', 'Kita Ke Sana', 3, NULL, 282, 0.684, 0.633, 0.244, 0.747, 50, '2023-07-21', 75);
INSERT INTO public.songs VALUES (10, '/stream/audio_default.mp3', 'Love Is Gone - Acoustic', 2, NULL, 176, 0.161, 0.935, 0.283, 0.092, 33, '2019-11-13', 62);
INSERT INTO public.songs VALUES (39, '/stream/audio_default.mp3', 'Love Of Mine', 4, NULL, 250, 0.060, 0.719, 0.645, 0.008, 67, '2022-09-01', 41);
INSERT INTO public.songs VALUES (92, '/stream/audio_default.mp3', 'Easy (feat. Jonsal Barrientes) - Live', 4, NULL, 317, 0.323, 0.384, 0.951, 0.030, 67, '2024-07-12', 59);
INSERT INTO public.songs VALUES (66, '/stream/audio_default.mp3', 'Bintang Massa Aksi', 1, NULL, 214, 0.746, 0.071, 0.744, 0.780, 17, '2022-04-22', 15);
INSERT INTO public.songs VALUES (73, '/stream/audio_default.mp3', 'Rumah Ke Rumah', 5, NULL, 277, 0.057, 0.905, 0.967, 0.931, 83, '2019-11-29', 40);
INSERT INTO public.songs VALUES (38, '/stream/audio_default.mp3', 'รักคือ...', 3, NULL, 220, 0.601, 0.587, 0.603, 0.279, 50, '2004-01-01', 42);
INSERT INTO public.songs VALUES (26, '/stream/audio_default.mp3', 'Love Story - Slowed & Reverb', 3, NULL, 295, 0.652, 0.464, 0.383, 0.762, 50, '2022-11-10', 48);
INSERT INTO public.songs VALUES (19, '/stream/audio_default.mp3', 'Lovefool', 2, NULL, 193, 0.304, 0.996, 0.354, 0.468, 33, '1996-01-01', 48);
INSERT INTO public.songs VALUES (47, '/stream/audio_default.mp3', 'Love Foolosophy - Live in Verona', 4, NULL, 462, 0.250, 0.362, 0.384, 0.553, 67, '2002-01-01', 16);
INSERT INTO public.songs VALUES (76, '/stream/audio_default.mp3', 'Nina', 1, NULL, 277, 0.673, 0.096, 0.593, 0.108, 17, '2024-08-30', 46);
INSERT INTO public.songs VALUES (91, '/stream/audio_default.mp3', 'Dancing (feat. Joe L Barnes & Tiffany Hudson) - Live', 2, NULL, 304, 0.979, 0.081, 0.348, 0.277, 33, '2022-03-04', 43);
INSERT INTO public.songs VALUES (8, '/stream/audio_default.mp3', 'Love, Maybe', 3, NULL, 185, 0.310, 0.465, 0.000, 0.258, 50, '2022-03-14', 64);
INSERT INTO public.songs VALUES (87, '/stream/audio_default.mp3', 'Calon Mantu Idaman (feat. Ncum)', 3, NULL, 189, 0.419, 0.791, 0.587, 0.701, 50, '2025-05-16', 52);
INSERT INTO public.songs VALUES (29, '/stream/audio_default.mp3', 'Lovers Rock', 4, NULL, 213, 0.437, 0.796, 0.638, 0.627, 67, '2014-06-05', 60);
INSERT INTO public.songs VALUES (34, '/stream/audio_default.mp3', 'Love Story (Taylor’s Version)', 2, NULL, 235, 0.395, 0.500, 0.103, 0.104, 33, '2021-04-09', 71);
INSERT INTO public.songs VALUES (52, '/stream/audio_default.mp3', 'Feather (feat. Cise Starr & Akin from CYNE)', 3, NULL, 175, 0.933, 0.782, 0.392, 0.727, 50, '2005-11-11', 36);
INSERT INTO public.songs VALUES (63, '/stream/audio_default.mp3', 'Fearless Pt. II', 6, NULL, 194, 0.834, 0.771, 0.504, 0.864, 100, '2017-12-23', 30);
INSERT INTO public.songs VALUES (90, '/stream/audio_default.mp3', 'To Love You More feat. Taro Hakase (Live in Memphis, 1997)', 3, NULL, 311, 0.758, 0.484, 0.106, 0.197, 50, '1998-01-01', 92);
INSERT INTO public.songs VALUES (14, '/stream/audio_default.mp3', 'Love Grows (Where My Rosemary Goes)', 2, NULL, 174, 0.056, 0.637, 0.140, 0.941, 33, '1970-01-01', 33);
INSERT INTO public.songs VALUES (59, '/stream/audio_default.mp3', 'Espresso', 2, NULL, 175, 0.122, 0.581, 0.599, 0.792, 33, '2024-04-12', 29);
INSERT INTO public.songs VALUES (75, '/stream/audio_default.mp3', 'Evaluasi', 1, NULL, 194, 0.030, 0.398, 0.453, 0.208, 17, '2019-11-29', 54);
INSERT INTO public.songs VALUES (99, '/stream/audio_default.mp3', 'SH♡TGUN feat. JIMMY, WEESA, ぺろぺろきゃんでー', 1, NULL, 184, 0.178, 0.393, 0.502, 0.683, 17, '2024-12-27', 30);
INSERT INTO public.songs VALUES (48, '/stream/audio_default.mp3', 'Love Me Anyway', 1, NULL, 163, 0.793, 0.215, 0.713, 0.675, 17, '2022-07-22', 6);
INSERT INTO public.songs VALUES (72, '/stream/audio_default.mp3', 'Secukupnya', 5, NULL, 205, 0.647, 0.661, 0.153, 0.888, 83, '2019-11-29', 59);
INSERT INTO public.songs VALUES (61, '/stream/audio_default.mp3', 'Gugatan Rakyat Semesta', 2, NULL, 266, 0.091, 0.259, 0.408, 0.256, 33, '2022-04-22', 49);
INSERT INTO public.songs VALUES (49, '/stream/audio_default.mp3', 'Love to Love You - Live at Royal Albert Hall', 2, NULL, 241, 0.804, 0.898, 0.654, 0.764, 33, '2000-01-01', 41);
INSERT INTO public.songs VALUES (17, '/stream/audio_default.mp3', 'love nwantiti (ah ah ah)', 1, NULL, 145, 0.856, 0.049, 0.660, 0.831, 17, '2019-08-30', 61);
INSERT INTO public.songs VALUES (33, '/stream/audio_default.mp3', 'Love Story - Version Orchestrale', 2, NULL, 297, 0.695, 0.716, 0.873, 0.557, 33, '2014-11-17', 27);
INSERT INTO public.songs VALUES (1, '/stream/audio_default.mp3', 'Lover Girl', 3, NULL, 164, 0.607, 0.664, 0.433, 0.520, 50, '2025-06-25', 92);
INSERT INTO public.songs VALUES (18, '/stream/audio_default.mp3', 'lovely', 2, NULL, 200, 0.342, 0.064, 0.724, 0.476, 33, '2021-10-05', 71);
INSERT INTO public.songs VALUES (55, '/stream/audio_default.mp3', 'Berdansalah, Karir Ini Tak Ada Artinya', 4, NULL, 224, 0.651, 0.450, 0.112, 0.669, 67, '2023-07-21', 52);
INSERT INTO public.songs VALUES (54, '/stream/audio_default.mp3', 'X (feat. Maluma & Ozuna) - Remix', 0, NULL, 236, 0.853, 0.813, 0.756, 0.155, 80, '2018-06-29', 56);
INSERT INTO public.songs VALUES (58, '/stream/audio_default.mp3', 'Nonsense', 2, NULL, 163, 0.832, 0.157, 0.594, 0.237, 33, '2022-07-15', 70);
INSERT INTO public.songs VALUES (80, '/stream/audio_default.mp3', 'On The Floor', 1, NULL, 284, 0.536, 0.610, 0.583, 0.730, 17, '2011-04-29', 58);
INSERT INTO public.songs VALUES (45, '/stream/audio_default.mp3', 'Love Me Not', 6, NULL, 213, 0.832, 0.226, 0.646, 0.636, 100, '2024-08-09', 45);
INSERT INTO public.songs VALUES (6, '/stream/audio_default.mp3', 'Lovesick Girls', 4, NULL, 192, 0.164, 0.433, 0.685, 0.878, 67, '2020-10-02', 39);
INSERT INTO public.songs VALUES (93, '/stream/audio_default.mp3', 'liMOusIne (feat. AURORA) - Live from Japan', 4, NULL, 310, 0.293, 0.837, 0.106, 0.635, 67, '2024-09-27', 16);
INSERT INTO public.songs VALUES (36, '/stream/audio_default.mp3', 'My Love Mine All Mine', 1, NULL, 137, 0.887, 0.573, 0.793, 0.543, 17, '2023-09-15', 47);
INSERT INTO public.songs VALUES (69, '/stream/audio_default.mp3', 'Cincin', 2, NULL, 266, 0.142, 0.182, 0.764, 0.923, 33, '2023-07-07', 92);
INSERT INTO public.songs VALUES (97, '/stream/audio_default.mp3', '别勉强 (feat. Eric 周兴哲)', 1, NULL, 278, 0.220, 0.999, 0.039, 0.382, 17, '2020-06-29', 53);
INSERT INTO public.songs VALUES (22, '/stream/audio_default.mp3', 'Love - Amapiano Remix', 2, NULL, 347, 0.167, 0.750, 0.727, 0.589, 33, '2025-01-06', 66);
INSERT INTO public.songs VALUES (2, '/stream/audio_default.mp3', 'Love wins all', 1, NULL, 271, 0.146, 0.788, 0.916, 0.802, 17, '2024-01-24', 53);
INSERT INTO public.songs VALUES (44, '/stream/audio_default.mp3', 'Love Like You (feat. Kenzie Walker) - Live', 0, NULL, 282, 0.017, 0.578, 0.321, 0.827, 0, '2020-07-31', 75);
INSERT INTO public.songs VALUES (68, '/stream/audio_default.mp3', 'Berita Kehilangan', 0, NULL, 259, 0.767, 0.678, 0.038, 0.021, 66, '2018-08-10', 98);
INSERT INTO public.songs VALUES (16, '/stream/audio_default.mp3', 'Love On Top', 1, NULL, 267, 0.377, 0.776, 0.082, 0.903, 17, '2011-06-24', 35);
INSERT INTO public.songs VALUES (82, '/stream/audio_default.mp3', 'Timeless (feat Playboi Carti)', 3, NULL, 256, 0.597, 0.565, 0.583, 0.299, 50, '2025-01-31', 60);
INSERT INTO public.songs VALUES (41, '/stream/audio_default.mp3', 'Love''s a Waste (feat. James Smith) - Live at Metropolis, London, 2020', 5, NULL, 232, 0.264, 0.669, 0.802, 0.682, 83, '2020-02-14', 63);
INSERT INTO public.songs VALUES (100, '/stream/audio_default.mp3', 'Snarky Puppy feat. KNOWER - One Hope', 4, NULL, 201, 0.732, 0.154, 0.066, 0.099, 67, '2016-01-01', 49);
INSERT INTO public.songs VALUES (78, '/stream/audio_default.mp3', 'Jika (feat. Ari Lasso)', 4, NULL, 324, 0.184, 0.002, 0.888, 0.346, 67, '1999-11-26', 31);
INSERT INTO public.songs VALUES (81, '/stream/audio_default.mp3', 'Kesayanganku (feat. Chelsea Shania) [From "Samudra Cinta"]', 1, NULL, 242, 0.923, 0.377, 0.777, 0.864, 17, '2020-01-10', 64);
INSERT INTO public.songs VALUES (77, '/stream/audio_default.mp3', 'Beautiful (feat. Camila Cabello)', 4, NULL, 180, 0.853, 0.761, 0.133, 0.394, 67, '2018-08-02', 43);
INSERT INTO public.songs VALUES (30, '/stream/audio_default.mp3', 'LOVE. FEAT. ZACARI.', 1, NULL, 213, 0.819, 0.361, 0.080, 0.761, 17, '2017-04-14', 51);
INSERT INTO public.songs VALUES (21, '/stream/audio_default.mp3', 'Love For You', 2, NULL, 170, 0.503, 0.347, 0.199, 0.106, 33, '2022-05-21', 21);
INSERT INTO public.songs VALUES (5, '/stream/audio_default.mp3', 'Love Me Harder', 1, NULL, 236, 0.013, 0.089, 0.059, 0.643, 17, '2014-08-22', 91);
INSERT INTO public.songs VALUES (79, '/stream/audio_default.mp3', 'Sampai Akhir (feat. DuMa)', 0, NULL, 205, 0.470, 0.614, 0.509, 0.826, 71, '2013-05-13', 40);
INSERT INTO public.songs VALUES (7, '/stream/audio_default.mp3', 'Loveeeeeee Song', 0, NULL, 256, 0.570, 0.574, 0.535, 0.776, 78, '2012-12-11', 6);
INSERT INTO public.songs VALUES (65, '/stream/audio_default.mp3', 'Peradaban', 0, NULL, 339, 0.729, 0.947, 0.831, 0.296, 73, '2018-07-13', 56);
INSERT INTO public.songs VALUES (74, '/stream/audio_default.mp3', 'Cincin', 1, NULL, 266, 0.640, 0.119, 0.360, 0.150, 17, '2023-07-21', 55);
INSERT INTO public.songs VALUES (71, '/stream/audio_default.mp3', 'Bed Chem', 5, NULL, 171, 0.124, 0.254, 0.290, 0.080, 83, '2024-08-23', 30);
INSERT INTO public.songs VALUES (4, '/stream/audio_default.mp3', 'Lover, You Should''ve Come Over', 2, NULL, 404, 0.414, 0.354, 0.369, 0.781, 33, '1994-01-01', 74);
INSERT INTO public.songs VALUES (96, '/stream/audio_default.mp3', 'Runnin (feat. Brandon Lake) - Live', 1, NULL, 376, 0.966, 0.711, 0.966, 0.363, 17, '2023-05-19', 47);
INSERT INTO public.songs VALUES (84, '/stream/audio_default.mp3', 'Margaret (feat. Bleachers)', 5, NULL, 339, 0.764, 0.278, 0.586, 0.179, 83, '2023-03-24', 68);
INSERT INTO public.songs VALUES (89, '/stream/audio_default.mp3', 'Toss the Feathers - Live at Royal Albert Hall', 4, NULL, 198, 0.673, 0.946, 0.903, 0.884, 67, '2000-01-01', 87);
INSERT INTO public.songs VALUES (50, '/stream/audio_default.mp3', 'Love Me - Live On The Ed Sullivan Show, October 28, 1956', 2, NULL, 188, 0.536, 0.830, 0.283, 0.515, 33, '1956-10-28', 69);
INSERT INTO public.songs VALUES (42, '/stream/audio_default.mp3', 'Love Me Like You - Live from The Get Weird Tour: Wembley Arena, 2016', 3, NULL, 295, 0.796, 0.030, 0.688, 0.087, 50, '2016-01-01', 34);
INSERT INTO public.songs VALUES (46, '/stream/audio_default.mp3', 'lovers’ carvings - Live Acoustic', 3, NULL, 170, 0.185, 0.327, 0.116, 0.261, 50, '2009-06-22', 43);
INSERT INTO public.songs VALUES (43, '/stream/audio_default.mp3', 'Love Buzz - Live At Reading, 1992', 3, NULL, 231, 0.620, 0.160, 0.905, 0.270, 50, '2009-01-01', 64);
INSERT INTO public.songs VALUES (53, '/stream/audio_default.mp3', 'Arteri', 6, NULL, 270, 0.024, 0.482, 0.175, 0.363, 100, '2024-08-30', 53);
INSERT INTO public.songs VALUES (12, '/stream/audio_default.mp3', 'Love Letter From The Sea to The Shore', 3, NULL, 191, 0.856, 0.407, 0.616, 0.094, 50, '2022-12-16', 85);
INSERT INTO public.songs VALUES (85, '/stream/audio_default.mp3', 'Rockabye (feat. Sean Paul & Anne-Marie)', 3, NULL, 251, 0.455, 0.404, 0.908, 0.942, 50, '2018-11-30', 62);
INSERT INTO public.songs VALUES (95, '/stream/audio_default.mp3', 'IDOL (feat. Nicki Minaj)', 3, NULL, 286, 0.372, 0.285, 0.370, 0.810, 50, '2018-09-07', 66);
INSERT INTO public.songs VALUES (57, '/stream/audio_default.mp3', 'Manchild', 3, NULL, 213, 0.229, 0.359, 0.001, 0.434, 50, '2025-06-05', 70);
INSERT INTO public.songs VALUES (25, '/stream/audio_default.mp3', 'Love Of My Life', 4, NULL, 217, 0.898, 0.036, 0.620, 0.804, 67, '2017-02-10', 60);
INSERT INTO public.songs VALUES (3, '/stream/audio_default.mp3', 'Love Is an Open Door - From "Frozen"/Soundtrack Version', 2, NULL, 124, 0.647, 0.353, 0.693, 0.732, 33, '2013-01-01', 87);
INSERT INTO public.songs VALUES (28, '/stream/audio_default.mp3', 'Love Story', 3, NULL, 236, 0.942, 0.226, 0.336, 0.388, 50, '2008-11-11', 44);


--
-- TOC entry 3938 (class 0 OID 31595)
-- Dependencies: 250
-- Data for Name: songs_genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.songs_genres VALUES (1, 2);
INSERT INTO public.songs_genres VALUES (2, 2);
INSERT INTO public.songs_genres VALUES (2, 3);
INSERT INTO public.songs_genres VALUES (1, 3);
INSERT INTO public.songs_genres VALUES (1, 4);
INSERT INTO public.songs_genres VALUES (2, 4);
INSERT INTO public.songs_genres VALUES (1, 6);
INSERT INTO public.songs_genres VALUES (2, 7);
INSERT INTO public.songs_genres VALUES (3, 7);
INSERT INTO public.songs_genres VALUES (1, 8);
INSERT INTO public.songs_genres VALUES (2, 9);
INSERT INTO public.songs_genres VALUES (1, 9);
INSERT INTO public.songs_genres VALUES (4, 10);
INSERT INTO public.songs_genres VALUES (6, 10);
INSERT INTO public.songs_genres VALUES (2, 11);
INSERT INTO public.songs_genres VALUES (6, 11);
INSERT INTO public.songs_genres VALUES (1, 12);
INSERT INTO public.songs_genres VALUES (2, 12);
INSERT INTO public.songs_genres VALUES (8, 13);
INSERT INTO public.songs_genres VALUES (6, 14);
INSERT INTO public.songs_genres VALUES (5, 14);
INSERT INTO public.songs_genres VALUES (7, 15);
INSERT INTO public.songs_genres VALUES (3, 15);
INSERT INTO public.songs_genres VALUES (3, 16);
INSERT INTO public.songs_genres VALUES (6, 16);
INSERT INTO public.songs_genres VALUES (10, 17);
INSERT INTO public.songs_genres VALUES (9, 17);
INSERT INTO public.songs_genres VALUES (2, 18);
INSERT INTO public.songs_genres VALUES (8, 18);
INSERT INTO public.songs_genres VALUES (13, 19);
INSERT INTO public.songs_genres VALUES (12, 20);
INSERT INTO public.songs_genres VALUES (1, 20);
INSERT INTO public.songs_genres VALUES (4, 21);
INSERT INTO public.songs_genres VALUES (2, 21);
INSERT INTO public.songs_genres VALUES (14, 22);
INSERT INTO public.songs_genres VALUES (15, 22);
INSERT INTO public.songs_genres VALUES (11, 23);
INSERT INTO public.songs_genres VALUES (12, 23);
INSERT INTO public.songs_genres VALUES (1, 24);
INSERT INTO public.songs_genres VALUES (2, 24);
INSERT INTO public.songs_genres VALUES (17, 25);
INSERT INTO public.songs_genres VALUES (18, 25);
INSERT INTO public.songs_genres VALUES (9, 26);
INSERT INTO public.songs_genres VALUES (17, 26);
INSERT INTO public.songs_genres VALUES (17, 27);
INSERT INTO public.songs_genres VALUES (18, 27);
INSERT INTO public.songs_genres VALUES (8, 28);
INSERT INTO public.songs_genres VALUES (13, 28);
INSERT INTO public.songs_genres VALUES (5, 29);
INSERT INTO public.songs_genres VALUES (1, 29);
INSERT INTO public.songs_genres VALUES (19, 30);
INSERT INTO public.songs_genres VALUES (20, 30);
INSERT INTO public.songs_genres VALUES (13, 31);
INSERT INTO public.songs_genres VALUES (7, 31);
INSERT INTO public.songs_genres VALUES (1, 32);
INSERT INTO public.songs_genres VALUES (21, 33);
INSERT INTO public.songs_genres VALUES (7, 34);
INSERT INTO public.songs_genres VALUES (21, 34);
INSERT INTO public.songs_genres VALUES (4, 35);
INSERT INTO public.songs_genres VALUES (20, 35);
INSERT INTO public.songs_genres VALUES (10, 36);
INSERT INTO public.songs_genres VALUES (16, 36);
INSERT INTO public.songs_genres VALUES (22, 37);
INSERT INTO public.songs_genres VALUES (6, 38);
INSERT INTO public.songs_genres VALUES (3, 38);
INSERT INTO public.songs_genres VALUES (3, 39);
INSERT INTO public.songs_genres VALUES (21, 39);
INSERT INTO public.songs_genres VALUES (23, 40);
INSERT INTO public.songs_genres VALUES (10, 41);
INSERT INTO public.songs_genres VALUES (5, 41);
INSERT INTO public.songs_genres VALUES (19, 42);
INSERT INTO public.songs_genres VALUES (13, 42);
INSERT INTO public.songs_genres VALUES (24, 43);
INSERT INTO public.songs_genres VALUES (17, 43);
INSERT INTO public.songs_genres VALUES (26, 44);
INSERT INTO public.songs_genres VALUES (25, 44);
INSERT INTO public.songs_genres VALUES (29, 45);
INSERT INTO public.songs_genres VALUES (28, 45);
INSERT INTO public.songs_genres VALUES (30, 46);
INSERT INTO public.songs_genres VALUES (31, 46);
INSERT INTO public.songs_genres VALUES (32, 47);
INSERT INTO public.songs_genres VALUES (33, 48);
INSERT INTO public.songs_genres VALUES (34, 49);
INSERT INTO public.songs_genres VALUES (36, 50);
INSERT INTO public.songs_genres VALUES (35, 50);
INSERT INTO public.songs_genres VALUES (5, 51);
INSERT INTO public.songs_genres VALUES (6, 51);
INSERT INTO public.songs_genres VALUES (37, 52);
INSERT INTO public.songs_genres VALUES (38, 53);
INSERT INTO public.songs_genres VALUES (8, 53);
INSERT INTO public.songs_genres VALUES (40, 54);
INSERT INTO public.songs_genres VALUES (41, 54);
INSERT INTO public.songs_genres VALUES (8, 55);
INSERT INTO public.songs_genres VALUES (22, 55);
INSERT INTO public.songs_genres VALUES (22, 56);
INSERT INTO public.songs_genres VALUES (8, 56);
INSERT INTO public.songs_genres VALUES (3, 57);
INSERT INTO public.songs_genres VALUES (3, 58);
INSERT INTO public.songs_genres VALUES (3, 59);
INSERT INTO public.songs_genres VALUES (3, 60);
INSERT INTO public.songs_genres VALUES (22, 61);
INSERT INTO public.songs_genres VALUES (38, 61);
INSERT INTO public.songs_genres VALUES (3, 62);
INSERT INTO public.songs_genres VALUES (21, 63);
INSERT INTO public.songs_genres VALUES (2, 63);
INSERT INTO public.songs_genres VALUES (3, 64);
INSERT INTO public.songs_genres VALUES (39, 65);
INSERT INTO public.songs_genres VALUES (8, 65);
INSERT INTO public.songs_genres VALUES (39, 66);
INSERT INTO public.songs_genres VALUES (8, 66);
INSERT INTO public.songs_genres VALUES (34, 67);
INSERT INTO public.songs_genres VALUES (9, 67);
INSERT INTO public.songs_genres VALUES (38, 68);
INSERT INTO public.songs_genres VALUES (39, 68);
INSERT INTO public.songs_genres VALUES (8, 69);
INSERT INTO public.songs_genres VALUES (22, 69);
INSERT INTO public.songs_genres VALUES (8, 70);
INSERT INTO public.songs_genres VALUES (22, 70);
INSERT INTO public.songs_genres VALUES (3, 71);
INSERT INTO public.songs_genres VALUES (22, 72);
INSERT INTO public.songs_genres VALUES (8, 72);
INSERT INTO public.songs_genres VALUES (8, 73);
INSERT INTO public.songs_genres VALUES (22, 73);
INSERT INTO public.songs_genres VALUES (22, 74);
INSERT INTO public.songs_genres VALUES (8, 74);
INSERT INTO public.songs_genres VALUES (22, 75);
INSERT INTO public.songs_genres VALUES (8, 75);
INSERT INTO public.songs_genres VALUES (8, 76);
INSERT INTO public.songs_genres VALUES (39, 76);
INSERT INTO public.songs_genres VALUES (1, 77);
INSERT INTO public.songs_genres VALUES (21, 77);
INSERT INTO public.songs_genres VALUES (42, 78);
INSERT INTO public.songs_genres VALUES (22, 78);
INSERT INTO public.songs_genres VALUES (42, 79);
INSERT INTO public.songs_genres VALUES (43, 79);
INSERT INTO public.songs_genres VALUES (36, 80);
INSERT INTO public.songs_genres VALUES (20, 80);
INSERT INTO public.songs_genres VALUES (22, 81);
INSERT INTO public.songs_genres VALUES (10, 82);
INSERT INTO public.songs_genres VALUES (35, 82);
INSERT INTO public.songs_genres VALUES (44, 83);
INSERT INTO public.songs_genres VALUES (22, 83);
INSERT INTO public.songs_genres VALUES (29, 84);
INSERT INTO public.songs_genres VALUES (26, 84);
INSERT INTO public.songs_genres VALUES (15, 85);
INSERT INTO public.songs_genres VALUES (30, 85);
INSERT INTO public.songs_genres VALUES (26, 86);
INSERT INTO public.songs_genres VALUES (19, 86);
INSERT INTO public.songs_genres VALUES (45, 87);
INSERT INTO public.songs_genres VALUES (49, 87);
INSERT INTO public.songs_genres VALUES (43, 88);
INSERT INTO public.songs_genres VALUES (42, 88);
INSERT INTO public.songs_genres VALUES (34, 89);
INSERT INTO public.songs_genres VALUES (23, 90);
INSERT INTO public.songs_genres VALUES (50, 91);
INSERT INTO public.songs_genres VALUES (26, 91);
INSERT INTO public.songs_genres VALUES (51, 92);
INSERT INTO public.songs_genres VALUES (26, 92);
INSERT INTO public.songs_genres VALUES (55, 93);
INSERT INTO public.songs_genres VALUES (56, 93);
INSERT INTO public.songs_genres VALUES (41, 94);
INSERT INTO public.songs_genres VALUES (57, 94);
INSERT INTO public.songs_genres VALUES (1, 95);
INSERT INTO public.songs_genres VALUES (52, 96);
INSERT INTO public.songs_genres VALUES (50, 96);
INSERT INTO public.songs_genres VALUES (59, 97);
INSERT INTO public.songs_genres VALUES (60, 97);
INSERT INTO public.songs_genres VALUES (64, 98);
INSERT INTO public.songs_genres VALUES (65, 99);
INSERT INTO public.songs_genres VALUES (66, 100);
INSERT INTO public.songs_genres VALUES (70, 100);
INSERT INTO public.songs_genres VALUES (1, 5);
INSERT INTO public.songs_genres VALUES (2, 5);
INSERT INTO public.songs_genres VALUES (4, 2);
INSERT INTO public.songs_genres VALUES (4, 5);


--
-- TOC entry 3939 (class 0 OID 31605)
-- Dependencies: 251
-- Data for Name: tours; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tours VALUES (1, '2026-01-22', 'Banjar Tour', 'Perum Prabowo Arena');
INSERT INTO public.tours VALUES (2, '2026-07-16', 'Banjar Tour', 'CV Sitompul (Persero) Tbk Arena');
INSERT INTO public.tours VALUES (3, '2026-04-15', 'Dumai Tour', 'PT Sudiati (Persero) Tbk Arena');
INSERT INTO public.tours VALUES (4, '2026-01-02', 'Kupang Tour', 'PD Wasita Arena');
INSERT INTO public.tours VALUES (5, '2025-12-14', 'Bontang Tour', 'CV Wibisono Mayasari Tbk Arena');


--
-- TOC entry 3940 (class 0 OID 31617)
-- Dependencies: 252
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (1, 'jmangunsong', 'https://ui-avatars.com/api/?name=jmangunsong&background=random', '$2a$06$H4gNj/zGjGD/.1KYZ2efE.7q.N1wdMn8H2V1UAKltemkgwzYAu/nS', 'jmangunsong_1@example.com', 'Padangpanjang', 'Niger');
INSERT INTO public.users VALUES (2, 'purwantiqueen', 'https://ui-avatars.com/api/?name=purwantiqueen&background=random', '$2a$06$dp.o2c7lO2y/L35pO7SaIOy.kZ85ULCZ8crwTVF0yv7XD4a1u9Zo.', 'purwantiqueen_2@example.com', 'Kotamobagu', 'Burkina Faso');
INSERT INTO public.users VALUES (3, 'widodointan', 'https://ui-avatars.com/api/?name=widodointan&background=random', '$2a$06$GPmmWMaN9u0SdxNQzycgzuPCi2D757sUUGYxsznAh/6HIj1YA20qq', 'widodointan_3@example.com', 'Cimahi', 'Brunei');
INSERT INTO public.users VALUES (4, 'ikaanggriawan', 'https://ui-avatars.com/api/?name=ikaanggriawan&background=random', '$2a$06$6zp5gBh0LIGlb9knfwxtMe7Sh03LGqUMDs.E79P7grdxFM/ijZGUe', 'ikaanggriawan_4@example.com', 'Palembang', 'Nauru');
INSERT INTO public.users VALUES (5, 'palastrimelinda', 'https://ui-avatars.com/api/?name=palastrimelinda&background=random', '$2a$06$U3vWSzl4raO0ZGY8ax11j.KfRBOy19QfClIh7zxCmqcouw7TnmV/W', 'palastrimelinda_5@example.com', 'Parepare', 'Portugal');
INSERT INTO public.users VALUES (6, 'titiwijayanti', 'https://ui-avatars.com/api/?name=titiwijayanti&background=random', '$2a$06$ANGsoqsLK32VPusKtRxPD.feYuviPB0J6Hi.X.F3Ki6k2W.LC4J2e', 'titiwijayanti_6@example.com', 'Bekasi', 'Fiji');
INSERT INTO public.users VALUES (7, 'iharyanto', 'https://ui-avatars.com/api/?name=iharyanto&background=random', '$2a$06$h4/fJe3mfXLvDCuRWlpHCuSKtNuAMBbVZup0o4wfSgnmG1gF/7xMy', 'iharyanto_7@example.com', 'Pontianak', 'Republik Dominika');
INSERT INTO public.users VALUES (8, 'timbul65', 'https://ui-avatars.com/api/?name=timbul65&background=random', '$2a$06$mvkbwCKiQRVKAI/X.a1sa.hRmtzvk9B4oKWUOe3Pklqa2g41A84a.', 'timbul65_8@example.com', 'Banjarbaru', 'Peru');
INSERT INTO public.users VALUES (9, 'kasimsihombing', 'https://ui-avatars.com/api/?name=kasimsihombing&background=random', '$2a$06$TGJv0DTJtCF3tpeXZ3hfBuF8jdeiV4qAvjMPGkoDIfiyVs6o.yL8m', 'kasimsihombing_9@example.com', 'Sungai Penuh', 'Ethiopia');
INSERT INTO public.users VALUES (10, 'pradiptaozy', 'https://ui-avatars.com/api/?name=pradiptaozy&background=random', '$2a$06$ueZvg2EarqX0MW49EYxp1O6NJueMknGexGZiWcmxNUg53AMA0826a', 'pradiptaozy_10@example.com', 'Kota Administrasi Jakarta Timur', 'Kolombia');
INSERT INTO public.users VALUES (11, 'pranatapuspita', 'https://ui-avatars.com/api/?name=pranatapuspita&background=random', '$2a$06$ktpp2Rr07Z3Ui/96IFjoKOr68k56IIxrj./S47.F5USVQYwbd8vtu', 'pranatapuspita_11@example.com', 'Banjarmasin', 'Bahrain');
INSERT INTO public.users VALUES (12, 'jumadinatsir', 'https://ui-avatars.com/api/?name=jumadinatsir&background=random', '$2a$06$sU4Sci9BoZ7.CZ3rn7ThYeHwO.NPaQcgV2HoxDZDtTgFq0I4HraIy', 'jumadinatsir_12@example.com', 'Surakarta', 'Botswana');
INSERT INTO public.users VALUES (13, 'cakrawala68', 'https://ui-avatars.com/api/?name=cakrawala68&background=random', '$2a$06$o3RsX1zhWb29voogs5IH8.JhjTMbuD19UUIsFm7WG.zvhO8NebGDO', 'cakrawala68_13@example.com', 'Yogyakarta', 'Chili');
INSERT INTO public.users VALUES (14, 'estiono92', 'https://ui-avatars.com/api/?name=estiono92&background=random', '$2a$06$TkZyTT33iLI8inkmjgXzXeNyK1lg4B7edjEh/X5rJ9JYA0RZofn/6', 'estiono92_14@example.com', 'Metro', 'Rumania');
INSERT INTO public.users VALUES (15, 'dimaswahyudin', 'https://ui-avatars.com/api/?name=dimaswahyudin&background=random', '$2a$06$pUoZnsRKRs8A2IPB9g3mZO017GorzmpBo0EZKA3IK6.mn44rTaZwq', 'dimaswahyudin_15@example.com', 'Kota Administrasi Jakarta Barat', 'Zambia');
INSERT INTO public.users VALUES (16, 'saptonosalwa', 'https://ui-avatars.com/api/?name=saptonosalwa&background=random', '$2a$06$gFMUfEkR8lWdcBWyLKlm9OHkhNFBx0Yr1XXgA8qd2J697e9RvdGUG', 'saptonosalwa_16@example.com', 'Pasuruan', 'Swedia');
INSERT INTO public.users VALUES (17, 'setiawanfarhunnisa', 'https://ui-avatars.com/api/?name=setiawanfarhunnisa&background=random', '$2a$06$ul2w97cIpOXXexdvKcedWOmK/5OIC.A5Vz2WU0sa4BjvvxpRY1noG', 'setiawanfarhunnisa_17@example.com', 'Pekalongan', 'Jepang');
INSERT INTO public.users VALUES (18, 'ratna18', 'https://ui-avatars.com/api/?name=ratna18&background=random', '$2a$06$B1cCN/5tvSv3WpW6K5TZNe6m7szro6f2n9jQA3oIIwIgNLtt5IJiS', 'ratna18_18@example.com', 'Madiun', 'Maroko');
INSERT INTO public.users VALUES (19, 'adikaprasasta', 'https://ui-avatars.com/api/?name=adikaprasasta&background=random', '$2a$06$1tISZVldrQPz3z.BD3Hp4.b.aZrnQEco8XJbshIqM9LcJ3fjYWuPW', 'adikaprasasta_19@example.com', 'Bandung', 'Venezuela');
INSERT INTO public.users VALUES (20, 'bwijayanti', 'https://ui-avatars.com/api/?name=bwijayanti&background=random', '$2a$06$UsAC9GpeVWprMR.hX2JUz.dMZTs26nDXJ6/6O5C1EqE1OEYuwnAie', 'bwijayanti_20@example.com', 'Lhokseumawe', 'Austria');
INSERT INTO public.users VALUES (21, 'permatalukman', 'https://ui-avatars.com/api/?name=permatalukman&background=random', '$2a$06$.Ang5FHl66XMI26KMnoQIu7AMqm3GidW4yG/krirePkwtlJLvuChW', 'permatalukman_21@example.com', 'Denpasar', 'Pantai Gading');
INSERT INTO public.users VALUES (22, 'isimbolon', 'https://ui-avatars.com/api/?name=isimbolon&background=random', '$2a$06$9FufarbxqFuXLltDusxiEurhsW3Ggna5ywpamhPMRH.zdBC9nQgyG', 'isimbolon_22@example.com', 'Langsa', 'Tunisia');
INSERT INTO public.users VALUES (23, 'tugimandamanik', 'https://ui-avatars.com/api/?name=tugimandamanik&background=random', '$2a$06$FLHFvIFMMvWIP9MPboiGiuVsN2E1yD1uu28GLjTNrZB4ZgRv/E3cS', 'tugimandamanik_23@example.com', 'Pangkalpinang', 'Venezuela');
INSERT INTO public.users VALUES (24, 'osalahudin', 'https://ui-avatars.com/api/?name=osalahudin&background=random', '$2a$06$8KkxDVFMAJg2beLEEimcruYGUE3cEi0GfsFYBTNlMrlhG0ETfH5Pm', 'osalahudin_24@example.com', 'Jambi', 'Ukraina');
INSERT INTO public.users VALUES (25, 'dacinpradipta', 'https://ui-avatars.com/api/?name=dacinpradipta&background=random', '$2a$06$iOsVbnOmDIQ0cAkCZOmspepMu1VJhRpwEzImSyGy/NB78hh6NCZ5.', 'dacinpradipta_25@example.com', 'Palu', 'Bulgaria');
INSERT INTO public.users VALUES (26, 'kasiranhidayat', 'https://ui-avatars.com/api/?name=kasiranhidayat&background=random', '$2a$06$eHqgs7L6nJUnLsWpBzi3d.cehTn3DELUKl4UYcR4q89aRyVNKjiWK', 'kasiranhidayat_26@example.com', 'Padang Sidempuan', 'Ghana');
INSERT INTO public.users VALUES (27, 'wahyudincagak', 'https://ui-avatars.com/api/?name=wahyudincagak&background=random', '$2a$06$J4y7z5tkiWdxy4AgjiLGmecUHmNsJgrI1KaRvOWaZakME18bmmxzi', 'wahyudincagak_27@example.com', 'Sawahlunto', 'Ukraina');
INSERT INTO public.users VALUES (28, 'jayadi15', 'https://ui-avatars.com/api/?name=jayadi15&background=random', '$2a$06$Vc9nntPBukY9AsWjGdeEuemi8ZO9FAC4djiA8B8eYreNW5qpNO922', 'jayadi15_28@example.com', 'Manado', 'Afrika Selatan');
INSERT INTO public.users VALUES (29, 'butama', 'https://ui-avatars.com/api/?name=butama&background=random', '$2a$06$hu2TzEXIg8quPPKBDgfGD.tHiTI1OyDW3MQ9Ss/s5Q7lOcu69LcLS', 'butama_29@example.com', 'Tangerang', 'Pantai Gading');
INSERT INTO public.users VALUES (30, 'jwasita', 'https://ui-avatars.com/api/?name=jwasita&background=random', '$2a$06$hdXK8ky86jigG3To8XnbsuDcVg3c0sauVopg84vCEKyEvw2q4ePXm', 'jwasita_30@example.com', 'Bontang', 'Jepang');
INSERT INTO public.users VALUES (31, 'dalima74', 'https://ui-avatars.com/api/?name=dalima74&background=random', '$2a$06$Q6y0SKNOw1Y9oieWsb2FC.cj5oO8.H5n/uLHsE5WjpzK3au40qOZC', 'dalima74_31@example.com', 'Jayapura', 'Malaysia');
INSERT INTO public.users VALUES (32, 'gangsarmardhiyah', 'https://ui-avatars.com/api/?name=gangsarmardhiyah&background=random', '$2a$06$vd/Cbu92.mwn3Op8Q7m4OuYGRdKpLHRWDmu7BXjxydJPtHFaqLoDm', 'gangsarmardhiyah_32@example.com', 'Pasuruan', 'Pakistan');
INSERT INTO public.users VALUES (33, 'humaira14', 'https://ui-avatars.com/api/?name=humaira14&background=random', '$2a$06$KwGlGEk0D6ZaWE6OEQ5AvuHymLsku23aCXTm4wjhyMnO.NXZRRdRi', 'humaira14_33@example.com', 'Bukittinggi', 'Peru');
INSERT INTO public.users VALUES (34, 'nadiasitorus', 'https://ui-avatars.com/api/?name=nadiasitorus&background=random', '$2a$06$cjLr8kcaot1Fukg/IrpRtO3nWQqgpd2PdEpPIxsa0t8VYB3SkKLGm', 'nadiasitorus_34@example.com', 'Kotamobagu', 'Vanuatu');
INSERT INTO public.users VALUES (35, 'ekaprayoga', 'https://ui-avatars.com/api/?name=ekaprayoga&background=random', '$2a$06$x1DB3OujcbyrfclawE2nXOwYG1aSuewDEq5GbN.A3J4KMTCeVQYLW', 'ekaprayoga_35@example.com', 'Samarinda', 'Montenegro');
INSERT INTO public.users VALUES (36, 'tsaptono', 'https://ui-avatars.com/api/?name=tsaptono&background=random', '$2a$06$bUdx7NQ1PdZmV6iYrPQNru1o4yEzGd6/.Yqg2VnT5O3vjmj4gvEBa', 'tsaptono_36@example.com', 'Cilegon', 'Makedonia Utara');
INSERT INTO public.users VALUES (37, 'luthfi39', 'https://ui-avatars.com/api/?name=luthfi39&background=random', '$2a$06$nUxh1Gg4wx6gcGiNJdVFseTKhuC3SgGrtYOJTnVye/QUj.pKNP0Xq', 'luthfi39_37@example.com', 'Ambon', 'Ukraina');
INSERT INTO public.users VALUES (38, 'balangga09', 'https://ui-avatars.com/api/?name=balangga09&background=random', '$2a$06$KJ8.s428vPcbkBYiQiljh.wkpCZZAIqoA5f3Ou/zmdh6jdKVh.Q5a', 'balangga09_38@example.com', 'Semarang', 'Uni Emirat Arab');
INSERT INTO public.users VALUES (39, 'wyolanda', 'https://ui-avatars.com/api/?name=wyolanda&background=random', '$2a$06$RUWKSDOvwIbQWKUJW5OQi.PejLO05S1/ns8HVwL9uWauVxaUmmrAe', 'wyolanda_39@example.com', 'Padang', 'Finlandia');
INSERT INTO public.users VALUES (40, 'jsuwarno', 'https://ui-avatars.com/api/?name=jsuwarno&background=random', '$2a$06$JMjb5hgA1AjLIcr/0ky7tOWVzA.ZkB8/FHxTPFPR7GyisIysxI6yq', 'jsuwarno_40@example.com', 'Batu', 'Portugal');
INSERT INTO public.users VALUES (41, 'melanifitria', 'https://ui-avatars.com/api/?name=melanifitria&background=random', '$2a$06$n.xgfz0XgLfE0vLamcTgN.LJDNIAnlGpmZQsXkur1rQSEXLeDSH4C', 'melanifitria_41@example.com', 'Pematangsiantar', 'Irak');
INSERT INTO public.users VALUES (42, 'whutasoit', 'https://ui-avatars.com/api/?name=whutasoit&background=random', '$2a$06$9P/3m5sXoReizKtvPAHZOefOczEmvqgDhZkCWirSdpqwva3uMEeUW', 'whutasoit_42@example.com', 'Tegal', 'Polandia');
INSERT INTO public.users VALUES (43, 'putrasatya', 'https://ui-avatars.com/api/?name=putrasatya&background=random', '$2a$06$gdvv5jeHgvDkYc0ejxgbY.N3AXFeXm6ftc8ZGSLr3bkPVu9BjRxfW', 'putrasatya_43@example.com', 'Sibolga', 'Zimbabwe');
INSERT INTO public.users VALUES (44, 'ikinagustina', 'https://ui-avatars.com/api/?name=ikinagustina&background=random', '$2a$06$Cs3xHXjOV1Gex1/Rrbl2Guwef/sZ5/KAyDn5t0VirGWYan6tGXVSm', 'ikinagustina_44@example.com', 'Pagaralam', 'Brasil');
INSERT INTO public.users VALUES (45, 'fyuniar', 'https://ui-avatars.com/api/?name=fyuniar&background=random', '$2a$06$tzavQIi48A.GyiZFLlPGtudNhu2/64h9KmEdl34lCKEJtJ8Pj7Dx2', 'fyuniar_45@example.com', 'Bau-Bau', 'Armenia');
INSERT INTO public.users VALUES (46, 'galihwaluyo', 'https://ui-avatars.com/api/?name=galihwaluyo&background=random', '$2a$06$Z1FlUCfG831ZPrTSRmx4N.CxBuRphYzuk8BA06mOB0P3YOmhINeFa', 'galihwaluyo_46@example.com', 'Dumai', 'Jepang');
INSERT INTO public.users VALUES (47, 'gunawandadap', 'https://ui-avatars.com/api/?name=gunawandadap&background=random', '$2a$06$Y3LexSYts6ksVONHq3y5Me6M83mdKQSy1MfaIbdGiNLhon3gn2KUG', 'gunawandadap_47@example.com', 'Ambon', 'Portugal');
INSERT INTO public.users VALUES (48, 'evasantoso', 'https://ui-avatars.com/api/?name=evasantoso&background=random', '$2a$06$4Y2OGqb1BVo6OKnOHGI/.O1LJ9oRG9RHAEOeII54nZTLBsS43BvoC', 'evasantoso_48@example.com', 'Ambon', 'Belize');
INSERT INTO public.users VALUES (49, 'ardiantokasusra', 'https://ui-avatars.com/api/?name=ardiantokasusra&background=random', '$2a$06$F5i.2oi6pSMqVYSV.Gqiw.ZYZmGJp8CBeSuQEE5/QwRVwgMI.4bVG', 'ardiantokasusra_49@example.com', 'Banjar', 'Palau');
INSERT INTO public.users VALUES (50, 'elestari', 'https://ui-avatars.com/api/?name=elestari&background=random', '$2a$06$kYzafFgrGwXvLk5nrLo/HOBPa.SMzggnW9Hapl.2DDbOJKoqQAuy.', 'elestari_50@example.com', 'Bekasi', 'Swiss');
INSERT INTO public.users VALUES (51, 'enteng20', 'https://ui-avatars.com/api/?name=enteng20&background=random', '$2a$06$wcTRxaAAnDqj1M31YExIi.2YnTsWq76Gv44jORGGvkTo42CJAWdPK', 'enteng20_51@example.com', 'Pontianak', 'Mozambik');
INSERT INTO public.users VALUES (52, 'hasan09', 'https://ui-avatars.com/api/?name=hasan09&background=random', '$2a$06$It1sdB5ErnHuePiK51ZFBOKrGmz4xGqspDWNY3.uu0PVj2kKSeWcS', 'hasan09_52@example.com', 'Dumai', 'Nepal');
INSERT INTO public.users VALUES (53, 'jprayoga', 'https://ui-avatars.com/api/?name=jprayoga&background=random', '$2a$06$wnFswFPtGfW2/Mu7n1ov3u4Q1.6AEfsAlcGTxIqmqLFfDwmOlSGGK', 'jprayoga_53@example.com', 'Banda Aceh', 'Tuvalu');
INSERT INTO public.users VALUES (54, 'dimasmandasari', 'https://ui-avatars.com/api/?name=dimasmandasari&background=random', '$2a$06$a0aO07Y1v1Owx1Ab4xUOiO/eD6jXUnzDa636MfcLXE3ZK0Ntp.QMO', 'dimasmandasari_54@example.com', 'Bukittinggi', 'Madagaskar');
INSERT INTO public.users VALUES (55, 'agustinaheru', 'https://ui-avatars.com/api/?name=agustinaheru&background=random', '$2a$06$FJum8xN3V1kXM6J/hUG0beMvEIfSYl.LX7Zvzh9KYZF73miDto3AK', 'agustinaheru_55@example.com', 'Palangkaraya', 'Serbia');
INSERT INTO public.users VALUES (56, 'langgeng75', 'https://ui-avatars.com/api/?name=langgeng75&background=random', '$2a$06$hVKOuSMDgZcCo0Bzz1srGuw1WoN2wbrvenee0oh8LMBhNbBiiNPJi', 'langgeng75_56@example.com', 'Padang Sidempuan', 'Kuwait');
INSERT INTO public.users VALUES (57, 'harja13', 'https://ui-avatars.com/api/?name=harja13&background=random', '$2a$06$HIDOVc1NHN8O6iZ0ueGqveBSUc8QI5sq/V9qwByidaQLW4pCR1lLK', 'harja13_57@example.com', 'Bogor', 'Brasil');
INSERT INTO public.users VALUES (58, 'hartakapradipta', 'https://ui-avatars.com/api/?name=hartakapradipta&background=random', '$2a$06$5XKRaenwDwep0oiZozVYxuckjGfdPTVyvZJ05og2CEAogGSvJ4IN.', 'hartakapradipta_58@example.com', 'Tangerang', 'Korea Utara');
INSERT INTO public.users VALUES (59, 'tasdiksantoso', 'https://ui-avatars.com/api/?name=tasdiksantoso&background=random', '$2a$06$VhY.55NW0gS7SjbkZDtIwezJmXXK5zB2jEAKPOCwmZ24Nnm3Jm1wi', 'tasdiksantoso_59@example.com', 'Pekalongan', 'Namibia');
INSERT INTO public.users VALUES (60, 'unuraini', 'https://ui-avatars.com/api/?name=unuraini&background=random', '$2a$06$jbsbxKomKL1v36YSx.lfVOCQ8FypfSqo98.kfuZbue.3/R.ay6/.C', 'unuraini_60@example.com', 'Binjai', 'Estonia');
INSERT INTO public.users VALUES (61, 'asudiati', 'https://ui-avatars.com/api/?name=asudiati&background=random', '$2a$06$ni5N59os.gMKkd9A51Iycux7f8TwQP71ZMmzSDRAAtunNvqbFY6Ku', 'asudiati_61@example.com', 'Subulussalam', 'Amerika Serikat');
INSERT INTO public.users VALUES (62, 'artanto06', 'https://ui-avatars.com/api/?name=artanto06&background=random', '$2a$06$60twPksOSqxE/VX9zANva.sQphH2T1wBXMfVAhNNpv8jGatAP2yfW', 'artanto06_62@example.com', 'Bima', 'Vatikan');
INSERT INTO public.users VALUES (63, 'adikaramandasari', 'https://ui-avatars.com/api/?name=adikaramandasari&background=random', '$2a$06$Ahn/fs1/RY28TWNQueGce.wSXiF2raO1Wba9TVTilIk3JDb0jRKh.', 'adikaramandasari_63@example.com', 'Gorontalo', 'Yordania');
INSERT INTO public.users VALUES (64, 'ubudiman', 'https://ui-avatars.com/api/?name=ubudiman&background=random', '$2a$06$a/QwGygHaMDBQO.vqbs.yOEbjOZkKEW9VXP7ZHz19Hauv4dwKA/km', 'ubudiman_64@example.com', 'Tanjungpinang', 'Turkmenistan');
INSERT INTO public.users VALUES (65, 'vharyanto', 'https://ui-avatars.com/api/?name=vharyanto&background=random', '$2a$06$CnjfZ6wy2.hPokmudaaPAeNU2tTsHLgYf9amcXvVDH9rK00GzrYDq', 'vharyanto_65@example.com', 'Ambon', 'Turkmenistan');
INSERT INTO public.users VALUES (66, 'ismailwijaya', 'https://ui-avatars.com/api/?name=ismailwijaya&background=random', '$2a$06$HnlPZPA1txQAC1q6JNRW1.zv3acKJcb/UANRqeVwUn7fjbck6AzBO', 'ismailwijaya_66@example.com', 'Cimahi', 'Sierra Leone');
INSERT INTO public.users VALUES (67, 'darimin21', 'https://ui-avatars.com/api/?name=darimin21&background=random', '$2a$06$Z7DLViHCTPQCBGaFwFQ5Ievwg6bi.j3xBu8s7YEbJHlXNro1mUcQK', 'darimin21_67@example.com', 'Blitar', 'Finlandia');
INSERT INTO public.users VALUES (68, 'marbunusman', 'https://ui-avatars.com/api/?name=marbunusman&background=random', '$2a$06$9vk9G.NjJ71EB1DsmOUFCuzpNiB09jgbpNn4ylxxvcg1sKwVoAVm2', 'marbunusman_68@example.com', 'Madiun', 'Montenegro');
INSERT INTO public.users VALUES (69, 'jmandasari', 'https://ui-avatars.com/api/?name=jmandasari&background=random', '$2a$06$sV2f/mv99XdlRioCg5ri.e1foqxgyZaNw2GROX/E5YOXJL3e1K00.', 'jmandasari_69@example.com', 'Blitar', 'Singapura');
INSERT INTO public.users VALUES (70, 'gara70', 'https://ui-avatars.com/api/?name=gara70&background=random', '$2a$06$IKez6If9mj8GcZOtDxIc4On2XQeGwKJ7N1R/dz43Pem0wQScjJNAG', 'gara70_70@example.com', 'Surabaya', 'Paraguay');
INSERT INTO public.users VALUES (71, 'hasan83', 'https://ui-avatars.com/api/?name=hasan83&background=random', '$2a$06$OtMV5nvwP0Hb4S.9La4Nc.dkIhRYdR1T0JKNaTeb2MGnoFjBXufY.', 'hasan83_71@example.com', 'Sibolga', 'Sri Lanka');
INSERT INTO public.users VALUES (72, 'uwaisoni', 'https://ui-avatars.com/api/?name=uwaisoni&background=random', '$2a$06$/MW7Nq7.e4oqPbva9mA.aeqQvFNblDOQtNPZJGiFjlu2/dQSuHFZy', 'uwaisoni_72@example.com', 'Semarang', 'Samoa');
INSERT INTO public.users VALUES (73, 'oman35', 'https://ui-avatars.com/api/?name=oman35&background=random', '$2a$06$ueXquJEXFmN7mFIMD1iA2uEVXANulJs6DfVPAXsnA5G74okML9XDG', 'oman35_73@example.com', 'Palangkaraya', 'Belize');
INSERT INTO public.users VALUES (74, 'hmarpaung', 'https://ui-avatars.com/api/?name=hmarpaung&background=random', '$2a$06$rxrOLsc2SIMGkMI5ng9pHOwij36I/pzlOwGyfF.Ooryy1ITlpPNSC', 'hmarpaung_74@example.com', 'Kota Administrasi Jakarta Selatan', 'Samoa');
INSERT INTO public.users VALUES (75, 'ohidayat', 'https://ui-avatars.com/api/?name=ohidayat&background=random', '$2a$06$GUVBIb/uLUrAcCrstPH.mu/nKov67omna3Ci.76K.bwpesFXEbF26', 'ohidayat_75@example.com', 'Lhokseumawe', 'Serbia');
INSERT INTO public.users VALUES (76, 'omaheswara', 'https://ui-avatars.com/api/?name=omaheswara&background=random', '$2a$06$5P8i1TfZRjYcpkMXRUW2S.jBtdKcyLsk6epn63WOimjw92olcf.52', 'omaheswara_76@example.com', 'Jayapura', 'Ethiopia');
INSERT INTO public.users VALUES (77, 'marpaungjessica', 'https://ui-avatars.com/api/?name=marpaungjessica&background=random', '$2a$06$PDq1U195cztz1qoHXJD7I.pwS8ALxhzh5kv3XJE6s4mzal52IvRlG', 'marpaungjessica_77@example.com', 'Balikpapan', 'Jamaika');
INSERT INTO public.users VALUES (78, 'siregaraditya', 'https://ui-avatars.com/api/?name=siregaraditya&background=random', '$2a$06$T1d8yKP13haLd5aaekZBtubocvpZDV13GJRUotnZUcMYlSUPJ6HNu', 'siregaraditya_78@example.com', 'Medan', 'Maroko');
INSERT INTO public.users VALUES (79, 'taswirmaryati', 'https://ui-avatars.com/api/?name=taswirmaryati&background=random', '$2a$06$AynVWBVN6hkZAUaAWtP6LOljzIYl7J6isUqRGP7PfckO1gOPEIOGa', 'taswirmaryati_79@example.com', 'Lhokseumawe', 'Hongaria');
INSERT INTO public.users VALUES (80, 'imarbun', 'https://ui-avatars.com/api/?name=imarbun&background=random', '$2a$06$PuKigpkUjvXB3hOhDN7uaef0LMUc/qzNTIGBlEEPx4xXY7vtkIOzq', 'imarbun_80@example.com', 'Bontang', 'Federasi Mikronesia');
INSERT INTO public.users VALUES (81, 'usyirahayu', 'https://ui-avatars.com/api/?name=usyirahayu&background=random', '$2a$06$xFYMOa2QWBQDUuppOil7a.d5sFApsioPO2Jkfkp54vfGi5TLTcP96', 'usyirahayu_81@example.com', 'Lubuklinggau', 'Malta');
INSERT INTO public.users VALUES (82, 'nababanrizki', 'https://ui-avatars.com/api/?name=nababanrizki&background=random', '$2a$06$oGqOfc7Q.yP59f/B1zwpzOFIVWC.nzETrPZ3.iq1uVnd/gs6FYtcm', 'nababanrizki_82@example.com', 'Parepare', 'Afrika Tengah');
INSERT INTO public.users VALUES (83, 'nadriansyah', 'https://ui-avatars.com/api/?name=nadriansyah&background=random', '$2a$06$pNBJguFrM5kpaoAgz3apYOeFAm/Iu7VacJKaBpsm3ny1uNVLU/hI2', 'nadriansyah_83@example.com', 'Blitar', 'Bahama');
INSERT INTO public.users VALUES (84, 'xnurdiyanti', 'https://ui-avatars.com/api/?name=xnurdiyanti&background=random', '$2a$06$u00dDQTFa2OStEnjI9Lc8.nsRdx3TDqEUIZ/0QI.vFyLioIFWdGS2', 'xnurdiyanti_84@example.com', 'Bukittinggi', 'Mauritius');
INSERT INTO public.users VALUES (85, 'yolandakairav', 'https://ui-avatars.com/api/?name=yolandakairav&background=random', '$2a$06$miES.x7Lz3DISp13Xx/Rf.fh00iqp671GhYRymtgdDxawz3gBz5EK', 'yolandakairav_85@example.com', 'Cirebon', 'Bulgaria');
INSERT INTO public.users VALUES (86, 'lanjarmaryadi', 'https://ui-avatars.com/api/?name=lanjarmaryadi&background=random', '$2a$06$KWMZOGNQXVfnTx.X0kRwHeXZKHAltQM77ctVFmwI0W9E4j6AzaNTC', 'lanjarmaryadi_86@example.com', 'Cilegon', 'Arab Saudi');
INSERT INTO public.users VALUES (87, 'kuswandarisetya', 'https://ui-avatars.com/api/?name=kuswandarisetya&background=random', '$2a$06$cct7Rpga4lheTN225FJ9Pe/SqZN7G/MZXpTch5AzHaDwbGqCl.95O', 'kuswandarisetya_87@example.com', 'Ambon', 'Trinidad dan Tobago');
INSERT INTO public.users VALUES (88, 'sakti53', 'https://ui-avatars.com/api/?name=sakti53&background=random', '$2a$06$Dd43meR5zHX8b6nCX1t3teZws.wrujRC0q4S5x5W3hYFOdPOWGGmq', 'sakti53_88@example.com', 'Banjar', 'Turkmenistan');
INSERT INTO public.users VALUES (89, 'wibisonomaryadi', 'https://ui-avatars.com/api/?name=wibisonomaryadi&background=random', '$2a$06$WrsnuXxR/gVdObGqej5PO.cPc/26zaHjGJFQp/rogHtx5zD4XroIm', 'wibisonomaryadi_89@example.com', 'Bandung', 'Tonga');
INSERT INTO public.users VALUES (90, 'padmasaricatur', 'https://ui-avatars.com/api/?name=padmasaricatur&background=random', '$2a$06$TOoTU2D5BhpPqjvoCwzUOOt2t9mJMCj35.0rgkos/XINtBDNpMw6u', 'padmasaricatur_90@example.com', 'Metro', 'Kosta Rika');
INSERT INTO public.users VALUES (91, 'primasaptono', 'https://ui-avatars.com/api/?name=primasaptono&background=random', '$2a$06$Xn8BcMnQfOVlCi/AkVGCU.ibd8p0/OEQphGV0hkkfXEuqRQcT4zS6', 'primasaptono_91@example.com', 'Gorontalo', 'Tajikistan');
INSERT INTO public.users VALUES (92, 'wahyudineman', 'https://ui-avatars.com/api/?name=wahyudineman&background=random', '$2a$06$aPf07oIBqebIvuQbYE5kWOgh/oHHdSbgPnDICu.ahFCukAS7cioT2', 'wahyudineman_92@example.com', 'Pontianak', 'Grenada');
INSERT INTO public.users VALUES (93, 'novitasariestiono', 'https://ui-avatars.com/api/?name=novitasariestiono&background=random', '$2a$06$k9ihc74LagCP2I/TCTXV4ezV1MNBAfgI3TghBu7K4pFpJ87lC737e', 'novitasariestiono_93@example.com', 'Medan', 'Kanada');
INSERT INTO public.users VALUES (94, 'natsirkezia', 'https://ui-avatars.com/api/?name=natsirkezia&background=random', '$2a$06$iTWWd2LRtshi8ewI9etCMO1BsSBHjliI8pmGauIcm1g905RfI2fVK', 'natsirkezia_94@example.com', 'Ternate', 'Timor Leste');
INSERT INTO public.users VALUES (95, 'gpertiwi', 'https://ui-avatars.com/api/?name=gpertiwi&background=random', '$2a$06$S267BVa39U.2Agpi5AHASuAbeokBIsZYHaT5I0e4yC6lXMwQtxisa', 'gpertiwi_95@example.com', 'Sawahlunto', 'Chili');
INSERT INTO public.users VALUES (96, 'rachel97', 'https://ui-avatars.com/api/?name=rachel97&background=random', '$2a$06$e7DdIkuXfBSYg1H3i5yo1eFe5lHvioGa/dwJDrOepyyt380ojSt8u', 'rachel97_96@example.com', 'Tomohon', 'Eritrea');
INSERT INTO public.users VALUES (97, 'nardi40', 'https://ui-avatars.com/api/?name=nardi40&background=random', '$2a$06$TPyXG1FEJtJmkNNWyUOfa.aB5Ab/2r.N.7ya6vUgR3b6M1ar9sRiK', 'nardi40_97@example.com', 'Banjarbaru', 'Spanyol');
INSERT INTO public.users VALUES (98, 'suartiniharsanto', 'https://ui-avatars.com/api/?name=suartiniharsanto&background=random', '$2a$06$rD7hwxYORyy7hrHw.zGqSOuIplw/W8qgtZ6y70CGcscRPMUOoC.EK', 'suartiniharsanto_98@example.com', 'Medan', 'Nikaragua');
INSERT INTO public.users VALUES (99, 'tusamah', 'https://ui-avatars.com/api/?name=tusamah&background=random', '$2a$06$oVP5tx5x4myXNNpSp00sIeBkyiVLwjoEg/7L5Z66U75fFK6mHhy8.', 'tusamah_99@example.com', 'Binjai', 'Tajikistan');
INSERT INTO public.users VALUES (100, 'yancezulkarnain', 'https://ui-avatars.com/api/?name=yancezulkarnain&background=random', '$2a$06$9g6JywZsNJGk9oxmPF0VdOWA1Mp0uNtPYhDgwO3cUpVM94noHe6S.', 'yancezulkarnain_100@example.com', 'Yogyakarta', 'El Salvador');


--
-- TOC entry 3972 (class 0 OID 0)
-- Dependencies: 222
-- Name: jobid_seq; Type: SEQUENCE SET; Schema: cron; Owner: postgres
--

SELECT pg_catalog.setval('cron.jobid_seq', 16, true);


--
-- TOC entry 3973 (class 0 OID 0)
-- Dependencies: 224
-- Name: runid_seq; Type: SEQUENCE SET; Schema: cron; Owner: postgres
--

SELECT pg_catalog.setval('cron.runid_seq', 7, true);


--
-- TOC entry 3974 (class 0 OID 0)
-- Dependencies: 263
-- Name: seq_add_songs_playlist_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_add_songs_playlist_id', 800, true);


--
-- TOC entry 3975 (class 0 OID 0)
-- Dependencies: 253
-- Name: seq_artists_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_artists_id', 73, true);


--
-- TOC entry 3976 (class 0 OID 0)
-- Dependencies: 257
-- Name: seq_collections_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_collections_id', 92, true);


--
-- TOC entry 3977 (class 0 OID 0)
-- Dependencies: 258
-- Name: seq_genres_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_genres_id', 70, true);


--
-- TOC entry 3978 (class 0 OID 0)
-- Dependencies: 262
-- Name: seq_listens_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_listens_id', 253, true);


--
-- TOC entry 3979 (class 0 OID 0)
-- Dependencies: 256
-- Name: seq_playlists_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_playlists_id', 148, true);


--
-- TOC entry 3980 (class 0 OID 0)
-- Dependencies: 259
-- Name: seq_reviews_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_reviews_id', 145, true);


--
-- TOC entry 3981 (class 0 OID 0)
-- Dependencies: 261
-- Name: seq_socials_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_socials_id', 73, true);


--
-- TOC entry 3982 (class 0 OID 0)
-- Dependencies: 254
-- Name: seq_songs_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_songs_id', 100, true);


--
-- TOC entry 3983 (class 0 OID 0)
-- Dependencies: 260
-- Name: seq_tours_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_tours_id', 5, true);


--
-- TOC entry 3984 (class 0 OID 0)
-- Dependencies: 255
-- Name: seq_users_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_users_id', 100, true);


--
-- TOC entry 3587 (class 2606 OID 31340)
-- Name: artists artists_artist_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_artist_email_key UNIQUE (artist_email);


--
-- TOC entry 3584 (class 2606 OID 31322)
-- Name: add_songs_playlists pk_add_songs_playlists; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.add_songs_playlists
    ADD CONSTRAINT pk_add_songs_playlists PRIMARY KEY (add_song_pl_id);


--
-- TOC entry 3600 (class 2606 OID 31360)
-- Name: artist_promotion pk_artist_promotion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_promotion
    ADD CONSTRAINT pk_artist_promotion PRIMARY KEY (artist_id);


--
-- TOC entry 3590 (class 2606 OID 31338)
-- Name: artists pk_artists; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT pk_artists PRIMARY KEY (artist_id);


--
-- TOC entry 3595 (class 2606 OID 31348)
-- Name: artists_tours pk_artists_tours; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists_tours
    ADD CONSTRAINT pk_artists_tours PRIMARY KEY (tour_id, artist_id);


--
-- TOC entry 3610 (class 2606 OID 31380)
-- Name: block_users pk_block_users; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_users
    ADD CONSTRAINT pk_block_users PRIMARY KEY (blocker_id, blocked_id);


--
-- TOC entry 3605 (class 2606 OID 31370)
-- Name: blocklist_artists pk_blocklist_artists; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocklist_artists
    ADD CONSTRAINT pk_blocklist_artists PRIMARY KEY (artist_id, user_id);


--
-- TOC entry 3621 (class 2606 OID 31414)
-- Name: collection_library pk_collection_library; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_library
    ADD CONSTRAINT pk_collection_library PRIMARY KEY (user_id, collection_id);


--
-- TOC entry 3626 (class 2606 OID 31424)
-- Name: collection_top_3_genres pk_collection_top_3_genres; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_top_3_genres
    ADD CONSTRAINT pk_collection_top_3_genres PRIMARY KEY (collection_id, genre_id);


--
-- TOC entry 3613 (class 2606 OID 31394)
-- Name: collections pk_collections; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT pk_collections PRIMARY KEY (collection_id);


--
-- TOC entry 3618 (class 2606 OID 31404)
-- Name: collections_songs pk_collections_songs; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections_songs
    ADD CONSTRAINT pk_collections_songs PRIMARY KEY (song_id, collection_id);


--
-- TOC entry 3633 (class 2606 OID 31434)
-- Name: create_songs pk_create_songs; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.create_songs
    ADD CONSTRAINT pk_create_songs PRIMARY KEY (song_id, artist_id);


--
-- TOC entry 3638 (class 2606 OID 31446)
-- Name: follow_artists pk_follow_artists; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow_artists
    ADD CONSTRAINT pk_follow_artists PRIMARY KEY (user_id, artist_id);


--
-- TOC entry 3643 (class 2606 OID 31456)
-- Name: follow_users pk_follow_users; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow_users
    ADD CONSTRAINT pk_follow_users PRIMARY KEY (follower_id, followed_id);


--
-- TOC entry 3646 (class 2606 OID 31466)
-- Name: genres pk_genres; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT pk_genres PRIMARY KEY (genre_id);


--
-- TOC entry 3651 (class 2606 OID 31474)
-- Name: like_reviews pk_like_reviews; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.like_reviews
    ADD CONSTRAINT pk_like_reviews PRIMARY KEY (review_id, user_id);


--
-- TOC entry 3656 (class 2606 OID 31486)
-- Name: like_songs pk_like_songs; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.like_songs
    ADD CONSTRAINT pk_like_songs PRIMARY KEY (song_id, user_id);


--
-- TOC entry 3661 (class 2606 OID 31500)
-- Name: listens pk_listens; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listens
    ADD CONSTRAINT pk_listens PRIMARY KEY (listen_id);


--
-- TOC entry 3667 (class 2606 OID 31526)
-- Name: pl_library pk_pl_library; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pl_library
    ADD CONSTRAINT pk_pl_library PRIMARY KEY (user_id, playlist_id);


--
-- TOC entry 3664 (class 2606 OID 31517)
-- Name: playlists pk_playlists; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT pk_playlists PRIMARY KEY (playlist_id);


--
-- TOC entry 3672 (class 2606 OID 31539)
-- Name: rate_songs pk_rate_songs; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate_songs
    ADD CONSTRAINT pk_rate_songs PRIMARY KEY (user_id, song_id);


--
-- TOC entry 3679 (class 2606 OID 31549)
-- Name: releases pk_releases; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.releases
    ADD CONSTRAINT pk_releases PRIMARY KEY (collection_id, artist_id);


--
-- TOC entry 3684 (class 2606 OID 31565)
-- Name: reviews pk_reviews; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT pk_reviews PRIMARY KEY (review_id);


--
-- TOC entry 3690 (class 2606 OID 31578)
-- Name: socials pk_socials; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socials
    ADD CONSTRAINT pk_socials PRIMARY KEY (social_id);


--
-- TOC entry 3693 (class 2606 OID 31593)
-- Name: songs pk_songs; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT pk_songs PRIMARY KEY (song_id);


--
-- TOC entry 3698 (class 2606 OID 31601)
-- Name: songs_genres pk_songs_genres; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_genres
    ADD CONSTRAINT pk_songs_genres PRIMARY KEY (genre_id, song_id);


--
-- TOC entry 3701 (class 2606 OID 31615)
-- Name: tours pk_tours; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tours
    ADD CONSTRAINT pk_tours PRIMARY KEY (tour_id);


--
-- TOC entry 3704 (class 2606 OID 31627)
-- Name: users pk_users; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_users PRIMARY KEY (user_id);


--
-- TOC entry 3687 (class 2606 OID 31883)
-- Name: reviews uq_user_collection_review; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT uq_user_collection_review UNIQUE (user_id, collection_id);


--
-- TOC entry 3707 (class 2606 OID 31631)
-- Name: users users_user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_user_email_key UNIQUE (user_email);


--
-- TOC entry 3709 (class 2606 OID 31629)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3580 (class 1259 OID 31326)
-- Name: add_songs_playlists_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX add_songs_playlists_pk ON public.add_songs_playlists USING btree (add_song_pl_id);


--
-- TOC entry 3596 (class 1259 OID 31363)
-- Name: artist_promotion_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX artist_promotion_pk ON public.artist_promotion USING btree (artist_id);


--
-- TOC entry 3588 (class 1259 OID 31341)
-- Name: artists_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX artists_pk ON public.artists USING btree (artist_id);


--
-- TOC entry 3591 (class 1259 OID 31349)
-- Name: artists_tours_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX artists_tours_pk ON public.artists_tours USING btree (tour_id, artist_id);


--
-- TOC entry 3606 (class 1259 OID 31381)
-- Name: block_users_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX block_users_pk ON public.block_users USING btree (blocker_id, blocked_id);


--
-- TOC entry 3601 (class 1259 OID 31371)
-- Name: blocklist_artists_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX blocklist_artists_pk ON public.blocklist_artists USING btree (artist_id, user_id);


--
-- TOC entry 3619 (class 1259 OID 31415)
-- Name: collection_library_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX collection_library_pk ON public.collection_library USING btree (user_id, collection_id);


--
-- TOC entry 3681 (class 1259 OID 31568)
-- Name: collection_mana_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX collection_mana_fk ON public.reviews USING btree (collection_id);


--
-- TOC entry 3624 (class 1259 OID 31425)
-- Name: collection_top_3_genres_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX collection_top_3_genres_pk ON public.collection_top_3_genres USING btree (collection_id, genre_id);


--
-- TOC entry 3611 (class 1259 OID 31395)
-- Name: collections_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX collections_pk ON public.collections USING btree (collection_id);


--
-- TOC entry 3614 (class 1259 OID 31405)
-- Name: collections_songs_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX collections_songs_pk ON public.collections_songs USING btree (song_id, collection_id);


--
-- TOC entry 3629 (class 1259 OID 31435)
-- Name: create_playlists_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX create_playlists_pk ON public.create_songs USING btree (song_id, artist_id);


--
-- TOC entry 3634 (class 1259 OID 31447)
-- Name: follow_artists_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX follow_artists_pk ON public.follow_artists USING btree (user_id, artist_id);


--
-- TOC entry 3639 (class 1259 OID 31457)
-- Name: follow_users_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX follow_users_pk ON public.follow_users USING btree (follower_id, followed_id);


--
-- TOC entry 3644 (class 1259 OID 31467)
-- Name: genres_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX genres_pk ON public.genres USING btree (genre_id);


--
-- TOC entry 3688 (class 1259 OID 31580)
-- Name: has_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX has_fk ON public.socials USING btree (artist_id);


--
-- TOC entry 3647 (class 1259 OID 31476)
-- Name: like_review2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX like_review2_fk ON public.like_reviews USING btree (user_id);


--
-- TOC entry 3648 (class 1259 OID 31477)
-- Name: like_review_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX like_review_fk ON public.like_reviews USING btree (review_id);


--
-- TOC entry 3649 (class 1259 OID 31475)
-- Name: like_reviews_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX like_reviews_pk ON public.like_reviews USING btree (review_id, user_id);


--
-- TOC entry 3652 (class 1259 OID 31487)
-- Name: like_songs_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX like_songs_pk ON public.like_songs USING btree (song_id, user_id);


--
-- TOC entry 3657 (class 1259 OID 31503)
-- Name: listens_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX listens_pk ON public.listens USING btree (listen_id);


--
-- TOC entry 3602 (class 1259 OID 31372)
-- Name: mem_blacklist2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mem_blacklist2_fk ON public.blocklist_artists USING btree (user_id);


--
-- TOC entry 3603 (class 1259 OID 31373)
-- Name: mem_blacklist_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mem_blacklist_fk ON public.blocklist_artists USING btree (artist_id);


--
-- TOC entry 3607 (class 1259 OID 31382)
-- Name: mem_block2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mem_block2_fk ON public.block_users USING btree (blocked_id);


--
-- TOC entry 3608 (class 1259 OID 31383)
-- Name: mem_block_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mem_block_fk ON public.block_users USING btree (blocker_id);


--
-- TOC entry 3630 (class 1259 OID 31436)
-- Name: membuat2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX membuat2_fk ON public.create_songs USING btree (artist_id);


--
-- TOC entry 3631 (class 1259 OID 31437)
-- Name: membuat_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX membuat_fk ON public.create_songs USING btree (song_id);


--
-- TOC entry 3662 (class 1259 OID 31519)
-- Name: membuat_playlist_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX membuat_playlist_fk ON public.playlists USING btree (user_id);


--
-- TOC entry 3682 (class 1259 OID 31567)
-- Name: membuat_review_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX membuat_review_fk ON public.reviews USING btree (user_id);


--
-- TOC entry 3592 (class 1259 OID 31350)
-- Name: memiliki2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX memiliki2_fk ON public.artists_tours USING btree (artist_id);


--
-- TOC entry 3593 (class 1259 OID 31351)
-- Name: memiliki3_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX memiliki3_fk ON public.artists_tours USING btree (tour_id);


--
-- TOC entry 3615 (class 1259 OID 31406)
-- Name: memiliki4_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX memiliki4_fk ON public.collections_songs USING btree (song_id);


--
-- TOC entry 3616 (class 1259 OID 31407)
-- Name: memiliki_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX memiliki_fk ON public.collections_songs USING btree (collection_id);


--
-- TOC entry 3597 (class 1259 OID 31361)
-- Name: mempromosikan2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mempromosikan2_fk ON public.artist_promotion USING btree (artist_id);


--
-- TOC entry 3598 (class 1259 OID 31362)
-- Name: mempromosikan_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mempromosikan_fk ON public.artist_promotion USING btree (collection_id);


--
-- TOC entry 3695 (class 1259 OID 31603)
-- Name: mempunyai2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mempunyai2_fk ON public.songs_genres USING btree (song_id);


--
-- TOC entry 3696 (class 1259 OID 31604)
-- Name: mempunyai_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mempunyai_fk ON public.songs_genres USING btree (genre_id);


--
-- TOC entry 3581 (class 1259 OID 31324)
-- Name: menambahkan_ke_playlist_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX menambahkan_ke_playlist_fk ON public.add_songs_playlists USING btree (playlist_id);


--
-- TOC entry 3582 (class 1259 OID 31325)
-- Name: menambahkan_lagu_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX menambahkan_lagu_fk ON public.add_songs_playlists USING btree (song_id);


--
-- TOC entry 3658 (class 1259 OID 31501)
-- Name: mendengarkan2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mendengarkan2_fk ON public.listens USING btree (user_id);


--
-- TOC entry 3659 (class 1259 OID 31502)
-- Name: mendengarkan_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mendengarkan_fk ON public.listens USING btree (song_id);


--
-- TOC entry 3640 (class 1259 OID 31458)
-- Name: mengikuti2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mengikuti2_fk ON public.follow_users USING btree (followed_id);


--
-- TOC entry 3641 (class 1259 OID 31459)
-- Name: mengikuti3_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mengikuti3_fk ON public.follow_users USING btree (follower_id);


--
-- TOC entry 3635 (class 1259 OID 31448)
-- Name: mengikuti4_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mengikuti4_fk ON public.follow_artists USING btree (user_id);


--
-- TOC entry 3636 (class 1259 OID 31449)
-- Name: mengikuti_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mengikuti_fk ON public.follow_artists USING btree (artist_id);


--
-- TOC entry 3653 (class 1259 OID 31488)
-- Name: menyukai2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX menyukai2_fk ON public.like_songs USING btree (song_id);


--
-- TOC entry 3654 (class 1259 OID 31489)
-- Name: menyukai_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX menyukai_fk ON public.like_songs USING btree (user_id);


--
-- TOC entry 3676 (class 1259 OID 31551)
-- Name: merilis2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX merilis2_fk ON public.releases USING btree (artist_id);


--
-- TOC entry 3677 (class 1259 OID 31552)
-- Name: merilis_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX merilis_fk ON public.releases USING btree (collection_id);


--
-- TOC entry 3668 (class 1259 OID 31527)
-- Name: pl_library_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pl_library_pk ON public.pl_library USING btree (user_id, playlist_id);


--
-- TOC entry 3665 (class 1259 OID 31518)
-- Name: playlists_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX playlists_pk ON public.playlists USING btree (playlist_id);


--
-- TOC entry 3673 (class 1259 OID 31541)
-- Name: rate2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rate2_fk ON public.rate_songs USING btree (user_id);


--
-- TOC entry 3674 (class 1259 OID 31542)
-- Name: rate_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rate_fk ON public.rate_songs USING btree (song_id);


--
-- TOC entry 3675 (class 1259 OID 31540)
-- Name: rate_songs_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX rate_songs_pk ON public.rate_songs USING btree (user_id, song_id);


--
-- TOC entry 3669 (class 1259 OID 31528)
-- Name: relationship_38_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX relationship_38_fk ON public.pl_library USING btree (user_id);


--
-- TOC entry 3670 (class 1259 OID 31529)
-- Name: relationship_39_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX relationship_39_fk ON public.pl_library USING btree (playlist_id);


--
-- TOC entry 3622 (class 1259 OID 31416)
-- Name: relationship_40_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX relationship_40_fk ON public.collection_library USING btree (user_id);


--
-- TOC entry 3623 (class 1259 OID 31417)
-- Name: relationship_41_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX relationship_41_fk ON public.collection_library USING btree (collection_id);


--
-- TOC entry 3680 (class 1259 OID 31550)
-- Name: releases_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX releases_pk ON public.releases USING btree (collection_id, artist_id);


--
-- TOC entry 3685 (class 1259 OID 31566)
-- Name: reviews_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX reviews_pk ON public.reviews USING btree (review_id);


--
-- TOC entry 3691 (class 1259 OID 31579)
-- Name: socials_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX socials_pk ON public.socials USING btree (social_id);


--
-- TOC entry 3699 (class 1259 OID 31602)
-- Name: songs_genres_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX songs_genres_pk ON public.songs_genres USING btree (genre_id, song_id);


--
-- TOC entry 3694 (class 1259 OID 31594)
-- Name: songs_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX songs_pk ON public.songs USING btree (song_id);


--
-- TOC entry 3627 (class 1259 OID 31426)
-- Name: top_3_genre2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX top_3_genre2_fk ON public.collection_top_3_genres USING btree (genre_id);


--
-- TOC entry 3628 (class 1259 OID 31427)
-- Name: top_3_genre_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX top_3_genre_fk ON public.collection_top_3_genres USING btree (collection_id);


--
-- TOC entry 3702 (class 1259 OID 31616)
-- Name: tours_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tours_pk ON public.tours USING btree (tour_id);


--
-- TOC entry 3585 (class 1259 OID 31323)
-- Name: user_menambahkan_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_menambahkan_fk ON public.add_songs_playlists USING btree (user_id);


--
-- TOC entry 3705 (class 1259 OID 31632)
-- Name: users_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_pk ON public.users USING btree (user_id);


--
-- TOC entry 3753 (class 2620 OID 31925)
-- Name: block_users trg_block_cleanup; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_block_cleanup AFTER INSERT ON public.block_users FOR EACH ROW EXECUTE FUNCTION public.enforce_block_logic();


--
-- TOC entry 3757 (class 2620 OID 31911)
-- Name: playlists trg_fix_playlist_collaborators; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_fix_playlist_collaborators AFTER UPDATE OF iscollaborative ON public.playlists FOR EACH ROW EXECUTE FUNCTION public.fix_playlist_collaborators();


--
-- TOC entry 3752 (class 2620 OID 31913)
-- Name: add_songs_playlists trg_reorder_playlist_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_reorder_playlist_delete AFTER DELETE ON public.add_songs_playlists FOR EACH ROW EXECUTE FUNCTION public.reorder_playlist_sequence();


--
-- TOC entry 3756 (class 2620 OID 31915)
-- Name: follow_artists trg_update_artist_follow_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_artist_follow_count AFTER INSERT OR DELETE ON public.follow_artists FOR EACH ROW EXECUTE FUNCTION public.update_artist_follow_count();


--
-- TOC entry 3759 (class 2620 OID 31917)
-- Name: reviews trg_update_collection_rating; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_collection_rating AFTER INSERT OR DELETE OR UPDATE ON public.reviews FOR EACH ROW EXECUTE FUNCTION public.update_collection_rating();


--
-- TOC entry 3755 (class 2620 OID 31919)
-- Name: collections_songs trg_update_collection_top3_genres; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_collection_top3_genres AFTER INSERT OR UPDATE ON public.collections_songs FOR EACH ROW EXECUTE FUNCTION public.update_collection_top3_genres();


--
-- TOC entry 3760 (class 2620 OID 31921)
-- Name: reviews trg_update_review_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_review_timestamp BEFORE UPDATE ON public.reviews FOR EACH ROW EXECUTE FUNCTION public.update_review_timestamp();


--
-- TOC entry 3758 (class 2620 OID 31923)
-- Name: rate_songs trg_update_song_rating; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_song_rating AFTER INSERT OR DELETE OR UPDATE ON public.rate_songs FOR EACH ROW EXECUTE FUNCTION public.update_song_rating();


--
-- TOC entry 3754 (class 2620 OID 31927)
-- Name: collections trg_validate_prerelease_date; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_validate_prerelease_date BEFORE INSERT OR UPDATE ON public.collections FOR EACH ROW EXECUTE FUNCTION public.validate_prerelease_date();


--
-- TOC entry 3761 (class 2620 OID 31929)
-- Name: tours trg_validate_tour_date; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_validate_tour_date BEFORE INSERT OR UPDATE ON public.tours FOR EACH ROW EXECUTE FUNCTION public.validate_tour_date();


--
-- TOC entry 3710 (class 2606 OID 31633)
-- Name: add_songs_playlists fk_add_song_menambahk_playlist; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.add_songs_playlists
    ADD CONSTRAINT fk_add_song_menambahk_playlist FOREIGN KEY (playlist_id) REFERENCES public.playlists(playlist_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3711 (class 2606 OID 31638)
-- Name: add_songs_playlists fk_add_song_menambahk_songs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.add_songs_playlists
    ADD CONSTRAINT fk_add_song_menambahk_songs FOREIGN KEY (song_id) REFERENCES public.songs(song_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3712 (class 2606 OID 31643)
-- Name: add_songs_playlists fk_add_song_user_mena_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.add_songs_playlists
    ADD CONSTRAINT fk_add_song_user_mena_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3715 (class 2606 OID 31663)
-- Name: artist_promotion fk_artist_p_mempromos_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_promotion
    ADD CONSTRAINT fk_artist_p_mempromos_artists FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3716 (class 2606 OID 31658)
-- Name: artist_promotion fk_artist_p_mempromos_collecti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_promotion
    ADD CONSTRAINT fk_artist_p_mempromos_collecti FOREIGN KEY (collection_id) REFERENCES public.collections(collection_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3713 (class 2606 OID 31648)
-- Name: artists_tours fk_artists__memiliki2_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists_tours
    ADD CONSTRAINT fk_artists__memiliki2_artists FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3714 (class 2606 OID 31653)
-- Name: artists_tours fk_artists__memiliki3_tours; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists_tours
    ADD CONSTRAINT fk_artists__memiliki3_tours FOREIGN KEY (tour_id) REFERENCES public.tours(tour_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3720 (class 2606 OID 31678)
-- Name: block_users fk_block_us_di_block__users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_users
    ADD CONSTRAINT fk_block_us_di_block__users FOREIGN KEY (blocker_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3721 (class 2606 OID 31683)
-- Name: block_users fk_block_us_mem_block_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_users
    ADD CONSTRAINT fk_block_us_mem_block_users FOREIGN KEY (blocked_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3718 (class 2606 OID 31668)
-- Name: blocklist_artists fk_blocklis_mem_black_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocklist_artists
    ADD CONSTRAINT fk_blocklis_mem_black_artists FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3719 (class 2606 OID 31673)
-- Name: blocklist_artists fk_blocklis_mem_black_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocklist_artists
    ADD CONSTRAINT fk_blocklis_mem_black_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3724 (class 2606 OID 31698)
-- Name: collection_library fk_collecti_collectio_collecti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_library
    ADD CONSTRAINT fk_collecti_collectio_collecti FOREIGN KEY (collection_id) REFERENCES public.collections(collection_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3722 (class 2606 OID 31693)
-- Name: collections_songs fk_collecti_memiliki4_songs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections_songs
    ADD CONSTRAINT fk_collecti_memiliki4_songs FOREIGN KEY (song_id) REFERENCES public.songs(song_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3723 (class 2606 OID 31688)
-- Name: collections_songs fk_collecti_memiliki_collecti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections_songs
    ADD CONSTRAINT fk_collecti_memiliki_collecti FOREIGN KEY (collection_id) REFERENCES public.collections(collection_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3726 (class 2606 OID 31708)
-- Name: collection_top_3_genres fk_collecti_top_3_gen_collecti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_top_3_genres
    ADD CONSTRAINT fk_collecti_top_3_gen_collecti FOREIGN KEY (collection_id) REFERENCES public.collections(collection_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3727 (class 2606 OID 31713)
-- Name: collection_top_3_genres fk_collecti_top_3_gen_genres; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_top_3_genres
    ADD CONSTRAINT fk_collecti_top_3_gen_genres FOREIGN KEY (genre_id) REFERENCES public.genres(genre_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3725 (class 2606 OID 31703)
-- Name: collection_library fk_collecti_user_coll_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_library
    ADD CONSTRAINT fk_collecti_user_coll_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3728 (class 2606 OID 31723)
-- Name: create_songs fk_create_s_membuat2_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.create_songs
    ADD CONSTRAINT fk_create_s_membuat2_artists FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3729 (class 2606 OID 31718)
-- Name: create_songs fk_create_s_membuat_songs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.create_songs
    ADD CONSTRAINT fk_create_s_membuat_songs FOREIGN KEY (song_id) REFERENCES public.songs(song_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3730 (class 2606 OID 31728)
-- Name: follow_artists fk_follow_a_mengikuti_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow_artists
    ADD CONSTRAINT fk_follow_a_mengikuti_artists FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3731 (class 2606 OID 31733)
-- Name: follow_artists fk_follow_a_mengikuti_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow_artists
    ADD CONSTRAINT fk_follow_a_mengikuti_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3732 (class 2606 OID 31738)
-- Name: follow_users fk_follow_u_mengikuti_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow_users
    ADD CONSTRAINT fk_follow_u_mengikuti_users FOREIGN KEY (followed_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3733 (class 2606 OID 31743)
-- Name: follow_users fk_follow_u_user_diik_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow_users
    ADD CONSTRAINT fk_follow_u_user_diik_users FOREIGN KEY (follower_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3734 (class 2606 OID 31748)
-- Name: like_reviews fk_like_rev_like_revi_reviews; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.like_reviews
    ADD CONSTRAINT fk_like_rev_like_revi_reviews FOREIGN KEY (review_id) REFERENCES public.reviews(review_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3735 (class 2606 OID 31753)
-- Name: like_reviews fk_like_rev_like_revi_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.like_reviews
    ADD CONSTRAINT fk_like_rev_like_revi_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3736 (class 2606 OID 31763)
-- Name: like_songs fk_like_son_menyukai2_songs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.like_songs
    ADD CONSTRAINT fk_like_son_menyukai2_songs FOREIGN KEY (song_id) REFERENCES public.songs(song_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3737 (class 2606 OID 31758)
-- Name: like_songs fk_like_son_menyukai_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.like_songs
    ADD CONSTRAINT fk_like_son_menyukai_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3738 (class 2606 OID 31768)
-- Name: listens fk_listens_mendengar_songs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listens
    ADD CONSTRAINT fk_listens_mendengar_songs FOREIGN KEY (song_id) REFERENCES public.songs(song_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3739 (class 2606 OID 31773)
-- Name: listens fk_listens_mendengar_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listens
    ADD CONSTRAINT fk_listens_mendengar_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3741 (class 2606 OID 31783)
-- Name: pl_library fk_pl_libra_playlist__playlist; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pl_library
    ADD CONSTRAINT fk_pl_libra_playlist__playlist FOREIGN KEY (playlist_id) REFERENCES public.playlists(playlist_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3742 (class 2606 OID 31788)
-- Name: pl_library fk_pl_libra_user_play_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pl_library
    ADD CONSTRAINT fk_pl_libra_user_play_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3740 (class 2606 OID 31778)
-- Name: playlists fk_playlist_membuat_p_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT fk_playlist_membuat_p_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3717 (class 2606 OID 31877)
-- Name: artist_promotion fk_promo_own_release; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_promotion
    ADD CONSTRAINT fk_promo_own_release FOREIGN KEY (artist_id, collection_id) REFERENCES public.releases(artist_id, collection_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3743 (class 2606 OID 31798)
-- Name: rate_songs fk_rate_son_rate2_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate_songs
    ADD CONSTRAINT fk_rate_son_rate2_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3744 (class 2606 OID 31793)
-- Name: rate_songs fk_rate_son_rate_songs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate_songs
    ADD CONSTRAINT fk_rate_son_rate_songs FOREIGN KEY (song_id) REFERENCES public.songs(song_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3745 (class 2606 OID 31808)
-- Name: releases fk_releases_merilis2_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.releases
    ADD CONSTRAINT fk_releases_merilis2_artists FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3746 (class 2606 OID 31803)
-- Name: releases fk_releases_merilis_collecti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.releases
    ADD CONSTRAINT fk_releases_merilis_collecti FOREIGN KEY (collection_id) REFERENCES public.collections(collection_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3747 (class 2606 OID 31813)
-- Name: reviews fk_reviews_collectio_collecti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_reviews_collectio_collecti FOREIGN KEY (collection_id) REFERENCES public.collections(collection_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3748 (class 2606 OID 31818)
-- Name: reviews fk_reviews_membuat_r_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_reviews_membuat_r_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3749 (class 2606 OID 31823)
-- Name: socials fk_socials_has_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socials
    ADD CONSTRAINT fk_socials_has_artists FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3750 (class 2606 OID 31828)
-- Name: songs_genres fk_songs_ge_mempunyai_genres; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_genres
    ADD CONSTRAINT fk_songs_ge_mempunyai_genres FOREIGN KEY (genre_id) REFERENCES public.genres(genre_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3751 (class 2606 OID 31833)
-- Name: songs_genres fk_songs_ge_mempunyai_songs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_genres
    ADD CONSTRAINT fk_songs_ge_mempunyai_songs FOREIGN KEY (song_id) REFERENCES public.songs(song_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3959 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2025-12-05 11:57:09 WIB

--
-- PostgreSQL database dump complete
--

\unrestrict nmLYIEM71PRun2S6QvZ1VFwOQqZzgscfG4Z3mzcWCsh6ZF9xyaYFjN84fxAzhv6

