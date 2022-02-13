DROP DATABASE IF EXISTS E_Commerce;
CREATE DATABASE E_Commerce;
USE E_Commerce;

drop table if exists supplier;
create table supplier (
	SUPP_ID int primary key,
	SUPP_NAME varchar(20),
	SUPP_CITY varchar(20),
	SUPP_PHONE varchar(11)
);

drop table if exists customer;
create table customer (
	CUS_ID int primary key,
    CUS_NAME varchar(20),
    CUS_PHONE varchar(11),
    CUS_CITY varchar(20),
    CUS_GENDER varchar(10)
);

drop table if exists category;
create table category (
	CAT_ID int primary key,
    CAT_NAME varchar(20)
);

drop table if exists product;
create table product (
	PRO_ID int primary key,
    PRO_NAME varchar(20),
    PRO_DESC varchar(50),
    CAT_ID int,
    foreign key (CAT_ID) references category(CAT_ID)
);

drop table if exists product_details;
create table product_details (
	PROD_ID int primary key,
    PRO_ID int,
    SUPP_ID int,
    PRICE INT,
    foreign key (PRO_ID) references product(PRO_ID),
    foreign key (SUPP_ID) references supplier(SUPP_ID)
);

drop table if exists orders;
create table orders (
	ORD_ID int primary key,
    ORD_AMOUNT int,
    ORD_DATE date,
    CUS_ID int,
    PROD_ID int,
    foreign key (CUS_ID) references customer(CUS_ID),
    foreign key (PROD_ID) references product_details(PROD_ID)
);

drop table if exists rating;
create table rating (
	RAT_ID int primary key,
    CUS_ID int,
    SUPP_ID int,
    RAT_RATSTARS int,
    foreign key (CUS_ID) references customer(CUS_ID),
    foreign key (SUPP_ID) references supplier(SUPP_ID)
);

insert into supplier values(1,"Rajesh Retails","Delhi",'1234567890');
insert into supplier values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into supplier values(3,"Knome products","Banglore",'9785462315');
insert into supplier values(4,"Bansal Retails","Kochi",'8975463285');
insert into supplier values(5,"Mittal Ltd.","Lucknow",'7898456532');

INSERT INTO CUSTOMER VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO CUSTOMER VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO CUSTOMER VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO CUSTOMER VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO CUSTOMER VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');

INSERT INTO CATEGORY VALUES( 1,"BOOKS");
INSERT INTO CATEGORY VALUES(2,"GAMES");
INSERT INTO CATEGORY VALUES(3,"GROCERIES");
INSERT INTO CATEGORY VALUES (4,"ELECTRONICS");
INSERT INTO CATEGORY VALUES(5,"CLOTHES");

INSERT INTO PRODUCT VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO PRODUCT VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO PRODUCT VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO PRODUCT VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO PRODUCT VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);

INSERT INTO product_details VALUES(1,1,2,1500);
INSERT INTO product_details VALUES(2,3,5,30000);
INSERT INTO product_details VALUES(3,5,1,3000);
INSERT INTO product_details VALUES(4,2,3,2500);
INSERT INTO product_details VALUES(5,4,1,1000);

INSERT INTO orders VALUES (50,2000,"2021-10-06",2,1);
INSERT INTO orders VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO orders VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO orders VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO orders VALUES(30,3500,"2021-08-16",4,3);

INSERT INTO RATING VALUES(1,2,2,4);
INSERT INTO RATING VALUES(2,3,4,3);
INSERT INTO RATING VALUES(3,5,1,5);
INSERT INTO RATING VALUES(4,1,3,2);
INSERT INTO RATING VALUES(5,4,5,4);

#3)	Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
select count(customer.cus_id) as count, cus_gender from customer inner join orders on customer.cus_id = orders.cus_id where orders.ord_amount >= 3000 group by cus_gender;

#4)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.
select orders.*, product.PRO_NAME from orders, product, product_details where orders.cus_id = 2 and product.pro_id = product_details.pro_id and orders.prod_id = product_details.prod_id;

#5)	Display the Supplier details who can supply more than one product.
select supplier.*, No_of_products from supplier, 
(select count(pro_id) as No_of_products, supp_id from product_details group by supp_id) as N where supplier.supp_id = N.supp_id and No_of_products > 1;

#6)	Find the category of the product whose order amount is minimum.
select * from orders natural join product_details natural join product natural join category having min(ord_amount);

#7)	Display the Id and Name of the Product ordered after “2021-10-05”.
select product.pro_id, product.pro_name from product, product_details as pd, orders as o where o.prod_id = pd.prod_id and pd.pro_id = product.pro_id and o.ord_date > "2021-10-05";

#8)	Display customer name and gender whose names start or end with character 'A'.
select cus_name, cus_gender from customer where cus_name like 'A%' or cus_name like '%A';

/*9) Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like 
if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.*/
delimiter $$
use e_commerce $$
create procedure supplier_ratings()
begin
select *, 
case
	when rat_ratstars > 4 then "Genuine Supplier"
	when rat_ratstars > 2 then "Average Supplier"
    else "Supplier should not be considered."
end as Rat_Verdict
from rating;
end $$

call supplier_ratings();