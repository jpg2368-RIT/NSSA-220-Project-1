#!/bin/bash

runProgs:
  ./APM1 &
  ./APM2 &
  ./APM3 &
  ./APM4 &
  ./APM5 &
  ./APM6 &

  killProgs:
    #kill %<jobNum>
