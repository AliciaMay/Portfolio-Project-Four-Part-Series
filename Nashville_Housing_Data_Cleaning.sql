-- Nashville Housing Data Exploration
-- Skills used: Joins, CTEs, Windows Functions, Converting Data Types, Column Modifications

-- Removed 3 rows from .csv due to errors uploading


-- Standardize date format and update table

SELECT  
  sale_date,
  FORMAT_DATE('%F', PARSE_DATE('%B %e, %Y', sale_date))
FROM `project-21793.Nashville_Housing_Data.housing_data`;

UPDATE 
  Nashville_Housing_Data.housing_data
SET sale_date =  FORMAT_DATE('%F', PARSE_DATE('%B %e, %Y', sale_date))
WHERE true;


-- Populate property address data

SELECT *
FROM `project-21793.Nashville_Housing_Data.housing_data`
WHERE property_address is NULL
ORDER BY parcel_id;

SELECT 
  a.parcel_id,
  a.property_address AS a,
  b.parcel_id,
  b.property_address AS b,
  IFNULL(a.property_address,b.property_address)
FROM `project-21793.Nashville_Housing_Data.housing_data` a 
JOIN `project-21793.Nashville_Housing_Data.housing_data` b 
  ON a.parcel_id = b.parcel_id
  AND a.unique_id <> b.unique_id
WHERE a.property_address is NULL;

UPDATE
  `project-21793.Nashville_Housing_Data.housing_data`
SET
  property_address = IFNULL(a.property_address,b.property_address)
FROM `project-21793.Nashville_Housing_Data.housing_data` a
JOIN `project-21793.Nashville_Housing_Data.housing_data` b
  ON a.parcel_id = b.parcel_id
  AND a.unique_id <> b.unique_id
WHERE a.property_address IS NULL;


-- Breaking out property address into individual columns (address, city)

SELECT
  property_address
FROM `project-21793.Nashville_Housing_Data.housing_data`;

SELECT 
  SPLIT(property_address, ",")[OFFSET(0)] property_address,
  SPLIT(property_address, ",")[OFFSET(1)] city
FROM `project-21793.Nashville_Housing_Data.housing_data`;

ALTER TABLE `project-21793.Nashville_Housing_Data.housing_data`
ADD COLUMN property_split_address STRING;

UPDATE `project-21793.Nashville_Housing_Data.housing_data`
SET property_split_address = SPLIT(property_address, ",")[OFFSET(0)]
WHERE TRUE;

ALTER TABLE `project-21793.Nashville_Housing_Data.housing_data`
ADD COLUMN property_split_city STRING;

UPDATE `project-21793.Nashville_Housing_Data.housing_data`
SET property_split_city = SPLIT(property_address, ",")[OFFSET(1)]
WHERE TRUE;


-- Separate the owner address into individual columns (address, city, state)

SELECT owner_address
FROM `project-21793.Nashville_Housing_Data.housing_data`;

SELECT 
  SPLIT(owner_address, ",")[OFFSET(0)] property_address,
  SPLIT(owner_address, ",")[OFFSET(1)] city,
  SPLIT(owner_address, ",")[OFFSET(2)] state
FROM `project-21793.Nashville_Housing_Data.housing_data`;

ALTER TABLE `project-21793.Nashville_Housing_Data.housing_data`
ADD COLUMN owner_split_address STRING;

UPDATE `project-21793.Nashville_Housing_Data.housing_data`
SET owner_split_address = SPLIT(owner_address, ",")[OFFSET(0)]
WHERE TRUE;

ALTER TABLE `project-21793.Nashville_Housing_Data.housing_data`
ADD COLUMN owner_split_city STRING;

UPDATE `project-21793.Nashville_Housing_Data.housing_data`
SET owner_split_city = SPLIT(owner_address, ",")[OFFSET(1)]
WHERE TRUE;

ALTER TABLE `project-21793.Nashville_Housing_Data.housing_data`
ADD COLUMN owner_split_state STRING;

UPDATE `project-21793.Nashville_Housing_Data.housing_data`
SET owner_split_state = SPLIT(owner_address, ",")[OFFSET(2)]
WHERE TRUE;


-- Verify changes

SELECT *
FROM `project-21793.Nashville_Housing_Data.housing_data`;


-- Removing duplicate rows

WITH RowNumCTE AS (
  SELECT *,
        ROW_NUMBER() OVER (
          PARTITION BY parcel_id,
                      property_address,
                      sale_price,
                      sale_date,
                      legal_reference
                      ORDER BY
                          unique_id
        ) row_num 
FROM `project-21793.Nashville_Housing_Data.housing_data`
)
SELECT *
FROM RowNumCTE
WHERE row_num >1
ORDER BY property_address;

-- 103 rows populated


-- Delete 103 duplicate rows using the statement below

CREATE OR REPLACE TABLE `project-21793.Nashville_Housing_Data.housing_data` AS
SELECT * EXCEPT(row_num)
FROM (
  SELECT *,
        ROW_NUMBER() OVER (
          PARTITION BY parcel_id,
                      property_address,
                      sale_price,
                      sale_date,
                      legal_reference
                      ORDER BY
                          unique_id
        ) row_num 
FROM `project-21793.Nashville_Housing_Data.housing_data`
)
WHERE row_num = 1;


-- Veiw table, 56371 rows populated

SELECT *
FROM `project-21793.Nashville_Housing_Data.housing_data`;


-- Verify changes were made by rerunning the statement below

WITH RowNumCTE AS (
  SELECT *,
        ROW_NUMBER() OVER (
          PARTITION BY parcel_id,
                      property_address,
                      sale_price,
                      sale_date,
                      legal_reference
                      ORDER BY
                          unique_id
        ) row_num 
FROM `project-21793.Nashville_Housing_Data.housing_data`
)
SELECT *
FROM RowNumCTE
WHERE row_num >1
ORDER BY property_address;

-- 0 duplicates polpulated, No data to display


-- Delete unused columns to demonstrate aptitude.

SELECT *
FROM `project-21793.Nashville_Housing_Data.housing_data`;

ALTER TABLE `project-21793.Nashville_Housing_Data.housing_data`
DROP COLUMN owner_address,
DROP COLUMN tax_district,
DROP COLUMN property_address,
DROP COLUMN sale_date;


-- Verify change was made

SELECT *
FROM `project-21793.Nashville_Housing_Data.housing_data`;
