package ggc.core;


public class SimpleProduct extends Product{
	/** Serial number for serialization. */
  	private static final long serialVersionUID = 202109192010L;

	SimpleProduct(String id){
		super(id);
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
		return getId() + "|" + (int) getMaxPrice() + "|" + getQuantity();
	}		
}