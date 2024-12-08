#!/bin/bash

# CPU usage
cpu_usage=$(top -bn 1 | grep "%Cpu(s)" | awk '{print $2 + $4}') # -bn 1 = static snapshot of the system's current state 
# this outputs: us (user cpu time), sy (system cpu time), ni (nice cpu time), id (idle cpu time), wa (IO-wait cpu time)
# hi: Hardware IRQ CPU time, si: Software IRQ CPU time, st: Steal time
# Nice cpu time = time spent running processes that have been assigned a lower priority. 

# Memory usage
free_mem=$(free -m | grep Mem | awk '{print $4}')
total_mem=$(free -m | grep Mem | awk '{print $2}')
used_mem=$((total_mem - free_mem))
mem_usage_percent=$((used_mem * 100 / total_mem))

# Disk usage
total_disk=$(df -h / | grep /dev/sdc | awk '{print $2}')
# Convert to a numerical value (with memory it was not needed because we got the numerical values already)
total_disk=$(bc <<< "$total_disk")
disk_usage=$(df -h / | grep /dev/sdc | awk '{print $2}')
# Remove the "G" suffix
disk_usage="${disk_usage%G}"
# Convert to a numerical value
disk_usage=$(bc <<< "$disk_usage")
disk_usage_percent=$((disk_usage * 100 / total_disk))

# Top 5 CPU processes
top_cpu_processes=$(top -bn 1 | head -n 12 | tail -n 5)

# Top 5 memory processes
top_mem_processes=$(ps aux --sort -rss | head -n 6 | tail -n 5)

# OS information
os_version=$(cat /etc/os-release | grep PRETTY_NAME | awk -F '=' '{print $2}')
uptime=$(uptime) # how long the system has been running
load_avg=$(uptime | awk -F 'load average: ' '{print $2}') # system load over the past 1,5 and 15 minutes 
logged_in_users=$(who | wc -l)
failed_login_attempts=$(last -n 10 | grep 'Failed password' | wc -l)

# Print the results
echo "CPU Usage: $cpu_usage%"
echo "Memory Usage: $used_mem/$total_mem MB ($mem_usage_percent%)"
echo "Disk Usage: $disk_usage/$total_disk GB ($disk_usage_percent%)"
echo "Top 5 CPU Processes:"
echo "$top_cpu_processes"
echo "Top 5 Memory Processes:"
echo "$top_mem_processes"
echo "OS Version: $os_version"
echo "Uptime: $uptime"
echo "Load Average: $load_avg"
echo "Logged In Users: $logged_in_users"
echo "Failed Login Attempts (last 10): $failed_login_attempts"