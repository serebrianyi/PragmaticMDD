package com.test_package;

@javax.persistence.Entity
@javax.persistence.Table(name="CATALOG")
public class Catalog {

	@javax.persistence.Column(name="NAME", nullable=false)
	private String name;

	@javax.persistence.OneToMany(mappedBy="catalog", cascade={javax.persistence.CascadeType.PERSIST, javax.persistence.CascadeType.REFRESH})
	private java.util.List<BookItem> records = new java.util.ArrayList<>();

	@javax.persistence.OneToOne(optional=false, cascade={javax.persistence.CascadeType.PERSIST, javax.persistence.CascadeType.REFRESH})
	@javax.persistence.JoinColumn(name="LIBRARY_ID")
	private Library library;

	public String getName() { return name; }
	public void setName(String value) { 
		name = value;
	}


	public java.util.List<BookItem> getRecords() { return records; }
	void setRecordsDirect(java.util.List<BookItem> value) { records = value; }
	public void addRecordsItem(BookItem item) {
	if (item != null) {
			getRecords().add(item);
			item.setCatalogDirect(this);
		}
	}
	public boolean removeRecordsItem(BookItem item) {
		if (item != null && getRecords().remove(item)) {
			item.setCatalogDirect(null);
			return true;
		}
		return false;
	}

	public Library getLibrary() { return library; }
	void setLibraryDirect(Library value) { library = value; }
	public void setLibrary (Library item) {
		Library prevItem = getLibrary(); 
		if (prevItem == item) return; 
		setLibraryDirect(item); 
		if (prevItem != null) prevItem.setCatalogDirect(null); 
		if (item != null) item.setCatalogDirect(this);
	}
}