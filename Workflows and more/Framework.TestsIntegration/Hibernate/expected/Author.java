package com.test_package;

@javax.persistence.Entity
@javax.persistence.Table(name="AUTHOR")
public class Author {

	@javax.persistence.Column(name="NAME", nullable=false)
	private String name;

	@javax.persistence.Column(name="BIOGRAPHY", nullable=false)
	private String biography;

	@javax.persistence.GeneratedValue
	@javax.persistence.Id
	@javax.persistence.Column(name="ID", nullable=false)
	private int id;

	@javax.persistence.ManyToMany(cascade={javax.persistence.CascadeType.PERSIST, javax.persistence.CascadeType.REFRESH})
	@javax.persistence.JoinTable(
		name="AUTHOR_BOOK",
		joinColumns={@javax.persistence.JoinColumn(name="AUTHORS_ID")},
		inverseJoinColumns={@javax.persistence.JoinColumn(name="WROTE_ID")})
	private java.util.List<Book> wrote = new java.util.LinkedHashSet<>();

	public String getName() { return name; }
	public void setName(String value) { 
		name = value;
	}

	public String getBiography() { return biography; }
	public void setBiography(String value) { 
		biography = value;
	}

	public int getId() { return id; }
	public void setId(int value) { 
		id = value;
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