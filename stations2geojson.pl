#!/usr/bin/env perl

use strict;
use warnings;

=pod DESCRIPTION

A script to create a mappable edition of the stations.csv database.

To create GeoJSON from `stations.csv` download the stations.csv file and pipe through
this script:

	curl https://raw.githubusercontent.com/capitainetrain/stations/master/stations.csv > stations.csv
	stations2geojson.pl < stations.csv > stations.geojson

This script is designed to be short and simple. No error or conformance checking is
performed. I have avoided using third party modules to allow a basic perl installation
to run and use this script.

=cut

my @stations_csv;
while(my $line = <>) {
	chomp($line);
	push(@stations_csv,$line);
}

# Assuming first line contains column titles
my $first_line = shift(@stations_csv);
my @column_titles = split(/;/,$first_line);

# Assuming remaining lines contain entries
my @array_of_station_refs;
foreach my $line (@stations_csv) {
	my @station = split(/;/,$line);
	my %station;
	for(my $i = 0; $i < scalar(@station); ++$i) {
		$station{$column_titles[$i]} = $station[$i];
	}
	push(@array_of_station_refs,\%station);
}

# Output stations in GeoJSON format

my @station_features;
foreach my $station (@array_of_station_refs) {
	next unless $station->{'longitude'} and $station->{'latitude'};

	my @properties;
	foreach my $key (keys %$station) {	
		push(@properties,'"'.$key.'": "'.$station->{$key}.'"');
	}
	my $properties = join(',',@properties);
	my $feature = '{ "type": "Feature", "geometry": { "type": "Point", "coordinates": ['.$station->{'longitude'}.','.$station->{'latitude'}.'] }, "properties": { '.$properties .' } }';
	push(@station_features,$feature);
}

print '{ "type": "FeatureCollection","features": ['."\n".join(",\n",@station_features)."\n]}\n";

=pod LICENSE

The MIT License (MIT)

Copyright (c) 2015 Graham Miln, http://miln.eu

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=cut
