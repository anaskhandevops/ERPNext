#!/bin/bash
set -x

 docker exec erp bash -c " 
            cd frappe-bench && \
            bench new-site erp.net --admin-password '321' --mariadb-root-username root --mariadb-root-password 1QWERT2 --db-host erpdb && \
            bench --site erp.net install-app erpnext && \
            bench get-app branch version-14 https://github.com/yrestom/POS-Awesome.git && \
            bench setup requirements && \
            bench build --app posawesome && \
            bench --site erp.net install-app posawesome && \
            cd /home/frappe/frappe-bench/sites && echo 'erp.net' >currentsite.txt && \
            cd /home/frappe/frappe-bench && nohup bench start > /dev/null 2>&1 &
            exit
            "