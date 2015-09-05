package com.test_package;

public class Book {

	private String ISBN;

	private String title;

	private String summary;

	private String publisher;

	private java.util.Date publicationDate;

	private int numberOfPages;

	private String language;

	private int id;

	private java.util.List<Author> authors = new java.util.LinkedHashSet<>();

	public String getISBN() { return ISBN; }
	public void setISBN(String value) { 
		ISBN = value;
	}

	public String getTitle() { return title; }
	public void setTitle(String value) { 
		title = value;
	}

	public String getSummary() { return summary; }
	public void setSummary(String value) { 
		summary = value;
	}

	public String getPublisher() { return publisher; }
	public void setPublisher(String value) { 
		publisher = value;
	}

	public java.util.Date getPublicationDate() { return publicationDate; }
	public void setPublicationDate(java.util.Date value) { 
		publicationDate = value;
	}

	public int getNumberOfPages() { return numberOfPages; }
	public void setNumberOfPages(int value) { 
		numberOfPages = value;
	}

	public String getLanguage() { return language; }
	public void setLanguage(String value) { 
		language = value;
	}

	public int getId() { return id; }
	public void setId(int value) { 
		id = value;
	}


	public java.util.List<Author> getAuthors() { return authors; }
	void setAuthorsDirect(java.util.List<Author> value) { authors = value; }
	public void addAuthorsItem(Author item) {
	if (item != null) {
			getAuthors().add(item);
			item.getWrote().add(this);
		}
	}
	public boolean removeAuthorsItem(Author item) {
		if (item != null && getAuthors().remove(item)) {
			item.getWrote().remove(this);
			return true;
		}
		return false;
	}
}