## Request current and historical USDA-AMS MPR data

### Background    

In the 1990’s, concern over growing packer concentration and a hog industry market shock resulted in discontent among producers and packers. As a result, the US Congress passed the Livestock Mandatory Reporting Act of 1999 (1999 Act) [Pub. L. 106-78, Title IX](https://en.wikipedia.org/wiki/Livestock_Mandatory_Reporting_Act_of_1999) which is required to be reauthorized every 5 years. See [here](https://www.ams.usda.gov/sites/default/files/media/LivestockMandatoryReportingBackground.pdf) for a full history of the Livestock Mandatory Reporting Background. The Act requires U.S. Department of Agriculture (USDA) to create a livestock reporting system for up-to-date marketing information on cattle, swine, lambs, and the by-products of such livestock.   

LMPRS requires packers, processors, and importers to report the marketing information several times each day, whereupon it is aggregated and made available electronically to these and other market participants. Since April 2000, market reports have been publicly issued in the form of .txt files with varying frequency. However, starting in April 2020, text files were made permanently unavailable. Instead, LMR began releasing report data on [LMR Datamart](https://mpr.datamart.ams.usda.gov/), LMR Web Service and the LMR API in real time. This change brings both voluntary and mandatory report release processes in sync.  

### Usage description
The `usdampr` package provides access to the report data in LMPRS through `R`, and it is built on the LMR Web Service. Technically, all data available at the LMR Web Service can be accessed from the `usdampr` package. 

`mpr_request` is the primary function in the `usdampr` package for making data requests. The data are automatically cleaned so that users can analyze and visualize the requested data without further data processing.

`mpr_request` takes two necessary inputs: slug ID and report time. 

  - slug ID: Users can request data based on slug ID or the legacy slug ID. For example, users can request data from the report of "National Weekly Boxed Beef Cutout & Boxed Beef Cuts" by letting the slug ID be 2461 or the legacy slug ID be LM_XB459. Multiple slug ID can be used to request data from multiple reports at the same time.   
  - report time: Users shall provide a report time for requesting the data. 
 
 The `usdampr` package also contains a data set called `slugInfo`, which documents some details about the reports (e.g., slug ID, legacy slug ID, report frequency, and report section headings). Please refer to the help page of the `mpr_request` function for details. 


### Examples   
  Below are some examples to show how the `mpr_request` function should be used. 

  Example 1: Request data for slug ID of 2461 on January 31, 2020
 ```
  test1a <- mpr_request(slugIDs = 2461, report_time = '01/31/2020')
 ```
 
  Example 2: Request data for slug ID of 2461 and 2463 on January 31, 2020   
```
test1c <- mpr_request(slugIDs = c(2461, 2463), report_time = '01/31/2020')
```
More examples are provided in the help page of the `mpr_request` function.

### Package installation   
```
devtools::install_github('cbw1243/usdampr')
```
Install the `devtools` package if you have not done it yet. Use `install.packages('devtools')`.

### Authors & Contact   
[Bowen Chen](www.bwchen.com), Email: bwchen0719@gmail.com     
[Elliott Dennis](https://agecon.unl.edu/faculty/elliott-dennis), Email: elliott.dennis@unl.edu    


