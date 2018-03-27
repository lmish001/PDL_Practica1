package cup.example;

import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;


import java_cup.runtime.*;

class Driver_example{
	public static void main(String[] args) throws Exception {
		InputStream dataStream = System.in;
		Reader r;
		
		if(args.length >= 1) {
			System.out.println("Leyendo entrada de fichero...");
			//dataStream = new FileInputStream(args[0]);
			r = new InputStreamReader(new FileInputStream(args[0]), "UTF8");
		}else {
			System.out.println("No se ha insertado expresión");
		}
		
		//creamos el objeto scanner

		IntroLex scanner = new IntroLex(r);
		ArrayList<Symbol> symbols = new ArrayList<Symbol>();
		boolean end = false;
		while (!end) {
			//mientras no alcancemo el fin de la entrada
			try {
				Symbol token = scanner.next_token();
				symbols.add(token);
				end = (token==null);
				if(!end)System.out.println("Encontrado: {"+token.sym+"} >> "+token.value);
			}catch (Exception e) {
				System.out.println("Algo ha ido mal");
				e.printStackTrace();
			}	
		}
		
		symbols.trimToSize();
		System.out.println("\n\n --Adiós--");
	}
	
}