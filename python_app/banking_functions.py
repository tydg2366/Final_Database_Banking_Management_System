# Module Transaction (Xử lý Giao dịch)
from database_helper import get_connection

def perform_transaction(account_id, amount, transaction_type):
    """Gọi Stored Procedure để nạp hoặc rút tiền"""
    conn = get_connection()
    if conn:
        try:
            cursor = conn.cursor()
            # Gọi Procedure: deposit_money hoặc withdraw_money tùy theo type
            procedure_name = "DepositMoney" if transaction_type == "DEPOSIT" else "WithdrawMoney"
            
            cursor.callproc(procedure_name, [account_id, amount])
            conn.commit() # Quan trọng: Xác nhận thay đổi dữ liệu
            
            print(f"--- Thành công: {transaction_type} {amount} cho tài khoản {account_id} ---")
        except Exception as e:
            print(f"Lỗi giao dịch: {e}")
        finally:
            conn.close()

# Module Account (Quản lý Tài khoản)
def get_account_balance(account_id):
    """Lấy số dư từ View_Customer_Balances (Task 7)"""
    conn = get_connection()
    if conn:
        cursor = conn.cursor(dictionary=True)
        query = "SELECT Balance FROM accounts WHERE AccountID = %s"
        cursor.execute(query, (account_id,))
        result = cursor.fetchone()
        conn.close()
        return result['Balance'] if result else None
    
#Module Report (Báo cáo & Bảo mật)
def show_secure_report():
    """Hiển thị báo cáo tên khách hàng đã được giải mã (Task 12)"""
    conn = get_connection()
    if conn:
        print("\n--- BÁO CÁO BẢO MẬT KHÁCH HÀNG (Dữ liệu đã giải mã) ---")
        cursor = conn.cursor()
        # Truy vấn trực tiếp từ View giải mã của Dương
        cursor.execute("SELECT * FROM View_Secure_Customer_Info LIMIT 10")
        
        rows = cursor.fetchall()
        print(f"{'ID':<5} | {'Tên Khách Hàng':<25}")
        print("-" * 35)
        for row in rows:
            print(f"{str(row[0]):<5} | {str(row[1]):<25}")
        
        conn.close()

#test
if __name__ == "__main__":
    # 1. Test thử lấy số dư của tài khoản ID số 1
    #balance = get_account_balance(1)
    #print(f"Số dư hiện tại tài khoản 1: {balance}")
    
    # 2. Test thử báo cáo bảo mật
    #show_secure_report()

    perform_transaction(1, 100000, 'DEPOSIT')
    show_secure_report()