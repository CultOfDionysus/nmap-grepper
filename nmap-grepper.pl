#!/usr/bin/perl
#
# read the "greppable" nmap output, outputting a single line for each open port, for each host
# Enables answering of questions like "can we have a list of all of the servers running SMTP or Telnet?"
#
#
use strict;
use warnings;
no warnings 'uninitialized'; # bit of a hack - sometimes input contains commas in unexpected places.

my $host;
my $ip;
my $delim = "\t"; # output field delimiter

my @services;
my @ports;
my @sections;

while (<>)              # read stdin
{

        @sections = split /\t/; # each input line divided by tabs

        # process each section

        foreach my $s (@sections) {

        #
        # Host section
        #

                if ($s =~ /Host:/) {
                        if ( /(\d+)\.(\d+)\.(\d+)\.(\d+)/, $s ) {  #looks like an IP
                                $ip = $&;
                        }
                        else  {
                                $ip = "none"; # should never happen
                        }
                        if ( /\(.*?\)/, $s) { # hostname is in brackets
                                $host = $&;
                                $host =~ s/[\)\(]//g; # strip brackets out
                        }
                        else { $host = "none"; }
                }
        #
        # Ports section
        #

                if ($s =~ /Ports:/) {
                        $s =~ s/Ports:[ ]+//g;  # strip the word "Ports:" plus trailing spaces
                        @ports = split /,[ ]+/, $s;
                        foreach my $t (@ports) {        # find the individual port items
                                @services = split /\//, $t;
                                if ($services[1]  =~ /open/) {  # sometimes there's no service name (element 4) or desc (element 6)
                                        print $ip, $delim, $host, $delim, $services[0], $delim, uc $services[2], $delim, 
                                        $services[4]  ? uc $services[4] : "unknown", $delim, $services[6]  ? $services[6] : "unknown", "\n";
                                }
                        }
                }
        }
}
exit;
                               
