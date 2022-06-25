# 1) create database
CREATE DATABASE hospital;

# 2) create new users and grant privileges
# admin has full privileges
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON hospital.* TO 'admin'@'localhost';
# main_user can only run select queries
CREATE USER 'main_user'@'localhost' IDENTIFIED BY 'main_user';
GRANT SELECT ON hospital.* TO 'main_user'@'localhost';
# reload privileges
FLUSH PRIVILEGES;

# 3) show grants
SHOW GRANTS FOR 'admin'@'localhost';
SHOW GRANTS FOR 'main_user'@'localhost';

# 4) drop users
DROP USER 'admin'@'localhost';
DROP USER 'main_user'@'localhost';