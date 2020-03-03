-- non_usa_customers.sql: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT
	c.CustomerId,
	c.FirstName,
	c.LastName,
	c.Country
FROM Customer c 
WHERE c.Country != 'USA';

-- brazil_customers.sql: Provide a query only showing the Customers from Brazil.
SELECT * FROM Customer c
WHERE c.Country = 'Brazil';

-- brazil_customers_invoices.sql: Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT i.InvoiceId,
	i.InvoiceDate,
	i.BillingCountry,
	c.FirstName,
	c.LastName
FROM Invoice i
JOIN Customer c
ON i.CustomerId = c.CustomerId
WHERE c.Country IN ('Brazil');

-- sales_agents.sql: Provide a query showing only the Employees who are Sales Agents.
SELECT * FROM Employee e
WHERE e.Title = 'Sales Support Agent';

-- unique_invoice_countries.sql: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
SELECT DISTINCT b.BillingCountry
FROM Invoice b
ORDER BY b.BillingCountry ;


-- sales_agent_invoices.sql: Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
SELECT i.InvoiceId,
	e.FirstName,
	e.LastName
FROM Invoice i
JOIN Customer c
on i.CustomerId = c.CustomerId
JOIN Employee e
ON c.SupportRepId = e.EmployeeId
WHERE e.Title = 'Sales Support Agent' 
ORDER BY i.InvoiceId DESC;

-- invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT i.Total,
	c.FirstName 'custFirst',
	c.LastName 'custLast',
	c.Country,
	e.FirstName, 'empFirst',
	e.LastName 'empLast'
FROM Invoice i
JOIN Customer c
ON i.CustomerId = c.CustomerId
JOIN Employee e
ON c.SupportRepId = e.EmployeeId
WHERE e.Title = 'Sales Support Agent'
ORDER BY i.Total ASC;

-- total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?
SELECT COUNT(*)
FROM Invoice i
WHERE i.InvoiceDate BETWEEN '2009-01-01' AND '2009-12-31';

SELECT COUNT(*)
FROM Invoice i
WHERE i.invoiceDate BETWEEN '2011-01-01' AND '2011-12-31'
OR i.InvoiceDate BETWEEN '2009-01-01' AND '2009-12-31';

-- total_sales_{year}.sql: What are the respective total sales for each of those years?
SELECT SUM(Total)
FROM Invoice i
WHERE i.InvoiceDate BETWEEN '2009-01-01' and '2009-12-31'
OR i.InvoiceDate BETWEEN '2011-01-01' and '2011-12-31';

-- invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT COUNT(*)
FROM InvoiceLine i 
WHERE i.InvoiceId = 37;

-- line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT 
	i.InvoiceLineId,
	COUNT()
FROM InvoiceLine i
GROUP BY i.InvoiceId;

-- line_item_track.sql: Provide a query that includes the purchased track name with each invoice line item.
SELECT 
	i.InvoiceLineId,
	t.Name
FROM InvoiceLine i
JOIN Track t
ON i.TrackId = t.TrackId
ORDER BY i.InvoiceLineId DESC;

-- line_item_track_artist.sql: Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT 
	i.InvoiceLineId,
	t.Name 'track name',
	ar.Name 'artist name'
FROM InvoiceLine i
JOIN Track t
ON i.TrackId = t.TrackId
JOIN Album a
ON t.AlbumId = a.AlbumId
JOIN Artist ar
on a.ArtistId = ar.ArtistId
ORDER BY i.InvoiceLineId ASC;

-- country_invoices.sql: Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT 
	COUNT() 'byCountry',
	i.BillingCountry,
	c.Country 'customerCountry'
FROM Invoice i
JOIN Customer c
ON i.CustomerId = c.CustomerId
GROUP BY c.Country;
	

-- playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.
SELECT
	COUNT(pt.TrackId),
	p.Name
FROM Playlist p
JOIN PlaylistTrack pt
ON pt.PlaylistId = p.PlaylistId
GROUP BY p.Name;

-- tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
SELECT
	t.Name 'trackName',
	a.Title ' albumTitle',
	mt.Name 'mediaType',
	g.Name 'genre'
FROM Track t 
JOIN Album a 
ON t.AlbumId = a.AlbumId
JOIN MediaType mt
ON t.MediaTypeId = mt.MediaTypeId
JOIN Genre g
ON t.GenreId = g.GenreId;

-- invoices_line_item_count.sql: Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT
	i.InvoiceId,
	count(il.InvoiceId)
FROM Invoice i 
JOIN InvoiceLine il 
ON i.InvoiceId = il.InvoiceId
GROUP BY il.InvoiceId;

-- sales_agent_total_sales.sql: Provide a query that shows total sales made by each sales agent.
SELECT 
	e.FirstName,
	e.LastName,
	ROUND(SUM(i.Total))
FROM Employee e 
JOIN Customer c 
ON e.EmployeeId = c.SupportRepId
JOIN Invoice i 
ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId;

-- top_2009_agent.sql: Which sales agent made the most in sales in 2009?
-- Hint: Use the MAX function on a subquery.
SELECT max(amountsum), amountsum.FirstName, amountsum.LastName
from (SELECT	
				e.FirstName,
				e.LastName,
				ROUND(SUM(i.Total)) as amountsum
		FROM Employee e 
		JOIN Customer c 
		ON e.EmployeeId = c.SupportRepId
		JOIN Invoice i 
		ON c.CustomerId = i.CustomerId
		WHERE i.InvoiceDate BETWEEN '2009-01-01' and '2009-12-31'
		GROUP BY e.EmployeeId) as amountsum;

-- top_agent.sql: Which sales agent made the most in sales over all?
SELECT max(amountsum), amountsum.FirstName, amountsum.LastName
from (SELECT

				e.FirstName,
				e.LastName,
				ROUND(SUM(i.Total)) as amountsum
		FROM Employee e 
		JOIN Customer c 
		ON e.EmployeeId = c.SupportRepId
		JOIN Invoice i
		ON c.CustomerId = i.CustomerId
		GROUP by e.EmployeeId) as amountsum;

-- sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.
SELECT 
		e.FirstName,
		e.LastName,
		COUNT(c.CustomerId)
FROM Employee e 
JOIN Customer c 
ON e.EmployeeId = c.SupportRepId
GROUP BY e.EmployeeId;

-- sales_per_country.sql: Provide a query that shows the total sales per country.

-- top_country.sql: Which country's customers spent the most?

-- top_2013_track.sql: Provide a query that shows the most purchased track of 2013.

-- top_5_tracks.sql: Provide a query that shows the top 5 most purchased tracks over all.

-- top_3_artists.sql: Provide a query that shows the top 3 best selling artists.

-- top_media_type.sql: Provide a query that shows the most purchased Media Type.