%{  #include "syntaxique.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int nb_line = 1;
    int est_identificateur_valide(char* idf) {
    if (strlen(idf) > 14) {
        return 0; // Erreur : plus de 14 caractères
    }
    for (int i = 0; i < strlen(idf) - 1; i++) {
        if (idf[i] == '_' && idf[i + 1] == '_') {
            return 0; // Erreur : underscores consécutifs
        }
    }
    return 1; // Identificateur valide
}
%}

letter      [a-zA-Z]
chiffre     [0-9]
ERREUR_UNDERSCORE {letter}({letter}|{chiffre}|_)*_ { printf("Erreur lexicale (Ligne %d): Identificateur ne peut pas se terminer par '_'\n", nb_line); }
IDF [a-z][a-z0-9_]*([a-z0-9])?
cst         {chiffre}+
entier      [-]?{chiffre}+
reel        [-]?{chiffre}+"."{chiffre}+
char_const  "'"([^'\n]*)"'"  
comment_1l  "<!-".*"-!>"
comment_ml  "{--"(.|\n)*"--}"

%%


MainPrgm      {printf("Mot cle: %s\n", yytext);}
Var           {printf("Mot cle: %s\n", yytext);}
BeginPg       {printf("Mot cle: %s\n", yytext);}
EndPg         { printf("Mot cle: %s\n", yytext);}


let           {printf("Mot cle: %s\n", yytext);}
Int           {printf("Mot clé: %s\n", yytext );}
Float         {printf("Mot clé: %s\n", yytext);}

@define       {printf("Mot clé: %s\n", yytext);}
Const         {printf("Mot cle: %s\n", yytext);}

if            {printf("Mot cle: %s\n", yytext);}
then          {printf("Mot cle: %s\n", yytext);}
else          {printf("Mot cle: %s\n", yytext);}

do            {printf("Mot cle: %s\n", yytext);}
while         {printf("Mot cle: %s\n", yytext);}

for           {printf("Mot cle: %s\n", yytext);}
from          {printf("Mot cle: %s\n", yytext);}
to            {printf("Mot cle: %s\n", yytext);}
step          {printf("Mot cle: %s\n", yytext);}

input         {printf("Mot cle: %s\n", yytext);}
output        {printf("Mot cle: %s\n", yytext);}


":="          printf("Aff: %s\n", yytext);
";"          printf("pvg\n");
","          printf("vg\n");
":"          printf("dp\n");
"{"          printf("ao\n");
"}"          printf("af\n");
"("          printf("po\n");
")"          printf("pf\n");
"["          printf("co\n");
"]"          printf("cf\n");

"+"          printf("plus\n");
"-"          printf("minus\n");
"*"          printf("mul\n");
"/"          printf("div\n");

"=="         printf("eq\n");
"!="         printf("neq\n");
">"          printf("sup\n");
"<"          printf("inf\n");
">="         printf("supeq\n");
"<="         printf("infeq\n");

"AND"        printf("and\n");
"OR"         printf("or\n");
"!"          printf("not\n");


{char_const} { printf("Constante chaine: %s\n", yytext); }
{cst}        { printf("Constante: %s\n", yytext); }
{entier}     { printf("Entier: %s\n", yytext); }
{reel}       { printf("Reel: %s\n", yytext); }


{comment_1l} { printf("Commentaire une ligne\n"); }
{comment_ml} { printf("Commentaire multi-lignes\n"); }


{IDF} {
    if (est_identificateur_valide(yytext)) {
        printf("Identificateur: %s\n", yytext);
    } else {
        printf("Erreur: Identificateur invalide (%s)\n", yytext);
    }
}


[ \t] { /* Ignorer les espaces */ }


\n { nb_line++; }


. { printf("Erreur lexicale: Caractere invalide '%s'\n", yytext); }

%%

int yywrap() {
    return 1;
}
int main() {
    printf("Analyse lexicale en cours...\n");
    yylex();
    printf("Analyse terminee.\n");
    return 0;
}
