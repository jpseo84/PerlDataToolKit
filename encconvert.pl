#!/usr/bin/perl

use strict;
use warnings;
use Encode;
use Encode::Guess;
use File::Basename;

my $file = $ARGV[0] or die "Usage: $0 <filename>\n";

# 처음 100KB 만 읽어오도록 수정(대용량 원장은 처리시 에러남)
open my $fh, '<', $file or die "Could not open '$file': $!";
my $buffer;
my $read_bytes = read $fh, $buffer, 100 * 1024;
close $fh;

# 인코딩 추정
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
    # 파일명을 가져올때 파일명 부분과 확장자 부분을 구분
    my ($basename, $dir, $ext) = fileparse($file, qr/\.[^.]*/);

    open my $in_fh, '<', $file or die "Could not open '$file': $!";
    my $output_file = "${dir}${basename}_utf8${ext}";
    open my $out_fh, '>', $output_file or die "Could not open '$output_file': $!";

    my $chunk_size = 64 * 1024; # 64KB
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

