#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

// symbol_node is an entry to symbol table in a linked list format
typedef struct symbol_node {
    struct symbol_node *next;  // next entry in the list
    char *name;
    int address;
} Symbolnode;

Symbolnode* make_symbol_node(char *name, int address);
void build_initial_table();
Symbolnode* contains(char *name);
void add_entry(char *name);
int get_address(char *name);


#endif