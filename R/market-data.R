# get market data ---------------------------------------------------------

#' @title Get current KuCoin API server time
#'
#' @param symbols A `character` vector of one or more pair symbol.
#' @param from A `date` or `datetime` object as a start of datetime range.
#' @param to A `date` or `datetime` object as an end of datetime range.
#' @param frequency A `character` vector of one which specify
#'  the frequency option.
#'
#' @details
#'
#'  List of supported frequencies:
#'
#'  * `"1 minute"`
#'  * `"3 minutes"`
#'  * `"5 minutes"`
#'  * `"15 minutes"`
#'  * `"30 minutes"`
#'  * `"1 hour"`
#'  * `"2 hour"`
#'  * `"4 hour"`
#'  * `"6 hour"`
#'  * `"8 hour"`
#'  * `"12 hour"`
#'  * `"1 day"`
#'  * `"1 week"`
#'
#' @return A `tibble` containing prices data
#'
#' @examples
#'
#' # import library
#' library(rucoin)
#'
#' # get one pair of symbol prices
#' prices <- get_kucoin_prices(
#'   symbols = "KCS/USDT",
#'   from = ymd_hms("2019-06-01 00:00:00"),
#'   to = ymd_hms("2019-06-02 00:00:00"),
#'   frequency = "1 hour"
#' )
#'
#' prices
#'
#' # get multiple pair of symbols prices
#' prices <- get_kucoin_prices(
#'   symbols = c("KCS/USDT", "BTC/USDT", "KCS/BTC"),
#'   from = ymd_hms("2019-06-01 00:00:00"),
#'   to = ymd_hms("2019-06-02 00:00:00"),
#'   frequency = "1 hour"
#' )
#'
#' prices
#'
#' @export

get_kucoin_prices <- function(symbols, from, to, frequency) {

  base_url <- "https://api.kucoin.com/api/v1/market/candles?"

  from <- as.numeric(as_datetime(from))
  to <- as.numeric(as_datetime(to))

  symbols <- prep_kucoin_symbols(symbols)
  frequency <- prep_kucoin_frequency(frequency)

  if (length(symbols) > 1) {

    results <- tibble()

    for (symbol in symbols) {

      response <- fromJSON(glue("{base_url}symbol={symbol}&startAt={from}&endAt={to}&type={frequency}"))

      result <- as_tibble(response$data, .name_repair = "minimal")
      result <- set_names(result, c("datetime", "open", "close", "high", "low", "volume", "turnover"))

      result$datetime <- as_datetime(as.numeric(result$datetime))
      result$open <- as.numeric(result$open)
      result$high <- as.numeric(result$high)
      result$low <- as.numeric(result$low)
      result$close <- as.numeric(result$close)
      result$volume <- as.numeric(result$volume)
      result$turnover <- as.numeric(result$turnover)

      result$symbol <- prep_kucoin_symbols(symbol, revert = TRUE)
      result <- result[, c("symbol", "datetime", "open", "high", "low", "close", "volume", "turnover")]
      result <- result[order(result$datetime), ]

      results <- bind_rows(results, result)

    }

  } else {

    response <- fromJSON(glue("{base_url}symbol={symbols}&startAt={from}&endAt={to}&type={frequency}"))

    results <- as_tibble(response$data, .name_repair = "minimal")
    results <- set_names(results, c("datetime", "open", "close", "high", "low", "volume", "turnover"))

    results$datetime <- as_datetime(as.numeric(results$datetime))
    results$open <- as.numeric(results$open)
    results$high <- as.numeric(results$high)
    results$low <- as.numeric(results$low)
    results$close <- as.numeric(results$close)
    results$volume <- as.numeric(results$volume)
    results$turnover <- as.numeric(results$turnover)

    results <- results[, c("datetime", "open", "high", "low", "close", "volume", "turnover")]
    results <- results[order(results$datetime), ]

  }

  results

}
