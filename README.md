# nmap-grepper

## About
Flattens Nmap "greppable" input into a tab-delimited table, making it easy to combine, search and select from a large number of .gnmap files. It reads .gnmap input from STDIN and writes tab-delimited lines of fields to STDOUT, __1 line per open port__, as in the following model:

```1:IP Address <tab> 2:Hostname <tab> 3:Port <tab> 4:Protocol <tab> 5:Service Name <tab> 6:Service Banner <newline>```

If you're in the habit of scanning large networks with Nmap, sometimes you want query the results to answer combinations of questions like:
* Are there any services running on non-standard ports?
* Where are my database servers?
* What versions of SSH are we running?

And so on. Often, automated vulnerability scanners can miss open services, or can fail to spot services hiding on non-standard ports. Nmap-grepper helps you to query large sets of gnmap files and delve deeper into your network.

## Example Usage
Pre-requisites: A bunch of previously generated .gnmap files. Assuming you've already performed an nmap scan of your network(s), specifying the -oA or -oG options with one or more commands along the lines of:

```nmap -vv -Pn -sS -sV -sC -A -p 1-65535 -oA outfile1 192.168.33.0/24  # Will produce output including outfile1.gnmap```

Nmap-grepper is most useful when combined with text processing tools like grep/cut/sort and so on. For example we might want to find all ssh services, even those on non-standard ports:

```#concatenate all gnmap files in the current dir, pipe into nmap-grepper, then cut fields 1,3,6 (IP, Port, Service Banner), grep for ssh, then sort uniquely```

```cat *gnmap | ./nmap-grepper.pl | cut -f1,3,6 | grep -i "ssh" | sort -u```

You might see output like this:

![image](https://user-images.githubusercontent.com/108018363/208949466-5e6db22b-6565-44f5-a3dd-6187195abd5a.png)

Or, you might want to look for anything that could be a SQL database:

```cat *gnmap | ./nmap-grepper.pl|cut -f1,3,6|grep -i "sql"|sort -u```

![image](https://user-images.githubusercontent.com/108018363/208955800-11863b28-aae3-4ded-9d50-6e4d32e2e8be.png)

Or maybe something Java-related:

```cat *gnmap | ./nmap-grepper.pl|cut -f1,3,6|grep -i "java"|sort -u```

![image](https://user-images.githubusercontent.com/108018363/208956057-c79d1339-7ef6-4773-b941-fd49dcc80a1e.png)

You are limited only by your own ingenuity!

## Top Tips

### Search Limiting
If you want to limit the search to the exact contents of a field, for example you want to search for the whole IP address "192.168.33.14" but you don't want grep to also match "192.168.33.14*". then include the tab delimiter in your grep command, eg:

```cat *gnmap | ./nmap-grepper.pl|cut -f1,3,5,6|grep -i 192.168.33.14$'\t' |sort -u```

### Search Extending 
Extend the range of fields you include (or remove the cut altogether) to enable searching on other fields such as hostname.


### Import into Excel via .txt file 
A very useful tip if you need to include any output for reporting or further processing. Save your output into a .txt file:

```cat *gnmap | ./nmap-grepper.pl | cut -f1,3,6 | grep -i "ssh" | sort -u > textfile.txt```


Then open the file in Excel, making sure to select "text files" as the file type:

![image](https://user-images.githubusercontent.com/108018363/208962360-5bb9f3b8-c198-4208-9d8d-06de1e5e84e2.png)


Excel will detect the file is delimited. Go ahead as follows:

![image](https://user-images.githubusercontent.com/108018363/208962580-91252879-f440-4e13-ae70-a72838fc5ef9.png)


And the import is complete!

![image](https://user-images.githubusercontent.com/108018363/208962875-630f4224-35f7-4204-a3b5-dd7b80bde1db.png)















