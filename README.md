# SSL-Scanner
Script to scan all hosts on specific research subnets and pull their SSL certificate information into a file that can be opened easily by excel.

#Output format
Output will start with a header containing a title and the date and time that the script was run. The next line will be table headers of the following: Hostname,	IP address, Issued to,	Issued by,	Valid from, Valid to . Next, all of the responding hosts will give the information above seperated by tabs (which makes importing to excel very simple).
