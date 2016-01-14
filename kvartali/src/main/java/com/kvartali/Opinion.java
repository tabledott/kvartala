package com.kvartali;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity 
public class Opinion {
	
	@Id
	public Long opinionId;
	public String kvartal;
	public String comment;

	public Opinion(){
		this.kvartal = "";
		this.comment = "";
	}
	
	public Opinion(String kvartal, String comment){
		this.kvartal = kvartal;
		this.comment = comment;
	}
	
	public String getKvartal() {
		return kvartal;
	}
	public void setKvartal(String kvartal) {
		this.kvartal = kvartal;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	
}
