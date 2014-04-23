#! /bin/bash


WARN=${1-46}
CRIT=${2-75}
VALUE=$(($(</sys/class/thermal/thermal_zone0/temp) / 1000))

if [ "${CRIT//[0-9]*}" != "" ]; then # If Crit a Number?

        echo "ERROR: The value of CRIT must be a number"
        exit 1


elif [ "${WARN//[0-9]*}" != "" ]; then # If Warn a Number?

        echo "ERROR: The value of WARN must be a number"
        exit 1

elif [ "${VALUE//[0-9]*}" != "" ]; then # If Value a Number?

        echo "ERROR: \$VALUE is not a Number"
        exit 1

fi



### Main Code ###
if [ "${VALUE}" -gt "${CRIT}" ] ; then


	echo "CRITICAL: SoC temperature is $temp deg.(C) "
	exit 2

elif [ "${VALUE}" -gt "${WARN}" ] ; then


	echo "WARNING: SoC temperature is $temp deg.(C) "
	exit 1

else

	echo "OK: SoC temperature is $temp deg.(C) "
	exit 0

fi
