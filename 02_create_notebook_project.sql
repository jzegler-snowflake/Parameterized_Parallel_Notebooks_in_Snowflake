-- Create Notebook Project

USE DATABASE DEMO_DB;
USE SCHEMA PUBLIC;

CREATE OR REPLACE NOTEBOOK PROJECT DEMO_DB.PUBLIC.CARBON_EMISSIONS_PROJECT
  FROM 'snow://workspace/USER$.PUBLIC."Parameterized_Parallel_Notebooks_in_Snowflake"/versions/live'
  COMMENT = 'Parameterized emissions calculator';

SHOW NOTEBOOK PROJECTS LIKE 'CARBON_EMISSIONS_PROJECT';
