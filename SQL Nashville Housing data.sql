SELECT *
FROM RamyaPortfolio..NashvilleHousingData

--Formatting date field

SELECT saledate1
FROM RamyaPortfolio..NashvilleHousingData

--This did not work
UPDATE RamyaPortfolio..NashvilleHousingData
SET saledate = convert(date, saledate)

--It worked
ALTER TABLE RamyaPortfolio..NashvilleHousingData
Add saledate1 Date;

UPDATE RamyaPortfolio..NashvilleHousingData
SET saledate1 = convert(date, saledate)

-------------------------------------------------------------

--Checking and updating property address fields

SELECT *
FROM RamyaPortfolio..NashvilleHousingData
--WHERE propertyaddress is null
ORDER BY 2

SELECT ram.ParcelID, ram.PropertyAddress, san.ParcelID, san.PropertyAddress, ISNULL(ram.propertyaddress, san.PropertyAddress)
FROM RamyaPortfolio..NashvilleHousingData ram
JOIN RamyaPortfolio..NashvilleHousingData san
	ON ram.ParcelID = san.ParcelID
	AND ram.[UniqueID ] <> san.[UniqueID ]
WHERE ram.PropertyAddress is null

UPDATE ram
SET PropertyAddress = ISNULL(ram.propertyaddress, san.PropertyAddress)
FROM RamyaPortfolio..NashvilleHousingData ram
JOIN RamyaPortfolio..NashvilleHousingData san
	ON ram.ParcelID = san.ParcelID
	AND ram.[UniqueID ] <> san.[UniqueID ]
WHERE ram.PropertyAddress is null

----------------------------------------------------------------------------------

--Splitting up the address into individual fields (Address, City, State)

SELECT PropertyAddress
FROM RamyaPortfolio..NashvilleHousingData

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address1
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address2

FROM RamyaPortfolio..NashvilleHousingData

ALTER TABLE RamyaPortfolio..NashvilleHousingData
Add PropertyAddress1 Nvarchar(200);

Update RamyaPortfolio..NashvilleHousingData
SET PropertyAddress1 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE RamyaPortfolio..NashvilleHousingData
Add PropertyCity1 Nvarchar(200);

Update RamyaPortfolio..NashvilleHousingData
SET PropertyCity1 = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM RamyaPortfolio..NashvilleHousingData

SELECT OwnerAddress
FROM RamyaPortfolio..NashvilleHousingData

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From RamyaPortfolio..NashvilleHousingData

ALTER TABLE RamyaPortfolio..NashvilleHousingData
Add OwnerAddress1 nvarchar(200);

UPDATE RamyaPortfolio..NashvilleHousingData
SET OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE RamyaPortfolio..NashvilleHousingData
Add OwnerCity1 nvarchar(200);

UPDATE RamyaPortfolio..NashvilleHousingData
SET OwnerCity1 = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE RamyaPortfolio..NashvilleHousingData
Add OwnerState1 nvarchar(200);

UPDATE RamyaPortfolio..NashvilleHousingData
SET OwnerState1 = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT * 
FROM RamyaPortfolio..NashvilleHousingData

-------------------------------------------------------------------------------

--Replace Yes and No with Y and N in 'soldasvacant' field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM RamyaPortfolio..NashvilleHousingData
GROUP by SoldAsVacant
ORDER by 2

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From RamyaPortfolio..NashvilleHousingData

Update RamyaPortfolio..NashvilleHousingData
SET 
SoldAsVacant = 
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-----------------------------------------------------------------------

--Remove Duplicates

WITH CTEforDuplicates AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
			UniqueID
				) duplicates

FROM RamyaPortfolio..NashvilleHousingData
)
SELECT *
FROM CTEforDuplicates
WHERE duplicates > 1
ORDER by PropertyAddress

SELECT *
FROM RamyaPortfolio..NashvilleHousingData

--------------------------------------------------------

--Delete unnecessary fields

SELECT *
FROM RamyaPortfolio..NashvilleHousingData

ALTER TABLE RamyaPortfolio..NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

