# post market order -------------------------------------------------------

#' @title Post a market order
#'
#' @param symbol A `character` vector of one or more pair symbol.
#' @param side A `character` vector of one which specify
#'  the order side: `"buy"` or `"sell"`.
#' @param base_size,quote_size A `numeric` vector which specify
#'  the base or quote currency size.
#'
#' @return A `tibble` containing order details
#'
#' @examples
#'
#' \dontrun{
#'
#' # to run this example, make sure
#' # you already setup the API key
#' # in a proper .Renviron file
#'
#' # import library
#' library(rucoin)
#'
#' # post a market order: buy 1 KCS
#' order_detail <- post_kucoin_market_order(
#'   symbol = "KCS/BTC",
#'   side = "buy",
#'   base_size = 1
#' )
#'
#' # quick check
#' order_detail
#'
#' # post a market order: sell 1 KCS
#' order_detail <- post_kucoin_market_order(
#'   symbol = "KCS/BTC",
#'   side = "sell",
#'   base_size = 1
#' )
#'
#' # quick check
#' order_detail
#'
#'
#' # post a market order: buy KCS worth 0.0001 BTC
#' order_detail <- post_kucoin_market_order(
#'   symbol = "KCS/BTC",
#'   side = "buy",
#'   quote_size = 0.0001
#' )
#'
#' # quick check
#' order_detail
#'
#' # post a market order: sell KCS worth 0.0001 BTC
#' order_detail <- post_kucoin_market_order(
#'   symbol = "KCS/BTC",
#'   side = "sell",
#'   base_size = 0.0001
#' )
#'
#' # quick check
#' order_detail
#'
#' }
#'
#' @export

post_kucoin_market_order <- function(symbol, side, base_size = NULL, quote_size = NULL) {

  # get current timestamp
  current_timestamp <- as.character(get_kucoin_time(raw = TRUE))

  # get client id
  clientOid <- base64_enc(as.character(current_timestamp))

  if (!is.null(base_size) & !is.null(quote_size)) {

    stop("Choose one from base_size or quote_size arguments!")

  } else if (is.null(base_size) & is.null(quote_size)) {

    stop("There is no specified size argument!")

  }

  # post market order
  if (!is.null(base_size)) {

    results <- post_market_order(
      symbol = prep_symbols(symbol),
      side = side,
      size = format(base_size, scientific = FALSE)
    )

  } else {

    results <- post_market_order(
      symbol = prep_symbols(symbol),
      side = side,
      funds = format(quote_size, scientific = FALSE)
    )

  }

  # return the result
  results

}

post_market_order <- function(symbol, side, size = NULL, funds = NULL) {

  # get current timestamp
  current_timestamp <- as.character(get_kucoin_time(raw = TRUE))

  # get client id
  clientOid <- base64_enc(as.character(current_timestamp))

  # prepare post body
  post_body <- list(
    clientOid = clientOid,
    symbol = symbol,
    side = side,
    type = "market",
    size = size,
    funds = funds
  )

  post_body <- post_body[!sapply(post_body, is.null)]

  post_body_json <- toJSON(post_body, auto_unbox = TRUE)

  # prepare GET headers
  sig <- paste0(current_timestamp, "POST", get_paths("orders", type = "endpoint"), post_body_json)
  sig <- hmac(object = sig, algo = "sha256", key = Sys.getenv("KC-API-SECRET"), raw = TRUE)
  sig <- base64_enc(input = sig)

  post_header <- c(
    "KC-API-KEY" = Sys.getenv("KC-API-KEY"),
    "KC-API-SIGN" = sig,
    "KC-API-TIMESTAMP" = current_timestamp,
    "KC-API-PASSPHRASE" = Sys.getenv("KC-API-PASSPHRASE")
  )

  # POST to server
  response <- POST(
    url = get_base_url(),
    path = get_paths("orders"),
    body = post_body,
    encode = "json",
    config = add_headers(.headers = post_header)
  )

  # analyze response
  response <- analyze_response(response)

  # parse json result
  parsed <- fromJSON(content(response, "text"))

  if (parsed$code != "200000") {

    stop(glue("Got error/warning with message: {parsed$msg}"))

  }

  # tidy the parsed data
  results <- as_tibble(parsed$data, .name_repair = "minimal")

  colnames(results) <- "order_id"

  # return the result
  results

}
