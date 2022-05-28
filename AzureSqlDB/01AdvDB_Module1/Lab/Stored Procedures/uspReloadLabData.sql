-- =========================
-- Author		: Harvey Hu
-- Created on	: 2022-5-25
-- Description	: 从外部数据源中，重新加载数据
-- =========================
CREATE PROCEDURE [lab].[uspReloadLabData]
	@object_name nvarchar(50) 
AS
SET  nocount  ON;

RETURN 0
