CREATE OR REPLACE FUNCTION get_song_average_rating(p_song_id INT)
RETURNS NUMERIC AS $$
DECLARE
    avg_rating NUMERIC;
BEGIN
    SELECT AVG(r.song_rating)
    INTO avg_rating
    FROM rate_songs r
    WHERE r.song_id = p_song_id;

    RETURN avg_rating;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_playlist_duration_minutes(p_playlist_id INT)
RETURNS INT AS $$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_artist_total_plays(p_artist_id INT)
RETURNS BIGINT AS $$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_album_total_duration(p_collection_id INT)
RETURNS INT AS $$
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
$$ LANGUAGE plpgsql;