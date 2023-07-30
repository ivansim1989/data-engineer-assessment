-- 1. Output the list of customers and their spending
select customer_name, SUM(total_price_before_gst) as spending from car_sales.invoice_details group by customer_name; 

-- 2. Output the top 3 car manufacturers that customers bought by sales (quatity) and the sales number for it in the current month 
with monthly_sales_quantity as (
	select manufacturer.identifier_number, manufacturer.manufacturer_name, to_char(transaction_timestamp, 'YYYY-MM') as year_month, sum(transaction.total_price) as quantity from car_sales.manufacturer_details as manufacturer
		join car_sales.model_details as model on (model.identifier_number = manufacturer.identifier_number)
		join car_sales.transaction_details as transaction on (transaction.serial_number = transaction.serial_number)
		join car_sales.invoice_details as invoice on (invoice.invoice_id = transaction.invoice_id)
	group by manufacturer.identifier_number, manufacturer.manufacturer_name, to_char(transaction_timestamp, 'YYYY-MM'))
select * from monthly_sales_quantity where year_month = to_char(current_date, 'YYYY-MM') order by quantity desc limit 10;