#!/usr/bin/env perl

use warnings;
use strict;

# in order to search for modules in the directory where this script is located
use File::Basename;
use Cwd;
use lib dirname (&Cwd::abs_path(__FILE__));

# modules in this distribution
use GetOptions;
use Constants qw ($TAXONOMIC_LINEAGE_DELIMITER @ITOL_DATA_TYPES);

# names of command line options
my $HELP_OPTION = 'help';
my $INPUT_OPTION = 'input';
my $OUTPUT_OPTION = 'output';
my $COUNTS_OPTION = 'counts';

# types for command line options; see 'Getopt::Long' Perl documentation for information on option types
my %OPTION_TYPES = ($HELP_OPTION => '',
		    $INPUT_OPTION => '=s',
		    $OUTPUT_OPTION => '=s',
		    $COUNTS_OPTION => '=s');

my @ITOL_DATA_TYPES_TO_PRINT = ();
my %DATA_TYPES = ();

# create a list of data types where the first letter is capitalized, for the output data file in '-$COUNTS_OPTION'
foreach my $data_type (@ITOL_DATA_TYPES)
{
    push(@ITOL_DATA_TYPES_TO_PRINT, ucfirst($data_type));
}

# create a hash for conveniently checking whether data types in the put file are permitted
foreach my $data_type (@ITOL_DATA_TYPES)
{
    $DATA_TYPES{$data_type} = 1;
}

sub main 
{
    my %args = &GetOptions::get_options(\%OPTION_TYPES);

    if ($args{$HELP_OPTION} || (not ($args{$INPUT_OPTION} && $args{$OUTPUT_OPTION} && $args{$COUNTS_OPTION})))
    {
	&help();
	exit;
    }

    open(INPUT, $args{$INPUT_OPTION}) || die "ERROR: could not open file '$args{$INPUT_OPTION}' for read";
    open(OUTPUT, ">", $args{$OUTPUT_OPTION}) || die "ERROR: could not open file '$args{$OUTPUT_OPTION}' for write";

    # the order of the columns is specified in the help message, so simply read the header line without checking
    # its contents
    my $header = <INPUT>;
    
    # hash structure that will store the lineage information for the species in this fasta file
    my %lineages = ();

    my %counts = ();
    
    while (<INPUT>)
    {
	chomp;

	my ($EukProt_ID, $data_type, $lineage_to_print) = split("\t");

	if (not defined $DATA_TYPES{$data_type})
	{
	    die "ERROR: data type '$data_type' not allowed";
	}
	
	if (not defined $counts{$lineage_to_print})
	{
	    my @lineage_to_print = split($TAXONOMIC_LINEAGE_DELIMITER, $lineage_to_print);
	    
	    &build_lineage_hash_structure(\%lineages, \@lineage_to_print);

	    foreach my $data_type (@ITOL_DATA_TYPES)
	    {
		$counts{$lineage_to_print}->{$data_type} = 0;
	    }
	}

	$counts{$lineage_to_print}->{$data_type}++;
    }

    # convert the set of collected taxonomic lineages to an output tree string
    print OUTPUT join(",", &lineage_hash_to_tree(\%lineages, "", 1)) . ";\n";

    close INPUT || die "ERROR: could not close file '$args{$INPUT_OPTION}' after read";
    close OUTPUT || die "ERROR: could not close file '$args{$OUTPUT_OPTION}' after write";

    # print the counts of data types to an iTOL-formatted text file
    open(COUNTS, ">", $args{$COUNTS_OPTION}) || die "ERROR: could not open file '$args{$COUNTS_OPTION}' for write";

    print COUNTS "DATASET_MULTIBAR\n";
    print COUNTS "SEPARATOR COMMA\n";
    print COUNTS "DATASET_LABEL,taxon_counts\n";
    print COUNTS "COLOR,#ff0000\n";
    print COUNTS "FIELD_COLORS,#1f78b4,#a6cee3,#006d2c,#74c476,#e5f5e0\n";
    print COUNTS "FIELD_LABELS," . join(",", @ITOL_DATA_TYPES_TO_PRINT) . "\n";

    print COUNTS "LEGEND_TITLE,Data sources\n";
    print COUNTS "LEGEND_SHAPES,1,1,1,1,1\n";
    print COUNTS "LEGEND_COLORS,#1f78b4,#a6cee3,#006d2c,#74c476,#e5f5e0\n";
    print COUNTS "LEGEND_LABELS," . join(",", @ITOL_DATA_TYPES_TO_PRINT) . "\n";

    print COUNTS "DATASET_SCALE,0-0-#bdbdbd-1-1-2,5-5-#bdbdbd-1-1-2,10-10-#bdbdbd-1-1-2,15-15-#bdbdbd-1-1-2,20-20-#bdbdbd-1-1-2,25-25-#bdbdbd-1-1-2\n";

    print COUNTS "BORDER_WIDTH,0.5\n";
    print COUNTS "BORDER_COLOR,#bdbdbd\n";
    
    print COUNTS "DATA\n";
    
    foreach my $lineage_to_print (sort { lc($a) cmp lc($b) } keys %counts)
    {
	my @nodes = split($TAXONOMIC_LINEAGE_DELIMITER, $lineage_to_print);

	my $leaf_name = pop @nodes;
	
	print COUNTS $leaf_name;

	foreach my $data_type (@ITOL_DATA_TYPES)
	{
	    print COUNTS "," . $counts{$lineage_to_print}->{$data_type};
	}

	print COUNTS "\n";
    }
    
    close COUNTS || die "ERROR: could not close file '$args{$COUNTS_OPTION}' after write";
}

# add a lineage in list format to a hash structure representing a taxonomy
sub build_lineage_hash_structure
{
    # the first argument is a hash reference within the data structure
    
    # the second argument is a reference to list representing the lineage
    my $lineage_list = $_[1];

    my $taxon_name = shift @$lineage_list;

    # if there are no more names in the lineage, use a scalar value to save this as a leaf element
    if (not defined $taxon_name)
    {
	return $_[0] = 1;
    }
    # otherwise, create a key for the current hash reference and recurse on the remainder of the list
    else
    {
	&build_lineage_hash_structure($_[0]->{$taxon_name}, $lineage_list);
    }
}

# input a hash structure with lineage information from a taxonomy, and output a list in Newick tree format
sub lineage_hash_to_tree
{
    my ($lineages, $carried_name, $include_internal_names) = @_;
    
    my @subtree = ();
    
    foreach my $taxon_name (sort keys %$lineages)
    {
	# if the current node is a reference, it is internal, so recurse to its children, adding their subtrees
	if (ref($lineages->{$taxon_name}))
	{
	    my $node_name_to_add = "";

	    # only if internal node names are requested
	    if ($include_internal_names)
	    {
		# name carried over from a parent with only one child (which does not result in a node in the output tree)
		if ($carried_name)
		{
		    $node_name_to_add = $carried_name . $TAXONOMIC_LINEAGE_DELIMITER . $taxon_name;
		}
		else
		{
		    $node_name_to_add = $taxon_name;
		}
	    }
	    
	    # if this internal node has more than one child, create a new node in the output tree, and recurse
	    # to its children
	    if (scalar(keys %{$lineages->{$taxon_name}}) > 1)
	    {
		push(@subtree, "(" . join(",", &lineage_hash_to_tree($lineages->{$taxon_name}, "", $include_internal_names)) .
		     ")$node_name_to_add");
	    }
	    # if this is an internal node with only one child, it should not be a node in the output tree; instead
	    # add its name to the eventual internal node name of the first child which has more than one child
	    else
	    {
		push(@subtree, &lineage_hash_to_tree($lineages->{$taxon_name}, $node_name_to_add, $include_internal_names));
	    }
	}
	# otherwise, this is a leaf, so simply add its name
	else
	{
	    push(@subtree, $taxon_name);
	}
    }
    
    return @subtree;
}

sub help
{
    my $TYPES_TO_PRINT = join(", ", @ITOL_DATA_TYPES);
    
    my $HELP = <<HELP;
Syntax: $0 -$INPUT_OPTION <txt> -$OUTPUT_OPTION <tree> -$COUNTS_OPTION <txt>

Create a tree (for input to iTOL) based on the taxonomic relationships
among species. Also output the counts of each type of data set for
each leaf of the tree. Types are:

$TYPES_TO_PRINT

Format of '-$INPUT_OPTION' file: one header line. First column is
EukProt ID, second column is the data source type, third column is the
subset of its full lineage to be represented in the tree. The
lowest-level taxonomic entities from each taxonomic lineage will
become leaves of the tree.

Ranks in taxonomic lineage are delimited by "$TAXONOMIC_LINEAGE_DELIMITER". 

    -$HELP_OPTION : print this message
    -$INPUT_OPTION : input taxonomy file, one taxon per line
    -$OUTPUT_OPTION : output tree (Newick format)
    -$COUNTS_OPTION : output iTOL-formatted text file with data source type counts per leaf
   
HELP

    print STDERR $HELP;
}

&main();
