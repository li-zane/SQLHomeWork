USE SQLHomework;
-- 创建省份表
CREATE TABLE Provinces (ProvinceName VARCHAR(20) PRIMARY KEY);
--城市表
CREATE TABLE Cities(
    ProvinceName VARCHAR(20) NOT NULL,
    CityName VARCHAR(20) NOT NULL,
    Area FLOAT,
    IsCapital BIT,
    PRIMARY KEY (ProvinceName, CityName),
    FOREIGN KEY (ProvinceName) REFERENCES Provinces(ProvinceName)
);
/*
 第 1 问
 */
--  固定资产表
CREATE TABLE FixedAssets (
    ProvinceName VARCHAR(20) NOT NULL,
    Time DATETIME NOT NULL,
    TypeName VARCHAR(20) NOT NULL,
    TotalInvestmentScale FLOAT,
    InvestmentScale FLOAT,
    InvestmentGrowthRate FLOAT,
    PRIMARY KEY (ProvinceName, Time),
    FOREIGN KEY (ProvinceName) REFERENCES Provinces(ProvinceName)
);
-- 社会消费品表
CREATE TABLE SocialConsumptionGoods (
    ProvinceName VARCHAR(20) NOT NULL,
    Time DATETIME NOT NULL,
    RetailTotal FLOAT NOT NULL,
    PRIMARY KEY (ProvinceName, Time),
    FOREIGN KEY (ProvinceName) REFERENCES Provinces(ProvinceName)
);
/*
 第 2 问
 */
-- 省份 GDP 表
CREATE TABLE ProvinceGDP (
    ProvinceName VARCHAR(20),
    Time DATETIME,
    TotalGDP FLOAT,
    PerCapitaGDP FLOAT,
    GrowthRate FLOAT,
    PRIMARY KEY (ProvinceName, Time),
    FOREIGN KEY (ProvinceName) REFERENCES Provinces(ProvinceName)
);
-- 城市 GDP 表
CREATE TABLE CityGDP (
    ProvienceName VARCHAR(20) NOT NULL,
    CityName VARCHAR(20) NOT NULL,
    Time DATETIME,
    TotalGDP FLOAT,
    PerCapitaGDP FLOAT,
    GrowthRate FLOAT,
    PRIMARY KEY (ProvienceName, CityName, Time),
    FOREIGN KEY (ProvienceName, CityName) REFERENCES Cities(ProvinceName, CityName)
);
/*
 第 3 问
 */
-- 产业表
CREATE TABLE Industry (
    ProvinceName VARCHAR(20) NOT NULL,
    CityName VARCHAR(20),
    Time DATETIME,
    IndustryType VARCHAR(20),
    GrowthRate FLOAT,
    Output FLOAT,
    PRIMARY KEY (ProvinceName, CityName, Time, IndustryType),
    FOREIGN KEY (ProvinceName, CityName) REFERENCES Cities(ProvinceName, CityName)
);
/*
 第 4 问
 */
--居民收入表
CREATE TABLE ResidentIncome (
    ProvinceName VARCHAR(20) NOT NULL,
    CityName VARCHAR(20) NOT NULL,
    Time DATETIME NOT NULL,
    IncomeType VARCHAR(20) NOT NULL,
    IncomeLevel VARCHAR(20) NOT NULL,
    YoYGrowth FLOAT,
    MoMGrowth FLOAT,
    Incomeamount FLOAT,
    PRIMARY KEY (ProvinceName, CityName, Time),
    FOREIGN KEY (ProvinceName, CityName) REFERENCES Cities(ProvinceName, CityName)
);
/*
 拓展部分
 */
--光照表
CREATE TABLE LightIntensityData (
    ProvinceName VARCHAR(20) NOT NULL,
    CityName VARCHAR(20) NOT NULL,
    Time DATETIME NOT NULL,
    LightIntensity FLOAT,
    PRIMARY KEY (ProvinceName, CityName, Time),
    FOREIGN KEY (ProvinceName, CityName) REFERENCES Cities(ProvinceName, CityName)
)