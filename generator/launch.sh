#!/bin/bash -x

set -e

CSV_DIR="database/csv"
RESULT_DIR="database/lua"

./ods2csv.sh

./generator.py $CSV_DIR/objectives.csv > $RESULT_DIR/objectives.lua

./check.sh
