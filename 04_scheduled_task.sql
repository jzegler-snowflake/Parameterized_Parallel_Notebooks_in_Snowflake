-- Scheduled Task Example

USE DATABASE DEMO_DB;
USE SCHEMA PUBLIC;

CREATE OR REPLACE TASK CARBON_EMISSIONS_DAILY_TASK
  WAREHOUSE = CONTAINER_RUNTIME_WH
  SCHEDULE = 'USING CRON 0 2 * * * UTC'
  COMMENT = 'Daily emissions calculation'
AS
  EXECUTE NOTEBOOK PROJECT DEMO_DB.PUBLIC.CARBON_EMISSIONS_PROJECT
    MAIN_FILE = 'snow://workspace/USER$.PUBLIC."Parameterized_Parallel_Notebooks_in_Snowflake"/versions/head/carbon_emissions_calculator.ipynb'
    COMPUTE_POOL = 'SYSTEM_COMPUTE_POOL_CPU'
    QUERY_WAREHOUSE = 'CONTAINER_RUNTIME_WH'
    RUNTIME = 'V2.2-CPU-PY3.11'
    ARGUMENTS = 'TechCorp'
    REQUIREMENTS_FILE = 'snow://workspace/USER$.PUBLIC."Parameterized_Parallel_Notebooks_in_Snowflake"/versions/head/requirements.txt'
    EXTERNAL_ACCESS_INTEGRATIONS = ('MLOPS_PYPI_ACCESS_INTEGRATION');

-- Alternative: One task per company

CREATE OR REPLACE TASK CARBON_EMISSIONS_TECHCORP
  WAREHOUSE = CONTAINER_RUNTIME_WH
  SCHEDULE = 'USING CRON 0 2 * * * UTC'
  COMMENT = 'TechCorp emissions'
AS
  EXECUTE NOTEBOOK PROJECT DEMO_DB.PUBLIC.CARBON_EMISSIONS_PROJECT
    MAIN_FILE = 'snow://workspace/USER$.PUBLIC."Parameterized_Parallel_Notebooks_in_Snowflake"/versions/head/carbon_emissions_calculator.ipynb'
    COMPUTE_POOL = 'SYSTEM_COMPUTE_POOL_CPU'
    QUERY_WAREHOUSE = 'CONTAINER_RUNTIME_WH'
    RUNTIME = 'V2.2-CPU-PY3.11'
    ARGUMENTS = 'TechCorp'
    REQUIREMENTS_FILE = 'snow://workspace/USER$.PUBLIC."Parameterized_Parallel_Notebooks_in_Snowflake"/versions/head/requirements.txt'
    EXTERNAL_ACCESS_INTEGRATIONS = ('MLOPS_PYPI_ACCESS_INTEGRATION');

CREATE OR REPLACE TASK CARBON_EMISSIONS_MANUFACTURECO
  WAREHOUSE = CONTAINER_RUNTIME_WH
  SCHEDULE = 'USING CRON 0 2 * * * UTC'
  COMMENT = 'ManufactureCo emissions'
AS
  EXECUTE NOTEBOOK PROJECT DEMO_DB.PUBLIC.CARBON_EMISSIONS_PROJECT
    MAIN_FILE = 'snow://workspace/USER$.PUBLIC."Parameterized_Parallel_Notebooks_in_Snowflake"/versions/head/carbon_emissions_calculator.ipynb'
    COMPUTE_POOL = 'SYSTEM_COMPUTE_POOL_CPU'
    QUERY_WAREHOUSE = 'CONTAINER_RUNTIME_WH'
    RUNTIME = 'V2.2-CPU-PY3.11'
    ARGUMENTS = 'ManufactureCo'
    REQUIREMENTS_FILE = 'snow://workspace/USER$.PUBLIC."Parameterized_Parallel_Notebooks_in_Snowflake"/versions/head/requirements.txt'
    EXTERNAL_ACCESS_INTEGRATIONS = ('MLOPS_PYPI_ACCESS_INTEGRATION');

-- Resume to activate (tasks start as SUSPENDED)
-- ALTER TASK CARBON_EMISSIONS_DAILY_TASK RESUME;

-- Check task status
SHOW TASKS LIKE 'CARBON_EMISSIONS%';

-- View task history
SELECT *
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
    TASK_NAME => 'CARBON_EMISSIONS_DAILY_TASK',
    SCHEDULED_TIME_RANGE_START => DATEADD(DAY, -7, CURRENT_TIMESTAMP())
))
ORDER BY SCHEDULED_TIME DESC;
