-- Create Notebook Project
-- Update <YOUR_WORKSPACE_HASH> with your actual workspace hash

USE DATABASE DEMO_DB;
USE SCHEMA PUBLIC;

CREATE OR REPLACE NOTEBOOK PROJECT CARBON_EMISSIONS_PROJECT
  FROM 'snow://workspace/<YOUR_WORKSPACE_HASH>/carbon_emissions_calculator.ipynb'
  COMMENT = 'Parameterized emissions calculator';

SHOW NOTEBOOK PROJECTS LIKE 'CARBON_EMISSIONS_PROJECT';
