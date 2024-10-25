use master;
create database SQLwithTDI
	on(
		name = SQLwithTDI_data,
		filename = '----------',
		size = 10MB,
		maxsize = 20MB,
		filegrowth = 1MB)
	log on (
		name = SQLwithTDI_log,
		filename = '------------',
		size = 10MB,
		maxsize = 20MB,
		filegrowth = 1MB)
	go

use SQLwithTDI;



select 
	Title,
	AuthorName 
from Authors as a inner join Books as b 
on a.AuthorID = b.AuthorID;



select Title, Genre, AuthorName 
from Books as b full outer join Authors as a 
on b.AuthorID = a.AuthorID;

select 
	Title, 
	round(Price,2) as Price 
from Books
where Genre = 'fantasy'

select 
	Title,
	Genre 
from Books
where Price > 15

--Outer Join

select 
	Title,
	case 
		when AuthorName is null then 'Unknown' 
		else AuthorName end as AutherName ,
	case 
		when Price is null then 'Price not available' 
		else round(Price,2) end as Price 
from Authors as a full outer join Books as b 
on a.AuthorID = b.AuthorID;



select 
	case 
		when AuthorName is null then 'Unknown' 
		else AuthorName end as AutherName ,
	case 
		when count(BookID) = 0 then 'No books written' 
		else count(BookID) end as TotalBooks 
from Authors as a full outer join Books as b 
on a.AuthorID = b.AuthorID
Group by AuthorName;




select * from 
	Products as p full outer join OrderDetails as od 
	on p.ProductID = od.ProductID ;

select c.name as CutomerName ,
	case when sum(o.TotalAmount) is null then 0
		 else sum(o.TotalAmount) end as TotalAmount
from Customers as c full outer join Orders as o
		on c.CustomerID = o.CustomerID
Group by c.name ;


select * from 
	Products as p full outer join OrderDetails as od 
	on p.ProductID = od.ProductID ;


select ProductName,
	case when sum(Quantity) is null then 0
		 else sum(Quantity) end as Quantity
from Products as p full outer join OrderDetails as od
		on p.ProductID = od.ProductID
Group by ProductName ;

select * from Products as p full outer join OrderDetails as od
		on p.ProductID = od.ProductID;