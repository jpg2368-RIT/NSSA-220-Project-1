#!/bin/bash

kill $(ps -a | grep "APM" | xargs | cut -d " " -f 1)
echo "Killed all APM scripts"
