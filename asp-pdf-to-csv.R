library(tidyverse)
library(tabulizer)
library(janitor)
regions <- c(
  "BOUCLEDU","BOUCLEDUMOUHOUN","CASCADES","CENTRE","CENTREEST","CENTRENORD",
  "CENTREOUEST","CENTRESUD","EST","HAUTSBASSINS","NORD",
  "PLATEAUCENTRAL","SAHEL","SUDOUEST","BURKINAFASO"
)

data <- tabulizer::extract_areas(file = "rendement-ans-part-13.pdf") # select data area manually
data <- data %>% 
  pluck(1) %>% 
  as.data.frame() %>% 
  replace_with_na_all(condition =~.x%in% c("-","- -","") ) %>% 
  janitor::remove_empty()

data %>% 
  as.tibble() %>% 
  `colnames<-`(.,.[1,]) %>% 
  janitor::clean_names() %>% 
  mutate(
    across(
      .cols = everything(),
      .fns = str_replace_all,
      pattern =" ",
      replacement = ""
    )
  ) %>% 
  .[-1,] %>% 
  filter(!(regions_provinces %in% regions)) %>% 
  mutate( 
     province = snakecase::to_sentence_case(regions_provinces),
    speculation = "igname", # nom spéculation manuel
    type_culture = "pure",
    .before = everything()
    ) %>% 
  select(-regions_provinces) %>% 
  pivot_longer(
    cols = -province:-type_culture,
    names_to = "year",
    names_prefix = "x",
    values_to = "rendement",
    values_transform = as.numeric
    
  ) %>% 
  write_csv(
    file = "processed-data/igname.csv", # nom spéculation manuel
    na ="",
    col_names = TRUE,
    quote = "none"
    
  )
  
    
