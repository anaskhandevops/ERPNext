### CREATE NETWORK
  
      docker network create erpnet

### RUN MARIADB CONTAINER
 
        docker run -it  --net erpnet --name erpdb -e MYSQL_ROOT_PASSWORD=1QWERT2 -v /home/ubuntu/conf:/etc/mysql/conf.d -d 1devops2/erpnextdb:14


### RUN FRAPPE-APP CONTAINER


          docker run -it --network erpnet --name erp -p 8000:8000 -p 9000:9000 -p3306:3306 -d 1devops2/erpnext:14


### EXEC INTO ERP CONTAINER

       cd frappe-bench && bench new-site erp.net --admin-password '321' --mariadb-root-username root --db-host erpdb
       bench --site erp.net install-app erpnext 
#### to install posawesome

       bench get-app branch version-14 https://github.com/yrestom/POS-Awesome.git
       bench setup requirements
       bench build --app posawesome
       bench --site erp.net install-app posawesome 
      cd /home/frappe/frappe-bench/sites && echo 'erp.net' >currentsite.txt 
      cd /home/frappe/frappe-bench && bench start


# PORTS
      3306 8000 9000


