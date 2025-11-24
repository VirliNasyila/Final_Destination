-- trigger perubahan rating insert review, update review, delete review
CREATE TRIGGER trg_update_collection_rating
AFTER INSERT OR UPDATE OR DELETE
ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_collection_rating();

SELECT * FROM reviews;

-- cek
-- insert collection_rating
INSERT INTO reviews (review, rating, review_id, user_id, collection_id)
VALUES ('bagussss', 5, 1, 10, 1);

SELECT collection_rating FROM collections WHERE collection_id = 1;

-- update collection_rating nya
UPDATE reviews
SET rating = 3
WHERE review_id = 1;

-- delete review
DELETE FROM reviews WHERE review_id = 1;

