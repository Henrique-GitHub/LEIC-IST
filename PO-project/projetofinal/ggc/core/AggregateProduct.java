package ggc.core;

public class AggregateProduct extends Product{
	/** Serial number for serialization. */
  	private static final long serialVersionUID = 202109192006L;
  	
	private Recipe _recipe;

	AggregateProduct(String id, Recipe recipe){
		super(id);
		_recipe = recipe;
	}

	@Override
	boolean checkQuantity(int quantity, Partner p){
		for (Batch b : getBatches()){
			if (b.getPartner() == p){
				quantity -= b.getQuantity();
			}
		}
		return quantity <= 0;
	}

	@Override
	public String toString(){
		return getId() + "|" + (int)getMaxPrice() + "|" + getQuantity() + "|" + _recipe.toString();
	}			/////To be done/////	
}