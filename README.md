# EukProt

[![License](https://img.shields.io/badge/license-GPLv3-blue.svg)](http://www.gnu.org/licenses/gpl.html)

EukProt is a database of published and publicly available predicted protein sets and unannotated genomes selected to represent eukaryotic diversity, including 742 species from all major supergroups as well as orphan taxa. The goal of the database is to provide a single, convenient resource for studies in phylogenomics, gene family evolution, and other gene-based research across the spectrum of eukaryotic life. Each species is placed within the [UniEuk](https://unieuk.org/) taxonomic framework in order to facilitate downstream analyses, and each data set is associated with a unique, persistent identifier to facilitate comparison and replication among analyses. The database is currently in version 2, and all versions will be permanently stored and made available via FigShare. We invite the community to provide suggestions for new data sets and new annotation features to be included in subsequent versions, with the goal of building a collaborative resource that will promote research to understand eukaryotic diversity and diversification.

Database (FigShare) DOI: [10.6084/m9.figshare.12417881.v2](https://doi.org/10.6084/m9.figshare.12417881.v2)

Description (bioRxiv) DOI: [10.1101/2020.06.30.180687](https://doi.org/10.1101/2020.06.30.180687)

## Perl scripts

- **add_EukProt_IDs_to_FASTAs.pl** : modify the headers of a directory of FASTA files, by adding a EukProt record ID as the first item after the initial ">", followed by a space. The record identifier is formatted as follows: [EukProt ID]_[Genus_species]_[Data set type abbreviation][Counter, starting with 000001]
- **taxonomy_to_tree_iTOL.pl** : create a tree for input to iTOL based on the taxonomic relationships among species, and create an iTOL input data file representing the counts of each type of data set (Genome, Single-cell genome, Transcriptome, EST, Single-cell transcriptome) for each leaf of the tree.

## Tree and tree-related files (input to and output from [iTOL](https://itol.embl.de))

Input to taxonomy_to_tree_iTOL.pl:
- **taxonomic_lineages_by_data_set.v02.2020_03_27.txt** : for each data set in EukProt, its data source type (genome, single-cell genome, transcriptome, EST or single-cell transcriptome) and its taxonomic lineage to be used for display in the iTOL tree (the lowest taxonomic level listed will become a leaf in the tree). Note that some taxonomic entities that are not in UniEuk have been added to the tree for display purposes.

Input to iTOL:
- **input_tree.v02.2020_03_27.tree** : input tree to iTOL, in Newick format, with internal nodes labeled.
- **data_set_counts_by_type.v02.2020_03_27.txt** : data file for iTOL, with counts of data sets by source type, for each leaf in the tree.
- **clade_colors.v02.2020_03_27.txt** : data file for iTOL, with colors to be used for different clades in the tree.
- **clade_labels.v02.2020_03_27.txt** : data file for iTOL, with labels to be used for different clades in the tree.

Output from iTOL (with cosmetic changes for display purposes):
- **EukProt_figure_1.v02.2020_03_27.svg** : final tree in Figure 1 (Inkscape SVG format).
- **EukProt_figure_1.v02.2020_03_27.pdf** : final tree in Figure 1 (PDF format).
