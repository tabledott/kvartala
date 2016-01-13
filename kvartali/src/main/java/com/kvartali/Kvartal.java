package com.kvartali;


import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;

import com.googlecode.objectify.Ref;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

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
		this.opinions = new LinkedList<String>();
		allStatistics = 0;

	}
	
	//used to generate sample starting data
	public Kvartal(String name, double location, double parks, double crime,
			double transport,  double infrastructure, double facilities,  double buildings, double shops, int numOpinions){
		this.name = name;
		sumStatistics = new short[NUMBER_STATISTICS];
		countStatistics= new short[NUMBER_STATISTICS];
		this.opinions = new LinkedList<String>();
		
		sumStatistics[0] = (short) (location * numOpinions);
		sumStatistics[1] = (short) (parks * numOpinions);
		sumStatistics[2] = (short) (crime * numOpinions);
		sumStatistics[3] = (short) (transport * numOpinions);
		sumStatistics[4] = (short) (infrastructure * numOpinions);
		sumStatistics[5] = (short) (facilities * numOpinions);
		sumStatistics[6] = (short) (buildings * numOpinions);
		sumStatistics[7] = (short) (shops * numOpinions);
		
		for(int i = 0; i < 8; i++) {
			countStatistics[i] = (short)numOpinions;
		}
		allStatistics = (short)numOpinions;
	}
	
	public void addKvartal(String name, byte location, byte parks, byte crime,
			byte transport,  byte infrastructure, byte facilities,  byte buildings, byte shops, String opinion){
		this.name = name;
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
			this.opinions.add(opinion);
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
		short counter = 0;
		for(int j =0; j<7;j++){
			if(result[j] > 0) {
				counter++;
			}
			result[8] += result[j];
		}
		
		if(counter > 0)
			result[8]/=counter;
		else
			result[8] = 0;

		result[8] = Double.parseDouble(String.format( "%.2f", result[8])); 
		
		return result;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

	public void addOpinion(String opinion) {
		this.opinions.add(opinion);
	}

	@Override
	public String toString() {
		return "Kvartal [name=" + name + ", sumStatistics="
				+ Arrays.toString(sumStatistics) + ", countStatistics="
				+ Arrays.toString(countStatistics) + ", opinions=" + opinions
				+ ", allStatistics=" + allStatistics + "]";
	}

}
