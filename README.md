# <p align="center">SUPER MARKET SALES ANALYSIS!</p>
# <p align="center">![image](https://github.com/AhamedSahil/Project-1/assets/164605797/25231f93-6fdf-40c6-a2c0-3d49cdcb7241)</p>

This repository contains code and resources for analyzing sales data from a supermarket. The analysis is performed using Sql on  mysqlworkbech and Excel. The purpose of this project is to gain insights into sales trends, customer behavior.

**Tools:-** Excel,Mysql

[Datasets Used](https://www.kaggle.com/datasets/aungpyaeap/supermarket-sales)

[SQL Analysis (Code)](supermarket_sales_projects.sql)

[Ppt presentation](sql_prjct.pptx)

### Data preparation

- changing the data types of date column 

```mysql 
update supermarket_sales.supermarket_sales set _date = str_to_date(_date,"%m/%d/%Y");
```

- adding a new colunm as sentiment fro rating purpose

```mysql
alter table supermarket_sales add column sentiment varchar(25) ;select count(sentiment) from supermarket_sales where sentiment is null ;
```

- we have fill some categorical data like 'negetive' if rating between 0 to 4,'netural' when rating between 4 to 6,'Good' when rating between 6 to 8 and 'Very Good' when rating betweeen 8 to 11 in sentiment column with the help of  rating column
```mysql 
start transaction;
savepoint sentiment_insertion;update supermarket_sales set rating = round(rating);
update supermarket_sales set sentiment= case when rating between 0 and 4 then "negetive"
when rating between 4 and 6 then "neutral"                                        
when rating between 6 and 8 then "Good"                                        
when rating between 8 and 11 then "very Good"
end ;
```
Result:

![image](https://github.com/AhamedSahil/Project-1/assets/164605797/95b3e962-8e26-42d6-aaab-bc7aa2183484)
- coverted  invoice column into primary key
```mysql
ALTER TABLE supermarket_sales.supermarket_sales
CHANGE COLUMN `Invoice ID` `Invoice ID` VARCHAR(100) NOT NULL,
ADD PRIMARY KEY (`Invoice ID`);
```

### OBJECTIVE OF THE STUDY

- To visualize how explanatory variable i.e., Branch, Customer type, Gender, Product line and Payment type affect to study variable sales.

- To check Main and Interaction effect of explanatory Variable on sales.
 
- Fitting appropriate Time Series Model and analyzing study variable sales.

### Contents

- Sales Performance Analysis

- Average Profit Analysis

- Sentiment Analysis

- Quantity of products sold in each city /branch

- Top selling product

### The questions we have apply on our dataset

- Finding the total sales with respect to product line and the top selling product 
```mysql
select product_line,sum(quantity) as total_sell from supermarket_sales group by product_line order by total_sell desc;
```
Result:

![image](https://github.com/AhamedSahil/Project-1/assets/164605797/e384bbc0-b2f7-4d59-9dd6-52f8665bf8aa)
### <p align="center">Top Selling Product!</p>
![image](https://github.com/AhamedSahil/SUPER-MARKET-SALES-ANALYSIS-/assets/164605797/af14b34c-50cf-46e1-9bbc-204555840a89)


- finding the most profitable productline.
```mysql
select product_line,sum(gross_income) as total_profit from supermarket_sales group by product_line order by total_profit desc;#top profitable product is food and beverages.
```
Result:

![image](https://github.com/AhamedSahil/SUPER-MARKET-SALES-ANALYSIS-/assets/164605797/25cac7de-aef9-4cc8-9a27-34c2834ef034)

- finding out the change in sells by their month respective to proudctline
```mysql
select _month,product_line,sum(total_sales) over(partition by product_line order by _month ) as profit_data from (select extract(month from _date) as _month,product_line,sum(gross_income) total_sales from supermarket_sales  Group by _month,product_line order by total_sales ) as data_;
```
Result:

![image](https://github.com/AhamedSahil/SUPER-MARKET-SALES-ANALYSIS-/assets/164605797/5b3e1101-c907-40c7-a0d7-f58b0f001f99)

- Finding the avg profit  with respective to proudctline

```mysql
select product_line, avg(gross_income) as Avg_profit from supermarket_sales group by product_line;
```
Result:

![image](https://github.com/AhamedSahil/SUPER-MARKET-SALES-ANALYSIS-/assets/164605797/bbf6881f-c2a5-4f49-a16d-315308a65908)

- Finding out sum of quantity by respictive City and branch irrespictive to productline
```mysql
select City,branch,sum(quantity) from supermarket_sales group by city,branch;
```
Result:

![image](https://github.com/AhamedSahil/SUPER-MARKET-SALES-ANALYSIS-/assets/164605797/d68166ca-0b7d-4cac-9a1c-717e84d770ea)

- Finding out the top most ratings with respect to Sentiment
```mysql
select sentiment,count(sentiment) as total_sentiment  from supermarket_sales group by sentiment order by total_sentiment desc;
```
Result:

![image](https://github.com/AhamedSahil/SUPER-MARKET-SALES-ANALYSIS-/assets/164605797/9f4471cc-e748-4f2b-ac11-6a9b929ab190)

![image](https://github.com/AhamedSahil/SUPER-MARKET-SALES-ANALYSIS-/assets/164605797/205e1dfe-d1be-4813-b017-d0993a5d1ca5)


- Finding out the Top 5  very good rating products
```mysql
SELECT city,product_line,sentiment, MAX(rating) AS top_rating
FROM supermarket_sales
GROUP BY city,product_line,sentiment
ORDER BY top_rating DESC
LIMIT 5;
```
Result:

![image](https://github.com/AhamedSahil/SUPER-MARKET-SALES-ANALYSIS-/assets/164605797/f552bb87-2e07-4594-a9e4-0c508caa9ea7)






















