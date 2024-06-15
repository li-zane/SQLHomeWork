/*
    2.1 分析在指定时间周期内一个省会城市的生产总值变化趋势与其所在省的趋势是否相似

    思路：
        - 查询指定省会城市在指定时间周期内的 GDP 变化趋势
        
        - 查询该省份在同一时间周期内的 GDP 变化趋势

        - 比较两个趋势
*/

CREATE PROCEDURE AnalyzeCityProvinceGDPTrend
    @ProvinceName NVARCHAR(100),
    @StartTime INT,
    @EndTime INT
AS
BEGIN
    -- 省会城市的 GDP 变化趋势
    SELECT Time, TotalGDP AS CityGDP
    FROM CityGDP, Cities
    WHERE CityGDP.ProvinceName = Cities.ProvinceName 
        AND CityGDP.CityName = Cities.CityName
        AND Cities.ProvinceName = @ProvinceName 
        AND Cities.isCapital = 1
        AND Time BETWEEN @StartTime AND @EndTime
    ORDER BY Time;

    -- 省份的 GDP 变化趋势
    SELECT Time, TotalGDP AS ProvinceGDP
    FROM ProvinceGDP
    WHERE ProvinceName = @ProvinceName AND Time BETWEEN @StartTime AND @EndTime
    ORDER BY Time;
END;

Exec AnalyzeCityProvinceGDPTrend '省份' '开始时间' '结束时间'

/*
    2.2 分析是否存在一些省会城市在指定时间周期的人均 GDP 低于其所在的省份

    思路：
        - 查询指定时间周期内的所有省会城市及其人均 GDP

        - 查询相同时间周期内各省的人均 GDP

        - 比较城市与所在省份的人均 GDP
        
*/

CREATE PROCEDURE AnalyzeCityProvincePerCapitaGDP
    @StartTime INT,
    @EndTime INT
AS
BEGIN
    -- 获取所有省会城市的人均 GDP
    SELECT C.ProvinceName, C.CityName, C.Time, C.PerCapitaGDP AS CityPerCapitaGDP, P.PerCapitaGDP AS ProvincePerCapitaGDP
    FROM CityGDP C
    JOIN ProvinceGDP P ON C.ProvinceName = P.ProvinceName AND C.Time = P.Time
    JOIN Cities CT ON C.CityName = CT.CityName AND C.ProvinceName = CT.ProvinceName
    WHERE CT.IsCapital = 1 AND C.Time BETWEEN @StartTime AND @EndTime;

    -- 找出人均 GDP 低于所在省份的人均 GDP 的省会城市
    SELECT *
    FROM
    (
        SELECT C.ProvinceName, C.CityName, C.Time, C.PerCapitaGDP AS CityPerCapitaGDP, P.PerCapitaGDP AS ProvincePerCapitaGDP
        FROM CityGDP C
        JOIN ProvinceGDP P ON C.ProvinceName = P.ProvinceName AND C.Time = P.Time
        JOIN Cities CT ON C.CityName = CT.CityName AND C.ProvinceName = CT.ProvinceName
        WHERE CT.IsCapital = 1 AND C.Time BETWEEN @StartTime AND @EndTime
    ) AS Subquery
    WHERE CityPerCapitaGDP < ProvincePerCapitaGDP;
END;

/*
    2.3 分析在新冠肺炎疫情三年（2020~2022）中，哪些省份在2020年GDP同比下降，2021年同比增加，2022年同比下降

    思路：
        - 选择2020~2022年数据

        - 计算每个省份的GDP同比变化

        - 找出符合条件的省份及其占比      
*/

CREATE PROCEDURE AnalyzeCovidImpactOnGDP
AS
BEGIN
    WITH GDPChanges AS (
        SELECT 
            ProvinceName,
            Time,
            TotalGDP,
            LAG(TotalGDP, 1) OVER (PARTITION BY ProvinceName ORDER BY Time) AS PrevYearGDP
        FROM 
            ProvinceGDP
        WHERE 
            Time BETWEEN 2019 AND 2022
    ),
    GDPComparison AS (
        SELECT 
            ProvinceName,
            Time,
            (TotalGDP - PrevYearGDP) / PrevYearGDP AS GDPChange
        FROM 
            GDPChanges
        WHERE 
            PrevYearGDP IS NOT NULL
    )
    SELECT 
        ProvinceName
    FROM 
        GDPComparison
    WHERE 
        (Time = 2020 AND GDPChange < 0)
        OR (Time = 2021 AND GDPChange > 0)
        OR (Time = 2022 AND GDPChange < 0)
    GROUP BY 
        ProvinceName
    HAVING 
        COUNT(*) = 3;

    -- Calculate the proportion of these provinces among all provinces
    DECLARE @TotalProvinces INT;
    DECLARE @AffectedProvinces INT;

    SELECT @TotalProvinces = COUNT(DISTINCT ProvinceName) FROM ProvinceGDP WHERE Time BETWEEN 2020 AND 2022;
    SELECT @AffectedProvinces = COUNT(DISTINCT ProvinceName) FROM GDPComparison WHERE (Time = 2020 AND GDPChange < 0) OR (Time = 2021 AND GDPChange > 0) OR (Time = 2022 AND GDPChange < 0) GROUP BY ProvinceName HAVING COUNT(*) = 3;

    SELECT 
        @AffectedProvinces AS AffectedProvinces,
        @TotalProvinces AS TotalProvinces,
        @AffectedProvinces * 100.0 / @TotalProvinces AS PercentageAffected;
END;


/*
    3.1 查询分析指定时间周期一个城市的第一、二、三产业的产值占比分布及其变化

    思路：
        - 查询指定城市在指定时间周期内的第一、二、三产业的产值及占比

        - 计算各产业的占比变化      
*/

CREATE PROCEDURE AnalyzeCityIndustryDistribution
    @CityName NVARCHAR(100),
    @StartTime INT,
    @EndTime INT
AS
BEGIN
    SELECT Time, CityName, 
           PrimaryIndustry, 
           SecondaryIndustry, 
           TertiaryIndustry,
           (PrimaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS PrimaryIndustryRatio,
           (SecondaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS SecondaryIndustryRatio,
           (TertiaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS TertiaryIndustryRatio
    FROM Industry
    WHERE CityName = @CityName AND Time BETWEEN @StartTime AND @EndTime
    ORDER BY Time;
END;

/*
    3.2 比较指定时间周期各城市的第一、二、三产业的产值占比

    思路：查询指定时间周期内所有城市的第一、二、三产业的产值及占比
*/

CREATE PROCEDURE CompareCityIndustryDistribution
    @StartTime INT,
    @EndTime INT
AS
BEGIN
    SELECT Time, CityName, ProvinceName, 
           PrimaryIndustry, 
           SecondaryIndustry, 
           TertiaryIndustry,
           (PrimaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS PrimaryIndustryRatio,
           (SecondaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS SecondaryIndustryRatio,
           (TertiaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS TertiaryIndustryRatio
    FROM Industry
    WHERE Time BETWEEN @StartTime AND @EndTime
    ORDER BY ProvinceName, CityName, Time;
END;

/*
    3.3 分析疫情对产业结构的影响，对哪种产业影响最严重

    思路：
        - 查询疫情前后的产业结构

        - 比较疫情前后各产业的变化情况

        - 找出哪些地区在疫情前后不符合“三二一”模式
*/

CREATE PROCEDURE AnalyzePandemicImpactOnIndustry
AS
BEGIN
    -- 疫情前(2019年)的产业结构
    SELECT ProvinceName, CityName, 
           (PrimaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS PrimaryIndustryRatio,
           (SecondaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS SecondaryIndustryRatio,
           (TertiaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS TertiaryIndustryRatio
    FROM Industry
    WHERE Time = 2019;

    -- 疫情后(2022年)的产业结构
    SELECT ProvinceName, CityName, 
           (PrimaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS PrimaryIndustryRatio,
           (SecondaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS SecondaryIndustryRatio,
           (TertiaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS TertiaryIndustryRatio
    FROM Industry
    WHERE Time = 2022;

    -- 不符合“三二一”模式的地区
    SELECT Time, ProvinceName, CityName,
           PrimaryIndustry, SecondaryIndustry, TertiaryIndustry,
           (PrimaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS PrimaryIndustryRatio,
           (SecondaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS SecondaryIndustryRatio,
           (TertiaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS TertiaryIndustryRatio
    FROM Industry
    WHERE (PrimaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) > 
          (SecondaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry))
       OR (PrimaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) > 
          (TertiaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry))
    ORDER BY Time, ProvinceName, CityName;
END;

/*
    3.4 分析在2020~2022年产业结构变化与湖北省最相似的三个省份

    思路：
        - 查询 2020 到 2022 年间湖北省的产业结构变化

        - 计算其他省份在同一时间段内的产业结构变化

        - 通过某种相似度度量方法找出与湖北省最相似的三个省份        
*/

CREATE PROCEDURE FindMostSimilarProvincesToHubei
AS
BEGIN
    -- 湖北省的产业结构变化
    SELECT Time, 
           (PrimaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS HubeiPrimaryRatio,
           (SecondaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS HubeiSecondaryRatio,
           (TertiaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS HubeiTertiaryRatio
    INTO #HubeiIndustry
    FROM Industry
    WHERE ProvinceName = '湖北省' AND Time BETWEEN 2020 AND 2022;

    -- 其他省份的产业结构变化
    SELECT ProvinceName, Time, 
           (PrimaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS PrimaryRatio,
           (SecondaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS SecondaryRatio,
           (TertiaryIndustry * 1.0 / (PrimaryIndustry + SecondaryIndustry + TertiaryIndustry)) AS TertiaryRatio
    INTO #OtherProvincesIndustry
    FROM Industry
    WHERE ProvinceName <> '湖北省' AND Time BETWEEN 2020 AND 2022;

    -- 计算相似度
    SELECT O.ProvinceName,
           AVG(ABS(O.PrimaryRatio - H.HubeiPrimaryRatio) + 
               ABS(O.SecondaryRatio - H.HubeiSecondaryRatio) + 
               ABS(O.TertiaryRatio - H.HubeiTertiaryRatio)) AS SimilarityScore
    FROM #OtherProvincesIndustry O
    JOIN #HubeiIndustry H ON O.Time = H.Time
    GROUP BY O.ProvinceName
    ORDER BY SimilarityScore ASC
    OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

    -- 清理临时表
    DROP TABLE #HubeiIndustry;
    DROP TABLE #OtherProvincesIndustry;
END;

-- =================================================
/*
    1.3 分析在新冠肺炎疫情三年(2020~2022)中，哪些省份社会消费品零售总额在2020年同比下降，2021年同比增加，2022年同比下降，计算这些省份在所有省份和直辖市的占比。湖北省在其中吗？

    思路：
        - 计算2020年、2021年、2022年的省份社会消费品零售总额同比增长率

        - 找出符合条件的省份

        - 计算符合条件的省份的占比

        - 检查湖北省是否在其中
*/

WITH RetailChange AS (
    SELECT
        ProvinceName,
        [2020] AS Retail2020,
        [2021] AS Retail2021,
        [2022] AS Retail2022,
        (Retail2020 - LAG(Retail2020, 1) OVER (PARTITION BY ProvinceName ORDER BY Time)) / NULLIF(LAG(Retail2020, 1) OVER (PARTITION BY ProvinceName ORDER BY Time), 0) AS Growth2020,
        (Retail2021 - Retail2020) / NULLIF(Retail2020, 0) AS Growth2021,
        (Retail2022 - Retail2021) / NULLIF(Retail2021, 0) AS Growth2022
    FROM (
        SELECT 
            ProvinceName,
            Time,
            RetailTotal
        FROM 
            SocialConsumption
        WHERE 
            Time BETWEEN 2020 AND 2022
    ) AS p
    PIVOT (
        MAX(RetailTotal) FOR Time IN ([2020], [2021], [2022])
    ) AS pvt
)
SELECT 
    ProvinceName,
    Retail2020,
    Retail2021,
    Retail2022,
    Growth2020,
    Growth2021,
    Growth2022
FROM 
    RetailChange
WHERE 
    Growth2020 < 0 AND Growth2021 > 0 AND Growth2022 < 0;

-- 计算符合条件的省份占比
SELECT 
    COUNT(*) * 1.0 / (SELECT COUNT(DISTINCT ProvinceName) FROM SocialConsumption WHERE Time = 2020) AS ProvincePercentage
FROM 
    RetailChange
WHERE 
    Growth2020 < 0 AND Growth2021 > 0 AND Growth2022 < 0;

-- 检查湖北省是否在其中
SELECT 
    COUNT(*) AS IsHubeiInList
FROM 
    RetailChange
WHERE 
    ProvinceName = '湖北省'
    AND Growth2020 < 0 AND Growth2021 > 0 AND Growth2022 < 0;

/*
    4.3 如果将居民收入划分为高、中、低三个等级，给每个区域收入赋予等级，将结果存储在数据库中，并且统计在指定时间周期各种等级的区域数量。查询哪些区域居民收入一直位于高等级，哪些一直位于低等级。注意不同时间周期划分高中低等级的标准不同。

    思路：
        - 获取指定时间周期内各区域的居民收入等级

        - 统计各等级的区域数量

        - 找出一直位于高等级和低等级的区域
*/

CREATE PROCEDURE AnalyzeResidentIncomeLevels
    @StartYear INT,
    @EndYear INT
AS
BEGIN
    SELECT ProvinceName, IncomeLevel, COUNT(*) AS RegionCount
    FROM ResidentIncome
    WHERE Time BETWEEN @StartYear AND @EndYear
    GROUP BY ProvinceName, IncomeLevel;

    WITH HighIncomeRegions AS (
        SELECT ProvinceName
        FROM ResidentIncome
        WHERE Time BETWEEN @StartYear AND @EndYear AND IncomeLevel = '高'
        GROUP BY ProvinceName
        HAVING COUNT(DISTINCT Time) = @EndYear - @StartYear + 1
    ),
    LowIncomeRegions AS (
        SELECT ProvinceName
        FROM ResidentIncome
        WHERE Time BETWEEN @StartYear AND @EndYear AND IncomeLevel = '低'
        GROUP BY ProvinceName
        HAVING COUNT(DISTINCT Time) = @EndYear - @StartYear + 1
    )
    SELECT '高等级' AS IncomeLevel, ProvinceName
    FROM HighIncomeRegions
    UNION ALL
    SELECT '低等级' AS IncomeLevel, ProvinceName
    FROM LowIncomeRegions;
END;


/*
    4.4 比较东部、西部、中部、东北部地区的居民收入的环比增长率

    思路：
        - 按地区划分省份（东部、西部、中部、东北部）

        - 计算各地区居民收入的环比增长率

        - 比较各地区的环比增长率
*/

CREATE PROCEDURE CompareRegionalIncomeGrowth
AS
BEGIN
    -- 定义各地区的省份
    DECLARE @EastProvinces TABLE (ProvinceName NVARCHAR(50));
    DECLARE @WestProvinces TABLE (ProvinceName NVARCHAR(50));
    DECLARE @CentralProvinces TABLE (ProvinceName NVARCHAR(50));
    DECLARE @NortheastProvinces TABLE (ProvinceName NVARCHAR(50));

    -- 东部地区省份
    INSERT INTO @EastProvinces VALUES ('北京市'), ('天津市'), ('河北省'), ('上海市'), ('江苏省'), ('浙江省'), ('福建省'), ('山东省'), ('广东省'), ('海南省');
    -- 西部地区省份
    INSERT INTO @WestProvinces VALUES ('重庆市'), ('四川省'), ('贵州省'), ('云南省'), ('西藏自治区'), ('陕西省'), ('甘肃省'), ('青海省'), ('宁夏回族自治区'), ('新疆维吾尔自治区');
    -- 中部地区省份
    INSERT INTO @CentralProvinces VALUES ('山西省'), ('安徽省'), ('江西省'), ('河南省'), ('湖北省'), ('湖南省');
    -- 东北地区省份
    INSERT INTO @NortheastProvinces VALUES ('辽宁省'), ('吉林省'), ('黑龙江省');

    -- 计算各省份的收入环比增长率
    WITH IncomeGrowth AS (
        SELECT ProvinceName, 
               Time,
               IncomeAmount,
               LAG(IncomeAmount) OVER (PARTITION BY ProvinceName ORDER BY Time) AS PreviousIncome
        FROM ResidentIncome
    ),
    YearlyGrowth AS (
        SELECT ProvinceName, 
               Time,
               IncomeAmount,
               PreviousIncome,
               (IncomeAmount - PreviousIncome) / PreviousIncome AS GrowthRate
        FROM IncomeGrowth
        WHERE PreviousIncome IS NOT NULL
    ),
    RegionalGrowth AS (
        SELECT '东部' AS Region, AVG(GrowthRate) AS AvgGrowthRate
        FROM YearlyGrowth
        WHERE ProvinceName IN (SELECT ProvinceName FROM @EastProvinces)
        UNION ALL
        SELECT '西部' AS Region, AVG(GrowthRate) AS AvgGrowthRate
        FROM YearlyGrowth
        WHERE ProvinceName IN (SELECT ProvinceName FROM @WestProvinces)
        UNION ALL
        SELECT '中部' AS Region, AVG(GrowthRate) AS AvgGrowthRate
        FROM YearlyGrowth
        WHERE ProvinceName IN (SELECT ProvinceName FROM @CentralProvinces)
        UNION ALL
        SELECT '东北部' AS Region, AVG(GrowthRate) AS AvgGrowthRate
        FROM YearlyGrowth
        WHERE ProvinceName IN (SELECT ProvinceName FROM @NortheastProvinces)
    )
    SELECT * FROM RegionalGrowth;
END;


/*
    4.5 在新冠肺炎疫情三年(20220~2022)中，哪些区域居民收入同比年增长率下降？

    思路：
        - 获取2020~2022年各城市的居民收入数据

        - 计算居民收入的同比年增长率

        - 找出同比年增长率下降的城市
*/

WITH IncomeChange AS (
    SELECT CityName, 
           Time,
           IncomeAmount,
           LAG(IncomeAmount) OVER (PARTITION BY CityName ORDER BY Time) AS PreviousIncome
    FROM ResidentIncome
    WHERE Time BETWEEN 2019 AND 2022
),
YearlyChange AS (
    SELECT CityName, 
           Time,
           IncomeAmount,
           PreviousIncome,
           (IncomeAmount - PreviousIncome) / PreviousIncome AS GrowthRate
    FROM IncomeChange
    WHERE PreviousIncome IS NOT NULL
)
SELECT DISTINCT CityName
FROM YearlyChange
WHERE GrowthRate < 0 AND Time BETWEEN 2020 AND 2022
ORDER BY CityName;
