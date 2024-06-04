use AWS3;


CREATE PROCEDURE LOAD_DIM_TYPE 
AS 
INSERT INTO dbo.DIM_TYPE (type) 
SELECT DISTINCT source.type 
FROM [dbo].[netflix_titles] source 
	WHERE NOT EXISTS ( 
			SELECT 1 FROM DIM_TYPE dim 
			WHERE dim.type = source.type 
	); 
GO

EXEC LOAD_DIM_TYPE;
GO


CREATE PROCEDURE LOAD_DIM_DIRECTOR
AS 
INSERT INTO dbo.DIM_DIRECTOR (director) 
SELECT DISTINCT source.director
FROM [dbo].[netflix_titles] source 
	WHERE NOT EXISTS ( 
			SELECT 1 FROM DIM_DIRECTOR dim 
			WHERE dim.director = source.director
	); 
GO

EXEC LOAD_DIM_DIRECTOR;
GO



CREATE PROCEDURE LOAD_DIM_INFO
AS 
INSERT INTO dbo.DIM_INFO (title, listed_in,description,"cast" ) 
SELECT DISTINCT source.title, source.listed_in, source.description,source.cast
FROM [dbo].[netflix_titles] source 
	WHERE NOT EXISTS ( 
			SELECT 1 FROM DIM_INFO dim 
			WHERE dim.title = source.title
	); 
GO

EXEC LOAD_DIM_INFO;
GO

CREATE PROCEDURE LOAD_DIM_COUNTRY
AS 
INSERT INTO dbo.DIM_COUNTRY (country) 
SELECT DISTINCT source.country
FROM [dbo].[netflix_titles] source 
	WHERE NOT EXISTS ( 
			SELECT 1 FROM DIM_COUNTRY dim 
			WHERE dim.country = source.country
	); 
GO

EXEC LOAD_DIM_COUNTRY;
GO

CREATE PROCEDURE LOAD_DIM_DATE
AS 
INSERT INTO dbo.DIM_DATE (date, release_year) 
SELECT DISTINCT source.date, source.release_year
FROM [dbo].[netflix_titles] source 
	WHERE NOT EXISTS ( 
			SELECT 1 FROM DIM_date dim 
			WHERE dim.date = source.date
	); 
GO

EXEC LOAD_DIM_DATE;
GO

CREATE PROCEDURE LOAD_DIM_DURATION
AS 
INSERT INTO dbo.LOAD_DIM_DURATION (duration) 
SELECT DISTINCT source.duration
FROM [dbo].[netflix_titles] source 
	WHERE NOT EXISTS ( 
			SELECT 1 FROM LOAD_DIM_DURATION dim 
			WHERE dim.duration = source.duration
	); 
GO

EXEC LOAD_DIM_DURATION;
GO


CREATE PROCEDURE LOAD_DIM_RATING
AS 
INSERT INTO dbo.DIM_RATING (rating) 
SELECT DISTINCT source.rating
FROM [dbo].[netflix_titles] source 
	WHERE NOT EXISTS ( 
			SELECT 1 FROM DIM_RATING dim 
			WHERE dim.rating = source.rating
	); 
GO

EXEC LOAD_DIM_RATING;
GO

CREATE PROCEDURE LOAD_FACT_NETFLIX_SHOWS
AS
	INSERT INTO FACT_NETFLIX_SHOWS (show_id, info_id, type_id, director_id, country_id, date_id, rating_id,duration_id)
	SELECT show_id, info_id, type_id, director_id, country_id, date_id, rating_id, duration_id
	FROM [dbo].[netflix_titles] source
	LEFT JOIN DIM_INFO
	ON DIM_INFO.cast = source.cast
	AND DIM_INFO.description = source.description
	AND DIM_INFO.listed_in = source.listed_in
	AND DIM_INFO.title = source.title
	LEFT JOIN DIM_TYPE ON DIM_TYPE.type = source.type
	LEFT JOIN DIM_DIRECTOR ON DIM_DIRECTOR.director = source.director
	LEFT JOIN DIM_COUNTRY ON DIM_COUNTRY.country = source.country
	LEFT JOIN DIM_DATE
	ON DIM_DATE.date_added = source.date_added
	AND DIM_DATE.release_year = source.release_year
	LEFT JOIN DIM_RATING ON DIM_RATING.rating = source.rating
	LEFT JOIN DIM_DURATION ON DIM_DURATION. duration = source.duration
GO

EXEC LOAD_FACT_NETFLIX_SHOWS;