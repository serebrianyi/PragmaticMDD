package com.test_package;

@javax.persistence.Entity
@javax.persistence.Table(name="LIBRARY")
public class Library {

	@javax.persistence.Column(name="NAME", nullable=false)
	private String name;

	@javax.persistence.Column(name="ADDRESS", nullable=false)
	private String address;

	@javax.persistence.GeneratedValue
	@javax.persistence.Id
	@javax.persistence.Column(name="ID", nullable=false)
	private int id;

	@javax.persistence.OneToMany(mappedBy="library", cascade={javax.persistence.CascadeType.PERSIST, javax.persistence.CascadeType.REFRESH})
	private java.util.List<BookItem> bookitems = new java.util.ArrayList<>();

	@javax.persistence.OneToOne(optional=false, mappedBy="library", cascade={javax.persistence.CascadeType.PERSIST, javax.persistence.CascadeType.REFRESH})
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