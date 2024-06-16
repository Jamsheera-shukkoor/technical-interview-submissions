#!/bin/bash

# Function to check CPU usage
check_cpu_usage() {
    cpu_usage_threshold=80  # Threshold in percentage
    current_cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

    cpu_usage_int=${current_cpu_usage%.*}  # Get integer part of the CPU usage
    if [ "$cpu_usage_int" -gt "$cpu_usage_threshold" ]; then
        echo "High CPU usage detected: $current_cpu_usage%" >&2
    fi
}

# Function to check memory usage
check_memory_usage() {
    memory_usage_threshold=80  # Threshold in percentage
    current_memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

    memory_usage_int=${current_memory_usage%.*}  # Get integer part of the memory usage
    if [ "$memory_usage_int" -gt "$memory_usage_threshold" ]; then
        echo "High memory usage detected: $current_memory_usage%" >&2
    fi
}

# Function to check disk space
check_disk_space() {
    disk_usage_threshold=80  # Threshold in percentage
    current_disk_usage=$(df -h / | tail -n 1 | awk '{print $5}' | sed 's/%//')

    if [ "$current_disk_usage" -gt "$disk_usage_threshold" ]; then
        echo "High disk usage detected: $current_disk_usage%" >&2
    fi
}

# Function to check for specific running processes
check_running_processes() {
    process_name="nginx"  # Example process name
    count=$(pgrep -c "$process_name")

    if [ "$count" -eq 0 ]; then
        echo "Process $process_name is not running" >&2
    fi
}

# Main function to call each health check function
main() {
    check_cpu_usage
    check_memory_usage
    check_disk_space
    check_running_processes
}

# Call the main function
main
