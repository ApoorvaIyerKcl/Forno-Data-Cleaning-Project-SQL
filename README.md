# SQL Data Cleaning Project- Forno Italian Restaurant

## Overview

This project focuses on **cleaning and preparing transactional data for Forno**, an **Italian restaurant**, using **SQL**. The primary objective was to transform raw Point of Sale (POS) data into a **clean, structured, and analysis-ready format** suitable for reporting and business insights.

The dataset reflects **real-world restaurant operations**, including customer bills, ordered menu items, and master menu data. This README outlines the **dataset structure**, **data cleaning approach**, and **tools used** in the project.

## Tools Used

* **MySQL Workbench** (or any other SQL client)
* **SQL** for data cleaning, validation, and transformation
  
## Data Cleaning Process

### Removed Duplicates

* Identified **duplicate bills and repeated item entries** caused by POS system or operational errors.
* Used **SQL window functions** to detect multiple records representing the same logical transaction.
* Retained the most accurate record while removing redundancies.

### Standardized Data and Populated Null Values

* Standardized **date and time formats** across all Forno transaction records.
* Normalized **text-based fields** such as payment modes, menu categories, and restaurant locations.
* Populated missing values using **business logic aligned with restaurant operations**.

### Handled Null and Blank Values

* Reviewed remaining **NULL and blank values** across bills, bill items, and menu tables.
* Decided whether to **update, retain, or remove records** based on their impact on Italian restaurant sales analysis.
* Ensured no critical analytical fields contained invalid data.

### Validated Business Logic and Calculations

* Recalculated **item-level subtotals** using quantity and unit selling price.
* Verified **bill-level totals** against aggregated item-level data.
* Flagged inconsistencies arising from manual entry or system issues during peak restaurant hours.

### Removed Unnecessary Columns and Rows

* Dropped **irrelevant columns** that did not contribute to sales or operational analysis.
* Removed records that could not be logically validated or corrected.


## Dataset Used

| Dataset Name  | Description                                                                                                 |
| ------------- | ----------------------------------------------------------------------------------------------------------- |
| RS-bills      | Contains **Forno bill-level transactions** including date, time, location, payment mode, and bill totals    |
| RS-bill_items | Stores **Italian menu item-level order data** such as quantity, pricing, subtotals, and preparation details |
| RS-menu_items | Master table defining **Forno’s Italian menu**, item categories, base prices, and availability status       |


## Outcome

After completing the data cleaning process, **Forno’s sales dataset** became **consistent, reliable, and analysis-ready**. The cleaned data supports:

* Italian menu performance analysis
* Revenue and billing validation
* Order-level and item-level sales reporting
* Operational insights for restaurant management

This project demonstrates **industry-relevant SQL data cleaning skills** using a **realistic Italian restaurant business scenario**, making it suitable for **portfolios, interviews, and client demonstrations**.




