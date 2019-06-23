
# rucoin

An API to KuCoin Crytocurrency Exchange data and market orders.

**Currently only have supports for getting market data, and still in
heavy development stage\!**

## Installation

You can install the development version of `rucoin` using:

``` r
# install.packages("devtools")
devtools::install_github("bagasbgy/rucoin")
```

## Getting Started

For getting market data, you can use `get_kucoin_prices()`:

``` r
# import library
library(rucoin)

# get one pair of symbol prices
prices <- get_kucoin_prices(
  symbols = "KCS/USDT",
  from = ymd_hms("2019-06-01 00:00:00"),
  to = ymd_hms("2019-06-02 00:00:00"),
  frequency = "1 hour"
)

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

## Further Development

  - API for market orders
