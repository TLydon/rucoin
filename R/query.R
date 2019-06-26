# query market data -------------------------------------------------------

# query klines data
query_klines <- function(symbol, startAt, endAt, type) {

  query_string <- glue("https://api.kucoin.com/api/v1/market/candles?symbol={symbol}&startAt={startAt}&endAt={endAt}&type={type}")

  response <- fromJSON(query_string)

  results <- as_tibble(response$data)

  colnames(results) <- c("datetime", "open", "close", "high", "low", "volume", "turnover")

  results <- results[, c("datetime", "open", "high", "low", "close", "volume", "turnover")]

  results[, 1:7] <- lapply(results[, 1:7], as.numeric)

  results$datetime <- as.POSIXct(results$datetime, origin = "1970-01-01 00:00:00 UTC", tz = "UTC")

  results <- results[order(results$datetime), ]

  results

}
