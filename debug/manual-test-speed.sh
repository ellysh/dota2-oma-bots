#!/bin/bash

sleep 3

# Give items, gold and level to the player

xdotool type 'dota_create_item item_travel_boots_2'
xdotool key 'Return'

xdotool type 'dota_create_item item_cyclone'
xdotool key 'Return'

xdotool type 'dota_create_item item_cyclone'
xdotool key 'Return'

xdotool type 'dota_create_item item_cyclone'
xdotool key 'Return'

xdotool type 'dota_create_item item_cyclone'
xdotool key 'Return'

xdotool type 'dota_create_item item_flask'
xdotool key 'Return'

xdotool type 'dota_create_item item_flask'
xdotool key 'Return'

xdotool type 'dota_create_item item_flask'
xdotool key 'Return'

xdotool type 'dota_hero_level 6'
xdotool key 'Return'

xdotool type 'dota_give_gold 99999'
xdotool key 'Return'

#exit 1

# Give items, gold and level to the bot

xdotool type 'dota_bot_give_item item_flask'
xdotool key 'Return'

xdotool type 'dota_bot_give_item item_flask'
xdotool key 'Return'

xdotool type 'dota_bot_give_item item_flask'
xdotool key 'Return'

xdotool type 'dota_bot_give_item item_flask'
xdotool key 'Return'

xdotool type 'dota_bot_give_level 1'
xdotool key 'Return'

xdotool type 'dota_bot_give_gold 1200'
xdotool key 'Return'

xdotool type 'host_timescale 0'
xdotool key 'Return'
