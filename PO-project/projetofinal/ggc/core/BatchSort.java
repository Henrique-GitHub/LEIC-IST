package ggc.core;

import java.util.Comparator;
 
public class BatchSort implements Comparator<Batch> {
    @Override
    public int compare(Batch b1, Batch b2) {
        int compareProductId = b1.getProduct().getId().compareToIgnoreCase(b2.getProduct().getId());
        int comparePartnerId = b1.getPartner().getId().compareToIgnoreCase(b2.getPartner().getId());
        int comparePrice = (int) b1.getPrice() - (int) b2.getPrice();
        int compareQuantity = b1.getQuantity() - b2.getQuantity();


        if (compareProductId != 0) return compareProductId;
        else if (comparePartnerId != 0) return comparePartnerId;
        else if (comparePrice != 0) return comparePrice;
        else return compareQuantity;
    }
}