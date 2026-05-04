-- TASK: USER ROLES & PERMISSIONS (Phân quyền người dùng)
-- Mục đích: Thiết lập các lớp bảo mật, đảm bảo nhân viên chỉ tiếp cận đúng dữ liệu cần thiết và ngăn chặn các thao tác nguy hiểm.

-- 1. Tạo các vai trò (Roles)
-- Vai trò quản trị viên: Toàn quyền trên hệ thống
CREATE ROLE IF NOT EXISTS 'bank_admin';

-- Vai trò nhân viên: Chỉ thực hiện nghiệp vụ khách hàng
CREATE ROLE IF NOT EXISTS 'bank_staff';

-- 2. Cấp quyền cho vai trò bank_admin
-- Admin có toàn quyền trên database mydb
GRANT ALL PRIVILEGES ON mydb.* TO 'bank_admin';

-- 3. Cấp quyền cho vai trò bank_staff
-- Nhân viên chỉ được xem (SELECT) và thực thi (EXECUTE) các thủ tục nạp/rút
GRANT SELECT ON mydb.* TO 'bank_staff';
GRANT EXECUTE ON PROCEDURE mydb.WithdrawMoney TO 'bank_staff';
GRANT EXECUTE ON PROCEDURE mydb.DepositMoney TO 'bank_staff';
-- Nhân viên được sử dụng các View báo cáo
GRANT SELECT ON mydb.View_Customer_Balances TO 'bank_staff';
GRANT SELECT ON mydb.View_Employee_Branch_Details TO 'bank_staff';

-- 4. Tạo người dùng cụ thể và gán vai trò
-- Giả sử tạo một tài khoản cho nhân viên giao dịch
CREATE USER IF NOT EXISTS 'staff_user'@'localhost' IDENTIFIED BY 'StaffPass123';
GRANT 'bank_staff' TO 'staff_user'@'localhost';

-- 5. Kích hoạt vai trò mặc định cho người dùng
SET DEFAULT ROLE 'bank_staff' TO 'staff_user'@'localhost';

-- Làm mới hệ thống quyền
FLUSH PRIVILEGES;

-- =============================================================
-- KIỂM TRA (MINH CHỨNG CHO BÁO CÁO)
-- =============================================================
-- Xem danh sách quyền của tài khoản nhân viên
SHOW GRANTS FOR 'staff_user'@'localhost';

-- Xem chi tiết các quyền bên trong vai trò bank_staff
SHOW GRANTS FOR 'bank_staff';