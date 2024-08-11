# Making Acronym and Sequence Number from Long Name with namaKU

The `namaku` purpose is to generate the acronym and sequence number for long name. This package will prevent the users from error when generating the acronym and sequence number.

This package is the part of Dhihram Tenrisau, MSc Health Data Science summer project, 'Phylodynamic of Norovirus in UK 2003-2023'. The project is supervised by Stéphane Hué

## Installation

You can install the development version of namaKU from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Dhihram/namaKU")
```

## Example

This package needs the additional package `rlang`, `tidyverse`, and `dplyr`

```{r, warning=FALSE, message=FALSE}
library(dplyr)
library(rlang)
library(tidyverse)
library(namaKU)
```

### Data

This package need a data frame that contains the long name. The data frame should have a column that contains the long name. The data frame should not have NA values in the location column.

```{r}
# Assuming 'df' is your data frame and it has a column 'AreaName'
d <- data.frame(id = seq(1:3), AreaName = c("loNDON", "Port Alegre", 'MakaSSar'), sub = c('a', 'b', 'c'))

#Check the data
str(d)

#View the data
knitr::kable(d)
```

### Package Utilization

The parameter of this package consist of :

-   `df`: data frame that contains the long name

-   `location`: the name of column that contain long name

-   `vocal`: `TRUE` to keep vocal letter, `FALSE` to remove vocal letter

-   `number` number of letter to keep from each word

-   `seq`: `TRUE` to add sequence number, `FALSE` to not add sequence number.

```{r}
d <- namaKU(df = d, location = AreaName, vocal = FALSE, number = 3, seq = TRUE)
knitr::kable(d)
```
For the manual, you can see [here](https://dhihram.github.io/namaKU/)
