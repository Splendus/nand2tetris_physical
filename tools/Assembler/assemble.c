#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <limits.h>
#include "code_table.h"
#include "symbol_table.h"
#include "parse.h"

char input_path[PATH_MAX];
char output_path[PATH_MAX];

unsigned dec_to_bin(unsigned k);

// read from iptr, preprocess and write to optr
// this is more like a main
int main(int argc, char *argv[]){

    if (argc != 2){
        printf("Usage: assemble.out <input_file>");
        return 1;
    }
    snprintf(input_path, sizeof(input_path), "%s", argv[1]);  // safe copy cmd line argument to input_path
    FILE *iptr = fopen(input_path, "r");
    char *ext = strrchr(input_path, '.');  // find `.`
    if (ext) {
        *ext = '\0';  // let input_path terminate at the suffix
        snprintf(output_path, sizeof(output_path), "%s.hack", input_path);
        *ext = '.';  // reinstantiate suffix
    }
    else {
        printf("No suffix found in input file: %s", input_path);
        return 2;
    }
    FILE *optr = fopen(output_path, "w");

    if (!iptr){
        printf("no such file: %s\n", input_path);
        return 1;
    }
    printf("Input file %s found\n", input_path);

    build_initial_table();  // initialize symbol table

    char buf[sizeof(*iptr)] = "";  // not 100% sure if this is a proper init
    char *asm_code = initialize_asm(iptr, buf);

    char *symb_or_addr = NULL;

    if (has_more_commands(asm_code)){
        char *command = advance(asm_code);

        char com_type = command_type(command);
        switch (com_type){
            case 'A':
                symb_or_addr = symbol(command + 1);
                if (symb_or_addr) {
                    fprintf(optr, "%s\n", symb_or_addr);
                } else {
                    fprintf(stderr, "Error: invalid mnemonic in command: %s\n", command);
                }
                break;
            case 'C': {
                char dest[5] = "null"; char comp[4] = ""; char jump[5] = "null";
                char *dest_bin = "000"; char *comp_bin = "-00000"; char *jump_bin = "000";
                char *eq = NULL; char *sc = NULL;

                eq = strrchr(command, '=');  // find '=', i.e. there are destination bits not 0
                sc = strrchr(command, ';');  // find ';', i.e. there are jump bits not 0
                ssize_t dest_needed = write_dest(dest, strlen(dest), command, eq);
                ssize_t comp_needed = write_comp(comp, strlen(comp), command, eq, sc);
                ssize_t jump_needed = write_jump(jump, strlen(jump), command, sc);
                if (dest_needed >= 0){
                    dest_bin = lookup(dest_table, DEST_TABLE_SIZE, dest);
                } else {
                    exit(1);
                }
                if (comp_needed >= 0){
                    comp_bin = lookup(comp_table, COMP_TABLE_SIZE, comp);
                } else {
                    exit(2);
                }
                if (jump_needed >= 0){
                    jump_bin = lookup(jump_table, JUMP_TABLE_SIZE, jump);
                } else {
                    exit(3);
                }

                if (comp_bin && dest_bin && jump_bin) {
                    fprintf(optr, "111%s%s%s\n", comp_bin, dest_bin, jump_bin);
                } else {
                    fprintf(stderr, "Error: invalid mnemonic in command: %s\n", command);
                }

                break;
            }
            case 'L': {
                size_t cmd_len = strlen(command);
                char *closing_par = strchr(command, ')');
                if (closing_par) *closing_par = '\0';  // temporarily remove closing parentheses
                else {
                    printf("L-Type command should end with ')' but command is: %s", command);
                    exit(1);
                }
                symb_or_addr = symbol(command + 1);
                if (symb_or_addr) {
                    fprintf(optr, "%s\n", symb_or_addr);
                } else {
                    fprintf(stderr, "Error: invalid mnemonic in command: %s\n", command);
                }
                if (closing_par) *closing_par = ')';  // restore closing parentheses
                break;
            }

            default:
                printf("Invalid command type for command: %s", command);
                break;
            }
    }

    fclose(iptr);
    fclose(optr);
    exit(0);
}


unsigned dec_to_bin(unsigned k) {
    if (k == 0) return 0;
    if (k == 1) return 1;
    return (k % 2) + 10 * dec_to_bin(k / 2);
}
