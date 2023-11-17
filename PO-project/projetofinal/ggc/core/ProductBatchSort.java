package ggc.core;

import java.util.Comparator;
 
public class ProductBatchSort implements Comparator<Batch> {
    @Override
    public int compare(Batch b1, Batch b2) {
        int comparePrice = (int) b1.getPrice() - (int) b2.getPrice();
        return comparePrice;
    }
}