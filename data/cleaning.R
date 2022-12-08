
{
  library(tidyverse)
  library(janitor)
}

# reading in the data

nba <- read_csv('data/nba_5year_surv.csv')  %>% 
  clean_names() %>% 
  mutate(surv_5yrs = ifelse(surv_5yrs=='Yes', 1, 0))

# getting rid of duplicates (where all observations are the same except 1 is
# success and other is not) ... gets rid of 20 rows (1328 --> 1308)

nba_clean <- nba %>% 
  group_by(name, fg_attempts_per_game, oreb_per_game, 
           ft_made_per_game, assists_per_game) %>% 
  mutate(duplicate = n() > 1) %>% 
  filter((!duplicate) | (duplicate & surv_5yrs == 1)) %>% 
  select(-duplicate) %>% 
  ungroup() 

write.csv(nba_clean, 'data/nba_clean.csv')

# checking that things still look okay

nba %>% 
  group_by(name, fg_attempts_per_game, oreb_per_game, 
           ft_made_per_game, assists_per_game) %>% 
  mutate(duplicate = n() > 1) %>% 
  filter(duplicate & surv_5yrs != 1) %>% 
  select(-duplicate) %>% 
  ungroup() %>% 
  pull(name)
