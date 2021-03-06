#!/bin/bash

DESTINATION_FOLDER="./output"

# Ensure that the script has the right number of arguments
if [ ! $# -eq 2 ] ; then
	echo "Usage: process.sh <source folder> <destination file>"
	echo "Destination file will be placed in $DESTINATION_FOLDER/"
	exit 1
fi

SOURCE_FOLDER=$1

# Ensure that $SOURCE_FOLDER exists and is a folder
if [ ! -d "$SOURCE_FOLDER" ] ; then
	echo "Error: $SOURCE_FOLDER must be a directory"
	exit 1
fi

# Create the output folder if it doesn't exist
if [ ! -d "$DESTINATION_FOLDER" ] ; then
	mkdir "$DESTINATION_FOLDER"
fi


DESTINATION_FILE="$DESTINATION_FOLDER/$2"

# Start with the list of tables
cp src/gtfs_tables.sqlite "$DESTINATION_FILE.sql"

# Process the GTFS data into SQL
python src/import_gtfs_to_sql.py "$SOURCE_FOLDER" nocopy >> "$DESTINATION_FILE.sql"

# Generate a .sqlite database from this SQL file
cat "$DESTINATION_FILE.sql" | sqlite3 "$DESTINATION_FILE.sqlite"

# Tidy up
rm "$DESTINATION_FILE.sql"
