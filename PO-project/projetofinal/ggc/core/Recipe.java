package ggc.core;

import java.util.List;
import java.util.ArrayList;


public class Recipe{
	private double _alpha;
	private List<Component> _components;

	Recipe (double a, List<Component> components){
		_alpha = a;
		_components = new ArrayList<>(components);
	}

	double getAlpha(){
		return _alpha;
	}

	List<Component> getComponents(){
		return _components;
	}

	double getPrice(){
		int total = 0;
		double price;

		for (Component c : _components){
			total += c.getProduct().getQuantity() * c.getProduct().getMaxPrice();
		}
		price = (1+_alpha)*total;
		return price;
	}

	public String toString(){
		String s = "";
		for (Component c: _components){
			s += c.getProduct().getId() + ":" + c.getQuantity() + "#";
		}
		return s.substring(0, s.length()-1);
	}
}