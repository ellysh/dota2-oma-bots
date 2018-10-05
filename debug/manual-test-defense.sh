#!/bin/bash

sleep 3

# Give items, gold and level to the player

xdotool type 'dota_create_item item_shivas_guard'
xdotool key 'Return'

xdotool type 'dota_create_item item_shivas_guard'
xdotool key 'Return'

xdotool type 'dota_create_item item_heart'
xdotool key 'Return'

xdotool type 'dota_create_item item_travel_boots_2'
xdotool key 'Return'

xdotool type 'dota_create_item item_greater_crit'
xdotool key 'Return'

#xdotool type 'dota_hero_level 15'
#xdotool key 'Return'

xdotool type 'dota_give_gold 99999'
xdotool key 'Return'

#exit 1

# Give items, gold and level to the bot

xdotool type 'dota_bot_give_item item_boots'
xdotool key 'Return'

xdotool type 'dota_bot_give_item item_gloves'
xdotool key 'Return'

xdotool type 'dota_bot_give_item item_boots_of_elves'
xdotool key 'Return'

xdotool type 'dota_bot_give_item item_mask_of_madness'
xdotool key 'Return'

xdotool type 'dota_bot_give_item item_ring_of_basilius'
xdotool key 'Return'

xdotool type 'dota_bot_give_level 1'
xdotool key 'Return'

xdotool type 'dota_bot_give_gold 1200'
xdotool key 'Return'

xdotool type 'host_timescale 0'
xdotool key 'Return'
