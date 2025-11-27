CREATE OR REPLACE FUNCTION validate_prerelease_date()
RETURNS TRIGGER AS $$
BEGIN
    -- RULE 1: prerelease must be future
    IF NEW.isPrerelease = TRUE  -- Jika isPrerelease = TRUE
       AND NEW.collection_release_date <= CURRENT_DATE THEN   -- Tetapi tanggal rilis tidak di masa depan
        RAISE EXCEPTION
            'If isPrerelease = TRUE, then release_date (%s) must be in the future.',  -- Pesan error
            NEW.collection_release_date;
    END IF;

    -- RULE 2: NOT prerelease must be today or past
    IF NEW.isPrerelease = FALSE  -- Jika isPrerelease = FALSE
       AND NEW.collection_release_date > CURRENT_DATE THEN -- Tetapi tanggal rilis berada di masa depan
        RAISE EXCEPTION
            'If isPrerelease = FALSE, release_date (%s) cannot be in the future.',  -- Pesan error
            NEW.collection_release_date;   -- Menampilkan tanggal yang salah
    END IF;

    -- RULE 3: If release date is today → force prerelease = FALSE
    IF NEW.collection_release_date = CURRENT_DATE THEN   -- Jika tanggal rilis sama dengan hari ini
        NEW.isPrerelease := FALSE;  -- isPrerelease menjadi FALSE
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_prerelease_date
BEFORE INSERT OR UPDATE ON collections
FOR EACH ROW
EXECUTE FUNCTION validate_prerelease_date();

SELECT * FROM collections;

-- cek
-- Test prerelease VALID
INSERT INTO collections (
    collection_id,
    collection_title,
    collection_type,
    collection_cover,
    collection_release_date,
    isPrerelease
)
VALUES (
    50,
    'My New Album',
    'Album',                 
    'cover.jpg',
    CURRENT_DATE + 5,
    TRUE
);

-- Test prerelease INVALID
INSERT INTO collections VALUES (
    52,
    'Test Invalid',
    'Album',
    'cover.jpg',
    CURRENT_DATE,
    null,
    TRUE
);

-- erorr
INSERT INTO collections (
    collection_id,
    collection_title,
    collection_type,
    collection_cover,
    collection_release_date,
    isPrerelease
)
VALUES (
    80,
    'Rule 2 Test',
    'Album',
    'cover.jpg',
    CURRENT_DATE + 3,   -- tanggal MASA DEPAN (invalid)
    FALSE               -- isPrerelease FALSE
);