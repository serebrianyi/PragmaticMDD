package com.test_package;

public class Library {

	private String name;

	private String address;

	private int id;

	private java.util.List<BookItem> bookItems = new java.util.ArrayList<>();

	private Catalog catalog;

	public String getName() { return name; }
	public void setName(String value) { 
		name = value;
	}

	public String getAddress() { return address; }
	public void setAddress(String value) { 
		address = value;
	}

	public int getId() { return id; }
	public void setId(int value) { 
		id = value;
	}


	public java.util.List<BookItem> getBookItems() { return bookItems; }
	void setBookItemsDirect(java.util.List<BookItem> value) { bookItems = value; }
	public void addBookItemsItem(BookItem item) {
	if (item != null) {
			getBookItems().add(item);
			item.setLibraryDirect(this);
		}
	}
	public boolean removeBookItemsItem(BookItem item) {
		if (item != null && getBookItems().remove(item)) {
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