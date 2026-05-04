USE mydb;

-- TASK: CREATE INDEXES (Tối ưu hóa truy vấn)

-- 1. Index trên bảng Accounts: Tăng tốc tra cứu tài khoản theo CustomerID
-- Thường dùng khi khách hàng đăng nhập và muốn xem danh sách tài khoản của họ.
CREATE INDEX idx_customer_id ON Accounts(CustomerID);

-- 2. Index trên bảng Employees: Tăng tốc tìm kiếm nhân viên theo chi nhánh
-- Thường dùng cho các báo cáo quản trị nhân sự theo từng khu vực.
CREATE INDEX idx_branch_id ON Employees(BranchID);

-- 3. Index trên bảng Transactions: Tăng tốc tra cứu theo loại giao dịch và ngày tháng
-- Giúp việc lọc các giao dịch 'Deposit' hay 'Withdrawal' nhanh hơn.
CREATE INDEX idx_transaction_type ON Transactions(TransactionType);
CREATE INDEX idx_transaction_date ON Transactions(TransactionDate);

SHOW INDEX FROM Accounts;

-- TASK: CREATE VIEWS (Hệ thống báo cáo)

-- 1. View xem tổng hợp: Tên khách hàng - Số tài khoản - Số dư
CREATE OR REPLACE VIEW View_Customer_Balances AS
SELECT 
    c.CustomerName, 
    a.AccountID, 
    a.Balance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID;

-- 2. View xem danh sách nhân viên và chi nhánh họ đang làm việc
CREATE OR REPLACE VIEW View_Employee_Branch_Details AS
SELECT 
    e.EmployeeName, 
    e.Position, 
    b.BranchName
FROM Employees e
JOIN Branches b ON e.BranchID = b.BranchID;

-- Gọi View ra để xem kết quả
SELECT * FROM View_Employee_Branch_Details;

-- TASK: AUDIT TABLE (Bảng lưu vết biến động số dư)
-- Mục đích: Đảm bảo tính minh bạch và an toàn dữ liệu

CREATE TABLE IF NOT EXISTS Account_Audit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT,
    OldBalance DECIMAL(15,2),
    NewBalance DECIMAL(15,2),
    ChangedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ActionType VARCHAR(50)
);

-- TASK: USER DEFINED FUNCTIONS (Hàm người dùng tự định nghĩa)
-- Mục đích: Đóng gói các công thức tính toán tài chính lặp đi lặp lại.
-- Giúp code gọn gàng, dễ bảo trì và tránh sai sót trong tính toán lãi suất.

DELIMITER //

-- 1. Hàm tính lãi suất hàng tháng (Calculate Monthly Interest)
-- Logic: Giả định lãi suất tiết kiệm là 0.5%/tháng (6%/năm).
-- Input: Số dư tài khoản (Balance).
-- Output: Số tiền lãi nhận được trong tháng đó.
CREATE FUNCTION CalculateInterest(p_Balance DECIMAL(15,2)) 
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE v_Interest DECIMAL(15,2);
    -- Công thức tính lãi suất đơn giản
    SET v_Interest = p_Balance * 0.005;
    RETURN v_Interest;
END //

-- 2. Hàm kiểm tra trạng thái số dư tối thiểu (Check Minimum Balance)
-- Logic: Quy định của ngân hàng yêu cầu số dư tối thiểu là 50,000 VND.
-- Input: Số dư hiện tại.
-- Output: Trạng thái 'Hợp lệ' hoặc 'Cảnh báo' nếu dưới mức quy định.
CREATE FUNCTION CheckMinBalance(p_Balance DECIMAL(15,2)) 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE v_Status VARCHAR(50);
    IF p_Balance < 50000.00 THEN
        SET v_Status = 'Dưới mức tối thiểu (Cảnh báo)';
    ELSE
        SET v_Status = 'Hợp lệ';
    END IF;
    RETURN v_Status;
END //

DELIMITER ;

-- =============================================================
-- TEST CASE: Kiểm tra hoạt động của Functions kết hợp với View
-- Chạy lệnh này để xem kết quả tính toán trực quan trên dữ liệu thật
-- =============================================================
SELECT 
    CustomerName, 
    Balance, 
    CalculateInterest(Balance) AS Estimated_Monthly_Interest,
    CheckMinBalance(Balance) AS Account_Status
FROM View_Customer_Balances
LIMIT 10;