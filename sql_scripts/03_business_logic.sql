-- Định nghĩa các Procedure để xử lý giao dịch Rút tiền và Nạp tiền
USE mydb;

DELIMITER //

-- PROCEDURE: WithdrawMoney
-- MÔ TẢ: Xử lý nghiệp vụ rút tiền từ tài khoản khách hàng
-- ĐẦU VÀO: 
--    p_AccountID (Mã tài khoản)
--    p_Amount (Số tiền cần rút)

CREATE PROCEDURE WithdrawMoney(
    IN p_AccountID INT, 
    IN p_Amount DECIMAL(15,2)
)
BEGIN
	-- Khai báo biến cục bộ để lưu trữ số dư hiện tại của tài khoản
    DECLARE current_balance DECIMAL(15,2);

    -- 1. Lấy số dư hiện tại
    SELECT Balance INTO current_balance FROM Accounts WHERE AccountID = p_AccountID;

    -- 2. Kiểm tra điều kiện rút tiền
    IF current_balance >= p_Amount THEN
        START TRANSACTION;
        -- Trừ tiền trong tài khoản
        UPDATE Accounts SET Balance = Balance - p_Amount WHERE AccountID = p_AccountID;
        -- Ghi log giao dịch
        INSERT INTO Transactions (AccountID, Amount, TransactionType) 
        VALUES (p_AccountID, -p_Amount, 'Withdrawal');
        COMMIT;
        SELECT 'Giao dịch thành công' AS Status;
    ELSE
        -- Nếu không đủ tiền thì báo lỗi
        SELECT 'Lỗi: Số dư không đủ để thực hiện giao dịch' AS Status;
    END IF;
END //

DELIMITER ;

-- test case "Rút tiền thành công"
-- Xem số dư trước khi rút
SELECT Balance FROM Accounts WHERE AccountID = 1;

-- Thực hiện rút 50.000
CALL WithdrawMoney(1, 50000.00);

-- Xem lại số dư và bảng giao dịch để xác nhận
SELECT Balance FROM Accounts WHERE AccountID = 1;
SELECT * FROM Transactions WHERE AccountID = 1 ORDER BY TransactionDate DESC LIMIT 1;

-- test case "Từ chối vì thiếu tiền"
CALL WithdrawMoney(1, 1000000000.00);


DELIMITER //

-- PROCEDURE: DepositMoney
-- MÔ TẢ: Xử lý nghiệp vụ nạp tiền vào tài khoản khách hàng
-- ĐẦU VÀO: 
--    p_AccountID (Mã tài khoản nhận tiền)
--    p_Amount (Số tiền cần nạp)

CREATE PROCEDURE DepositMoney(
    IN p_AccountID INT, 
    IN p_Amount DECIMAL(15,2)
)
BEGIN
    -- Kiểm tra số tiền nạp phải lớn hơn 0
    IF p_Amount <= 0 THEN
        SELECT 'Lỗi: Số tiền nạp phải lớn hơn 0' AS Status;
    -- Kiểm tra tài khoản có tồn tại không
    ELSEIF (SELECT COUNT(*) FROM Accounts WHERE AccountID = p_AccountID) = 0 THEN
        SELECT 'Lỗi: Tài khoản không tồn tại' AS Status;
    ELSE
        START TRANSACTION;
        
        -- 1. Cộng tiền vào tài khoản
        UPDATE Accounts 
        SET Balance = Balance + p_Amount 
        WHERE AccountID = p_AccountID;
        
        -- 2. Ghi nhật ký giao dịch (Deposit là số dương)
        INSERT INTO Transactions (AccountID, Amount, TransactionType) 
        VALUES (p_AccountID, p_Amount, 'Deposit');
        
        COMMIT;
        SELECT 'Nạp tiền thành công' AS Status;
    END IF;
END //

DELIMITER ;

-- Test case 
-- Bước 1: Nạp tiền thành công
-- Nạp 200.000 vào tài khoản 1
CALL DepositMoney(1, 200000.00);

-- Kiểm tra số dư và giao dịch mới nhất
SELECT Balance FROM Accounts WHERE AccountID = 1;
SELECT * FROM Transactions WHERE AccountID = 1 ORDER BY TransactionDate DESC LIMIT 1;

-- Bước 2: Test lỗi (Dữ liệu không hợp lệ)
-- -- Thử nạp số tiền âm
CALL DepositMoney(1, -50000.00);

-- TASK: TRIGGER (Tự động hóa giám sát giao dịch)
-- Mục đích: Tự động ghi log mỗi khi số dư tài khoản thay đổi
-- Đảm bảo tính minh bạch và có khả năng truy vết (Audit Trail) cho mọi giao dịch

DELIMITER //

CREATE TRIGGER After_Balance_Update
AFTER UPDATE ON Accounts
FOR EACH ROW
BEGIN
    -- Chỉ kích hoạt ghi log nếu số dư (Balance) thực sự bị thay đổi
    IF OLD.Balance <> NEW.Balance THEN
        INSERT INTO Account_Audit (
            AccountID, 
            OldBalance, 
            NewBalance, 
            ActionType
        )
        VALUES (
            OLD.AccountID, 
            OLD.Balance, 
            NEW.Balance, 
            'UPDATE_BALANCE'
        );
    END IF;
END //

DELIMITER ;

-- test case check sự tự động hóa
-- Bước 1: Thực hiện một giao dịch nạp tiền (đã làm ở Task 8)
CALL DepositMoney(1, 100000.00);

-- Bước 2: Kiểm tra xem Trigger có tự động làm việc không
-- (Bạn không cần INSERT vào bảng Audit, Trigger sẽ tự làm thay bạn)
SELECT * FROM Account_Audit;