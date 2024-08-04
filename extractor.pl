###########################################################################
# Text line extractor (extractor) 0.1                                     #
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
use utf8;
use Time::HiRes qw(time);
use Encode::Guess;
use File::Basename;

print "Extractor, as part of the Perl Data Toolkit Version 0.1, Copyright (C) 2023 Jupyo Seo\n";
print "This program comes with ABSOLUTELY NO WARRANTY;\n";
print "This is free software, and you are welcome to redistribute it under certain conditions; see the provided LICENSE file for details.\n\n";

sub process_file {
    my ($target_file_path, $dictionary_file_path) = @_;

    my %dictionary;
    open my $dictionary_file, '<:encoding(UTF-8)', $dictionary_file_path or die "Cannot open dictionary file: $!";
    while (my $word = <$dictionary_file>) {
        $word =~ s/^\xEF\xBB\xBF//;
        $word =~ s/^\s+|\s+$//g;
        $dictionary{lc $word} = 1;
    }
    close $dictionary_file;

    my ($name, $path, $suffix) = fileparse($target_file_path, qr/\.[^.]*/);
    my $output_file_path = $path . $name . '_output' . $suffix;
    open my $output_file, '>:encoding(UTF-8)', $output_file_path or die "Cannot open output file: $!";

    # Check UTF-8 encoding
    open my $target_file, '<', $target_file_path or die "Cannot open target file: $!";
    read($target_file, my $checker, 1024) or die "Cannot read from file: $!";
    close $target_file;

    my $decoder = guess_encoding($checker);
    if (ref($decoder)) {
        if ($decoder->name eq 'utf8') {
            # UTF8인 경우에만 진행하고 아닌 경우 에러
            open $target_file, '<:encoding(UTF-8)', $target_file_path or die "Cannot open target file: $!";
            while (my $line = <$target_file>) {
                foreach my $dict_word (keys %dictionary) {
                    if ($line =~ /\b\Q$dict_word\E\b/i) {
                        print $output_file $line;
                        last;
                    }
                }
            }
            close $target_file;
        } else {
            die "Target file appears to be in " . $decoder->name . " format, not UTF-8\n";
        }
    } else {
        die "Cannot guess the encoding of target file: $decoder\n";
    }

    close $output_file;
    print "Output file written to $output_file_path\n";
}


my $start_time = time();

process_file(@ARGV);

my $elapsed_time = time() - $start_time;
my $hours = int($elapsed_time / 3600);
my $minutes = int(($elapsed_time % 3600) / 60);
my $seconds = $elapsed_time % 60;
printf("Elapsed time: %02d:%02d:%02d (or %.2f seconds)\n", $hours, $minutes, $seconds, $elapsed_time);
