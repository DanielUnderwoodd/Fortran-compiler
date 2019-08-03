package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%


%class Lexer
%implements  sym
%public
%unicode
%line
%column
%cup
%char

%state STRING



%{


    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }

    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code,
						new Location(yyline+1, yycolumn +1, yychar),
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }

    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }

    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" +
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Identifier = [a-zA-Z][0-9a-zA-Z_]*

integer = [+-]?[0-9]+([edED][+-]?[1-9][0-9]*)?
text = [^\"]

character = [\"](([\%][\"])|{text})*[\"]

LineTerminator = \r|\n|\r\n
whitespace = [ \n\r\t]+


/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}

// %eofval{
//      return symbolFactory.newSymbol("EOF", EOF, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+1,yychar+1));
// %eofval}

%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG


%%


<YYINITIAL> {
//keywords
  {whitespace} {}
  ","               { return symbolFactory.newSymbol("CO", CO); }
  "+"               { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"               { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"               { return symbolFactory.newSymbol("TIMES", TIMES); }
  "n"               { return symbolFactory.newSymbol("UMINUS", UMINUS); }
  "("               { return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"               { return symbolFactory.newSymbol("RPAREN", RPAREN); }
  "function"        { return symbolFactory.newSymbol("FUNCTION", FUNCTION); }
  "end function"    { return symbolFactory.newSymbol("ENDFUNCTION", ENDFUNCTION); }
  "print"           { return symbolFactory.newSymbol("PRINT", PRINT); }
  "read"            { return symbolFactory.newSymbol("READ", READ); }
  "if"              { return symbolFactory.newSymbol("IF", IF); }
  "else"            { return symbolFactory.newSymbol("ELSE", ELSE); }
  "then"            { return symbolFactory.newSymbol("THEN", THEN); }
  "program"         { return symbolFactory.newSymbol("PROGRAM", PROGRAM); }
  "end program"     { return symbolFactory.newSymbol("ENDPROGRAM", ENDPROGRAM); }
  "else"            { return symbolFactory.newSymbol("ELSE", ELSE); }
  "="               { return symbolFactory.newSymbol("EQ",EQ); }  
  "=="              { return symbolFactory.newSymbol("EQ2",EQ2); }  
  "!="              { return symbolFactory.newSymbol("NOTEQ",NOTEQ); } 
  ">"               { return symbolFactory.newSymbol("GT",GT); } 
  ">"               { return symbolFactory.newSymbol("LT",LT); } 
  ">="              { return symbolFactory.newSymbol("GTEQ",GTEQ); } 
  "<="              { return symbolFactory.newSymbol("LTEQ",LTEQ); } 
  "integer"         { return symbolFactory.newSymbol("INT",INT); } 
  "character"       { return symbolFactory.newSymbol("CHARACTER",CHARACTER); } 
  "::"              { return symbolFactory.newSymbol("TPOINT", TPOINT); }
  "implicit none"   { return symbolFactory.newSymbol("IMPLI", IMPLI); }
  "do"              { return symbolFactory.newSymbol("DO",DO); }
  "while"           { return symbolFactory.newSymbol("WHILE",WHILE); }
  "end do"          { return symbolFactory.newSymbol("ENDDO",ENDDO); }
  "else if"         { return symbolFactory.newSymbol("ELSEIF ",ELSEIF); }
  "end if"          { return symbolFactory.newSymbol("ENDIF ",ENDIF); }
  {integer}         { return symbolFactory.newSymbol("INTEGER_LIT", INTEGER_LIT, Integer.parseInt(yytext())); }
  {Identifier}      { return symbolFactory.newSymbol("IDENT",IDENT, yytext()); }
  {character}		{ return symbolFactory.newSymbol("STRING_LIT", STRING_LIT, yytext()); }

}
 






/* error fallback */
[^]                            { throw new Error("Parsing Failed! Illegal character ["+ yytext()+"] at line " + yyline + ", col " + yycolumn); }
