# Written by Kirk B. Wagoner
# Copyright 2018 by Kirk B. Wagoner
# 
#  # IBM Z/os Korn shell script for 
#  Filter file to remove non complaint records.
#  Such as store to store transfers, blank records, etc
# 

# Function to create array of invoices and count
function read_file_into_array(file, array) {
   count  = 0;
   while (1) {
      status = getline record < file
      if (status == -1) {
         print "Failed to read file " file;
         exit 1;
      }
      if (status == 0) break;
      array[record] = ++count;
   }
   close(file);
   return count
}

BEGIN {
    invoice_file = ARGV[1];
    records_count = read_file_into_array(invoice_file, Invoices)    # Call function to create array of already processed invoice numbers and record count.   
    print "Number of unique invoices: ",records_count,".";
    print "Begining removal of non compliant records.";
    
    FS=",";          # Set Field Separator to comma.

    # Create array of store zipcodes to include - Change as needed
    store_zipcodes[53265] = 0
    store_zipcodes[54266] = 1
    store_zipcodes[55612] = 2
    store_zipcodes[56613] = 3
    store_zipcodes[57106] = 4
    store_zipcodes[58241] = 5
    store_zipcodes[59701] = 6
    store_zipcodes[99911] = 7
    store_zipcodes[88913] = 8
    store_zipcodes[77915] = 9

}


# Main reject or exclude rows
{
if($6 in Invoices || $6 == 0 || $6 == "")    # Exclude already used invoices, empty invoice number, invoice number zero
    { print $0 > out_i;}                     # Print to file invoices rejected
else
    {
     if($81 == "" || toupper($16) ~ /RETURN/ || toupper($67) ~ /COMPANY_NAME/ || toupper($68) ~ /COMPANY_NAME/ )    # Reject Returns and Store to Store transfers change to actual store name.
         { print $0 > out_r; }    # Print to file records rejected as returns or store to store transfers
     else if ($81 in store_zipcodes)    # Print to file if zipcode is in store list
         { print $0 > "./output/outfile_1.csv"; }
     else { print $0 > out_r;}     # Print to file if otherwise rejected
    }
}

END { print "Complete."; }
