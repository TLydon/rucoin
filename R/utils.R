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

  response <- fromJSON("https://api.kucoin.com/api/v1/timestamp")

  result <- as.POSIXct(floor(response$data / 1000), origin = "1970-01-01 00:00:00 UTC", tz = "UTC")

  result

}
