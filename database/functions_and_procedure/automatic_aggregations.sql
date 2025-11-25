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


CREATE OR REPLACE PROCEDURE update_song_rating(p_song_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    avg_rating NUMERIC;
BEGIN
    SELECT get_song_average_rating(p_song_id)
    INTO avg_rating;

    UPDATE songs
    SET song_rating = avg_rating
    WHERE song_id = p_song_id;
END;
$$;


CREATE OR REPLACE PROCEDURE update_collection_rating(p_collection_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    avg_rating NUMERIC;
BEGIN
    SELECT get_collection_average_rating(p_collection_id)
    INTO avg_rating;

    UPDATE collections
    SET collection_rating = avg_rating
    WHERE collection_id = p_collection_id;
END;
$$;
