#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

# Command-line options
my $keep_original = 0;  # Default: Overwrite original file
GetOptions("k" => \$keep_original);

# Check if filename is provided
if (@ARGV < 1) {
    die "Usage: $0 [-k] <input_file>\n  -k : Keep original file, output to target_output.txt\n";
}

# Get the input file from command-line argument
my $input_file = $ARGV[0];
my $output_file = $keep_original ? "$input_file.output.txt" : "$input_file.tmp";
my $unprocessed_file = "$input_file.unprocessed.txt";

# Open input file
open(my $in, '<', $input_file) or die "Cannot open input file: $!";
open(my $out, '>', $output_file) or die "Cannot open output file: $!";
open(my $unproc, '>', $unprocessed_file) or die "Cannot open unprocessed file: $!";

my $prev_line = "";  # Store previous line
my $prev_pipe_count = 0;  # Track pipe count of previous line

while (my $line = <$in>) {
    chomp $line;  # Remove newline character
    my $pipe_count = () = $line =~ /\|/g;  # Count pipes in the current line

    # If no previous line stored, keep the current one and continue
    if ($prev_line eq "") {
        $prev_line = $line;
        $prev_pipe_count = $pipe_count;
        next;
    }

    # Merge if sum of pipes in two adjacent lines is between 24 and 26
    if (($prev_pipe_count + $pipe_count) >= 24 && ($prev_pipe_count + $pipe_count) <= 26) {
        if ($prev_pipe_count > $pipe_count && $prev_line =~ /^\S/) {
            if ($prev_pipe_count < 25) {
                $prev_line .= "|";  # Append a pipe if needed
            }
            print $out "$prev_line $line\n";  # Write fixed line
        } else {
            print $unproc "$prev_line\n$line\n";  # Save unprocessed
        }
        $prev_line = "";
        $prev_pipe_count = 0;
        next;
    }

    # If line is already well-formed (25 pipes), write it directly
    if ($prev_pipe_count == 25) {
        print $out "$prev_line\n";
    } else {
        print $unproc "$prev_line\n";  # Save unprocessed
    }

    # Store current line as the new previous line
    $prev_line = $line;
    $prev_pipe_count = $pipe_count;
}

# Write remaining line
if ($prev_line ne "") {
    if ($prev_pipe_count == 25) {
        print $out "$prev_line\n";
    } else {
        print $unproc "$prev_line\n";
    }
}

# Close file handles
close $in;
close $out;
close $unproc;

# Replace the original file if not using -k option
if (!$keep_original) {
    rename $output_file, $input_file or die "Error replacing file: $!";
}

print "Processing complete!\n";
print "  - Corrected output: " . ($keep_original ? "$output_file\n" : "$input_file (overwritten)\n");
print "  - Unprocessed lines: $unprocessed_file\n";
