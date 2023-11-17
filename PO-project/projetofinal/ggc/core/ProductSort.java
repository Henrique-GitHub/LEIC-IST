package ggc.core;

import java.util.Comparator;
 
public class ProductSort implements Comparator<Product> {
    @Override
    public int compare(Product p1, Product p2) {
        int compareId = p1.getId().compareToIgnoreCase(p2.getId());
        int comparePrice = (int) p1.getMaxPrice() - (int) p2.getMaxPrice();
        int compareQuantity = p1.getQuantity() - p2.getQuantity();


        if (compareId != 0) return compareId;
        else if (comparePrice != 0) return comparePrice;
        else return compareQuantity;
    }
}