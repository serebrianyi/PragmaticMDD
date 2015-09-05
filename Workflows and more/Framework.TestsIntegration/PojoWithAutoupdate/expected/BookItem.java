package com.test_package;

public class BookItem extends Book {

	private String barcode;

	private int tag;

	private boolean isReferenceOnly;

	private Account borrowedBy;

	private Account reservedBy;

	private Catalog catalog;

	private Library library;

	public String getBarcode() { return barcode; }
	public void setBarcode(String value) { 
		barcode = value;
	}

	public int getTag() { return tag; }
	public void setTag(int value) { 
		tag = value;
	}

	public boolean getIsReferenceOnly() { return isReferenceOnly; }
	public void setIsReferenceOnly(boolean value) { 
		isReferenceOnly = value;
	}


	public Account getBorrowedBy() { return borrowedBy; }
	void setBorrowedByDirect(Account value) { borrowedBy = value; }
	public void setBorrowedBy (Account item) {
		Account prevItem = getBorrowedBy(); 
		if (prevItem == item) return; 
		setBorrowedByDirect(item); 
		if (prevItem != null) prevItem.getBorrowed().remove(this); 
		if (item != null) item.getBorrowed().add(this);
	}

	public Account getReservedBy() { return reservedBy; }
	void setReservedByDirect(Account value) { reservedBy = value; }
	public void setReservedBy (Account item) {
		Account prevItem = getReservedBy(); 
		if (prevItem == item) return; 
		setReservedByDirect(item); 
		if (prevItem != null) prevItem.getReserved().remove(this); 
		if (item != null) item.getReserved().add(this);
	}

	public Catalog getCatalog() { return catalog; }
	void setCatalogDirect(Catalog value) { catalog = value; }
	public void setCatalog (Catalog item) {
		Catalog prevItem = getCatalog(); 
		if (prevItem == item) return; 
		setCatalogDirect(item); 
		if (prevItem != null) prevItem.getRecords().remove(this); 
		if (item != null) item.getRecords().add(this);
	}

	public Library getLibrary() { return library; }
	void setLibraryDirect(Library value) { library = value; }
	public void setLibrary (Library item) {
		Library prevItem = getLibrary(); 
		if (prevItem == item) return; 
		setLibraryDirect(item); 
		if (prevItem != null) prevItem.getBookItems().remove(this); 
		if (item != null) item.getBookItems().add(this);
	}
}