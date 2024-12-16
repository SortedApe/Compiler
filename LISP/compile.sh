#!/bin/bash
# Check if the user provided the .y and .l files
if [ $# -ne 2 ]; then
    echo "Usage: $0 <parser_file.y> <lexer_file.l>"
    exit 1
fi
# Assign input files from user arguments
PARSER_FILE="$1"
LEXER_FILE="$2"

# Extract the base names (without extensions) of the files
BASE_NAME=$(basename "$PARSER_FILE" .y)
LEXER_NAME=$(basename "$LEXER_FILE" .l)

# Define the output directory and file
OUTPUT_DIR="test_case"
OUTPUT_FILE="$OUTPUT_DIR/output"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run bison to generate the parser source
bison -d "$PARSER_FILE"

# Run flex to generate the lexer source
flex "$LEXER_FILE"

# Compile the Bison-generated .tab.c file
gcc -c -g -I.. "$BASE_NAME.tab.c"

# Compile the Flex-generated lexer source
gcc -c -g -I.. lex.yy.c
gcc -c -g -I.. Tree.c
gcc -c -g -I.. SymbolTable.c

# Link the object files and create the executable in the specified output directory
gcc -o "$OUTPUT_FILE" "$BASE_NAME.tab.o" lex.yy.o Tree.o SymbolTable.o

# Check if the output was created successfully
if [ -f "$OUTPUT_FILE" ]; then
    echo "Output file created successfully at $OUTPUT_FILE"
else
    echo "Error: Output file not created"
fi
rm "$BASE_NAME.tab.c" lex.yy.c lex.yy.o "$BASE_NAME.tab.o" "$BASE_NAME.tab.h" SymbolTable.o Tree.o

