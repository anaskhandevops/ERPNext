FROM ubuntu:20.04

## ARG ##
ARG DEBIAN_FRONTEND=noninteractive

ARG pythonVersion=python3
ARG appBranch=version-13
ARG frappath=/home/frappe/frappe-bench

## ENV SETUP ##
ENV systemUser=frappe
# frappe
ENV benchPath=bench-repo \
    benchRepo="https://github.com/frappe/bench" \
    benchBranch=v5.x \
    frappeRepo="https://github.com/frappe/frappe" \
    erpnextRepo="https://github.com/frappe/erpnext" 

RUN apt-get update && apt-get upgrade -y && apt-get install sudo -y 

## STEP-1: Install git ##
RUN apt-get install -y git 

## STEP-2: install python-dev ##
RUN apt-get install -y python3-dev 

## STEP-3: Install setuptools and pip (Python's Package Manager) ##
RUN apt-get install -y python3-setuptools python3-pip 

## STEP-4: Install virtualenv ##
RUN apt-get install -y virtualenv 

## STEP-5: install Redis ##
RUN apt-get install -y redis-server 

## STEP-6: install Node.js package ##
RUN apt-get install curl -y \
&& curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
&& apt-get install nodejs -y 

## STEP-7: install Yarn ##
RUN apt-get update && apt-get install -y  npm \
&& npm install -g yarn 

## STEP-8:  install wkhtmltopdf ## 
RUN apt-get install -y xvfb libfontconfig wkhtmltopdf

## STEP-9: ADD Sudoers ##
RUN adduser --disabled-password --gecos "" $systemUser \
&& usermod -aG sudo $systemUser \
&& echo "%sudo  ALL=(ALL)  NOPASSWD: ALL" > /etc/sudoers.d/sudoers 

## STEP-10: Set Workdir & User ##
USER $systemUser
WORKDIR /home/$systemUser

## STEP-11: install frappe-bench ##
RUN sudo apt-get update && sudo apt-get upgrade -y \
&& git clone --branch $benchBranch --depth 1 --origin upstream $benchRepo $benchPath \ 
&& sudo -H pip3 install frappe-bench \
&& bench --version \
&& sudo chown frappe -R /home/frappe \
&& sudo apt-get install cron -y \ 
&& bench init /home/frappe/frappe-bench --frappe-path https://github.com/frappe/frappe --frappe-branch version-13 --python python3

## STEP-12: Install ERP app ##
RUN cd /home/frappe/frappe-bench && pip3 install numpy==1.18.5 && pip3 install pandas==0.24.2 \
&& bench get-app erpnext https://github.com/frappe/erpnext --branch version-13 

## STEP-13: Install mariadb client ##
RUN sudo apt-get install -y mariadb-client



## STEP-13: create a site in frappe bench ##
#RUN bench new-site $siteName \
#     --admin-password $adminPass \
#     --mariadb-root-username $dbuser \
#     --mariadb-root-password $mysqlPass  \
#     --db-host $hname 
    
## STEP-14: EXpose Ports ##
EXPOSE 8000 9000 3306

