USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT	COUNT(*) AS director_mapping_row_count
FROM
	director_mapping;
-- Number of rows (director_mapping) = 3867

SELECT	COUNT(*) AS genre_row_count
FROM
	genre;
-- Number of rows (genre) = 14662

SELECT	COUNT(*) AS movie_row_count
FROM
	movie;
-- Number of rows (movie) = 7997

SELECT	COUNT(*) AS names_row_count
FROM
	names;
-- Number of rows (names) = 25735

SELECT	COUNT(*) AS ratings_row_count
FROM
	ratings;
-- Number of rows (ratings) = 7997

SELECT	COUNT(*) AS role_mapping_row_count
FROM
	role_mapping;
-- Number of rows (role_mapping) = 15615
    
-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT	SUM(CASE
				WHEN id IS NULL THEN 1
                ELSE 0
			END) AS Id_Null_Count,
		SUM(CASE
				WHEN title IS NULL THEN 1
                ELSE 0
			END) AS Title_Null_Count,
		SUM(CASE
				WHEN year IS NULL THEN 1
                ELSE 0
			END) AS Year_Null_Count,
		SUM(CASE
				WHEN date_published IS NULL THEN 1
                ELSE 0
			END) AS Date_Published_Null_Count,
		SUM(CASE
				WHEN duration IS NULL THEN 1
                ELSE 0
			END) AS Duration_Null_Count,
		SUM(CASE
				WHEN country IS NULL THEN 1
                ELSE 0
			END) AS Country_Null_Count,
		SUM(CASE
				WHEN worlwide_gross_income IS NULL THEN 1
                ELSE 0
			END) AS Worlwide_Gross_Income_Null_Count,
		SUM(CASE
				WHEN languages IS NULL THEN 1
                ELSE 0
			END) AS Languages_Null_Count,
		SUM(CASE
				WHEN production_company IS NULL THEN 1
                ELSE 0
			END) AS Production_Company_Null_Count
FROM
	movie;
    
-- Country, Worlwide_Gross_Income, Languages, Production_Company columns have Null Values/Count.

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Number of movies released each year
SELECT	year,
		COUNT(title) AS number_of_movies
FROM
	movie
GROUP BY 
		year;

-- Number of movies released each year are as follows:
-- 2017: 3052, 2018: 2944, 2019: 2001

-- Number of movies released each month
SELECT	MONTH(date_published) AS month_num,
		COUNT(title) AS number_of_movies
FROM
	movie
GROUP BY
	month_num
ORDER BY
	month_num ASC;

-- Number of movies released each month are as follows:
-- 1: 804, 2: 640, 3: 824, 4: 680, 5: 625, 6: 580, 7: 493, 8: 678, 9: 809, 10: 801, 11: 625, 12: 438
-- Highest number of movies is produced in month of March followed by September and January

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT	COUNT(title) AS number_of_movies_US_INDIA_in_2019
FROM
	movie
WHERE
	(country LIKE '%USA%' OR
    country LIKE '%INDIA%') AND
    year = 2019;

-- USA & India produced 1059 movies in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT	COUNT(DISTINCT genre) AS unique_genres
FROM
	genre;

-- Distinct Genres in the data set are 13 Genres.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT	genre,
		COUNT(m.title) AS number_of_movie
FROM
	movie AS m
INNER JOIN
    genre AS g
    ON m.id = g.movie_id
GROUP BY
	genre
ORDER BY
	number_of_movie DESC LIMIT 1;

-- Drama Genre has maximum number (4285) of movie titles

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT	COUNT(*) AS movies_with_one_genre
	FROM (
			SELECT	movie_id
			FROM
				genre
			GROUP BY
				movie_id
			HAVING
				COUNT(DISTINCT genre) = 1
			) AS one_genre;

-- There are 3289 movie titles with only 1 movie genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT	genre,
		ROUND(AVG(m.duration),2) AS avg_duration
FROM
	movie AS m
INNER JOIN
	genre AS g
    ON m.id = g.movie_id
GROUP BY
	genre
ORDER BY
	avg_duration DESC;

-- Action movies have highest duration of 112.88 mins followed by Romance (109.53 mins) and Crime (107.05 mins).

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT	genre,
		COUNT(movie_id) AS movie_count,
        RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM
	genre
GROUP BY
	genre;

-- Thriller is Rank 3 across all the genres with movie count of 1484 movies.
-- Drama is Rank 1 across all the genres with movie count of 4285 movies.
-- Comedy is Rank 2 across all the genres with movie count of 2412 movies.

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT	MIN(avg_rating) AS min_avg_rating,
		MAX(avg_rating) AS max_avg_rating,
        MIN(total_votes) AS min_total_votes,
		MAX(total_votes) AS max_total_votes,
        MIN(median_rating) AS min_median_rating,
		MAX(median_rating) AS max_median_rating
FROM
	ratings;
    
-- Avg_rating is between 1 & 10.
-- Median_rating is between 1 & 10
-- Total_votes is between 100 & 725138
    
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH movie_ranking AS
(
SELECT	m.title,
		r.avg_rating,
        RANK() OVER(ORDER BY r.avg_rating DESC) AS movie_rank,
        DENSE_RANK() OVER(ORDER BY r.avg_rating DESC) AS movie_dense_rank,
        ROW_NUMBER() OVER(ORDER BY r.avg_rating DESC) AS movie_row_number
FROM ratings AS r
INNER JOIN
	movie AS m
    ON m.id = r.movie_id
)
SELECT	*
FROM
	movie_ranking
WHERE
	movie_rank <= 10;

-- Used Dense Rank for getting the ranks without skipping the rank values in case avg_rating is same
-- Used Row Number for getting the Top movies
-- Top 6 movies avg. rating is more than 9.5

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT	median_rating,
		COUNT(movie_id) AS movie_count
FROM
	ratings
GROUP BY
	median_rating
ORDER BY
	movie_count DESC;

-- Median Rating of 7 has maximum movies (2257) followed by median rating of 6 (1975) and 8 (1030).

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT	m.production_company,
		COUNT(m.title) AS movie_count,
        RANK() OVER(ORDER BY COUNT(m.title) DESC) as prod_company_rank,
        DENSE_RANK() OVER(ORDER BY COUNT(m.title) DESC) as prod_company_dense_rank,
        ROW_NUMBER() OVER(ORDER BY COUNT(m.title) DESC) as prod_company_row_number
FROM
	ratings AS r
INNER JOIN
	movie AS m
    ON m.id = r.movie_id
WHERE
	r.avg_rating > 8 AND
    m.production_company IS NOT NULL
GROUP BY
	m.production_company;

-- Dream Warrior Pictures and National Theatre Live are the Top 2 production company ranked 1 with each having movie count of 3.

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT	g.genre,
		COUNT(m.title) AS movie_count
FROM
	movie AS m
INNER JOIN
	genre AS g
            ON m.id = g.movie_id
    INNER JOIN
		ratings AS r
        ON r.movie_id = m.id
WHERE
	m.year = 2017 AND
    month(m.date_published) = 3 AND
    m.country LIKE '%USA%' AND
    r.total_votes > 1000
GROUP BY
	g.genre
ORDER BY
	movie_count DESC;

-- 24 Drama movies released during March 2017 in the USA country and had more than 1,000 votes 

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT	m.title,
		r.avg_rating,
        g.genre
FROM
	movie AS m
INNER JOIN
	genre AS g
    ON m.id = g.movie_id
    INNER JOIN
		ratings AS r
        ON r.movie_id = m.id
WHERE
	r.avg_rating > 8 AND
    m.title LIKE 'The%'
GROUP BY
	m.title
ORDER BY
	r.avg_rating DESC;

-- There are total 8 movies where title starts with 'The'
-- The best rated movie of the list is The Brighton Miracle with avg. rating of 9.5
-- All these movies belonged to Top 5 Genre i.e., Drama, Crime and Action

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT	r.median_rating,
		COUNT(m.title) AS movie_count
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON m.id = r.movie_id
WHERE
	r.median_rating = 8 AND
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY
	r.median_rating;

-- 361 movies were released between 1 April 2018 and 1 April 2019 with median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT	m.languages,
		SUM(r.total_votes) AS total_votes
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON m.id = r.movie_id
WHERE
	m.languages LIKE '%GERMAN%'

UNION

SELECT	m.languages,
		SUM(r.total_votes) AS total_votes
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON m.id = r.movie_id
WHERE
	m.languages LIKE '%ITALIAN%'
ORDER BY
	total_votes DESC;

-- German movies received 4421525 votes
-- Italian movies received 2559540 votes
-- Hence, we can conclude German movies received more votes than Italian movies

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT	SUM(CASE
				WHEN name IS NULL THEN 1
                ELSE 0
			END) AS name_nulls,
		SUM(CASE
				WHEN height IS NULL THEN 1
                ELSE 0
			END) AS height_nulls,
		SUM(CASE
				WHEN date_of_birth IS NULL THEN 1
                ELSE 0
			END) AS date_of_birth_nulls,
		SUM(CASE
				WHEN known_for_movies IS NULL THEN 1
                ELSE 0
			END) AS known_for_movies_nulls
FROM
	names;

-- There are no null values in name column
-- Height, Date of birth & Known for movies column have null values

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_genres AS
(
	SELECT	g.genre,
			COUNT(m.id) AS movie_count,
			RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
	FROM
		movie AS m
	INNER JOIN
		genre AS g
        ON m.id = g.movie_id
		INNER JOIN
			ratings AS r
			ON r.movie_id = m.id
	WHERE
		r.avg_rating > 8
	GROUP BY
		g.genre
	LIMIT 3
)
SELECT	n.name AS director_name,
		COUNT(d.movie_id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_rank,
        g.genre AS genre
FROM
	director_mapping AS d
INNER JOIN
	genre AS g
    ON d.movie_id = g.movie_id
    INNER JOIN
		names AS n
        ON n.id = d.name_id
        INNER JOIN
			top_genres AS t
            ON t.genre = g.genre
            INNER JOIN
				ratings AS r
                ON r.movie_id = d.movie_id
WHERE
	r.avg_rating > 8
GROUP BY
	n.name
ORDER BY
	movie_count DESC LIMIT 3;

-- Top 3 directors in top genres with avg. rating more than 8 are as follows:
-- James Mangold - Rank 1 with movie count 4
-- Soubin Shahir - Rank 2 with movie count 3
-- Joe Russo - Rank 3 with movie count 3

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT	n.name AS actor_name,
		COUNT(rm.movie_id) AS movie_count
FROM
	role_mapping AS rm
INNER JOIN
	names AS n
    ON n.id = rm.name_id
    INNER JOIN
		ratings AS r
        ON r.movie_id = rm.movie_id
WHERE
	r.median_rating >= 8 AND
    rm.category = 'actor'
GROUP BY
	n.name
ORDER BY
	movie_count DESC LIMIT 2;

-- Top 2 actors are Mammootty & Mohanlal with 8 and 5 movies respectively

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT	m.production_company,
		SUM(r.total_votes) AS vote_count,
        DENSE_RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON m.id = r.movie_id
GROUP BY
	m.production_company
LIMIT 3;

-- Top3 production houses with respect total votes are as follows:
-- Marvel Studios - Rank 1 - Total Votes are 2656967
-- Twentieth Century Fox - Rank 2 - Total Votes are 2411163
-- Warner Bros. - Rank 3 - Total Votes are 2396057

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT	n.name AS actor_name,
		r.total_votes,
        COUNT(m.id) AS count_movies,
        ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actor_avg_rating,
        RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) DESC) AS actor_rank,
        DENSE_RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) DESC) AS actor_dense_rank
FROM
	names AS n
INNER JOIN
	role_mapping AS rm
    ON n.id = rm.name_id
    INNER JOIN
		ratings AS r
        ON rm.movie_id = r.movie_id
			INNER JOIN
				movie AS m
                ON m.id = r.movie_id
WHERE
	rm.category = 'actor' AND
    m.country LIKE '%india%'
GROUP BY
	n.name
HAVING
	count_movies >= 5
ORDER BY
	actor_avg_rating DESC,
	r.total_votes DESC;

-- Top 3 Indian actors (having acted in atleast 5 movies) are as follows:
-- Vijay Sethupathi Rank 1 with avg_rating as 8.42
-- Fahadh Faasil Rank 2 with avg_rating as 7.99
-- Yogi Babu Rank 3 with avg_rating as 7.83

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT	n.name AS actress_name,
		r.total_votes,
        COUNT(m.id) AS count_movies,
        ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating,
        RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) DESC) AS actress_rank,
        DENSE_RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) DESC) AS actress_dense_rank
FROM
	names AS n
INNER JOIN
	role_mapping AS rm
    ON n.id = rm.name_id
    INNER JOIN
		ratings AS r
        ON rm.movie_id = r.movie_id
			INNER JOIN
				movie AS m
                ON m.id = r.movie_id
WHERE
	rm.category = 'actress' AND
    m.country LIKE '%india%' AND
    m.languages LIKE '%hindi%'
GROUP BY
	n.name
HAVING
	count_movies >= 3
ORDER BY
	actress_avg_rating DESC,
	r.total_votes DESC;

-- Top 5 Indian actresses (having acted in atleast 3 movies) are as follows:
-- Taapsee Pannu Rank 1 with avg_rating as 7.74
-- Kriti Sanon Rank 2 with avg_rating as 7.05
-- Divya Dutta Rank 3 with avg_rating as 6.88
-- Shraddha Kapoor Rank 4 with avg_rating as 6.63
-- Kriti Kharbanda Rank 5 with avg_rating as 4.80

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT	m.title,
	CASE
		WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
	END AS category
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON m.id = r.movie_id
    INNER JOIN
		genre AS g
        ON r.movie_id = g.movie_id
WHERE
	g.genre = 'Thriller';

-- Most of movies are One-time-watch movies (786) followed by Flop movies (493), Hit movies (166) and Superhit movies (39)

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
-- Round is good to have and not a must have; Same thing applies to sorting
SELECT	g.genre,
		ROUND(AVG(m.duration),2) AS avg_duration,
        SUM(ROUND(AVG(m.duration),2)) OVER(ORDER BY g.genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        SUM(ROUND(AVG(m.duration),2)) OVER(ORDER BY g.genre ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS moving_avg_duration
FROM
	movie AS m
INNER JOIN
	genre AS g
    ON m.id = g.movie_id
GROUP BY
	g.genre
ORDER BY
	g.genre;
   
-- The Top 3 Genres with maximum avg duration are as follows:
-- Action with 112.88 mins
-- Romance with 109.53 mins
-- Crime with 107.05 mins

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_genres AS
(
	SELECT	g.genre,
			COUNT(m.id) AS movie_count
	FROM
		genre AS g
	INNER JOIN
		movie AS m
		ON m.id = g.movie_id
	GROUP BY
		g.genre
	ORDER BY
		COUNT(m.id) DESC
        LIMIT 3
),
-- Need to convert INR to $ in worlwide_gross_income. Assuming $1 = Rs.82 for converting gross income into one standard unit if $
top_grossing_movies AS
(
	SELECT	g.genre,
			m.year,
            m.title AS movie_name,
		CASE
			WHEN m.worlwide_gross_income LIKE 'INR%' THEN CAST(REPLACE(m.worlwide_gross_income,'INR','') AS DECIMAL(12)) / 82
            WHEN m.worlwide_gross_income LIKE '$%' THEN CAST(REPLACE(m.worlwide_gross_income,'$','') AS DECIMAL(12))
            ELSE CAST(m.worlwide_gross_income AS DECIMAL(12))
		END AS worldwide_gross_income
	FROM
		movie AS m
	INNER JOIN
		genre AS g
        ON g.movie_id = m.id,
	top_genres
	WHERE
		g.genre IN (top_genres.genre)
-- group by done to get distinct movie titles as one movie can belong to multiple genres
	GROUP BY
		movie_name
	ORDER BY
		m.year
),
top_movies AS 
(
	SELECT	*,
			 DENSE_RANK() OVER(PARTITION BY year ORDER BY worldwide_gross_income DESC) AS movie_rank
	FROM
		top_grossing_movies
)
SELECT	*
FROM
	top_movies
WHERE
	movie_rank <= 5;

-- Top ranked movies for respective years are as follows:
-- The Fate of the Furious Rank 1 in 2017
-- Bohemian Rhapsody Rank 1 in 2018
-- Avengers: Endgame Rank 1 in 2019

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT	m.production_company,
		COUNT(m.id) AS movie_count,
        RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON m.id = r.movie_id
WHERE
	m.production_company IS NOT NULL AND
    r.median_rating >= 8 AND
    POSITION(',' IN languages) > 0
GROUP BY
	m.production_company
LIMIT 2;

-- Star Cinema & Twentieth Century Fox are top 2 production houses with respect to multilingual hit movies

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_actresses AS
(
	SELECT	n.name AS actress_name,
			SUM(total_votes) AS total_votes,
			COUNT(r.movie_id) AS movie_count,
			ROUND(SUM(total_votes*avg_rating) / SUM(total_votes),2) AS actress_avg_rating,
			RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank
	FROM
		names AS n
	INNER JOIN
		role_mapping AS rm
		ON n.id = rm.name_id
			INNER JOIN
				ratings AS r
				ON rm.movie_id = r.movie_id
					INNER JOIN
						genre AS g
						ON r.movie_id = g.movie_id
	WHERE
		rm.category = 'actress' AND
		g.genre = 'Drama' AND
		r.avg_rating > 8
	GROUP BY
		n.name
)
-- Did not use LIMIT 3 as there are 4 top ranked actresses having same movie_count of 2 
SELECT	*
FROM
	top_actresses
WHERE
	actress_rank <= 3;

-- Top ranked actresses are as follows:
-- Parvathy Thiruvothu, Susan Brown, Amanda Lawrence, Denise Gough all have 2 suprehit movies (avg rating > 8) in Drama Genre.

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_information AS
(
	SELECT	d.name_id,
			n.name,
			d.movie_id,
            r.avg_rating,
            r.total_votes,
            m.duration,
            m.date_published,
            LAG(m.date_published, 1) OVER(PARTITION BY d.name_id ORDER BY m.date_published) AS previous_date_published
	FROM
		names AS n
        INNER JOIN
			director_mapping AS d
            ON n.id = d.name_id
				INNER JOIN
					movie AS m
                    ON d.movie_id = m.id
						INNER JOIN
							ratings AS r
                            ON m.id = r.movie_id
),
top_directors AS 
(
	SELECT	name_id AS director_id,
			name AS director_name,
            COUNT(movie_id) AS number_of_movies,
            ROUND(AVG(DATEDIFF(date_published,previous_date_published)),2) AS avg_inter_movie_days,
            ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS avg_rating,
			SUM(total_votes) AS total_votes,
			ROUND(MIN(avg_rating),1) AS min_rating,
			ROUND(MAX(avg_rating),1) AS max_rating,
			SUM(duration) AS total_duration,
			RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS director_rank
	FROM
		director_information
	GROUP BY
		director_id
)
SELECT	director_id,
		director_name,
		number_of_movies,
        avg_inter_movie_days,
        avg_rating,
        total_votes,
        min_rating,
        max_rating,
        total_duration
FROM
	top_directors
WHERE
	director_rank <= 9;