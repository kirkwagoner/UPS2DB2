# UPS2DB2
Author: Kirk B Wagoner- 2018

Scripts to filter and import UPS (United Parcel Service) csv files into IBM Z/os DB2 database. 
Uses QShell, Korn shell scripts.

United Parcel Service (UPS) account holders have an option to download a csv of their account data for internal business uses.
Companies that ship and receive large quantities of packages may want to query such data on their IBM Z/os systems.
The UPS csv files are poorly formatted and unsuitable for directly importing. 
The files have 250 columns or fields with 4-6 rows of records per individual shipment.

These scripts will help format and filter the UPS csv file into a SQL file that can be imported/loaded into DB2 data base.

Scripts included:
- Setup scripts
  - DB_CREATE.sql     -Create DB2 table for data import

- Main scripts
  - UPS2DB2.sh        - QSHEll script - Starting script
  - ups2db2.ksh       - Korn shell script - Main process scripting
  - zipsort.awk       - Awk script - filter invoices, and stores
  - delmit.awk        - Awk script - Properly delimit text fields with single quotes

- Temporay files
  - ./tmp/tmp1.csv    - Intermediate file that formatting/filetring operations
  - ./tmp/tmp2.csv    - Intermediate file that formatting/filetring operations
  - ./output/tmp_rjct1_DATE_TIME.csv   - Records rejected by zipcode in zipsort.awk (verify filtering criteria)
  - ./output/tmp_rjct2_DATE_TIME.csv   - Records rejected by invoice in zipsort.awk (verify invoice filtering)
  - ./output/sqlfile.sql     - SQL file of INSERT statements
  
Folder/Directory structure
  UPS2DB2   # Top level - contains scripts
  UPS2DB2/input   # Place UPS.csv files here
  UPS2DB2/output  # Location of various output files, helpful for troubleshooting record filtering and formating when testing, auto remove in production
  UPS2DB2/tmp     # Location of temporary files, helpful for troubleshooting record filtering and formating when testing, auto remove in production
