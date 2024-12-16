%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include <string.h>
    #include "Tree.h"
    #include "SymbolTable.h"
    
    int yylex();
    void yyerror(const char* c);

%}
%union {
    Tree* tval;
    char* sval;
}
%token <tval> NUMBER BOOL ID
%token mod and not or print_num print_bool LB RB IF define

%type <tval> PLUS MINUS MULTIPLY DIVIDE MODULUS GREATER SMALLER EQUAL AND-OP OR-OP NOT-OP IF-EXP VARIABLE
%type <tval> EXP NUM-OP 
%type <tval> LOGICAL-OP
%type <tval> EXPS 
%type PROGRAM STMTS STMT PRINT-STMT DEF-STMT

%%

PROGRAM : STMTS ;

STMTS : STMT STMTS
      | /* empty */
      ;

STMT : EXP
     | PRINT-STMT
     | DEF-STMT
     ;
DEF-STMT : LB define VARIABLE EXP RB   {
                                        
                                            Variable* var =(Variable*) malloc(sizeof(Variable));
                                            var->id = $3->operation;
                                            var->value = $4->value;
                                            add(var);
                                            /*for(int i = 0 ; i< VariableCount; i++){
                                                printf("%s %d\n",variableArray[i]->id, variableArray[i] -> value);
                                            }*/
                                }

    ;
VARIABLE : ID   {
                        
                        $$ = $1;
                }
    
    ;

PRINT-STMT : LB print_num EXP RB{printf("%d\n",$3 -> value);}
           | LB print_bool EXP RB{if($3->value != 0){printf("#t\n");}else{printf("#f\n");}}
           ;
EXPS :/**/          { $$ = NULL;} 
    | EXP EXPS      { 
                        $$ = createTree(NULL, 0 , 2);
                        $$ -> children[0] = $1;
                        $$ -> children[1] = $2;
                    }
    ;
EXP : 
      NUMBER     { $$ = $1;}
    | BOOL       { $$ = $1;}                              
    | NUM-OP     {}
    | LOGICAL-OP {}
    | IF-EXP     {}
    | ID         { 
                        Variable* var = call($1->operation);
                        $1->value = var->value;
                        $$ = $1;
                 }
    ;

NUM-OP : PLUS
       | MINUS
       | MULTIPLY
       | DIVIDE
       | MODULUS
       | GREATER
       | SMALLER
       | EQUAL
       ;

PLUS : LB '+' EXP EXPS  RB      {
                                    $$ = createTree("+",0,1);
                                    $$->children[0] = $3;//children 0 holds the result of EXP
                                    Tree* current = $4; 
                                    int child_count = 1;
                                    while (current != NULL) {
                                        $$->children = realloc($$->children, sizeof(Tree*) * (child_count + 1));
                                        $$->children[child_count++] = current->children[0]; 
                                        current = current->children[1]; 
                                    }
                                    $$->child_count = child_count;
                                    calculate($$);
                                }
     ;

MINUS : LB '-' EXP EXP RB     {
                                    $$ = createTree("-", 0,2);
                                    $$->children[0] = $3;
                                    $$->children[1] = $4;
                                    calculate($$);
                                }
      ;

MULTIPLY : LB '*' EXP EXPS RB   {
                                    $$ = createTree("*",0,1);
                                    $$->children[0] = $3;
                                    Tree* current = $4;
                                    int child_count = 1;
                                    while (current != NULL) {
                                        $$->children = realloc($$->children, sizeof(Tree*) * (child_count + 1));
                                        $$->children[child_count++] = current->children[0]; 
                                        current = current->children[1]; 
                                    }
                                    $$->child_count = child_count;
                                    calculate($$);
                                }

         ;

DIVIDE : LB '/' EXP EXP RB  {
                                $$ = createTree("/",0,2);
                                $$->children[0] = $3;
                                $$->children[1] = $4;
                                calculate($$);
                                
                            }

       ;

MODULUS : LB mod EXP EXP   RB   {
                                    $$ = createTree("mod",0,2);
                                    $$->children[0] = $3;
                                    $$->children[1] = $4;
                                    calculate($$);

                                
                                }
        ;

GREATER : LB '>' EXP EXP   RB   {
                                       if($3->value > $4 ->value){
                                            $$ = createTree(NULL, 1,0);
                                       }else{
                                            $$ = createTree(NULL, 0,0);
                                       }
                                }
        ;

SMALLER : LB '<' EXP EXP   RB   {
                                    if($3->value < $4 ->value){
                                        $$ = createTree(NULL, 1,0);
                                    }else{
                                        $$ = createTree(NULL, 0,0);
                                    }
                                }
        ;

EQUAL : LB '=' EXP EXPS RB     {
                                    $$ = createTree("=", 1, 1); // Default to `true` (1)
                                    $$->children[0] = $3;        // First operand
                                    Tree* current = $4;          // Remaining operands
                                    int child_count = 1;

                                    // Traverse EXPS linked list
                                    while (current != NULL) {
                                        $$->children = realloc($$->children, sizeof(Tree*) * (child_count + 1));
                                        $$->children[child_count++] = current->children[0];
                                        current = current->children[1];
                                    }
                                    $$->child_count = child_count;

                                    // Check values
                                    for (int i = 0; i +1 < child_count; i++) {
                                        if ($$->children[i]->value != $$->children[i+1]->value) { // If any value is `false`
                                            $$->value = 0; // Set to `false`
                                            break;
                                        }
                                    }
                                }
      ;

LOGICAL-OP : AND-OP
           | OR-OP
           | NOT-OP
           ;

AND-OP : LB and EXP EXPS  RB    {
                                    $$ = createTree("and", 1, 1); // Default to `true` (1)
                                    $$->children[0] = $3;        // First operand
                                    Tree* current = $4;          // Remaining operands
                                    int child_count = 1;

                                    // Traverse EXPS linked list
                                    while (current != NULL) {
                                        $$->children = realloc($$->children, sizeof(Tree*) * (child_count + 1));
                                        $$->children[child_count++] = current->children[0];
                                        current = current->children[1];
                                    }
                                    $$->child_count = child_count;

                                    // Check values
                                    for (int i = 0; i < child_count; i++) {
                                        if ($$->children[i]->value == 0) { // If any value is `false`
                                            $$->value = 0; // Set to `false`
                                            break;
                                        }
                                    }
                                }
       ;

OR-OP : LB or EXP EXPS RB       {
                                    $$ = createTree("or", 0, 1); // Default to `false` (1)
                                    $$->children[0] = $3;        // First operand
                                    Tree* current = $4;          // Remaining operands
                                    int child_count = 1;

                                    // Traverse EXPS linked list
                                    while (current != NULL) {
                                        $$->children = realloc($$->children, sizeof(Tree*) * (child_count + 1));
                                        $$->children[child_count++] = current->children[0];
                                        current = current->children[1];
                                    }
                                    $$->child_count = child_count;

                                    // Check values
                                    for (int i = 0; i < child_count; i++) {
                                        if ($$->children[i]->value == 1) { // If any value is `true
                                            $$->value = 1; // Set to true
                                            break;
                                        }
                                    }
                                }
      ;

NOT-OP : LB not EXP RB          {
                                    $$ = createTree("not", $3->value  == 0 ? 1 : 0 , 1);
                                    $$ ->children[0] = $3;
                                    
                                }
       ;
IF-EXP: LB IF EXP EXP EXP RB    {   
                                    $$ = createTree("if", 0, 3);
                                    $$->children[0] = $3;
                                    $$->children[1] = $4;
                                    $$->children[2] = $5;
                                    $$->value = $$->children[0]->value != 0 ? $$->children[1]->value : $$->children[2]->value
;                                }
%%

void yyerror(const char*c){
    printf("%s\n", c);
}
int main(){
    init();
    yyparse();
    return 0;
}