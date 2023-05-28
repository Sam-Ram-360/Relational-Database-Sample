/*1.Basic stats on customers per city for a specific time period*/
select b.branch_city City, count(distinct o.customer_id) Number_of_customers
from orders o, branch b
where b.branch_id = o.branch_id
  and o.order_date between '2022-09-01' and '2022-10-31'
group by b.branch_city
  order by Number_of_customers desc;


/*2.All products with description and prices*/
select p.Product_Name NameOfProduct,p.Product_Size Size ,p.Product_Color Color,
       p.Product_Description Description ,p.Product_Composition Composition,
       p.Product_Inventory Inventory, p.Product_Price Price, g.Category_Name
from product p, Categories g
where g.category_id = p.category_id;


/*3.Order record and delivery details.*/
select distinct o.Order_no,
       CASE WHEN o.Order_Is_Online = 'T' THEN 'Yes' ELSE 'No' END AS Is_Online ,
       o.Order_Date,o.Order_Time,
       o.Order_Status delivery, o.Transaction_Status
from orders o
where random() < 0.3;


/*4.Report of product availability and their location*/
select  p.Product_Name,b.branch_name, pb.pro_bra_Inventory  Inventory
from Product_Branch pb, branch b, product p
where pb.branch_id = b.branch_id
  and pb.Product_ID = p.Product_ID
  and random() < 0.1;



/*5.Monthly income generated per city/location*/
select concat(to_char(o.order_date,'yyyy'),'-',to_char(o.order_date,'Mon')) Year_Month ,
       b.branch_name,sum(s.Order_Quantity*s.Unit_Price) city_income
from branch b,orders o,Sales s
where b.branch_id = o.branch_id
  and o.order_id = s.order_id
group by b.branch_name, Year_Month
order by city_income desc;


/*Total Amount per order */
select o.Order_no Order_number,
      concat(c.customer_fname,'',c.customer_lname) Customer_Fullname,
      sum(s.Order_Quantity*s.Unit_Price) total_Amount
from Orders o ,Sales s , customer c
where o.order_id = s.order_id
  and o.customer_id = c.customer_id
  and (o.Transaction_Status <> 'Refunded' or o.Order_Status <> 'Canceled')
group by Order_number,Customer_Fullname
order by Total_amount desc;


/*Customer_point*/
select o.customer_id,concat(c.customer_fname,'',c.customer_lname) Customer_Fullname,
       round(sum(s.Unit_Price*s.Order_Quantity)/10,0) Order_Point
from orders o, Sales s ,customer c
where s.order_id = o.Order_ID and c.customer_id = o.customer_id
      and (o.Transaction_Status <> 'Refunded' or o.Order_Status <> 'Canceled')

group by o.customer_id,Customer_Fullname
order by Order_Point desc;



/*8.Customers who have an online account but have not purchased anything online*/
/*we can send them promotions to make them active buyers*/

Select bb.customer_id,bb.Customer_fName,a.Customer_Email
from account_info a, (
  SELECT distinct c.customer_id ,c.Customer_fName
  FROM Customer c
  WHERE EXISTS (
      SELECT 1
      FROM orders o
      WHERE o.customer_id = c.customer_id
          AND o.Order_Is_Online = 'F'
  ) AND NOT EXISTS (
      SELECT 1
      FROM orders o
      WHERE o.customer_id = c.customer_id
          AND o.Order_Is_Online = 'T'
  )
) bb
where bb.customer_id = a.customer_id;




/*9.	Number of cashier and sales assistant in each branch*/
select b.Branch_Name Branch, e.employee_job job,
       count(distinct sh.employee_id) "number of employees"
from shift sh,branch b,employee e
where b.branch_id = sh.branch_id
  and sh.employee_id = e.employee_id
  and shift_end_date = '9999-12-31'
group by Branch,job;


/*10.	Manager of branches*/
select concat(m.Employee_fName,'',m.Employee_lName) employee_Fullname ,
       m.manager_branch "Branch manager",
       ( select distinct concat(m.Employee_fName,'',m.Employee_lName)
                from manager m
              where m.employee_id = m.Line_Manager_ID) "manager of managers"
from manager m;
