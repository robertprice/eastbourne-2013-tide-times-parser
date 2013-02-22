eastbourne-2013-tide-times-parser
=================================

Extracts tide times from Eastbourne's 2013 tide times PDF and returns them in a usable JSON format.

This is a Perl script to iterate over the PDF tide tides for 2013 from Eastbourne.gov.uk when cut and pasted out into a text file.

JSON Data
---------

This returns the data in a usable JSON format like this...

	[
  		{
    		"highlow" : "L",
    		"height" : "0.5m",
    		"datetime" : "2013-12-31T16:30:00"
  		},
		{
			"highlow" : "H",
			"height" : "7.2m",
			"datetime" : "2013-12-31T22:36:00"
		}
	]

Original Data
-------------

The PDF file to cut and paste from can be found here.

http://www.eastbourne.gov.uk/EasysiteWeb/getresource.axd?AssetID=163451&type=full&servicetype=Inline

Usage
-----

	perl tide.pl < tides.txt