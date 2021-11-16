# Author Kirk B. Wagoner
#
# Add single quotes to begining and end of each field that do not contain numerical data.
BEGIN { FS=OFS="," }
{
  for (i=1; i<=NF; ++i) { # Start at 1st field and increment until last field 
    if ($i ~ /[^0-9.]/) { # Test if numerical data or non-numerical data
      gsub("'","", $i)    # Remove any existing single quotes in field data
      $i = "'" $i "'"     # Add single quotes to beginning and end of field
    }
  }
  print    # Output 
}
