--Procedure: create_review(user_id, collection_id, review_text)
--Procedure: like_review(user_id, review_id)
--Procedure: unlike_review(user_id, review_id)

/*==============================================================*/
/* Procedure: CREATE_REVIEW                               */
/*==============================================================*/
CREATE OR REPLACE PROCEDURE create_review(
    p_user_id INT,
    p_collection_id INT,
    p_review_text TEXT
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
    IF EXISTS (
        SELECT 1 FROM reviews
        WHERE user_id = p_user_id
        AND collection_id = p_collection_id
    ) THEN
        RAISE EXCEPTION 'User has already reviewed this collection';
    END IF;

    -- ambil review_id dari sequence
    SELECT NEXTVAL('reviews_review_id_seq')
    INTO v_review_id;

    -- insert review (trigger kamu akan update timestamp jika review diganti)
    INSERT INTO reviews(review_id, user_id, collection_id, review, "timestamp")
    VALUES (v_review_id, p_user_id, p_collection_id, p_review_text, CURRENT_TIMESTAMP);

    RAISE NOTICE 'Review created with ID %', v_review_id;
END;
$$;

CALL create_review(1, 10, 'Album ini sangat keren!');
CALL create_review(9999, 10, 'Test review');
CALL create_review(1, 9999, 'Test review');
CALL create_review(1, 10, '');
CALL create_review(1, 10, 'Review pertama');
CALL create_review(1, 10, 'Review kedua');

/*==============================================================*/
/* Procedure: CREATE_REVIEW                               */
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
/* Procedure: CREATE_REVIEW                               */
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
    liked_by INT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.review_id,
        r.review,
        lr.user_id AS liked_by
    FROM reviews r
    LEFT JOIN like_reviews lr ON lr.review_id = r.review_id
    ORDER BY r.review_id;
END;
$$ LANGUAGE plpgsql;
