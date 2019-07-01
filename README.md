
# rucoin

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/bagasbgy/rucoin.svg?branch=master)](https://travis-ci.org/bagasbgy/rucoin)
<!-- badges: end -->

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

### Market Data

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
#>    datetime             open  high   low close  volume turnover
#>    <dttm>              <dbl> <dbl> <dbl> <dbl>   <dbl>    <dbl>
#>  1 2019-06-01 00:00:00  1.17  1.18  1.17  1.18 167547.  197324.
#>  2 2019-06-01 01:00:00  1.18  1.18  1.17  1.17 100258.  117947.
#>  3 2019-06-01 02:00:00  1.18  1.18  1.17  1.18 154036.  180993.
#>  4 2019-06-01 03:00:00  1.18  1.18  1.17  1.17 109438.  128619.
#>  5 2019-06-01 04:00:00  1.17  1.18  1.17  1.17 176296.  206855.
#>  6 2019-06-01 05:00:00  1.18  1.18  1.14  1.14 153679.  179050.
#>  7 2019-06-01 06:00:00  1.14  1.17  1.14  1.16 479256.  553977.
#>  8 2019-06-01 07:00:00  1.16  1.18  1.15  1.18 606178.  705656.
#>  9 2019-06-01 08:00:00  1.18  1.20  1.17  1.20 651853.  773753.
#> 10 2019-06-01 09:00:00  1.2   1.22  1.20  1.21 454741.  550390.
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
#>    symbol   datetime             open  high   low close  volume turnover
#>    <chr>    <dttm>              <dbl> <dbl> <dbl> <dbl>   <dbl>    <dbl>
#>  1 KCS/USDT 2019-06-01 00:00:00  1.17  1.18  1.17  1.18 167547.  197324.
#>  2 KCS/USDT 2019-06-01 01:00:00  1.18  1.18  1.17  1.17 100258.  117947.
#>  3 KCS/USDT 2019-06-01 02:00:00  1.18  1.18  1.17  1.18 154036.  180993.
#>  4 KCS/USDT 2019-06-01 03:00:00  1.18  1.18  1.17  1.17 109438.  128619.
#>  5 KCS/USDT 2019-06-01 04:00:00  1.17  1.18  1.17  1.17 176296.  206855.
#>  6 KCS/USDT 2019-06-01 05:00:00  1.18  1.18  1.14  1.14 153679.  179050.
#>  7 KCS/USDT 2019-06-01 06:00:00  1.14  1.17  1.14  1.16 479256.  553977.
#>  8 KCS/USDT 2019-06-01 07:00:00  1.16  1.18  1.15  1.18 606178.  705656.
#>  9 KCS/USDT 2019-06-01 08:00:00  1.18  1.20  1.17  1.20 651853.  773753.
#> 10 KCS/USDT 2019-06-01 09:00:00  1.2   1.22  1.20  1.21 454741.  550390.
#> # … with 62 more rows
```

You can also get the most recent metadata for all symbols using
`get_kucoin_symbols()`:

``` r
# get all symbols' most recent metadata
metadata <- get_kucoin_symbols()

# quick check
metadata
#> # A tibble: 434 x 13
#>    symbol name  enable_trading base_currency quote_currency base_min_size
#>    <chr>  <chr> <lgl>          <chr>         <chr>                  <dbl>
#>  1 ACAT/… ACAT… TRUE           ACAT          BTC                    100  
#>  2 ACAT/… ACAT… TRUE           ACAT          ETH                    100  
#>  3 ACT/B… ACT/… TRUE           ACT           BTC                      1  
#>  4 ACT/E… ACT/… TRUE           ACT           ETH                      1  
#>  5 ADB/B… ADB/… TRUE           ADB           BTC                     10  
#>  6 ADB/E… ADB/… TRUE           ADB           ETH                     10  
#>  7 AERGO… AERG… TRUE           AERGO         BTC                      0.1
#>  8 AERGO… AERG… TRUE           AERGO         ETH                      0.1
#>  9 AGI/B… AGI/… TRUE           AGI           BTC                      1  
#> 10 AGI/E… AGI/… TRUE           AGI           ETH                      1  
#> # … with 424 more rows, and 7 more variables: quote_min_size <dbl>,
#> #   base_max_size <dbl>, quote_max_size <dbl>, base_increment <dbl>,
#> #   quote_increment <dbl>, price_increment <dbl>, fee_currency <chr>
```

## Further Development

  - API for market meta data
  - API for market orders
