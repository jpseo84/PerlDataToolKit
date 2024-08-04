README
=====

# Introduction
본 저장소는 Perl 을 사용하여 텍스트 데이터를 편리하게 처리하기 위한 프로그램들이 개발되고 관리되고 있습니다. 저장소에 보관되는 모든 프로그램들의 사용에 대해서는 함께 첨부된 라이센스 파일을 참조하시기 바랍니다.
* 표준 Perl 인터프리터가 내장되어 있는 Unix/Linux 환경에서는 별다른 환경 설정 없이 명령어를 실행할 수 있습니다. 윈도우 환경에서는 Perl 인터프리터를 설치하고 사용해야 하며, 윈도우에서 사용할 수 있는 Strawberry Perl 인터프리터의 선택과 설치방법에 대해서는 다음 웹사이트를 참고하시기 바랍니다: https://strawberryperl.com/
* Perl 인터프리터를 사용할 수 없는 환경이나 Perl 에 익숙하지 않을 경우 함께 제공되는 Python 으로 작성된 프로그램을 사용할 수 있습니다. 현재 Python 버전의 경우 Encconvert, Extractor 에 대해서 제공됩니다. 일반적으로 Unix 내장 텍스트 처리 툴(sed, awk)과 거의 비슷한 속도를 제공하는 Perl 과 달리, Python 프로그램들은 약간의 성능 저하가 발생할 수 있습니다.  
  
This repository contains programs developed and managed for easier processing of text data using Perl. For the use of all programs in this repository, please refer to the attached LICENSE file.
* Programs can be run without any additional environmental configurations from most Unix/Linux environments with a built-in standard Perl interpreter. For Windows environments, you need to install a Perl interpreter. For information on installing the Strawberry Perl interpreter for Windows, please refer to the following website: https://strawberryperl.com/
* If you cannot use a Perl interpreter or are not familiar with one, Python-based versions are available. Currently, Python versions are provided for Encconvert and Extractor. Unlike Perl, which generally provides speed similar to Unix built-in text processing tools (sed, awk), Python programs are slighly slower in terms of processing speed.

# Encconvert - 텍스트 인코딩 변환기(Text encoding converter)
Encconvert 는 텍스트 파일(Plain text file)의 텍스트 인코딩을 편리하게 편환하기 위하여 Perl 으로 작성되었습니다. 아직도 많은 수의 ERP 시스템이나 데이터 처리 소프트웨어가 원장 데이터 및 각종 데이터파일 추출시 EUC-KR 형태로 내보내기 때문에 텍스트 인코딩에 대해 확실히 알지 못할 경우 항상 실행하여 UTF-8 로 변환하는 것이 좋습니다. 이미 UTF-8 로 작성된 경우 별도의 처리를 하지 않도록 설계되었으며, EUC-KR 이외의 인코딩은 인식하지 못합니다.  
  
Encconvert is a Perl-based program used to convert the text encoding (codepage) of plain text files. Many ERP systems and data processing software still provide exporting functionality for its ledger data and various data files in EUC-KR format, it's good to always run this and convert to UTF-8 if you're unsure of the text encoding. It's designed not to process files already prepared in UTF-8, and it doesn't recognize encodings other than EUC-KR.
  
## 기본 기능(Basic functionality)
* 파일의 인코딩을 인식합니다(EUC-KR, UTF-8).
* EUC-KR 인코딩 파일을 UTF-8 인코딩으로 변환합니다.
* 생명공학, 재무데이터, 대기업의 회계 원장 등 대용량의 텍스트 파일이 생성되는 작업에도 활용할 수 있도록 데이터를 분할하여 처리합니다.
  
* Detects file encoding (EUC-KR, UTF-8).
* Converts the target EUC-KR encoded file into a UTF-8 encoded one.
* Processes data in chunks to handle large text files used in bio-engineering, finance, and accounting ledgers of large organization.
  
## 사용 방법(Usage)
Perl 인터프리터가 설치된 환경에서 사용할 수 있으며, encconvert.pl <filename> 형태로 실행합니다. 파이썬 버전의 경우에도 사용법은 동일하므로, 인터프리터 명과 프로그램 파일명만 정확하게 기입하면 동일하게 작동합니다.
> perl encconvert.pl filename.txt  
> python encconvert.py filename.txt  
  
It can be used in environments with a Perl interpreter by running command as 'encconvert.pl <filename>'. The Python version can be run in the same manner.
> perl encconvert.pl filename.txt  
> python encconvert.py filename.txt  
  
# Extractor - 문자열 기반 텍스트 데이터 추출기(String-based text data extractor)
Extractor 는 텍스트 파일(Plain text file)로부터 특정 문자열을 포함한 일련의 데이터 행들을 일괄 추출하기 위하여 Perl 로 작성되었습니다. Perl 의 기본 라이브러리를 활용하였기 떄문에 Unix 의 기본 내장 명령어 셋(sed, awk 등)과 거의 동일하게 빠른 속도로 데이터를 처리할 수 있습니다. 
  
Extractor is a Perl-based program used to batch extract a series of rows from a plain text file. It extracts rows (lines) containing specific strings from plain text files. Using Perl's basic libraries, it can process data at almost the same speed as Unix's basic built-in command set (sed, awk, etc.).
  
## 기본 기능(Basic functionality)
* 제공된 사전 파일(Dictionary)로부터 키워드를 읽습니다.
* 지정된 대상 파일(Target file)에 대해서 각 행을 확인하여 사전 파일의 키워드가 포함되어 있는지 확인합니다.
* 키워드가 포함된 것으로 확인된 행을 추출하여 출력(output) 파일로 동일 디렉토리에 저장합니다.
* 사전 파일, 대상 파일 모두 UTF-8 인코딩으로 작성된 경우에만 작성합니다. EUC-KR 로 작성된 파일의 경우 본 저장소에 함께 첨부되어 있는 Encconvert 를 활용하시기 바랍니다.
  
* Reads keywords from the provided dictionary file.
* Checks each line from the specified target file to see if it contains keywords from the dictionary file.
* Extracts lines containing specified keywords from the dictionary and saves to an output file in the same directory.
* Works only when both the dictionary file and target file are in UTF-8 encoding. For files written in EUC-KR, please use a separete tool Encconvert provided in this repository.
  
## 사용 방법(Usage)
Perl 인터프리터가 설치된 환경에서 사용할 수 있으며, extractor.pl 뒤에 대상 파일명과 추출 기준이 될 문자열을 포함한 사전(Dictionary) 파일을 작성하고 실행합니다. 파이썬 버전의 경우에도 사용법은 동일하므로, 인터프리터 명과 프로그램 파일명만 정확하게 기입하면 동일하게 작동합니다.
> perl extractor.pl target.csv dictionary.txt  
> python extractor.pl target.csv dictionary.txt  
  
It can be used in environments with a Perl interpreter by running with the target filename and the dictionary file.. The Python version  can be run in the same manner
> perl extractor.pl target.csv dictionary.txt  
> python extractor.pl target.csv dictionary.txt  
  
# 테스트용 파일(Testing files)
두 개의 테스트용 파일이 함께 제공됩니다.
* test_euckr.txt: Encconvert 를 테스트하기 위한 파일로 EUC-KR 인코딩으로 작성된 파일입니다.
* test.csv: Extractor 를 테스트하기 위한 파일로 함께 제공되는 Dictionary 파일과 함께 사용할 수 있습니다.
> perl extractor.pl test.csv dictionary.txt
  
Two test files are provided.
* test_euckr.txt: a file with EUC-KR encoding (to test Encconvert).
* test.csv: a file to test Extractor, which can be used with the provided Dictionary file.
> perl extractor.pl test.csv dictionary.txt
  
# 저자 및 저작권
서주표(Jupyo Seo), 2023  
본 프로그램은 GPL 2.0 을 따르며, 상세한 사용권에 대해서는 별첨 LICENSE 파일을 확인하시기 바랍니다. 국문 버전은 LICENSE_KR 로 제공됩니다.  
Jupyo Seo, 2023  
This program follows GPL 2.0, and for detailed license, please check the attached LICENSE file.  