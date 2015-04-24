# stations-geojson

Use **stations2geojson.pl** to create a [GeoJSON](http://geojson.org) edition of the European train station database.

## Using the Script

Download the latest stations database from [CapitaineTrain/stations](https://github.com/capitainetrain/stations):

    curl https://raw.githubusercontent.com/capitainetrain/stations/master/stations.csv > stations.csv

Pipe the `stations.csv` file into the script and pipe out the resulting GeoJSON to a new file:

    stations2geojson.pl < stations.csv > stations.geojson

## Sample Conversion

The [stations.geojson](https://github.com/grahammiln/stations-geojson/blob/master/stations.geojson) is a sample file created with `stations.csv`. While correct at the time of uploading, please create your own edition with the latest database.
