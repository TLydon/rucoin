# response analyzer
analyze_response <- function(x) {

  # stop if not return json
  if (http_type(x) != "application/json") {

    stop("Server not responded correctly")

  }

  # stop if server responding with error
  if (http_error(x)) {

    stop(glue("Stopped with message: '{http_status(x)$message}'"))

  }

  # return original if all success
  x

}

# endpoints urls lookup
get_kucoin_endpoint <- function(endpoint) {

  # base api url
  base_url <- "https://api.kucoin.com/api/v1/"

  # lookup table
  lookup <- tribble(
    ~endpoint, ~path,
    "klines", "market/candles",
    "symbols", "symbols",
    "time", "timestamp"
  )

  # get specified endpoint
  path <- lookup$path[lookup$endpoint == endpoint]

  # combine with base url
  results <- glue("{base_url}{path}")

  # return the result
  results

}
