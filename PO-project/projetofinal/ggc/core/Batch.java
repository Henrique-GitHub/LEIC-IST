package ggc.core;

import java.io.Serializable;

public class Batch implements Serializable{
	/** Serial number for serialization. */
  	private static final long serialVersionUID = 202109192007L;
  	
	private double _price;
	private int _quantity;
	private Product _product;
	private Partner _partner;

	/**
	 * @param p
	 * @param q
	 * @param prod
	 * @param partn
	 * Initializes an object of Batch class
	 * */
	Batch(double p, int q, Product prod, Partner partn){
		_price = p;
		_quantity = q;
		_product = prod;
		_partner = partn;
	}

	Product getProduct(){
		return _product;
	}

	Partner getPartner(){
		return _partner;
	}

	int getQuantity(){
		return _quantity;
	}

	double getPrice(){
		return _price;
	}

	void changeQuantity(int q){
		_quantity += q;
	}

	/**
	 * Returns the string that represents the Batch
	 * */
	@Override
	public String toString(){
		return _product.getId() + "|" + _partner.getId() + "|" + (int)_price + "|" + _quantity;
	}   
}