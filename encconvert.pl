###########################################################################
# Text Encoding Converter (encconvert) 0.1                                #
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
use Encode;
use Encode::Guess;
use File::Basename;

print "Encconvert, as part of the Perl Data Toolkit Version 0.1, Copyright (C) 2023 Jupyo Seo\n";
print "This program comes with ABSOLUTELY NO WARRANTY;\n";
print "This is free software, and you are welcome to redistribute it under certain conditions; see the provided LICENSE file for details.\n\n";

my $file = $ARGV[0] or die "Usage: $0 <filename>\n";

# Read the first 100KB only - prevent errors when processing a large GL file
open my $fh, '<', $file or die "Could not open '$file': $!";
my $buffer;
my $read_bytes = read $fh, $buffer, 100 * 1024;
close $fh;

# Guess file encoding
my $enc = guess_encoding($buffer, qw/euc-kr utf-8/);
if (ref($enc)) {
    print "The detected encoding is: ", $enc->name, "\n";
} else {
    print "Could not guess the encoding: $enc\n";
    exit;
}

print "Do you want to convert the file to UTF-8? (y/n): ";
my $response = <STDIN>;
chomp $response;

if (lc($response) eq 'y') {
    # Separate filename and extension
    my ($basename, $dir, $ext) = fileparse($file, qr/\.[^.]*/);

    open my $in_fh, '<', $file or die "Could not open '$file': $!";
    my $output_file = "${dir}${basename}_utf8${ext}";
    open my $out_fh, '>', $output_file or die "Could not open '$output_file': $!";

    my $chunk_size = 64 * 1024; # Chunk sized as 64KB
    while (my $bytes_read = read $in_fh, my $chunk, $chunk_size) {
        my $decoded_chunk = decode($enc->name, $chunk);
        my $encoded_chunk = encode("utf-8", $decoded_chunk);
        print $out_fh $encoded_chunk;
    }

    close $in_fh;
    close $out_fh;

    print "Converted file saved as '$output_file'\n";
} else {
    print "Conversion aborted.\n";
}

