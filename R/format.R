# input formatter ---------------------------------------------------------

# convert conventional pair symbol to KuCoin's API standard
prep_kucoin_symbols <- function(x, revert = FALSE) {

  if (revert) {

    x <- gsub("\\-", "\\/", x)

  } else {

    x <- gsub("\\/", "\\-", x)

  }

  x

}

# formate date input
prep_kucoin_datetime <- function(x) as.numeric(as.POSIXct(x, tz = "UTC"))

# format frequency input
prep_kucoin_frequency <- function(x) {

  if (!(is.character(x) & length(x) == 1)) {

    stop("Unsupported frequency! See function documentation for helps")

  }

  lookup <- tribble(
    ~x, ~y,
    "1 minute", "1min",
    "3 minutes", "3min",
    "5 minutes", "5min",
    "15 minutes", "15min",
    "30 minutes", "30min",
    "1 hour", "1hour",
    "2 hours", "2hour",
    "4 hours", "4hour",
    "6 hours", "6hour",
    "8 hours", "8hour",
    "12 hours", "12hour",
    "1 day", "1day",
    "1 week", "1week"
  )

  x <- lookup$y[lookup$x == x]

  if (length(x) == 0) {

    stop("Unsupported frequency! See function documentation for helps")

  }

  x

}
