package ggc.core;

public class Bargain extends Notification{

	Bargain(String type, Product p, double price){
		super(type, p, price);
	}

	@Override
	public String toString(){
		return "BARGAIN" + "|" + getProduct().getId() + "|" + (int)getPrice();
	}
}