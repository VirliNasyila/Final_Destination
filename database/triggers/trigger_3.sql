

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
