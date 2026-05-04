SET FOREIGN_KEY_CHECKS = 0; -- Vô hiệu hóa kiểm tra ràng buộc để xóa dữ liệu nhanh
TRUNCATE TABLE Transactions;
TRUNCATE TABLE Accounts;
TRUNCATE TABLE Employees;
TRUNCATE TABLE Customers;
TRUNCATE TABLE Branches;
SET FOREIGN_KEY_CHECKS = 1; -- Kích hoạt lại ràng buộc để đảm bảo an toàn dữ liệu