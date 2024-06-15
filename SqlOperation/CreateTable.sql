USE SQLHomework;
-- ����ʡ�ݱ�
CREATE TABLE Provinces (ProvinceName VARCHAR(20) PRIMARY KEY);
--���б�
CREATE TABLE Cities(
    ProvinceName VARCHAR(20) NOT NULL,
    CityName VARCHAR(20) NOT NULL,
    Area FLOAT,
    IsCapital BIT,
    PRIMARY KEY (ProvinceName, CityName),
    FOREIGN KEY (ProvinceName) REFERENCES Provinces(ProvinceName)
);
/*
 �� 1 ��
 */
--  �̶��ʲ���
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
-- �������Ʒ��
CREATE TABLE SocialConsumptionGoods (
    ProvinceName VARCHAR(20) NOT NULL,
    Time DATETIME NOT NULL,
    RetailTotal FLOAT NOT NULL,
    PRIMARY KEY (ProvinceName, Time),
    FOREIGN KEY (ProvinceName) REFERENCES Provinces(ProvinceName)
);
/*
 �� 2 ��
 */
-- ʡ�� GDP ��
CREATE TABLE ProvinceGDP (
    ProvinceName VARCHAR(20),
    Time DATETIME,
    TotalGDP FLOAT,
    PerCapitaGDP FLOAT,
    GrowthRate FLOAT,
    PRIMARY KEY (ProvinceName, Time),
    FOREIGN KEY (ProvinceName) REFERENCES Provinces(ProvinceName)
);
-- ���� GDP ��
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
 �� 3 ��
 */
-- ��ҵ��
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
 �� 4 ��
 */
--���������
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
 ��չ����
 */
--���ձ�
CREATE TABLE LightIntensityData (
    ProvinceName VARCHAR(20) NOT NULL,
    CityName VARCHAR(20) NOT NULL,
    Time DATETIME NOT NULL,
    LightIntensity FLOAT,
    PRIMARY KEY (ProvinceName, CityName, Time),
    FOREIGN KEY (ProvinceName, CityName) REFERENCES Cities(ProvinceName, CityName)
)