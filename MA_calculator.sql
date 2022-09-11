create Procedure [dbo].[MA_calculator]

	@date date
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @tem table(
		com varchar(10),
		ma real
	)

	insert into @tem select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code=stock_data.stock_code and date in (select Dates from find_date_4(@date,5,1,1)) group by stock_data.stock_code

	update stock_data set MA5 =ma from @tem as T1 where date =@date and stock_code=com

	delete from @tem 

	insert into @tem select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code=stock_data.stock_code and date in (select Dates from find_date_4(@date,10,1,1)) group by stock_data.stock_code

	update stock_data set MA10 =ma from @tem as T1 where date =@date and stock_code=com

	delete from @tem 

	insert into @tem select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code=stock_data.stock_code and date in (select Dates from find_date_4(@date,20,1,1)) group by stock_data.stock_code

	update stock_data set MA20 =ma from @tem as T1 where date =@date and stock_code=com

	delete from @tem

	insert into @tem select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code=stock_data.stock_code and date in (select Dates from find_date_4(@date,60,1,1)) group by stock_data.stock_code

	update stock_data set MA60 =ma from @tem as T1 where date =@date and stock_code=com

	delete from @tem

	insert into @tem select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code=stock_data.stock_code and date in (select Dates from find_date_4(@date,120,1,1)) group by stock_data.stock_code

	update stock_data set MA120 =ma from @tem as T1 where date =@date and stock_code=com

	delete from @tem

	insert into @tem select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code=stock_data.stock_code and date in (select Dates from find_date_4(@date,240,1,1)) group by stock_data.stock_code

	update stock_data set MA240 =ma from @tem as T1 where date =@date and stock_code=com

	delete from @tem
END