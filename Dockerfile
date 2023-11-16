FROM ubuntu:22.04

## ARG ##
ARG DEBIAN_FRONTEND=noninteractive

ARG pythonVersion=python3
ARG appBranch=version-14
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
RUN apt-get install -y python3-setuptools python3-pip python3.10-venv

## STEP-4: Install virtualenv ##.
RUN apt-get install -y virtualenv

## STEP-5: install Redis ##
RUN apt-get install -y redis-server

## STEP-6: install Node.js package ##
RUN apt-get install curl -y \
&& curl -sL https://deb.nodesource.com/setup_16.x | sudo bash - \
&& apt-get install nodejs -y

## STEP-7: install Yarn ##
RUN sudo npm install -g yarn

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
&& bench init /home/frappe/frappe-bench --frappe-path https://github.com/frappe/frappe --frappe-branch version-14 --python python3

## STEP-12: Install ERP app ##
RUN cd /home/frappe/frappe-bench && bench get-app erpnext https://github.com/frappe/erpnext --branch version-14

## STEP-13: Install mariadb client ##
RUN sudo apt-get install -y mariadb-client

COPY setup-erp.sh /home/frappe/frappe-bench
RUN sudo chmod a+x /home/frappe/frappe-bench/setup-erp.sh

## STEP-14: EXpose Ports ##
EXPOSE 8000 9000 3306

CMD ["/bin/bash", "-c", "/home/frappe/frappe-bench/setup-erp.sh"]