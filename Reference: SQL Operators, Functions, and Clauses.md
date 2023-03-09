### Partition By (from https://www.sqlshack.com/sql-partition-by-clause-overview/)
We use SQL PARTITION BY to divide the result set into partitions and perform computation on each subset of partitioned data.<br>
In the SQL GROUP BY clause, we can use a column in the select statement if it is used in Group By clause as well.<br>
It does not allow any column in the select clause that is not part of GROUP BY clause.<br>


| Group By | SQL PARTITION BY |
| ------- | ------- |
| We get a limited number of records using the Group By clause | We get all records in a table using the PARTITION BY clause. |
| It gives one row per group in result set. For example, we get a result for each group of CustomerCity in the GROUP BY clause. | It gives aggregated columns with each record in the specified table. |
|  | We have 15 records in the Orders table. In the query output of SQL PARTITION BY, we also get 15 rows along with Min, Max and average values. |


