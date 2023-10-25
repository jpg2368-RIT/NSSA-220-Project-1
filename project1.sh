#!/bin/bash

# starts each of the apm scripts
runProcs () {
	./APM1 192.168.122.1 &
	p1pid=$!
	echo "APM1: $p1pid"
	./APM2 127.0.0.1 &
	p2pid=$!
	echo "APM2: $p2pid"
	./APM3 127.0.0.1 &
	p3pid=$!
	echo "APM3: $p3pid"
	./APM4 127.0.0.1 &
	p4pid=$!
	echo "APM4: $p4pid"
	./APM5 127.0.0.1 &
	p5pid=$!
	echo "APM5: $p5pid"
	./APM6 127.0.0.1 &
	p6pid=$!
	echo "APM6: $p6pid"

}

# kills each of the apm scripts
killProcs () {
	#kill "$p1pid"
	#kill "$p2pid"
	#kill "$p3pid"
	#kill "$p4pid"
	#kill "$p5pid"
	#kill "$p6pid"
	kill $(ps -a | grep APM | cut -d " " -f 1)
	exit 0

}

#collects process level metrics
procLvlCol () {
	# cpu util (ps) [DONE]
	# ram util (ps) [DONE]
	# drive writes (df) [UNFINISHED]
	# output cpu/ram util to <proc_name>_metrics.csv [DONE]
	# format <seconds>,<%cpu>,<%ram>
	cpu1=$(ps -p $p1pid -o %cpu | tail -1 | xargs)	
	ram1=$(ps -p $p1pid -o %mem | tail -1 | xargs)
	echo "$SECONDS,$cpu1,$ram1" >> APM1_metrics.csv
	
	cpu2=$(ps -p $p2pid -o %cpu | tail -1 | xargs)	
	ram2=$(ps -p $p2pid -o %mem | tail -1 | xargs)
	echo "$SECONDS,$cpu2,$ram2" >> APM2_metrics.csv

	local cpu3=$(ps -p $p3pid -o %cmd | tail -1 | xargs)	
	local ram3=$(ps -p $p3pid -o %mem | tail -1 | xargs)
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
	# network bandwith util [UNFINISHED]
	# drive access rates [UNFINISHED]
	# drive util [UNFINISHED]
	# write to system_metrics.csv [UNFINISHED]
	# format <seconds>,<rx data rate>,<tx data rate>,<disk writes>,<available disk capacity>
	:
}


# main
trap killProcs SIGINT
runProcs
# main loop
while [[ true ]]
do
	if (( $SECONDS % 5 == 0 ))
	then	
		procLvlCol
		sysLvlCol
		sleep 2
	fi
done
trap killProcs EXIT 2> /dev/null
