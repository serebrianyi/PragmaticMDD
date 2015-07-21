package com.test_package;

@javax.persistence.Entity
@javax.persistence.Table(name="BOOK_ITEM3")
@javax.persistence.PrimaryKeyJoinColumn(name="ID")
public class BookItem3 extends Book {

	@javax.persistence.Column(name="BARCODE3", nullable=false)
	private String barcode3;



	public String getBarcode3() { return barcode3; }
	public void setBarcode3(String value) { 
		barcode3 = value;
	}


}