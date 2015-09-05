--Chris Fenton IS607 Week 1 Assignment
--Note: Following code is for Postgres

--Question 1

--Total number of planes with listed speed?

SELECT count(*)
FROM planes
WHERE speed IS NOT NULL;

--returns 23 records

--Maximum listed speed?

SELECT max(speed)
FROM planes
WHERE speed IS NOT NULL;

--returns 432

--Minimum listed speed?

SELECT min(speed)
FROM planes
WHERE speed IS NOT NULL;

--returns 90

--Question 2

--What is the total distance flown by all planes in January 2013?

SELECT sum(distance)
FROM flights
WHERE year = '2013' AND month = '1';

--Returns 27,188,805 (miles)

--What is the total distance flown by all of the planes in January 2013 where tailnum is missing?

SELECT sum(distance)
FROM flights
WHERE year = '2013' AND month = '1' AND tailnum IS NULL;

--Returns no records, every flight had a tailnum.

--Question 3

--What is the total distance flow for all planes on 7/5/13 grouped by manufacturer?

--Inner Join

SELECT sum(flights.distance) AS "Distance Flown", planes.manufacturer
FROM flights
INNER JOIN planes
ON flights.tailnum = planes.tailnum
WHERE flights.year = '2013' AND flights.month = '7' AND flights.day = '5'
GROUP BY planes.manufacturer
ORDER BY "Distance Flown" DESC;

--returns:
/*
Distance Flown; Manufacturer
335028;"BOEING"
195089;"AIRBUS"
78786;"AIRBUS INDUSTRIE"
77909;"EMBRAER"
31160;"BOMBARDIER INC"
15690;"MCDONNELL DOUGLAS AIRCRAFT CO"
7486;"MCDONNELL DOUGLAS"
4767;"MCDONNELL DOUGLAS CORPORATION"
2898;"CESSNA"
2199;"AMERICAN AIRCRAFT INC"
1157;"GULFSTREAM AEROSPACE"
1142;"CANADAIR"
1089;"DOUGLAS"
937;"BARKER JACK L"
*/

--Left Join

SELECT sum(flights.distance) AS "Distance Flown", planes.manufacturer
FROM flights
LEFT JOIN planes
ON flights.tailnum = planes.tailnum
WHERE flights.year = '2013' AND flights.month = '7' AND flights.day = '5'
GROUP BY planes.manufacturer
ORDER BY "Distance Flown" DESC;

--returns
/*
Distance Flown; Manufacturer
335028;"BOEING"
195089;"AIRBUS"
127671;""
78786;"AIRBUS INDUSTRIE"
77909;"EMBRAER"
31160;"BOMBARDIER INC"
15690;"MCDONNELL DOUGLAS AIRCRAFT CO"
7486;"MCDONNELL DOUGLAS"
4767;"MCDONNELL DOUGLAS CORPORATION"
2898;"CESSNA"
2199;"AMERICAN AIRCRAFT INC"
1157;"GULFSTREAM AEROSPACE"
1142;"CANADAIR"
1089;"DOUGLAS"
937;"BARKER JACK L"
*/

--The results are similar, however the left join includes the miles from flights
--that did not return a tailnum match on the planes table.

--Question 4

--What wer the top 5 destinations for Airbus flights?

SELECT airports.name AS "Airport", count(*) AS "Total Flights"
FROM flights
INNER JOIN planes ON flights.tailnum = planes.tailnum
INNER JOIN airports ON flights.dest = airports.faa
WHERE planes.manufacturer = 'AIRBUS' or planes.manufacturer = 'AIRBUS INDUSTRIE'
GROUP BY "Airport"
ORDER BY "Total Flights" DESC
LIMIT 5;

--Returns:
/*
Airport;Total Flights
"Charlotte Douglas Intl";8334
"Fort Lauderdale Hollywood Intl";8063
"Orlando Intl";7473
"Los Angeles Intl";4705
"Chicago Ohare Intl";4273
*/
