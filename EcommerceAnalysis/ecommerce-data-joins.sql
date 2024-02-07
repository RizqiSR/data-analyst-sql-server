USE eCommerceAnalysis

SELECT f.customer_key, COUNT(f.customer_key) as shopping_frequency, SUM(f.total_price) as total_spent
FROM fact_table f
JOIN customer_dim c
  ON f.customer_key = c.customer_key
GROUP BY f.customer_key
ORDER BY 3 DESC

SELECT customer_key, payment_key, time_key, item_key, store_key,
  COUNT(customer_key) OVER (PARTITION BY coustomer_key) as shopping_frequency,
  AVG(total_price) OVER (PARTITION BY time_key) as average_total_spent
FROM fact_table f
ORDER BY 1

SELECT customer_key, AVG(total_price)
FROM fact_table
GROUP BY customer_key;

--------------------------------------------------------------------------------------------------------------------------------------------
-- Question: Are there some duplicate data?
-- Answer: There are no duplicates in this dataset because all records have a unique coustomer
WITH RowNum_CTE AS (
SELECT *, 
  ROW_NUMBER() OVER (
    PARTITION BY payment_key,
                 coustomer_key,
                 time_key,
                 item_key,
                 store_key
    ORDER BY coustomer_key
  ) row_num
FROM fact_table
)

SELECT *
FROM RowNum_CTE
WHERE row_num > 1

--------------------------------------------------------------------------------------------------------------------------------------------
-- Standardize item_desc writting format
SELECT item_name, item_desc, REPLACE(item_desc, 'a. ', '') as edited_item_desc
FROM item_dim
WHERE item_desc LIKE 'a. %'

ALTER TABLE item_dim
ADD edited_item_desc NVARCHAR(255)

----------- Code BELOW THIS LINE Commented because the column already deleted (writing this after the final joins query ready) -----------
-- UPDATE item_dim
-- SET edited_item_desc = REPLACE(item_desc, 'a. ', '')

--------------------------------------------------------------------------------------------------------------------------------------------
-- -- Split edited_item_dim: first string (before space) will be the item_category, second string (after space 'till the end of the whole string) will be the item_spec
-- SELECT edited_item_desc,
--        SUBSTRING(edited_item_desc, 1, CHARINDEX(' ', edited_item_desc)) item_category,
--        SUBSTRING(edited_item_desc, CHARINDEX(' ', edited_item_desc) + 1, LEN(edited_item_desc)) item_specification
-- FROM item_dim

-- -- item_category column:
-- ALTER TABLE item_dim
-- ADD item_category NVARCHAR(255)

-- UPDATE item_dim
-- SET item_category = SUBSTRING(edited_item_desc,1, CHARINDEX(' ',edited_item_desc))

-- --item_specification column:
-- ALTER TABLE item_dim
-- ADD item_specification NVARCHAR(255)

-- UPDATE item_dim
-- SET item_specification = SUBSTRING(edited_item_desc,CHARINDEX(' ',edited_item_desc) + 1, LEN(edited_item_desc))

-- -- Populate the medicine item_category
-- SELECT item_key, item_name, edited_item_desc, item_category
-- FROM item_dim
-- WHERE edited_item_desc = 'Medicine'

-- UPDATE item_dim
-- SET item_category = 'Medicine'
-- WHERE edited_item_desc = 'Medicine'

----------- Code ABOVE THIS LINE Commented because the column already deleted (writing this after the final joins query ready) -----------

-- Hapus kolom edited_item_desc (yang format-nya masih berantakan):
ALTER TABLE item_dim
DROP COLUMN IF EXISTS edited_item_dim

--------------------------------------------------------------------------------------------------------------------------------------------
-- Edit & Clean the item_category & item_specification columns by removing leading/trailing spaces &  special characters
-- Now we have all columns populated and no NULL values in them :
SELECT item_category, item_specification,
CASE 
  WHEN item_specification = 'Cream' THEN 'Coffee Cream'
  WHEN item_specification = 'Ground' THEN 'Coffee Ground'
  WHEN item_specification = 'Hot Cocoa' THEN 'Coffee Hot Cocoa'
  WHEN item_specification = 'Supplies' THEN 'Kitchen Supplies'
  ELSE item_specification
END
FROM item_dim

UPDATE item_dim
SET item_specification = CASE 
  WHEN item_specification = 'Cream' THEN 'Coffee Cream'
  WHEN item_specification = 'Ground' THEN 'Coffee Ground'
  WHEN item_specification = 'Hot Cocoa' THEN 'Coffee Hot Cocoa'
  WHEN item_specification = 'Supplies' THEN 'Kitchen Supplies'
  ELSE item_specification
END

SELECT item_category, 
       TRIM(item_category) edited_1,
       item_specification, 
       TRIM(REPLACE(item_specification, '- ', '')) edited_2
FROM item_dim

UPDATE item_dim
SET item_category = TRIM(item_category)

UPDATE item_dim
SET item_specification = TRIM(REPLACE(item_specification, '- ', ''))

-- Drop the old item_desc colum & change the edited_item_desc to item_desc (as a new item_desc with cleaner value format)
ALTER TABLE item_dim
DROP COLUMN IF EXISTS item_desc

-- Change the column name at item_dim table: desc -> description
EXEC sp_rename 'item_dim.man_country', 'manufacturer_country';

-- Change the column name at fact_table table: coustumer_key -> customer_key
EXEC sp_rename 'fact_table.coustomer_key', 'customer_key';

-- Check the total of each item based on item_desc:
SELECT item_desc, COUNT(item_key)
FROM item_dim
GROUP BY item_desc
ORDER BY 2 DESC

--------------------------------------------------------------------------------------------------------------------------------------------
-- Get Columns: to identify
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='fact_table';

--------------------------------------------------------------------------------------------------------------------------------------------
-- Change the data type  of a specific column in an existing table
ALTER TABLE item_dim ALTER COLUMN store_key NVARCHAR(50)


--------------------------------------------------------------------------------------------------------------------------------------------
-- Data Checking: Check the suitability of calculations between query result data with SQL & Tableau
SELECT f.customer_key, c.name, COUNT(f.customer_key) shopping_frequency, SUM(f.total_price) total_spent
FROM fact_table f
LEFT JOIN customer_dim c
  ON  f.customer_key = c.customer_key
GROUP BY f.customer_key, c.name
ORDER BY 4 DESC

SELECT COUNT(customer_key)
FROM fact_table

SELECT c.customer_key, c.name, COUNT(*) as number_of_purchases, SUM(f.total_price) as total_spent
FROM fact_table f
JOIN customer_dim c ON f.customer_key = c.customer_key
WHERE c.name = 'pooja'
GROUP BY c.name, c.customer_key
ORDER BY 2 DESC;


--------------------------------------------------------------------------------------------------------------------------------------------
-- Query to join the final table for data visualization:
SELECT f.customer_key,
       c.name,
       t.date, t.day, t.month, t.year, t.hour, t.week, t.quarter,
       i.item_name, i.item_category, i.item_specification, i.manufacturer_country, i.supplier, f.quantity, i.unit_price, f.total_price,
       s.division, s.district,
       Trans.trans_type, Trans.bank_name
FROM fact_table f
LEFT JOIN customer_dim c ON f.customer_key = c.customer_key
LEFT JOIN item_dim i ON  f.item_key = i.item_key
LEFT JOIN Trans_dim Trans ON  f.payment_key=Trans.payment_key
LEFT JOIN time_dim t ON  f.time_key = t.time_key
LEFT JOIN store_dim s on f.store_key= s.store_Key