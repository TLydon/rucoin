
# rucoin

An R API to KuCoin Crytocurrency market data and market orders.

**Currently only have supports for getting market data, and still in
heavy development stage\!**

## Installation

You can install the development version of `rucoin` using:

``` r
# install.packages("devtools")
devtools::install_github("bagasbgy/rucoin")
```

## Getting Started

First of all, let’s start by importing the library:

``` r
# import library
library(rucoin)
```

### Historical Data

For getting historical data, you can use `get_kucoin_prices()`:

``` r
# get one pair of symbol prices
prices <- get_kucoin_prices(
  symbols = "KCS/USDT",
  from = "2019-06-01 00:00:00",
  to = "2019-06-02 00:00:00",
  frequency = "1 hour"
)

# quick check
prices
#> # A tibble: 24 x 7
#>    datetime             open  high   low close volume turnover
#>    <dttm>              <dbl> <dbl> <dbl> <dbl>  <dbl>    <dbl>
#>  1 1970-01-01 00:00:01    13    19    17    21     10       12
#>  2 1970-01-01 00:00:02    20    18    16    14      1        1
#>  3 1970-01-01 00:00:03    18    17    12    19      6        6
#>  4 1970-01-01 00:00:04    17    16    15    13      2        2
#>  5 1970-01-01 00:00:05    14    14    13    16     14       14
#>  6 1970-01-01 00:00:06    15    10     8     9      5        5
#>  7 1970-01-01 00:00:07     6     9     6    12     22       22
#>  8 1970-01-01 00:00:08    10    13    11    20     23       23
#>  9 1970-01-01 00:00:09    19    20    18    22     24       24
#> 10 1970-01-01 00:00:10    21    22    20    24     21       21
#> # … with 14 more rows
```

The `get_kucoin_prices()` function also support for querying multiple
symbols:

``` r
# get one pair of symbol prices
prices <- get_kucoin_prices(
  symbols = c("KCS/USDT", "BTC/USDT", "KCS/BTC"),
  from = "2019-06-01 00:00:00",
  to = "2019-06-02 00:00:00",
  frequency = "1 hour"
)

# quick check
prices
#> # A tibble: 72 x 8
#>    symbol   datetime             open  high   low close volume turnover
#>    <chr>    <dttm>              <dbl> <dbl> <dbl> <dbl>  <dbl>    <dbl>
#>  1 KCS/USDT 1970-01-01 00:00:01    13    19    17    21     10       12
#>  2 KCS/USDT 1970-01-01 00:00:02    20    18    16    14      1        1
#>  3 KCS/USDT 1970-01-01 00:00:03    18    17    12    19      6        6
#>  4 KCS/USDT 1970-01-01 00:00:04    17    16    15    13      2        2
#>  5 KCS/USDT 1970-01-01 00:00:05    14    14    13    16     14       14
#>  6 KCS/USDT 1970-01-01 00:00:06    15    10     8     9      5        5
#>  7 KCS/USDT 1970-01-01 00:00:07     6     9     6    12     22       22
#>  8 KCS/USDT 1970-01-01 00:00:08    10    13    11    20     23       23
#>  9 KCS/USDT 1970-01-01 00:00:09    19    20    18    22     24       24
#> 10 KCS/USDT 1970-01-01 00:00:10    21    22    20    24     21       21
#> # … with 62 more rows
```

## Further Development

  - API for market meta data
  - API for market orders
