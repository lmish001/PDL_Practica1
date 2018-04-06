package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
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

Newline    = \r | \n | \r\n
Whitespace = [ \t\f] | {Newline}
NumLiteral = [0-9]*
HexLiteral = [0-9a-fA-F]*
OctLiteral = [0-7]*
Int_Number = {NumLiteral}
Dec_Number = {NumLiteral}"."{NumLiteral} | "."{NumLiteral}
Hex_Number = 0 [xX] [1-9a-fA-F] {HexLiteral}
Oct_Number = 0 [xX] 0 {OctLiteral}

Number = {Int_Number}|{Dec_Number}|{Hex_Number}|{Oct_Number}
Op = "+"|"-"|"*"|"/"
/* comments */
Comment ="%%" {frase}* {Newline}
frase = {palabra} | {palabra} {Whitespace}*
palabra = [A-Za-z0-9]*

/*uminus*/

ident = ([:jletter:] | "_" ) ([:jletterdigit:] | [:jletter:] | "_" )*


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {

  "="          { return symbolFactory.newSymbol("EQ", EQ); }
  ";"          { return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"          { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"          { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"          { return symbolFactory.newSymbol("TIMES", TIMES); }
  "/"		   { return symbolFactory.newSymbol("DIVIDEBY", DIVIDEBY); }
  "n"          { return symbolFactory.newSymbol("UMINUS", UMINUS); }
  "("          { return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"          { return symbolFactory.newSymbol("RPAREN", RPAREN); }
  "exp"        { return symbolFactory.newSymbol("EXP", EXP); }
  "log"        { return symbolFactory.newSymbol("LOG", LOG); }
  "sin"        { return symbolFactory.newSymbol("SIN", SIN); }
  "cos"        { return symbolFactory.newSymbol("COS", COS); }
  "MEM"		   { return symbolFactory.newSymbol("MEM", MEM); }
  {Int_Number} { return symbolFactory.newSymbol("INT_NUMBER", INT_NUMBER, Integer.parseInt(yytext())); }
  {Dec_Number} { return symbolFactory.newSymbol("DEC_NUMBER", DEC_NUMBER, Float.parseFloat(yytext())); }
  {Hex_Number} { return symbolFactory.newSymbol("INT_NUMBER", INT_NUMBER, Integer.parseInt(yytext().substring(2, yytext().length()), 16));}
  {Oct_Number} { return symbolFactory.newSymbol("INT_NUMBER", INT_NUMBER, Integer.parseInt(yytext().substring(3, yytext().length()), 8));}
  {Comment}	   { }
  {Whitespace} {}
  }



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
