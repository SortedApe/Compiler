#pragma once
typedef struct Variable{
    char* id;
    int value;
}Variable;
extern int VariableCount ; // Start with zero variables
extern Variable** variableArray; // Start with NULL
void init();
int add(Variable* var);
Variable* call(char* c);