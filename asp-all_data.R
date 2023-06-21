library(tidyverse)
library(writexl)
library(fs)

csv_files <- dir_ls("processed-data/",glob = "*.csv")

all_rdt <- map_dfr(
  .x = csv_files ,
  .f = read_csv,
) # some files contains in year columns 2_019 instead of 2019 correcte manually

all_rdt %>% 
  pivot_wider(id_cols = province:type_culture,
              names_from = year,
              values_from = "rendement") %>% 
  group_split(speculation) %>% 
  write_xlsx(path = "processed-data/all_data.xlsx",
             col_names = TRUE,
             format_headers = TRUE)
  