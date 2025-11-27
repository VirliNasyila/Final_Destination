CREATE OR REPLACE FUNCTION get_collection_genres(p_collection_id INT)
RETURNS TABLE(genre_id INT, genre_name VARCHAR)
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


CREATE OR REPLACE FUNCTION get_collection_average_rating(p_collection_id INT)
RETURNS NUMERIC AS
$$
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
$$ LANGUAGE plpgsql;
