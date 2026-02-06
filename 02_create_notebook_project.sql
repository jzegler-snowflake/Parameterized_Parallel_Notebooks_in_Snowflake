-- Create Notebook Project
-- First, find your workspace path by running:
-- LIST 'snow://workspace/USER$.PUBLIC.DEFAULT$/versions/live/';
-- 
-- Then update <YOUR_WORKSPACE_PATH> below with the correct path
-- Format: snow://workspace/USER$.PUBLIC."workspace_name"/versions/head

USE DATABASE DEMO_DB;
USE SCHEMA PUBLIC;

-- Option 1: If you know your workspace path
CREATE OR REPLACE NOTEBOOK PROJECT DEMO_DB.PUBLIC.CARBON_EMISSIONS_PROJECT
  FROM '<YOUR_WORKSPACE_PATH>'
  COMMENT = 'Parameterized emissions calculator';

-- Option 2: If notebook is already in a workspace, get the path:
-- SELECT * FROM INFORMATION_SCHEMA.NOTEBOOKS WHERE NAME = 'carbon_emissions_calculator';

SHOW NOTEBOOK PROJECTS LIKE 'CARBON_EMISSIONS_PROJECT';
