

-- Trigger follow–unfollow artis
CREATE OR REPLACE FUNCTION update_artist_follow_count()
RETURNS TRIGGER AS $$
BEGIN
    -- FOLLOW → INSERT
    IF TG_OP = 'INSERT' THEN
        UPDATE artists
        SET follower_count = COALESCE(follower_count, 0) + 1
        WHERE artist_id = NEW.artist_id;
    END IF;

    -- UNFOLLOW → DELETE
    IF TG_OP = 'DELETE' THEN
        UPDATE artists
        SET follower_count = COALESCE(follower_count, 0) - 1
        WHERE artist_id = OLD.artist_id;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- trigger
CREATE TRIGGER trg_update_artist_follow_count
AFTER INSERT OR DELETE
ON follow_artists
FOR EACH ROW
EXECUTE FUNCTION update_artist_follow_count();

-- -- cek
-- -- follow
-- INSERT INTO follow_artists (user_id, artist_id)
-- VALUES (9, 4);

-- INSERT INTO follow_artists (user_id, artist_id)
-- VALUES (10, 4);

-- -- unfollow
-- DELETE FROM follow_artists
-- WHERE user_id = 9 AND artist_id = 4;
-- DELETE FROM follow_artists

-- SELECT follower_count FROM artists WHERE artist_id = 4;

-- SELECT * FROM artists;
