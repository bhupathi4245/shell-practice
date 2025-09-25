#!/sbin/bash

USERID=($id -u)
R="\3[31m"
G="\3[32m"
Y="\3[33m"
N="\3[0m"
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
PACKAGES=("mysql" "python" "nginx" "httpd")

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

# for package in ${PACKAGE[@]}
# $@ is to receive arguements from the shell/console itself...Ex. sudo sh 16-loop.sh nginx mysql
for package in $@
do
	dnf list installed $package &>>$LOG_FILE
	if [ $? -ne 0 ]
	then
		echo "$package is not installed.... going to install..." | tee -a $LOG_FILE
		dnf install $package -y &>> $LOG_FILE
		VALIDATE $? "my$packagesql"
	else
		echo -e "$package is already installed.... $Y nothing to do $N" | tee -a $LOG_FILE
	fi
done