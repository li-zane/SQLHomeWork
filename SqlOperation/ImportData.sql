USE SQLHomework;
/*
 启用 Ad Hoc Distributed Queries, 从而可以使用 OPENROWSET 导入 .xlsx 文件中的数据
 */
sp_configure 'show advanced options',
1;
RECONFIGURE;
GO sp_configure 'ad hoc distributed queries',
    1;
RECONFIGURE;
GO
select *
from Provinces -- 省份表
SELECT * INTO Provinces
From OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'Excel 12.0;Database=F:\OneDrive\Documents\猪姐姐\大一下\SQLHomeWork\Data\省级行政区划.xlsx;HDR=YES;',
        -- Database 下填写导入的 xlsx 文件的绝对路径
        'SELECT * FROM [Sheet1$]'
    );
-- 城市表
/*
 第 1 问
 */
--  固定资产表
-- 社会消费品表
/*
 第 2 问
 */
-- 省份 GDP 表
-- 城市 GDP 表
/*
 第 3 问
 */
-- 产业表
/*
 第 4 问
 */
--居民收入表