#!/bin/bash

sleep 3

xdotool type 'sv_cheats 1'
xdotool key 'Return'

xdotool type 'log_verbosity +console off'
xdotool key 'Return'

xdotool type 'log_verbosity -console off'
xdotool key 'Return'

xdotool type 'log_verbosity VScript default'
xdotool key 'Return'

xdotool type 'clear'
xdotool key 'Return'

xdotool type 'host_timescale 0'
xdotool key 'Return'
