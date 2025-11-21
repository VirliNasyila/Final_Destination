--search_song
--search_collection
--search_artist
--search_playlist

/*==============================================================*/
/* Function: SEARCH_SONG                                    */
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
/* Function: SEARCH_COLLECTION                                  */
/*==============================================================*/


/*==============================================================*/
/* Function: SEARCH_PLAYLIST                	                */
/*==============================================================*/



/*==============================================================*/
/* Function: SEARCH_ARTIS		                                */
/*==============================================================*/

