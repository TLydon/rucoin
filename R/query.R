# query market data -------------------------------------------------------

# query klines data
query_klines <- function(symbol, startAt, endAt, type) {

  query_string <- glue("https://api.kucoin.com/api/v1/market/candles?symbol={symbol}&startAt={startAt}&endAt={endAt}&type={type}")

  response <- fromJSON(query_string)

  response

}
