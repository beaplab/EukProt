#!/usr/bin/env perl

use warnings;
use strict;

# in order to search for modules in the directory where this script is located
use File::Basename;
use Cwd;
use lib dirname (&Cwd::abs_path(__FILE__));

# modules in this distribution
use GetOptions;
use Constants qw ($DIRECTORY_DELIMITER $FASTA_EXTENSION %FASTA_FILE_DATA_TYPES $TAB_DELIMITED_TEXT_EXTENSION);

# names of command line options
my $HELP_OPTION = 'help';
my $INPUT_OPTION = 'input';
my $OUTPUT_OPTION = 'output';
my $TYPE_OPTION = 'type';
my $MAPPING_OPTION = 'mapping';
my $EXTENSION_OPTION = 'extension';
my $FORCE_OPTION = 'force';

# types for command line options; see 'Getopt::Long' Perl documentation for information on option types
my %OPTION_TYPES = ($HELP_OPTION => '',
		    $INPUT_OPTION => '=s',
		    $OUTPUT_OPTION => '=s',
		    $TYPE_OPTION => '=s',
		    $MAPPING_OPTION => '=s',
		    $EXTENSION_OPTION => '=s',
		    $FORCE_OPTION => '!');

sub main 
{
    my %args = &GetOptions::get_options(\%OPTION_TYPES);

    if ($args{$HELP_OPTION} || (not ($args{$INPUT_OPTION} && $args{$OUTPUT_OPTION} && $args{$TYPE_OPTION})))
    {
	&help();
	exit;
    }
    
    my $extension_to_use = $args{$EXTENSION_OPTION} || $FASTA_EXTENSION;

    # check that input and output directories exist
    foreach my $directory_option ($INPUT_OPTION, $OUTPUT_OPTION, $MAPPING_OPTION)
    {
	if ($args{$directory_option} && (not -d $args{$directory_option}))
	{
	    die "ERROR: supplied value of '-$directory_option', '$args{$directory_option}', is not a directory";
	}
    }

    # verify that the specified data type is allowed
    if (not defined $FASTA_FILE_DATA_TYPES{$args{$TYPE_OPTION}})
    {
	die "ERROR: supplied value of '-$TYPE_OPTION', '$args{$TYPE_OPTION}' is not allowed";
    }

    # retrieve the list of files in the input directory
    opendir(INPUT_DIR, $args{$INPUT_OPTION}) || die "ERROR: could not open directory '$args{$INPUT_OPTION}' for read";

    my @filenames = readdir(INPUT_DIR);
    
    closedir INPUT_DIR || die "ERROR: could not close directory '$args{$INPUT_OPTION}' after read";

    # process files in sorted order (case insensitive), to make it easy to follow progress
    foreach my $filename (sort { lc($a) cmp lc($b) } @filenames)
    {
	# only process files with the appropriate extension
	if ($filename =~ /(.*?)\Q$extension_to_use\E$/o)
	{
	    my $input_file_basename = $1;

	    print STDOUT "--- $input_file_basename ---\n";

	    my $id_counter = 1;
	    
	    my $input_fasta_path = $args{$INPUT_OPTION} . $DIRECTORY_DELIMITER . $filename;
	    my $output_fasta_path = $args{$OUTPUT_OPTION} . $DIRECTORY_DELIMITER . $filename;
	    my $output_mapping_path = ($args{$MAPPING_OPTION} || "") . $DIRECTORY_DELIMITER . $input_file_basename .
		$TAB_DELIMITED_TEXT_EXTENSION;

	    # check if output files exist, and only overwrite them if '-$FORCE_OPTION' is specified; otherwise, skip
	    if (-e $output_fasta_path && (not -z $output_fasta_path))
	    {
		if ($args{$FORCE_OPTION})
		{
		    print STDOUT "Output FASTA file '$output_fasta_path' already exists, overwriting.\n";
		}
		else
		{
		    print STDOUT "WARNING: Output FASTA file '$output_fasta_path' already exists, skipping.\n";

		    next;
		}
	    }
	    
	    if ($args{$MAPPING_OPTION} && -e $output_mapping_path && (not -z $output_mapping_path))
	    {
		if ($args{$FORCE_OPTION})
		{
		    print STDOUT "Output mapping file '$output_mapping_path' already exists, overwriting.\n";
		}
		else
		{
		    print STDOUT "WARNING: Output mapping file '$output_mapping_path' already exists, skipping.\n";

		    next;
		}
	    }
	    
	    open(INPUT, $input_fasta_path) || die "ERROR: could not open file '$input_fasta_path' for read";
	    open(OUTPUT, ">", $output_fasta_path) || die "ERROR: could not open file '$output_fasta_path' for write";

	    # if a mapping file was requested, open it for write and print out a header
	    if ($args{$MAPPING_OPTION})
	    {
		open(MAPPING, ">", $output_mapping_path) || die "ERROR: could not open file '$output_mapping_path' for write";

		print MAPPING join("\t", ("EukProt_Record_ID", "Previous_Record_ID")) . "\n";
	    }

	    # read through the input FASTA file, prepending the new EukProt identifier to each FASTA header
	    while (<INPUT>)
	    {
		if (/^>(.*)/)
		{
		    chomp;
		    
		    my $new_id = $input_file_basename . "_" . $FASTA_FILE_DATA_TYPES{$args{$TYPE_OPTION}} .
			sprintf("%06d", $id_counter);
		    
		    print OUTPUT ">" . $new_id . " " . $1 . "\n";

		    # if a mapping file was requested, print out a tab-delimited file linking the new identifier to
		    # the previous identifier (which is simply all characters up to the first space)
		    if ($args{$MAPPING_OPTION})
		    {
			my ($previous_id, undef) = split(/\s/, $1);

			print MAPPING join("\t", ($new_id, $previous_id)) . "\n";
		    }

		    $id_counter++;
		}
		else
		{
		    print OUTPUT $_;
		}
	    }
	    
	    close INPUT || die "ERROR: could not close file '$input_fasta_path' after read";
	    close OUTPUT || die "ERROR: could not close file '$output_fasta_path' after write";

	    if ($args{$MAPPING_OPTION})
	    {
		close MAPPING || die "ERROR: could not close file '$output_mapping_path' after write";
	    }
	}
    }
}

sub help
{
    my $TYPES_AND_ABBREVIATIONS = "";

    foreach my $data_type (keys %FASTA_FILE_DATA_TYPES)
    {
	$TYPES_AND_ABBREVIATIONS .= join("\t", ($FASTA_FILE_DATA_TYPES{$data_type}, $data_type)) . "\n";
    }
    
    my $HELP = <<HELP;
Syntax: $0 -$INPUT_OPTION <dir> -$OUTPUT_OPTION <dir> -$TYPE_OPTION <type> [-$MAPPING_OPTION <dir>] [-$EXTENSION_OPTION <ext>] [-$FORCE_OPTION]

Modify the headers of a directory of FASTA files, by adding a EukProt
record ID as the first item after the initial ">", followed by a
space.

The record identifier is formatted as follows:

[EukProt ID]_[Genus_species]_[Data set type abbreviation][Counter, starting with 000001]

Because the naming scheme for FASTA files is [EukProt ID]_[Genus_species]$FASTA_EXTENSION,
the first part of the identifier will be taken directly from the file name.

Allowed types (and their one-letter abbreviations) are:
$TYPES_AND_ABBREVIATIONS    
    -$HELP_OPTION : print this message
    -$INPUT_OPTION : input directory of FASTA files
    -$OUTPUT_OPTION : output directory of FASTA files
    -$TYPE_OPTION : type of data contained in the FASTA files (only one type is allowed per
            directory)
    -$MAPPING_OPTION : optional output directory for tab-delimited text files (one per input
               file) containing mapping of the identifiers from each input FASTA header
               (considered as all text up to the first space character, if any) to their
               new EukProt identifier
    -$EXTENSION_OPTION : extension for input files (default $FASTA_EXTENSION)
    -$FORCE_OPTION : overwrite output files if they already exist (default skip existing files)

HELP

    print STDERR $HELP;
}

&main();
