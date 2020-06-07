reshape_func <- function(data) {
  data_out <- tidyr::gather(data, month, value, jan:total)
  data_out <- dplyr::mutate(data_out, value = as.numeric(gsub(',', '', value)),
                            report_month =  match(month, tolower(month.abb)))
  data_out
}

check_numeric <- function(dat){
  dat_numeric <- suppressWarnings(as.numeric(gsub(',', '', dat)))
  if(sum(dat_numeric, na.rm = T) == 0){
    FALSE
  }else{
    TRUE
  }
}

convert_date <- function(data){
  out <- data
  if(grep('published_date', colnames(data))){
    out[, 'published_date'] <- as.POSIXct(out[, 'published_date'], format = "%m/%d/%Y %H:%M:%S")
  }
  if('report_date' %in% colnames(out)){
    out[, 'report_date'] <- as.Date(out[, 'report_date'], format = "%m/%d/%Y")
   }
  if('slug_id' %in% colnames(out)){
    out[, 'slug_id'] <- as.numeric(out[, 'slug_id'])
  }
  out <- dplyr::mutate_if(out, check_numeric, function(i) as.numeric(gsub(',', '', i)))
  return(out)
}

mpr_request_single <- function(slug, report_time, message){
  validIDs <- c(2451, 2453, 2455:2464, 2466:2472, 2474:2489, 2498:2524, 2656, 2659:2681, 2685:2696, 2701:2703, 2989, 2991,
                2993, 3345:3359)
  # Check slug id
  if(!as.numeric(slug) %in% validIDs) stop('Invalid slug ID. Please check with the slugInfo data set. Use data("slugInfo").')

  slug <- paste0(slug)

  if(slug %in% c('2989', '2991', '2993')){# These slug ids are for dairy prices (starting from weekly).
    request_url <- paste0('https://mpr.datamart.ams.usda.gov/services/v1.1/reports/', slug, '?q=week_ending_date=', report_time, '&allSections=true')
  }

  if(slug %in% paste0(c(2451:2703))){ # Livestock data
    request_url <- paste0('https://mpr.datamart.ams.usda.gov/services/v1.1/reports/', slug, '?q=report_date=', report_time, '&allSections=true')
  }

  if(slug %in% paste0(c(3345:3359))) {# dairy data
    #if(nchar(report_time) != 4) stop('Dairy FMMOS request can only take a four-digit year as the report_time')
    request_url <- paste0('https://mpr.datamart.ams.usda.gov/services/v1.1/reports/', slug, '?q=report_year=', report_time, '&allSections=true')
  }

  response <- httr::GET(request_url)
  if(response$status_code == 500) stop('Internet server error. Possibly due to invalid slug id. Consider revise your request.')

  data <- jsonlite::fromJSON(httr::content(response, as = "text", encoding = 'UTF-8')) #lapply(data, read_data_func2)
  data_out <- data[['results']]

  if(!is.null(data_out))  {
    if(slug %in% paste0(c(3345:3359))) {# dairy data
      for(i in 2:length(data_out)){
        data_out[[i]] <- reshape_func(data_out[[i]])
      }
    }
    names(data_out) <- data$reportSection
  }
  # Clean the dates and convert to numerical values.
  data_out <- lapply(data_out, convert_date)

  if(isTRUE(message)){
    if(sum(grepl('No Results Found', data$message)) >= 1){
      warning('There is warning message with the request. It could be due to invalid date input. Please revise your request. ',  paste0(data$message, collapse = '..'))
    }else{
      cat('Successfully requested data for slug:', slug, '\nMultiple sections are included in the data list:',
          paste0(1:length(data_out), '-',names(data_out), ';'))
    }
  }
  return(data_out)
}

