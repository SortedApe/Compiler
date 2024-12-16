/*
    build a AST Tree for each function;
    create a runtime stack to support recursion call
    

*/
typedef struct Function{
    char* id;
    int* paramList;
}func;