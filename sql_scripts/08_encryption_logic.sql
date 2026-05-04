-- TASK: MÃ HÓA DỮ LIỆU NHẠY CẢM (ENCRYPTION)
-- Mục đích: Bảo vệ thông tin định danh khách hàng bằng thuật toán AES_ENCRYPT

-- Tắt chế độ Safe Update để có thể mã hóa hàng loạt khách hàng
-- Tránh lỗi MySQL ngăn chặn Update khi không có điều kiện WHERE trên khóa chính
SET SQL_SAFE_UPDATES = 0;

-- Thêm cột mới để lưu tên đã mã hóa (Chỉ chạy 1 lần, nếu báo lỗi Duplicate thì bỏ qua)
-- Sử dụng thuật toán AES với mã khóa (Key) là 'MySecretBankKey2026'
ALTER TABLE customers ADD COLUMN EncryptedName VARBINARY(255);

-- Mã hóa toàn bộ tên khách hàng
UPDATE customers
SET EncryptedName = AES_ENCRYPT(CustomerName, 'MySecretBankKey2026');

-- TASK: THIẾT LẬP VIEW BẢO MẬT (SECURE VIEW)
-- Mục đích: Cho phép nhân viên có quyền xem tên khách hàng sau khi đã giải mã
CREATE OR REPLACE VIEW View_Secure_Customer_Info AS
SELECT 
    CustomerID,
    -- Giải mã từ cột EncryptedName về dạng chữ (CHAR)
    CAST(AES_DECRYPT(EncryptedName, 'MySecretBankKey2026') AS CHAR(255)) AS DecryptedCustomerName
FROM customers;

-- Kiểm tra kết quả giải mã (Test nội bộ)
-- Chỉ hiện 5 dòng đầu tiên để xác nhận dữ liệu không bị NULL
SELECT * FROM View_Secure_Customer_Info LIMIT 5;

-- Bật lại chế độ Safe Update để bảo vệ dữ liệu sau khi cấu hình xong
SET SQL_SAFE_UPDATES = 1;

-- HOÀN TẤT CẤU HÌNH BẢO MẬT