## Request current and historical USDA-AMS MPR data

### Background    

The Livestock Mandatory Price Reporting System (LMPRS) was congressionally mandated by the Livestock Mandatory Reporting Act of 1999 (The Act) and renewed in 2006. The Act requires U.S. Department of Agriculture (USDA) to create a livestock reporting system for up-to-date marketing information on cattle, swine, lambs, and the by-products of such livestock. 

LMPRS requires packers, processors, and importers to report the marketing information several times each day, whereupon it is aggregated and made available electronically to these and other market participants. The marketing information includes pricing, contracting for purchase, and supply and demand conditions for livestock, livestock production, and livestock products. 

Initially, the report data was available at the top of the hour for most reports. Starting on the afternoon of May 4, 2020, LMR will begin releasing report data on LMR Datamart, LMR Web Service and the LMR API in real time. This change brings both voluntary and mandatory report release processes in sync.

### Usage description
The `usdampr` package provides access to the report data in LMPRS through `R`, and it is built on the LMR Web Service. Technically, all data available at the LMR Web Service can be accessed from the `usdampr` package. 

`mpr_request` is the primary function in the `usdampr` package for making data requests. The data are automatically cleaned so that users can analyze and visualize the requested data without further data processing.

`mpr_request` takes two necessary inputs: slug ID and report time. 

  - slug ID: Users can request data based on slug ID or the legacy slug ID. For example, users can request data from the report of "National Weekly Boxed Beef Cutout & Boxed Beef Cuts" by letting the slug ID be 2461 or the legacy slug ID be LM_XB459. Multiple slug ID can be used to request data from multiple reports at the same time.   
  - report time: Users shall provide a report time for requesting the data. 
  Please refer to the help page of the `mpr_request` function for details. 
  
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

### Contact  
[Bowen Chen](www.bwchen.com), Email: bwchen0719@gmail.com     
[Elliott Dennis](https://agecon.unl.edu/faculty/elliott-dennis), Email: elliott.dennis@unl.edu    


