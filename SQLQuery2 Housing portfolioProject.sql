--cleaning data in SQL Queries

select *
from PortfolioProject..NashvilleHousing
--------------------------------------------------------------------------------

--Standardize Date Format--

Select SaleDate--, convert (date,saledate) as SaleDate
from PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing set SaleDate = convert (date,saledate)
--adding new column
alter table portfolioproject..nashvillehousing
Add SaleDateConverted Date;
--inserting data
update portfolioproject..nashvillehousing
set SaleDateConverted = convert (Date,SaleDate)

select saledateconverted
from PortfolioProject..NashvilleHousing
----------------------------------------------------------------------------------------------

--Populate Property Address data

Select * 
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null 
order by ParcelID

select a.parcelid, a.PropertyAddress, b.ParcelID, b.PropertyAddress
, isnull( a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress) --OR isnull(a.PropertyAddress, No_Address)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
-------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Adress,City, Satet)

-----------using substring----------
select PropertyAddress, SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress) -1) as Address
, SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress)) as City
from PortfolioProject..NashvilleHousing

--adding 2 new columns
alter table portfolioproject..nashvillehousing
Add Property_Address Nvarchar(255);
alter table portfolioproject..nashvillehousing
Add Property_City Nvarchar(255);

--inserting data
update portfolioproject..nashvillehousing
set Property_Address =  SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress) -1)
update portfolioproject..nashvillehousing
set Property_City = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress))

-----------using parsename----------
select OwnerAddress
from PortfolioProject..NashvilleHousing

Select parsename (replace (OwnerAddress, ',' , '.' ), 3)
, parsename (replace (OwnerAddress, ',' , '.' ), 2)
, parsename (replace (OwnerAddress, ',' , '.' ), 1)
from portfolioproject..nashvillehousing

--adding Columns
alter table portfolioproject..nashvillehousing
Add Owner_Address Nvarchar(255);
alter table portfolioproject..nashvillehousing
Add Owner_city Nvarchar(255);
alter table portfolioproject..nashvillehousing
Add Owner_State Nvarchar(255);

--Inserting Data
update portfolioproject..nashvillehousing
set Owner_Address =  parsename (replace (OwnerAddress, ',' , '.' ), 3)
update portfolioproject..nashvillehousing
set Owner_City = parsename (replace (OwnerAddress, ',' , '.' ), 2)
update portfolioproject..nashvillehousing
set Owner_State =  parsename (replace (OwnerAddress, ',' , '.' ), 1)
----------------------------------------------------------------------------------

--Change Y and N to Yes and No in 'Sold as vacant'field

select distinct (soldasvacant), count(soldasvacant)
from PortfolioProject..NashvilleHousing
group by soldasvacant
order by 2

select SoldAsVacant
, CASE When soldasvacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
	 end
from PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
set SoldAsVacant = 
CASE When soldasvacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
	 end
---------------------------------------------------------------------------------------------------

--Remove Duplicates

with RowNumCTE AS(
select *,
      ROW_NUMBER() over (
	  partition by parcelID,
	               Propertyaddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   order by uniqueID) AS Row_num
From PortfolioProject..NashvilleHousing
--Order by ParcelID
)
--delet From RowNumCTE Where ROW_NUM >1
select *
from RowNumCTE 
Where ROW_NUM > 1
Order by PropertyAddress
-----------------------------------------------------------------------------------------------------

--Delete Unused Columns

alter table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, propertyaddress, taxdistrict

alter table PortfolioProject..NashvilleHousing
Drop Column SaleDate

select *
from PortfolioProject..NashvilleHousing
