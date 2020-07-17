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

can.header.row <- here('data', 'cn_header_file.csv') %>%
  read_csv(col_names = FALSE) %>%
  unlist %>%
  unname 

can.master.list <- here('data', 'cn.txt') %>%
  read_delim(delim = '|',
             col_names = can.header.row) %>%
  select(can.id = CAND_ID, can.name = CAND_NAME,
         can.party = CAND_PTY_AFFILIATION,
         can.el.year = CAND_ELECTION_YR,
         can.office.state = CAND_OFFICE_ST,
         can.office = CAND_OFFICE,
         can.office.district = CAND_OFFICE_DISTRICT,
         can.incumb.flag = CAND_ICI,
         can.pcc = CAND_PCC, can.st.1 = CAND_ST1,
         can.st.2 = CAND_ST2, can.city = CAND_CITY,
         can.state = CAND_ST, can.zip = CAND_ZIP)

data.header.row <- here('data', 'pas2_header_file.csv') %>%
  read_csv(col_names = FALSE) %>%
  unlist %>%
  unname

comm.can.data <- here('data', 'comm-can-2020.txt') %>%
  read_delim(delim = '|', guess_max = 250000,
             col_names = data.header.row)

rm(list = c('cm.header.row', 'data.header.row', 
            'can.header.row'))
