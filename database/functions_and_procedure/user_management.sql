/*register_user
login_user(email, password_hash)
follow_user(follower_id, followed_id)
unfollow_user(follower_id, followed_id)
get_followers(user_id)*/

CREATE EXTENSION IF NOT EXISTS pgcrypto;
/*==============================================================*/
/* Function: REGISTER_USER
insert data user baru ke table users dan mengembalikan user_id  */
/*==============================================================*/
DROP FUNCTION IF EXISTS register_user(VARCHAR, VARCHAR, VARCHAR);

CREATE OR REPLACE FUNCTION register_user(p_username VARCHAR, p_raw_pw VARCHAR, p_user_email VARCHAR)
RETURNS TABLE (
    user_id INT4,
    message TEXT
)
AS $$
DECLARE
	v_user_id INT4;
    v_pw_hash TEXT;
BEGIN
    --cek apakah email sudah dipakai atau belum
    IF EXISTS (SELECT 1 FROM users WHERE user_email = p_user_email) THEN
        RETURN QUERY SELECT NULL::INT, 'Email already registered'::TEXT;
        RETURN;
    END IF;

    --cek apakah username sudah dipakai atau belum
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
        RETURN QUERY SELECT NULL::INT, 'Username already taken'::TEXT;
        RETURN;
    END IF;

    --hash password menggunakan bcrypt
    v_pw_hash := crypt(p_raw_pw, gen_salt('bf'));

	--generate user_id dari sequence
	SELECT nextval('seq_users_id') INTO v_user_id;
	
    --insert user baru, user_id dari sequence
    INSERT INTO users (user_id, username, pw_hash, user_email)
    VALUES (v_user_id, p_username, v_pw_hash, p_user_email);
    RETURN QUERY SELECT v_user_id, 'Registration successful'::TEXT;
	RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM register_user('nugrinti', 'password1234', 'nurahma@gmail.com');

/*==============================================================*/
/* Function: LOGIN_USER
return user_id dan message login successful                     */
/*==============================================================*/
DROP FUNCTION IF EXISTS login_user(VARCHAR);

CREATE OR REPLACE FUNCTION login_user(p_user_email VARCHAR, p_raw_pw VARCHAR)
RETURNS TABLE (
    user_id INT4,
    message TEXT
)
AS $$
DECLARE
	v_user_id INT4;
    v_pw_hash VARCHAR(255);
BEGIN
    --cek apakah username sudah terdaftar atau belum
    SELECT u.user_id, u.pw_hash
    INTO v_user_id, v_pw_hash
    FROM users u
    WHERE u.user_email = p_user_email;

    --jika email belum terdaftar
    IF v_user_id IS NULL THEN
        RETURN QUERY SELECT NULL::INT4, 'Email not registered'::TEXT;
        RETURN;
    END IF;

    --cek password
    IF crypt(p_raw_pw, v_pw_hash) <> v_pw_hash THEN
        RETURN QUERY SELECT NULL::INT4, 'Invalid password'::TEXT;
        RETURN;
    END IF;

    --else, berhasil login
    RETURN QUERY SELECT v_user_id, 'Login successful'::TEXT;
	RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM login_user('nurahma@gmail.com', 'password1234');

/*==============================================================*/
/* Procedure: TOGGLE_FOLLOW_USER   
toggle follow dan unfollow sesama user*/
/*==============================================================*/
CREATE OR REPLACE PROCEDURE toggle_follow_user(p_follower_id INT, p_followed_id INT)
LANGUAGE PLPGSQL
AS $$
DECLARE
    v_exists BOOLEAN;
BEGIN
    --tidak boleh follow/unfollow diri sendiri
    IF p_follower_id = p_followed_id THEN
        RAISE EXCEPTION 'User cannot follow/unfollow themselves';
    END IF;

    --cek apakah kedua user valid
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_follower_id) THEN
        RAISE EXCEPTION 'Follower user_id % not found', p_follower_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_followed_id) THEN
        RAISE EXCEPTION 'Followed user_id % not found', p_followed_id;
    END IF;

    --cek apakah sudah follow, jika sudah -> unfollow
    SELECT EXISTS (SELECT 1 FROM follow_users 
        WHERE follower_id = p_follower_id AND followed_id = p_followed_id) 
    INTO v_exists;

    IF v_exists THEN
        --delete relationship from follow_users
        DELETE from follow_users 
            WHERE follower_id = p_follower_id AND followed_id = p_followed_id;
        RAISE NOTICE 'Unfollow successful';
        RETURN;
    END IF;

    --jika belum follow -> follow
    --insert ke table follow_users
    INSERT INTO follow_users (follower_id, followed_id)
    VALUES (p_follower_id, p_followed_id);
	RAISE NOTICE 'Follow successful';
    
END;$$;

CALL toggle_follow_user(12, 20);
SELECT * FROM follow_users;
CALL unfollow_user(11, 11);
CALL unfollow_user(100, 2);
CALL unfollow_user(2, 100);
CALL unfollow_user(12, 20);

/*==============================================================*/
/* Function: GET_FOLLOWERS                                      */
/*==============================================================*/
DROP FUNCTION IF EXISTS get_followers(INT);

CREATE OR REPLACE FUNCTION get_followers(p_user_id INT)
RETURNS TABLE (
    follower_id INT4,
    follower_username VARCHAR(50),
    follower_email VARCHAR(320)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT u.user_id, u.username, u. user_email
    FROM follow_users
    JOIN users u ON fu.follower_id = u.user_id
    WHERE fu.followed_id = p_user_id
    ORDER BY u.username;
END;
$$ LANGUAGE plpgsql;

CALL follow_user(11, 53);
CALL follow_user(12, 53);
CALL follow_user(20, 53);
CALL follow_user(31, 53);

SELECT * FROM get_followers(53);

/*==============================================================*/
/* Function: GET_FOLLOWING                                      */
/*==============================================================*/
DROP FUNCTION IF EXISTS get_following(INT);

CREATE OR REPLACE FUNCTION get_following(p_user_id INT)
RETURNS TABLE (
    following_id INT4,
    following_username VARCHAR(50),
    following_email VARCHAR(320)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT u.user_id, u.username, u. user_email
    FROM follow_users
    JOIN users u ON fu.followed_id = u.user_id
    WHERE fu.follower_id = p_user_id
    ORDER BY u.username;
END;
$$ LANGUAGE plpgsql;

CALL follow_user(12, 40);
CALL follow_user(12, 30);
CALL follow_user(12, 53);

SELECT * FROM get_following(12);