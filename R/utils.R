# time utilities ----------------------------------------------------------

#' @title Get current KuCoin API server time
#'
#' @param raw A `logical` vector to specify whether
#'  to return a raw results or not. The default is `FALSE`.
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

get_kucoin_time <- function(raw = FALSE) {

  # get server response
  response <- GET(
    url = get_base_url(),
    path = get_paths("time")
  )

  # analyze response
  response <- analyze_response(response)

  # parse json result
  parsed <- fromJSON(content(response, "text"))

  # get timestamp
  results <- as.numeric(parsed$data)

  # parse datetime if raw == FALSE
  if (!raw) {

    # readjust result
    results <- floor(parsed$data / 1000)

    # convert to proper datetime
    results <- as_datetime(results)

  }

  # return the results
  results

}
