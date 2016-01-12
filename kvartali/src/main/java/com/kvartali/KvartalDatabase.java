package com.kvartali;

import java.util.LinkedList;
import java.util.List;

public class KvartalDatabase {
	//parsed with @@ tag
	// example: Дружба 2,45655,Италиянския квартал@@@6867, София, мамо, София@@
	private List<Kvartal> allKvartali;
	private String rawInfo;
	
	public KvartalDatabase(String rawInfo){
		this.rawInfo = rawInfo;
		allKvartali = new LinkedList<Kvartal>();
	}
	
	public void decodeRawString(){
		String[] kvartals = rawInfo.split("@@@");
		for(int i =0; i < kvartals.length; i++){
			// example: Дружба 2!&45655!&Италиянския квартал@@@Дружба 2!&6867!&София, мамо, София@@@
			// @@@ the separator between the records. 
			// !& the separator between the fields in the record. 
			String[] parsedData = kvartals[i].split("!&"); 
			String name = parsedData[0];
			int encodedKvartalDataNumber = Integer.parseInt(parsedData[1]);	
			String opinion = parsedData[2];
			allKvartali.add(new Kvartal(name,encodedKvartalDataNumber, opinion ));
		}
	}
	
	public List<Kvartal> getAllKvartali() {
		return allKvartali;
	}

	public void setAllKvartali(List<Kvartal> allKvartali) {
		this.allKvartali = allKvartali;
	}
	
}
