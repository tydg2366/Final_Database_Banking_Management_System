# Secure Banking Management System - Final Project

This project is the final submission for the Introduction to Databases course at the **Faculty of Data Science and Artificial Intelligence**, **National Economics University (NEU)**. It demonstrates a complete end-to-end data pipeline, from database design to secure data ingestion and transaction management.

## Student Information
- **Full Name:** Nguyen Thi Thuy Duong
- **Student ID:** 11247158
- **Class** Data Science 66B

## Tech Stack
- **Database:** MySQL (Stored Procedures, Triggers, Views, AES Encryption)
- **Programming:** Python 3.x (Pandas, Mysql-connector-python)
- **Design & Tools:** MySQL Workbench (ERD), VS Code, GitHub

## Repository Structure
- `sql_scripts/`: Database schema, business logic, and security configurations.
- `python_app/`: Source code for the database helper and ETL process.
- `data/`: Standardized input data (Excel format).
- `docs/`: Entity-Relationship Diagram (ERD) and technical documentation.

## How to Run
1. **Database Setup:** Execute the SQL scripts in `sql_scripts/` in numeric order.
2. **Environment Config:** Update your connection credentials in `database_helper.py`.
3. **Data Ingestion:** Run `data_ingest_new.py` to migrate data from Excel to MySQL.
4. **Operations:** Execute `main.py` to perform deposit/withdrawal transactions and generate security reports.

## Key Features
- **Data Security:** Implemented **AES-256 Encryption** for sensitive customer information at the database level.
- **Automation:** Utilized **SQL Triggers** for automated balance auditing and logging.
- **Integrity:** Ensured **ACID compliance** for financial transactions via robust Stored Procedures.
- **ETL Pipeline:** Built a custom Python-based ETL process to handle data cleansing and migration.
