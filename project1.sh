#!/bin/bash

# starts each of the apm scripts
runProcs () {
	./APM1 192.168.122.1 &
	#p1job=$(jobs | grep APM1 | cut -b 2)
	p1pid=$(ps | grep APM1 | cut -d " " -f 1)
	./APM2 127.0.0.1 &
	#p2job=$(jobs | grep APM2 | cut -b 2)
	p2pid=$(ps | grep APM2 | cut -d " " -f 1)
	./APM3 127.0.0.1 &
	#p3job=$(jobs | grep APM3 | cut -b 2)
	p3pid=$(ps | grep APM3 | cut -d " " -f 1)
	./APM4 127.0.0.1 &
	#p4job=$(jobs | grep APM4 | cut -b 2)
	p4pid=$(ps | grep APM4 | cut -d " " -f 1)
	./APM5 127.0.0.1 &
	#p5job=$(jobs | grep APM5 | cut -b 2)
	p5pid=$(ps | grep APM5 | cut -d " " -f 1)
	./APM6 127.0.0.1 &
	#p6job=$(jobs | grep APM6 | cut -b 2)
	p6pid=$(ps | grep APM6 | cut -d " " -f 1)

}

# kills each of the apm scripts
killProcs () {
	kill "$p1pid"
	kill "$p2pid"
	kill "$p3pid"
	kill "$p4pid"
	kill "$p5pid"
	kill "$p6pid"
	exit 0

}

#collects process level metrics
procLvlCol () {
	# cpu util (ps)
	# ram util (ps)
	# drive writes (df)
	# output cpu/ram util to <proc_name>_metrics.csv
	# format <seconds>,<%cpu>,<%ram>
	cpu1=$(ps -au | grep APM1 | head -n 1 | cut -d " " -f 6)
	ram1=$(ps -au | grep APM1 | head -n 1 | cut -d " " -f 8)
	echo "$SECONDS,$cpu1,$ram1" >> APM1_metrics.csv
	
	local cpu2=$(ps -au | grep APM2 | head -n 1 | cut -d " " -f 6)
	local ram2=$(ps -au | grep APM2 | head -n 1 | cut -d " " -f 8)
	echo "$SECONDS,$cpu2,$ram2" >> APM2_metrics.csv

	local cpu3=$(ps -au | grep APM3 | head -n 1 | cut -d " " -f 6)
	local ram3=$(ps -au | grep APM3 | head -n 1 | cut -d " " -f 8)
	echo "$SECONDS,$cpu3,$ram3" >> APM3_metrics.csv

	local cpu4=$(ps -au | grep APM4 | head -n 1 | cut -d " " -f 6)
	local ram4=$(ps -au | grep APM4 | head -n 1 | cut -d " " -f 8)
	echo "$SECONDS,$cpu4,$ram4" >> APM4_metrics.csv

	local cpu5=$(ps -au | grep APM5 | head -n 1 | cut -d " " -f 6)
	local ram5=$(ps -au | grep APM5 | head -n 1 | cut -d " " -f 8)
	echo "$SECONDS,$cpu5,$ram5" >> APM5_metrics.csv

	local cpu6=$(ps -au | grep APM6 | head -n 1 | cut -d " " -f 6)
	local ram6=$(ps -au | grep APM6 | head -n 1 | cut -d " " -f 8)
	echo "$SECONDS,$cpu6,$ram6" >> APM6_metrics.csv
	:
	
}

# collects system level metrics
sysLvlCol () {
	# network bandwith util
	# drive access rates
	# drive util	
	# write to system_metrics.csv
	# format <seconds>,<rx data rate>,<tx data rate>,<disk writes>,<available disk capacity>
	:
}


# main
trap killProcs SIGINT
runProcs
# main loop
while [[ true ]]
do
	procLvlCol
	sysLvlCol
	sleep 5
done
trap killProcs EXIT 2> /dev/null
