-- data cleaning in sql
Select * from housingdata;
-- standardize the date format
select salesdate , convert(date, salesdate) from housingdata;

Alter table housingdata  add modifieddate date;
update  housingdata set modifieddate = convert(date, salesdate);

-- deleting unused column
alter table housingdata
Drop column salesdate;

---renaming a column name
-- does not work with rename within alter

alter table housingdata rename column modifieddate to salesdate;

-- sp_rename is stored procedures and we are using the stored procedures to rename a column in sql

EXEC sp_rename 'housingdata.modifieddate', 'salesdate', 'COLUMN';

Select ParcelID,PropertyAddress from housingdata order by ParcelID;

--populating the address to  null column based on same parcelid
--use of self join

Select a.ParcelID,a.PropertyAddress,  b.ParcelID,b.PropertyAddress from housingdata a Join housingdata b 
on a.ParcelID= b.ParcelID and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null;

Select a.ParcelID,a.PropertyAddress,  b.ParcelID,b.PropertyAddress , ISNULL(a.PropertyAddress, b.PropertyAddress)
from housingdata a Join housingdata b 
on a.ParcelID= b.ParcelID and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null;

Update a
set PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
from housingdata a Join housingdata b 
on a.ParcelID= b.ParcelID and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null;


---Breaking out address into individual column(address, city, state)

Select PropertyAddress from housingdata;

Select SUBSTRING(PropertyAddress , 1 , charindex(',', PropertyAddress)-1) as  addresspart1 from housingdata;
Select SUBSTRING(PropertyAddress, (charindex(',', PropertyAddress)+1), len(PropertyAddress) )as addresspart2 from housingdata;

alter table housingdata add addresspart1 varchar(50);
Update housingdata set addresspart1 = SUBSTRING(PropertyAddress , 1 , charindex(',', PropertyAddress)-1);
alter table housingdata add addresspart2 varchar(50);
Update housingdata set addresspart2 = SUBSTRING(PropertyAddress, (charindex(',', PropertyAddress)+1), len(PropertyAddress) );

--Breaking  owner address

 Select PARSENAME( replace(OwnerAddress, ',', '.'), 3) from housingdata;
 Select PARSENAME( replace(OwnerAddress, ',', '.'), 2) from housingdata;
 Select PARSENAME( replace(OwnerAddress, ',', '.'), 1) from housingdata;

 alter table housingdata add owneraddress1 varchar(50);
 alter table housingdata add owneraddress2 varchar(50);
 alter table housingdata add owneraddress3 varchar(50);

 Update housingdata set owneraddress1 =PARSENAME( replace(OwnerAddress, ',', '.'), 3);
 Update housingdata set owneraddress2 =PARSENAME( replace(OwnerAddress, ',', '.'), 2);
 Update housingdata set owneraddress3 =PARSENAME( replace(OwnerAddress, ',', '.'), 1);

  --select distinct(SoldAsVacant) from housingdata;

  Select SoldAsVacant, 
  case
  when SoldAsVacant ='Yes' then 'Y'
  when SoldAsVacant ='No' then 'N'
  end from housingdata;

  alter table housingdata add modifiedSoldAsVacant varchar(35);
  select SoldASVacant, modifiedSoldAsVacant from housingdata where SoldAsVacant='Yes';
  update housingdata set modifiedSoldAsVacant = 
  case
  when SoldAsVacant ='Yes' then 'Y'
  when SoldAsVacant ='No' then 'N'
  else SoldAsVacant
  end ;


  ---Removing duplicates

  With rownumcte as( Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 salesDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) as row_num from housingdata )
delete  from rownumcte where row_num >1;







