-- MySQL Workbench Forward Engineering

-- PHẦN 1: CẤU HÌNH BIẾN MÔI TRƯỜNG (ENVIRONMENT SETTINGS)
-- Mục đích: Đảm bảo quá trình khởi tạo diễn ra mượt mà, tạm thời bỏ qua các

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- PHẦN 2: KHỞI TẠO CƠ SỞ DỮ LIỆU (SCHEMA INITIALIZATION)
-- Schema mydb
-- -----------------------------------------------------
-- Xóa Schema cũ nếu đã tồn tại để làm sạch dữ liệu trước khi cài đặt mới
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- Tạo Database mới với bảng mã utf8 để hỗ trợ lưu trữ Tiếng Việt có dấu
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- PHẦN 3: ĐỊNH NGHĨA CÁC BẢNG DỮ LIỆU (TABLE DEFINITIONS)
-- Table `mydb`.`Branches`
-- -----------------------------------------------------
-- 3.1. Bảng Branches (Chi nhánh): Lưu thông tin mạng lưới ngân hàng
DROP TABLE IF EXISTS `mydb`.`Branches` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Branches` (
  `BranchID` INT NOT NULL AUTO_INCREMENT,
  `BranchName` VARCHAR(100) NOT NULL,
  `Address` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`BranchID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Employees`
-- -----------------------------------------------------
-- 3.2. Bảng Employees (Nhân viên)
-- Mục đích: Quản lý nhân sự và phân bổ nhân viên vào các chi nhánh
DROP TABLE IF EXISTS `mydb`.`Employees` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Employees` (
  `EmployeeID` INT NOT NULL AUTO_INCREMENT,
  `EmployeeName` VARCHAR(100) NOT NULL,
  `Position` VARCHAR(50) NULL,
  `BranchID` INT NOT NULL,
  PRIMARY KEY (`EmployeeID`),
  INDEX `fk_employees_branches_idx` (`BranchID` ASC) VISIBLE,
  CONSTRAINT `fk_employees_branches`
    FOREIGN KEY (`BranchID`)
    REFERENCES `mydb`.`Branches` (`BranchID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Customers`
-- -----------------------------------------------------
-- 3.3. Bảng Customers (Khách hàng)
-- Mục đích: Lưu trữ thông tin cá nhân và định danh duy nhất của khách hàng
DROP TABLE IF EXISTS `mydb`.`Customers` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Customers` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `CustomerName` VARCHAR(100) NOT NULL,
  `PhoneNumber` VARCHAR(15) NOT NULL,
  `Address` VARCHAR(255) NULL,
  PRIMARY KEY (`CustomerID`),
  
  -- Ràng buộc UNIQUE đảm bảo mỗi số điện thoại chỉ đăng ký cho một khách hàng
  UNIQUE INDEX `PhoneNumber_UNIQUE` (`PhoneNumber` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Accounts`
-- -----------------------------------------------------
-- 3.4. Bảng Accounts (Tài khoản ngân hàng)
-- Mục đích: Quản lý số dư và liên kết tài khoản với khách hàng sở hữu
DROP TABLE IF EXISTS `mydb`.`Accounts` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Accounts` (
  `AccountID` INT NOT NULL AUTO_INCREMENT,
  `CustomerID` INT NOT NULL,
  `Balance` DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  `OpenDate` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`AccountID`),
  INDEX `fk_accounts_customers_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_accounts_customers`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `mydb`.`Customers` (`CustomerID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Transactions`
-- -----------------------------------------------------
-- 3.5. Bảng Transactions (Giao dịch)
-- Mục đích: Lưu vết mọi biến động số dư (Nạp, Rút, Chuyển tiền)
DROP TABLE IF EXISTS `mydb`.`Transactions` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Transactions` (
  `TransactionID` INT NOT NULL AUTO_INCREMENT,
  `AccountID` INT NOT NULL,
  `Amount` DECIMAL(15,2) NOT NULL,
  `TransactionType` ENUM('Deposit', 'Withdrawal', 'Transfer') NOT NULL,
  `TransactionDate` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`TransactionID`),
  INDEX `fk_transactions_accounts_idx` (`AccountID` ASC) VISIBLE,
  CONSTRAINT `fk_transactions_accounts`
    FOREIGN KEY (`AccountID`)
    REFERENCES `mydb`.`Accounts` (`AccountID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- PHẦN 4: HOÀN TẤT THIẾT LẬP (CLEANUP)
-- Khôi phục lại các cài đặt kiểm tra ràng buộc ban đầu của hệ thống
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
