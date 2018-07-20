#!/bin/bash -x

DATABASE_DIR="database/docs"
TEMP_DIR="database/temp"
CSV_DIR="database/csv"

ssconvert -S -O 'separator=;' "$DATABASE_DIR/Database.ods" "$TEMP_DIR/Database.txt"

cp "$TEMP_DIR/Database.txt.0" "$CSV_DIR/objectives.csv"
