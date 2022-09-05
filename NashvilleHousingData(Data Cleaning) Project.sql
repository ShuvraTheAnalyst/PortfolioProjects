--Cleaning Data in SQL Queries

Select *
From [PortfolioProject ].dbo.NashvilleHousing

--Strandardize Date Format

Select saleDateConverted, CONVERT(Date, SaleDate)
From [PortfolioProject ].dbo.NashvilleHousing


Update [PortfolioProject ].dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [PortfolioProject ].dbo.NashvilleHousing
ADD SaleDateConverted Date;

Update [PortfolioProject ].dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Populate Property Address Data

Select *
From [PortfolioProject ].dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From [PortfolioProject ].dbo.NashvilleHousing a
JOIN [PortfolioProject ].dbo.NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


UPDATE a
SET PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
From [PortfolioProject ].dbo.NashvilleHousing a
JOIN [PortfolioProject ].dbo.NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into Individual Columns(Address,State,City)


Select PropertyAddress
From [PortfolioProject ].dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
  --CHARINDEX(',',PropertyAddress)

From [PortfolioProject ].dbo.NashvilleHousing

ALTER TABLE [PortfolioProject ].dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update [PortfolioProject ].dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE [PortfolioProject ].dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update [PortfolioProject ].dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select*

From [PortfolioProject ].dbo.NashvilleHousing



select OwnerAddress

From [PortfolioProject ].dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)

From [PortfolioProject ].dbo.NashvilleHousing




ALTER TABLE [PortfolioProject ].dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update [PortfolioProject ].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE [PortfolioProject ].dbo.NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update [PortfolioProject ].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE [PortfolioProject ].dbo.NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update [PortfolioProject ].dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


select *

From [PortfolioProject ].dbo.NashvilleHousing







-----Change Y and N to Yes and No in "SoldAsVacant" Column


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From [PortfolioProject ].dbo.NashvilleHousing
Group By SoldAsVacant
order by 2

Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN  'Yes'
       WHEN SoldAsVacant = 'N' THEN  'No'
	   ELSE SoldAsVacant
	   END

From [PortfolioProject ].dbo.NashvilleHousing


Update [PortfolioProject ].dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN  'Yes'
       WHEN SoldAsVacant = 'N' THEN  'No'
	   ELSE SoldAsVacant
	   END





----Remove Duplicates
With RowNumCTE As(
Select *,
     ROW_NUMBER() OVER(
	 Partition by ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				    UniqueID
					) row_num

From [PortfolioProject ].dbo.NashvilleHousing
)
Select*
From RowNumCTE
where row_num > 1
Order By PropertyAddress







Select*
From [PortfolioProject ].dbo.NashvilleHousing



-----Delete Unused Columns


Select*
From [PortfolioProject ].dbo.NashvilleHousing

ALTER TABLE [PortfolioProject ].dbo.NashvilleHousing
DROP COLUMN PropertyAddress,SaleDate,OwnerAddress,TaxDistrict