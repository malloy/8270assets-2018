%{
/* TERMINOLOGY: A "word" is a set of non-delimiters seperated by delimiters.
 *              -- edge case 1: files with a word and no delimiters
 *              -- edge case 2: last word of the file
 *              -- edge case 3: leading delimiters
 *              -- edge case 4: files with only delimiters
 *
 *              A "line" is a newline character \n.
 *              -- Weirdly, a file written on one line with no newline
 *                 character at the end is considered to have ZERO lines
 *
 *              A "char" is ANY character in the file (delimiters and non-delimiters).
 */ 

#include <iostream>
#include <cstring>
  int words = 0; // count of words
  int chars = 0; // count of chars
  int lines = 0; // count of lines
%}

%option noinput
%option nounput

/* definition of characters that DO NOT compose words
 * ~ spaces, tabs, and newlines
 */
delimiter [ \t\n]

/* definition of characters that DO compose words
 * ~ everything but spaces, stabs, and newlines
 */
letter    [^ \t\n]

%%
   /* This rule is for the edge-case that delimiters appear
    * at the front of the file or the file has only delimiters.
    */
{delimiter}+ {
   chars += strlen(yytext);

   for(int i = 0; yytext[i]; ++i)
      if(yytext[i] == '\n') ++lines;
}

   /* This rule is for typical cases, files with one word
    * and no delimiters, and the last word of the file.
    *
    * Note that we use the closure set of delimiters, not the
    * the positive closure set. What would happen if we made this change?
    */
{letter}+{delimiter}* {
   ++words;
   chars += strlen(yytext);

   for(int i = 0; yytext[i]; ++i)
      if(yytext[i] == '\n') ++lines;
}
%%
int yywrap() { return 1; }

