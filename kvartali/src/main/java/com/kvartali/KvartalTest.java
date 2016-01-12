package com.kvartali;

import static org.junit.Assert.*;

import org.junit.Test;

public class KvartalTest {
	
	@Test
	public void testConversionToInteger() {
		//String name, short location, short parks, short crime,
		//short transport, short infrastructure, short facilities, short buildings, short shops, String opinion
		Kvartal tmp = new Kvartal("Банишора", (short)3, (short)3, (short)4, (short)5, (short)4, 
				(short)5, (short)6, (short)4, "от витоша изригва лава");
		int number  = tmp.generateOcenka();
		Kvartal tmp1 = new Kvartal("Банишора", number);
		
		assertEquals(tmp.getLocation(), tmp1.getLocation());
		assertEquals(tmp.getParks(), tmp1.getParks());
		assertEquals(tmp.getCrime(), tmp1.getCrime());
		assertEquals(tmp.getTransport(), tmp1.getTransport());
		assertEquals(tmp.getInfrastructure(), tmp1.getInfrastructure());
		assertEquals(tmp.getFacilities(), tmp1.getFacilities());
		assertEquals(tmp.getBuildings(), tmp1.getBuildings());
		assertEquals(tmp.getShops(), tmp1.getShops());

		
	}

}
