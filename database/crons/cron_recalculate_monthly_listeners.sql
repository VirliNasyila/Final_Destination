CREATE OR REPLACE FUNCTION recalculate_monthly_listeners()
RETURNS VOID AS $$
BEGIN
    UPDATE artists a
    SET monthly_listener_count = sub.cnt
    FROM (
        SELECT
            cs.artist_id,
            COUNT(DISTINCT l.user_id) AS cnt
        FROM listens l
        JOIN create_songs cs ON cs.song_id = l.song_id
        WHERE DATE_TRUNC('month', l.timestamp) = DATE_TRUNC('month', CURRENT_DATE)
        GROUP BY cs.artist_id
    ) sub
    WHERE a.artist_id = sub.artist_id;
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule(
    'recalculate_monthly_listeners_daily',
    '0 1 * * *',
    $$SELECT recalculate_monthly_listeners();$$
);
