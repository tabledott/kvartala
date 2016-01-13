package com.kvartali;


import java.util.HashMap;
import java.util.LinkedList;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

/*
 * Всеки квартал ще си пази статистиките като при добавяне на нов квартал се преизчисляват и се връщат като
 * double масив.
 */
@Entity 
public class Kvartal implements java.io.Serializable{
	
	private static final long serialVersionUID = -4840857086217453429L;

	@Id
	private Long kvartalId;
	
	private String name;
	public final int NUMBER_STATISTICS = 9; 
	
	short[] sumStatistics;
	short[] countStatistics;

	private LinkedList<String> opinions;
	public short allStatistics;
	
	public Kvartal() {
		super();
		sumStatistics = new short[NUMBER_STATISTICS];
		countStatistics= new short[NUMBER_STATISTICS];
		opinions = new LinkedList<>();
		allStatistics = 0;

	}
	
	public void addKvartal(byte location, byte parks, byte crime,
			byte transport,  byte infrastructure, byte facilities,  byte buildings, byte shops, String opinion){
		if(location>0){
			this.countStatistics[0]++;
			this.sumStatistics[0]+=location;
		}
		if(parks>0){
			this.countStatistics[1]++;
			this.sumStatistics[1]+=parks;
		}
		if(crime>0){
			this.countStatistics[2]++;
			this.sumStatistics[2]+=crime;
		}
		if(transport>0){
			this.countStatistics[3]++;
			this.sumStatistics[3]+=transport;
		}
		if(infrastructure>0){
			this.countStatistics[4]++;
			this.sumStatistics[4]+=infrastructure;
		}
		
		if(facilities>0){
			this.countStatistics[5]++;
			this.sumStatistics[5]+=facilities;
		}
		if(buildings>0){
			this.countStatistics[6]++;
			this.sumStatistics[6]+=buildings;
		}
		if(shops>0){
			this.countStatistics[7]++;
			this.sumStatistics[7]+=shops;
		}
		
		if(opinion!=null && opinion.length() > 0){
			opinions.add(opinion);
		}
		
		// here we count all the evaluations
		allStatistics++;
	}
	
	public double[]  returnStatistics(){
		double[] result = new double[NUMBER_STATISTICS];
		for (int i = 0; i < NUMBER_STATISTICS; i++){
			if(this.countStatistics[i]>0){
				result[i] = (double)this.sumStatistics[i]/this.countStatistics[i];
			}
			else{
				result[i] = 0;
			}
			
			result[i] = Double.parseDouble(String.format( "%.2f", result[i])); 
		}
		//calculate the average result
		for(int j =0; j<7;j++){
			result[8] += result[j];
		}
		result[8]/=7;

		result[8] = Double.parseDouble(String.format( "%.2f", result[8])); 
		
		return result;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

	public LinkedList<String> getOpinion() {
		return opinions;
	}
	public void addOpinion(String opinion) {
		opinions.add(opinion);
	}

	
	//decodirane ot 5-ti4na brojna sistema ot 2 do 6
	/*
	 * public Kvartal(String name, short location, short parks, short crime,
			short transport, short infrastructure, short facilities, short buildings, short shops,
			String opinion) {
		super();
		this.name = name;
		this.opinion = opinion;
	}

	public Kvartal(String name, int ocenka, String opinion){
		statistics = new
		this.setOcenka(ocenka);
		this.name = name;
		this.opinion = opinion;
		
		this.location = (short)(ocenka%5 + 2);
		ocenka/=5;
		this.parks = (short)(ocenka%5 +2);
		ocenka/=5;
		this.crime = (short)(ocenka%5 +2);
		ocenka/=5;
		this.transport = (short)(ocenka%5 +2);
		ocenka/=5;
		this.infrastructure = (short)(ocenka%5 +2);
		ocenka/=5;
		this.facilities = (short)(ocenka%5 + 2);
		ocenka/=5;
		this.buildings = (short)(ocenka%5 + 2);
		ocenka/=5;
		this.shops = (short)(ocenka%5 + 2);
		ocenka/=5;
	} */
	
		/*
	 * Adding kvartal: Kvartal [kvartalId=null, name=Банишора, location=3, parks=4, crime=5, transport=4, infrastructure=5, facilities=3, buildings=3, shops=2, opinion=test]

	 * kvartalId=" + kvartalId + ", name=" + name
				+ ", location=" + location + ", parks=" + parks + ", crime="
				+ crime + ", transport=" + transport + ", infrastructure="
				+ infrastructure + ", facilities=" + facilities
				+ ", buildings=" + buildings + ", shops=" + shops
				+ ", opinion=" + opinion + "]";

	 */
	/*
	public Kvartal(String kvartalfromString){
		String[] data = kvartalfromString.split(",");
		this.name = data[0];
		this.location = Short.parseShort(data[1]);
		this.parks = Short.parseShort(data[2]);
		this.crime = Short.parseShort(data[3]);
		this.transport = Short.parseShort(data[4]);
		this.infrastructure = Short.parseShort(data[5]);
		this.facilities = Short.parseShort(data[6]);
		this.buildings = Short.parseShort(data[7]);
		this.shops = Short.parseShort(data[8]);
		this.opinion = data[9];
	}
	*/
	
	//Дружба 2!&45655!&Италиянския квартал@@@Дружба 1!&6867!&София, мамо, София@@@
	/*public String encodeToString(){
		return this.name+"!&"+this.getOcenka()+"!&"+this.opinion+"@@@";
	}
	*//*
	public int getOcenka() {
		int t = 1;
		int res = 0;
		res+=(this.location-2)*t;
		t*=5;
		res+=(this.parks-2)*t;
		t*=5;
		res+=(this.crime-2)*t;
		t*=5;
		res+=(this.transport-2)*t;
		t*=5;
		res+=(this.infrastructure-2)*t;
		t*=5;
		res+=(this.facilities-2)*t;
		t*=5;
		res+=(this.buildings-2)*t;
		t*=5;
		res+=(this.shops-2)*t;
		t*=5;
		return res;
	}

	public void setOcenka(int ocenka) {
		this.ocenka = ocenka;
	}
	*/
}
