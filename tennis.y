%code {
#include <stdio.h>
#include <string.h>

extern int yylex(void);
void yyerror(const char *s);

struct player max_win (struct player player1, struct player player2);
int calculateYears(int year1, int year2);

}

%code requires {

    enum constants { MAX_SIZE = 50 };
    enum gender {MAN,WOMAN};

       
     struct player {
        int timesInWimbledon;
        char namePlayer[MAX_SIZE];
    };
}    

%union {
    int year;
    char name[MAX_SIZE];
    int timesWins;
    enum gender typeGender;
    struct player _player;
}


%token TITLE WIMBLEDON AUSTRALIAN_OPEN FRENCH_OPEN COMMA THROUGH NAME 
%token <year> YEAR_NUM
%token <name> PLAYER_NAME
%token <typeGender> GENDER

%nterm <timesWins> optional_wimbledon list_of_years year_spec
%nterm <_player> list_of_players player

%define parse.error verbose

%%

input: TITLE list_of_players { if ($2.timesInWimbledon == 0) {
             printf ("We don't have woman that win in Wimbledon\n");}
         else{
             printf ("Woman with greatest number of wins at Wimbledon: %s (%d wins)\n",
                            $2.namePlayer, $2.timesInWimbledon);}
       };


list_of_players:list_of_players player 
       {$$ = max_win($1, $2);};

list_of_players:player
       {
         $$ = $1;
        };

player:NAME PLAYER_NAME GENDER 
       optional_wimbledon optional_australian_open optional_french_open 
       { 
       if( $3 == WOMAN ){
         $$.timesInWimbledon = $4;
         strcpy($$.namePlayer,$2);
         }else
          $$.timesInWimbledon = 0;
       };

optional_wimbledon: WIMBLEDON list_of_years {$$ = $2;};
                    | %empty{$$ = 0;};

optional_australian_open: AUSTRALIAN_OPEN list_of_years {};
                          | %empty{};

optional_french_open: FRENCH_OPEN list_of_years {};
                      | %empty{};    
                          
list_of_years: list_of_years ',' year_spec { $$ = $1 + $3 ; };

list_of_years: year_spec { $$ = $1; };

year_spec: YEAR_NUM { $$ = 1; } 
    | YEAR_NUM '-' YEAR_NUM { $$ = calculateYears($1, $3); } ;

%%

int main(int argc, char **argv)
{
    extern FILE *yyin;
    if (argc != 2) 
    {
        fprintf(stderr, "Usage: ./%s <input-file-name>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) 
    {
        fprintf(stderr, "failed to open %s\n", argv[1]);
        return 1;
    }

    yyparse();
    
    fclose(yyin);
    return 0;
}

void yyerror(const char *s)
{
    extern int yylineno;
    fprintf(stderr, "line %d: %s\n", yylineno, s);
}


int calculateYears(int year1, int year2)
{
   return (year2-year1)+1;
}

struct player max_win (struct player player1, struct player player2)
{       
   return player1.timesInWimbledon >= player2.timesInWimbledon ? player1 : player2;
}
