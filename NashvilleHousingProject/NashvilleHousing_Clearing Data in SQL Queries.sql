/* 
  Project: Clearing Data in SQL Queries
*/

SELECT *
  FROM PortofolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------------------
-- Standarize Date Format
SELECT SaleDate, SaleDateConverted, CONVERT(Date,SaleDate)
  FROM PortofolioProject..NashvilleHousing

UPDATE PortofolioProject..NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE PortofolioProject..NashvilleHousing
ADD SaleDateConverted Date

UPDATE PortofolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address data
SELECT *
FROM PortofolioProject..NashvilleHousing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortofolioProject..NashvilleHousing a
JOIN PortofolioProject..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortofolioProject..NashvilleHousing a
JOIN PortofolioProject..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into individual columns (Address, city, state):
-- A. Using SUBSTRING
SELECT PropertyAddress, 
    SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) - 1) AS Address, 
    SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM PortofolioProject..NashvilleHousing

SELECT PropertyAddress,
    PARSENAME(PropertyAddress, 4)
FROM PortofolioProject..NashvilleHousing

/* We can't separarte 2 values into one column, so we need to add new column: */
-- 1) PropertySplitAddress:
ALTER TABLE PortofolioProject..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE PortofolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) - 1)

-- 2) PropertySplitCity :
ALTER TABLE PortofolioProject..NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE PortofolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

-- B. Using PARSENAME => work kinda like SUBSTRING, but start from the back
SELECT OwnerAddress,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortofolioProject..NashvilleHousing

ALTER TABLE PortofolioProject..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE PortofolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortofolioProject..NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE PortofolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE PortofolioProject..NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE PortofolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--------------------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to "Yes" and "No" in "SoldAsVacant"
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortofolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END
FROM PortofolioProject..NashvilleHousing

UPDATE PortofolioProject..NashvilleHousing
SET SoldAsVacant = CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END


--------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates: Best Practice => Don't change the original Dataset. Use temp table
WITH RowNumCTE AS (
SELECT *,
  ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
                 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
    ORDER BY UniqueID
  ) row_num
FROM PortofolioProject..NashvilleHousing
)
SELECT *
FROM RowNumCTE


------------------------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns
ALTER TABLE PortofolioProject..NashvilleHousing
DROP COLUMN IF EXISTS OwnerAddress, PropertyAddress, TaxDistrict, SaleDate

SELECT * FROM PortofolioProject..NashvilleHousing