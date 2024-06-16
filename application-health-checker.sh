#!/bin/bash

# Configuration
URL="http://your.application.endpoint"
LOG_FILE="/var/log/app_health_check.log"
STATUS_FILE="/var/log/app_status.log"

# Function to log messages
log_message() {
    local status=$1
    local message=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $status - $message" >> $LOG_FILE
}

# Function to check application health
check_health() {
    HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" $URL)
    
    if [ "$HTTP_STATUS" -eq 200 ]; then
        log_message "UP" "Application is up. Status code: $HTTP_STATUS"
        echo "UP" > $STATUS_FILE
    else
        log_message "DOWN" "Application is down or not responding. Status code: $HTTP_STATUS"
        echo "DOWN" > $STATUS_FILE
    fi
}

# Check application health
check_health
