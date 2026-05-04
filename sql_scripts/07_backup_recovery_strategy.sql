-- TASK: BACKUP & RECOVERY STRATEGY
-- Mục đích: Đảm bảo an toàn dữ liệu và khả năng phục hồi hệ thống

-- 1. Sau khi phục hồi, kiểm tra tính toàn vẹn của dữ liệu (Data Integrity)
-- Đảm bảo số lượng bản ghi không bị mất mát
SELECT 
    (SELECT COUNT(*) FROM customers) AS Total_Customers,
    (SELECT COUNT(*) FROM accounts) AS Total_Accounts,
    (SELECT COUNT(*) FROM transactions) AS Total_Transactions;

-- 2. Kiểm tra xem các đối tượng nâng cao có còn hoạt động không
-- (Views, Procedures, Triggers phải được khôi phục nguyên vẹn)
SHOW FULL TABLES IN mydb WHERE TABLE_TYPE LIKE 'VIEW';
SHOW PROCEDURE STATUS WHERE Db = 'mydb';
SHOW TRIGGERS FROM mydb;