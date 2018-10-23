/*
 * The MIT License (MIT)
 * 
 * Copyright (c) 2016 Brian A. Malloy and James F. Power
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 */
%{
/* This scanner is written by James Power, Chris Malloy, and Brian Malloy
 * During Fall, 2016.  
 * Most of the definitions and specifications were taken from:
 * https://docs.python.org/2.7/reference/index.html
 */
#include "stdbool.h"
#include "parse.tab.h"


/* Code to handle locations */
/* This is taken from Chapter 8 - flex & bison by John Levine */
int yycolumn = 1;

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; yylloc.last_column = yycolumn+yyleng-1; \
    yycolumn += yyleng;


static const int NO_TOKEN = -1;       /* Used to indicate that no token is queued */
static const int FIRST_COLUMN = 1;    /* Start a line in column 1 (not 0) */

/* We want to wrap the generated lexer with our own function */
#define YY_DECL int orig_yylex(void)


/* The scanner state: based roughly on the code in the CPython tokeniser */
#define MAXINDENT 100   /* Max indentation level */
struct tok_state {
    int indent;                 /* Current indentation index */
    int indstack[MAXINDENT];    /* Stack of indents */
    int atbol;                  /* Nonzero if at begin of new line */
    int pendin;                 /* Pending indents (if > 0) or dedents (if < 0) */
    int level;                  /* () [] {} Parentheses nesting level */
    /* These next state variables are not in the CPython tokeniser state */
    bool cont_line;             /* are we in a continuation line? */
    bool seen_endmarker;        /* Have we sent the ENDMARKER token yet? */
    int pending_token;          /* One token can be queued while processing indent/dedent */
    bool print_name_hack;       /* Treat print as a 3.x name? (o/w it is a keyword) */
    int long_string_start_line; /* Starting line for a multi-line string */
    int long_string_start_col ; /* Starting column for a multi-line string */
};

static struct tok_state *tok = NULL;

static void display_error(const char *msg);
static void left_enclose(void);
static void right_enclose(void);
static void mark_long_string_start(void) ;
static void mark_long_string_end(void);
static void mark_new_line(void);
static bool explicit_newline(void);
static void handle_eof(void);

/* Some counters, just for information: */
static int keywords = 0;
static int identifiers = 0;
static int numbers = 0;

%}

%option yylineno
%option noyywrap


number    {integer}|{longinteger}|{floatnumber}|{imagnumber}

imagnumber     {imaghead}[jJ]
imaghead       {floatnumber}|{intpart}

floatnumber    {pointfloat}|{expfloat}
expfloat       {expfloat_1}{exponent}
expfloat_1     {expfloat_2}|{pointfloat}
expfloat_2     {nonzero}{digit}*
pointfloat     {pointfloat_1}|{pointfloat_2}
pointfloat_1   {intpart}?{fraction}
pointfloat_2   {intpart}\.
intpart        {nzintpart}|0
nzintpart      {nonzero}{digit}*
fraction       \.{digit}+
exponent       [eE][+-]?{digit}+

longinteger    {integer}[lL]
integer        {decinteger}|{octinteger}|{hexinteger}|{bininteger}
decinteger     {nzointeger}|0
nzointeger     {nonzero}{digit}*
hexinteger     0[xX]{hexdigit}+
octinteger     0[oO]{octdigit}+|0{octdigit}+
bininteger     0[bB]{bindigit}+

digit          [0-9]
nonzero        [1-9]
octdigit       [0-7]
bindigit       [01]
hexdigit       [0-9a-fA-F]

string        {stringprefix}?{stringbody}
stringbody    {shortstring}

stringprefix  {ruprefix}|{rbprefix}
ruprefix      [rRuU][rRuU]?
rbprefix      [rRbB][rRbB]?

shortstring       {shortstring1tck}|{shortstring2tck}
shortstring2tck   \"{shortitem2tck}*\"
shortstring1tck   \'{shortitem1tck}*\'
longstring        {longstring1tck}|{longstring2tck}
longstring2tck    \"\"\"{longitem}*\"\"\"
longstring1tck    \'\'\'{longitem}*\'\'\'

shortitem2tck     {shortchar2tck}|{escapeseq}
shortitem1tck     {shortchar1tck}|{escapeseq}
longitem          {longchar}|{escapeseq}
shortchar2tck     [^\n\r\f\"\\]
shortchar1tck     [^\n\r\f\'\\]
longchar          [^\\]
escapeseq         \\.|\\{newline}

name      [_a-zA-Z][_a-zA-Z0-9]*

ws        [ \t\f]
spaces    {ws}+
stringQQ  [ru]?\"([^\\\"]|\\.)*\"
stringQ   [ru]?\'([^\\\']|\\.)*\'

newline   [\r]?[\n]|[\r]
comment   #.*


/***** Start states for multi-line strings and indentation *****/
%x LONG_STRING
%x LONG_STRING2

%%

  
"print_function"            { /* Hack to allow 2.7 use 3.x print-style function call */
                              tok->print_name_hack = true; return NAME; }

{comment}                   { ; }
{spaces}                    { ; }


{ws}*{comment}?{newline}    { if (explicit_newline()) return NEWLINE; }

"\\"{newline}               {  tok->cont_line = true;  mark_new_line(); /* Explicit line joining: throw it away */ ;  }


{stringprefix}?"'''"        { mark_long_string_start(); BEGIN(LONG_STRING); }
<LONG_STRING>"'''"          { mark_long_string_end(); BEGIN(INITIAL); return STRING; }

{stringprefix}?"\"\"\""     { mark_long_string_start(); BEGIN(LONG_STRING2); }
<LONG_STRING2>"\"\"\""      { mark_long_string_end(); BEGIN(INITIAL); return STRING; }

<LONG_STRING,LONG_STRING2>{newline}    { mark_new_line(); }
<LONG_STRING,LONG_STRING2>{escapeseq}  { ; }
<LONG_STRING,LONG_STRING2>.            { ; }
<LONG_STRING,LONG_STRING2><<EOF>>      { display_error("unterminated long string at EOF"); }

{string}   { return STRING; }


"("        { left_enclose();  return LPAR; }
")"        { right_enclose(); return RPAR; }
"["        { left_enclose();  return LSQB;  }
"]"        { right_enclose(); return RSQB; }
"{"        { left_enclose();  return LBRACE; }
"}"        { right_enclose(); return RBRACE; }

":"        { return COLON; }
","        { return COMMA; }
";"        { return SEMI; }

"+"        { return PLUS; }
"-"        { return MINUS; }
"*"        { return STAR; }
"/"        { return SLASH; }

"<"        { return LESS; }
">"        { return GREATER; }
"="        { return EQUAL; }

"."        { return DOT; }
"%"        { return PERCENT; }
"`"        { return BACKQUOTE; }

"=="       { return EQEQUAL; }
"!="       { return NOTEQUAL; }
"<="       { return LESSEQUAL; }
">="       { return GREATEREQUAL; }
"<>"       { return GRLT; }

"~"        { return TILDE; }
"^"        { return CIRCUMFLEX; }
"<<"       { return LEFTSHIFT; }
">>"       { return RIGHTSHIFT; }
"**"       { return DOUBLESTAR; }

"+="       { return PLUSEQUAL; }
"-="       { return MINEQUAL; }
"*="       { return STAREQUAL; }
"/="       { return SLASHEQUAL; }
"%="       { return PERCENTEQUAL; }
"&="       { return AMPEREQUAL; }
"|"        { return BAR; }
"|="       { return VBAREQUAL; }
"^="       { return CIRCUMFLEXEQUAL; }
"<<="      { return LEFTSHIFTEQUAL; }
">>="      { return RIGHTSHIFTEQUAL; }
"**="      { return DOUBLESTAREQUAL; }
"//"       { return DOUBLESLASH; }
"//="      { return DOUBLESLASHEQUAL; }

"@"        { return AT; }

"and"      { return AND; }
"&"        { return AMPERSAND; }
"not"      { return NOT; }
"or"       { return OR; }
"as"       { return AS; }
"assert"   { return ASSERT; }
"break"    { return BREAK; }
"class"    { return CLASS; }
"continue" { return CONTINUE; }
"def"      { return DEF; }
"del"      { return DEL; }
"elif"     { return ELIF; }
"else"     { return ELSE; }
"except"   { return EXCEPT; }
"exec"     { return EXEC; }
"finally"  { return FINALLY; }
"for"      { return FOR; }
"from"     { return FROM; }
"global"   { return GLOBAL; }
"if"       { return IF; }
"import"   { return IMPORT; }
"in"       { return IN; }
"is"       { return IS; }
"lambda"   { return LAMBDA; }
"pass"     { return PASS; }
"print"    { if (tok->print_name_hack) return NAME; else return PRINT; }
"raise"    { return RAISE; }
"return"   { return RETURN; }
"try"      { return TRY; }
"while"    { return WHILE; }
"with"     { return WITH; }
"yield"    { return YIELD; }

{number}   { ++numbers; return NUMBER; }
{name}     { ++identifiers; return NAME; }

<<EOF>>    { handle_eof(); return ENDMARKER; }

<*>.       { display_error("unknown character"); }


%%



void 
init_scanner(FILE *input_file)
{
  yyin = input_file;
  if (tok != NULL) {
    free(tok);
  }
  /* Calloc a new state (so everything is initialised to 0/false) */
  tok = (struct tok_state *)calloc(1, sizeof(struct tok_state));
  if (tok == NULL) {
    display_error("memory allocation failure in init_scanner");
  }
  tok->pending_token = NO_TOKEN;
  tok->indstack[0] = FIRST_COLUMN;  /* Start column (not 0)  */
}

static void display_error(const char *msg) 
{ 
    fprintf (stderr, "%d.%d-%d.%d:", yylloc.first_line, yylloc.first_column,
                                     yylloc.last_line,  yylloc.last_column);
    fprintf(stderr, " lexical error with [%s]: %s\n", yytext, msg);
    exit(EXIT_FAILURE);
}


static void left_enclose(void)
{
    ++ tok->level;
}

static void right_enclose(void)
{
    -- tok->level;
}

static void mark_long_string_start(void) 
{
    tok->long_string_start_line = yylloc.first_line;
    tok->long_string_start_col =  yylloc.first_column;
}

static void mark_long_string_end(void)
{
    yylloc.first_line = tok->long_string_start_line;
    yylloc.first_column = tok->long_string_start_col;
    tok->long_string_start_line = tok->long_string_start_col = 0;
}

static void mark_new_line(void)
{
    yycolumn = FIRST_COLUMN; 
}

static bool explicit_newline(void)
{
    bool is_explicit_newline = (tok->level == 0) && (tok->cont_line || (yylloc.first_column > FIRST_COLUMN));
    tok->cont_line = false; 
    mark_new_line();
    return is_explicit_newline;
}

static void handle_eof(void)
{
    mark_new_line();     /* Sets current indentation to left margin */
    yylloc.last_column = yylloc.first_column = FIRST_COLUMN;
    tok->atbol = true;   /* Triggers flushing of the indentation stack */
}


/*** Indentation stack handling  ***/

/* Pop the indentation stack until you get back to col, queue DEDENTs */
static void pop_indents(int col)
{
    if ( tok->indent < 0 ) { 
        display_error("(internal) indentation stack underflow");
    }
    else {
        int curr_indent = tok->indstack[tok->indent];
        if (col < curr_indent) { 
            tok->pendin --;  
            tok->indent --;   /* The actual 'pop' */
            pop_indents(col);
        }
        else if (col > curr_indent) {
            display_error("dedent is less than corresponding indent");
        }
        /* else col == curr_indent, and we're done */
    }
}

/* Push col onto the indentation stack, queue an INDENT */
static void push_indent(int col)
{
    tok->pendin ++;  
    tok->indstack[++tok->indent] = col;
}

/* Wrapper that calls push or pop as appropriate */
static void note_new_indent(int col)
{
    int curr_indent = tok->indstack[tok->indent];
    if (col > curr_indent)
        push_indent(col);
    else if (col < curr_indent)
      pop_indents(col);
    /* else col == curr_indent, so do nothing */
}



int yylex(void)
{
    int token = NO_TOKEN;
    if (tok->seen_endmarker)
        yyterminate();
    /* First check for any pending indents or dedents */
    if (tok->pendin < 0) {
        tok->pendin ++;
        token = DEDENT;
    } 
    else if (tok->pendin > 0) {
        tok->pendin --;
        token = INDENT;
    } 
    /* Next check for a pending token */
    else if (tok->pending_token != NO_TOKEN) {
        token = tok->pending_token;
        tok->pending_token = NO_TOKEN;
    }
    /* Finally, call the actual scanner */
    else {
        token = orig_yylex();
        if (token == NEWLINE) { 
            tok->atbol = true; 
        }
        else if (tok->atbol) {
            tok->atbol = false; 
            note_new_indent(yylloc.first_column); 
            tok->pending_token = token;  
            token = yylex();
        }
        /* if we get here then nothing is pending, so just return the token */
    } 
    if (token == ENDMARKER)
        tok->seen_endmarker = true;  /* Wrap up the next time around */
    return token; 
}


/* Debug version: call this to print each token as you get it */
int debug_yylex(void)
{
    int token = yylex();
    printf ("%d.%d-%d.%d:", yylloc.first_line, yylloc.first_column,
                            yylloc.last_line,  yylloc.last_column);
    switch (token) {
        case ENDMARKER: printf(" ENDMARKER\n"); break;
        case INDENT: printf(" INDENT\n"); break;
        case DEDENT: printf(" DEDENT\n"); break;
        case NEWLINE: printf(" NEWLINE\n"); break;
        default: printf(" %d [%s]\n", token, yytext);
    }
    return token;
}

void free_scanner() {
  free(tok);
}
