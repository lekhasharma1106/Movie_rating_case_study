USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 'movie' AS table_name ,COUNT(id) AS record_count FROM movie 
UNION ALL 
SELECT 'genre' AS table_name ,COUNT(movie_id) AS record_count FROM genre 
UNION ALL 
SELECT 'director_mapping' AS table_name ,COUNT(movie_id) AS record_count FROM director_mapping 
UNION ALL 
SELECT 'role_mapping' AS table_name ,COUNT(movie_id) AS record_count FROM role_mapping 
UNION ALL 
SELECT 'names' AS table_name ,COUNT(id) AS record_count FROM names 
UNION ALL 
SELECT 'ratings' AS table_name ,COUNT(movie_id) AS record_count FROM ratings ;

/*
Note: columns used in count function is not having null values. so used them instead of * to get optimized query
table_name 	record_count
==========	============
movie	7997
genre	14662
director_mapping	3867
role_mapping	15615
names	25735
ratings	7997
Above are the total number of records in each table */


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	SUM(ISNULL(id)) AS id ,
	SUM(ISNULL(title)) AS title ,
    SUM(ISNULL(year)) AS year ,
	SUM(ISNULL(date_published)) AS date_published ,
	SUM(ISNULL(duration)) AS duration ,
    SUM(ISNULL(country)) AS country ,
	SUM(ISNULL(worlwide_gross_income)) AS worlwide_gross_income ,
	SUM(ISNULL(languages)) AS languages ,
    SUM(ISNULL(production_company)) AS production_company
FROM movie;

/* columns with values 0 are those which are not having null values in those columns 
 and other columns(country,worlwide_gross_income,languages,production_company) are having certain number of null values. */



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

-- number of movies released by each year

SELECT 
	Year 
	,COUNT(id) AS number_of_movies 
FROM movie 
GROUP BY Year;

/* (2017->3052 Movies),(2018->2944 Movies),(2019->2001 Movies)
 Movie releases are decreasing as years are progressing */

-- number of movies released by month wise

SELECT 
	MONTH(date_published) AS month_num
	,COUNT(id) AS number_of_movies 
FROM movie 
GROUP BY month_num
ORDER BY month_num ASC;

/*12	438,7	493,6	580
11	625,5	625,2	640,8	678,4	680
10	801,1	804,9	809,3	824
1. Most number of movies are release in March,Sep,Jan,Oct 
(from mid of March, it is end of academic year or summer holidays.
Jan is festival or holiday month.
so most number of audience are tend to watch the movies and it is expected to have high number of releases)
2. least number of movies are released in December , July,Jun 
(as Jun & July are Acadmic starting months.so less number of audience are tend to watch the movies.
so, it is expected to have less releases)
3. remaining months are having moderate number of movie releases*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
	COUNT(id) AS India_or_USA_movies -- 1059 movies are released in India or USA or both
FROM 
	movie
WHERE 
	year=2019 
	AND country REGEXP '(India|USA)';

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT genre FROM genre GROUP BY genre;

/* Drama,Fantasy,Thriller,Comedy,Horror,Family,
Romance,Adventure,Action,Sci-Fi,Crime,Mystery,Others
are 13 unique genre values in genre table 
Note: In the order of execution of query, GROUP BY executes first and distinct executes later,
to optimize the query further I used group by instead of distinct*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,year,COUNT(id) AS number_of_movies 
FROM movie m 
	INNER JOIN genre g ON m.id=g.movie_id
-- WHERE year = 2019 -- 2019 is the last year in the dataset
GROUP BY genre,year
ORDER BY number_of_movies DESC;

/* As comment is asking from last year and question is asking for overall irrespective of year.
so.I included year in the query to accomodate the comment analysis.
we just have to remove year in both select and group by clause to answer the question(movies produced overall).
but in both the cases Drama genre had the highest number of movies */


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre_movies_list AS (
SELECT 
	movie_id
	,COUNT(genre) AS number_of_genres
FROM movie m 
	INNER JOIN genre g ON m.id=g.movie_id
GROUP BY movie_id
HAVING number_of_genres=1
)
SELECT COUNT(movie_id) AS no_of_movies_with_single_genre FROM one_genre_movies_list;
-- 3289 movies are having only one genre


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

SELECT genre,ROUND(AVG(duration),0) AS avg_duration
FROM movie m 
	INNER JOIN genre g ON m.id=g.movie_id
GROUP BY genre;

/* the average duration of the genres range from 93 to 113 minutes and
average duration of Drama genre is 107 minutes 
Note: according to the output format shown in above comments, we rounded the average duration to 0 decimal points.
but in below question,Drama genre average duration is mentioned as 106.77 with rounding it to 2 decimal points .
to get the same result please use ROUND(AVG(duration),2) instead of ROUND(AVG(duration),0) in select clause */


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
WITH genre_rank_based_on_movie_count AS (
SELECT 
	genre
	,COUNT(movie_id) AS movie_count
    ,RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM movie m 
	INNER JOIN genre g 
		ON m.id=g.movie_id
GROUP BY genre 
)
SELECT 
	genre
	,movie_count
    ,genre_rank 
FROM genre_rank_based_on_movie_count
WHERE genre='Thriller';
/*
genre, movie_count, genre_rank
Thriller, 1484, 3
Thriller is of 3rd rank with 1484 overall movies for all years(2017,2018,2019) in the dataset */


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
	ROUND(min(avg_rating),0) AS min_avg_rating 
	,ROUND(max(avg_rating),0) AS max_avg_rating 
    ,ROUND(min(total_votes),0) AS min_total_votes
    ,ROUND(max(total_votes),0) AS max_total_votes
    ,ROUND(min(median_rating),0) AS min_median_rating
    ,ROUND(max(median_rating),0) AS min_median_rating -- output format given  is having min_median_rating even though it is max,I am leaving as per the output format.
FROM ratings;

/*
# min_avg_rating, max_avg_rating, min_total_votes, max_total_votes, min_median_rating, max_median_rating
1.0, 10.0, 100, 725138, 1, 10
minimum and maximum of average rating are from 1 to 10
minimum and maximum of total number of votes are from 100 to 725138
minimum and maximum of median rating are from 1 to 10
*/

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

WITH movie_rankings AS (
SELECT 
	title
	,avg_rating
    ,RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM
	movie m
    INNER JOIN ratings r
		ON m.id=r.movie_id
)
SELECT 
	title
	,avg_rating
    ,movie_rank
FROM movie_rankings
WHERE  movie_rank<=10;
 /* 
rank-number of movies-cumulative number of movies
1st  -	2 	-	2
3rd  -	1	-	3
4th  -	1	-	4
5th  -	2	-	6
7th  -	3	-	9
10th -  5	-	14
Note: 1. Rank function skips some rank places as previous rank is occupied by more than 1 movie.
	  2. Eventhough top 10 movies are asked in the question, we are getting 14 movies as the 10th rank place is 
        occupied by 5 movies.
	  3. Muliple movies can have same ratings
*/


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

SELECT 
	median_rating	
	,COUNT(movie_id) AS movie_count 
FROM ratings r 
GROUP BY median_rating
ORDER BY movie_count ASC; 
/*
1. medium to above medium ratings(5,6,7,8) are most commanly given to the movies.
2. low(1,2,3,4) and high(9,10) ratings are less commanly given to the movies.
*/



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
WITH production_company_rank AS (
SELECT 
	production_company
	,COUNT(movie_id) AS movie_count
    ,RANK() OVER( ORDER BY COUNT(movie_id) DESC) AS prod_company_rank
FROM movie m 
	INNER JOIN ratings r 
		ON m.id=r.movie_id 
WHERE 
	avg_rating > 8 
	AND production_company IS NOT NULL -- to filter out valid or known production company
GROUP BY production_company
)
SELECT 
	production_company
	,movie_count
	,prod_company_rank 
FROM production_company_rank 
WHERE prod_company_rank=1;

/*Below are 2 top production companys with 3 number of hit movies(avg_rating>8)
production_company, movie_count, prod_company_rank
Dream Warrior Pictures, 3, 1
National Theatre Live, 3, 1

RSVP company can partner with either Dream Warrior Pictures company or National Theatre Live company or both
to increse it's chances to deliver a hit movie.
*/


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

SELECT 
	genre
	,COUNT(id) AS movie_count
FROM movie m 
	INNER JOIN genre g ON m.id=g.movie_id
	INNER JOIN ratings r ON m.id=r.movie_id
WHERE 
	year = 2017 
	AND MONTHNAME(date_published) = 'MARCH' 
	AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC; -- order by is used to find the genre with highest number of movies

/* Drama ,Thriller and Action are top 3 genres in MARCH 2017 with more than 1000 people voted. */





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

SELECT 
	title,
    avg_rating,
	genre
FROM movie m 
	INNER JOIN genre g ON m.id=g.movie_id
	INNER JOIN ratings r ON m.id=r.movie_id
WHERE 
	title LIKE 'The%' AND -- title starts with 'The' condition
	avg_rating > 8 ; 


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(id) AS movie_count -- 361 movies are given medain rating of 8 which are released between 1 April 2018 and 1 April 2019.
FROM movie m 
	INNER JOIN ratings r 
		ON m.id=r.movie_id
WHERE 
	date_published BETWEEN '2018-04-01' AND '2019-04-01'
	AND median_rating = 8 ;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH all_german_movie_votes AS (
SELECT 'German' AS movie_language,
	    SUM(total_votes) AS total_votes
FROM movie m 
	INNER JOIN ratings r 
		ON m.id = r.movie_id
WHERE languages REGEXP 'German' -- languages column value contains german
)
, all_italian_movie_votes AS (
SELECT 'Italian' AS movie_language,
	    SUM(total_votes) AS total_votes
FROM movie m 
	INNER JOIN ratings r 
		ON m.id = r.movie_id
WHERE languages REGEXP 'Italian' -- lanuages column value contains Italian
)
SELECT movie_language,total_votes FROM all_german_movie_votes
UNION ALL
SELECT movie_language,total_votes FROM all_italian_movie_votes;

/*
movie_language, total_votes
German, 4421525
Italian, 2559540
yes, German movies got more votes compared to Italian movies
*/
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
	SUM(ISNULL(name)) AS name_nulls ,
    SUM(ISNULL(height)) AS height_nulls ,
	SUM(ISNULL(date_of_birth)) AS date_of_birth_nulls ,
	SUM(ISNULL(known_for_movies)) AS known_for_movies_nulls 
FROM names;

-- By running above query we can see name column does not have null values where as other columns have null values.   
-- id column is primary key(conatins NOT NULL constraint),so id column doesn't contain any NULL values.



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

/***********Ranking the genre based on number of movie with avg_rating is more than 8*******/
WITH genre_rank AS (
SELECT g.genre
	   ,RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM genre g
	INNER JOIN movie m ON g.movie_id=m.id
    INNER JOIN ratings r ON m.id=r.movie_id
WHERE r.avg_rating>8
GROUP BY genre
)
/******Filtering top 3 genre by genre_rank cte*******/
,top3_genres AS (
SELECT genre FROM genre_rank WHERE genre_rank<=3
)
/******Ranking the director*************/
,director_rank AS (
SELECT name AS director_name, 
	   count(m.id) AS movie_count,
       RANK() OVER(ORDER BY count(m.id) DESC) AS director_rank
FROM movie m
	 INNER JOIN genre g ON m.id=g.movie_id
     INNER JOIN ratings r ON m.id=r.movie_id
     INNER JOIN director_mapping dm ON m.id=dm.movie_id
     INNER JOIN names n ON dm.name_id=n.id
WHERE avg_rating>8
	  AND genre in (SELECT genre FROM top3_genres)
GROUP BY name
)
/******Main Query*************/
SELECT director_name,movie_count FROM director_rank WHERE director_rank<=3;







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
WITH actor_rank AS (
SELECT nm.name AS actor_name,
       Count(role_map.movie_id) AS movie_count
       ,RANK() OVER( ORDER BY Count(role_map.movie_id) DESC) AS actor_rank 
FROM   names nm
       INNER JOIN role_mapping role_map 
				ON nm.id = role_map.name_id
       INNER JOIN movie m 
				ON role_map.movie_id = m.id
       INNER JOIN ratings rate 
				ON rate.movie_id = role_map.movie_id
WHERE  category = 'actor'
       AND rate.median_rating >= 8
GROUP  BY nm.name
)
SELECT actor_name,movie_count FROM actor_rank WHERE actor_rank<=2;
-- By executing the above query we can say that mammootty and mohanlal have highest median rating.
-- We can conclude these actors can be more productive.




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

WITH prod_comp_rank AS (
SELECT     production_company,
           Sum(total_votes) AS vote_count,
           Rank() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings rate
ON         m.id=rate.movie_id
GROUP BY   production_company
)
SELECT production_company,vote_count,prod_comp_rank FROM prod_comp_rank WHERE prod_comp_rank<=3;


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
SELECT n.NAME AS actor_name,
       sum(total_votes) AS total_votes,
       Count(r.movie_id)  AS movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating, -- calculating weighted average on total votes
	   Rank() OVER(ORDER BY Sum(avg_rating * total_votes) / Sum(total_votes) DESC,total_votes DESC) AS actor_rank
       
FROM   movie m
       INNER JOIN role_mapping role_map ON m.id = role_map.movie_id
       INNER JOIN ratings r ON m.id = r.movie_id
       INNER JOIN names n ON n.id = role_map.name_id
WHERE  category = 'actor'
       AND country LIKE '%India%' 
GROUP  BY actor_name
HAVING Count(r.movie_id) >= 5; 

-- As output format shows more number of records I am not filtering on actor_rank by 1 but by seeing result we can easily Vijay Sethupathi is top on the list

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

WITH actress_rank AS (
SELECT n.NAME AS actress_name,
       total_votes,
       Count(r.movie_id) AS movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating, -- calculating weighted average on total votes
	   Rank() OVER(ORDER BY Sum(avg_rating * total_votes) / Sum(total_votes) DESC,total_votes DESC) AS actress_rank
FROM   movie m
       INNER JOIN role_mapping role_map ON m.id = role_map.movie_id
       INNER JOIN ratings r ON m.id = r.movie_id
       INNER JOIN names n ON n.id = role_map.name_id
WHERE  category = 'actress'
       AND country LIKE '%India%' 
       AND languages LIKE '%Hindi%' 
GROUP  BY actress_name
HAVING Count(r.movie_id) >= 3  
)
SELECT actress_name,total_votes,movie_count,actress_avg_rating,actress_rank
FROM actress_rank
WHERE actress_rank<=5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
/*HERE we are using CASE statements to get the average rating of movies*/
SELECT 
    title AS movie_name,
    avg_rating,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop Movies'
    END AS avg_rating_category
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    genre = 'thriller';


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
	ROUND(SUM(AVG(duration)) OVER w,2) AS running_total_duration,
	ROUND(AVG(AVG(duration)) OVER w,2) AS moving_avg_duration
FROM movie m
	INNER JOIN genre g ON m.id = g.movie_id
GROUP BY genre
WINDOW w AS (ORDER BY genre ASC); -- Assuming genre wise means alphabetical order of genre

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

-- Top 3 Genres based on most number of movies

WITH top3_genre AS (
SELECT genre
FROM (
	SELECT
		genre,
		RANK() OVER(ORDER BY COUNT(movie_id) DESC) as genre_rank
	FROM genre
	GROUP BY genre
	) rank_genre
WHERE genre_rank<=3
)
,currency_conversion AS (
SELECT
	genre,
	YEAR,
	title as movie_name,
    CASE WHEN SUBSTRING_INDEX( worlwide_gross_income , ' ' ,1)='INR' THEN CAST(SUBSTRING_INDEX( worlwide_gross_income , ' ' ,-1)/81.42 AS float)
    -- converting INR to $ based on 1 $= 81.42 INR on April 12,2022 AS worlwide_gross_income column value contains  both INR and $ currencies 
    ELSE CAST(SUBSTRING_INDEX( worlwide_gross_income , ' ' ,-1) AS float) END AS worlwide_gross_income
FROM movie m
	INNER JOIN genre g ON m.id = g.movie_id
WHERE genre IN (SELECT genre FROM top3_genre)
)
,top_movies AS (
SELECT  genre
		,year
        ,movie_name
        ,CONCAT('$ ' ,worlwide_gross_income) AS worlwide_gross_income
        ,RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM currency_conversion
)
SELECT  genre
		,year
        ,movie_name
        ,worlwide_gross_income
        ,movie_rank
FROM top_movies
WHERE movie_rank<=5;


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
WITH rank_production_company AS (
SELECT
production_company,
COUNT(id) as movie_count,
RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE median_rating>=8
AND production_company IS NOT NULL -- to get the valid production company names
AND POSITION(',' IN languages)>0 
GROUP BY production_company
)
SELECT production_company
	   ,movie_count
       ,prod_comp_rank 
FROM rank_production_company 
WHERE prod_comp_rank<=2;

-- Star Cinema,Twentieth Century Fox  are top production houses to tie up with, to increase the chances of delivering the hit multilingual movies in that order

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

WITH actress_summary AS
(
SELECT  n.NAME AS actress_name,
		SUM(total_votes) AS total_votes,
		Count(r.movie_id) AS movie_count,
		Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating, -- using the weighted average rating as nothing is mentioned in the question
		Rank() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank -- using the weighted average rating for ranking purpose as nothing is mentioned in the question
FROM  movie AS m
	INNER JOIN ratings AS r
		ON  m.id=r.movie_id
	INNER JOIN role_mapping AS rm
		ON m.id = rm.movie_id
	INNER JOIN names AS n
		ON rm.name_id = n.id
	INNER JOIN GENRE AS g
		ON g.movie_id = m.id
WHERE category = 'ACTRESS'
AND  avg_rating>8
AND genre = "Drama"
GROUP BY   NAME )
SELECT  actress_name
		,total_votes
        ,movie_count
        ,actress_avg_rating
        ,actress_rank
FROM  actress_summary
WHERE actress_rank<=3;


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

WITH next_date_published_summary AS (
SELECT d.name_id
	   ,NAME
       ,d.movie_id
       ,duration
       ,r.avg_rating
       ,total_votes
       ,m.date_published,
	   Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published ASC,movie_id ASC) AS next_date_published
FROM director_mapping AS d
	 INNER JOIN names AS n ON  n.id = d.name_id
	 INNER JOIN movie AS m ON  m.id = d.movie_id
	 INNER JOIN ratings AS r ON r.movie_id = m.id 
)

,top_director_summary AS (
SELECT *,
	   Datediff(next_date_published, date_published) AS date_difference
FROM next_date_published_summary 
)

,top_directors_details AS (
SELECT name_id AS director_id,
	   NAME AS director_name,
	   Count(movie_id) AS number_of_movies,
       Round(Avg(date_difference),0) AS avg_inter_movie_days,
	   Round(Avg(avg_rating),2) AS avg_rating,
	   Sum(total_votes) AS total_votes,
	   Min(avg_rating)  AS min_rating,
	   Max(avg_rating)  AS max_rating,
	   Sum(duration)  AS total_duration,
       RANK() OVER(ORDER BY Count(movie_id) DESC) AS director_rank 
FROM top_director_summary
GROUP BY director_id
)

SELECT director_id
	   ,director_name
       ,number_of_movies
       ,avg_inter_movie_days,
	   avg_rating
       ,total_votes
       ,min_rating
       ,max_rating
       ,total_duration
FROM top_directors_details
WHERE director_rank <= 9; 





