#' Request current and historical USDA-AMS MPR data
#'
#' This is the primary function in the \code{usdampr} package to request data from the United States
#' Department of Agriculture - Agricultural Marketing Service (USDA-AMS) mandatory price reporting, commonly known as MPR.
#' This function allow users to access data documented in the Livestock Mandatory Price Reporting (LMPR),
#' Dairy Products Mandatory Reporting Program (DPMRP), and Federal Milk Marketing Orders (FMMOS) market reports.
#' LMPR contains data for cattle, hogs, sheep, beef, pork, and lamb.
#'
#' This function is built on the web service provided by USDA-AMS. Alternatives to this package include text files to be
#' directly downloaded via \url{https:://mpr.datamart.ams.usda.gov} (known as DATAMART),
#' or direct coding of the API. Starting in April 2020, text files were made permanently unavailable.
#'
#' The \code{mpr_request} function  provides flexible ways to request data. Specifically, users can download data from a single report or
#' multiple reports for a pre-specified report time. Users can also specify slug IDs or the legacy slug IDs to request data.
#'
#' The data request takes two necessary inputs. The first input is slug ID or legacy slug ID. Slug ID should be a 4-digit number
#' (numbers in characters are fine). Examples for slug ID include 2461 (Report name: National Weekly Boxed Beef Cutout & Boxed Beef Cuts),
#' 2472 (Report name: Weekly Direct Slaughter Cattle). If you happen to not know the slug ID, you can use the legacy slug IDs,
#' such as LM_XB459 (Report name: National Weekly Boxed Beef Cutout & Boxed Beef Cuts). When legacy slug IDs are provided, the
#' \code{mpr_request} function would perform an internal search for their corresponding slug IDs and then make data requests. The returned
#' data are labelled by slug IDs for consistency. Users should provide either slug IDs or legacy slug IDs, not both. The provides slug IDs
#' or legacy slug IDs must be valid. Use data(slugInfo) to get a list of valid slug IDs and the report information.
#'
#' The second input is report time. For LMPR and DPMRP, the report time should be a specific date with year, month and day,
#' formatted as: %m/%d/%Y), such as "06/05/2020" for June 5th 2020. An error message could appear if the report time is not approaritely formated.
#' For FMMOS, the report time should be a year instead, such as 2020. Users can request data for a range of time period, such as "06/01/2020:06/05/2020" for data
#' from June 1st 2020 to June 5th 2020.
#'
#'
#'
#' @param slugIDs Valid slug IDs. Should be a 4-digit number, either a numerical value or a character.
#'                Users can provide can either one slug ID or multiple slug IDs. See details.
#' @param slugIDs_legacy Valid legacy slug IDs. Examples: LM_XB401, LM_XB403.
#' @param report_time A valid date (e.g.,'01/31/2020') or period of time (e.g., '01/31/2020:03/25/2020').
#'                    For FMMOS, it should be a year (e.g., 2019). The default is the current system date.
#' @param message A binary indicator for whether to display warning messages or not. Default is TRUE.
#'
#' @return
#' The function returns a list with the requested data. The requested are either daily, weekly, monthly, or yearly, depending on the report data being requested.
#' Report sections associated with the slug ID are located in sub-lists. Empty data could be returned if there are no data associated with the request.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Load all available slug IDs, report date, report sections, and report frequency
#' # If you already know the slug IDs, you can ignore skip thie code
#' data(slugInfo)
#' # Example 1: One slug ID, single date
#' test1a <- mpr_request(slugIDs = 2461, report_time = '01/31/2020')
#' # Now use legacy slug ID
#' test1a_legacy <- mpr_request(slugIDs_legacy = 'LM_XB459', report_time = '01/31/2020')
#'
#' # Example 1: One slug ID, multiple dates
#' test1b <- mpr_request(slugIDs = 2461, report_time = '01/31/2020:03/25/2020')
#' # Multiple slug IDs, single date
#' test1c <- mpr_request(slugIDs = c(2461, 2463), report_time = '01/31/2020')
#' # Now use legacy slug ID
#' test1c_legacy <- mpr_request(slugIDs_legacy = c('LM_XB459', 'LM_XB461'), report_time = '01/31/2020')
#'
#' # Multiple slug IDs, multiple dates
#' test1d <- mpr_request(slugIDs = c(2461, 2463), report_time = '01/25/2020:03/25/2020')
#'
#' # Get Livestock Mandatory Price Reporting (LMPR) data.
#' test2a <- mpr_request(slugIDs = 2463, report_time = '01/25/2020:03/25/2020')
#' # Get Dairy Products Mandatory Reporting Program (DPMRP) data.
#' test2b <- mpr_request(slugIDs = 2991, report_time = '01/25/2020:03/25/2020')
#' # Get Federal Milk Marketing Orders (FMMOS) data. NAs are returned if the data do not exist.
#' test2c <- mpr_request(slugIDs = 3346, report_time = '2018:2019')
#'
#'}


mpr_request <- function(slugIDs = NULL, slugIDs_legacy = NULL, report_time = NULL, message = TRUE){
  if(is.null(report_time)){
    report_time = format(Sys.Date(), format="%m/%d/%Y")
  }
  if(is.null(slugIDs) & is.null(slugIDs_legacy))
    stop('slugIDs or slugIDs_legacy must be provided.')

  if(!is.null(slugIDs) & !is.null(slugIDs_legacy))
    stop("Please provide slugIDs or slugIDs_legacy, not both. Hint: use data('slugInfo') to check with the ID information")

  if(!is.null(slugIDs_legacy)){
    ehagdhjdsdcsd <- new.env()
    utils::data("slugInfo", envir = ehagdhjdsdcsd)
    slugIDs <- ehagdhjdsdcsd$slugInfo$slug_id[which(ehagdhjdsdcsd$slugInfo$legacy_slugid %in% slugIDs_legacy)]
  }

  if(length(slugIDs) == 1){
    out <- mpr_request_single(slugIDs, report_time, message = message)
  }else{
    out <- lapply(slugIDs, function(i) mpr_request_single(i, report_time, message = message))
    names(out) <- slugIDs
  }
  return(out)
}

