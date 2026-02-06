-- Data Setup for Carbon Emissions Demo
-- Creates tables and loads sample data

USE DATABASE DEMO_DB;
USE SCHEMA PUBLIC;

-- Activity Data Table

CREATE OR REPLACE TABLE COMPANY_ACTIVITY_DATA (
    COMPANY_ID VARCHAR(50),
    COMPANY_NAME VARCHAR(100),
    ACTIVITY_TYPE VARCHAR(100),
    ACTIVITY_VALUE FLOAT,
    UNIT VARCHAR(50),
    REPORTING_YEAR INTEGER,
    SCOPE VARCHAR(20),
    DATA_SOURCE VARCHAR(100),
    LOAD_TIMESTAMP TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Emissions Factors Table

CREATE OR REPLACE TABLE EMISSIONS_FACTORS (
    ACTIVITY_TYPE VARCHAR(100),
    EMISSION_FACTOR FLOAT,
    UNIT VARCHAR(50),
    SCOPE VARCHAR(20),
    SOURCE VARCHAR(200)
);

-- Results Table

CREATE OR REPLACE TABLE EMISSIONS_RESULTS (
    EXECUTION_ID VARCHAR(100),
    COMPANY_ID VARCHAR(50),
    COMPANY_NAME VARCHAR(100),
    SCOPE VARCHAR(20),
    TOTAL_EMISSIONS_TCO2E FLOAT,
    REPORTING_YEAR INTEGER,
    EXECUTION_TIME_SECONDS FLOAT,
    EXECUTION_TIMESTAMP TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    PARAMETERS VARCHAR(500)
);

-- Sample Conversion Factors
INSERT INTO EMISSIONS_FACTORS VALUES
    -- Scope 1
    ('Natural Gas Combustion', 0.0053, 'kg CO2e/kWh', 'Scope 1', 'EPA 2024 Emission Factors'),
    ('Diesel Combustion', 2.68, 'kg CO2e/liter', 'Scope 1', 'EPA 2024 Emission Factors'),
    ('Company Vehicles', 0.171, 'kg CO2e/km', 'Scope 1', 'EPA 2024 Emission Factors'),
    
    -- Scope 2
    ('Purchased Electricity', 0.385, 'kg CO2e/kWh', 'Scope 2', 'eGRID 2023 US Average'),
    ('Purchased Heating', 0.215, 'kg CO2e/kWh', 'Scope 2', 'EPA 2024 Emission Factors'),
    
    -- Scope 3
    ('Business Travel - Air', 0.255, 'kg CO2e/km', 'Scope 3', 'DEFRA 2024'),
    ('Business Travel - Rail', 0.041, 'kg CO2e/km', 'Scope 3', 'DEFRA 2024'),
    ('Employee Commuting', 0.192, 'kg CO2e/km', 'Scope 3', 'EPA 2024 Emission Factors'),
    ('Waste to Landfill', 0.567, 'kg CO2e/kg', 'Scope 3', 'EPA WARM Model 2024'),
    ('Data Center Services', 0.475, 'kg CO2e/kWh', 'Scope 3', 'Cloud Carbon Footprint 2024');

-- Sample Activity Data for 5 Companies

-- Company 1: TechCorp (Software/Technology)
INSERT INTO COMPANY_ACTIVITY_DATA VALUES
    ('TECH001', 'TechCorp', 'Purchased Electricity', 2500000, 'kWh', 2024, 'Scope 2', 'Utility Bills'),
    ('TECH001', 'TechCorp', 'Data Center Services', 1800000, 'kWh', 2024, 'Scope 3', 'Cloud Provider Reports'),
    ('TECH001', 'TechCorp', 'Business Travel - Air', 450000, 'km', 2024, 'Scope 3', 'Travel Management System'),
    ('TECH001', 'TechCorp', 'Employee Commuting', 125000, 'km', 2024, 'Scope 3', 'Employee Survey'),
    ('TECH001', 'TechCorp', 'Natural Gas Combustion', 85000, 'kWh', 2024, 'Scope 1', 'Utility Bills');

-- Company 2: ManufactureCo (Manufacturing)
INSERT INTO COMPANY_ACTIVITY_DATA VALUES
    ('MFG002', 'ManufactureCo', 'Natural Gas Combustion', 5200000, 'kWh', 2024, 'Scope 1', 'Utility Bills'),
    ('MFG002', 'ManufactureCo', 'Diesel Combustion', 125000, 'liter', 2024, 'Scope 1', 'Fuel Receipts'),
    ('MFG002', 'ManufactureCo', 'Company Vehicles', 285000, 'km', 2024, 'Scope 1', 'Fleet Management'),
    ('MFG002', 'ManufactureCo', 'Purchased Electricity', 8750000, 'kWh', 2024, 'Scope 2', 'Utility Bills'),
    ('MFG002', 'ManufactureCo', 'Waste to Landfill', 450000, 'kg', 2024, 'Scope 3', 'Waste Management Reports');

-- Company 3: RetailCo (Retail)
INSERT INTO COMPANY_ACTIVITY_DATA VALUES
    ('RET003', 'RetailCo', 'Purchased Electricity', 4200000, 'kWh', 2024, 'Scope 2', 'Utility Bills'),
    ('RET003', 'RetailCo', 'Purchased Heating', 320000, 'kWh', 2024, 'Scope 2', 'Utility Bills'),
    ('RET003', 'RetailCo', 'Company Vehicles', 650000, 'km', 2024, 'Scope 1', 'Fleet Management'),
    ('RET003', 'RetailCo', 'Employee Commuting', 825000, 'km', 2024, 'Scope 3', 'Employee Survey'),
    ('RET003', 'RetailCo', 'Waste to Landfill', 285000, 'kg', 2024, 'Scope 3', 'Waste Management Reports');

-- Company 4: HealthcarePlus (Healthcare)
INSERT INTO COMPANY_ACTIVITY_DATA VALUES
    ('HC004', 'HealthcarePlus', 'Purchased Electricity', 3150000, 'kWh', 2024, 'Scope 2', 'Utility Bills'),
    ('HC004', 'HealthcarePlus', 'Natural Gas Combustion', 1250000, 'kWh', 2024, 'Scope 1', 'Utility Bills'),
    ('HC004', 'HealthcarePlus', 'Company Vehicles', 185000, 'km', 2024, 'Scope 1', 'Fleet Management'),
    ('HC004', 'HealthcarePlus', 'Business Travel - Rail', 95000, 'km', 2024, 'Scope 3', 'Travel Management System'),
    ('HC004', 'HealthcarePlus', 'Waste to Landfill', 125000, 'kg', 2024, 'Scope 3', 'Waste Management Reports');

-- Company 5: FinanceGlobal (Financial Services)
INSERT INTO COMPANY_ACTIVITY_DATA VALUES
    ('FIN005', 'FinanceGlobal', 'Purchased Electricity', 1850000, 'kWh', 2024, 'Scope 2', 'Utility Bills'),
    ('FIN005', 'FinanceGlobal', 'Data Center Services', 950000, 'kWh', 2024, 'Scope 3', 'Cloud Provider Reports'),
    ('FIN005', 'FinanceGlobal', 'Business Travel - Air', 1250000, 'km', 2024, 'Scope 3', 'Travel Management System'),
    ('FIN005', 'FinanceGlobal', 'Employee Commuting', 425000, 'km', 2024, 'Scope 3', 'Employee Survey'),
    ('FIN005', 'FinanceGlobal', 'Natural Gas Combustion', 125000, 'kWh', 2024, 'Scope 1', 'Utility Bills');

-- Verify Data Load
SELECT 'Company Activity Data Count:' AS METRIC, COUNT(*) AS VALUE FROM COMPANY_ACTIVITY_DATA
UNION ALL
SELECT 'Number of Companies:', COUNT(DISTINCT COMPANY_ID) FROM COMPANY_ACTIVITY_DATA
UNION ALL
SELECT 'Emissions Factors Count:', COUNT(*) FROM EMISSIONS_FACTORS;

-- Quick preview of data by company
SELECT 
    COMPANY_NAME,
    COUNT(*) AS ACTIVITY_RECORDS,
    COUNT(DISTINCT ACTIVITY_TYPE) AS ACTIVITY_TYPES,
    COUNT(DISTINCT SCOPE) AS SCOPES
FROM COMPANY_ACTIVITY_DATA
GROUP BY COMPANY_NAME
ORDER BY COMPANY_NAME;

-- Next: Create the notebook from carbon_emissions_calculator.ipynb
