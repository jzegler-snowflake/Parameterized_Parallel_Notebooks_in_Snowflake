# Carbon Emissions Calculator - Parameterized Notebooks Demo

## Overview

Shows how to run Snowflake notebooks with parameters, scheduled or on-demand, with parallel execution on compute pools.

## Use Case

Simple example: calculate carbon emissions for different companies. Pass in a company name like 'TechCorp' or 'ManufactureCo', and the notebook processes that company's data. Same notebook code, different parameters.

## Files

| File | Purpose |
|------|---------|
| `01_setup_data.sql` | Creates tables and loads sample data |
| `carbon_emissions_calculator.ipynb` | Jupyter notebook file (pull via Git integration) |
| `02_create_notebook_project.sql` | Creates the notebook project |
| `03_manual_parallel_execution.sql` | Commands for parallel execution demo (2 companies) |
| `04_scheduled_task.sql` | Scheduled task setup (optional) |

## Setup

### 1. Create Tables and Load Data

Run `01_setup_data.sql` to create:
- `COMPANY_ACTIVITY_DATA` - Sample activity data from 5 companies
- `EMISSIONS_FACTORS` - Conversion factors for calculating emissions
- `EMISSIONS_RESULTS` - Output table for results

### 2. Create Notebook

1. Commit this repo to Git and connect to Snowflake (Projects > Git Repositories)
2. Create notebook from the `carbon_emissions_calculator.ipynb` file
3. Set database: `DEMO_DB`, schema: `PUBLIC`, warehouse: `CONTAINER_RUNTIME_WH`
4. Note the workspace path: `snow://workspace/<HASH>/carbon_emissions_calculator.ipynb`

### 3. Create Notebook Project

Run `02_create_notebook_project.sql`

### 4. Update Workspace Hash

In files `03_manual_parallel_execution.sql` and `04_scheduled_task.sql`, replace `<YOUR_WORKSPACE_HASH>` with your actual workspace hash from step 2.

### 5. Test Execution

```sql
EXECUTE NOTEBOOK PROJECT DEMO_DB.PUBLIC.CARBON_EMISSIONS_PROJECT
  MAIN_FILE = 'snow://workspace/<YOUR_HASH>/carbon_emissions_calculator.ipynb'
  COMPUTE_POOL = 'SYSTEM_COMPUTE_POOL_CPU'
  QUERY_WAREHOUSE = 'CONTAINER_RUNTIME_WH'
  RUNTIME = 'V2.2-CPU-PY3.11'
  ARGUMENTS = 'TechCorp'
  REQUIREMENTS_FILE = 'snow://workspace/<YOUR_HASH>/requirements.txt'
  EXTERNAL_ACCESS_INTEGRATIONS = ('MLOPS_PYPI_ACCESS_INTEGRATION');

-- Verify results
SELECT * FROM EMISSIONS_RESULTS ORDER BY EXECUTION_TIMESTAMP DESC;
```

## Package Management

**Two approaches for installing Python packages** ([official docs](https://docs.snowflake.com/en/developer-guide/snowflake-ml/container-runtime-package-management)):

1. **Interactive development (Cell 1)**: Use `!pip install <package>` directly in notebook cells
   - Great for trying out new packages
   - Runs each time the notebook executes
   - Example: `!pip install tabulate`
   
2. **Production execution (REQUIREMENTS_FILE)**: Reference a requirements.txt file
   - Pre-installs packages at container startup
   - More reliable for scheduled/automated runs
   - Faster since packages are cached
   - Used automatically with `EXECUTE NOTEBOOK PROJECT`

**Note**: Requires an External Access Integration for PyPI or Artifact Repository enabled.

## Demo Flow

### Show the Data

```sql
SELECT COMPANY_NAME, COUNT(*) AS ACTIVITIES
FROM COMPANY_ACTIVITY_DATA
GROUP BY COMPANY_NAME;

SELECT * FROM EMISSIONS_FACTORS LIMIT 5;
```

### Show Scheduled Execution

```sql
SHOW TASKS LIKE 'CARBON_EMISSIONS%';
```

### Demo Parallel Execution

Open 2 SQL worksheets. In each, run the EXECUTE NOTEBOOK PROJECT command with different company names:
- Worksheet 1: `ARGUMENTS = 'TechCorp'`
- Worksheet 2: `ARGUMENTS = 'ManufactureCo'`

Execute both simultaneously to demonstrate parallel processing on the compute pool.

### Show Results

```sql
-- Latest results by company
SELECT 
    COMPANY_NAME,
    SUM(TOTAL_EMISSIONS_TCO2E) AS TOTAL_TCO2E,
    MAX(EXECUTION_TIME_SECONDS) AS EXEC_TIME
FROM EMISSIONS_RESULTS
WHERE EXECUTION_TIMESTAMP >= DATEADD(MINUTE, -5, CURRENT_TIMESTAMP())
GROUP BY COMPANY_NAME
ORDER BY TOTAL_TCO2E DESC;

-- Compare sequential vs parallel execution time
WITH recent AS (
    SELECT MAX(EXECUTION_TIME_SECONDS) AS t
    FROM EMISSIONS_RESULTS
    WHERE EXECUTION_TIMESTAMP >= DATEADD(MINUTE, -5, CURRENT_TIMESTAMP())
    GROUP BY COMPANY_NAME
)
SELECT 'Sequential (est.)' AS METHOD, SUM(t) AS SECONDS FROM recent
UNION ALL
SELECT 'Parallel (actual)', MAX(t) FROM recent;
```

## Sample Data

| Company | Industry | Est. Emissions |
|---------|----------|----------------|
| TechCorp | Technology | ~2,000 tonnes |
| ManufactureCo | Manufacturing | ~28,000 tonnes |
| RetailCo | Retail | ~2,000 tonnes |
| HealthcarePlus | Healthcare | ~1,500 tonnes |
| FinanceGlobal | Financial Services | ~2,200 tonnes |

## Troubleshooting

**Workspace hash not found**: Get the correct path from your notebook and update the SQL files

**Compute pool not active**: Run `SHOW COMPUTE POOLS;` - they auto-resume when needed

**No results**: Check the notebook execution output for errors

## Documentation

- [EXECUTE NOTEBOOK PROJECT](https://docs.snowflake.com/en/sql-reference/sql/execute-notebook-project)
- [CREATE NOTEBOOK PROJECT](https://docs.snowflake.com/en/sql-reference/sql/create-notebook-project)
- [Container Runtime Package Management](https://docs.snowflake.com/en/developer-guide/snowflake-ml/container-runtime-package-management)