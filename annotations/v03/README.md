# EukProt v3 Annotations

## Files hosted on the EukProt GitHub

- **BUSCO_v5.2.2_eukaryota_odb10.EukProt_v03.2021_11_22.txt** : results of running BUSCO v5.2.2 with the eukaryota_odb10 database on all protein files from EukProt.

- **The_Comparative_Set_196_species.EukProt_v03.2021_11_22.txt** : list of protein files included in The Comparative Set (TCS).

## Files hosted elsewhere

- **OrthoFinder2 orthogroups inferred from The Comparative Set** (on [FigShare](https://doi.org/10.6084/m9.figshare.24680481), contributed by Chung Hyun Cho) : the construction of orthologous gene clusters, referred to as orthogroups, was carried out for The Comparative Set (TCS), which encompasses [a total of 196 eukaryotic species](https://doi.org/10.24072/pcjournal.173). The clustering of genes in a non-biased manner was performed using [Orthofinder v2.5.2](https://doi.org/10.1186/s13059-019-1832-y), wherein each gene was compared to a comprehensive proteome dataset consisting of over five million proteins. Following the experimentation with various parameters, the [DIAMOND algorithm](https://doi.org/10.1038/nmeth.3176) was selected for conducting homology searches using the '-S diamond_ultra_sens' option.

- **Pfam v34.0 protein domain annotations** (on [FigShare](https://doi.org/10.6084/m9.figshare.24680811), contributed by Alex Gàlvez-Morante): Pfam domains predicted on all EukProt v3 datasets (one output file per dataset). Domains were predicted with [InterProScan version 5.56](https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.56-89.0/) and [InterPro version 89.0](https://www.ebi.ac.uk/interpro/release_notes/89.0/) (which includes the Pfam database version 34.0; note that this is no longer the most recent version of Pfam), with default parameter values.
