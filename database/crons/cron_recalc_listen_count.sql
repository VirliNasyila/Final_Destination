CREATE OR REPLACE FUNCTION recalc_listen_count()
RETURNS void AS $$
BEGIN
    UPDATE songs s
    SET listen_count = sub.cnt
    FROM (
        SELECT song_id, COUNT(*) AS cnt
        FROM listens
        GROUP BY song_id
    ) sub
    WHERE s.song_id = sub.song_id;
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule(
    'recalc_listen_count_daily',
    '20 0 * * *',
    $$SELECT recalc_listen_count();$$
);
