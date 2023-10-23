#!/bin/bash

# starts each of the apm scripts
runProcs () {
	./APM1 192.168.122.1 &
	p1job=$(jobs | grep APM1 | cut -b 2)
	echo "$p1job"
	./APM2 127.0.0.1 &
	p2job=$(jobs | grep APM2 | cut -b 2)
	./APM3 127.0.0.1 &
	p3job=$(jobs | grep APM3 | cut -b 2)
	./APM4 127.0.0.1 &
	p4job=$(jobs | grep APM4 | cut -b 2)
	./APM5 127.0.0.1 &
	p5job=$(jobs | grep APM5 | cut -b 2)
	./APM6 127.0.0.1 &
	p6job=$(jobs | grep APM6 | cut -b 2)

}

# kills each of the apm scripts
killProcs () {
	kill %$p1job
	kill %$p2job
	kill %$p3job
	kill %$p4job
	kill %$p5job
	kill %$p6job

}

#collects process level metrics
procLvlCol () {
	# cpu util (ps)
	# ram util (ps)
	ps -o "%cpu %mem"
	# drive writes (df)
	# output cpu/ram util to <proc_name>_metrics.csv
	# format <seconds>, <%cpu>, <%ram>
	:
	
}

# collects system level metrics
sysLvlCol () {
	# network bandwith util
	# drive access rates
	# drive util	
	# write to system_metrics.csv
	# format <seconds>, <rx data rate>, <tx data rate>, <disk writes>, <available disk capacity>
	:
}


# main
runProcs
# main loop
while [[ true ]]
do
	procLvlCol
	sysLvlCol
	sleep 5
done
killProcs
