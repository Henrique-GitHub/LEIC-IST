package ggc.core;

public class Sale extends Transaction{
	private double _priceToPay;
	private double _baseValue;
    private int _pointsToAdd;

	Sale(Product prod, int quant, Partner partner, int deadline, int id, double baseValue){
		super(prod, quant, partner, deadline, id);
		_baseValue = baseValue;
	}

    void pay(int date){
    	changePaymentStatus();
    	setPaymentDate(date);
    }

    boolean isPayed(){
        return getPaymentStatus();
    }

    double getBaseValue(){
		return _baseValue;
	}

	void updateValueToPay(int currentDate){
       getPartner().checkStatus();
       int N = 0;
       double fluctuation = 0;
       int partnerPoints = getPartner().getPoints();
       String partnerStatus = getPartner().getStatus();
       int paymentDeadline = getPaymentDeadline();
       int dayDiffernce = paymentDeadline - currentDate;

       if (getProduct() instanceof AggregateProduct) N = 3;
       else N = 5;

       if (dayDiffernce >= N){
            fluctuation = -_priceToPay * 0.1;
            _pointsToAdd = (int)Math.round(10 * (getBaseValue() + fluctuation));
       }
       else if (0 <= dayDiffernce && dayDiffernce < N){
           if (partnerStatus == "SELECTION" && dayDiffernce >= 2) fluctuation = -_priceToPay * 0.05;
           else if (partnerStatus == "ELITE") fluctuation = -_priceToPay * 0.1;
           _pointsToAdd = (int)Math.round(10 * (getBaseValue() + fluctuation));
       }
       else if(0 < -dayDiffernce && -dayDiffernce <= N){
           if (partnerStatus == "NORMAL"){
               fluctuation = _priceToPay * 0.05 * -dayDiffernce;
               _pointsToAdd = -partnerPoints;
           }
           else if (partnerStatus == "SELECTION" && -dayDiffernce > 1) fluctuation = _priceToPay * 0.02 * -dayDiffernce;
           else if (partnerStatus == "ELITE") fluctuation = -_priceToPay * 0.05;
       }
       else if (-dayDiffernce > N){
           if (partnerStatus == "NORMAL"){
               fluctuation = _priceToPay * 0.1 * -dayDiffernce;
               _pointsToAdd = -partnerPoints;
           }
           else if (partnerStatus == "SELECTION") fluctuation = _priceToPay * 0.05 * -dayDiffernce;
       }

       if (-dayDiffernce > 15 && partnerStatus == "ELITE"){
           _pointsToAdd = (int)Math.round(-partnerPoints * 0.75);
       }
       if (-dayDiffernce > 2 && partnerStatus == "SELECTION"){
          _pointsToAdd = (int)Math.round(-partnerPoints * 0.9);
       }

       _priceToPay = getBaseValue() + fluctuation;
    }

    void addPoints(){
        getPartner().changePoints(_pointsToAdd);
    }

    double getValueToPay(){
    	return _priceToPay;
    }

    @Override
    public String toString(){
    	if(isPayed())
    		return "VENDA" + "|" + getId() + "|" + getPartner().getId() + "|" + getProduct().getId() + "|" + getAmount() 
    		+ "|" + (int)getBaseValue() + "|" + (int)_priceToPay + "|" + getPaymentDeadline() + "|" + getPaymentDate();
    	else{
    		return "VENDA" + "|" + getId() + "|" + getPartner().getId() + "|" + getProduct().getId() + "|" + getAmount() 
    		+ "|" + (int)getBaseValue() + "|" + (int)_priceToPay + "|" + getPaymentDeadline();
    	}
    }
}