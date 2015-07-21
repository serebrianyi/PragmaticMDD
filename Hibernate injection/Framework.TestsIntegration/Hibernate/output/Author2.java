package com.test_package;

@javax.persistence.Entity
@javax.persistence.Table(name="AUTHOR2")
public class Author2 {

	@javax.persistence.Column(name="NAME2", nullable=false)
	private String name2;

	@javax.persistence.Column(name="BIOGRAPHY2", nullable=false)
	private String biography2;

	@javax.persistence.GeneratedValue
	@javax.persistence.Id
	@javax.persistence.Column(name="ID", nullable=false)
	private int id;



	public String getName2() { return name2; }
	public void setName2(String value) { 
		name2 = value;
	}

	public String getBiography2() { return biography2; }
	public void setBiography2(String value) { 
		biography2 = value;
	}

	public int getId() { return id; }
	public void setId(int value) { 
		id = value;
	}


}