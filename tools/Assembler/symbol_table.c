#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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


static const struct symbol_to_address {
    char *name;
    int address;
} built_ins[] = {
    "SP",       0,      // stack pointer of VM
    "LCL",      1,      // local segment of VM
    "ARG",      2,      // argument of function/method call
    "THIS",     3,      // pointer to object in heap
    "THAT",     4,      // pointer to object in heap
    "LED",      4096,   // (probably 1 for LED1 on and LED2 off, 2 for LED1 on and LED2 off, 3 for both on)
    "BUT",      4097,   // 0 for BUT pushed down, 1 for BUT released up
    "UART_TX",  4098,   // send byte over UART
    "UART_RX",  4099,   // receive byte from UART
    "SPI",      4100,   // read/write from SPI flash ROM
    "SRAM_A",   4101,   // address of SRAM chip for next read/write
    "SRAM_D",   4102,   // read/write data from/to SRAM chip
    "GO",       4103,   // switch from BOOT to RUN
    "LCD8",     4104,   // write 8bit to LCD
    "LCD16",    4105,   // write 16bit to LCD
    "RTP",      4106,   // read/write 8bit from/to RTP
    "DEBUG0",   4107,   // reserved for debugging
    "DEBUG1",   4108,
    "DEBUG2",   4109,
    "DEBUG3",   4110,
    "DEBUG4",   4111,
};

static Symbolnode head_node = { NULL, built_ins[0].name, built_ins[0].address };
static Symbolnode *head = &head_node;

// Constructor of symbol_node
Symbolnode* make_symbol_node(char *name, int address){
    Symbolnode *temp;
    temp->name = name;
    temp->address = address;
    temp->next = NULL;

    return temp;
};


static int symbol_table_initialized = 0;
// build_initial_table: initialize the symbol table with the built_ins
void build_initial_table(){

    if (symbol_table_initialized) return;
    Symbolnode *tmp = head;
    Symbolnode *curr = NULL;
    for (int i = 1; i < (sizeof(built_ins) / sizeof(built_ins[0])); i++){
        curr = make_symbol_node(built_ins[i].name, built_ins[i].address);
        tmp->next = curr;
        tmp = curr;
    }
    // Add RAM0-RAM15
    for (int i = 0; i < 16; i++){
        char* name;
        sprintf(name, "R%d", i);
        curr = make_symbol_node(name, i);
        tmp->next = curr;
        tmp = curr;
    }
    symbol_table_initialized = 1;
}

// contains: check if the symbol table already contains the given symbol.
// if true, returns a pointer to the Symbolnode, else NULL
Symbolnode* contains(char* name){

    Symbolnode* curr = malloc(sizeof(*curr));

    for (curr = head; curr != NULL; curr = curr->next){
        if (strcmp(name, curr->name) == 0){
            return curr; // found
        }
    }
    return NULL; // not found
}


// add_entry: adds a Symbolnode to the symbol table given name, finding the next free address
void add_entry(char* name){

    Symbolnode* curr;

    // Problem is, this could occur also if there was an error with the pointer
    for (curr = head; curr->next != NULL; curr = curr->next); // traverse to the end of the list
    if (curr->address < 15) {
        printf("Node can only be added after address 15 but last installed address is %d", curr->address);
    }
    Symbolnode* new_entry = make_symbol_node(name, (curr->address)+1);
    curr->next = new_entry;
};


// get_address: return address if name already exists, NULL else
int get_address(char* name){
    Symbolnode *query_node = contains(name);
    if (query_node){
        return query_node->address;
    } else {
        return -1;
    }
}
