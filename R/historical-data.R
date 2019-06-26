# get historical data -----------------------------------------------------

#' @title Get historical data from specified symbols
#'
#' @param symbols A `character` vector of one or more pair symbol.
#' @param from A `character` with valid `date`/`datetime` format,
#'  or `date`/`datetime` object as a start of datetime range.
#' @param to A `character` with valid `date`/`datetime` format,
#'  or `date`/`datetime` object as an end of datetime range.
#' @param frequency A `character` vector of one which specify
#'  the frequency option, see details for further information.
#'
#' @details
#'
#'  There are several supported frequencies:
#'
#'  * `"1 minute"`
#'  * `"3 minutes"`
#'  * `"5 minutes"`
#'  * `"15 minutes"`
#'  * `"30 minutes"`
#'  * `"1 hour"`
#'  * `"2 hours"`
#'  * `"4 hours"`
#'  * `"6 hours"`
#'  * `"8 hours"`
#'  * `"12 hours"`
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
#'   from = "2019-06-01 00:00:00",
#'   to = "2019-06-02 00:00:00",
#'   frequency = "1 hour"
#' )
#'
#' # quick check
#' prices
#'
#' # get multiple pair of symbols prices
#' prices <- get_kucoin_prices(
#'   symbols = c("KCS/USDT", "BTC/USDT", "KCS/BTC"),
#'   from = "2019-06-01 00:00:00",
#'   to = "2019-06-02 00:00:00",
#'   frequency = "1 hour"
#' )
#'
#' # quick check
#' prices
#'
#' @export

get_kucoin_prices <- function(symbols, from, to, frequency) {

  if (length(symbols) > 1) {

    results <- tibble()

    for (symbol in symbols) {

      result <- query_klines(
        symbol = prep_kucoin_symbols(symbol),
        startAt = prep_kucoin_datetime(from),
        endAt = prep_kucoin_datetime(to),
        type = prep_kucoin_frequency(frequency)
      )

      result$symbol <- symbol
      result <- result[, c("symbol", "datetime", "open", "high", "low", "close", "volume", "turnover")]
      result <- result[order(result$datetime), ]

      results <- rbind(results, result)

    }

  } else {

    results <- query_klines(
      symbol = prep_kucoin_symbols(symbols),
      startAt = prep_kucoin_datetime(from),
      endAt = prep_kucoin_datetime(to),
      type = prep_kucoin_frequency(frequency)
    )

  }

  results

}
