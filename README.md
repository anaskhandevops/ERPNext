## Install erpnext app with docker
![Docker](https://img.shields.io/badge/Docker-23.0.3-%232496ED.svg?style=for-the-badge&logo=docker&logoColor=white) ![ERPNext](https://img.shields.io/badge/ERPNext-v14-%2343853D.svg?style=for-the-badge&logo=erpnext&logoColor=white) ![MariaDB](https://img.shields.io/badge/MariaDB-10.8-%234479A1.svg?style=for-the-badge&logo=mariadb&logoColor=white) ![Python](https://img.shields.io/badge/Python-3.10-%234B8BBE.svg?style=for-the-badge&logo=python&logoColor=white)




### CREATE NETWORK
  
      docker network create erpnet

### RUN MARIADB CONTAINER
 
        docker run -it  --net erpnet --name erpdb -e MYSQL_ROOT_PASSWORD=1QWERT2 -v /home/ubuntu/conf:/etc/mysql/conf.d -d 1devops2/erpnextdb:14


### RUN FRAPPE-APP CONTAINER


          docker run -it --network erpnet --name erp -p 8000:8000 -p 9000:9000 -p3306:3306 -d 1devops2/erpnext:14


### EXEC INTO ERP CONTAINER

       cd frappe-bench && bench new-site erp.net --admin-password '321' --mariadb-root-username root --db-host erpdb
       bench --site erp.net install-app erpnext 
#### to install pos-awesome

       bench get-app branch version-14 https://github.com/yrestom/POS-Awesome.git
       bench setup requirements
       bench build --app posawesome
       bench --site erp.net install-app posawesome 
      cd /home/frappe/frappe-bench/sites && echo 'erp.net' >currentsite.txt 
      cd /home/frappe/frappe-bench && bench start


# PORTS
      3306 8000 9000


