CREATE OR REPLACE FUNCTION delete_expired_tours()
RETURNS VOID AS $$
BEGIN
    DELETE FROM tours
    WHERE tour_date < CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule(
    'delete_expired_tours_daily',
    '5 0 * * *',
    $$SELECT delete_expired_tours();$$
);
