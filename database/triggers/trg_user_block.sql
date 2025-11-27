CREATE OR REPLACE FUNCTION enforce_block_logic()
RETURNS TRIGGER AS $$
BEGIN
    -- Hapus hubungan follow kedua arah
    DELETE FROM follow_users
    WHERE (follower_id = NEW.blocker_id AND followed_id = NEW.blocked_id)
       OR (follower_id = NEW.blocked_id AND followed_id = NEW.blocker_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_block_cleanup
AFTER INSERT ON block_users
FOR EACH ROW
EXECUTE FUNCTION enforce_block_logic();