package com.kvartali;


import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity 
public class Kvartal {
	
	@Id
	private Long kvartalId;
	
	private String name;
	private short location;
	private short parks;
	private short crime;
	private short transport;
	private short infrastructure;
	private short facilities;
	private short buildings;
	private short shops;
	//w петорна бройна система, за да пазим памет
	private int ocenka;
	private String opinion;
	
	
	public Kvartal() {
		super();
	}
	
	//decodirane ot 5-ti4na brojna sistema ot 2 do 6
	public Kvartal(String name, int ocenka){
		this.ocenka = ocenka;
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
	}
	
	public int generateOcenka(){
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
	
	public Kvartal(String name, short location, short parks, short crime,
			short transport, short infrastructure, short facilities, short buildings, short shops,
			String opinion) {
		super();
		this.name = name;
		this.location = location;
		this.parks = parks;
		this.crime = crime;
		this.transport = transport;
		this.facilities = facilities;
		this.buildings = buildings;
		this.infrastructure = infrastructure;
		this.shops = shops;
		this.opinion = opinion;
	}
	/*
	 * Adding kvartal: Kvartal [kvartalId=null, name=Банишора, location=3, parks=4, crime=5, transport=4, infrastructure=5, facilities=3, buildings=3, shops=2, opinion=test]

	 * kvartalId=" + kvartalId + ", name=" + name
				+ ", location=" + location + ", parks=" + parks + ", crime="
				+ crime + ", transport=" + transport + ", infrastructure="
				+ infrastructure + ", facilities=" + facilities
				+ ", buildings=" + buildings + ", shops=" + shops
				+ ", opinion=" + opinion + "]";

	 */
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public short getLocation() {
		return location;
	}
	public void setLocation(short location) {
		this.location = location;
	}
	public short getParks() {
		return parks;
	}
	public void setParks(short parks) {
		this.parks = parks;
	}
	public short getCrime() {
		return crime;
	}
	public void setCrime(short crime) {
		this.crime = crime;
	}
	public short getTransport() {
		return transport;
	}
	public short getInfrastructure() {
		return infrastructure;
	}
	public void setInfrastructure(short infrastructure) {
		this.infrastructure = infrastructure;
	}
	public void setTransport(short transport) {
		this.transport = transport;
	}
	public short getFacilities() {
		return facilities;
	}
	public void setFacilities(short facilities) {
		this.facilities = facilities;
	}
	public short getBuildings() {
		return buildings;
	}
	public void setBuildings(short buildings) {
		this.buildings = buildings;
	}
	public short getShops() {
		return shops;
	}
	public void setShops(short shops) {
		this.shops = shops;
	}
	public String getOpinion() {
		return opinion;
	}
	public void setOpinion(String opinion) {
		this.opinion = opinion;
	}
	@Override
	public String toString() {
		return "Kvartal [kvartalId=" + kvartalId + ", name=" + name
				+ ", location=" + location + ", parks=" + parks + ", crime="
				+ crime + ", transport=" + transport + ", infrastructure="
				+ infrastructure + ", facilities=" + facilities
				+ ", buildings=" + buildings + ", shops=" + shops
				+ ", opinion=" + opinion + "]";
	}
	
}
