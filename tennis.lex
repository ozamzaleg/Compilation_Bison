%{
#include <string.h>
#include <ctype.h> 
#include "tennis.tab.h"

extern int atoi (const char *);

%}
%option noyywrap
%option yylineno

%%

"** Winners **" {return TITLE;}

18[5-9][0-9]|19[0-9]{2}|[2-9][0-9]{3,} { yylval.year = atoi(yytext); return YEAR_NUM;}

["`'][a-zA-Z]+(" "[a-zA-Z]+)*["`'] {
    if(yytext[0] == yytext[strlen(yytext)-1]){
        strcpy(yylval.name,yytext+1);
        yylval.name[strlen(yylval.name)-1]='\0';
        return PLAYER_NAME;
    }else{
        fprintf(stderr,"Line %d : Name must start with a character %c and end with the same character !!!\n",yylineno,yytext[0]);
        exit(1);
    }
    }

\<Woman\> {yylval.typeGender = WOMAN; return GENDER; }

\<Man\> {yylval.typeGender = MAN; return GENDER; }

\<name\> {return NAME;}

\<Wimbledon\> { return WIMBLEDON; }

\<Australian" "Open\> { return AUSTRALIAN_OPEN; }

\<French" "Open\>  { return FRENCH_OPEN; }

","  {return ',';}

"-" {return '-';}

[ \n\t\r]+  /* skip white space */

. {fprintf (stderr, "Line %d : unrecognized token %c \n",yylineno,yytext[0]);
   exit(1);}

%%

