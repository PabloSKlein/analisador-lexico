
%option noyywrap

%{

#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include <math.h>

int id=0;
char varIds[10][10] = {};
int actualId = 1;
bool breakStrcmp = false;

%}


DIGIT	[0-9]
reserved_word	if|else|for|while|do|switch|return|function|null|NULL|break|case|void|#include|printf|scanf|int|float|double|string|bool
ID	[a-z|A-Z][a-z0-9A-Z]* 
string_literal	"\"".*"\""
ponteiro	"&"{ID}
include_path	{ID}"."{ID}
logic_op	"&&"|"||"
Arith_op	"+"|"-"|"*"|"/"|"%"
Relational_Op 		"<"|"<="|"=="|"!="|">="|">"|"?"|":"
equal	"="
l_paren		"("
r_paren		")"
l_bracket 	"{"
r_bracket	"}"
l_square    "["
r_square    "]"
comma		","
semicolon	";"
l_comment   "//".*
n_comment	"/*"([^*]|"*"+[^/*])*"*"+"/"


/* rules */

%%

{DIGIT}+ { printf("[num, %s]\n", yytext, atoi(yytext));}

{DIGIT}"."{DIGIT}* {printf("[num, %s]\n", yytext, atof(yytext));}

{reserved_word} {printf("[Reserved_word, %s]\n", yytext);}

{Relational_Op} {printf("[Relational_Op, %s]\n", yytext);}

{Arith_op} {printf("[Arith_op, %s]\n", yytext);}

{logic_op} {printf("[logic_op, %s]\n", yytext);}

{include_path} {printf("[include_path, %s]\n", yytext);}

{ponteiro} {printf("[ponteiro, %s]\n", yytext);}

{string_literal} { printf("[string_literal: %s ]\n", yytext);}

{equal} {printf("[equal, %s]\n", yytext);}

{l_paren} {printf("[l_paren, %s]\n", yytext);}

{r_paren} {printf("[r_paren, %s]\n", yytext);}

{l_bracket} {printf("[l_bracket, %s]\n", yytext);}

{r_bracket} {

	printf("[r_bracket, %s]\n", yytext);
	for (int i = 0; i < 10; i++){
		strcpy(varIds[i], "/0");
		actualId = 1;
	}
}

{l_square} {printf("[l_square, %s]\n", yytext);}

{r_square} {printf("[r_square, %s]\n", yytext);}

{comma} {printf("[comma, %s]\n", yytext);}

{semicolon} {printf("[semicolon, %s]\n", yytext);}

{ID} {

	int i;
	for (i = 0; i < sizeof(varIds); i++){
        if(strcmp(yytext, varIds[i])==0){
			printf("[id %s, %d]\n", yytext, i);
			breakStrcmp = true;
			break;
		}
	}
	if(!breakStrcmp){
		strcpy(varIds[actualId], yytext);
		printf("[id %s, %d]\n", yytext, actualId);
		actualId++;
	}else{
		breakStrcmp = false;
	}
}
	

{l_comment} { }

{n_comment} { }

[ \t\n]+

.	printf("Caractere nao reconhecido: %s\n", yytext);

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	return 0;
}
