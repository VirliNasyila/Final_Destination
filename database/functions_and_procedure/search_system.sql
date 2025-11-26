/*search(keyword, type) 
type = 'song' | 'artist' | 'collection' | 'playlist' | 'user'*/

DROP FUNCTION IF EXISTS search(TEXT, TEXT);

CREATE OR REPLACE FUNCTION search(keyword TEXT, type TEXT)
RETURNS TABLE (
    result_type TEXT,
    id INT,
    title TEXT,
    info TEXT,
    extra_info TEXT
)
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
$$ LANGUAGE plpgsql STABLE;

select * from search('nug', 'user')
select * from search ('lil', 'artist')
select * from search('story', 'song')
select * from search('love', 'collection')
select * from search('love', 'playlist')
