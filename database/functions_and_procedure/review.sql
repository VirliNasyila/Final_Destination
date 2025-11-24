--Procedure: create_review(user_id, collection_id, review_text)
--Procedure: like_review(user_id, review_id)
--Procedure: unlike_review(user_id, review_id)

/*==============================================================*/
/* Procedure: CREATE_REVIEW                               */
/*==============================================================*/
CREATE OR REPLACE PROCEDURE create_review(
    p_review_text TEXT,
	p_rating NUMERIC (3,0),
	p_user_id INT4,
    p_collection_id INT4
)
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

select * from users
select * from reviews
CALL create_review('Album ini sangat keren!', 10, 1, 1);
CALL create_review('Test review', 10, 9999, 1);
CALL create_review('Test review', 10, 2, 9999);
CALL create_review('', 10, 2, 3);
CALL create_review('Review pertama', 10, 1, 10);
CALL create_review('Review kedua', 10, 1, 10);

/*==============================================================*/
/* Procedure: LIKE_REVIEW                               */
/*==============================================================*/
CREATE OR REPLACE PROCEDURE like_review(
    p_user_id INT,
    p_review_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- cek user
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User_id % not found', p_user_id;
    END IF;

    -- cek review
    IF NOT EXISTS (SELECT 1 FROM reviews WHERE review_id = p_review_id) THEN
        RAISE EXCEPTION 'Review_id % not found', p_review_id;
    END IF;

    -- user tidak boleh like review sendiri
    IF EXISTS (
        SELECT 1 FROM reviews
        WHERE review_id = p_review_id
        AND user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'User cannot like their own review';
    END IF;

    -- cek jika sudah like
    IF EXISTS (
        SELECT 1 FROM like_reviews
        WHERE review_id = p_review_id
        AND user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'Review already liked by this user';
    END IF;

    -- insert like (tanpa timestamp)
    INSERT INTO like_reviews(review_id, user_id)
    VALUES (p_review_id, p_user_id);

    RAISE NOTICE 'Review % liked by user %', p_review_id, p_user_id;
END;
$$;

CALL like_review(2, 15);
CALL like_review(9999, 15);
CALL like_review(2, 99999);
CALL like_review(1, 15);
CALL like_review(2, 15);
CALL like_review(2, 15);

/*==============================================================*/
/* Procedure: UNLIKE_REVIEW                               */
/*==============================================================*/
CREATE OR REPLACE PROCEDURE unlike_review(
    p_user_id INT,
    p_review_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- cek user
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User_id % not found', p_user_id;
    END IF;

    -- cek review
    IF NOT EXISTS (SELECT 1 FROM reviews WHERE review_id = p_review_id) THEN
        RAISE EXCEPTION 'Review_id % not found', p_review_id;
    END IF;

    -- cek apakah like belum ada
    IF NOT EXISTS (
        SELECT 1 FROM like_reviews
        WHERE review_id = p_review_id
        AND user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'User has not liked this review';
    END IF;

    -- hapus like
    DELETE FROM like_reviews
    WHERE review_id = p_review_id
    AND user_id = p_user_id;

    RAISE NOTICE 'Review % unliked by user %', p_review_id, p_user_id;
END;
$$;

CALL unlike_review(2, 15);
CALL unlike_review(9999, 15);
CALL unlike_review(2, 99999);
CALL unlike_review(3, 15);

CREATE OR REPLACE FUNCTION get_reviews_with_likes()
RETURNS TABLE (
    review_id INT,
    review TEXT,
	rating NUMERIC (3,0),
	review_timestamp TIMESTAMP,
	reviewer_id INT,
	collection_id INT,
    liked_by INT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.review_id,
        r.review,
		r.rating,
		r."TIMESTAMP",
		r.user_id AS reviewer_id,
		r.collection_id,
        lr.user_id AS liked_by
    FROM reviews r
    LEFT JOIN like_reviews lr ON lr.review_id = r.review_id
    ORDER BY r.review_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_reviews_with_likes();