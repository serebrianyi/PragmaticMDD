package com.test_package;

@javax.persistence.Entity
@javax.persistence.Table(name="BOOK")
public class Book {

	@javax.persistence.Column(name="I_S_B_N")
	private String ISBN;

	@javax.persistence.Column(name="TITLE", nullable=false)
	private String title;

	@javax.persistence.Column(name="SUMMARY", nullable=false)
	private String summary;

	@javax.persistence.Column(name="PUBLISHER", nullable=false)
	private String publisher;

	@javax.persistence.Column(name="PUBLICATION_DATE", nullable=false)
	private java.util.Date publicationDate;

	@javax.persistence.Column(name="NUMBER_OF_PAGES", nullable=false)
	private int numberOfPages;

	@javax.persistence.Column(name="LANGUAGE", nullable=false)
	private String language;

	@javax.persistence.ManyToMany(mappedBy="wrote", cascade={javax.persistence.CascadeType.PERSIST, javax.persistence.CascadeType.REFRESH})
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