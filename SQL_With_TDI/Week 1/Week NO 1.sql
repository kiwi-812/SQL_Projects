use TDI;

 select * from locations;

 select country , population from locations;

 select region from locations where population > 500000;

 select region from locations where density < 50;

 select country from locations where region = 'Canterbury';

 select region , population from locations order by population desc ;

 select * from locations order by region asc ;

 select region , population , density from locations where population > 500000 order by density desc;

 select country , sum (population) as population from locations group by country ;

 go;