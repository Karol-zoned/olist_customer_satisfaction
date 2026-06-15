## "What drives customer satisfaction on Olist marketplace?"

1. Firstly I created a database from csv files using MS SQL Server - simply imported flat files to the database

CREATE DATABASE Olist
 - I check the structure of the tables. As some of them couldn't have datatypes assigned during creation, I proceed to assign primary keys and datatypes in the tables by hand. While assigning PKs I discovered
 some anomalies in the dbo.olist_order_reviews table. Those will be further investigated during the EDA phase of the project.

INSERT SOME QUERIES
TO DO: write about relations between tables, add some more about the anomaly with reviews