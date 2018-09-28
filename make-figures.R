# Figure 1
library(ranacapa)
library(plotly)
library(phyloseq)
library(tidyverse)
library(reshape2)
library(heatmaply)
taxDat <- readRDS(system.file("explore-anacapa-output", "data", "demo_taxonTable.Rds", package = "ranacapa"))
metDat <- readRDS(system.file("explore-anacapa-output", "data", "demo_metadata.Rds", package = "ranacapa"))
psobj <- convert_anacapa_to_phyloseq(taxDat, metDat)

# Figure 1: Rarefying/Sp accumulation curve --------
psobj <- subset_samples(psobj, subset = (Sample != "PCR_blank_3"))
psobj <- subset_samples(psobj, subset = (Sample != "PCR_blank_4"))
fig1 <- ggrare(psobj, step = 1000, se = FALSE, color = "Sample") + 
  theme_ranacapa()
fig1 <- ggplotly(fig1, tooltip = c("Sample"))

# Figure 2: Taxonomy heatmap ----------

tax_table <- data.frame(otu_table(psobj))
tax_table <- cbind(tax_table, colsplit(rownames(tax_table), ";",
                             names = c("Phylum", "Class", "Order", "Family", "Genus", "Species")))
   
tax_table <- tax_table %>%
  mutate(Phylum = ifelse(is.na(Phylum) | Phylum == "", "unknown", Phylum)) %>%
  mutate(Class = ifelse(is.na(Class) | Class == "", "unknown", Class)) %>%
  mutate(Order = ifelse(is.na(Order) | Order == "", "unknown", Order)) %>%
  mutate(Family = ifelse(is.na(Family) | Family == "", "unknown", Family)) %>%
  mutate(Genus = ifelse(is.na(Genus) | Genus == "", "unknown", Genus)) %>%
  mutate(Species = ifelse(is.na(Species)| Species == "", "unknown", Species))


tax_table <- tax_table %>%
  group_by(Class) %>%
  # group_by(Species) %>%
  summarize_if(is.numeric, sum) %>%
  data.frame %>%
  column_to_rownames("Class")
# column_to_rownames("Species")
tax_table <- tax_table[which(rowSums(tax_table) > 0),]
tax_table[tax_table == 0] <- NA
tax_table

fig2 <- heatmaply(tax_table, Rowv = F, Colv = F, hide_colorbar = F,
          grid_gap = 1, na.value = "white", key.title = "Number of \nSequences in \nSample")

# Figure 3: Taxonomy barplot ---------

psobj_glommed <- tax_glom(psobj, "Order")
fig3 <- plot_bar(psobj_glommed, fill = "Order") + theme_ranacapa() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(axis.title = element_blank())

fig3 <- ggplotly() %>%
  layout(yaxis = list(title = "Abundance", titlefont = list(size = 16)),
         xaxis = list(title = "Sample", titlefont = list(size = 16)),
         margin = list(l = 70, b = 100)) 

# Figure 4: Alpha diversity plots --------
psobj_island <- subset_samples(psobj, !is.na(Island))
plot_richness(psobj_island, measures = "Shannon", color = "Island", x = "Island") + 
  theme_ranacapa() +
  geom_boxplot(aes_string(fill = "Island", alpha = 0.2)) + 
  theme(legend.position = "none") +
  theme(axis.title = element_blank()) +
  theme(axis.text.x = element_text(angle = 45))
fig4 <- ggplotly(tooltip = c("x", "value")) %>%
  layout(yaxis = list(title = paste("Shannon Diversity"), titlefont = list(size = 16)),
         xaxis = list(title = "Island", titlefont = list(size = 16)),
         margin = list(l = 60, b = 70))
  
# Figure 5: Beta diversity plots -------

d <- distance(psobj_island, method= "jaccard")
ord <- ordinate(psobj_island, method = "MDS", distance = d)
nmdsplot <- plot_ordination(psobj_island, ord,
                            color = "Island", shape = "Island") +
  ggtitle(paste("Island PCoA; dissimilarity method:",
                tools::toTitleCase("Jaccard dissimilarity"))) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme_ranacapa()
fig5 <- ggplotly(tooltip = c("Island", "x", "y")) %>%
  layout(hovermode = 'closest')

save.image(file = "make-figures.Rdata")
