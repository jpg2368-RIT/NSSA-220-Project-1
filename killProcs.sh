#!/bin/bash

kill $(ps -a | grep APM | cut -d " " -f 1)
echo "Killed all APM scripts"
