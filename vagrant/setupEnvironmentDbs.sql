CREATE DATABASE vagrant;
CREATE USER 'vagrant_user'@'localhost' IDENTIFIED BY 'p@ssw0rd';
GRANT ALL PRIVILEGES ON vagrant.* TO 'vagrant_user'@'localhost' IDENTIFIED BY 'p@ssw0rd';
