#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <limits.h>
#include "symbol_table.h"

const int MAXLINE = 200;


char* initialize_asm(FILE *iptr, char *buf);
int has_more_commands(char *asm_code);
char* advance(char *asm_code);
char command_type(char* cur_command);
char* symbol(char* cur_command);
ssize_t write_dest(char *buf, size_t bufsize, char *cur_command, char *eq);
ssize_t write_comp(char *buf, size_t bufsize, char *cur_command, char *eq, char *sc);
ssize_t write_jump(char *buf, size_t bufsize, char *cur_command, char *sc);
static ssize_t handle_size_diff(ssize_t needed, size_t bufsize);


// initialize_asm: read from iptr asm file, preprocess and write to a string buf which is returned
char* initialize_asm(FILE *iptr, char *buf){
    char line[MAXLINE + 1] = "";
    int j = 0;  // index of buf

    while (fgets(line, MAXLINE, iptr))  // while we get lines from input
    {
        printf("read line: %s", line);  // Debugging
        int i;
        for (i = 0; isspace(line[i]); i++)
            continue;
        if ((line[i] != '\n') && (line[i] != '/')){ // early break otherwise
            for (; i < strlen(line); i++){  //  for all characters in the line
                if (line[i] == ' '){
                    continue;
                }
                if (line[i] == '/'){  // if there is a slash, we assume an inline comment in this line
                    // putc('\n', optr);
                    buf[j] = '\n';
                    j++;
                    break;
                }
                else {
                    // putc(line[i], optr);
                    buf[j] = line[i];
                    j++;
                }
            }
        }
    }
    buf[j] = '\0';
    return buf;
}

// has_more_commands: Returns 1 if the asm_code has more commands to parse, 0 else
int has_more_commands(char *asm_code){
    if (*asm_code == '\0') return 0;
    else return 1;
}

// advance: return the next line of the asm_code and move the parser to the next line
// if there is no new line, the asm_code will be set to point to '\0'
char* advance(char *asm_code){
    char *next_line = strchr(asm_code, '\n');  // find the first occurrence of a newline character
    char *cur_line;
    if (next_line) {
        *next_line = '\0';
        *cur_line = *asm_code;
        *next_line = '\n';  // may be redundant
        asm_code = next_line + 1;
    } else {
        *cur_line = *asm_code;
        *asm_code  = '\0';
    }
    return cur_line;
}

// command_type: return the command type of the current command (A, C or L)
char command_type(char* cur_command){
    char first_char = cur_command[0];
    char last_char = cur_command[strlen(cur_command) - 1];

    char *eq = strrchr(cur_command, '=');  // find '=', i.e. there are destination bits not 0
    char *sc = strrchr(cur_command, ';');  // find ';', i.e. there are jump bits not 0

    char com_type = '0';

    if (first_char == '@'){
        com_type = 'A';
    }
    if (first_char == '(' && last_char == ')'){
        com_type = 'L';
    }
    if (*eq || *sc){
        com_type = 'C';
    }

    return com_type;
}

// symbol: returns the symbol or decimal Xxx of the current command @Xxx or (Xxx).
// Note that the function expects its input `cur_command` to start (just) after '@'
char* symbol(char* cur_command){
    for (int i = 1; i < strlen(cur_command); i++){
        if (isalpha(cur_command[i])){
            // if we find a letter, symbol_table lookup
            Symbolnode* query_symbol = contains(cur_command);
            if (!query_symbol) {
                add_entry(cur_command);
                return cur_command;
            } else {
                return query_symbol->name;
            }
        }
    }
    // when all chars are digits we can simply return as is
    return cur_command;

}

// write_dest: from cur_command and semicolon pointer, write dest mnemonic
ssize_t write_dest(char *buf, size_t bufsize, char *cur_command, char *eq){
    ssize_t needed = 0;
    if (eq) {
        *eq = '\0';
        needed = snprintf(buf, bufsize, "%s", cur_command);
        *eq = '=';
    }

    return handle_size_diff(needed, bufsize);
}


// write_comp: from cur_command, equality and semicolon pointer, write comp mnemonic
ssize_t write_comp(char *buf, size_t bufsize, char *cur_command, char *eq, char *sc){
    ssize_t needed = 0;
    if (eq && sc) {
        // dest=comp;jump
        *eq = '\0', *sc = '\0';
        needed = snprintf(buf, bufsize, "%s", eq+1);
    }
    else if (eq) {
        // dest=comp
        *eq = '\0';
        needed = snprintf(buf, bufsize, "%s", eq+1);
    }
    else if (sc) {
        // comp;jump
        *sc = '\0';
        needed = snprintf(buf, bufsize, "%s", cur_command);
    } else {
        // comp
        needed = snprintf(buf, bufsize, "%s", cur_command);
    }
    *eq = '=', *sc = ';';

    return handle_size_diff(needed, bufsize);
}

// write_jump: from cur_command and semicolon pointer, write jump mnemonic
ssize_t write_jump(char *buf, size_t bufsize, char *cur_command, char *sc){
    ssize_t needed = 0;
    if (sc) {
        // comp;jump or dest=comp;jump
        needed = snprintf(buf, bufsize, "%s", sc+1);
    }
    return handle_size_diff(needed, bufsize);
}

// handle_size_diff: Return the difference between needed and allocated bufsize. Point out errors.
static ssize_t handle_size_diff(ssize_t needed, size_t bufsize){
    if (needed < 0) {
        printf("Encoding error in snprintf to buf");
        return -1; // encoding error
    }
    if ((size_t)needed >= bufsize) {
        printf("Needed size %zd exceeds allocated bufsize %zu. Writing to buf was truncated", needed + 1, bufsize);
    }

    return (ssize_t)(bufsize - (size_t)needed -1);
}