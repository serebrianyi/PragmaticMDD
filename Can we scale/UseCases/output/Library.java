package com.test_package;


public class Library {

	private String name;

	private String address;

	private java.util.List<BookItem> bookitems  = new java.util.ArrayList<>();

	private Catalog catalog ;

	public String getName() { return name; }
	public void setName(String value) { 
		name = value;
	}

	public String getAddress() { return address; }
	public void setAddress(String value) { 
		address = value;
	}


	public java.util.List<BookItem> getBookitems() { return bookitems; }
	void setBookitemsDirect(java.util.List<BookItem> value) { bookitems = value; }
	public void addBookitemsItem(BookItem item) {
	if (item != null) {
			getBookitems().add(item);
			item.setLibraryDirect(this);
		}
	}
	public boolean removeBookitemsItem(BookItem item) {
		if (item != null && getBookitems().remove(item)) {
			item.setLibraryDirect(null);
			return true;
		}
		return false;
	}

	public Catalog getCatalog() { return catalog; }
	void setCatalogDirect(Catalog value) { catalog = value; }
	public void setCatalog (Catalog item) {
		Catalog prevItem = getCatalog(); 
		if (prevItem == item) return; 
		setCatalogDirect(item); 
		if (prevItem != null) prevItem.setLibraryDirect(null); 
		if (item != null) item.setLibraryDirect(this);
	}
}