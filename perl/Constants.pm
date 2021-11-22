package Constants;

require Exporter;
@ISA = ("Exporter");

###
# Values of constants to be exported

# constants related to taxonomic lineages
$TAXONOMIC_LINEAGE_DELIMITER = ";";

# constants related to data types
@ITOL_DATA_TYPES = ("genome", "single-cell genome", "transcriptome", "EST", "single-cell transcriptome");

# operating system related constants
$DIRECTORY_DELIMITER = "/";

# file extensions
$FASTA_EXTENSION = ".fasta";
$TAB_DELIMITED_TEXT_EXTENSION = ".txt";

# from https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=BlastHelp
$ALLOWED_NUCLEIC_ACID_CODES = "ACGTNUKSYMWRBDHV";
$ALLOWED_AMINO_ACID_CODES = "ABCDEFGHIKLMNPQRSTUVWYZX*";

# one-letter labels for FASTA files containing different data types
%FASTA_FILE_DATA_TYPES = ("genome" => "G",
			  "transcriptome" => "T",
			  "protein" => "P");

%FASTA_FILE_ALLOWED_CODES = ("genome" => $ALLOWED_NUCLEIC_ACID_CODES,
			     "transcriptome" => $ALLOWED_NUCLEIC_ACID_CODES,
			     "protein" => $ALLOWED_AMINO_ACID_CODES);
###

###
# List of constants to be exported
@EXPORT_OK = qw($TAXONOMIC_LINEAGE_DELIMITER @ITOL_DATA_TYPES
                $DIRECTORY_DELIMITER $FASTA_EXTENSION %FASTA_FILE_DATA_TYPES $TAB_DELIMITED_TEXT_EXTENSION
                $ALLOWED_NUCLEIC_ACID_CODES $ALLOWED_AMINO_ACID_CODES %FASTA_FILE_ALLOWED_CODES
                );
###

1;
