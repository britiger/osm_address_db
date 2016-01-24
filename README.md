osm_address_db
==============

This collection of scripts is for importing osm data to a postgre database for analyse address data.

Requirements
============
For using the following scripts you need a postgresql database version 9.3 or above including a suitable postgis extension. 
You also need the current osm2pgsql (0.87.2 tested) for importing the data.

Before starting the import you need to copy the file config.sample into config. You have to create an empty database with postgis extension enabled. In the config file you have to set the database parameter and the source file of the osm pbf file. If you want to update the database in the future without a complete reimport you have to set the url and sequence of the diff files.

Programs
========

 - initial_import.sh - This is the main script it reads the given data file (see config file)
 - update_import.sh - This script reads the url and sequence number from the database. After starting it checks the given url for new updates and load this file, import the data into the database. After importing using osm2pgsql it rebuilds the existing address database.
 - reimport.sh - If you you have modified the osm2pgsql data you need to reimport the data into the address db structure. This script is called by update_import.sh autocratically. 
 - import_countries.sh - Imports all *.osm files from the country_files directory. The files have to contain the relations of a country. You will need this if you import small extracts to have these polygons for fill all empty addr:country tags.
