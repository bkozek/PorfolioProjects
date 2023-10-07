

--Cleaning Data in SQL Queries

select SaleDate,Convert(Date,Saledate) from Housing

select  * from Housing
where PropertyAddress is null
--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
select SaleDate,Convert(Date,Saledate) from Housing


ALTER TABLE Housing
Add SalesDateNewFormat Date

UPDATE Housing
SET SalesDateNewFormat = Convert(Date,Saledate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select a.[UniqueID ],a.ParcelID,a.PropertyAddress , b.[UniqueID ],b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from Housing a
join Housing b
ON a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Housing a
join Housing b
ON a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress,
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1),
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))
from Housing

ALTER TABLE Housing
Add PropertySplitAddress nvarchar(255)

ALTER TABLE Housing
Add PropertySplitCity nvarchar(255)

UPDATE Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

UPDATE Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))



select 
PARSENAME(replace(OwnerAddress,',','.'),3) as street,
PARSENAME(replace(OwnerAddress,',','.'),2) as city,
PARSENAME(replace(OwnerAddress,',','.'),1) as state

from Housing

select *
from Housing

select OwnerAddress
from Housing

ALTER TABLE Housing
Add OwnerSplitAddress nvarchar(255)

UPDATE Housing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)



ALTER TABLE Housing
Add OwnerSplitCity nvarchar(255)

UPDATE Housing
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)



ALTER TABLE Housing
Add OwnerSplitState nvarchar(255)

UPDATE Housing
SET OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

SELECT replace(OwnerAddress,',','.') from Housing
--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select SoldAsVacant,
	CASE

	WHEN SoldAsVacant='N' THEN 'No'
	WHEN SoldAsVacant='Y' THEN 'Yes'
	Else SoldAsVacant
	END
from Housing

ALTER TABLE Housing
Add NewSold nvarchar(255)

UPDATE Housing
SET SoldAsVacant = CASE

	WHEN SoldAsVacant='N' THEN 'No'
	WHEN SoldAsVacant='Y' THEN 'Yes'
	Else SoldAsVacant
	END
from Housing



select distinct(SoldAsVacant),count(SoldAsVacant) 
from Housing
group by SoldAsVacant

select *
from Housing

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH CTE_row_num
as(
select *,
	ROW_NUMBER() OVER(Partition by
						ParcelID,
						PropertyAddress,
						SalePrice,
						SaleDate,
						LegalReference
						ORDER BY 
							UniqueID) as ro_num
from Housing

)

Select * from CTE_row_num
where ro_num >1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select* from Housing


ALTER TABLE housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE housing
DROP COLUMN SaleDate












