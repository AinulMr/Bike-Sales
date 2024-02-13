select * from sales

--Seperate the date column into year, month and day--

SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    DAY(Date) AS Day
FROM sales;

ALTER TABLE Sales
ADD Year_Sales INT,
	Month_Sales INT,
	Day_Sales INT;

UPDATE Sales
SET Year_Sales = YEAR(Date),
    Month_Sales = MONTH(Date),
    Day_Sales = DAY(Date);

-- Generate a group age

SELECT *,
    CASE
		WHEN Customer_Age < 18 THEN 'Under 18'
        WHEN Customer_Age BETWEEN 18 AND 24 THEN 'Young Adult'
        WHEN Customer_Age BETWEEN 25 AND 44 THEN 'Middle-aged'
        WHEN Customer_Age BETWEEN 45 AND 64 THEN 'Senior Adult'
        ELSE 'Elderly'
    END AS Age_Group
FROM 
    Sales

-- add new column Age_Group
ALTER TABLE Sales
ADD Age_Group VARCHAR(50);

-- fill the new column -- Update
UPDATE Sales
SET Age_Group = 
    CASE
        WHEN Customer_Age < 18 THEN 'Under 18'
        WHEN Customer_Age BETWEEN 18 AND 24 THEN 'Young Adult'
        WHEN Customer_Age BETWEEN 25 AND 44 THEN 'Middle-aged'
        WHEN Customer_Age BETWEEN 45 AND 64 THEN 'Senior Adult'
        ELSE 'Elderly'
    END;


--Sales Calculation--

WITH SalesCalucaltion as (
SELECT
    *,
    order_quantity * unit_cost as Total_Cost,
	order_quantity * unit_price as Total_Price
	
FROM
    Sales
)

SELECT
	*,Total_Price - Total_Cost as Profit
FROM
	SalesCalucaltion

--Update Table--

ALTER TABLE Sales
ADD Total_Cost INT,
	Total_Price INT,
	Profit INT

UPDATE Sales
SET Total_Cost = order_quantity * unit_cost,
	Total_Price = order_quantity * unit_price

UPDATE Sales
SET Profit = Total_Price - Total_Cost


select * from sales

--Discount 10% if Total price above 150--

WITH Discount_Price AS(
SELECT
	*,
	CASE
		WHEN Product_Category = 'Accessories' AND Total_Price > 150 THEN Total_Price * 0.1 
		ELSE 0
	END AS Discount_10Percent
FROM
	Sales
),

After_Discount AS (
SELECT
	*,
	Total_Price - Discount_10Percent AS Price_AfterDiscount
FROM
	Discount_Price
)

SELECT
	*,
	Price_AfterDiscount - Total_Cost AS Profit_AfterDiscount
FROM
	After_Discount


--Update Table--

ALTER TABLE Sales
ADD Discount_10Percent INT,
	Price_AfterDiscount INT,
	Profit_AfterDiscount INT

UPDATE Sales
SET Discount_10Percent =
	CASE
		WHEN Product_Category = 'Accessories' AND Total_Price > 150 THEN Total_Price * 0.1 
		ELSE 0
	END

UPDATE Sales
SET	Price_AfterDiscount = Total_Price - Discount_10Percent,
	Profit_AfterDiscount = Price_AfterDiscount - Total_Cost

UPDATE Sales
SET Profit_AfterDiscount = Price_AfterDiscount - Total_Cost

SELECT * FROM Sales