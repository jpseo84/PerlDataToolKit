###########################################################################
# Text Encoding Converter (encconvert) 0.2                                #
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
use Encode;
use Encode::Guess;
use File::Basename;
use File::Glob ':glob';

print "Encconvert, as part of the Perl Data Toolkit Version 0.2, Copyright (C) 2024 Jupyo Seo\n";
print "This program comes with ABSOLUTELY NO WARRANTY;\n";
print "This is free software, and you are welcome to redistribute it under certain conditions; see the provided LICENSE file for details.\n\n";

# Ensure at least one argument is given
if (@ARGV == 0) {
    die "Usage: $0 <file1> [file2] [...] (wildcards supported)\n";
}

# Expand wildcards and filter valid files
my @files = map { bsd_glob($_) } @ARGV;
@files = grep { -f $_ } @files;  # Only keep actual files

if (@files == 0) {
    die "No valid files found.\n";
}

my $apply_to_all = 0;  # Flag to track "all" option

foreach my $file (@files) {
    print "\nProcessing file: $file\n";

    # Read the first 100KB to determine encoding
    open my $fh, '<', $file or warn "Could not open '$file': $!\n" and next;
    my $buffer;
    my $read_bytes = read $fh, $buffer, 100 * 1024;
    close $fh;

    # Guess file encoding
    my $enc = guess_encoding($buffer, qw/euc-kr utf-8/);
    if (ref($enc)) {
        print "The detected encoding is: ", $enc->name, "\n";
    } else {
        print "Could not guess the encoding for '$file': $enc\n";
        next;
    }

    my $response;
    unless ($apply_to_all) {
        print "Do you want to convert '$file' to UTF-8? (y/n/a for all): ";
        $response = <STDIN>;
        chomp $response;

        if (lc($response) eq 'a') {
            $apply_to_all = 1;
        }
    }

    if ($apply_to_all || lc($response) eq 'y') {
        # Separate filename and extension
        my ($basename, $dir, $ext) = fileparse($file, qr/\.[^.]*/);
        my $output_file = "${dir}${basename}_utf8${ext}";

        open my $in_fh, '<', $file or warn "Could not open '$file': $!\n" and next;
        open my $out_fh, '>', $output_file or warn "Could not open '$output_file': $!\n" and next;

        my $chunk_size = 64 * 1024; # Process in 64KB chunks
        while (my $bytes_read = read $in_fh, my $chunk, $chunk_size) {
            my $decoded_chunk = decode($enc->name, $chunk);
            my $encoded_chunk = encode("utf-8", $decoded_chunk);
            print $out_fh $encoded_chunk;
        }

        close $in_fh;
        close $out_fh;

        print "Converted file saved as '$output_file'\n";
    } else {
        print "Skipping conversion for '$file'.\n";
    }
}

print "\nProcessing completed.\n";
