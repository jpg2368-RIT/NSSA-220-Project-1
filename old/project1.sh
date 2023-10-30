#!/bin/bash

# starts each of the apm scripts
runProcs () {
	./APM1 192.168.122.1 &
	p1pid=$!
	./APM2 127.0.0.1 &
	p2pid=$!
	./APM3 127.0.0.1 &
	p3pid=$!
	./APM4 127.0.0.1 &
	p4pid=$!
	./APM5 127.0.0.1 &
	p5pid=$!
	./APM6 127.0.0.1 &
	p6pid=$!
}

# kills each of the apm scripts
killProcs () {
	kill "$p1pid"
	kill "$p2pid"
	kill "$p3pid"
	kill "$p4pid"
	kill "$p5pid"
	kill "$p6pid"
	#kill $(ps -a | grep APM | cut -d " " -f 1)
	exit 0
}

#collects process level metrics
procLvlCol () {
	# cpu util (ps) [DONE]
	# ram util (ps) [DONE]
	# output cpu/ram util to <proc_name>_metrics.csv [DONE]
	# format <seconds>,<%cpu>,<%ram>
	cpu1=$(ps -p $p1pid -o %cpu | tail -1 | xargs)	
	ram1=$(ps -p $p1pid -o %mem | tail -1 | xargs)
	echo "$SECONDS,$cpu1,$ram1" >> APM1_metrics.csv
	
	cpu2=$(ps -p $p2pid -o %cpu | tail -1 | xargs)	
	ram2=$(ps -p $p2pid -o %mem | tail -1 | xargs)
	echo "$SECONDS,$cpu2,$ram2" >> APM2_metrics.csv

	cpu3=$(ps -p $p3pid -o %cmd | tail -1 | xargs)	
	ram3=$(ps -p $p3pid -o %mem | tail -1 | xargs)
	echo "$SECONDS,$cpu3,$ram3" >> APM3_metrics.csv

	cpu4=$(ps -p $p4pid -o %cpu | tail -1 | xargs)	
	ram4=$(ps -p $p4pid -o %mem | tail -1 | xargs)
	echo "$SECONDS,$cpu4,$ram4" >> APM4_metrics.csv

	cpu5=$(ps -p $p5pid -o %cpu | tail -1 | xargs)	
	ram5=$(ps -p $p5pid -o %mem | tail -1 | xargs)
	echo "$SECONDS,$cpu5,$ram5" >> APM5_metrics.csv

	cpu6=$(ps -p $p6pid -o %cpu | tail -1 | xargs)	
	ram6=$(ps -p $p6pid -o %mem | tail -1 | xargs)
	echo "$SECONDS,$cpu6,$ram6" >> APM6_metrics.csv	
}

# collects system level metrics
sysLvlCol () {
	# network bandwith util (ifstat) [DONE]
	# drive write rate (iostat) [DONE]
	# drive space left (df) [DONE]
	# write to system_metrics.csv [DONE]
	# format <seconds>,<rx data rate>,<tx data rate>,<disk writes>,<available disk capacity>
	
	rxrate=$(ifstat ens33 -t 1 | grep ens33 | xargs | cut -d " " -f 6)
	txrate=$(ifstat ens33 -t 1 | grep ens33 | xargs | cut -d " " -f 8)

	dwrites=$(iostat sda | grep sda | xargs | cut -d " " -f 4)

	diskcap=$(df / -h -B M| grep / | xargs | cut -d " " -f 4)
	diskcap=${diskcap:0:-1}

	echo "$SECONDS,$rxrate,$txrate,$dwrites,$diskcap" >> system_metrics.csv
}


# main
trap killProcs SIGINT
runProcs

time_output="seconds"
end_time=0
if [ $# -ge 1 ]
then
        end_time=$1
        time_output="/ $end_time seconds"
fi

# main loop
while [[ true ]]
do
# prevent mismatching time due to sequential process
seconds=$SECONDS
	if (( $seconds % 5 == 0 ))
	then	
		procLvlCol
	fi
	if (( $seconds % 2 == 0 ))
	then
		sysLvlCol
	fi
	if [ $end_time -ne 0 ] && [ $seconds -ge $end_time ]
	then
		echo ""
		killProcs		
		exit 0
	fi
	echo -ne "\r$seconds $time_output"
	sleep 1
done
trap killProcs EXIT 2> /dev/null
