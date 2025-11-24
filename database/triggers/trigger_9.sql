
-- trigger
CREATE TRIGGER trg_update_collection_top3_genres
AFTER INSERT OR UPDATE ON collections_songs
FOR EACH ROW
EXECUTE FUNCTION update_collection_top3_genres();


SELECT * FROM collections_songs;
-- cek 
-- Update supaya trigger jalan
UPDATE collections_songs
SET nomor_track = nomor_track
WHERE collection_id = 1;

UPDATE collections_songs
SET nomor_track = nomor_track
WHERE collection_id = 2;

-- Lihat hasil top 3 genre
SELECT * FROM collection_top_3_genres
WHERE collection_id = 1;

SELECT * FROM collection_top_3_genres
WHERE collection_id = 2;

SELECT * FROM collection_top_3_genres;
