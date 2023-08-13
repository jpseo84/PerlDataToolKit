###########################################################################
# CryptoCurrency Wallet Verifier 0.1                                      #
# Copyright (C) 2023 Jupyo Seo                                            #
# This program is free software; you can redistribute it and/or modify    #
# it under the terms of the GNU General Public License as published by    #
# the Free Software Foundation; either version 2 of the License, or       #
# (at your option) any later version.                                     #
#                                                                         #
# This program is distributed in the hope that it will be useful,         #
# but WITHOUT ANY WARRANTY; without even the implied warranty of          #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           #
# GNU General Public License for more details.                            #
#                                                                         #
# You should have received a copy of the GNU General Public License along #
# with this program; if not, write to the Free Software Foundation, Inc., #
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.             #
###########################################################################

#!/usr/bin/perl

use strict;
use warnings;

# Print your statements
print "Version 0.1, Copyright (C) 2023 Jupyo Seo\n";
print "This program comes with ABSOLUTELY NO WARRANTY;\n";
print "This is free software, and you are welcome to redistribute it under certain conditions; see the provided LICENSE file for details.\n\n";

# Ensure an input file is provided
unless ($ARGV[0]) {
    die "Usage: $0 <input_filename> [output_filename]\n";
}

my $input_filename = $ARGV[0];
my $output_filename = $ARGV[1] || $input_filename =~ s/\.\w+$//r . "_wrapped.txt";

open my $infile, '<', $input_filename or die "Couldn't open file $input_filename: $!";

open my $outfile, '>', $output_filename or die "Couldn't open file $output_filename: $!";

my $min_len = 140;
my $max_len = 150;
my $current_len = 0;
my @current_line;

# Read the entire file into a scalar
local $/;
my $content = <$infile>;

# Split based on any recognized line ending
my @lines = split /\r\n|\n|\r/, $content;

foreach my $line (@lines) {
    my @words = split(/\s+/, $line);

    foreach my $word (@words) {
        if ($current_len + length($word) > $max_len) {
            print $outfile join(' ', @current_line) . "\n";
            $current_len = 0;
            @current_line = ();
        }
        push @current_line, $word;
        $current_len += length($word) + 1;
    }
    
    # Print and reset at the end of original line
    print $outfile join(' ', @current_line) . "\n";
    $current_len = 0;
    @current_line = ();
}

close $infile;
close $outfile;

print "Wrapped text saved to $output_filename\n";
