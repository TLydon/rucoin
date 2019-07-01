# time utilities ----------------------------------------------------------

#' @title Get current KuCoin API server time
#'
#' @return A `datetime` object
#'
#' @examples
#' # import library
#' library(rucoin)
#'
#' # get current server time
#' get_kucoin_time()
#'
#' @export

get_kucoin_time <- function() {

  # get endpoint url
  endpoint <- get_kucoin_endpoint("time")

  # get server response
  response <- GET(glue("{endpoint}"))

  # analyze response
  response <- analyze_response(response)

  # parse json result
  parsed <- fromJSON(content(response, "text"))

  # convert to proper datetime
  results <- as.POSIXct(floor(parsed$data / 1000), origin = "1970-01-01 00:00:00 UTC", tz = "UTC")

  # return the results
  results

}
