package ggc.core;

public class Component{
	public Product _product;
	public int _quantity;

	Component(Product p, int q){
		_product = p;
		_quantity = q;
	}

	int getQuantity(){
		return _quantity;
	}

	Product getProduct(){
		return _product;
	}
}