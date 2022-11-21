# EukProt v3

[![License](https://img.shields.io/badge/license-GPLv3-blue.svg)](http://www.gnu.org/licenses/gpl.html) [![DOI](https://zenodo.org/badge/284257207.svg)](https://zenodo.org/badge/latestdoi/284257207)

![Tree representing relationships among data sets and counts by type](/iTOL/v03/EukProt_figure_1.v03.2021_11_22.png)

EukProt is a database of published and publicly available predicted protein sets selected to represent the breadth of eukaryotic diversity, currently including 993 species from all major supergroups as well as orphan taxa. The goal of the database is to provide a single, convenient resource for gene-based research across the spectrum of eukaryotic life, such as phylogenomics and gene family evolution. Each species is placed within the [UniEuk taxonomic framework](https://unieuk.org/) in order to facilitate downstream analyses, and each data set is associated with a unique, persistent identifier to facilitate comparison and replication among analyses. The database is regularly updated, and all versions will be permanently stored and made available via FigShare. The current version has a number of updates, notably The Comparative Set (TCS), a reduced taxonomic set with high estimated completeness while maintaining a substantial phylogenetic breadth, which comprises 196 predicted proteomes. A BLAST web server and graphical displays of data set completeness are available at [http://evocellbio.com/eukprot/](http://evocellbio.com/eukprot/). We invite the community to provide suggestions for new data sets and new annotation features to be included in subsequent versions, with the goal of building a collaborative resource that will promote research to understand eukaryotic diversity and diversification.

Database (FigShare) DOI: [10.6084/m9.figshare.12417881.v3](https://doi.org/10.6084/m9.figshare.12417881.v3)

Description (Peer Community Journal) DOI: [10.24072/pcjournal.173](https://doi.org/10.24072/pcjournal.173)

BLAST database, interactive plots of BUSCO scores and 'The Comparative Set' (TCS): A selected subset of EukProt for comparative genomics investigations are available at: [evocellbio, the Wideman Lab](http://evocellbio.com/eukprot/). Protein sequence FASTA files of the TCS are available at DOI: [10.6084/m9.figshare.21586065](https://doi.org/10.6084/m9.figshare.21586065)

## Perl scripts

Note: these scripts depend on the Perl modules (filenames ending in .pm), which should be in the same directory as the script files.

- **add_EukProt_IDs_to_FASTAs_and_clean.pl** : modify the headers of a directory of FASTA files, by adding a EukProt record ID as the first item after the initial ">", followed by a space. The record identifier is formatted as follows: [EukProt ID]\_[Genus_species]\_[Data set type abbreviation][Counter, starting with 000001]. Clean illegal characters from sequences. The following characters are permitted, as defined by [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=BlastHelp) for nucleic acid sequences: ``ACGTNUKSYMWRBDHV`` and for protein sequences: ``ABCDEFGHIKLMNPQRSTUVWYZX*``.
- **taxonomy_to_tree_iTOL.pl** : create a tree for input to iTOL based on the taxonomic relationships among species, and create an iTOL input data file representing the counts of each type of data set (Genome, Single-cell genome, Transcriptome, EST, Single-cell transcriptome) for each leaf of the tree.

## Tree and tree-related files (input to and output from [iTOL](https://itol.embl.de))

Input to taxonomy_to_tree_iTOL.pl:
- **taxonomic_lineages_by_data_set.[version].txt** : for each data set in EukProt, its data source type (genome, single-cell genome, transcriptome, EST or single-cell transcriptome) and its taxonomic lineage to be used for display in the iTOL Figure 1 tree (the lowest taxonomic level listed will become a leaf in the tree). Note that some taxonomic entities that are not in UniEuk have been added to the tree for display purposes.

Input to iTOL:
- **input_tree.[figure].[version].tree** : input trees to iTOL, in Newick format, with internal nodes labeled.
- **clade_labels.[figure].[version].txt** : data files for iTOL, with labels to be used for different clades in the tree.
- **clade_colors.[version].txt** : data file for iTOL, with colors to be used for different clades in the tree.
- **data_set_counts_by_type.[version].txt** : data file for iTOL, with counts of data sets by source type, for each leaf in the tree in Figure 1.

Output from iTOL (with cosmetic changes for display purposes):
- **EukProt_[figure].[version].svg** : final tree in Figures 1 and 3 (Inkscape SVG format).
- **EukProt_[figure].[version].pdf** : final tree in Figures 1 and 3 (PDF format).
- **EukProt_[figure].[version].png** : final tree in Figures 1 and 3 (PNG format, 100 dpi).

## Annotations

Annotations, which can be updated as new analyses are performed (i.e., both accompanying and in between full database releases). File names indicate analysis type (and software/database version, if applicable).
