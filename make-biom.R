# Make biom table from Zack's metadata and taxonomy tables
taxDat <- readRDS(system.file("explore-anacapa-output", "data", "demo_taxonTable.Rds", package = "ranacapa"))
metDat <- readRDS(system.file("explore-anacapa-output", "data", "demo_metadata.Rds", package = "ranacapa"))
psobj <- convert_anacapa_to_phyloseq(taxDat, metDat)
psobj <- subset_samples(psobj, subset = (Sample != "PCR_blank_3"))
psobj <- subset_samples(psobj, subset = (Sample != "PCR_blank_4"))

otu <- otu_table(psobj)
tax <- tax_table(psobj)
colnames(tax) <- paste0("Rank",1:6)
biom_object <- make_biom(data = otu, observation_metadata = tax)
write_biom(biom_object, "test-biom.biom")
imported_biom <- read_biom("test-biom.biom")


imported_otu <- as(biom_data(imported_biom), "matrix")
imported_otu_df <- as(biom_data(imported_biom), "matrix") %>% as.data.frame() %>% rownames_to_column("taxID")
imported_met <- observation_metadata(imported_biom)
imported_met_df <- as(observation_metadata(imported_biom), "matrix") %>% as.data.frame() %>% rownames_to_column("taxID")

imported_met_df2 <- imported_met_df %>% mutate(V1 = paste0("p__", V1),
                V2 = paste0("c__", V2),
                V3 = paste0("o__", V3),
                V4 = paste0("f__", V4),
                V5 = paste0("g__", V5),
                V6 = paste0("s__", V6)) %>% 
  mutate(taxonomy =  paste(V1, V2, V3, V4, V5, V6, sep = ";")) %>%
  select(-c(V1, V2, V3, V4, V5, V6))
to_write <- left_join(imported_otu_df, imported_met_df)

write.table(to_write, "zacks-otu-table.txt", quote = F, row.names = F, sep = "\t")
