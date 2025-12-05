
CREATE OR REPLACE FUNCTION recalculate_all_song_popularity()
RETURNS VOID AS $$
BEGIN
    -- hitung play maksimum dalam 30 hari terakhir
    WITH play_counts AS (
        SELECT
            song_id,
            COUNT(*) AS plays_30
        FROM listens
        WHERE "TIMESTAMP" >= CURRENT_DATE - INTERVAL '30 days'
        GROUP BY song_id
    ),
    max_play AS (
        SELECT MAX(plays_30) AS max_plays FROM play_counts
    )
    UPDATE songs s
    SET popularity =
        CASE
            WHEN pc.plays_30 IS NULL THEN 0   -- tidak ada play sama sekali -> 0
            WHEN mp.max_plays = 0 THEN 0      -- kalau kosong
            ELSE ROUND( (pc.plays_30::numeric / mp.max_plays::numeric) * 100 )
        END
    FROM play_counts pc, max_play mp
    WHERE s.song_id = pc.song_id;
END;
$$ LANGUAGE plpgsql;


SELECT cron.schedule(
    'recalculate_song_popularity_daily',
    '15 0 * * *',
    $$SELECT recalculate_all_song_popularity();$$
);
