#ifndef PARSE_H
#define PARSE_H

#include <stdio.h>

char* initialize_asm(FILE *iptr, char *buf);
int has_more_commands(char *asm_code);
char* advance(char *asm_code);
char command_type(char* cur_command);
char* symbol(char* cur_command);
ssize_t write_dest(char *buf, size_t bufsize, char *cur_command, char *eq);
ssize_t write_comp(char *buf, size_t bufsize, char *cur_command, char *eq, char *sc);
ssize_t write_jump(char *buf, size_t bufsize, char *cur_command, char *sc);

#endif
