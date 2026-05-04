-- TASK: DATA INTEGRITY & POST-LOAD VERIFICATION
-- Mục đích: Đảm bảo dữ liệu được nạp đầy đủ và đồng bộ giữa các bảng
-- Sử dụng UNION để tạo một Dashboard báo cáo nhanh về số lượng bản ghi
-- Giúp kiểm tra tính toàn vẹn (Integrity Check) chỉ trong 1 lần thực thi

USE mydb;
SELECT 'Branches' as TableName, COUNT(*) FROM Branches
UNION SELECT 'Customers', COUNT(*) FROM Customers
UNION SELECT 'Employees', COUNT(*) FROM Employees
UNION SELECT 'Accounts', COUNT(*) FROM Accounts
UNION SELECT 'Transactions', COUNT(*) FROM Transactions;