#!/bin/bash
USERID=$(id -u)
SOURCE_DIR=$1
DEST_DIR=$2
DAYS_TO_KEEP=${3:-14} # Default to 14 days if not provided

LOGS_DIR="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_DIR/$SCRIPT_NAME.log"
SOURCE_DIR="/home/ec2-user/app-logs"

R="\3[31m"
G="\3[32m"
Y="\3[33m"
N="\3[0m"

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


check_root() {
    if [ $USERID -ne 0 ]; then
        echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
        exit 1
    else
        echo "You are running with root access" | tee -a $LOG_FILE
    fi
}

check_root
mkdir -p $LOGS_DIR

USAGE() {
    echo "Usage: $0 <source_directory> <destination_directory> [days_to_keep]" | tee -a $LOG_FILE
    echo "Example: $0 /home/ec2-user/app-logs /backup/logs 14" | tee -a $LOG_FILE
    exit 1
}

if [ $# -lt 2 ]; then
    echo -e "$R USAGE:: Insufficient arguments provided $N" | tee -a $LOG_FILE
    USAGE
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "$R ERROR:: Source directory $SOURCE_DIR does not exist $N" | tee -a $LOG_FILE
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    echo -e "$Y WARNING:: Destination directory $DEST_DIR does not exist. Creating it... $N" | tee -a $LOG_FILE
    mkdir -p "$DEST_DIR"
    VALIDATE $? "Creating destination directory"
fi

FILES_TO_BACKUP=$(find "$SOURCE_DIR" -type f -name "*.log" -mtime -$DAYS_TO_KEEP)

if [ -z "$FILES_TO_BACKUP" ]; then
    echo "No log files found in $SOURCE_DIR modified in the last $DAYS_TO_KEEP days." | tee -a $LOG_FILE
    exit 0
fi
else
    echo "Backing up the following files from $SOURCE_DIR to $DEST_DIR:" | tee -a $LOG_FILE
    echo "$FILES_TO_BACKUP" | tee -a $LOG_FILE
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            cp "$file" "$DEST_DIR"
            VALIDATE $? "Backing up $file"
        fi
    done <<< "$FILES_TO_BACKUP"
fi