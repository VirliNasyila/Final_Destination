CREATE OR REPLACE FUNCTION recalculate_all_song_popularity()
RETURNS VOID AS $$
BEGIN
    UPDATE songs s
    SET popularity = sub.pop
    FROM (
        SELECT
            l.song_id,
            CASE
                WHEN COUNT(*) <= 1 THEN 0
                ELSE LEAST(100, LOG(10, COUNT(*)) * 25)
            END AS pop
        FROM listens l
        WHERE l.timestamp >= CURRENT_DATE - INTERVAL '30 days'
        GROUP BY l.song_id
    ) sub
    WHERE s.song_id = sub.song_id;
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule(
    'recalculate_song_popularity_daily',
    '0 3 * * *',
    $$SELECT recalculate_all_song_popularity();$$
);
