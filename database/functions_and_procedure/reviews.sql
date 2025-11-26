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
/* Procedure: TOGGLE_LIKE_REVIEW                               */
/*==============================================================*/
CREATE OR REPLACE PROCEDURE toggle_like_review(p_user_id INT, p_review_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
	v_exists BOOLEAN;
BEGIN
    -- cek user
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User_id % not found', p_user_id;
    END IF;

    -- cek review
    IF NOT EXISTS (SELECT 1 FROM reviews WHERE review_id = p_review_id) THEN
        RAISE EXCEPTION 'Review_id % not found', p_review_id;
    END IF;

    --cek toggle
    SELECT EXISTS (SELECT 1 FROM like_reviews WHERE review_id = p_review_id AND user_id = p_user_id)
    INTO v_exists;

    --jika sudah like -> unlike
    IF v_exists THEN
        DELETE FROM like_reviews WHERE review_id = p_review_id AND user_id = p_user_id;
        RAISE NOTICE 'Review % unliked by user %', p_review_id, p_user_id;
        RETURN;
    END IF;

    -- jika belum like -> insert like
    INSERT INTO like_reviews VALUES (p_review_id, p_user_id);
    RAISE NOTICE 'Review % liked by user %', p_review_id, p_user_id;
END;
$$;

select * from reviews
CALL toggle_like_review(2, 1);
select * from like_reviews
CALL toggle_like_review(9999, 15);
CALL toggle_like_review(2, 99999);

/*==============================================================*/
/* Procedure: UNLIKE_REVIEW                               */
/*==============================================================*/
CREATE OR REPLACE PROCEDURE unlike_review(p_user_id INT, p_review_id INT)
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
        SELECT 1 FROM like_reviews WHERE review_id = p_review_id
        	AND user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'User has not liked this review';
    END IF;

    -- hapus like
    DELETE FROM like_reviews WHERE review_id = p_review_id AND user_id = p_user_id;

    RAISE NOTICE 'Review % unliked by user %', p_review_id, p_user_id;
END;
$$;

select * from like_reviews
CALL unlike_review(2, 4);
CALL unlike_review(9999, 15);
CALL unlike_review(2, 99999);
CALL unlike_review(2, 4);
CALL unlike_review(2, 3);