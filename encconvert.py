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

#!/usr/bin/env python3

import sys
import os
import chardet
from pathlib import Path

def print_program_info():
    print("Encconvert, as part of the Data Toolkit Version 0.1, Copyright (C) 2024")
    print("This program comes with ABSOLUTELY NO WARRANTY;")
    print("This is free software, and you are welcome to redistribute it under certain conditions; see the provided LICENSE file for details.\n")

def detect_encoding(file_path):
    with open(file_path, 'rb') as file:
        raw_data = file.read(100 * 1024)  # Read first 100KB
    result = chardet.detect(raw_data)
    return result['encoding']

def convert_file(input_path, output_path, input_encoding):
    with open(input_path, 'r', encoding=input_encoding) as infile, \
         open(output_path, 'w', encoding='utf-8') as outfile:
        while True:
            chunk = infile.read(64 * 1024)  # Read 64KB at a time
            if not chunk:
                break
            outfile.write(chunk)

def main():
    print_program_info()

    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <filename>")
        sys.exit(1)

    file_path = sys.argv[1]
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        sys.exit(1)

    detected_encoding = detect_encoding(file_path)
    print(f"The detected encoding is: {detected_encoding}")

    response = input("Do you want to convert the file to UTF-8? (y/n): ").lower()
    if response != 'y':
        print("Conversion aborted.")
        sys.exit(0)

    input_path = Path(file_path)
    output_path = input_path.with_stem(f"{input_path.stem}_utf8")

    try:
        convert_file(input_path, output_path, detected_encoding)
        print(f"Converted file saved as '{output_path}'")
    except Exception as e:
        print(f"An error occurred during conversion: {e}")

if __name__ == "__main__":
    main()