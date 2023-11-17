package ggc.core;

import java.util.Comparator;
 
public class PartnerSort implements Comparator<Partner> {
    @Override
    public int compare(Partner p1, Partner p2) {
        int compareId = p1.getId().compareToIgnoreCase(p2.getId());
        int compareName = p1.getName().compareToIgnoreCase(p2.getName());
        int compareAddress = p1.getAddress().compareToIgnoreCase(p2.getAddress());
        int compareStatus = p1.getStatus().compareToIgnoreCase(p2.getStatus());
        int comparePoints = p1.getPoints() - p2.getPoints();
        int compareSalesValue = p1.getSalesValue() - p2.getSalesValue();
        int compareAcquisitionValue = p1.getAcquisitionValue() - p2.getAcquisitionValue();


        if (compareId != 0) return compareId;
        else if (compareName != 0) return compareName;
        else if (compareAddress != 0) return compareAddress;
        else if (compareStatus != 0) return compareStatus;
        else if (comparePoints != 0) return comparePoints;
        else if (compareSalesValue != 0) return compareSalesValue;
        else return compareAcquisitionValue;
    }
}