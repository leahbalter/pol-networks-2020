# load things

library(tidyverse)
library(here)

cm.header.row <- here('data', 'cm_header_file.csv') %>%
  read_csv(col_names = FALSE) %>%
  unlist %>%
  unname

cm.master.list <- here('data', 'cm.txt') %>%
  read_delim(delim = '|',
             col_names = cm.header.row)

data.header.row <- here('data', 'pas2_header_file.csv') %>%
  read_csv(col_names = FALSE) %>%
  unlist %>%
  unname

comm.can.data <- here('data', 'comm-can-2020.txt') %>%
  read_delim(delim = '|', guess_max = 250000,
             col_names = data.header.row)

rm(list = c('cm.header.row', 'data.header.row'))
