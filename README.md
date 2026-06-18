# "What drives customer satisfaction on Olist marketplace?"

## Project Overview

This project explores the main factors that influence customer satisfaction on the Olist marketplace. The analysis focuses on customer reviews, order delivery performance, payment behavior, products, sellers, and geographic information.

The main business question is:

/nWhat drives customer satisfaction on the Olist marketplace?/n

The goal of the project is to identify patterns connected with higher and lower review scores and translate them into business insights.

CREATE DATABASE Olist
 - I check the structure of the tables. As some of them couldn't have datatypes assigned during creation, I proceed to assign primary keys and datatypes in the tables by hand. While assigning PKs I discovered
 some anomalies in the dbo.olist_order_reviews table. Those will be further investigated during the EDA phase of the project.

INSERT SOME QUERIES
TO DO: write about relations between tables, add some more about the anomaly with reviews

### Creating relational database model

![Database schema](schema.png)

### Data profiling
 1. dbo.olist_orders
