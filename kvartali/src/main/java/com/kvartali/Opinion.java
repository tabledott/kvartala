package com.kvartali;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity 
public class Opinion {
	
	@Id
	public Long opinionId;
	public String kvartal;
	public String comment;
	
}
