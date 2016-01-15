package com.kvartali;

import java.util.Date;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity 
public class Opinion implements java.io.Serializable {
	
	@Id
	public Long opinionId;
	
	public String kvartal;
	public String comment;
	public Date date;

	public Opinion(){
		this.kvartal = "";
		this.comment = "";
	}
	
	public Opinion(String kvartal, String comment, Date date){
		this.kvartal = kvartal;
		this.comment = comment;
		this.date = date;
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

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}
	
}
