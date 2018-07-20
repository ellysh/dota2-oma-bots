#!/bin/bash -x

set -e

CSV_DIR="database/csv"
RESULT_DIR="../bots/database"

./ods2csv.sh

./generator.py OBJECTIVES 4 $CSV_DIR/objectives.csv > $RESULT_DIR/objectives.lua

./check.sh
