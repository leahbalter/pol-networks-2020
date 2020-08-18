# load things

library(tidyverse)
library(here)
library(lubridate)

cm.header.row <- here('data', 'cm_header_file.csv') %>%
  read_csv(col_names = FALSE) %>%
  unlist %>%
  unname

cm.master.list <- here('data', 'cm.txt') %>%
  read_delim(delim = '|',
             col_names = cm.header.row) %>%
  select(comm.id = CMTE_ID, comm.name = CMTE_NM,
         comm.treas = TRES_NM, comm.st.1 = CMTE_ST1,
         comm.st.2 = CMTE_ST2, comm.city = CMTE_CITY,
         comm.state = CMTE_ST, comm.zip = CMTE_ZIP,
         comm.desig = CMTE_DSGN, comm.type = CMTE_TP,
         comm.party = CMTE_PTY_AFFILIATION,
         comm.org.type = ORG_TP,
         comm.connected.org = CONNECTED_ORG_NM,
         cand.id = CAND_ID) %>%
  distinct

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
         can.state = CAND_ST, can.zip = CAND_ZIP) %>%
  distinct

data.header.row <- here('data', 'pas2_header_file.csv') %>%
  read_csv(col_names = FALSE) %>%
  unlist %>%
  unname

comm.can.data <- here('data', 'comm-can-2020.txt') %>%
  read_delim(delim = '|', guess_max = 250000,
             col_names = data.header.row) %>%
  select(row.id = SUB_ID, donor.id = CMTE_ID, 
         ammend.ind = AMNDT_IND, 
         prim.gen.ind = TRANSACTION_PGI,
         trans.type = TRANSACTION_TP, entity.type = ENTITY_TP,
         donee.cm.id = OTHER_ID, 
         #donee.can.id = CAND_ID,
         donee.com.name = NAME, donee.city = CITY, 
         donee.state = STATE, donee.zip = ZIP_CODE, 
         trans.date = TRANSACTION_DT,
         trans.amount = TRANSACTION_AMT,
         memo.code = MEMO_CD, memo.text = MEMO_TEXT) %>%
  distinct

rm(list = c('cm.header.row', 'data.header.row', 
            'can.header.row'))

comm.can.data <- comm.can.data %>% 
  left_join(select(cm.master.list, donor.id = comm.id, 
                   donor.comm.name = comm.name, 
                   donor.comm.party = comm.party, 
                   donor.comm.type = comm.type),
            by = 'donor.id') %>% 
  left_join(select(cm.master.list, donee.cm.id = comm.id,
                   donee.can.id = cand.id), 
            by = 'donee.cm.id') %>% 
  left_join(select(can.master.list, donee.can.id = can.id, can.name, 
                   donee.can.party = can.party, can.el.year,
                   can.office.state, can.office, 
                   can.office.district, can.incumb.flag,
                   can.pcc), by = 'donee.can.id') 

unmatched <- comm.can.data %>%
  filter(is.na(donee.can.id)) %>%
  select(-(donee.can.id:can.pcc)) %>%
  mutate(donee.can.id = donee.cm.id) %>%
  left_join(select(can.master.list, donee.can.id = can.id,
                   can.name, donee.can.party = can.party,
                   can.el.year, can.office.state,
                   can.office, can.office.district, 
                   can.incumb.flag, can.pcc),
            by = 'donee.can.id')

comm.can.data <- comm.can.data %>%
  filter(!is.na(can.name)) %>%
  bind_rows(unmatched %>%
              filter(!is.na(can.name)))

# these are committees that show up in neither committee
# nor candidate list
unmatched <- unmatched %>%
  filter(is.na(can.name))

comm.can.data <- comm.can.data %>%
  select(row.id, trans.date, trans.amount, can.el.year, prim.gen.ind, 
         can.office.state, can.office, can.office.district, 
         can.party = donee.can.party, can.name, can.incumb.flag, 
         donee.cm.name = donee.name, donor.cm.name = donor.comm.name, 
         trans.type, donor.entity.type = entity.type, 
         donee.cm.id, donor.cm.id = donor.id, can.pcc,
         donee.city:donee.zip, donor.cm.party = donor.comm.party,
         donor.cm.type = donor.comm.type, memo.text) %>%
  mutate(trans.date = mdy(trans.date)) %>%
  filter(can.el.year == 2020) 


# note there's about a thousand rows that either have an na(prim.gen.ind)
# or have an indicator letter that is non p/g (for, example, r for runoff election)
primary <- comm.can.data %>%
  filter(str_detect(prim.gen.ind, 'P'))

general <- comm.can.data %>%
  filter(str_detect(prim.gen.ind, 'G'))
