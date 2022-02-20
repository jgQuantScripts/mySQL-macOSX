# 1. Install MySQL Server   : https://dev.mysql.com/downloads/mysql/
# 2. Install MySQL Workbench: https://dev.mysql.com/downloads/workbench/
# 3. Install iODBC SDK      : http://www.iodbc.org/dataspace/doc/iodbc/wiki/iodbcWiki/Downloads
# 4. Install MySQL Connector: https://dev.mysql.com/downloads/connector/odbc/
# required packages 
require("quantmod");require("odbc");require("DBI")

# get Data
ticker ="AAPL"
STK <- getSymbols(ticker,auto.assign = FALSE)
colnames(STK) <- gsub(paste0(ticker,"."),"",names(STK))
# convert to data frame
STK = as.data.frame(cbind(as.character(index(STK)), coredata(STK)), row.names = NULL)
colnames(STK)[1] = "Date"
STK$Symbol <- ticker

# column classes for data.frame (i.e. what type of data is being stored in DB)
fieldTYPES= list(
  Date="date",Open="double(10,2)",High="double(10,2)",Low="double(10,2)",
  Close ="double(10,2)",Volume="Int(25)",Adjusted="double(10,2)", Symbol="varchar(8)"
)
# connect to DB - CHANGE "PWD" to the your own database password!!!
library("DBI")
con <- dbConnect(odbc(), Driver = "/usr/local/mysql-connector-odbc-8.0.28-macos11-x86-64bit/lib/libmyodbc8a.so", 
                 Server = "localhost", Database = "sys", UID = "root", PWD = "testDB_123", 
                 Port = 3306)
# write table
dbWriteTable(con, name="OHLCV", value=STK, field.types=fieldTYPES ,row.names=FALSE)

