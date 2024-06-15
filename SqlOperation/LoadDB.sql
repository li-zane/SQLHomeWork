-- 从数据库文件载入数据库

CREATE DATABASE YourDatabaseName
ON (FILENAME = ''), -- 填充 .mdf 文件路径
   (FILENAME = '') -- 填充 .ldf 文件路径
FOR ATTACH;