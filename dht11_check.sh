#!/bin/bash

#export LC_NUMERIC=de_DE.UTF

# Get the reading from the sensor and strip the non-number parts
SENSOR="`/opt/whs/dht11`"
TEMP="`echo ${SENSOR} | cut -d ':' -f1`"
HUMIDITY="`echo ${SENSOR} | cut -d ':' -f2`"


MODE=${1-HUMIDITY}


WARN=${2-40}
CRIT=${3-50}


# Which mode is set?
if  [ "${MODE}" == "HUMIDITY" ]; then

        VALUE="`/usr/bin/printf "%.0f\n" ${HUMIDITY}`"
        TEXT="Humidity is ${VALUE}%"

elif  [ "${MODE}" == "TEMP" ]; then

        VALUE="`/usr/bin/printf "%.0f\n" ${TEMP}`"
        TEXT="Temperature is ${VALUE} deg.(C)"

else

        # no valid mode -> error
        echo "WARNING - Mode is not TEMP or HUMIDITY"
        exit 1

fi


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


        echo "CRITICAL: ${TEXT}"
        exit 2

elif [ "${VALUE}" -gt "${WARN}" ] ; then


        echo "WARNING: ${TEXT}"
        exit 1

else

        echo "OK: ${TEXT}"
        exit 0

fi
