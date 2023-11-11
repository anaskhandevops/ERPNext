#!/bin/bash

# Define variables
FRAPPE_BENCH_DIR="/home/frappe/frappe-bench"
SITE_NAME="erp.net"
ADMIN_PASSWORD='321'
MARIADB_ROOT_USERNAME='root'
MARIADB_ROOT_PASSWORD='1QWERT2'
DB_HOST='erpdb'

# Move to Frappe Bench directory
cd $FRAPPE_BENCH_DIR && \

# Create a new site
bench new-site $SITE_NAME --admin-password $ADMIN_PASSWORD --mariadb-root-username $MARIADB_ROOT_USERNAME --mariadb-root-password $MARIADB_ROOT_PASSWORD --db-host $DB_HOST && \

# Install ERPNext app
bench --site $SITE_NAME install-app erpnext && \

# Install POS-Awesome app
bench get-app branch version-14 https://github.com/yrestom/POS-Awesome.git && \
bench setup requirements && \
bench build --app posawesome && \
bench --site $SITE_NAME install-app posawesome && \

# Start the app
cd $FRAPPE_BENCH_DIR/sites && echo $SITE_NAME > currentsite.txt && \
cd $FRAPPE_BENCH_DIR && bench start

