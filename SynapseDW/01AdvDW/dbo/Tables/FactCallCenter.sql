CREATE TABLE [dbo].[FactCallCenter] (
    [FactCallCenterID]    INT           IDENTITY (1, 1) NOT NULL,
    [DateKey]             INT           NOT NULL,
    [WageType]            NVARCHAR (15) NOT NULL,
    [Shift]               NVARCHAR (20) NOT NULL,
    [LevelOneOperators]   SMALLINT      NOT NULL,
    [LevelTwoOperators]   SMALLINT      NOT NULL,
    [TotalOperators]      SMALLINT      NOT NULL,
    [Calls]               INT           NOT NULL,
    [AutomaticResponses]  INT           NOT NULL,
    [Orders]              INT           NOT NULL,
    [IssuesRaised]        SMALLINT      NOT NULL,
    [AverageTimePerIssue] SMALLINT      NOT NULL,
    [ServiceGrade]        FLOAT (53)    NOT NULL,
    [Date]                DATETIME      NULL,
)
WITH (DISTRIBUTION=HASH([WageType]), CLUSTERED COLUMNSTORE INDEX);
