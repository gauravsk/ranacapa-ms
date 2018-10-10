# Make biom table from Zack's metadata and taxonomy tables
library(tidyverse)
library(phyloseq)
library(ranacapa)
taxDat <- readRDS(system.file("explore-anacapa-output", "data", "demo_taxonTable.Rds", package = "ranacapa"))

taxDat <- taxDat %>% select(-PCR_blank_3, -PCR_blank_4)


to_write <- taxDat %>% 
  rename(taxID = sum.taxonomy) %>%
  separate(., taxID, into = paste0("V", 1:6), ";", remove = F) %>%
  mutate(V1 = paste0("p__", V1),
         V2 = paste0("c__", V2),
         V3 = paste0("o__", V3),
         V4 = paste0("f__", V4),
         V5 = paste0("g__", V5),
         V6 = paste0("s__", V6)) %>% 
  mutate(taxonomy =  paste(V1, V2, V3, V4, V5, V6, sep = ";")) %>%
  select(-c(V1, V2, V3, V4, V5, V6))

write.table(to_write, "channel-islands-otu-table.txt", quote = F, row.names = F, sep = "\t")
