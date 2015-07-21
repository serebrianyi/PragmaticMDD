package com.test_package;

@javax.persistence.Entity
@javax.persistence.Table(name="BOOK_ITEM2")
@javax.persistence.PrimaryKeyJoinColumn(name="ID")
public class BookItem2 extends BookItem {

	@javax.persistence.Column(name="BARCODE2", nullable=false)
	private String barcode2;



	public String getBarcode2() { return barcode2; }
	public void setBarcode2(String value) { 
		barcode2 = value;
	}


}