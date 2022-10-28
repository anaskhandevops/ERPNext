
Credentials:    
		
		MARIADB PASSWORD=12345 
		
		ERP -> user=administrator  password=321


STEP-1: PULL 

		--> docker pull technonies/erpnextdb
		
	        --> docker pull technonies/erpnext


STEP-2: CREATE NETWORK
		
		--> docker network create mynet

STEP-3: RUN

                --> docker run -d --network mynet --name mariadbb --env MARIADB_ROOT_PASSWORD=12345 -v /home/tlp/conf:/etc/mysql/mariadb.conf.d technonies/erpnextdb 
                --> docker run -it -d --network mynet --name erp -p 8000:8000 -p 9000:9000 -p3306:3306 technonies/erpnext

STEP-3: EXEC in technonies/erpnext 
		
		--> bench new-site <your-site.com> --admin-password '321' --mariadb-root-username root --db-host mariadbb 
		--> bench --site site.net install-app erpnext 
		--> cd /home/frappe/frappe-bench/sites && echo 'site.net' >currentsite.txt 
		--> cd /home/frappe/frappe-bench && bench start
