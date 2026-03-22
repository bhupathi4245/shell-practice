#!/bin/bash

USERID=$(id -u)
R="\3[31m"
G="\3[32m"
Y="\3[33m"
N="\3[0m"
LOGS_DIR="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_DIR/$SCRIPT_NAME.log"
SOURCE_DIR="/home/ec2-user/app-logs"

mkdir -p $LOGS_DIR

# check the user has root priveleges or not
if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access" | tee -a $LOG_FILE
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

FILES_TO_DELETE=$(find $SOURCE_DIR -type f -name "*.log" -mtime +14)

while IFS = read -r file; do
    if [ -f "$file" ]; then
        echo "Deleting: $file"
        rm -rf "$file"
    fi
done <<< "$FILES_TO_DELETE"

echo "Script finished executing at: $(date)" | tee -a $LOG_FILE