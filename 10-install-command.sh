#!/bin/bash

USERID=($id -u)

if [ $USERID -ne 0 ]
then
	echo "Error:: Please run this script with root access"
	exit 1 # give any number other than 0 upto 127
else
	echo "You are running with root acess... so please proceed"
fi

dnf list installed mysql
if [ $? -ne 0 ]
then
	echo "MySQL is not installed.... go ahead and install"
	dnf install mysql -y
	if [ $? -eq 0 ]
	then 
			echo "Installing mySQL is.... successful"
	else
		echo "Installing mySQL is.... failure"
		exit 1
	fi
else
	echo "mySQL is already installed.... nothing to do"
fi