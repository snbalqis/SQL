# Portfolio Project - Data Cleaning using Microsoft SQL Server Management Studio
A portfolio project on data cleaning through SQL queries on SSMS using Nashville Housing dataset.

## The following are examples of SQL functions used:
|   |  |
| ------------- | ------------- |
| CONVERT()  | ISNULL()  |
| SUBSTRING()  | CHARINDEX()  |
| LEN() | PARSENAME() |
| REPLACE() | COUNT() |

A Common Table Expression (CTE) is also created — RowNumCTE, to help us remove duplicates.

## The following are steps taken to clean the dataset:
1) Standardizing date format of SaleDate column by converting to date data type
2) Replacing NULL values of property address by populating the data through matching the same ParcelID
3) Dividing the property and owner address into individual columns (Address, City, State)
4) Changing Y and N to Yes and No respectively in 'Sold as Vacant' field
5) Removing duplicates
6) Deleting unused columns
