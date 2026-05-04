import sys
from banking_functions import perform_transaction, get_account_balance, show_secure_report

def main():
    while True:
        print("\n" + "="*30)
        print("   HỆ THỐNG NGÂN HÀNG NEU - PHASE 3")
        print("="*30)
        print("1. Kiểm tra số dư tài khoản")
        print("2. Nạp tiền (Deposit)")
        print("3. Rút tiền (Withdraw)")
        print("4. Xuất báo cáo bảo mật (Giải mã)")
        print("5. Thoát chương trình")
        
        choice = input("\nXin mời chọn chức năng (1-5): ")

        if choice == '1':
            acc_id = input("Nhập ID tài khoản: ")
            balance = get_account_balance(acc_id)
            if balance is not None:
                print(f"-> Số dư hiện tại của tài khoản {acc_id} là: {balance:,.2f} USD")
            else:
                print("-> Không tìm thấy tài khoản này!")

        elif choice == '2':
            acc_id = input("Nhập ID tài khoản: ")
            amount = float(input("Nhập số tiền muốn nạp: "))
            perform_transaction(acc_id, amount, "DEPOSIT")

        elif choice == '3':
            acc_id = input("Nhập ID tài khoản: ")
            amount = float(input("Nhập số tiền muốn rút: "))
            perform_transaction(acc_id, amount, "WITHDRAW")

        elif choice == '4':
            show_secure_report()

        elif choice == '5':
            print("Cảm ơn đã sử dụng hệ thống!")
            sys.exit()
        
        else:
            print("Lựa chọn không hợp lệ, vui lòng thử lại.")

if __name__ == "__main__":
    main()