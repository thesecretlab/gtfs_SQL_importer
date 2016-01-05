#!/bin/bash

DESTINATION_FOLDER="./output"

if [ $# -neq 2 ] ; then
	echo "Usage: process.sh <source folder> <destination file>"
	echo "Destination file will be placed in $DESTINATION_FOLDER/"
fi

if [ ! -d $DESTINATION_FOLDER ] ; then
	mkdir $DESTINATION_FOLDER
fi

SOURCE_FOLDER=$1
DESTINATION_FILE="$DESTINATION_FOLDER/$2"

# Start with the list of tables
cp src/gtfs_tables.sqlite $DESTINATION_FILE.sql

# Process the GTFS data into SQL
python src/import_gtfs_to_sql.py $SOURCE_FOLDER nocopy >> $DESTINATION_FILE.sql

# Generate a .sqlite database from this SQL file
cat $DESTINATION_FILE.sql | sqlite3 $DESTINATION_FILE.sqlite

# Tidy up
rm $DESTINATION_FILE.sql
