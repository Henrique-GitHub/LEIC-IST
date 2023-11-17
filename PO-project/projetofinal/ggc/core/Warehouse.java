package ggc.core;

import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Map;
import java.util.HashMap;

import java.io.Serializable;
import java.io.IOException;
import ggc.core.exception.BadEntryException;

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

public class Warehouse implements Serializable {

  private static final long serialVersionUID = 202109192006L;

  private int _date;
  private double _balance;
  private Map<String, Product> _products = new HashMap<>();
  private Map<String, Partner>_partners = new HashMap<>();
  private List<Transaction>_transactions = new ArrayList<>();
  private int _transactionNum;

  /************************WAREHOUSE**************************/

  double getBalance(){
    return _balance;
  }

  double getAccountingBalance(){
    double toPay = 0;

    for (Transaction t : _transactions){
      if (!t.isPayed()){
        t.updateValueToPay(_date);
        toPay += t.getValueToPay();
      }
    }

    return _balance + toPay;
  }

  void changeBalance(double value){
    _balance += value;
  }

  void importFile(String txtfile) throws IOException, BadEntryException  {
    Parser parser = new Parser(this);

    try{  parser.parseFile(txtfile);

    } catch(IOException | BadEntryException ioebee){
      throw ioebee;
    }
  }

  /************************DATE**************************/
  
  void advanceDate(int days) throws InvalidDate{
    if (days <= 0) throw new InvalidDate();
    _date += days;
  }

  int getDate(){
    return _date;
  }

  /************************PRODUCTS**************************/

  Product getProduct(String id) throws ProductDoesNotExist{
    if (!hasProduct(id)) {throw new ProductDoesNotExist();}
    return getProducts().get(id.toLowerCase());
  }

  boolean hasProduct(String id){
    return getProducts().containsKey(id.toLowerCase());
  }

  Map<String, Product> getProducts(){
    return _products;
  }

  List<Product> getProductsList(){
    List<Product> products = new ArrayList<>(getProducts().values());
    Collections.sort(products, new ProductSort());
    for (Product p : products) p.setMaxPrice();
    return products;
  }

  void addSimpleProduct(String id){
    getProducts().put(id.toLowerCase(), new SimpleProduct(id));
  }

  void addAggregateProduct(String productId, int numOfComponents, double alpha, ArrayList<String> productIds, ArrayList<Integer> productAmounts) throws ProductDoesNotExist{
    List<Component> components = new ArrayList<>();

    for (int i = 0; i < numOfComponents; i++){
      components.add(new Component(getProduct(productIds.get(i)), productAmounts.get(i)));
    }

    getProducts().put(productId.toLowerCase(), new AggregateProduct(productId, new Recipe(alpha, components)));
  }

  void hasEnoughProduct(String productId, int amount) throws ProductNotEnough, ProductDoesNotExist{
    int total = 0;
    for (Batch b : getProduct(productId).getBatches()){
      total += b.getQuantity();
    }
    if (total - amount < 0) throw new ProductNotEnough(total);
  }

  /************************PARTNERS**************************/

  Partner getPartner(String id) throws PartnerDoesNotExist{
    if (!hasPartner(id)) {throw new PartnerDoesNotExist();}
    return getPartners().get(id.toLowerCase());
  }

  boolean hasPartner(String id){
    return getPartners().containsKey(id.toLowerCase());
  }

  Map<String, Partner> getPartners(){
    return _partners;
  }

  List<Partner> getPartnersList(){
    List<Partner>partners = new ArrayList<>(getPartners().values());
    Collections.sort(partners, new PartnerSort());
    return partners;
  }

  void addPointsToPartnerBySale(Sale s){
    s.addPoints();
  }

  void registerPartner(String id, String name, String address) throws PartnerAlreadyExists{

    if (getPartners().containsKey(id.toLowerCase())) throw new PartnerAlreadyExists();
    getPartners().put(id.toLowerCase(), new Partner(id, name, address));
  }

  /************************BATCHES**************************/

  List<Batch> getBatches(){
    List<Batch>batches = new ArrayList<>();

    for (Product p: getProducts().values()) batches.addAll(p.getBatches());
    Collections.sort(batches, new BatchSort());
    return batches;
  }

  List<Batch> getBatchesByPartner(String id){
    List<Batch> batches = new ArrayList<>();
    for (Batch b: getBatches()){
      if (b.getPartner().getId().compareToIgnoreCase(id) == 0)
        batches.add(b);
    }
    Collections.sort(batches, new BatchSort());
    return batches;
  }

  List<Batch> getBatchesByProduct(String id){
    List<Batch> batches = new ArrayList<>();
    for (Batch b: getBatches()){
      if (b.getProduct().getId().compareToIgnoreCase(id) == 0)
        batches.add(b);
    }
    Collections.sort(batches, new BatchSort());
    return batches;
  }

  List<Batch> getUnderLimitPriceBatches(int pL){
    List<Batch> batches = new ArrayList<>();
    for (Batch b: getBatches()){
      if (b.getPrice() < pL)
        batches.add(b);
    }
    Collections.sort(batches, new BatchSort());
    return batches;
  }

  /************************TRANSACTIONS**************************/

  List<Transaction> getTransactions(){
    return _transactions;
  }

  Transaction getTransactionById(int id) throws TransactionDoesNotExist{
    if (id >= getTransactionId()|| id < 0) {throw new TransactionDoesNotExist();}
    return getTransactions().get(id);
  }

  void addTransaction(Transaction t){
    getTransactions().add(t);
  }

  int getTransactionId(){
    return _transactionNum;
  }

  void nextTransactionId(){
    _transactionNum += 1;
  }

  void payTransaction(Transaction t){
    t.pay(getDate());
  }

  boolean transactionIsPayed(Transaction t){
    return t.isPayed();
  }

  double getTransactionCost(Transaction t){
    t.updateValueToPay(getDate());
    return t.getValueToPay();
  }

  List<Transaction> getPaymentsByPartner(String id) throws PartnerDoesNotExist{
    List<Transaction> partnerPayments = new ArrayList<>();
    for (Transaction t : getPartner(id).getSales()){
      if (t.isPayed()) partnerPayments.add(t);
    }
    return partnerPayments;
  }

  /*Acquisitions*/

  List<Acquisition> getPartnerAcquisitions(String id) throws PartnerDoesNotExist{
    return getPartner(id).getAcquisitions();
  }

  void registerPurchase(String partnerId, String prodId, double price, int amount) throws PartnerDoesNotExist, ProductDoesNotExist{
    Product prod = getProduct(prodId);
    Partner partner = getPartner(partnerId);
    Acquisition acq = new Acquisition(prod, amount, partner,getTransactionId(),price);
    acq.pay(getDate());
    nextTransactionId();
    Batch b = new Batch(price, amount, prod, partner);
    prod.addBatch(b);
    addTransaction(acq);
    partner.addAcquisition(acq);
    changeBalance(-price*amount);
  }

  /*Sales*/

  List<Sale> getPartnerSales(String id) throws PartnerDoesNotExist{
    return getPartner(id).getSales();
  }

  void registerSale(String partnerId, int deadline, String productId, int amount) throws ProductDoesNotExist, PartnerDoesNotExist{
    List<Batch> productBatches = getBatchesByProduct(productId);

    Collections.sort(productBatches, new ProductBatchSort());

    int quant = amount;

    double price = 0;
    while (quant > 0){
      if (productBatches.get(0).getQuantity() > quant){
        productBatches.get(0).changeQuantity(-amount);
        price += quant * productBatches.get(0).getPrice();
        break;
      }
      else {
        price += productBatches.get(0).getPrice() * productBatches.get(0).getQuantity();
        quant -= productBatches.get(0).getQuantity();
        Batch b = productBatches.get(0);
        Product p = getProduct(productId);
        p.removeBatch(b);
        productBatches.remove(b);

      }
    }
    Sale sale = new Sale(getProduct(productId), amount, getPartner(partnerId), deadline, getTransactionId(),price);
    nextTransactionId();
    addTransaction(sale);
    getPartner(partnerId).addSale(sale);
  }

  void updateSalePrice(int id) throws TransactionDoesNotExist{
    if (id >= getTransactionId() || id < 0) {throw new TransactionDoesNotExist();}
    getTransactionById(id).updateValueToPay(getDate());
  }

  /*Notifications*/

  List<Notification> getNotifications(String partnerId) throws PartnerDoesNotExist{
    return getPartner(partnerId).getNotifications();
  }

  void addObserver(Partner p){
    for (Product prod: _products.values()){
      prod.addObserver(p);
    }
  }

  void toggleProductNotifications(String partnerId, String productId) throws ProductDoesNotExist, PartnerDoesNotExist{
    getProduct(productId).togglePartner(getPartner(partnerId));
  }
}
