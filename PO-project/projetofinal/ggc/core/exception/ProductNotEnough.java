package ggc.core.exception;

public class ProductNotEnough extends Exception{
	/** Serial number for serialization. */
  	private static final long serialVersionUID = 202109998013L;
  	private int _total;

	public ProductNotEnough(int total){
		_total = total;
	}

	public int getTotal(){
		return _total;
	}
}