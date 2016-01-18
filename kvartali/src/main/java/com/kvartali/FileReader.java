package com.kvartali;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.LinkedList;

public class FileReader {

	public FileReader(){
	}
	
	public LinkedList<String> readListFromFile(String fileName){
		LinkedList<String> result = new LinkedList<String>();
		BufferedReader br = null;
		try {
			String sCurrentLine;
			br = new BufferedReader(
					   new InputStreamReader(
			                      new FileInputStream("kvartali.txt"), "UTF-8"));
			while ((sCurrentLine = br.readLine()) != null) {
				result.add(sCurrentLine);
			}
	
		}
		catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (br != null)br.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		
		return result;
	}
}
