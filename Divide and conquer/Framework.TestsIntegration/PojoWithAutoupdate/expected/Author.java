package com.test_package;


public class Author {

	private String name;

	private String biography;

	private java.util.List<Book> books  = new java.util.ArrayList<>();

	public String getName() { return name; }
	public void setName(String value) { 
		name = value;
	}

	public String getBiography() { return biography; }
	public void setBiography(String value) { 
		biography = value;
	}


	public java.util.List<Book> getBooks() { return books; }
	private void setBooksDirect(java.util.List<Book> value) { books = value; }
	public void addBooksItem(Book item) {
	if (item != null) {
			getBooks().add(item);
			item.setAuthorDirect(this);
		}
	}
	public boolean removeBooksItem(Book item) {
		if (item != null && getBooks().remove(item)) {
			item.setAuthorDirect(null);
			return true;
		}
		return false;
	}
}