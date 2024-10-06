-- SQL PROJECT- MUSIC STORE DATA ANALYSIS

-- Question Set 1


-- 1. Who is the senior most employee based on job title?

SELECT 
    * 
FROM 
    Employee 
LIMIT 10;

-- Ans:

SELECT 
    employee_id, 
    first_name, 
    last_name 
FROM 
    employee 
ORDER BY 
    levels DESC 
LIMIT 1;

SELECT 
    employee_id, 
    first_name 
FROM 
    employee 
WHERE 
    employee_id = '9';

 -- 2. Which countries have the most Invoices?
 
SELECT 
    * 
FROM 
    invoice 
LIMIT 10;
 
SELECT 
    DISTINCT billing_country 
FROM 
    invoice 
LIMIT 10;
 
--Ans:

SELECT 
    billing_country AS Country, 
    COUNT(invoice_id) AS Invoice_count 
FROM 
    invoice 
GROUP BY 
    Country 
ORDER BY 
    Invoice_count DESC 
LIMIT 4;

-- 3. What are top 3 values of total invoice?

SELECT 
    * 
FROM 
    invoice 
ORDER BY 
    total DESC;

-- for top 3 values

SELECT 
    total 
FROM 
    invoice 
ORDER BY 
    total DESC 
LIMIT 3;

-- for distinct top 3 values

SELECT 
    DISTINCT total 
FROM 
    invoice 
ORDER BY 
    total DESC 
LIMIT 3;

-- 4. Which city has the best customers? We would like to throw a promotional Music 
-- Festival in the city we made the most money. Write a query that returns one city that 
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice 
-- totals.

-- Ans: 

SELECT 
    Billing_City AS City, 
    SUM(total) 
FROM 
    invoice 
GROUP BY 
    City 
ORDER BY 
    City DESC 
LIMIT 1;

-- 5. Who is the best customer? The customer who has spent the most money will be 
-- declared the best customer. Write a query that returns the person who has spent the 
-- most money.

--Ans:

SELECT 
    c.first_name AS first_name, 
    c.last_name AS last_name, 
    SUM(i.total) AS total 
FROM 
    invoice AS i 
JOIN 
    customer AS c ON i.customer_id = c.customer_id 
GROUP BY 
    c.customer_id 
ORDER BY 
    total DESC 
LIMIT 1;

-- furthermore

SELECT 
    c.first_name AS first_name, 
    c.last_name AS last_name, 
    ROUND(CAST(SUM(i.total) AS NUMERIC), 2) AS total 
FROM 
    invoice AS i 
JOIN 
    customer AS c ON i.customer_id = c.customer_id 
GROUP BY 
    c.customer_id 
ORDER BY 
    total DESC 
LIMIT 1;

-- Question Set 2 – Moderate

-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music 
-- listeners. Return your list ordered alphabetically by email starting with A.

SELECT 
    * 
FROM 
    customer 
LIMIT 10;

SELECT 
    * 
FROM 
    genre 
LIMIT 10;

-- Ans:
WITH CTE AS (
    SELECT c.email, c.first_name, c.last_name, g.name as genre
    FROM customer AS c 
    JOIN invoice AS i ON c.customer_id = i.customer_id 
    JOIN invoice_line AS il ON i.invoice_id = il.invoice_id 
    JOIN track AS t ON t.track_id = il.track_id 
    JOIN genre AS g ON t.genre_id = g.genre_id
)
SELECT 
    distinct email AS Email,
    first_name AS First_name,
    last_name AS Last_name,
    genre
FROM 
    CTE 
WHERE 
    genre='Rock'
ORDER BY 
    Email;

-- or to optimise

WITH CTE AS (
    SELECT distinct c.email, c.first_name, c.last_name, g.name as genre
    FROM customer AS c 
    JOIN invoice AS i ON c.customer_id = i.customer_id 
    JOIN invoice_line AS il ON i.invoice_id = il.invoice_id 
    JOIN track AS t ON t.track_id = il.track_id 
    JOIN genre AS g ON t.genre_id = g.genre_id
)
SELECT 
    email AS Email,
    first_name AS First_name,
    last_name AS Last_name,
    genre
FROM 
    CTE 
WHERE 
    genre='Rock'
ORDER BY 
    Email;

-- 2. Let's invite the artists who have written the most rock music in our dataset. Write a 
-- query that returns the Artist name and total track count of the top 10 rock bands.

SELECT 
    * 
FROM 
    track 
LIMIT 10;

SELECT 
    name 
FROM 
    artist 
LIMIT 10;

Ans:
SELECT 
    ar.name AS artist_name, 
    COUNT(t.track_id) AS rock_track_cnt 
FROM 
    Track AS t 
JOIN 
    album AS a ON t.album_id = a.album_id 
JOIN 
    artist AS ar ON a.artist_id = ar.artist_id 
GROUP BY 
    ar.name, t.genre_id 
HAVING 
    t.genre_id = '1' 
ORDER BY 
    rock_track_cnt DESC 
LIMIT 10;

-- 3. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the 
-- longest songs listed first.

SELECT 
    AVG(Milliseconds) 
FROM 
    Track;

SELECT 
    Milliseconds 
FROM 
    Track;

-- Ans:
SELECT 
    "name", 
    Milliseconds AS Minutes 
FROM 
    Track 
WHERE 
    Milliseconds > (SELECT AVG(Milliseconds) FROM Track) 
ORDER BY 
    Milliseconds DESC;

-- furthermore

SELECT 
    "name", 
    Milliseconds / 60000 AS Minutes 
FROM 
    Track 
WHERE 
    Milliseconds > (SELECT AVG(Milliseconds) FROM Track) 
ORDER BY 
    Milliseconds DESC;

-- Question Set 3 – Advanced

-- 1. Find how much amount spent by each customer on artists? Write a query to return
-- customer name, artist name and total spent.

SELECT 
    total 
FROM 
    invoice 
LIMIT 10;

-- Ans:

SELECT 
    c.first_name,
    c.last_name, 
    ar.name AS artist_name,
    ROUND(SUM(i.total)::numeric, 2) AS total_spent
FROM 
    customer AS c
JOIN 
    invoice AS i ON c.customer_id = i.customer_id
JOIN 
    invoice_line AS il ON i.invoice_id = il.invoice_id
JOIN 
    track AS t ON il.track_id = t.track_id
JOIN 
    album AS a ON t.album_id = a.album_id
JOIN 
    artist AS ar ON a.artist_id = ar.artist_id
GROUP BY 
    c.first_name, 
    c.last_name, 
    ar.name;


-- in place of :: one can use CAST function too, it would look like ...round(cast(sum(i.total as numeric),2)...
-- also in place of doing ...round(sum(i.total::numeric),2)... I did round(sum(i.total)::numeric,2)...

-- 2. We want to find out the most popular music Genre for each country. We determine the 
-- most popular genre as the genre with the highest amount of purchases. Write a query 
-- that returns each country along with the top Genre. For countries where the maximum 
-- number of purchases is shared return all Genres.

SELECT 
    DISTINCT quantity 
FROM 
    invoice_line;

WITH CTE AS (
    SELECT 
        c.country AS country, 
        g.name AS genre,
        COUNT(*) AS quantity 
    FROM 
        customer AS c 
    JOIN 
        invoice AS i ON c.customer_id = i.customer_id 
    JOIN 
        invoice_line AS il ON i.invoice_id = il.invoice_id 
    JOIN 
        track AS t ON il.track_id = t.track_id 
    JOIN 
        genre AS g ON t.genre_id = g.genre_id
    GROUP BY 
        c.country, g.name
)
SELECT 
    country,
    genre,
    quantity
FROM 
    CTE
WHERE 
    (country, quantity) IN (
        SELECT 
            country, 
            MAX(quantity) 
        FROM 
            CTE 
        GROUP BY 
            country
    )
ORDER BY 
    country;

		
-- or use

WITH CTE AS (
    SELECT 
        c.country AS country, 
        g.name AS genre,
        COUNT(*) AS quantity 
    FROM 
        customer AS c 
    JOIN 
        invoice AS i ON c.customer_id = i.customer_id 
    JOIN 
        invoice_line AS il ON i.invoice_id = il.invoice_id 
    JOIN 
        track AS t ON il.track_id = t.track_id 
    JOIN 
        genre AS g ON t.genre_id = g.genre_id
    GROUP BY 
        c.country, g.name
),
MaxQuantityPerCountry AS (
    SELECT 
        country, 
        MAX(quantity) AS max_quantity
    FROM 
        CTE
    GROUP BY 
        country
)
SELECT 
    CTE.country, 
    CTE.genre, 
    CTE.quantity
FROM 
    CTE
JOIN 
    MaxQuantityPerCountry AS M
    ON CTE.country = M.country AND CTE.quantity = M.max_quantity
ORDER BY 
    CTE.country;

-- as joins are more efficient than where clause for larger datasets

-- 3. Write a query that determines the customer that has spent the most on music for each 
-- country. Write a query that returns the country along with the top customer and how
-- much they spent. For countries where the top amount spent is shared, provide all 
-- customers who spent this amount.

-- Ans:
WITH CTE AS (
    SELECT 
        c.country AS country, 
        c.first_name AS first_name, 
        c.last_name AS last_name, 
        ROUND(SUM(i.total)::numeric, 2) AS total
    FROM 
        customer AS c 
    JOIN 
        invoice AS i ON c.customer_id = i.customer_id 
    GROUP BY 
        c.country, c.first_name, c.last_name
)
SELECT 
    country, 
    first_name, 
    last_name, 
    total
FROM 
    CTE
WHERE 
    (country, total) IN (
        SELECT 
            country, 
            MAX(total) 
        FROM 
            CTE
        GROUP BY 
            country
    )
ORDER BY 
    country;

or use

WITH CTE AS (
    SELECT 
        c.country AS country, 
        c.first_name AS first_name, 
        c.last_name AS last_name, 
        ROUND(SUM(i.total)::numeric, 2) AS total
    FROM 
        customer AS c 
    JOIN 
        invoice AS i ON c.customer_id = i.customer_id 
    GROUP BY 
        c.country, c.first_name, c.last_name
),
MaxSpendingPerCountry AS (
    SELECT 
        country, 
        MAX(total) AS max_total
    FROM 
        CTE
    GROUP BY 
        country
)
SELECT 
    CTE.country, 
    CTE.first_name, 
    CTE.last_name, 
    CTE.total
FROM 
    CTE
JOIN 
    MaxSpendingPerCountry AS M
    ON CTE.country = M.country AND CTE.total = M.max_total
ORDER BY 
    CTE.country;


-- verifying

WITH CTEE AS (
    SELECT 
        c.country AS country, 
        c.first_name AS first_name, 
        c.last_name AS last_name, 
        COUNT(i.customer_id) AS cnt,
		ROUND(SUM(i.total)::numeric,2) AS tot
    FROM 
        customer AS c 
    JOIN 
        invoice AS i ON c.customer_id = i.customer_id 
    GROUP BY 
        c.country, c.first_name, c.last_name
)
SELECT 
    country, 
    first_name, 
    last_name, 
    cnt,
	tot
FROM 
    CTEE 
WHERE 
    cnt > 1
order by country;