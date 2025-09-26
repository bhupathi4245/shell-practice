#!/bin/bash

USERID=($id -u)
R="\3[31m"
G="\3[32m"
Y="\3[33m"
N="\3[0m"
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
	echo -e "$R Error:: Please run this script with root access $N" | tee -a $LOG_FILE
	exit 1 # give any number other than 0 upto 127
else
	echo "You are running with root acess... so please proceed with next steps.... prechecks and installations"
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
	if [ $1 -eq 0 ]
	then 
			echo -e "Installing mySQL is.... $G SUCCESS $N" | tee -a $LOG_FILE
	else
		echo -e "$G Installing mySQL is.... $R FAILURE $N" | tee -a $LOG_FILE
		exit 1
	fi

}
dnf list installed mysql &>>$LOG_FILE
if [ $? -ne 0 ]
then
	echo "mysql is not installed.... going to install..." | tee -a $LOG_FILE
	dnf install mysql -y &>> $LOG_FILE
	VALIDATE $? "mysql"
else
	echo -e "mySQL is already installed.... $Y nothing to do $N" | tee -a $LOG_FILE
fi

dnf list installed python3 &>>$LOG_FILE
if [ $? -ne 0 ]
then
	echo "python3 is not installed.... going to install..." | tee -a $LOG_FILE
	dnf install python3 -y &>>$LOG_FILE
	VALIDATE $? "python3"
else
	echo -e "python3 is already installed.... $Y nothing to do $N" | tee -a $LOG_FILE
fi

dnf list installed nginx &>>$LOG_FILE
if [ $? -ne 0 ]
then
	echo "nginx is not installed.... going to install..." | tee -a $LOG_FILE
	dnf install nginx -y &>>LOG_FILE
	VALIDATE $? "nginx"
else
	echo -e "nginx is already installed.... $Y nothing to do $N" | tee -a $LOG_FILE
fi