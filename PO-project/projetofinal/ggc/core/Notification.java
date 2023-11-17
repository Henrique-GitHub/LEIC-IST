package ggc.core;

public abstract class Notification{
	private String _type;
	private Product _product;
	private double _price;

	Notification(String type, Product p, double price){
		_type = type;
		_product = p;
		_price = price;
	}

	String getType(){
		return _type;
	} 

	Product getProduct(){
		return _product;
	} 

	double getPrice(){
		return _price;
	} 
}