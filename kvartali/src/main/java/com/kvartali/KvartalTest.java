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
		int number  = tmp.getOcenka();
		Kvartal tmp1 = new Kvartal("Банишора", number, "от витоша изригва лава");
		
		assertEquals(tmp.getLocation(), tmp1.getLocation());
		assertEquals(tmp.getParks(), tmp1.getParks());
		assertEquals(tmp.getCrime(), tmp1.getCrime());
		assertEquals(tmp.getTransport(), tmp1.getTransport());
		assertEquals(tmp.getInfrastructure(), tmp1.getInfrastructure());
		assertEquals(tmp.getFacilities(), tmp1.getFacilities());
		assertEquals(tmp.getBuildings(), tmp1.getBuildings());
		assertEquals(tmp.getShops(), tmp1.getShops());
		
	}
	
	@Test
	public void testEncodeRawString()
	{
		//Дружба 2!&45655!&Италиянския квартал@@@
		Kvartal tmp = new Kvartal("Дружба 2", 45655, "Италиянския квартал");
	
		KvartalDatabase tmp1 = new KvartalDatabase(tmp.encodeToString());
		tmp1.decodeRawString();

		assertEquals(tmp1.getAllKvartali().get(0).getOcenka(),45655);
		assertEquals(tmp1.getAllKvartali().get(0).getName(),"Дружба 2");
		assertEquals(tmp1.getAllKvartali().get(0).getOpinion(),"Италиянския квартал");

	}
	
	@Test
	public void testDecodeRawString(){
		
		
		KvartalDatabase tmp = new KvartalDatabase("Дружба 2!&45655!&Италиянския квартал@@@Дружба 1!&6867!&София, мамо, София@@@");
		tmp.decodeRawString();
		assertEquals(tmp.getAllKvartali().get(0).getOcenka(),45655);
		assertEquals(tmp.getAllKvartali().get(0).getName(),"Дружба 2");
		assertEquals(tmp.getAllKvartali().get(0).getOpinion(),"Италиянския квартал");

		assertEquals(tmp.getAllKvartali().get(1).getOcenka(),6867);
		assertEquals(tmp.getAllKvartali().get(1).getName(),"Дружба 1");
		assertEquals(tmp.getAllKvartali().get(1).getOpinion(),"София, мамо, София");
	
	}
	
}
