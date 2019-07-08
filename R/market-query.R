# query market data -------------------------------------------------------

# query klines data
query_klines <- function(symbol, startAt, endAt, type) {

  # get endpoint
  endpoint <- get_endpoint("klines")

  # get server response
  response <- GET(glue("{endpoint}?symbol={symbol}&startAt={startAt}&endAt={endAt}&type={type}"))

  # analyze response
  response <- analyze_response(response)

  # parse json result
  parsed <- fromJSON(content(response, "text"))

  # tidy the parsed data
  results <- as_tibble(parsed$data, .name_repair = "minimal")

  colnames(results) <- c("datetime", "open", "close", "high", "low", "volume", "turnover")

  results <- results[, c("datetime", "open", "high", "low", "close", "volume", "turnover")]

  results[, 1:7] <- lapply(results[, 1:7], as.numeric)

  results$datetime <- as_datetime(results$datetime)

  results <- results[order(results$datetime), ]

  # return the result
  results

}
