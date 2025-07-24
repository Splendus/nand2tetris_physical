// lookup_table.c
//
// c instructions are translated into 16 bit values
// 111a vvvv vvdd djjj
// with an a bit, 6 value bits v, 3 destination bits d and 3 jump bits j
// Example:
// D=D-A
// has "D" as its destination (010) and "D-A" as its value bits (0 010011)
// and would therefore by translated (with jump being null) to
// D=D-A --> 1110 0100 1101 0000
//
// a instructions (for the a register) handle everything related to address specifications
// They start with 0 followed by a constant (e.g. an address in memory)
// 0vvv vvvv vvvv vvvv

#include <stdlib.h>
#include <stdio.h>
#include <string.h>


struct instr {
    char *hackcode;
    char *opcode;
};

char* lookup(struct instr *table, int table_size, const char *mnemonic);

// c-instruction
struct instr comp_table[] = {
    "0",    "0101010",  // a = 0
    "1",    "0111111",
    "-1",   "0111010",
    "D",    "0001100",
    "A",    "0110000",
    "!D",   "0001101",
    "!A",   "0110001",
    "-D",   "0001111",
    "-A",   "0110011",
    "D+1",  "0011111",
    "A+1",  "0110111",
    "D-1",  "0001110",
    "A-1",  "0110010",
    "D+A",  "0000010",
    "D-A",  "0010011",
    "A-D",  "0000111",
    "D&A",  "0000000",
    "D|A",  "0010101",
    "M",    "1110000",  // a = 1
    "!M",   "1110001",
    "M+1",  "1110111",
    "M-1",  "1110010",
    "D+M",  "1000010",
    "D-M",  "1010011",
    "M-D",  "1000111",
    "D&M",  "1000000",
    "D|M",  "1010101",
};


// dest-instruction (d1 d2 d3)
struct instr dest_table[] = {
    "null", "000",
    "M",    "001",
    "D",    "010",
    "MD",   "011",
    "A",    "100",
    "AM",   "101",
    "AD",   "110",
    "AMD",  "111",
};

// jump-instruction (j1 j2 j3)
struct instr jump_table[] = {
    "null", "000",
    "JGT",  "001",
    "JEQ",  "010",
    "JGE",  "011",
    "JLT",  "100",
    "JNE",  "101",
    "JLE",  "110",
    "JMP",  "111",
};

const int COMP_TABLE_SIZE = sizeof(comp_table) / sizeof(comp_table[0]);
const int DEST_TABLE_SIZE = sizeof(dest_table) / sizeof(dest_table[0]);
const int JUMP_TABLE_SIZE = sizeof(jump_table) / sizeof(jump_table[0]);

char* lookup(struct instr *table, int table_size, const char *mnemonic){
    for (int i = 0; i < table_size; i++){
        if (strcmp(table[i].hackcode, mnemonic) == 0){
            return table[i].opcode;
        }
    }
    return NULL;
}