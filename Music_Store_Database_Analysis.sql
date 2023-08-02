/*	Question Set 1 - Easy */

--1. Who is the senior most employee based on job title?

Select levels,first_name,last_name,title from Employee
order by levels desc
limit 1;

--2. Which countries have the most Invoices?

Select billing_country,count(*) as Invoice_Count from Invoice
group by billing_country
Order by Invoice_count desc;

--3. What are top 3 values of total invoice?

Select billing_country,total from Invoice
order by total desc
limit 3;

/*4. Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals.*/

Select billing_city,sum(total) as Total_Amount from invoice
group by billing_city
order by Total_Amount desc
limit 1;

/*5. Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money*/

Select a.customer_id,a.first_name,a.last_name,sum(b.total) as "Total Spending" from Customer as A
Join invoice as B
On a.customer_id = b.customer_id
group by a.customer_id
order by "Total Spending" desc
limit 1;


/* Question Set 2 - Moderate */

/*1. Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A.*/

Select Distinct a.email, a.first_name,a.Last_name,e.name as "Genre_Name" from customer a
join invoice b on a.customer_id = b.customer_id
join invoice_line c on b.invoice_id = c.invoice_id
join track d on c.track_id = d.track_id
join Genre e on d.genre_id = e.genre_id
where e.name like 'Rock'
order by a.email;


/*2. Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands.*/

Select a.name as "Artist_Name",count(c.track_id) as "Track_Count",d.name as "Genre" from Artist a 
join album b on a.artist_id = b.artist_id
join track c on b.album_id = c.album_id
join Genre d on c.genre_id = d.genre_id
where d.name like 'Rock'
group by a.name,d.name
order by "Track_Count" desc
limit 10;


/*3. Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first.*/

Select name as "Track_Name",milliseconds as "Track_Length" from Track
where milliseconds > 
	(Select Avg(milliseconds) as "Avg_Track_Length" 
	 from Track)
order by milliseconds desc;


/* Question Set 3 - Advance */

/*1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent.*/

With best_selling_artist as (
	Select artist.artist_id, artist.name as artist_name, sum(a.unit_price * a.quantity) as Total_sales
	from invoice_line a
	join Track on a.track_id = track.track_id
	join album on album.album_id = track.album_id
	join artist on album.artist_id = artist.artist_id
	group by 1
	order by 3 desc
	limit 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;


/*2. We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres.*/

with Popular_genre as (
	Select count(invoice_line.quantity) as Purchases, customer.country, genre.name, genre.genre_id,
	Row_Number() Over(Partition by customer.country ORDER BY COUNT(invoice_line.quantity) DESC) as "Row_Num"
	from Invoice_line 
	join invoice on invoice_line.invoice_id = invoice.invoice_id
	join customer on invoice.customer_id = customer.customer_id
	join Track on invoice_line.track_id = track.track_id
	join Genre on track.genre_id = genre.genre_id
	group by 2,3,4
	order by 2 asc,1 desc	
)
Select * from Popular_genre where "Row_Num" <= 1;



/*3. Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount.*/

 
with Customer_with_country as (
Select a.customer_id,a.first_name,a.last_name,b.billing_country,Sum(b.total) as "Total Spendings",
Row_Number() Over(Partition by b.billing_country) as "Row_Num"
from Customer as a
join Invoice as b on a.customer_id = b.customer_id
group by 1,2,3,4
order by 4 asc,"Total Spendings" desc
)

Select * from customer_with_country where "Row_Num" <= 1;




