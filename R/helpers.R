# response processor ------------------------------------------------------

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

# input processor ---------------------------------------------------------

# convert conventional pair symbol to KuCoin's API standard
prep_symbols <- function(x, revert = FALSE) {

  if (revert) {

    x <- gsub("\\-", "\\/", x)

  } else {

    x <- gsub("\\/", "\\-", x)

  }

  x

}

# formate date input
prep_datetime <- function(x) as.numeric(as.POSIXct(x, tz = "UTC"))

# format frequency input
prep_frequency <- function(x) {

  if (!(is.character(x) & length(x) == 1)) {

    stop("Unsupported frequency! See function documentation for helps")

  }

  lkp <- tribble(
    ~freq, ~formatted,
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

  x <- lkp$formatted[lkp$freq == x]

  if (length(x) == 0) {

    stop("Unsupported frequency! See function documentation for helps")

  }

  x

}

prep_datetime_range <- function(from, to, frequency) {

  # prepare frequency lookup table
  lkp <- tribble(
    ~frequency, ~num, ~chr,
    "1 minute", 1, "mins",
    "3 minutes", 3, "mins",
    "5 minutes", 5, "mins",
    "15 minutes", 15, "mins",
    "30 minutes", 30, "mins",
    "1 hour", 1, "hours",
    "2 hours", 2, "hours",
    "4 hours", 4, "hours",
    "6 hours", 6, "hours",
    "8 hours", 8, "hours",
    "12 hours", 12, "hours",
    "1 day", 1, "days",
    "1 week", 1, "weeks"
  )

  # get numeric and character part from frequency
  num <- lkp$num[lkp$frequency == frequency]
  chr <- lkp$chr[lkp$frequency == frequency]

  # calculate time difference
  timediff <- difftime(
    time1 = to,
    time2 = from,
    units = chr
  )

  timelength <- as.numeric(timediff) / num

  # create time sequence
  timeseq <- seq.POSIXt(from, by = paste(num, chr), length.out = timelength)

  # prepare time range lookup table
  start_index <- c(1, c(1:timelength)[1:timelength %% 1500 == 0])
  end_index <- c(start_index[-1] - 1, timelength)

  results <- tibble(
    from = timeseq[start_index],
    to = timeseq[end_index] + 1
  )

  # return the results
  results

}

# api base data -----------------------------------------------------------

# endpoints urls lookup
get_endpoint <- function(endpoint) {

  # base api url
  base_url <- "https://api.kucoin.com/api/v1/"

  # lookup table
  lkp <- tribble(
    ~endpoint, ~path,
    "klines", "market/candles",
    "symbols", "symbols",
    "time", "timestamp"
  )

  # get specified endpoint
  path <- lkp$path[lkp$endpoint == endpoint]

  # combine with base url
  results <- glue("{base_url}{path}")

  # return the result
  results

}
