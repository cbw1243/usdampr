#' Request USDA MPR historical data
#'
#' The primary function in the \code{usdampr} package to request data from the USDA LMP API.
#'
#' To make valid request, users should provide valid slug IDs. The data returned is saved in a list, while each list saves info for a section.
#'
#'
#' @param slugs slug IDs. It can be a single slug ID, or multiple slug IDs.
#' @param report_time  time to request. The default time is current day. It can be a time interval.
#' @param message a binary indicator for displaying warning messages or not?
#'
#' @return
#' The function returns a list with the requested data.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' test1 <- mpr_request(slug = 2463, report_time = '01/25/2020:05/25/2020') # Get livestock
#' test2 <- mpr_request(slug = 2991, report_time = '01/25/2020:04/25/2020') # Get daily price data
#' test3 <- mpr_request(slug = 3346, report_time = '2018:2019') # Get FMMOS data
#'
#' test4 <- mpr_request(c(2461, 2463), report_time = '01/25/2020:05/25/2020') # Multiple slug IDs
#' }


mpr_request <- function(slugs, report_time = format(Sys.Date(), format="%m/%d/%Y"), message = T){
  if(length(slugs) == 1){
    out <- mpr_request_single(slugs, report_time)
  }else{
    out <- lapply(slugs, function(i) mpr_request_single(i, report_time))
    names(out) <- slugs
  }
  return(out)
}



