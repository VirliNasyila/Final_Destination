CREATE OR REPLACE FUNCTION update_prerelease_daily()
RETURNS VOID AS $$
BEGIN
    UPDATE collections
    SET isPrerelease = FALSE
    WHERE isPrerelease = TRUE
      AND collection_release_date <= CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule(
    'update_prerelease_job_daily',
    '0 0 * * *',
    $$SELECT update_prerelease_daily();$$
);
