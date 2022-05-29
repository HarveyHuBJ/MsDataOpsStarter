

CREATE TABLE [Lab].[telecom_churn](
	[State] [nvarchar](50) NOT NULL,
	[Account_length] NVARCHAR(50) NOT NULL,
	[Area_code] NVARCHAR(50) NOT NULL,
	[International_plan] [nvarchar](50) NOT NULL,
	[Voice_mail_plan] [nvarchar](50) NOT NULL,
	[Number_vmail_messages] [nvarchar](50) NOT NULL,
	[Total_day_minutes] NVARCHAR(50) NOT NULL,
	[Total_day_calls] NVARCHAR(50) NOT NULL,
	[Total_day_charge] NVARCHAR(50) NOT NULL,
	[Total_eve_minutes] NVARCHAR(50) NOT NULL,
	[Total_eve_calls] NVARCHAR(50) NOT NULL,
	[Total_eve_charge] NVARCHAR(50) NOT NULL,
	[Total_night_minutes] NVARCHAR(50) NOT NULL,
	[Total_night_calls] NVARCHAR(50) NOT NULL,
	[Total_night_charge] NVARCHAR(50) NOT NULL,
	[Total_intl_minutes] NVARCHAR(50) NOT NULL,
	[Total_intl_calls] [nvarchar](50) NOT NULL,
	[Total_intl_charge] NVARCHAR(50) NOT NULL,
	[Customer_service_calls] [nvarchar](50) NOT NULL,
	[Churn] NVARCHAR(50) NOT NULL
) ON [PRIMARY]
GO

