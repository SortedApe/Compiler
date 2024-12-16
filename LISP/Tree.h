#pragma once
#define INTEGER 0;
#define BOOLEAN 1;
#define STRING 2;
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct Tree {
    char* operation;     
    int value;            
    struct Tree** children;
    int child_count;       
} Tree;

// Function to create a new tree node
Tree* createTree(char* operation, int value, int child_count) ;
void calculate(Tree* tree);