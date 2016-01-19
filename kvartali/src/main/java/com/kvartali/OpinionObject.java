package com.kvartali;

import java.util.HashSet;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity 
public class OpinionObject implements java.io.Serializable {
	
	private static final long serialVersionUID = -5858905410084127835L;

	@Id
	public String name;
	
	private String businessCategory;
	private String businessAddress;
	private HashSet<String> opinions;
	
	private short counterEvaluation;
	private short sumEvaluation;
	
	public OpinionObject() {
		super();
		name = "";
		businessCategory = "";
		businessAddress = "";
		sumEvaluation = 0;
		counterEvaluation = 0;
		this.opinions = new HashSet<String>();
	}
	
	public OpinionObject(String name){
		this.name = name;
	}
	
	public double getMark(){
		if (counterEvaluation == 0)
			return 0;
		return sumEvaluation/counterEvaluation;
	}
	
	public void AddOpinionObject(String name, String businessCategory, String businessAddress, String opinion, int mark) {
		this.name = name;
		this.businessCategory = businessCategory;
		this.businessAddress = businessAddress;
		if(opinion!=null && opinion.length() > 0){
			this.opinions.add(opinion);
		}
		this.counterEvaluation++;
		this.sumEvaluation+=mark;
	}
	
	
}
