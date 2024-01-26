###########################################################################
# Text Delimiter Predictor (delimiter) 0.1                                #
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

sub predict_delimiter {
    my ($file_path) = @_;
    my @delimiters = ('|', ';', ',', "\t");
    my %delimiter_counts;

    open my $fh, '<', $file_path or die "Cannot open file: $!";
    <$fh>;

    while (my $line = <$fh>) {
        last if $. > 10;

        foreach my $delimiter (@delimiters) {
            my $count = () = $line =~ /\Q$delimiter\E/g;
            $delimiter_counts{$delimiter} += $count;
        }
    }

    close $fh;

    my $max_delimiter = (sort { $delimiter_counts{$b} <=> $delimiter_counts{$a} } keys %delimiter_counts)[0];

    return $max_delimiter;
}

my $file_path = "filename.csv";
my $predicted_delimiter = predict_delimiter($file_path);
print "Predicted delimiter: '$predicted_delimiter'\n";
