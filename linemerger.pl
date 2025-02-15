#!/usr/bin/perl
use strict;
use warnings;

# Check if filename is provided
if (@ARGV < 1) {
    die "Usage: $0 <input_file>\n";
}

# Get the input file from command-line argument
my $input_file = $ARGV[0];

# Define output files
my $processed_file   = "$input_file.processed.txt";
my $unprocessed_file = "$input_file.unprocessed.txt";

# Open input file
open(my $in, '<', $input_file) or die "Cannot open input file: $!";
open(my $proc, '>', $processed_file) or die "Cannot open processed file: $!";
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

    # If the sum of two adjacent lines' pipes is between 24 and 26, merge them
    if (($prev_pipe_count + $pipe_count) >= 24 && ($prev_pipe_count + $pipe_count) <= 26) {
        # Ensure the first line has more pipes and starts with data
        if ($prev_pipe_count > $pipe_count && $prev_line =~ /^\S/) {
            # Append a pipe if the first line has significantly fewer than expected
            if ($prev_pipe_count < 25) {
                $prev_line .= "|";
            }

            # Merge and save
            print $proc "$prev_line $line\n";
        } else {
            print $unproc "$prev_line\n$line\n";  # Save unprocessed
        }
        # Reset previous line storage
        $prev_line = "";
        $prev_pipe_count = 0;
        next;
    }

    # If it doesn’t match, write the previous line to unprocessed
    print $unproc "$prev_line\n";

    # Store current line as the new previous line
    $prev_line = $line;
    $prev_pipe_count = $pipe_count;
}

# Write any remaining line to unprocessed file
if ($prev_line ne "") {
    print $unproc "$prev_line\n";
}

# Close file handles
close $in;
close $proc;
close $unproc;

print "Cleaning complete! Check '$processed_file' and '$unprocessed_file'.\n";
