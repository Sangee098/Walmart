# Walmart Data Analysis: End-to-End SQL + Python Project 

## Project Overview

![Project Pipeline](https://github.com/najirh/Walmart_SQL_Python/blob/main/walmart_project-piplelines.png)


This project is an end-to-end data analysis solution designed to extract critical business insights from Walmart sales data. I utilize Python for data processing and analysis, SQL for advanced querying, and structured problem-solving techniques to solve key business questions. 

---

## Project Steps

### 1. Set Up the Environment
   - **Tools Used**: Visual Studio Code (VS Code), Python, SQL (MySQL and PostgreSQL)
   - **Goal**: Create a structured workspace within VS Code and organize project folders for smooth development and data handling.

### 2. Set Up Kaggle API
   - **API Setup**: Obtained the Kaggle API token from [Kaggle](https://www.kaggle.com/) by navigating to profile settings and downloading the JSON file.
   - **Configure Kaggle**: 
      - I downloaded the `kaggle.json` file from the local `.kaggle` folder.
      - Used the command `kaggle datasets download -d <dataset-path>` to pull datasets directly into your project.

### 3. Download Walmart Sales Data
   - **Data Source**: Used the Kaggle API to download the Walmart sales datasets from Kaggle.
   - **Dataset Link**: [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)
   - **Storage**: Saved the data in the `data/` folder for easy reference and access.

### 4. Install Required Libraries and Load Data
   - **Libraries**: Installed necessary Python libraries using:
     ```bash
     pip install pandas numpy sqlalchemy mysql-connector-python psycopg2
     ```
     
### 5. Explore the Data
   - **Goal**: Conducted an initial data exploration to understand data distribution, check column names, types, and identify potential issues.
   - **Analysis**: Used the functions like `.info()`, `.describe()`, and `.head()` to get a quick overview of the data structure and statistics.

### 6. Data Cleaning
   - **Remove Duplicates**: Identified and removed duplicate entries to avoid skewed results.
   - **Handle Missing Values**: Dropped rows or columns with missing values if they are insignificant; filled values where essential.
   - **Fix Data Types**: Have ensured all columns have consistent data types (e.g., dates as `datetime`, prices as `float`).
   - **Currency Formatting**: Used `.replace()` to handle and format currency values for analysis.
   - **Validation**: Have checked for any remaining inconsistencies and verified the cleaned data.

### 7. Feature Engineering
   - **Create New Columns**: Calculate the `Total Amount` for each transaction by multiplying `unit_price` by `quantity` and adding this as a new column.
   - **Enhance Dataset**: Adding this calculated field will streamline further SQL analysis and aggregation tasks.

### 8. Load Data into MySQL and PostgreSQL
   - **Set Up Connections**: Connect to MySQL and PostgreSQL using `sqlalchemy` and load the cleaned data into each database.
   - **Table Creation**: Set up tables in both MySQL and PostgreSQL using Python SQLAlchemy to automate table creation and data insertion.
   - **Verification**: Run initial SQL queries to confirm that the data has been loaded accurately.

### 9. SQL Analysis: Complex Queries and Business Problem Solving
   - **Business Problem-Solving**: Write and execute complex SQL queries to answer critical business questions, such as:
     - Revenue trends across branches and categories.
     
     - Identifying best-selling product categories.
     ```sql
     SELECT * FROM (SELECT branch,category, AVG(rating) AS avg_rating,RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) FROM walmart
     GROUP BY 1,2) WHERE rank =1;
     ```
     - Sales performance by time, city, and payment method.
     ```sql

     SELECT * FROM (SELECT branch,TO_CHAR(TO_DATE(date,'dd/mm/yy'),'day'),COUNT(*) AS transations,RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank 
     FROM walmart
     GROUP BY branch,2
     ORDER BY 1) WHERE rank=1;

     SELECT city,category,AVG(rating) AS Average_rating,MIN(rating) AS Min_rating,MAX(rating) AS Max_rating FROM walmart
     GROUP BY city,category
     ORDER BY city;

     SELECT * FROM (SELECT branch,TO_CHAR(TO_DATE(date,'dd/mm/yy'),'day'),COUNT(*) AS transations,RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank 
     FROM walmart
     GROUP BY branch,2
     ORDER BY 1) WHERE rank=1;
     ```
     - Analyzing peak sales periods and customer buying patterns.
     ```sql
     SELECT * FROM (SELECT branch,payment_method,COUNT(*) AS transition,RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank FROM walmart
     GROUP BY branch,payment_method
     ORDER BY branch) WHERE rank=1;


     SELECT CASE 
     WHEN EXTRACT (HOUR FROM (time::time))<12 THEN 'Morning'
     WHEN EXTRACT (HOUR FROM (time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
     ELSE 'Evening' 
     END AS Day_time,COUNT(*) AS invoice FROM walmart
     GROUP BY Day_time
     ORDER BY invoice;

     ```
     - Profit margin analysis by branch and category.
      ```sql
     WITH Sorted_data AS 
    (SELECT branch,
     SUM(CASE WHEN EXTRACT(YEAR FROM TO_DATE(date,'dd/mm/yy')) = 2023 THEN quantity*unit_price END) AS Revenue_2023, 
     SUM(CASE WHEN EXTRACT(YEAR FROM TO_DATE(date,'DD/MM/YY')) = 2022 THEN quantity*unit_price END) AS Revenue_2022
     FROM walmart
     GROUP BY branch
     ORDER BY branch)
     SELECT *,(Revenue_2022-Revenue_2023)/Revenue_2022*100 AS revenue_Difference FROM Sorted_data
     ORDER BY revenue_Difference DESC
     LIMIT 5;


## Requirements

- **Python 3.8+**
- **SQL Databases**: MySQL, PostgreSQL
- **Python Libraries**:
  - `pandas`, `numpy`, `sqlalchemy`, `mysql-connector-python`, `psycopg2`
- **Kaggle API Key** (for data downloading)


## Project Structure

```plaintext
|-- data/                     # Raw data and transformed data
|-- sql_queries/              # SQL scripts for analysis and queries
|-- notebooks/                # Jupyter notebooks for Python analysis
|-- README.md                 # Project documentation
|-- requirements.txt          # List of required Python libraries
|-- main.py                   # Main script for loading, cleaning, and processing data
```
---

## Results and Insights

This section will include your analysis findings:
- **Sales Insights**: Key categories, branches with highest sales, and preferred payment methods.
- **Profitability**: Insights into the most profitable product categories and locations.
- **Customer Behavior**: Trends in ratings, payment preferences, and peak shopping hours.

## Future Enhancements

Possible extensions to this project:
- Integration with a dashboard tool (e.g., Power BI or Tableau) for interactive visualization.
- Additional data sources to enhance analysis depth.
- Automation of the data pipeline for real-time data ingestion and analysis.

---

## License

This project is licensed under the MIT License. 

---

## Acknowledgments

- **Data Source**: Kaggle’s Walmart Sales Dataset
- **Inspiration**: Walmart’s business case studies on sales and supply chain optimization.

---
