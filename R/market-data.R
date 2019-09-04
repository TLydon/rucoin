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

  # get datetime ranges
  times <- prep_datetime_range(
    from = as_datetime(from),
    to = as_datetime(to),
    frequency = frequency
  )

  # get result for multiple symbols
  if (length(symbols) > 1) {

    results <- tibble()

    for (symbol in symbols) {

      # get queried results
      result <- tibble()

      for (i in 1:nrow(times)) {

        queried <- get_klines(
          symbol = prep_symbols(symbol),
          startAt = prep_datetime(times$from[i]),
          endAt = prep_datetime(times$to[i]),
          type = prep_frequency(frequency)
        )

        if (nrow(queried) == 0) {

          message(glue("No data for {symbol} {times$from[i]} to {times$to[i]}"))

        } else {

          result <- rbind(result, queried)

        }

      }

      if (nrow(result) == 0) {

        message(glue("Skipping data for {symbol}"))

      } else {

        init_names <- colnames(result)

        result$symbol <- symbol

        result <- result[, c("symbol", init_names)]

        result <- result[order(result$datetime), ]

        results <- rbind(results, result)

      }

    }

  # get result for one symbols
  } else {

    # get queried results
    results <- tibble()

    for (i in 1:nrow(times)) {

      result <- get_klines(
        symbol = prep_symbols(symbols),
        startAt = prep_datetime(times$from[i]),
        endAt = prep_datetime(times$to[i]),
        type = prep_frequency(frequency)
      )

      if (nrow(result) == 0) {

        message(glue("No data for {symbols} {times$from[i]} to {times$to[i]}"))

      } else {

        results <- rbind(results, result)

      }

    }

  }

  # return the result
  results

}

# query klines (prices) data
get_klines <- function(symbol, startAt, endAt, type) {

  # prepare query params
  query_params <- list(
    symbol = symbol,
    startAt = startAt,
    endAt = endAt,
    type = type
  )

  # get server response
  response <- GET(
    url = get_base_url(),
    path = get_paths("klines"),
    query = query_params
  )

  # analyze response
  response <- analyze_response(response)

  # parse json result
  parsed <- fromJSON(content(response, "text"))

  # tidy the parsed data
  results <- as_tibble(parsed$data, .name_repair = "minimal")

  if (nrow(results) == 0) {

    message("Specified symbols and period returning no data")

  } else {

    colnames(results) <- c("datetime", "open", "close", "high", "low", "volume", "turnover")

    results <- results[, c("datetime", "open", "high", "low", "close", "volume", "turnover")]

    results[, 1:7] <- lapply(results[, 1:7], as.numeric)

    results$datetime <- as_datetime(results$datetime)

    results <- results[order(results$datetime), ]

  }

  # return the result
  results

}

# market metadata ---------------------------------------------------------

#' @title Get all symbols' most recent metadata
#'
#' @return A `tibble` containing some metadata
#'
#' @examples
#' # import library
#' library(rucoin)
#'
#' # get all symbols' most recent metadata
#' metadata <- get_kucoin_symbols()
#'
#' # quick check
#' metadata
#'
#' @export

get_kucoin_symbols <- function() {

  # get server response
  response <- GET(
    url = get_base_url(),
    path = get_paths("symbols")
  )

  # analyze response
  response <- analyze_response(response)

  # parse json result
  parsed <- fromJSON(content(response, "text"))

  # tidy the parsed data
  results <- as_tibble(parsed$data, .name_repair = "minimal")

  colnames(results) <- c(
    "symbol", "quote_max_size", "enable_trading", "price_increment",
    "fee_currency", "base_max_size", "base_currency", "quote_currency",
    "market", "quote_increment", "base_min_size", "quote_min_size",
    "name", "base_increment"
  )

  results <- results[, c(
    "symbol", "name", "enable_trading",
    "base_currency", "quote_currency",
    "base_min_size", "quote_min_size",
    "base_max_size", "quote_max_size",
    "base_increment", "quote_increment",
    "price_increment", "fee_currency"
  )]

  results[, 6:12] <- lapply(results[, 6:12], as.numeric)

  results[, 1:2] <- lapply(results[, 1:2], prep_symbols, revert = TRUE)

  results <- results[order(results$base_currency, results$quote_currency), ]

  # return the result
  results

}
