package ggc.core;

public class New extends Notification{

	New(String type, Product p, double price){
		super(type, p, price);
	}

	@Override
	public String toString(){
		return "NEW" + "|" + getProduct().getId() + "|" + (int)getPrice();
	}
}