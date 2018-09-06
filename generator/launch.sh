#!/bin/bash -x

set -e

CSV_DIR="database/csv"
RESULT_DIR="../bots/database"

./ods2csv.sh

./generator.py $CSV_DIR/farm.csv > $RESULT_DIR/farm.lua
./generator.py $CSV_DIR/recovery.csv > $RESULT_DIR/recovery.lua
./generator.py $CSV_DIR/offensive.csv > $RESULT_DIR/offensive.lua
./generator.py $CSV_DIR/defensive.csv > $RESULT_DIR/defensive.lua

./check.sh
