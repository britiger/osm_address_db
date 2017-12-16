-- create database and roles with extension

CREATE USER osm PASSWORD 'osm' LOGIN;

CREATE DATABASE osm OWNER osm;

-- Chaneg Database to osm
\c osm

-- Extensions
CREATE EXTENSION postgis;
CREATE EXTENSION fuzzystrmatch;
