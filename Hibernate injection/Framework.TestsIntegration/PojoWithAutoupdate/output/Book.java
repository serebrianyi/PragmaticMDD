package com.test_package;

public class Book {

	private String ISBN;

	private String title;

	private Author author;

	public String getISBN() { return ISBN; }
	public void setISBN(String value) { 
		ISBN = value;
	}

	public String getTitle() { return title; }
	public void setTitle(String value) { 
		title = value;
	}


	public Author getAuthor() { return author; }
	void setAuthorDirect(Author value) { author = value; }
	public void setAuthor (Author item) {
		Author prevItem = getAuthor(); 
		if (prevItem == item) return; 
		setAuthorDirect(item); 
		if (prevItem != null) prevItem.getBooks().remove(this); 
		if (item != null) item.getBooks().add(this);
	}
}