-- �������ݿ�

CREATE DATABASE SQLHomework
ON
( NAME = SQLHomework_dat,
    FILENAME = 'F:\OneDrive\Documents\����\��һ��\SQLHomeWork\DataBase\MyNewDatabase.mdf', -- ��䱣�� .mdf �ļ���·��
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB )
LOG ON
( NAME = SQLHomework_log,
    FILENAME = 'F:\OneDrive\Documents\����\��һ��\SQLHomeWork\DataBase\MyNewDatabase.ldf',  -- ��䱣�� .ldf �ļ���·��
    SIZE = 5MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB );


