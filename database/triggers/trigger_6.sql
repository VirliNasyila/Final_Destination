-- FUNCTION: otomatis matikan prerelease saat tanggal rilis tiba
CREATE OR REPLACE FUNCTION prerelease_check_logic()
RETURNS TRIGGER AS $$
BEGIN
    -- Jika ini prerelease dan hari ini sudah sama dengan tanggal rilis
    IF NEW.isPrerelease = TRUE
       AND CURRENT_DATE = NEW.collection_release_date THEN

        NEW.isPrerelease := FALSE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER: aktif sebelum INSERT / UPDATE
CREATE TRIGGER trg_prerelease_check
BEFORE INSERT OR UPDATE ON collections
FOR EACH ROW
EXECUTE FUNCTION prerelease_check_logic();

-- -- cek
-- -- case insert data yg tanggal rilis nya hari ini
-- INSERT INTO collections (
--     collection_id, collection_title, collection_type,
--     collection_cover, collection_release_date,
--     collection_rating, isPrerelease
-- )
-- VALUES (
--     999, 'Test Prerelease', 'Album',
--     NULL, CURRENT_DATE, NULL, TRUE
-- );

-- SELECT collection_id, isPrerelease, collection_release_date
-- FROM collections
-- WHERE collection_id = 999;


-- -- case insert data tanggal rilis nya besok
-- INSERT INTO collections (
--     collection_id, collection_title, collection_type,
--     collection_cover, collection_release_date,
--     collection_rating, isPrerelease
-- )
-- VALUES (
--     1000, 'Test Tomorrow', 'Album',
--     NULL, CURRENT_DATE + 1, NULL, TRUE
-- );

-- SELECT collection_id, isPrerelease, collection_release_date
-- FROM collections
-- WHERE collection_id = 1000;

-- -- update data pada hari rilis
-- UPDATE collections
-- SET collection_release_date = CURRENT_DATE,
--     isPrerelease = true
-- WHERE collection_id = 1000;

-- SELECT collection_id, isPrerelease, collection_release_date
-- FROM collections
-- WHERE collection_id = 1000;
