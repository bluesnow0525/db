USE [ncu_database]
GO
/****** Object:  UserDefinedFunction [dbo].[find_date_4]    Script Date: 2022/9/11 下午 09:16:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[find_date_4](@Date date,@NumberOfDay int, @today int, @cmd int)
RETURNS @finddate TABLE 
(
	Dates date
)
AS
BEGIN 
DECLARE @remaining_day int;
DECLARE @current_day int;
DECLARE @current_year INT
DECLARE @current_total_day INT

SELECT @current_day = day_of_stock FROM [dbo].[calendar] WHERE date = @Date AND day_of_stock != -1;
if(@current_day is NULL) RETURN
/*cmd=1時，天數往前數*/
IF(@cmd = 1)
	BEGIN
		SET @remaining_day = @current_day - @NumberOfDay;
		if(@today =0)
			SET @current_day=@current_day-1;

		IF(@remaining_day > 0)
			insert into @finddate SELECT date FROM [dbo].[calendar] WHERE day_of_stock BETWEEN @remaining_day AND @current_day AND year(date) = year(@Date);
		ELSE 
			BEGIN
			/*分析年份的細節並且找出哪幾天*/
				insert into  @finddate SELECT date FROM [dbo].[calendar] WHERE day_of_stock BETWEEN 0 AND @current_day AND year(date) = year(@Date);

				DECLARE cur CURSOR LOCAL for
				SELECT year, total_day FROM [dbo].[year_calendar] order by year ASC
				open cur

				FETCH next from cur into @current_year, @current_total_day
				WHILE @@FETCH_STATUS = 0 BEGIN
					SET @remaining_day = @remaining_day + @current_total_day;

					IF @remaining_day > 0 
						BEGIN
							insert into  @finddate SELECT date FROM [dbo].[calendar] WHERE day_of_stock BETWEEN @remaining_day AND @current_total_day AND year(date) = @current_year;
							BREAK
						END
					ELSE
						insert into @finddate SELECT date FROM [dbo].[calendar] WHERE day_of_stock BETWEEN 0 AND @current_total_day AND year(date) = @current_year;
					FETCH next from cur into @current_year, @current_total_day
				END
			END
	END
IF(@cmd = 0)
	BEGIN	
		SET @remaining_day = @current_day + @NumberOfDay;
		if(@today !=1)
			SET @current_day=@current_day+1;

		IF(@remaining_day > 0)
			insert into  @finddate SELECT date FROM [dbo].[calendar] WHERE day_of_stock BETWEEN @current_day AND @remaining_day  AND year(date) = year(@Date);
		ELSE 
			BEGIN
				insert into @finddate SELECT date FROM [dbo].[calendar] WHERE day_of_stock BETWEEN 0 AND @current_day AND year(date) = year(@Date);

				DECLARE cur CURSOR LOCAL for
				SELECT year, total_day FROM [dbo].[year_calendar] order by year ASC
				open cur

				FETCH next from cur into @current_year, @current_total_day
				WHILE @@FETCH_STATUS = 0 BEGIN
					SET @remaining_day = @remaining_day + @current_total_day;

					IF @remaining_day > 0 
						BEGIN
							insert into  @finddate SELECT date FROM [dbo].[calendar] WHERE day_of_stock BETWEEN @remaining_day AND @current_total_day AND year(date) = @current_year;
							BREAK
						END
					ELSE
						insert into @finddate SELECT date FROM [dbo].[calendar] WHERE day_of_stock BETWEEN 0 AND @current_total_day AND year(date) = @current_year;
					FETCH next from cur into @current_year, @current_total_day
				END
			END
	END
	RETURN
END