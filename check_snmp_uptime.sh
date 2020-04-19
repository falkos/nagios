#!/bin/bash
#
# Autor: Falko Saller
# Version: 1.5
# Date: 19.04.2020
#
#
# This small Nagios plugin checks the uptime of a device. 
# This can detect reboots between two check intervals. 
#
# Usage: check_snmp_uptime.sh 192.168.0.1 public iso.3.6.1.2.1.1.8.0
#
# Example OIDs: 
# Synology NAS: iso.3.6.1.2.1.25.1.1.0
# HP Switch:    iso.3.6.1.2.1.1.8.0 
#
#
# Exit Code and Service States
# 0 = OK UP
# 1 = WARNING  UP or DOWN/UNREACHABLE*
# 2 = CRITICAL DOWN/UNREACHABLE
# 3 = UNKNOWN  DOWN/UNREACHABLE
#




# Write the log output to Syslogseconds
shopt -s expand_aliases
alias log_error='logger -t nagios_check --id=$$ -p local0.err'
alias log_info='logger -t nagios_check --id=$$ -p local0.info'


WARN_SEC=3600 # If the uptime is less than 3600 seconds (one hour) change the status to warning
CRIT_SEC=600  # If it is less than 600 seconds (10 minutes), change the status to critical


# Default SNMP Values
DEFAULT_SNMP_HOST=192.168.0.30 # Hostname or IP of the device
DEFAULT_SNMP_COMMUNITY="public" # snmp community string of the device
DEFAULT_SNMP_OID="iso.3.6.1.2.1.25.1.1.0" # snmp OID for the Uptime

# Passed parameters
SNMP_HOST=$1 # Hostname or IP of the device
SNMP_COMMUNITY=$2 # community string 
SNMP_OID=$3 # snmp OI

# check if a parameter is passed, if not take the default
if [ -z "$SNMP_HOST" ]; then
   SNMP_HOST=$DEFAULT_SNMP_HOST
fi

if [ -z "$SNMP_COMMUNITY" ]; then
   SNMP_COMMUNITY=$DEFAULT_SNMP_COMMUNITY
fi

if [ -z "$SNMP_OID" ]; then
   SNMP_OID=$DEFAULT_SNMP_OID
fi

# Retrieve SNMP data from the device
SNMP_GET=$(snmpget -Ov -v2c -c ${SNMP_COMMUNITY} ${SNMP_HOST} ${SNMP_OID} 2>&1)
if [ "$?" -ne "0" ]
then
   log_error "Failed to get the snmp values from Host! ${SNMP_GET}" 
   exit 1
else
   UPTIME_TICKS=$(echo ${SNMP_GET} | cut -d "(" -f 2 | cut -d ")" -f 1) # Uptime in seconds
   UPTIME_ISO=$(echo ${SNMP_GET} | cut -d "(" -f 2 | cut -d ")" -f 2) # Uptime / Date
fi

# Check type of the variables to exclude syntax errors further down
if [ "${CRIT_SEC//[0-9]*}" != "" ]; then # If Crit a Number?
        echo "UNKNOWN: The value of CRIT must be a number"
        exit 3
elif [ "${WARN_SEC//[0-9]*}" != "" ]; then # If Warn a Number?
        echo "UNKNOWN: The value of WARN must be a number"
        exit 3
elif [ "${UPTIME_TICKS//[0-9]*}" != "" ]; then # If UPTIME_TICKS contains a Number?
        echo "UNKNOWN: \$VALUE is not a Number"
        exit 3
fi


# Check uptime and output message / exit code
if [ "${UPTIME_TICKS}" -lt "${CRIT_SEC}" ] ; then
   echo "CRITICAL: The Uptime is ${UPTIME_ISO} "
   exit 2
elif [ "${UPTIME_TICKS}" -lt "${WARN_SEC}" ] ; then
   echo "WARNING: The Uptime is ${UPTIME_ISO} "
   exit 1
else
   echo "OK: The Uptime is ${UPTIME_ISO}"
   exit 0
fi
