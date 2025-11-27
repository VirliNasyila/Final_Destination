CREATE OR REPLACE FUNCTION reorder_playlist_sequence()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE add_songs_playlists
    SET no_urut = no_urut - 1
    WHERE playlist_id = OLD.playlist_id
    AND no_urut > OLD.no_urut;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_reorder_playlist_delete
AFTER DELETE ON add_songs_playlists
FOR EACH ROW
EXECUTE FUNCTION reorder_playlist_sequence();