#!/usr/bin/perl -w

## Perl script to iterate over the PDF tide tides for 2013 from
## Eastbourne.gov.uk when cut and pasted out into a text file.
## This returns the data in a usable JSON format like this...
#
# [
#  {
#    "highlow" : "L",
#    "height" : "0.5m",
#    "datetime" : "2013-12-31T16:30:00"
#  },
#  {
#    "highlow" : "H",
#    "height" : "7.2m",
#    "datetime" : "2013-12-31T22:36:00"
#  }
# ]
#
## The PDF file to cut and paste from can be found here.
## http://www.eastbourne.gov.uk/EasysiteWeb/getresource.axd?AssetID=163451&type=full&servicetype=Inline
##
## Usage: perl tide.pl < tides.txt

use strict;
use warnings;
use JSON;
use DateTime;

my $json = new JSON;
my $months = {
    'Jan' => 1,
    'Feb' => 2,
    'Mar' => 3,
    'Apr' => 4,
    'May' => 5,
    'Jun' => 6,
    'Jul' => 7,
    'Aug' => 8,
    'Sep' => 9,
    'Oct' => 10,
    'Nov' => 11,
    'Dec' => 12
};
my @tides = ();         ## this is where we'll store all the tides.
my $currentdate;        ## holding variable for the current date.
my $currenttide = {};   ## holding variable for the current tide data.

## iterate over each line.
while (my $line = <>) {
    chomp($line);

    ## Is this a date?
    if ($line =~ /^\d{2}-\w{3}$/) {
        $currentdate = $line;
        next;

    ## Is this a day?
    } elsif ($line =~ /^\w{3}$/) {
        ## ignore days
        next;

    ## Is this a time?
    } elsif ($line =~ /^\d{2}:\d{2}$/) {

        ## create a datetime and add it to the currenttide in ISO8601 format.
        my ($day, $month) = ($currentdate =~ /^(\d{2})-(\w{3})$/);
        my ($hour, $minute) = ($line =~ /^(\d{2}):(\d{2})$/);
        my $datetime = DateTime->new(
            year => 2013,
            month => $months->{$month},
            day => $day,
            hour => $hour,
            minute => $minute,
            second => 0,
            time_zone => 'UTC'
        );
        $currenttide->{'datetime'} = $datetime->iso8601();
        next;

    ## high or low tide?
    } elsif ($line =~ /^[HL]$/) {

        ## add the high or low tide indicator to the currenttide.
        $currenttide->{'highlow'} = $line;
        next;

    ## is this a height?
    } elsif ($line =~ /^\d{1,2}\.\dm$/) {

        ## add the height to the currenttide
        $currenttide->{'height'} = $line;

        ## the height is the last item, so save this to the list of tides
        # and reset the currenttide hash.
        push @tides, $currenttide;
        $currenttide = {};
        next;
    }
}

## print out all the tides in a nice format.
print $json->pretty->encode(\@tides);
