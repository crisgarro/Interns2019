USE [InternDB]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 8/14/2018 8:36:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[accountID] [int] IDENTITY(1,1) NOT NULL,
	[accountTypeID] [int] NOT NULL,
	[accountBalance] [decimal](30, 12) NOT NULL,
	[accountInterestRate] [decimal](30, 12) NOT NULL,
	[accountOverdraft] [decimal](30, 12) NOT NULL,
	[accountLastAccessTimestamp] [datetime] NULL,
	[accountEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[accountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountType]    Script Date: 8/14/2018 8:36:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountType](
	[accountTypeID] [int] IDENTITY(1,1) NOT NULL,
	[accountType] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_AccountType] PRIMARY KEY CLUSTERED 
(
	[accountTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 8/14/2018 8:36:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[customerID] [int] IDENTITY(1,1) NOT NULL,
	[customerName] [nvarchar](255) NOT NULL,
	[customerAddress] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerAccount]    Script Date: 8/14/2018 8:36:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerAccount](
	[customerAccountID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[accountID] [int] NOT NULL,
	[customerAccountTimestamp] [datetime] NULL,
 CONSTRAINT [PK_CustomerAccount] PRIMARY KEY CLUSTERED 
(
	[customerAccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TransactionType]    Script Date: 8/14/2018 8:36:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionType](
	[transactionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[transactionType] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_TransactionType] PRIMARY KEY CLUSTERED 
(
	[transactionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trasaction]    Script Date: 8/14/2018 8:36:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trasaction](
	[transactionID] [int] IDENTITY(1,1) NOT NULL,
	[transactionTypeID] [int] NOT NULL,
	[accountID] [int] NOT NULL,
	[transactionAmount] [decimal](30, 12) NOT NULL,
	[transactionTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Trasaction] PRIMARY KEY CLUSTERED 
(
	[transactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF__Account__account__619B8048]  DEFAULT ((0)) FOR [accountBalance]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF__Account__account__628FA481]  DEFAULT ((0)) FOR [accountInterestRate]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF__Account__account__6383C8BA]  DEFAULT ((0)) FOR [accountOverdraft]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF__Account__account__6477ECF3]  DEFAULT (getutcdate()) FOR [accountLastAccessTimestamp]
GO
ALTER TABLE [dbo].[CustomerAccount] ADD  DEFAULT (getutcdate()) FOR [customerAccountTimestamp]
GO
ALTER TABLE [dbo].[Trasaction] ADD  CONSTRAINT [DF__Trasactio__trans__45F365D3]  DEFAULT ((0)) FOR [transactionAmount]
GO
ALTER TABLE [dbo].[Trasaction] ADD  CONSTRAINT [DF__Trasactio__trans__46E78A0C]  DEFAULT (getutcdate()) FOR [transactionTimestamp]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_AccountType] FOREIGN KEY([accountTypeID])
REFERENCES [dbo].[AccountType] ([accountTypeID])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Account_AccountType]
GO
ALTER TABLE [dbo].[CustomerAccount]  WITH CHECK ADD  CONSTRAINT [FK_CustomerAccount_Account] FOREIGN KEY([accountID])
REFERENCES [dbo].[Account] ([accountID])
GO
ALTER TABLE [dbo].[CustomerAccount] CHECK CONSTRAINT [FK_CustomerAccount_Account]
GO
ALTER TABLE [dbo].[CustomerAccount]  WITH CHECK ADD  CONSTRAINT [FK_CustomerAccount_Customer] FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[CustomerAccount] CHECK CONSTRAINT [FK_CustomerAccount_Customer]
GO
ALTER TABLE [dbo].[Trasaction]  WITH CHECK ADD  CONSTRAINT [FK_Trasaction_Account] FOREIGN KEY([accountID])
REFERENCES [dbo].[Account] ([accountID])
GO
ALTER TABLE [dbo].[Trasaction] CHECK CONSTRAINT [FK_Trasaction_Account]
GO
ALTER TABLE [dbo].[Trasaction]  WITH CHECK ADD  CONSTRAINT [FK_Trasaction_TransactionType] FOREIGN KEY([transactionTypeID])
REFERENCES [dbo].[TransactionType] ([transactionTypeID])
GO
ALTER TABLE [dbo].[Trasaction] CHECK CONSTRAINT [FK_Trasaction_TransactionType]
GO
