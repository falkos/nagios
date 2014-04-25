#!/bin/bash

# Get the reading from the sensor and strip the non-number parts
SENSOR="`sudo /opt/whs/dht11`"
TEMP="`echo ${SENSOR} | cut -d ':' -f1 | awk '{printf "%.0f\n", $1}' `"
HUMIDITY="`echo ${SENSOR} | cut -d ':' -f2 | awk '{printf "%.0f\n", $1}' `"


MODE=${1-HUMIDITY}


WARN=${2-40}
CRIT=${3-50}
VALUE=0


if [ "${CRIT//[0-9]*}" != "" ]; then # If Crit a Number?

        echo "ERROR: The value of CRIT must be a number"
        exit 2

elif [ "${WARN//[0-9]*}" != "" ]; then # If Warn a Number?

        echo "ERROR: The value of WARN must be a number"
        exit 2

elif [ "${TEMP}" -eq 0 ]; then # If TEMP a Number?

        echo "ERROR: The value of TEMP must be a number"
        exit 2

elif [ "${HUMIDITY}" -eq 0  ]; then # If HUMIDITY a Number?

        echo "ERROR: The value of HUMIDITY must be a number"
        exit 2

fi


# Which mode is set?
if  [ "${MODE}" == "HUMIDITY" ]; then

		VALUE=${HUMIDITY}
        TEXT="Humidity is ${VALUE}%"

elif  [ "${MODE}" == "TEMP" ]; then

		VALUE=${TEMP}
        TEXT="Temperature is ${VALUE} deg.(C)"

else

        # no valid mode -> error
        echo "WARNING - Mode is not TEMP or HUMIDITY"
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
