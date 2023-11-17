package ggc.core;

import java.util.List;
import java.util.ArrayList;
import java.io.Serializable;


public class Partner implements Observer, Serializable{
	/** Serial number for serialization. */
  	private static final long serialVersionUID = 202109192008L;
  	
	private String _name;
	private String _address;
	private String _id;
	private String _status = "NORMAL";
	private int _points;
	private List<Acquisition>_acquisitions = new ArrayList<>();
	private List<Sale>_sales = new ArrayList<>();
	private List<Notification>_notifications = new ArrayList<>();

	/**
	 * @param id
	 * @param name
	 * @param address
	 * Initializes an object of Product class
	 * */
	Partner(String id, String name, String address){
		_id = id;
		_name = name;
		_address = address;
	} 		

	String getId(){
		return _id;
	}

	String getName(){
		return _name;
	}

	String getAddress(){
		return _address;
	}

	String getStatus(){
		return _status;
	}

	int getPoints(){
		return _points;
	}

	int getSalesValue(){
		int total = 0;

		for(Sale s : _sales)  total += s.getValueToPay();
		return total;
	}

	int getPayedSales(){
		int total = 0;

		for(Sale s : _sales){
			if (s.isPayed()) total += s.getValueToPay();
		}
		return total;
	}

	List<Notification> getNotifications(){
		return _notifications;
	}

	List<Acquisition> getAcquisitions(){
		return _acquisitions;
	}

	List<Sale> getSales(){
		return _sales;
	}

	int getAcquisitionValue(){
		int total = 0;

		for(Acquisition a : _acquisitions) total += a.getBaseValue();
		return total;
	}

	void addAcquisition(Acquisition a){
		_acquisitions.add(a);
	}

	void addSale(Sale s){
		_sales.add(s);
	}

	void changePoints(int points){
		_points += points;
	}
	
	@Override
	public void addNotification(Notification n){
		_notifications.add(n);
	}

	void checkStatus(){
		if (_points > 25000) _status = "ELITE";
		else if (25000 > _points && _points > 2000) _status = "SELECTION";
		else _status = "NORMAL";
	}

	@Override
	public boolean equals(Object obj){
		return obj instanceof Partner && _id.equals(((Partner)obj)._id);
	}

	@Override
	public int hashCode(){
		return _id.hashCode();
	}

	/**
	 * Returns the string that represents the Partner 
	 * */
	@Override
	public String toString(){
		return _id + "|" + _name + "|" + _address + "|" + _status + "|" 
		+ _points + "|" + getAcquisitionValue() + "|" + getSalesValue() + "|" + getPayedSales();
	}
}