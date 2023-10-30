#!/bin/bash

# starts each of the apm scripts
run_procs () {
	apms=("APM1" "APM2" "APM3" "APM4" "APM5" "APM6")
	ip="127.0.0.1"
	pids=()
	for i in ${!apms[@]}; do
		./${apms[$i]} $ip &
		# $! get the most recently executed background process
		pids+=($!)
	done
}

# kills each of the apm scripts
kill_procs () {
	for pid in ${pids[@]}; do
		kill "$pid"
	done
	echo ""
	exit 0
}

# collect process level
proc_lvl_col () {
	# collect ps of all pids at once, remove header, and remove newline
	apms_cpu_mem_output=($(echo "${pids[@]}" | ps -p $(sed 's/ /,/g') -o "%cpu %mem"| tail -n +2 | tr '\n' ' '))
	#echo "$apms_cpu_mem_output" | IFS=" " read -a apms_cpu_mem_output
	# write cpu and mem to respective APM#
	for ((i=0; i < ${#apms_cpu_mem_output[@]}; i+=2)); do
		echo "$seconds,${apms_cpu_mem_output[$i]},${apms_cpu_mem_output[$i+1]}" >> APM$((i/2+1))_metrics.csv
	done
}

sys_lvl_col () {
	rx_tx_rate=$(ifstat ens33 -t 1 | grep ens33 | xargs | cut -d " " -f 6,8 | tr ' ' ',')
	
	dwrites=$(iostat sda | grep sda | xargs | cut -d " " -f 4)

        diskcap=$(df / -h -B M| grep / | xargs | cut -d " " -f 4)
        diskcap=${diskcap:0:-1}

        echo "$seconds,$rx_tx_rate,$dwrites,$diskcap" >> system_metrics.csv
}

#main
trap kill_procs SIGINT
run_procs

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
                proc_lvl_col &
        fi
        if (( $seconds % 2 == 0 ))
        then
                sys_lvl_col &
        fi
        if [ $end_time -ne 0 ] && [ $seconds -ge $end_time ]
        then
                kill_procs
                exit 0
        fi
        echo -ne "\r$seconds $time_output"
        sleep 1
done
trap kill_procs EXIT 2> /dev/null

