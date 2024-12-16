%option noyywrap
%{
    #include "Tree.h"
    #include "project.tab.h"
%}

print_num "print-num"
print_bool "print-bool"
id [a-zA-Z_][a-zA-Z0-9]*
boolVal ("#t"|"#f")
integer (-)?([0-9]+)


/**/
%%
[\t\n ]+     { }
"+"             {return yytext[0];} 
"-"             {return yytext[0];}
"*"             {return yytext[0];}
"/"             {return yytext[0];}
"="             {return yytext[0];}
">"             {return yytext[0];}
"<"             {return yytext[0];}
"if"            {return IF;}
"and"           {return and;}
"not"           {return not;}
"or"            {return or;}
"mod"           {return mod;}
"define"        {return define;}
"fun"           {return  fun;}
"("             {return LB;}
")"             {return RB;}
{print_num}     {return print_num;}
{print_bool}    {return print_bool;}
{id}            {Tree* token = createTree(strdup(yytext), 0, 0);yylval.tval = token;return ID;}
{boolVal}       {if(strcmp(yytext, "#t")==0){Tree* token = createTree(NULL,1,0); yylval.tval = token;} else{Tree* token =createTree(NULL, 0, 0) ; yylval.tval = token;}return BOOL;}
{integer}       {Tree* token = createTree(NULL, atoi(yytext), 0);yylval.tval = token;return NUMBER;}

%%
