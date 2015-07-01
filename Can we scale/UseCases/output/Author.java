package com.test_package;


public class Author {

	private String name;

	private String biography;

	private java.util.List<Book> wrote  = new java.util.ArrayList<>();

	public String getName() { return name; }
	public void setName(String value) { 
		name = value;
	}

	public String getBiography() { return biography; }
	public void setBiography(String value) { 
		biography = value;
	}


	public java.util.List<Book> getWrote() { return wrote; }
	void setWroteDirect(java.util.List<Book> value) { wrote = value; }
	public void addWroteItem(Book item) {
	if (item != null) {
			getWrote().add(item);
			item.getAuthors().add(this);
		}
	}
	public boolean removeWroteItem(Book item) {
		if (item != null && getWrote().remove(item)) {
			item.getAuthors().remove(this);
			return true;
		}
		return false;
	}
}