#!/bin/bash

USERID=($id -u)

if [ $USERID -ne 0 ]
then
	echo "Error:: Please run this script with root access"
	exit 1 # give any number other than 0 upto 127
else
	echo "You are running with root acess... so please proceed with next steps.... prechecks and installations"
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
	if [ $? -eq 0 ]
	then 
			echo "Installing mySQL is.... successful"
	else
		echo "Installing mySQL is.... failure"
		exit 1
	fi

}
dnf list installed mysql
if [ $? -ne 0 ]
then
	echo "mysql is not installed.... go ahead and install"
	dnf install mysql -y
	VALIDATE $? "mysql"
else
	echo "mySQL is already installed.... nothing to do"
fi

dnf list installed python3
if [ $? -ne 0 ]
then
	echo "python3 is not installed.... go ahead and install"
	dnf install python3 -y
	VALIDATE $? "python3"
else
	echo "python3 is already installed.... nothing to do"
fi

dnf list installed nginx
if [ $? -ne 0 ]
then
	echo "nginx is not installed.... go ahead and install"
	dnf install nginx -y
	VALIDATE $? "nginx"
else
	echo "nginx is already installed.... nothing to do"
fi