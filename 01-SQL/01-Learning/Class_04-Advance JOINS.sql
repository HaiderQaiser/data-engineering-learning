-- SELF JOIN
-- Har product ke saath same brand ke doosre products find karo.
SELECT 
	p.product_name,
	b.brand_id
FROM production.products AS p
INNER JOIN production.products AS b
ON p.brand_id = b.product_id;

SELECT 
    p.product_name AS product_1,
    b.product_name AS product_2
FROM production.products AS p
INNER JOIN production.products AS b
    ON p.brand_id = b.brand_id
WHERE p.product_id <> b.product_id;

ANTI LEFT/RIGHT JOIN ASSIGNMENT MN ADD KRO JOINS WALE