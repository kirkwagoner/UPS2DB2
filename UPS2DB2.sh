# Written by Kirk B. Wagoner
# Copyright 2018 by Kirk B. Wagoner
# 
# IBM Z/os Qshell script for importing exteremely large csv files from United Parcel Service into DB2 for later querying.
# 
# A QSHELL script to run a query, output to text, run a Korn shell script for data validation and create SQL file, upload sql file into db2_log.
# This file requires other script files to do validation.
# 
# Program flow:
#   1 - Create a list of UPS (United Parcel Service) Invoices you have already uploaded into DB2.
#   2 - Call ups2db2.ksh script.
#   3 - Have user select new UPS csv file to import.
#   4 - Assign temporary file names and locations.
#   5 - Call zip_sort_Generic.awk to filter and reject records (zipcodes,returns, transfers).
#   6 - Make all records 250 fields long.
#   7 - Fix delimiters.
#   8 - Create SQL INSERT file.
#   9 - Load SQL file into DB2.
# 

DATE=`date +%m%d%Y`
TIME=`date +%H%M`
# Get file of existing Invoice_Numbers
DB2 # Login or connection details # -d 10.1.1.1 -u USERNAME -p PASSWORD
# DB2 SQL STATEMENT TO EXECUTE  then pipe to TAIL to remove first and last 4 rows and output to a text file. DB2 output has 4 lines of Header and footer information.
DB2 'SELECT DISTINCT(INVOICE_NUMBER) FROM DATABASE.TABLE;' | tail +4 | tail -r | tail +4 | tail -r > /invoice_numbers.txt

# Run Korn Shell script to complete data manipulation/validation tasks
./ups2db2.ksh

# DB2 Commands from script
echo "Loading Data into DB."

DB2 # Login or connection details # -d 10.1.1.1 -u USERNAME -p PASSWORD
# Measure time it takes to Run sql file and capture output in text file
# -t semicolons end SQL statments, -f run SQL file
time DB2 -tf /insert_file.sql > /db2_log_${DATE}_${TIME}.txt

# Add any cleanup code to remove temp files

echo "All Done!"
