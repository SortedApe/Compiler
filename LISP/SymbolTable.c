#include "SymbolTable.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h> // For debugging prints

int VariableCount = 0; // Start with zero variables
Variable** variableArray = NULL; // Start with NULL

void init() {
    variableArray = malloc(sizeof(Variable*) * 1);
    if (!variableArray) {
        fprintf(stderr, "Error: Failed to allocate memory for variableArray\n");
        exit(1); 
    }
    VariableCount = 0; 
}

int add(Variable* var) {
    for(int i = 0 ; i< VariableCount; i++){
        if (strcmp(var->id, variableArray[i]->id) == 0) { 
            printf("Redefinition is not allowed\n");
            return 1;
        }
    }
    VariableCount++;
    variableArray = realloc(variableArray, sizeof(Variable*) * VariableCount);
    if (!variableArray) {
        fprintf(stderr, "Error: Failed to reallocate memory for variableArray\n");
        exit(1); 
    }

    
    variableArray[VariableCount - 1] = var;

    
    //printf("Added variable: %s = %d\n", var->id, var->value);
    //printf("VariableCount: %d\n", VariableCount);

    return 0; 
}

Variable* call(char* c) {
    for (int i = 0; i < VariableCount; i++) {
        if (strcmp(c, variableArray[i]->id) == 0) {
            
            //printf("Variable found: %s = %d\n", variableArray[i]->id, variableArray[i]->value);
            return variableArray[i];
        }
    }

    printf("Error: Variable %s not found\n", c);
    return NULL; // Variable not found
}
