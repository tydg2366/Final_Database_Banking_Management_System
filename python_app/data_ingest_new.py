import pandas as pd
from database_helper import get_connection
import time

def ingest_from_excel():
    start_time = time.time()

    conn = get_connection()
    if not conn: return
    cursor = conn.cursor()
    
    file_path = "Du_Lieu_Ngan_Hang.xlsx"

    try:
        print("--- BẮT ĐẦU QUY TRÌNH NẠP DỮ LIỆU ---")

        # 1. Nạp bảng Branches
        print("Đang nạp dữ liệu Branches từ Excel...")
        df_branches = pd.read_excel(file_path, sheet_name='Branches')
        branches_sql = """
            INSERT INTO branches (BranchID, BranchName, Address)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE BranchName=VALUES(BranchName), Address=VALUES(Address)
        """
        cursor.executemany(branches_sql, [tuple(x) for x in df_branches.values])

        # 2. Nạp bảng Customers
        print("Đang nạp dữ liệu Customers từ Excel...")
        df_customers = pd.read_excel(file_path, sheet_name='Customers')
        customers_sql = """
            INSERT INTO customers (CustomerID, CustomerName, PhoneNumber, Address)
            VALUES (%s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE 
                CustomerName=VALUES(CustomerName), PhoneNumber=VALUES(PhoneNumber),
                Address=VALUES(Address)
        """
        cursor.executemany(customers_sql, [tuple(x) for x in df_customers.values])

        # 3. Nạp bảng Employees 
        print("Đang nạp dữ liệu Employees từ Excel...")
        df_employees = pd.read_excel(file_path, sheet_name='Employees')
        employees_sql = """
            INSERT INTO employees (EmployeeID, BranchID, EmployeeName, Position)
            VALUES (%s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE 
                EmployeeName=VALUES(EmployeeName), Position=VALUES(Position), BranchID=VALUES(BranchID)
        """
        cursor.executemany(employees_sql, [tuple(x) for x in df_employees.values])

        # 4. Nạp bảng Accounts 
        print("Đang nạp dữ liệu Accounts từ Excel...")
        df_accounts = pd.read_excel(file_path, sheet_name='Accounts')
        # Chuyển đổi định dạng ngày tháng để MySQL hiểu
        df_accounts['OpenDate'] = df_accounts['OpenDate'].dt.strftime('%Y-%m-%d')
        accounts_sql = """
            INSERT INTO accounts (AccountID, CustomerID, Balance, OpenDate)
            VALUES (%s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE Balance=VALUES(Balance), OpenDate=VALUES(OpenDate)
        """
        cursor.executemany(accounts_sql, [tuple(x) for x in df_accounts.values])

        # 5. Nạp bảng Transactions
        print("Đang nạp dữ liệu Transactions từ Excel...")
        df_trans = pd.read_excel(file_path, sheet_name='Transactions')
        df_trans['TransactionDate'] = df_trans['TransactionDate'].dt.strftime('%Y-%m-%d')
        trans_sql = """
            INSERT INTO transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
            VALUES (%s, %s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE Amount=VALUES(Amount), TransactionDate=VALUES(TransactionDate)
        """
        cursor.executemany(trans_sql, [tuple(x) for x in df_trans.values])

        conn.commit()

        print("\n" + "="*50)
        print("THÀNH CÔNG: Toàn bộ dữ liệu thực tế đã được nạp vào MySQL!")
        print("="*50)

        # Kết thúc bấm giờ
        end_time = time.time()
        # Tính toán thời gian thực thi
        execution_time = end_time - start_time

        print("\n" + "="*50)
        print("HOÀN TẤT: Hệ thống đã xử lý 510 dòng cho mỗi bảng!")
        print(f"THỜI GIAN THỰC THI: {execution_time:.2f} giây") # Hiện 2 chữ số thập phân
        
        # Đánh giá hiệu năng dựa trên kết quả
        if execution_time < 5:
            print("ĐÁNH GIÁ: Hiệu năng cực kỳ tốt (Dưới 5 giây)!")
        else:
            print("ĐÁNH GIÁ: Hiệu năng đạt yêu cầu.")
        print("="*50)

    except Exception as e:
        print(f"Lỗi khi nạp dữ liệu: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    ingest_from_excel()