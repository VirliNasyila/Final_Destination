--search_song
--search_collection
--search_artist
--search_playlist

/*==============================================================*/
/* Function: SEARCH_SONG                                        */
/*==============================================================*/
DROP FUNCTION IF EXISTS search_song(TEXT);

CREATE OR REPLACE FUNCTION search_song(keyword TEXT)
RETURNS TABLE (
    song_id INT,
    song_title VARCHAR(255),
    artist_name TEXT,
    album_name VARCHAR(255),
    song_duration INT,
    popularity NUMERIC(3,0),
    song_file VARCHAR(2048)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        v.song_id,
        v.song_title,
        v.artist_name,
        v.album_name,
        v.song_duration,
        v.popularity,
        v.song_file
    FROM view_full_song_details v
    WHERE 
        v.song_title ILIKE '%' || keyword || '%'
        OR v.artist_name ILIKE '%' || keyword || '%'
        OR v.album_name ILIKE '%' || keyword || '%'
    ORDER BY v.popularity DESC NULLS LAST;
END;
$$ LANGUAGE plpgsql STABLE;

SELECT * FROM search_song('officiis');

/*==============================================================*/
/* Function: SEARCH_COLLECTION             
search collection based on collection_title(album_name), artist_name,
song_title (lagu dalam album)									*/
/*==============================================================*/
DROP FUNCTION IF EXISTS search_collection(TEXT);

CREATE OR REPLACE FUNCTION search_collection(keyword TEXT)
RETURNS TABLE (
    collection_title VARCHAR(255),
    artist_name TEXT,
    total_tracks BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.album_name AS collection_title,
        v.artist_name,
        COUNT(v.song_id) AS total_tracks
    FROM view_full_song_details v
    WHERE 
        v.album_name ILIKE '%' || keyword || '%'
        OR v.artist_name ILIKE '%' || keyword || '%'
        OR v.song_title ILIKE '%' || keyword || '%'
    GROUP BY 
        v.album_name,
        v.artist_name
    ORDER BY 
        total_tracks DESC;
END;
$$ LANGUAGE plpgsql STABLE;

SELECT * FROM search_collection('Puti')

/*==============================================================*/
/* Function: SEARCH_PLAYLIST                	                */
/* bisa search playlist berdasarkan playlist_title, playlist_desc, 
song_title, artist_name, album_name							    */
/*==============================================================*/
DROP FUNCTION IF EXISTS search_playlist(TEXT);

CREATE OR REPLACE FUNCTION search_playlist(keyword TEXT)
RETURNS TABLE (
    playlist_id INT,
    playlist_title VARCHAR(255),
    playlist_desc TEXT,
    total_songs BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.playlist_id,
        p.playlist_title,
        p.playlist_desc,
        COUNT(asp.song_id) AS total_songs
    FROM playlists p
    LEFT JOIN add_songs_playlists asp 
        ON p.playlist_id = asp.playlist_id
    LEFT JOIN view_full_song_details v
        ON v.song_id = asp.song_id
    WHERE 
        p.playlist_title ILIKE '%' || keyword || '%'
        OR COALESCE(p.playlist_desc, '') ILIKE '%' || keyword || '%'
        OR v.song_title ILIKE '%' || keyword || '%'
        OR v.artist_name ILIKE '%' || keyword || '%'
        OR v.album_name ILIKE '%' || keyword || '%'
    GROUP BY 
        p.playlist_id,
        p.playlist_title,
        p.playlist_desc
    ORDER BY 
        total_songs DESC;
END;
$$ LANGUAGE plpgsql STABLE;

SELECT * FROM search_playlist('officiis');

/*==============================================================*/
/* Function: SEARCH_ARTIST		                                */
/*==============================================================*/


SELECT * FROM playlists
SELECT * FROM collections
SELECT * FROM view_full_song_details