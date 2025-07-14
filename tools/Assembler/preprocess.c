#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <limits.h>

char input_path[PATH_MAX];
char output_path[PATH_MAX];

int preprocess_asm(FILE *optr, FILE *iptr);

int main(int argc, char *argv[])
{
    if (argc != 2){
        printf("Usage: preprocess.c <input_file>");
        return 1;
    }
    else {
        snprintf(input_path, sizeof(input_path), "%s", argv[1]);  // safe copy cmd line argument to input_path
        char *ext = strrchr(input_path, '.');  // find .
        FILE *iptr = fopen(input_path, "r");
        if (!ext) {
            printf("No suffix found in input file: %s", input_path);
            return 2;
        }
        else {
            *ext = '\0';  // let input_path terminate at the suffix
            snprintf(output_path, sizeof(output_path), "%s.pre", input_path);
        }
        FILE *optr = fopen(output_path, "w");

        if (iptr == NULL){
            printf("no such file: %s\n", input_path);
            return 1;
        }
        else
            printf("Input file %s found\n", input_path);

        preprocess_asm(optr, iptr);
        fclose(iptr);
        fclose(optr);
        return 0;
    }
}

// read from iptr, preprocess and write to optr
int preprocess_asm(FILE *optr, FILE *iptr){
    char line[200 + 1] = "";

    while (fgets(line, 200, iptr))  // while we get lines from input
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
                    putc('\n', optr);
                    break;
                }
                else {
                    putc(line[i], optr);
                }
            }
        }
    }
    return 0;
}
