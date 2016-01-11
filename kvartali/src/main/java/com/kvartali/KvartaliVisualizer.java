package com.kvartali;
import java.util.Arrays;
import java.util.LinkedList;

public class KvartaliVisualizer {
	private int[] sumStatistics;
	private int[] countStatistics;
	public double[] averages;
	
	public String name;
	private LinkedList<String> opinions;
	public final int NUMBER_STATISTICS = 10; 
	
	public KvartaliVisualizer(int[] sumStatistics, int[] countStatistics,
			String name, LinkedList<String> opinions) {
		super();
		this.sumStatistics = sumStatistics;
		this.countStatistics = countStatistics;
		this.name = name;
		this.opinions = opinions;
	}
	
	public KvartaliVisualizer(String name){
		this.name = name;
		this.opinions = new LinkedList<String>();
		this.sumStatistics = new int[NUMBER_STATISTICS];
		this.countStatistics = new int[NUMBER_STATISTICS];
		this.averages = new double[NUMBER_STATISTICS];
	}
	
	/* In this order
	 * <th>Местоположение</th>      
	  <th>Паркове, зеленина</th>
	  <th>Престъпност</th>
	  <th>Инфраструктура</th>
	  <th>Транспорт</th>
	  <th>Публични сгради</th>
	  <th>Сграден фонд</th>
	  <th>Магазини</th>
	  <th>Средна оценка</th>
	  <th>Брой мнения</th>
	 */
	public void addKvartal(Kvartal kvartal){
		if(kvartal.getLocation()>0){
			this.countStatistics[0]++;
			this.sumStatistics[0]+=kvartal.getLocation();
		}
		if(kvartal.getParks()>0){
			this.countStatistics[1]++;
			this.sumStatistics[1]+=kvartal.getParks();
		}
		if(kvartal.getCrime()>0){
			this.countStatistics[2]++;
			this.sumStatistics[2]+=kvartal.getCrime();
		}
		if(kvartal.getInfrastructure()>0){
			this.countStatistics[3]++;
			this.sumStatistics[3]+=kvartal.getInfrastructure();
		}
		if(kvartal.getTransport()>0){
			this.countStatistics[4]++;
			this.sumStatistics[4]+=kvartal.getTransport();
		}
		if(kvartal.getFacilities()>0){
			this.countStatistics[5]++;
			this.sumStatistics[5]+=kvartal.getFacilities();
		}
		if(kvartal.getBuildings()>0){
			this.countStatistics[6]++;
			this.sumStatistics[6]+=kvartal.getBuildings();
		}
		if(kvartal.getShops()>0){
			this.countStatistics[7]++;
			this.sumStatistics[7]+=kvartal.getShops();
		}
		
		for(int i =0; i<7;i++){
			this.sumStatistics[8] += this.sumStatistics[i];
		}

		this.countStatistics[8]=1;
		// here we count all the evaluations
		this.countStatistics[9]++;
		
		this.opinions.add(kvartal.getOpinion());
	}
	
	public void visualize(){
		for (int i = 0; i < NUMBER_STATISTICS; i++){
			if(this.countStatistics[i]>0){
				this.averages[i] = (double)this.sumStatistics[i]/this.countStatistics[i];
			}
			else{
				this.averages[i] = 0;
			}
		}
		this.averages[9] = this.countStatistics[9];
	}
	
	public void addOpinion(String opinion){
		opinions.push(opinion);
	}

	@Override
	public String toString() {
		return "KvartaliVisualizer [sumStatistics="
				+ Arrays.toString(sumStatistics) + ", countStatistics="
				+ Arrays.toString(countStatistics) + ", averages="
				+ Arrays.toString(averages) + ", name=" + name + ", opinions="
				+ opinions + ", NUMBER_STATISTICS=" + NUMBER_STATISTICS + "]";
	}
	
}
