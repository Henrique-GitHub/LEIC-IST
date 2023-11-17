package ggc.core;

public class Acquisition extends Transaction{
	private double _price;
	private int _date;

	Acquisition(Product prod, int quant, Partner partner, int id, double price){
		super(prod, quant, partner, 0, id);
		_price = price;
		changePaymentStatus();
	}

	void pay(int date){
		setPaymentDate(date);
	}

	boolean isPayed(){
		return true;
	}

	double getBaseValue(){
		return _price * getAmount();
	}

	double getValueToPay(){
		return getBaseValue();
	}

	void updateValueToPay(int date){}

	@Override
    public String toString(){
    	return "COMPRA" + "|" + getId() + "|" + getPartner().getId() + "|" + getProduct().getId() + "|" + getAmount() 
    	+ "|" + (int)getBaseValue() + "|" + getPaymentDate();
    }
}	
