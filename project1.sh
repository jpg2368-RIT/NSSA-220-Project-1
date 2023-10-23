#!/bin/bash

# starts each of the apm scripts
runProcs () {
	./APM1 192.168.122.1 &
	p1job=$(jobs | grep APM1 | cut -b 2)
	./APM2 192.168.122.1 &
	p2job=$(jobs | grep APM2 | cut -b 2)
	./APM3 192.168.122.1 &
	p3job=$(jobs | grep APM3 | cut -b 2)
	./APM4 192.168.122.1 &
	p4job=$(jobs | grep APM4 | cut -b 2)
	./APM5 192.168.122.1 &
	p5job=$(jobs | grep APM5 | cut -b 2)
	./APM6 192.168.122.1 &
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
	:
}

# collects system level metrics
sysLvlCol () {
	:
}


# main
runProcs
sleep 4
procLvlCol
sysLvlCol
killProcs
