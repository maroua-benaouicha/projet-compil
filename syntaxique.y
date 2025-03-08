%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern int yylex();
    extern int nb_line;
    void yyerror(const char *s);
%}

/* Déclaration des types de tokens */
%token MainPrgm var BeginPg EndPg let Int Float Const define
%token if then else do while for from to step input output
%token aff pvg vg dp
%token AO AF PO PF CO CF
%token MINUS MUL DIV plus
%token EQ NEQ sup inf supEQ infEQ
%token AND OR NOT
%token IDF ENTIER REEL CHAR_CONST
%token COMMENT_1L COMMENT_ML

%%

programme:
    MainPrgm IDF var declarations BeginPg AO instructions AF EndPg pvg
    { printf("Programme valide.\n"); }
    ;

declarations:
    declarations declaration
    |/* epsilon */
    ;

declaration:
     let liste_identificateurs dp type pvg
    | let liste_identificateurs dp tableau pvg
    | define Const IDF dp type aff valeur pvg
    ;

liste_identificateurs:
    IDF
    | liste_identificateurs vg IDF
    ;

type:
      Int
    | Float
    ;

tableau:
    CO type pvg ENTIER CF
    ;

valeur:
    ENTIER
    | REEL
    ;

instructions:
    instructions instruction
    | /* epsilon */
    ;

instruction:
     affectation
    | condition
    | boucle
    | entree_sortie
    ;

affectation:
    IDF aff expression pvg
    ;

expression:
      expression plus expression   
    | expression MINUS expression
    | expression MUL expression
    | expression DIV expression
    | IDF
    | ENTIER
    | REEL
    | CHAR_CONST
    | PO expression PF
    |
    ;

condition:
    if PO expression PF then AO instructions AF else AO instructions AF
    ;

boucle:
    do AO instructions AF while PO expression PF pvg
    | for IDF from expression to expression step expression AO instructions AF
    ;

entree_sortie:
    input PO liste_identificateurs PF pvg
    | output PO liste_identificateurs PF pvg /* a verifier*/
    ;

%%

void yyerror(const char *s) {
    printf("Erreur syntaxique à la ligne %d: %s\n", nb_line, s);
}

int main() {
    printf("Analyse syntaxique en cours...\n");
    yyparse();
    printf("Analyse syntaxique terminée.\n");
    return 0;
}

