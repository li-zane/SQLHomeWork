-- 创建数据库

CREATE DATABASE SQLHomework
ON
( NAME = SQLHomework_dat,
    FILENAME = 'F:\OneDrive\Documents\猪姐姐\大一下\SQLHomeWork\DataBase\MyNewDatabase.mdf', -- 填充保存 .mdf 文件的路径
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB )
LOG ON
( NAME = SQLHomework_log,
    FILENAME = 'F:\OneDrive\Documents\猪姐姐\大一下\SQLHomeWork\DataBase\MyNewDatabase.ldf',  -- 填充保存 .ldf 文件的路径
    SIZE = 5MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB );


