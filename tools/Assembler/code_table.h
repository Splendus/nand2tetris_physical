#ifndef CODE_TABLE_H
#define CODE_TABLE_H

struct instr
{
    char *hackcode;
    char *opcode;
};

extern struct instr comp_table[];
extern struct instr dest_table[];
extern struct instr jump_table[];

extern const int COMP_TABLE_SIZE;
extern const int DEST_TABLE_SIZE;
extern const int JUMP_TABLE_SIZE;

char* lookup(struct instr *table, int table_size, const char *mnemonic);

#endif
