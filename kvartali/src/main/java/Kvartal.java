
public class Kvartal {
	
	private String name;
	private short location;
	private short parks;
	private short crime;
	private short transport;
	private short facilities;
	private short buildings;
	private short shops;
	private String opinion;
	
	
	
	public Kvartal(String name, short location, short parks, short crime,
			short transport, short facilities, short buildings, short shops,
			String opinion) {
		super();
		this.name = name;
		this.location = location;
		this.parks = parks;
		this.crime = crime;
		this.transport = transport;
		this.facilities = facilities;
		this.buildings = buildings;
		this.shops = shops;
		this.opinion = opinion;
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
	
}