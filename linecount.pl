#!/usr/bin/perl
use strict;
use warnings;

# Check if filename is provided
if (@ARGV < 1) {
    die "Usage: $0 <input_file>\n";
}

# Get the input file from command-line argument
my $input_file = $ARGV[0];

# Open the input file
open(my $in, '<', $input_file) or die "Cannot open input file: $!";

my $lines_per_page = 20;  # Number of lines per page
my $lines_shown = 0;  # Counter for displayed lines

while (my $line = <$in>) {
    chomp $line;  # Remove newline character

    # Count the number of pipes ('|') in the line
    my $pipe_count = () = $line =~ /\|/g;

    # Format pipe count as 2-digit padded number (e.g., 03, 22, 26)
    my $formatted_pipe_count = sprintf("[%02d]", $pipe_count);

    # Print the formatted line with pipe count
    print "$formatted_pipe_count $line\n";
    $lines_shown++;

    # Pause every $lines_per_page lines
    if ($lines_shown % $lines_per_page == 0) {
        print "\n-- More (Press Enter to continue, 'q' to quit, 'n' to skip N pages, 's' to skip section) -- ";
        my $input = <STDIN>;
        chomp($input);

        if ($input eq 'q') {
            print "Exiting...\n";
            last;
        } elsif ($input =~ /^n(\d*)$/) {
            my $skip_pages = $1 || 1;
            my $skip_lines = $skip_pages * $lines_per_page;
            print "Skipping $skip_lines lines...\n";
            while ($skip_lines-- > 0 && <$in>) { }  # Skip lines
        } elsif ($input eq 's') {
            print "Skipping next section (50 lines)...\n";
            for (1..50) { <$in> }  # Skip 50 lines
        }
    }
}

# Close file handle
close $in;

print "\nEnd of file reached.\n";
