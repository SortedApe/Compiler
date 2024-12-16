#include "Tree.h"

Tree* createTree(char* operation, int value, int child_count) {
    Tree* newTree = (Tree*)malloc(sizeof(Tree));
    newTree->operation = operation;
    newTree->value = value;
    newTree->child_count = child_count;
    if (child_count > 0) {
        newTree->children = (Tree**)malloc(sizeof(Tree*) * child_count);
    } else {
        newTree->children = NULL;
    }
    return newTree;
}
void calculate(Tree* tree){
    int ans = 0;
    if(strcmp(tree->operation , "+") == 0){
        for(int i = 0 ; i<tree -> child_count ; i++){
             ans += tree->children[i]->value;
        }
        tree -> value = ans;
        return;
    }
    else if(strcmp(tree->operation,"-") == 0){
        ans = (tree->children[0]->value) - (tree->children[1]->value);
        tree -> value = ans;
        return;
    }
    else if (strcmp(tree->operation , "*") == 0){
        ans ++;
        for(int i = 0 ; i<tree -> child_count ; i++){
             ans *= tree->children[i]->value;
        }
        tree -> value = ans;
        return;
    }
    else if (strcmp(tree->operation , "/") == 0){
        ans = (tree->children[0]->value) / (tree->children[1]->value);
        tree -> value = ans;
        return;
    }
    else if (strcmp(tree->operation , "mod") == 0){
        ans = (tree->children[0]->value) % (tree->children[1]->value);
        tree -> value = ans;
        return;
    }
    else if (strcmp(tree->operation , "=") == 0){
        
        
    }
    printf("arithmetic error");
    return;
}