/*
Question 3. Counting short trips
For the trips in November 2025 
(lpep_pickup_datetime between '2025-11-01' and '2025-12-01', 
exclusive of the upper bound), 
how many trips had a trip_distance of less than or equal to 1 mile?
*/

SELECT 
	COUNT(*) AS Trips_less_1mile
FROM green_taxi_trips
WHERE lpep_pickup_datetime >= '2025-11-01' 
AND lpep_pickup_datetime < '2025-12-01'
AND trip_distance <= 1;

/*
Question 4. Longest trip for each day
Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles (to exclude data errors).

Use the pick up time for your calculations.

2025-11-14
2025-11-20
2025-11-23
2025-11-25
*/


SELECT 
	pickup_date
FROM
	(SELECT
    	DATE(lpep_pickup_datetime) AS pickup_date,
		SUM(trip_distance) AS TotalDist
	FROM green_taxi_trips
	WHERE trip_distance < 100
	GROUP BY DATE(lpep_pickup_datetime)
	ORDER BY SUM(trip_distance) DESC) AS T
LIMIT 1;

/*
Question 5. Biggest pickup zone
Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?

East Harlem North
East Harlem South
Morningside Heights
Forest Hills
*/

SELECT 
	Z."Zone",
	SUM(G.total_amount) SumofMoneyPaid
FROM green_taxi_trips AS G
JOIN zones  Z
ON G."PULocationID" = Z."LocationID"
WHERE DATE(lpep_pickup_datetime) = '2025-11-18'
GROUP BY Z."Zone"
ORDER BY SumofMoneyPaid DESC;

/*
Question 6. Largest tip
For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

Note: it's tip , not trip. We need the name of the zone, not the ID.

JFK Airport
Yorkville West
East Harlem North
LaGuardia Airport
*/

SELECT 
	Z2."Zone" pickuoHarlemZone,
	G."DOLocationID",
	Z1."Zone" dropofzone,
	G.tip_amount Tips
FROM green_taxi_trips AS G
JOIN zones  Z1 ON G."DOLocationID" = Z1."LocationID"
JOIN zones Z2 ON G."PULocationID" = Z2."LocationID"
WHERE (G.lpep_pickup_datetime >= '2025-11-01'AND G.lpep_pickup_datetime <  '2025-12-01') AND Z2."Zone" = 'East Harlem North'
ORDER BY Tips DESC
LIMIT 1;



