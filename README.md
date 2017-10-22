osm_address_db
==============

This collection of scripts is for importing osm data to a postgre database for analyse address data.

Requirements
============
For using the following scripts you need a postgresql database version 10 or above including a suitable postgis extension. 
You also need the current osm2pgsql (0.92.0 tested, prior versions may work) for importing the data.

Before starting the import you need to copy the file config.sample into config. You have to create an empty database with postgis extension enabled. In the config file you have to set the database parameter and the source file of the osm pbf file. If you want to update the database in the future without a complete reimport you have to set the url and sequence of the diff files.

You also need osmupdate. You can install this tool in your $PATH or in the tools/ directory. If osmupdate doesn't exists, the script will try to download and compile them using cc compiler.

Programs
========

 - initial_import.sh - This is the main script it reads the given data file (see config file)
 - osmupdate.sh - update database, this is started once by initial_import.sh with the parameter first, other valid parameter are full or address. This script is using osmupdate for the process.
   - parameter first: don't run it if the import finished successful, only use it the import failed because of missing or compilation errors of osmupdate
   - parameter full: Updates all data and refresh all materialized views
   - parameter address: Updates all data but use the old materialized views, this is for a fast update of the database
   
Old Tools
--------
 - fetch_country_list.sh - Load the list of all country polygons into the directory country_files/ using Overpass-API
 - fetch_countries.sh - Load all osm files of counties defined in the file itself (python required)

Others
======
  - Currently the import of countries isn't available.
  - Use a separate directory per database instance.
  - The script osmupdate.sh uses the date of the previous update process. Don't delete tmp/old_update.osc.gz! If the file is missing, the script uses the date of the imported file or the update completly failes.
