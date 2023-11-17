package ggc.core;

import java.io.Serializable;

public abstract class Transaction implements Serializable{
    private static final long serialVersionUID = 202109340609L;
    private int _paymentDate;
    private Partner _partner;
    private double _toPay;
    private Product _product;
    private int _amount;
    private int _id;
    private boolean _isPayed;
    private int _paymentDeadline;



    Transaction (Product prod, int amount, Partner partner, int deadline, int id){
        _partner = partner;
        _product = prod;
        _amount = amount;
        _id = id;
        _paymentDeadline = deadline;
    }
    
    int getId(){
        return _id;
    }

    Partner getPartner(){
        return _partner;
    }
    
    int getPaymentDate(){
        return _paymentDate;
    }

    void setPaymentDate(int date){
        _paymentDate = date;
    }

    Product getProduct(){
        return _product;
    }

    boolean getPaymentStatus(){
        return _isPayed;
    }

    void changePaymentStatus(){
        _isPayed = true;
    }

    int getPaymentDeadline(){
        return _paymentDeadline;
    }

    int getAmount(){
        return _amount;
    }

    abstract void pay(int date);

    abstract boolean isPayed();

    abstract double getBaseValue();

    abstract double getValueToPay();

    abstract void updateValueToPay(int date);
}
