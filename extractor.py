#!/usr/bin/env python3

import sys
import time
import re
from pathlib import Path
import chardet
import unicodedata

print("Extractor, as part of the Data Toolkit Version 0.1, Copyright (C) 2024 Jupyo Seo")
print("This program comes with ABSOLUTELY NO WARRANTY;")
print("This is free software, and you are welcome to redistribute it under certain conditions; see the provided LICENSE file for details.\n")

def load_dictionary(dictionary_file_path):
    with open(dictionary_file_path, 'r', encoding='utf-8') as f:
        return {word.strip().lower() for word in f}

def process_file(target_file_path, dictionary_file_path):
    dictionary = load_dictionary(dictionary_file_path)
    
    output_file_path = Path(target_file_path).with_suffix('_output.txt')

    chunk_size = 1024 * 1024  # 1 MB
    with open(target_file_path, 'rb') as f:
        raw = f.read(chunk_size)
        result = chardet.detect(raw)
        encoding = result['encoding']
        confidence = result['confidence']
    
    print(f"Detected encoding: {encoding} with confidence: {confidence}")
    
    if encoding is None or confidence < 0.7:
        print("Encoding detection uncertain. Defaulting to UTF-8...")
        encoding = 'utf-8'
    
    try:
        with open(target_file_path, 'r', encoding=encoding) as infile, \
             open(output_file_path, 'w', encoding='utf-8') as outfile:
            for line in infile:
                normalized_line = unicodedata.normalize('NFC', line)
                if any(re.search(r'\b' + re.escape(word) + r'\b', normalized_line, re.IGNORECASE) for word in dictionary):
                    outfile.write(line)
        
        print(f"Output file written to {output_file_path}")
    except UnicodeDecodeError as e:
        print(f"Error: Unable to decode the file with {encoding} encoding.")
        print(f"Error details: {str(e)}")
        print("The file may contain characters that are not valid in the detected encoding.")
        print("Please ensure the file is saved in UTF-8 format without BOM (Byte Order Mark).")
        raise

def main():
    if len(sys.argv) != 3:
        print("Usage: python script.py <target_file> <dictionary_file>")
        sys.exit(1)
    
    start_time = time.time()
    
    try:
        process_file(sys.argv[1], sys.argv[2])
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)
    
    elapsed_time = time.time() - start_time
    hours, rem = divmod(elapsed_time, 3600)
    minutes, seconds = divmod(rem, 60)
    print(f"Elapsed time: {int(hours):02d}:{int(minutes):02d}:{seconds:05.2f} (or {elapsed_time:.2f} seconds)")

if __name__ == "__main__":
    main()