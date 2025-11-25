/*==============================================================*/
/* Function: GET_ARTIST_DETAIL                                  */
/*==============================================================*/
DROP FUNCTION IF EXISTS get_artist_detail(INT);

CREATE OR REPLACE FUNCTION get_artist_detail(p_artist_id INT)
RETURNS TABLE (
    artist_id INT,
    artist_name VARCHAR(255),
    bio TEXT,
    artist_pfp VARCHAR(2048),
    banner VARCHAR(2048),
    artist_email VARCHAR(320),
    monthly_listener_count BIGINT,
    follower_count BIGINT,
    total_albums BIGINT,
    total_tracks BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM view_artist_profile_header v WHERE v.artist_id = p_artist_id;
END;
$$ LANGUAGE plpgsql STABLE;

SELECT * FROM get_artist_detail(3)
/*==============================================================*/
/* Function: GET_ARTIST_CONTENT                                 */
/*==============================================================*/
DROP FUNCTION IF EXISTS get_artist_content(INT, TEXT);

CREATE OR REPLACE FUNCTION get_artist_content(p_artist_id INT, p_type TEXT)
RETURNS TABLE (
    content_type TEXT,
    content_id INT,
    title TEXT,
    extra_info TEXT
)
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
$$ LANGUAGE plpgsql STABLE;

SELECT * FROM get_artist_content(2, 'songs')
SELECT * FROM get_artist_content(2, 'collections')
SELECT * FROM get_artist_content(2, 'tours')
SELECT * FROM get_artist_content(2, 'promotions')
SELECT * FROM get_artist_content(2, 'song')

/*==============================================================*/
/* Procedure: TOGGLE_FOLLOW_ARTIST                              */
/*==============================================================*/
CREATE OR REPLACE PROCEDURE toggle_follow_artist(p_user_id INT, p_artist_id INT)
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

call toggle_follow_artist(1, 12)
select * from follow_artists
call toggle_follow_artist(9999, 12)
call toggle_follow_artist(12, 9999)
call toggle_follow_artist(1, 12)
select * from follow_artists
