library(ranacapa)
library(plotly)
library(phyloseq)
library(tidyverse)
library(reshape2)
library(heatmaply)
library(biomformat)
taxDat <- readRDS(system.file("explore-anacapa-output", "data", "demo_taxonTable.Rds", package = "ranacapa"))
metDat <- readRDS(system.file("explore-anacapa-output", "data", "demo_metadata.Rds", package = "ranacapa"))
psobj <- convert_anacapa_to_phyloseq(taxDat, metDat)

# Figure 1: Rarefying/Sp accumulation curve --------
psobj <- subset_samples(psobj, subset = (Sample != "PCR_blank_3"))
psobj <- subset_samples(psobj, subset = (Sample != "PCR_blank_4"))
fig1_static <- ggrare(psobj, step = 1000, se = FALSE, color = "Sample") + 
  theme_ranacapa() + 
  ylab("Sample richness")
fig1 <- ggplotly(fig1_static, tooltip = c("Sample"))
fig1_static <- fig1_static + 
  theme(legend.position = "none") + 
  ggtitle("Taxon accumulation curve",
          subtitle = "Users see individual sample's curves and can choose rarefying depth in the Shiny app")
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
fig3_static <- plot_bar(psobj_glommed, fill = "Order") + 
  theme_ranacapa() + 
  theme(axis.text.x = (element_text(angle = 45, hjust = 1)))

fig3 <- ggplotly(fig3_static) +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(axis.title = element_blank())  %>%
  layout(yaxis = list(title = "Abundance", titlefont = list(size = 16)),
         xaxis = list(title = "Sample", titlefont = list(size = 16)),
         margin = list(l = 70, b = 100)) 
fig3_static <- fig3_static + 
  theme(legend.position = 'none') + 
  ggtitle("Taxonomy barplot at the Order level", 
          subtitle = "Users can choose taxonomy level in the Shiny app and can hover over bars to identify the identity")
# Figure 4: Alpha diversity plots --------
psobj_island <- subset_samples(psobj, !is.na(Island))
fig4_static <- plot_richness(psobj_island, measures = "Shannon", color = "Island", x = "Island") + 
  theme_ranacapa() +
  ylab("") + 
  geom_boxplot(aes_string(fill = "Island", alpha = 0.2)) + 
  theme(legend.position = "none") +
  # theme(axis.title = element_blank()) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  ggtitle("Shannon Diversity at each island",
          subtitle = "Users can choose the metadata column to group samples by in the Shiny app")
fig4 <- ggplotly(fig4_static, tooltip = c("x", "value")) %>%
  layout(yaxis = list(title = paste("Shannon Diversity"), titlefont = list(size = 16)),
         xaxis = list(title = "Island", titlefont = list(size = 16)),
         margin = list(l = 60, b = 70))
fig4_static <- fig4_static + 
  ylab("Shannon Diversity")
# Figure 5: Beta diversity plots -------

d <- distance(psobj_island, method= "jaccard")
ord <- ordinate(psobj_island, method = "MDS", distance = d)
fig5_static <- plot_ordination(psobj_island, ord,
                            color = "Island", shape = "Island") +
  ggtitle(paste("Island PCoA; dissimilarity method: Jaccard dissimilarity"),
          subtitle = "Users can choose the metadata column to group samples by in the Shiny app") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme_ranacapa()
fig5 <- ggplotly(fig5_static, tooltip = c("Island", "x", "y")) %>%
  layout(hovermode = 'closest')

fig1 <- config(fig1, showLink=TRUE)
fig2 <- config(fig2, showLink=TRUE)
fig3 <- config(fig3, showLink=TRUE)
fig4 <- config(fig4, showLink=TRUE)
fig5 <- config(fig5, showLink=TRUE)

# ----------
# Save interactive plots
htmlwidgets::saveWidget(fig1, file = file.path(getwd(), "figure-files", "fig1.html"), selfcontained = T)
htmlwidgets::saveWidget(fig2, file = file.path(getwd(), "figure-files", "fig2.html"), selfcontained = T)
htmlwidgets::saveWidget(fig3, file = file.path(getwd(), "figure-files", "fig3.html"), selfcontained = T)
htmlwidgets::saveWidget(fig4, file = file.path(getwd(), "figure-files", "fig4.html"), selfcontained = T)
htmlwidgets::saveWidget(fig5, file = file.path(getwd(), "figure-files", "fig5.html"), selfcontained = T)

# Save static plots for pdf version 
ggsave(filename = "Kandlikar-etal-figures-static/fig1.tiff",
       fig1_static, dpi = 600)
ggsave(filename = "Kandlikar-etal-figures-static/fig3.tiff",
       fig3_static, dpi = 600)
ggsave(filename = "Kandlikar-etal-figures-static/fig4.tiff",
       fig4_static, dpi = 600)
ggsave(filename = "Kandlikar-etal-figures-static/fig5.tiff",
       fig5_static, dpi = 600)

# Have to do some messy stuff to save static version of heatmap...
tax_table_m <- as.matrix(tax_table)
bitmap(file = "Kandlikar-etal-figures-static/fig2.tiff", res=600, height=15, width=18, 
       units='in', pointsize=20)
gplots::heatmap.2(tax_table_m[1:20,], Rowv = F, Colv = F, scale = "none", trace = "none" ,
                  col = viridis(n=256, alpha = 1, begin = 0, end = 1, option = "viridis"), 
                  key.title =  "Number of Sequences\nin Sample", keysize = .75, key.xlab = NA,
                  key.ylab = NA, srtCol = 45, margins = c(9,9), colsep = 1:ncol(tax_table_m),
                  main = "Taxonomy heatmap (first 20 orders shown)\nusers can hover over cells to find information in Shiny app")
dev.off() 
              
save.image(file = "make-figures.Rdata")
