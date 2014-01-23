Important file dependencies are as follows
- onall.script: batch processing file, gives makeclusters.sh to various nodes
- - makeclusters.sh: perturbs data, clusters it, cuts tree into clustering.
- - - perturb.py: given .jplace files, produces perturbed .jplace files
- - - clusters.R: applies various clustering methods and cuts them,
- - - ... producing many clusterings
- - graphs.R: Calculate rand Index between clusterings and metrics for each gene
- - ... with good coverage

Ancillary Scripts
- lineage.sh
- - Inspects some values for several genes, as produced by a program called
- - ... lineage for subsequent analysis.  Does not interface with other scripts
- - ... in this directory.
- grab_taxmaps.sh
- - Counts convex taxa and total taxa in the tree for 
- ave_buckets.R
- - Produces graphs of data where points along the X-axis are bucketed and
- - ... their average value is placed on the Y axis as a point
- branchlength.R
- - Calculates the total sum of branch lengths of each gene phylogenetic tree
- - ... for subsequent analysis
- calc_fpd.sh
- - Calcualtes phylogenetic diversity for later analysis
- compare.R
- - Compares the clustering result from the original paper with results
- - ... produced by clustering COGs.  No substitute for 16S was found
- grab_taxmaps.sh
- - Measures convex taxa at phylum level and total taxa for later analysis
- cuttable.R
- - function to supply a non-ultrametric dendrogram with a merge order so that
- - ... it can be cut with the R cutree function

Data files
- genes_coverage
- - A list of the 280 genes with hits for all 111 microbiome samples
- gene_convexities.csv
- - Output from grab_taxmaps.sh; Tree convexity at phylum level uses column 2
- - ... divided by column 3
- Human-Microbiome-Metadata.csv
- - Metadata for the original Human Microbiome metagenome.  Each row specifies
- - ... a unique human sample and information about that sample, such as country
- - ... of origin, sex, etc.
- gene_stats.csv
- - The conglomeration of various metrics for the 280 genes with good coverage
- gut_pairwise_identities.csv
- - The pairwise percent identity for the genes with good coverage, produced by
- - ... the Geneious software program.
