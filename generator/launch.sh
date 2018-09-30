#!/bin/bash -x

set -e

CSV_DIR="database/csv"
LUA_DIR="database/lua"
RESULT_DIR="../bots/database"

./ods2csv.sh

./generator.py $CSV_DIR/buy.csv > $LUA_DIR/buy.lua
./generator.py $CSV_DIR/farm.csv > $LUA_DIR/farm.lua
./generator.py $CSV_DIR/recovery.csv > $LUA_DIR/recovery.lua
./generator.py $CSV_DIR/offensive.csv > $LUA_DIR/offensive.lua
./generator.py $CSV_DIR/defensive.csv > $LUA_DIR/defensive.lua

./linker.py $LUA_DIR/buy.lua $LUA_DIR/recovery.lua $LUA_DIR/defensive.lua $LUA_DIR/offensive.lua $LUA_DIR/farm.lua > $RESULT_DIR/objectives.lua

./check.sh
