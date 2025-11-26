/*10. get_collection_detail(collection_id) — FUNCTION
11. get_collection_tracks(collection_id) — FUNCTION
12. get_new_releases(limit_n) — FUNCTION
    Mirip Spotify Browse → “New Releases”.
    > get_artist_collections sudah ditutup fungsinya di modul Artist.*/
DROP FUNCTION IF EXISTS get_collection_detail(INT);
CREATE OR REPLACE FUNCTION get_collection_detail(p_collection_id INT)
RETURNS TABLE (
    collection_id INT,
    collection_title TEXT,
    collection_type TEXT,
    collection_cover TEXT,
    release_date DATE,
    rating NUMERIC(3,0),
    is_prerelease BOOL,
    total_tracks BIGINT,
    total_artists BIGINT
)
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
$$ LANGUAGE plpgsql STABLE;

SELECT * FROM get_collection_detail(1);
SELECT * FROM get_collection_detail(999);  

DROP FUNCTION IF EXISTS get_collection_tracks
CREATE OR REPLACE FUNCTION get_collection_tracks(p_collection_id INT)
RETURNS TABLE (
    track_number INT,
    song_id INT,
    song_title TEXT,
    artist_name TEXT,
    duration INT,
    popularity NUMERIC(3,0),
    song_file TEXT
)
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
$$ LANGUAGE plpgsql STABLE;

SELECT * FROM get_collection_tracks(1);

DROP FUNCTION IF EXISTS get_new_releases
CREATE OR REPLACE FUNCTION get_new_releases(p_limit INT)
RETURNS TABLE (
    collection_id INT,
    title TEXT,
    artist_name TEXT,
    release_date DATE,
    total_tracks BIGINT
)
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
$$ LANGUAGE plpgsql STABLE;

SELECT * FROM get_new_releases(5);
SELECT * FROM get_new_releases(20);	

