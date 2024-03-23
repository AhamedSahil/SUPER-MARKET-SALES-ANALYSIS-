create database supermarket_sales;
use supermarket_sales;
select * from supermarket_sales.supermarket_sales;
start transaction;
#Cleaning the data 
#changing the data types of date column 
update supermarket_sales.supermarket_sales set _date = str_to_date(_date,"%m/%d/%Y");
#coverted  invoice column into primary key 
ALTER TABLE supermarket_sales.supermarket_sales
CHANGE COLUMN `Invoice ID` `Invoice ID` VARCHAR(100) NOT NULL,
ADD PRIMARY KEY (`Invoice ID`);
#adding a new colunm as sentiment fro rating purpose
alter table supermarket_sales add column sentiment varchar(25) ;
select count(sentiment) from supermarket_sales where sentiment is null ;
alter table  supermarket_sales drop column sentiment;

start transaction;
savepoint sentiment_insertion;
update supermarket_sales set rating = round(rating);
update supermarket_sales set sentiment= case when rating between 0 and 4 then "negetive"
										when rating between 4 and 6 then "neutral"
                                        when rating between 6 and 8 then "Good"
                                        when rating between 8 and 11 then "very Good"
                                        end ;
rollback to savepoint sentiment_insertion;
select * from supermarket_sales.supermarket_sales;
commit;

#Finding the total sales with respect to product line 
select product_line,sum(quantity) as total_sell from supermarket_sales group by product_line order by total_sell desc;#Top selling product is Electronic accessories.


#finding the most profitable product with respect to product_line
select product_line,sum(gross_income) as total_profit from supermarket_sales group by product_line order by total_profit desc;#top profitable product is food and beverages.


#finding out the change in sells by their month respective to proudctline 
select _month,product_line,sum(total_sales) over(partition by product_line order by _month ) as profit_data from (select extract(month from _date) as _month,product_line,sum(gross_income) total_sales from supermarket_sales  Group by _month,product_line order by total_sales ) as data_;

#Finding the avg profit  with respective to proudctline
select product_line, avg(gross_income) as Avg_profit from supermarket_sales group by product_line;

#Finding the Top spending customer
select invoice_id,city,gender,product_line,total_price from supermarket_sales where total_price = (select max(total_price) from supermarket_sales);

#avg Buy Product per person  
select round(avg(quantity)) as avg_Buy_product_per_person from supermarket_sales;

#Top product selling City repective to product 
select City,product_line,sum(quantity) as total_selling_product from supermarket_sales group by city,product_line order by total_selling_product desc limit 1;

#Finding out sum of quantity by respictive City and branch irrespictive to productline 
select City,branch,sum(quantity) from supermarket_sales group by city,branch;

#Finding out the top most ratings
select sentiment,count(sentiment) as total_sentiment  from supermarket_sales group by sentiment order by total_sentiment desc;

#Finding out the Top 5  very good rating products
SELECT city,product_line,sentiment, MAX(rating) AS top_rating
FROM supermarket_sales
GROUP BY city,product_line,sentiment
ORDER BY top_rating DESC
LIMIT 5;














