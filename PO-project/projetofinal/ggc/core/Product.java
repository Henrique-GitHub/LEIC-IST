package ggc.core;

import java.util.List;
import java.util.ArrayList;
import java.io.Serializable;
import java.util.Collection;


public abstract class Product implements Serializable{
	/** Serial number for serialization. */
  	private static final long serialVersionUID = 202109192009L;

	private double _maxPrice;
	private String _id;
	private List<Batch> _batches = new ArrayList<>();
	private List<Partner> _observers = new ArrayList<>();

	/**
	 * @param id
	 * @param mp
	 * Initializes an object of Product class
	 * */
	Product(String id){
		_id = id;
	}

	String getId(){
		return _id;
	}

	abstract boolean checkQuantity(int quantity, Partner p);

	/**
	 * Returns the quantity of products of all Batches 
	 * */
	int getQuantity(){
		int quant = 0;
		for (Batch b : getBatches()){
			quant += b.getQuantity();
		}
		return quant;
	}

	double getMaxPrice(){
		return _maxPrice;
	}

	List<Batch> getBatches(){
		return _batches;
	}

	void addBatch(Batch b){
		if (_batches.size() > 0 && minPrice()> b.getPrice()){
			for (Partner p : _observers){
				p.addNotification(new Bargain("SMS", b.getProduct(), b.getPrice()));
			}
		}
		else if( _batches.size() == 0){
			for (Partner p : _observers){
				p.addNotification(new New("SMS", b.getProduct(), b.getPrice()));
			}
		}
		_batches.add(b);
	}

	void removeBatch(Batch b){
		_batches.remove(b);
	}

	void setMaxPrice(){
		for (Batch b : _batches){
			if (b.getPrice() > _maxPrice)
				_maxPrice = b.getPrice();
		}
	}

	void addObserver(Partner p){
		_observers.add(p);
	}

	void addObservers(Collection<Partner> partners){
		_observers.addAll(partners);
	}

	void togglePartner(Partner p){
		if(_observers.contains(p))
			_observers.remove(p);
		else{
			_observers.add(p);
		}
	}

	double minPrice(){
		double minPrice = _maxPrice;
		for (Batch b : _batches){
			if (b.getPrice() < minPrice)
				minPrice = b.getPrice();
		}
		return minPrice;
	}

	@Override
	public boolean equals(Object obj){
		return obj instanceof Product && _id.equals(((Product)obj)._id);
	}

	@Override
	public int hashCode(){
		return _id.hashCode();
	}
}