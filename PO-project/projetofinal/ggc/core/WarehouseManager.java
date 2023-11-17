package ggc.core;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;


import java.io.Serializable;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import ggc.core.exception.BadEntryException;
import ggc.core.exception.ImportFileException;
import ggc.core.exception.UnavailableFileException;
import ggc.core.exception.MissingFileAssociationException;
import ggc.core.exception.PartnerAlreadyExists;
import ggc.core.exception.InvalidDate;
import ggc.core.exception.PartnerDoesNotExist;
import ggc.core.exception.ProductDoesNotExist;
import ggc.core.exception.TransactionDoesNotExist;
import ggc.core.exception.ProductNotEnough;

public class WarehouseManager {

  private String _filename = "";
  private String _loadfile = "";

  private Warehouse _warehouse = new Warehouse();

  /************************WAREHOUSE**************************/

  public Warehouse getWarehouse(){
    return _warehouse; 
  }   

  public String getLoadFile(){
    return _loadfile;
  }

  public double getAvailableBalance(){
    return _warehouse.getBalance();
  }

  public double getAccountingBalance(){
    return _warehouse.getAccountingBalance();
  }

  public void changeBalance(double value){
    _warehouse.changeBalance(value);
  }

  public void save() throws IOException, FileNotFoundException, MissingFileAssociationException {
    if (_loadfile.equals(""))
      _loadfile = _filename;
    try {
      ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(_loadfile));
      oos.writeObject(_warehouse);
      oos.close();

    } catch (FileNotFoundException fnfe){ throw fnfe;
    } catch (IOException ioe){ throw ioe;
    }
  }

  public void saveAs(String filename) throws MissingFileAssociationException, FileNotFoundException, IOException {
    _filename = filename;
    save();
  }

  public void load(String filename) throws UnavailableFileException, ClassNotFoundException{
    try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(filename))){
      _warehouse = (Warehouse) ois.readObject();
      _loadfile = filename;
    }
    catch (IOException ioe) { throw new UnavailableFileException(filename); }
  }

  public void importFile(String textfile) throws ImportFileException {
    try {
      _warehouse.importFile(textfile);
    } catch (IOException | BadEntryException ex) {
      throw new ImportFileException(textfile, ex);
    }
  }

  /************************DATE**************************/

  public void advanceDate(int days) throws InvalidDate{
    _warehouse.advanceDate(days);
  }

  public int displayDate(){
    return _warehouse.getDate();
  }

  /**************************PRODUCT**************************/

  public Product getProduct(String id) throws ProductDoesNotExist{
    return _warehouse.getProduct(id);
  }

  public boolean hasProduct(String id){
    return _warehouse.hasProduct(id);
  }

  public Map<String, Product> getProducts(){
    return _warehouse.getProducts();
  }

  public List<Product> getProductsList(){
    return _warehouse.getProductsList();
  }

  public void addSimpleProduct(String id){
    _warehouse.addSimpleProduct(id);
  }

  public void addAggregateProduct(String productId, int numOfComponents, double alpha, 
    ArrayList<String> productIds, ArrayList<Integer> productAmounts) throws ProductDoesNotExist{
    _warehouse.addAggregateProduct(productId, numOfComponents, alpha, productIds, productAmounts);
  }

  public void hasEnoughProduct(String productId, int amount) throws ProductNotEnough, ProductDoesNotExist{
    _warehouse.hasEnoughProduct(productId, amount);
  }

  /**************************PARTNER**************************/

  public Partner getPartner(String id) throws PartnerDoesNotExist{
    return _warehouse.getPartner(id);
  }

  public Map<String, Partner> getPartners(){
    return _warehouse.getPartners();
  }

  public List<Partner> getPartnersList(){
    return _warehouse.getPartnersList();
  }

  public void addPointsToPartnerBySale(Sale s){
    _warehouse.addPointsToPartnerBySale(s);
  }

  public void registerPartner(String id, String name, String address) throws PartnerAlreadyExists{
    _warehouse.registerPartner(id, name, address);
  }

  /**************************BATCHES***************************/

  public List<Batch> getBatchesList(){
    return _warehouse.getBatches();
  }

  public List<Batch> getBatchesByPartner(String id){
    return _warehouse.getBatchesByPartner(id);
  }

  public List<Batch> getBatchesByProduct(String id){
    return _warehouse.getBatchesByProduct(id);
  }

  public List<Batch> getUnderLimitPriceBatches(int pL){
    return _warehouse.getUnderLimitPriceBatches(pL);
  }

/**************************TRANSACTIONS***************************/

  public List<Transaction> getTransactions(){
    return _warehouse.getTransactions();
  }

  public Transaction getTransactionById(int id) throws TransactionDoesNotExist{
    return _warehouse.getTransactionById(id);
  }

  public void payTransaction(Transaction t){
    _warehouse.payTransaction(t);
  }

  public boolean transactionIsPayed(Transaction t){
    return _warehouse.transactionIsPayed(t);
  }

  public double getTransactionCost(Transaction t){
    return _warehouse.getTransactionCost(t);
  }

  public List<Transaction> getPaymentsByPartner(String id) throws PartnerDoesNotExist{
    return _warehouse.getPaymentsByPartner(id);
  }
  
  /*Acquisitions*/

  public List<Acquisition> getPartnerAcquisitions(String id) throws PartnerDoesNotExist{
    return _warehouse.getPartnerAcquisitions(id);
  }

  public void registerPurchase(String partnerId, String prodId, double price, int amount) throws PartnerDoesNotExist, ProductDoesNotExist{
    _warehouse.registerPurchase(partnerId, prodId, price, amount);
  }

  /*Sales*/

  public List<Sale> getPartnerSales(String id) throws PartnerDoesNotExist{
    return getPartner(id).getSales();
  }

  public void registerSale(String partnerId, int deadline, String productId, int amount) throws ProductDoesNotExist, PartnerDoesNotExist{
    _warehouse.registerSale(partnerId, deadline, productId, amount);
  }

  public void updateSalePrice(int id) throws TransactionDoesNotExist{
    _warehouse.updateSalePrice(id);
  }
  
  /*Notifications*/

  public void toggleProductNotifications(String partnerId, String productId) throws ProductDoesNotExist, PartnerDoesNotExist{
    _warehouse.toggleProductNotifications(partnerId, productId);
  }

  public List<Notification> getNotifications(String partnerId) throws PartnerDoesNotExist{
    return _warehouse.getNotifications(partnerId);
  }
}