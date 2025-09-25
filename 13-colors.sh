#!/sbin/bash

USERID=($id -u)
R="\3[31m"
G="\3[32m"
Y="\3[33m"
N="\3[0m"

if [ $USERID -ne 0 ]
then
	echo -e "$R Error:: Please run this script with root access $N"
	exit 1 # give any number other than 0 upto 127
else
	echo "You are running with root acess... so please proceed with next steps.... prechecks and installations"
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
	if [ $? -eq 0 ]
	then 
			echo -e "Installing mySQL is.... $G SUCCESS $N"
	else
		echo -e "$G Installing mySQL is.... $R FAILURE $N"
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
	echo -e "mySQL is already installed.... $Y nothing to do $N"
fi

dnf list installed python3
if [ $? -ne 0 ]
then
	echo "python3 is not installed.... go ahead and install"
	dnf install python3 -y
	VALIDATE $? "python3"
else
	echo -e "python3 is already installed.... $Y nothing to do $N"
fi

dnf list installed nginx
if [ $? -ne 0 ]
then
	echo "nginx is not installed.... go ahead and install"
	dnf install nginx -y
	VALIDATE $? "nginx"
else
	echo -e "nginx is already installed.... $Y nothing to do $N"
fi