# user information --------------------------------------------------------

#' @title Get user's balance(s) list
#'
#' @return A `tibble` containing balance details
#'
#' @examples
#'
#' \dontrun{
#'
#' # to run this example, make sure
#' # you already setup the API key
#' # in a proper .Renviron file
#'
#' # import library
#' library(rucoin)
#'
#' # get user's balance details
#' balances <- get_kucoin_balances()
#'
#' # quick check
#' balances
#'
#' }
#'
#' @export

get_kucoin_balances <- function() {

  # get current timestamp
  current_timestamp <- as.character(get_kucoin_time(raw = TRUE))

  # prepare GET headers
  sig <- paste0(current_timestamp, "GET", get_paths("accounts", type = "endpoint"))
  sig <- hmac(object = sig, algo = "sha256", key = Sys.getenv("KC-API-SECRET"), raw = TRUE)
  sig <- base64_enc(input = sig)

  get_header <- c(
    "KC-API-KEY" = Sys.getenv("KC-API-KEY"),
    "KC-API-SIGN" = sig,
    "KC-API-TIMESTAMP" = current_timestamp,
    "KC-API-PASSPHRASE" = Sys.getenv("KC-API-PASSPHRASE")
  )

  # GET server response
  response <- GET(
    url = get_base_url(),
    path = get_paths("accounts"),
    config = add_headers(.headers = get_header)
  )

  # analyze response
  response <- analyze_response(response)

  # parse json result
  parsed <- fromJSON(content(response, "text"))

  # tidy the parsed data
  results <- as_tibble(parsed$data)

  results <- results[, c("type", "id", "currency", "balance", "available", "holds")]

  results[, 4:6] <- lapply(results[, 4:6], as.numeric)

  results <- results[order(results$type, results$currency), ]

  # return the result
  results

}
