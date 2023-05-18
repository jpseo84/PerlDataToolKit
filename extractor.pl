#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Time::HiRes qw(time);
use Encode::Guess;

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

    my ($output_file_path) = $target_file_path =~ /^(.+)\.[^.]+$/;
    $output_file_path .= '_output.txt';
    open my $output_file, '>:encoding(UTF-8)', $output_file_path or die "Cannot open output file: $!";

    # UTF-8 Check
    use Encode::Guess;
    open my $target_file, '<', $target_file_path or die "Cannot open target file: $!";
    my $first_few_bytes;
    read($target_file, $first_few_bytes, 512) or die "Cannot read from file: $!";
    close $target_file;

    my $decoder = guess_encoding($first_few_bytes);
    if (ref($decoder)) {
        if ($decoder->name eq 'utf8') {
            # Open the file only when the encoding is utf8
            open $target_file, '<:encoding(UTF-8)', $target_file_path or die "Cannot open target file: $!";
            while (my $line = <$target_file>) {
                if (grep { $dictionary{lc $_} } split /[\W_]+/u, $line) {
                    print $output_file $line;
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