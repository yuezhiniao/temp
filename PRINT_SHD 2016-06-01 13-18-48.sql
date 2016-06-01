USE [zbttfpf6]
GO

ALTER PROCEDURE dbo.PRINT_SHD
	 @billid INT
AS 
    SET nocount ON    
    
    IF EXISTS (SELECT * FROM dbo.BillDeliveryNote WITH(NOLOCK) WHERE Status<>6 AND BillID=@billid)
    BEGIN
		SELECT -1000,'集货未完成'
		RETURN
    END
       
    DECLARE @Memo1 varchar(500)    
    
    CREATE TABLE #tt
        (
          [BillCode] [varchar](16) ,
          [MakeTime] [datetime] ,
          [ListAmount] [int] ,--发票张数    
          [FCLAmount] [int] ,--整箱数    
          [LCLAmount] [int] ,--拼箱数    
          [TotalAmount] INT ,--合计数    
          [ReviewMan] [int] ,--复核人    
          [ReviewManName] [varchar](20) ,--复核人姓名    
          [Memo] [varchar](8000) ,--备注    
          [Maker] [int] ,--制单人    
          MakerName VARCHAR(20) , --制单人姓名    
          [ClientID] [int] ,--客户ID    
          ClientName [varchar](200) ,--单位名称    
          [WayID] [int] ,--路径内码    
          [WayName] [varchar](100) , --发货路径    
          Sums MONEY , --金额    
          Address VARCHAR(200) , --地址    
          SellCall VARCHAR(40) , --电话    
          [ColdAmount] [int] ,--冷件数    
	----钱坤 20100519     
          [specialamount] [int] ,--特殊件    
          TCMAmount [int] ,   --中药件数   Add by xuh 20110215 根据鸿泰要求添加    
          EquipAmount [int]  --器化件数    
	---------------------------------    
        )    
      
    INSERT  INTO #tt
            ( BillCode ,
              MakeTime ,
              ListAmount ,
              FCLAmount ,
              LCLAmount ,
              TotalAmount ,
              ReviewMan ,
              Memo ,
              Maker ,
              ClientID ,
              ColdAmount ,
              specialamount ,
              TCMAmount ,
              EquipAmount
            )
            SELECT  a.BillCode ,
                    a.MakeTime ,
                    a.ListAmount ,
                    a.FCLAmount ,
                    a.LCLAmount ,
                    a.FCLAmount + a.LCLAmount    
					--钱坤 20100519 总数=整件+散件+冷件+特殊药品件数    
                    + a.coldamount + a.specialamount + a.TCMAmount
                    + a.EquipAmount,    --合计总数还要加上中药,器化件数 add by xuh 20110215      
                    a.ReviewMan ,
                    a.Memo ,
                    a.Maker ,
                    a.ClientID ,
                    a.ColdAmount ,
                    a.specialamount ,
                    a.TCMAmount ,
                    a.EquipAmount
            FROM    BillDeliveryNote a WITH(NOLOCK) 
            WHERE   a.billid = @billid      
      
    UPDATE  a
    SET     a.ClientName = b.ClientName ,
            a.WayID = c.SendWay ,
            a.Address = b.Address ,
            a.SellCall = c.SellCall
    FROM    #tt a
            INNER JOIN ClientUnit b WITH(NOLOCK) ON a.ClientID = b.ClientID
            INNER JOIN CorpCustomInfo c WITH(NOLOCK) ON a.ClientID = c.ClientID    
    
    UPDATE  a
    SET     a.WayName = b.WayName
    FROM    #tt a
            INNER  JOIN SendWay b WITH(NOLOCK) ON a.WayID = b.WayID    
    
    UPDATE  a
    SET     a.MakerName = b.P_NAME
    FROM    #tt a
            INNER JOIN person b WITH(NOLOCK) ON a.maker = b.p_lsm    
    
    UPDATE  a
    SET     a.ReviewManName = b.P_NAME
    FROM    #tt a
            INNER JOIN person b WITH(NOLOCK) ON a.ReviewMan = b.p_lsm    
    
    DECLARE @Memo VARCHAR(8000)    
    SELECT  @Memo = REPLACE(REPLACE(( SELECT    billcode
                                      FROM      billsellheader N WITH(NOLOCK)
                                      WHERE     DeliveryID = @billid
                                    FOR
                                      XML AUTO
                                    ), '<N billcode="', ''), '"/>', ' ')   
                                    
    
    IF @Memo IS NULL 
    BEGIN
        --SET @Memo = ''
        
        SELECT @Memo = STUFF((SELECT DISTINCT ','+  b.BillCode 
		FROM dbo.WMSORDERITEMS i WITH(NOLOCK) 
		INNER JOIN dbo.WMSORDERLIST l WITH(NOLOCK) ON i.ListID = l.ListID
		INNER JOIN billsellheader b WITH(NOLOCK) ON CONVERT(VARCHAR,b.BillID)=i.BillCode
		WHERE l.DeliverID=@billid FOR XML PATH('')), 1,1,'')
    END    
    
    SELECT AreaID
    INTO #ttttt
	FROM dbo.WMSORDERITEMS i WITH(NOLOCK) 
	INNER JOIN dbo.WMSORDERLIST l WITH(NOLOCK) ON i.ListID = l.ListID
	INNER JOIN dbo.GoodsBaseInfo gb WITH(NOLOCK) ON i.GoodsID=gb.GoodsID
	WHERE l.DeliverID=@billid
	
	SET @Memo1 = ''
	IF EXISTS(SELECT * FROM #ttttt WHERE AreaID=4)
		SET @Memo1 = @Memo1+'【麻】'
	IF EXISTS(SELECT * FROM #ttttt WHERE AreaID=12)
		set @Memo1 =  @Memo1+'【冷】'
	IF EXISTS(SELECT * FROM #ttttt WHERE AreaID=15)
		 set @Memo1 = @Memo1+'【特】'
		 
    UPDATE  #tt
    SET     memo = CONVERT(VARCHAR(8000), memo + @Memo)    
    
    DECLARE @Sums MONEY     
    SELECT  @Sums = SUM(summoney)
    FROM    billsellheader WITH(NOLOCK)
    WHERE   DeliveryID = @billid    
    
    UPDATE  #tt
    SET     Sums = @Sums    
    
    UPDATE  BillDeliveryNote
    SET     Printer = 1
    WHERE   billid = @billid
            AND Printer = 0  

    IF EXISTS ( SELECT  *
                FROM    dbo.BillDeliveryNote WITH(NOLOCK) 
                WHERE   BillID = @billid
                        AND PrintTime IS NULL ) 
        BEGIN
            UPDATE  dbo.BillDeliveryNote
            SET     PrintTime = GETDATE()
            WHERE   BillID = @billid
        END
    
    SELECT BillCode,SUM(CASE WHEN l.BusiType=22 then -sums ELSE Sums end) moneys
    INTO #Money
	FROM dbo.WMSORDERITEMS i WITH(NOLOCK) 
	INNER JOIN dbo.WMSORDERLIST l WITH(NOLOCK) ON i.ListID = l.ListID
	WHERE l.DeliverID=@billid
	GROUP BY BillCode

    SELECT  'SH-'+ RIGHT(BillCode,8) BarCode,*, 
--    (select 
--	STUFF((SELECT ',' + BillCode    
--            FROM #Money  FOR XML PATH('')), 1,1,'')) AS Remark ,
    memo AS Remark,
     (SELECT SUM(moneys) Moneys FROM #Money) AS AllSum,
     @Memo1 AS GoodsType
    FROM    #tt    
    DROP TABLE #tt 
	DROP TABLE #Money