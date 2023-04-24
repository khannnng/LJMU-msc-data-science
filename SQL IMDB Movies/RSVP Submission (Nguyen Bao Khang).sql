USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
(SELECT COUNT(*) FROM director_mapping) as director_mapping_Rows,
(SELECT COUNT(*) FROM genre) as genre_Rows,
(SELECT COUNT(*) FROM movie) as movie_Rows,
(SELECT COUNT(*) FROM names) as names_Rows,
(SELECT COUNT(*) FROM ratings) as ratings_Rows, 
(SELECT COUNT(*) FROM role_mapping) as role_mapping_Rows;

/* Answer: 
director_mapping: 3867
genre: 14662
movie: 7997
names: 25735
ratings: 7997
role_mapping: 15615
*/


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS Title_NULL,
SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS Year_NULL,
SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS DatePublished_NULL,
SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS Duration_NULL,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Country_NULL,
SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS Income_NULL,
SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS Language_NULL,
SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_NULL
FROM movie;

/* Answer: 
country, worldwide_gross_income, language AND production_company
*/

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

-- Movies by year
SELECT Year, COUNT(id) AS number_of_movies 
FROM movie
GROUP BY Year
ORDER BY Year;

-- Movies by month
SELECT MONTH(date_published) as month_num, COUNT(id) AS number_of_movies 
FROM movie
GROUP BY month_num
ORDER BY month_num;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT
(SELECT Count(id) FROM movie 
WHERE (country LIKE '%INDIA%') AND year = 2019) AS movies_by_INDIA,
(SELECT Count(id) FROM movie 
WHERE (country LIKE '%USA%') AND year = 2019) AS movies_by_USA,
(SELECT Count(id) FROM movie
WHERE (country LIKE '%INDIA%' OR country LIKE '%USA%' ) AND year = 2019) AS total_movies_INDIA_and_USA ;

/* Answer: 
By India: '309'
By USA: '758',
By both: '1059'
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre as genre_list FROM genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
WITH genre_count AS (
	SELECT genre, COUNT(id) as no_of_movies
	FROM movie m INNER JOIN genre g ON m.id = g.movie_id
	GROUP BY genre
	ORDER BY no_of_movies DESC
    )
SELECT * FROM genre_count
WHERE no_of_movies = (SELECT MAX(no_of_movies) FROM genre_count)
;

/* Answer: 
Drama genre has 4285 movies.
*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH single_genre_movies AS (
	SELECT movie_id, COUNT(movie_id) AS no_of_genres FROM genre
	GROUP BY movie_id
	HAVING no_of_genres = 1)
SELECT COUNT(*) AS no_of_single_genre_movies 
FROM single_genre_movies;

/* Answer: 
There are 3289 movies which has only 1 genre.
*/

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
SELECT genre, ROUND(AVG(duration),2) AS avg_duration
FROM movie m INNER JOIN genre g ON m.id = g.movie_id
GROUP BY genre;


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
SELECT genre, COUNT(genre) as movie_count,
RANK() OVER(ORDER BY COUNT(genre) DESC) AS genre_rank
FROM genre
GROUP BY genre;



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
SELECT 
MIN(avg_rating) AS min_avg_rating,
MAX(avg_rating) AS max_avg_rating,
MIN(total_votes) AS min_total_votes,
MAX(total_votes) AS max_total_votes,
MIN(median_rating) AS min_median_rating,
MAX(median_rating) AS min_median_rating
FROM ratings;


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

-- Top 10 movies by RANK()
WITH movie_rankings AS (
	SELECT title, avg_rating,
	RANK() OVER(ORDER BY avg_rating DESC) as movie_rank
	FROM movie m INNER JOIN ratings r on m.id = r.movie_id
    )
SELECT * FROM movie_rankings
WHERE movie_rank <= 10;

-- Top 10 movies by DENSE_RANK(), the list is a bit longer
WITH movie_rankings AS (
	SELECT title, avg_rating,
	DENSE_RANK() OVER(ORDER BY avg_rating DESC) as movie_rank
	FROM movie m INNER JOIN ratings r on m.id = r.movie_id
    )
SELECT * FROM movie_rankings
WHERE movie_rank <= 10;




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
SELECT median_rating, COUNT(title) AS movie_count
FROM movie m INNER JOIN ratings r on m.id = r.movie_id
GROUP BY median_rating
ORDER BY median_rating;


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

WITH prodcom_ranking AS (
    SELECT production_company, COUNT(production_company) AS movie_count,
    RANK() OVER(ORDER BY COUNT(production_company) DESC) AS prod_company_rank
    FROM movie m INNER JOIN ratings r on m.id = r.movie_id 
    WHERE avg_rating > 8
    GROUP BY production_company)
SELECT * FROM prodcom_ranking
WHERE prod_company_rank = 1
;


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

SELECT genre, COUNT(genre) as movie_count
FROM movie m 
INNER JOIN ratings r ON m.id = r.movie_id 
INNER JOIN genre g ON m.id = g.movie_id
-- in March 2017, in the USA, More than 1000 votes
WHERE 
    MONTH(date_published) = 3  
    AND year = 2017   
    AND total_votes > 1000          
    AND country LIKE '%USA%'           
GROUP BY genre
ORDER BY movie_count DESC;



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

SELECT title, avg_rating, genre
FROM movie m 
INNER JOIN ratings r ON m.id = r.movie_id 
INNER JOIN genre g ON m.id = g.movie_id
WHERE avg_rating > 8 AND title REGEXP '^The'
ORDER BY genre, avg_rating DESC;




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT COUNT(id) AS no_of_movies
FROM movie m 
INNER JOIN ratings r ON m.id = r.movie_id 
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'
AND median_rating = 8;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH vote_info AS (
    SELECT country, sum(total_votes) as total_votes 
    FROM movie m INNER JOIN ratings r ON m.id = r.movie_id
    WHERE country LIKE '%Germany%' OR country LIKE '%Italy%'
    GROUP BY country
    )
SELECT 
-- Germany votes
(SELECT SUM(total_votes) FROM vote_info WHERE country LIKE '%Germany%') as German_total_votes,
-- Italy votes
(SELECT SUM(total_votes) FROM vote_info WHERE country LIKE '%Italy%') as Italian_total_votes,
-- Verdict
(SELECT CASE 
	WHEN German_total_votes > Italian_total_votes THEN 'German'
    WHEN German_total_votes < Italian_total_votes THEN 'Italy' 
    ELSE 'Equal' END)
 AS Country_with_more_votes;



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
SELECT 
SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;




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

/*
The question is slightly ambiguous since it can be interpreted in 2 following ways:
1. Top 3 directors in all movies in top 3 genres
(eg: What are the top 3 genres and in ALL the movies belong to this top 3 genres, which 3 directors have the most movies (avr rating >8)?
2. From each of the top 3 genres, who is the 1 top director for their respective genre, for a total of 3 directors
(eg: if the top 3 genres are A, B and C, who is the top director for genre A, who is the top director for B, etc...)

Based on the desired output format, #1 seems to be the correct way to understand (no genre column in output)*/

-- Step 1. CTE of director ranking of who has the most >8.0 average rating movies which belong in the top 3 genres
WITH director_ranking AS (
	SELECT name AS director_name, COUNT(movie_id) AS movie_count,
	RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS director_rank
	FROM movie m
	INNER JOIN genre g ON m.id = g.movie_id
	INNER JOIN ratings r USING(movie_id)
	INNER JOIN director_mapping d USING(movie_id)
	INNER JOIN names n ON d.name_id = n.id

	-- Step 1a. whose movies belongs to the top 3 genres ...
	WHERE genre IN 
		-- Subquery for Top 3 genres
		(WITH genre_ranking AS (
		SELECT genre, COUNT(id),
		RANK() OVER(ORDER BY count(id) DESC) AS ranking
		FROM movie m
		INNER JOIN genre g ON m.id = g.movie_id
		INNER JOIN ratings r USING(movie_id)
		WHERE avg_rating >8
		GROUP BY genre
		ORDER BY count(id) DESC)
		SELECT genre FROM genre_ranking
		WHERE ranking <= 3)
	-- Step 1b. ... and whose movies has >8 average rating 
	AND avg_rating > 8
	GROUP BY name)
    
-- Step 2. From the CTE above, who are the top 3?
SELECT director_name, movie_count FROM director_ranking
WHERE director_rank <= 3
;
-- --> The result for the top 3 are actually 4 directors, since there were tie for the 2nd place



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
WITH actor_ranking AS (
    SELECT name AS actor_name, COUNT(name) AS movie_count, 
    RANK() OVER(ORDER BY COUNT(name) DESC) AS actor_rank
    FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id 
    INNER JOIN role_mapping rm USING(movie_id)
    INNER JOIN names n ON rm.name_id=n.id
    WHERE category = 'actor'
    AND median_rating >= 8
    GROUP BY name
    ORDER BY COUNT(name) DESC
    )
SELECT actor_name, movie_count 
FROM actor_ranking
WHERE actor_rank <=2;


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
WITH prodcom_ranking AS (
    SELECT production_company, SUM(total_votes) AS vote_count,
    RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prodcom_rank
    FROM movie m INNER JOIN ratings r ON m.id = r.movie_id 
    WHERE production_company != 'None'
    GROUP BY production_company
    )
SELECT *
FROM prodcom_ranking
WHERE prodcom_rank <=3
ORDER BY vote_count DESC;

/* Top 3 are: 
- Marvel Studios
- Twentieth Century Fox
- Warner Bros.
*/
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
SELECT 
    name AS actor_name, 
    SUM(total_votes) AS total_votes, 
    COUNT(name) AS movie_count, 
    -- weighted average rating = sum of(rating per movie *votes per movie) / (total votes from all movie)
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating,
    RANK() OVER (
        -- rank with average rating
        ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC, 
        -- use sum of total votes as tie breaker
        SUM(total_votes) DESC
        ) AS actor_rank
FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id 
    INNER JOIN role_mapping rm USING(movie_id)
    INNER JOIN names n ON rm.name_id=n.id
    
-- filter: actor, in India, at least 5 movies
WHERE category = 'actor' AND country like '%India%'
GROUP BY actor_name
HAVING movie_count >=5;


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
SELECT 
    name AS actress_name, 
    SUM(total_votes) AS total_votes, 
    COUNT(name) AS movie_count, 
    -- weighted average rating = sum of(rating per movie *votes per movie) / (total votes from all movie)
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
    RANK() OVER (ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC, SUM(total_votes) DESC) AS actress_rank
FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id 
    INNER JOIN role_mapping rm USING(movie_id)
    INNER JOIN names n ON rm.name_id=n.id
-- filter: actress, released in India, in Hindi language, at least 3 movies
WHERE category = 'actress'
	AND country like '%India%'
	AND languages like '%Hindi%'
GROUP BY name
HAVING movie_count >=3
LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title AS thriller_title, avg_rating,
CASE
    WHEN avg_rating > 8 THEN 'Superhit movies'
    WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
    WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
    ELSE 'Flop Movies'
    END AS rating_category
FROM movie m
INNER JOIN genre g ON m.id=g.movie_id
INNER JOIN ratings r ON m.id=r.movie_id
WHERE genre = 'Thriller';



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
SELECT 
    genre, 
    ROUND(AVG(duration),2) AS avg_duration, 
    ROUND(SUM(AVG(duration)) OVER(ORDER BY genre),2) AS running_total_duration,
    ROUND(AVG(AVG(duration)) OVER(ORDER BY genre),2) AS moving_avg_duration
FROM movie m
INNER JOIN genre g ON m.id = g.movie_id
GROUP BY genre;


-- Round is good to have and not a must have; Same thing applies to sorting


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

-- APPROACH 1:
WITH 
-- Step1. Convert gross income from inr to usd (USD 1 ~ INR 80), remove currency symbol
gross_income_converted AS (
   SELECT genre, year, title AS movie_name,
-- convert INR to USD
CASE
    WHEN worlwide_gross_income LIKE '%INR%' THEN REPLACE(worlwide_gross_income, 'INR ','')/80
    ELSE REPLACE(worlwide_gross_income, '$ ','')/1
END AS worlwide_gross_income
FROM movie m INNER JOIN genre g ON m.id=g.movie_id
WHERE worlwide_gross_income IS NOT NULL
-- in top 3 genres
AND genre IN (
    SELECT genre FROM (
    SELECT genre, COUNT(genre) as movie_count,
    RANK() OVER(ORDER BY COUNT(genre) DESC) AS genre_rank
    FROM movie m INNER JOIN genre g ON m.id=g.movie_id
    GROUP BY genre) AS genre_ranking
    WHERE genre_rank <=3)
ORDER BY worlwide_gross_income desc    
),
-- Step 2. Use the converted income above for ranking
movie_ranking_by_year AS (
    SELECT *,
    DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
    FROM gross_income_converted
)
-- Step 3. Use the ranking from step 2, filter rank 1-5
SELECT genre,year,movie_name, CONCAT('$ ', worlwide_gross_income) AS worlwide_gross_income,movie_rank
FROM movie_ranking_by_year
WHERE movie_rank <=5
ORDER BY year, movie_rank;

-- --> We see some duplicates because the same movie can have multiple genres.

-- APPROACH 2: same as approach 1 but use GROUP_CONCAT at the last step to combine genres from duplicates into 1 row:
WITH 
-- Step1. Convert gross income from inr to usd, assuming USD 1 ~ INR 80
gross_income_converted AS (
   SELECT genre, year, title AS movie_name,
    -- convert INR to USD
    CASE
        WHEN worlwide_gross_income LIKE '%INR%' THEN REPLACE(worlwide_gross_income, 'INR ','')/80
        ELSE REPLACE(worlwide_gross_income, '$ ','')/1
    END AS worlwide_gross_income
    FROM movie m INNER JOIN genre g ON m.id=g.movie_id
    WHERE worlwide_gross_income IS NOT NULL
    -- in top 3 genres
    AND genre IN (
        SELECT genre FROM (
        SELECT genre, COUNT(genre) as movie_count,
        RANK() OVER(ORDER BY COUNT(genre) DESC) AS genre_rank
        FROM movie m INNER JOIN genre g ON m.id=g.movie_id
        GROUP BY genre) AS genre_ranking
        WHERE genre_rank <=3)
    order by worlwide_gross_income desc    
),
-- Step 2. Use the converted income above for ranking
movie_ranking_by_year AS (
    SELECT *,
    DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
    FROM gross_income_converted
)

-- Step 3. Use the ranking from step 2, filter rank 1-5. 
-- Also use GROUP_CONCAT to combine genres from duplicates into 1 row (may not work outside MySQL)
SELECT 
    GROUP_CONCAT(genre) as genre, 
    GROUP_CONCAT(distinct year) as year, 
    movie_name, 
    CONCAT('$ ', GROUP_CONCAT(distinct worlwide_gross_income)) AS worlwide_gross_income,
    GROUP_CONCAT(distinct movie_rank) AS movie_rank

FROM movie_ranking_by_year
WHERE movie_rank <=5
GROUP BY movie_name
ORDER BY year, movie_rank;

/* --> the result now displayed a lot neater. 
- "Zhan lang II" and "Joker", 2 multi-genre movies, now do not show duplicate.
- group_concat is a MySQL-only function, so it might not work for other management system. 
- On other system, approach 1 is the safer code.
*/



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

WITH prod_comp_ranking AS (
    SELECT production_company, COUNT(title) AS movie_count,
    RANK() OVER(ORDER BY COUNT(production_company) DESC) AS prod_comp_rank
    FROM movie m INNER JOIN ratings r ON m.id = r.movie_id
    WHERE languages LIKE '%,%'
    AND median_rating >= 8
    GROUP BY production_company
    )
SELECT * FROM prod_comp_ranking
WHERE prod_comp_rank <=2;



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

/*
The question did not specify whether we should use weighted average.
So here is the approach:
- Ranking base on the number of Super Hit movie count (NOT actress_avg_rating OR total_votes)
- average rating NOT based on total votes (not weighted average)
- There is NO tie breaker
*/

WITH actress_ranking AS (
    SELECT 
		name AS actress_name, 
		SUM(total_votes) AS total_votes, 
        COUNT(name) AS movie_count, 
        AVG(avg_rating) AS actress_avg_rating,
    RANK() OVER(ORDER BY COUNT(name) DESC) AS actress_rank
    FROM movie m 
    INNER JOIN ratings r ON m.id = r.movie_id 
    INNER JOIN genre g using(movie_id)
    INNER JOIN role_mapping rm using(movie_id)
    INNER JOIN names n on rm.name_id = n.id
    -- filter: actresses, in movies average rating >8, in drama genre
    WHERE category = 'actress'
    AND genre = 'Drama'
    AND avg_rating > 8
    GROUP BY actress_name
    )
SELECT * FROM actress_ranking
WHERE actress_rank <=3;

/*
We have 4 actresses tie for the first place, as we ranked them based on the number of movies they appeared in. 
*/



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

-- Step 1. Rank the director id base on the total number of movies
WITH director_ranking AS (
    SELECT name_id, COUNT(movie_id) as movie_count,
    RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS director_rank
    FROM director_mapping
    GROUP BY name_id
    ),

    -- Step 2. Calculate the inter movie days for movies from the top director_ids calculated in step 1
    top_9_directors_movies_info AS (
    SELECT 
        name_id, name, movie_id, duration, avg_rating, total_votes, date_published,
        Datediff(Lead(date_published,1) OVER(PARTITION BY name_id ORDER BY date_published,movie_id ), date_published) 
        AS inter_movie_days
    FROM movie m
    INNER JOIN director_mapping dm on m.id = dm.movie_id
    INNER JOIN names n on dm.name_id = n.id
    INNER JOIN ratings r using(movie_id)
    WHERE name_id IN (SELECT name_id FROM director_ranking WHERE director_rank <=9)
    ORDER BY name_id,inter_movie_days)

-- Step 3. Aggregate the details from step 2
SELECT 
    name_id AS director_id, 
    name AS director_name, 
    COUNT(name_id) AS number_of_movies,
    ROUND(AVG(inter_movie_days),1) AS avg_inter_movie_days,
    ROUND(AVG(avg_rating),2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM top_9_directors_movies_info
GROUP BY name_id
ORDER BY number_of_movies DESC;

-- End of submission. Thank you.






