###########################################################################
# File Merger (encconvert) 0.1                                #
# Copyright (C) 2024 Jupyo Seo                                            #
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

print STDERR "FileMerger, as part of the Perl Data Toolkit Version 0.1, Copyright (C) 2024 Jupyo Seo\n";
print STDERR "This program comes with ABSOLUTELY NO WARRANTY;\n";
print STDERR "This is free software, and you are welcome to redistribute it under certain conditions; see the provided LICENSE file for details.\n\n";

# Check if at least one file is provided
if (@ARGV < 1) {
    die "Usage: $0 file1 [file2 ...]\n";
}

my $is_first_file = 1;

foreach my $file (@ARGV) {
    open my $fh, '<', $file or die "Cannot open file $file: $!\n";

    my $is_first_line = 1;
    while (my $line = <$fh>) {
        # Skip header if not the first file
        if ($is_first_file || !$is_first_line) {
            print $line;
        }
        $is_first_line = 0;
    }

    close $fh;
    $is_first_file = 0;  # Mark that we've processed the first file
}
