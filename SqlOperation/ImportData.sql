USE SQLHomework;
/*
 ���� Ad Hoc Distributed Queries, �Ӷ�����ʹ�� OPENROWSET ���� .xlsx �ļ��е�����
 */
sp_configure 'show advanced options',
1;
RECONFIGURE;
GO sp_configure 'ad hoc distributed queries',
    1;
RECONFIGURE;
GO
select *
from Provinces -- ʡ�ݱ�
SELECT * INTO Provinces
From OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'Excel 12.0;Database=F:\OneDrive\Documents\����\��һ��\SQLHomeWork\Data\ʡ����������.xlsx;HDR=YES;',
        -- Database ����д����� xlsx �ļ��ľ���·��
        'SELECT * FROM [Sheet1$]'
    );
-- ���б�
/*
 �� 1 ��
 */
--  �̶��ʲ���
-- �������Ʒ��
/*
 �� 2 ��
 */
-- ʡ�� GDP ��
-- ���� GDP ��
/*
 �� 3 ��
 */
-- ��ҵ��
/*
 �� 4 ��
 */
--���������