select*
from ProjectPortfolio1.[dbo].[Real_Estate]

--1. CHANGED DATE FORMAT
select SaleDateConverted, Convert (Date, SaleDate)
from ProjectPortfolio1.[dbo].[Real_Estate]

Alter Table Real_Estate
Add SaleDateConverted Date; 

Update Real_Estate 
Set SaleDateConverted = Convert (Date, SaleDate)



--2. Property Address Got Populated
select * 
from ProjectPortfolio1.[dbo].[Real_Estate]
order by ParcelID

select x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, ISNULL(x.PropertyAddress,y.PropertyAddress)
from ProjectPortfolio1.[dbo].[Real_Estate] x
   JOIN ProjectPortfolio1.[dbo].[Real_Estate] y
    ON x.ParcelID = y.ParcelID
	AND x.[UniqueID ] <> y.[UniqueID ]
	where x.PropertyAddress is null

Update x
Set PropertyAddress = ISNULL(x.PropertyAddress,y.PropertyAddress)
from ProjectPortfolio1.[dbo].[Real_Estate] x
   JOIN ProjectPortfolio1.[dbo].[Real_Estate] y
    ON x.ParcelID = y.ParcelID
	AND x.[UniqueID ] <> y.[UniqueID ]
	where x.PropertyAddress is null



--3. Splitted the Address into columns of Address, City & State
select PropertyAddress
from ProjectPortfolio1.[dbo].[Real_Estate]

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
from ProjectPortfolio1.[dbo].[Real_Estate]

Alter Table Real_Estate
Add PropertySplitAddress Nvarchar(255); 

Update Real_Estate 
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table Real_Estate
Add PropertySplitCity Nvarchar(255); 

Update Real_Estate 
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

select*
from ProjectPortfolio1.[dbo].[Real_Estate]

---USED PARSENAME TO SPLIT THE ADDRESS
select OwnerAddress
from ProjectPortfolio1.[dbo].[Real_Estate]

select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from ProjectPortfolio1.[dbo].[Real_Estate]


Alter Table Real_Estate
Add OwnerSplitAddress Nvarchar(255); 

Update Real_Estate 
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

Alter Table Real_Estate
Add OwnerSplitCity Nvarchar(255); 

Update Real_Estate 
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

Alter Table Real_Estate
Add OwnerSplitState Nvarchar(255); 

Update Real_Estate 
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
select*
from ProjectPortfolio1.[dbo].[Real_Estate]






---4.Change Y and N to YES and NO in "Sold as Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from ProjectPortfolio1.[dbo].[Real_Estate]
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
from ProjectPortfolio1.[dbo].[Real_Estate]

UPDATE Real_Estate
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END


---5.DELETING DUPLICATE
WITH RowNumCTE AS(
Select*, 
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				   UniqueID
				   )row_num
				    
From ProjectPortfolio1.[dbo].[Real_Estate]
)
DELETE 
from RowNumCTE
WHERE row_num > 1


---REMOVING UNUSED COLUMNS
Select*
from ProjectPortfolio1.[dbo].[Real_Estate]

ALTER TABLE ProjectPortfolio1.[dbo].[Real_Estate]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE ProjectPortfolio1.[dbo].[Real_Estate]
DROP COLUMN SaleDate















