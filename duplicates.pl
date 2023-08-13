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
use Text::CSV_XS;
use List::MoreUtils qw(uniq);

print "Version 0.1, Copyright (C) 2023 Jupyo Seo\n";
print "This program comes with ABSOLUTELY NO WARRANTY;\n";
print "This is free software, and you are welcome to redistribute it under certain conditions; see the provided LICENSE file for details.\n\n";

my $input_file = $ARGV[0] // die "Usage: perl script_name.pl your_file.csv";

my $output_file = 'internal_transactions.csv';

my @data;
my %deposit;
my %withdraw;

my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
open my $fh, "<", $input_file or die "Cannot open $input_file: $!";
while (my $row = $csv->getline ($fh)) {
    # clean amounts and construct keys
    $$row[2] =~ s/,//g; # DEPOSIT
    $$row[3] =~ s/,//g; # WITHDRAW
    $$row[1] =~ s/^(\d{2}:\d{2}):\d{2}$/$1/; # TXT

    if ($$row[2] > 0) { # deposit
        push @{$deposit{$$row[0].'_'.$$row[1].'_'.$$row[2]}}, $row; # TXD_TXT_DEPOSIT key
    }

    if ($$row[3] > 0) { # withdraw
        push @{$withdraw{$$row[0].'_'.$$row[1].'_'.$$row[3]}}, $row; # TXD_TXT_WITHDRAW key
    }
}
close $fh;

my @keys = uniq(keys %deposit, keys %withdraw);
my @result;

foreach my $key (@keys) {
    next if (!$deposit{$key} or !$withdraw{$key});

    foreach my $dep (@{$deposit{$key}}) {
        foreach my $wdr (@{$withdraw{$key}}) {
            # skip if it is the same account
            next if ($$dep[9] eq $$wdr[9]);

            push @result, [$$dep[0], $$dep[1], $$dep[2], $$dep[3], $$dep[4], $$dep[5], $$dep[6], $$dep[7], $$dep[8], $$dep[9], $$dep[10], $$dep[11],
                           $$wdr[0], $$wdr[1], $$wdr[2], $$wdr[3], $$wdr[4], $$wdr[5], $$wdr[6], $$wdr[7], $$wdr[8], $$wdr[9], $$wdr[10], $$wdr[11]];
        }
    }
}

$csv->say (*STDOUT, $_) for @result;
