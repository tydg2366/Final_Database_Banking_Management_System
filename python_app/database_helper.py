import mysql.connector
from mysql.connector import Error

def get_connection():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            user='root',        
            password='Thuyduong@23', 
            database='mydb'      
        )
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Lỗi kết nối database: {e}")
        return None

# Test thử kết nối
if __name__ == "__main__":
    conn = get_connection()
    if conn:
        print("Kết nối thành công! Đã sẵn sàng làm tiếp.")
        conn.close()