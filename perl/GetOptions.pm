package GetOptions;

###
# This package contains a subroutine to retrieve command line options
# into a hash keyed by the option name.
#
# Example of how to use:
# 
# use GetOptions;
# 
# my $HELP_OPTION = 'help';
# my $FILE_OPTION = 'file';
# my %OPTION_TYPES = ($HELP_OPTION => '!',
# 		      $FILE_OPTION => '=s');
# my %args = 
#     &GetOptions::get_options('options' => \%OPTION_TYPES);
#
# if ($args{$HELP_OPTION})
# {
#     print "You asked for help!\n";
# }
# else
# {
#     print "You tried to use the file '$args{$FILE_OPTION}'.\n";
# }
#
# See 'Getopt::Long' Perl documentation for information on option types.
###

use warnings;
use strict;

# core Perl modules
use Getopt::Long;

sub get_options
{
    my %option_types = %{shift @_};

    my %getopt_hash;
    my @getopt_list;
    my %arguments;
    
    foreach my $option (keys %option_types)
    {
	$getopt_hash{$option} = \$arguments{$option};
	push(@getopt_list, $option . $option_types{$option});
    }
    
    &Getopt::Long::GetOptions(\%getopt_hash, @getopt_list);
    
    return %arguments;
}

1;
