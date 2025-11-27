/*==============================================================*/
/* Procedure: ADD_ARTIST_PROMOTION                              */
/*==============================================================*/
DROP PROCEDURE IF EXISTS add_artist_promotion(INT, INT, TEXT);
CREATE OR REPLACE PROCEDURE add_artist_promotion(p_artist_id INT, p_collection_id INT, p_comment TEXT)
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

select * from releases

CALL add_artist_promotion(3, 3, 'Check out my new album!');
select * from artist_promotion
CALL add_artist_promotion(3, 3, 'Updated promo!');
select * from artist_promotion
CALL add_artist_promotion(10, 20, 'Invalid promotion');
CALL add_artist_promotion(999, 5, 'hello');
CALL add_artist_promotion(10, 999, 'promo');

/*==============================================================*/
/* Funtion:GET_ARTIST_TOURS                                     */
/*==============================================================*/
CREATE OR REPLACE FUNCTION get_artist_tours(p_artist_id INT)
RETURNS TABLE (
    tour_id INT,
    tour_name TEXT,
    venue TEXT,
    tour_date DATE
)
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
$$ LANGUAGE plpgsql STABLE;

select * from artists_tours
select * from tours

--tambah tour
INSERT INTO tours (tour_id, tour_name, venue, tour_date)
VALUES (100, 'World Tour 2025', 'Jakarta Convention Center', '2025-12-20');

-- relasikan artis ke tour
INSERT INTO artists_tours (artist_id, tour_id)
VALUES (3, 100);

SELECT * FROM get_artist_tours(3);
SELECT * FROM get_artist_tours(20);
SELECT * FROM get_artist_tours(999);