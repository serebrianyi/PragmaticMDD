package com.test_package;


public class Account {

	private int number;

	private java.util.Date opened;

	private AccountState state;

	private java.util.List<BookItem> borrowed  = new java.util.ArrayList<>();

	private java.util.List<BookItem> reserved  = new java.util.ArrayList<>();

	public int getNumber() { return number; }
	public void setNumber(int value) { 
		number = value;
	}

	public java.util.Date getOpened() { return opened; }
	public void setOpened(java.util.Date value) { 
		opened = value;
	}

	public AccountState getState() { return state; }
	public void setState(AccountState value) { 
		state = value;
	}


	public java.util.List<BookItem> getBorrowed() { return borrowed; }
	void setBorrowedDirect(java.util.List<BookItem> value) { borrowed = value; }
	public void addBorrowedItem(BookItem item) {
	if (item != null) {
			getBorrowed().add(item);
			item.setBorrowedByDirect(this);
		}
	}
	public boolean removeBorrowedItem(BookItem item) {
		if (item != null && getBorrowed().remove(item)) {
			item.setBorrowedByDirect(null);
			return true;
		}
		return false;
	}

	public java.util.List<BookItem> getReserved() { return reserved; }
	void setReservedDirect(java.util.List<BookItem> value) { reserved = value; }
	public void addReservedItem(BookItem item) {
	if (item != null) {
			getReserved().add(item);
			item.setReservedByDirect(this);
		}
	}
	public boolean removeReservedItem(BookItem item) {
		if (item != null && getReserved().remove(item)) {
			item.setReservedByDirect(null);
			return true;
		}
		return false;
	}
}