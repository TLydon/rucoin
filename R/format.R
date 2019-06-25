# input formatter ---------------------------------------------------------

# convert conventional pair symbol to KuCoin's API standard
prep_kucoin_symbols <- function(x, revert = FALSE) {

  if (revert) {

    x <- str_replace_all(x, "\\-", "\\/")

  } else {

    x <- str_replace_all(x, "\\/", "\\-")

  }

  x

}

# formate date input
prep_kucoin_datetime <- function(x) as.numeric(as_datetime(x))

# format frequency input
prep_kucoin_frequency <- function(x) {

  if (!(is.character(x) & length(x) == 1))
    stop("Unsupported frequency! See function documentation for helps")

  x <- case_when(
    x == "1 minute" ~ "1min",
    x == "3 minutes" ~ "3min",
    x == "5 minutes" ~ "5min",
    x == "15 minutes" ~ "15min",
    x == "30 minutes" ~ "30min",
    x == "1 hour" ~ "1hour",
    x == "2 hour" ~ "2hour",
    x == "4 hour" ~ "4hour",
    x == "6 hour" ~ "6hour",
    x == "8 hour" ~ "8hour",
    x == "12 hour" ~ "12hour",
    x == "1 day" ~ "1day",
    x == "1 week" ~ "1week"
  )

  if (is.na(x))
    stop("Unsupported frequency! See function documentation for helps")

  x

}
