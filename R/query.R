# query market data -------------------------------------------------------

# query klines data
query_klines <- function(symbol, startAt, endAt, type) {

  query_string <- glue("https://api.kucoin.com/api/v1/market/candles?symbol={symbol}&startAt={startAt}&endAt={endAt}&type={type}")

  response <- fromJSON(query_string)

  results <- as_tibble(response$data)
  colnames(results) <- c("datetime", "open", "close", "high", "low", "volume", "turnover")

  results$datetime <- as.POSIXct(as.numeric(results$datetime), origin = "1970-01-01 00:00:00 UTC", tz = "UTC")
  results$open <- as.numeric(results$open)
  results$high <- as.numeric(results$high)
  results$low <- as.numeric(results$low)
  results$close <- as.numeric(results$close)
  results$volume <- as.numeric(results$volume)
  results$turnover <- as.numeric(results$turnover)

  results <- results[, c("datetime", "open", "high", "low", "close", "volume", "turnover")]
  results <- results[order(results$datetime), ]

  results

}
