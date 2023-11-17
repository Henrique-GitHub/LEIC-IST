package ggc.app.transactions;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.app.exception.UnknownTransactionKeyException;
import ggc.core.exception.TransactionDoesNotExist;
import ggc.core.Sale;


/**
 * Receive payment for sale transaction.
 */
public class DoReceivePayment extends Command<WarehouseManager> {

  public DoReceivePayment(WarehouseManager receiver) {
    super(Label.RECEIVE_PAYMENT, receiver);
    //FIXME add command fields
    addIntegerField("saleId", Message.requestTransactionKey());
  }

  @Override
  public final void execute() throws CommandException {
    //FIXME implement command
    Integer saleId = integerField("saleId");
    
    try{
      if (!_receiver.transactionIsPayed(_receiver.getTransactionById(saleId))){
        _receiver.changeBalance(_receiver.getTransactionCost(_receiver.getTransactionById(saleId)));
        _receiver.payTransaction(_receiver.getTransactionById(saleId));
        _receiver.addPointsToPartnerBySale((Sale)_receiver.getTransactionById(saleId));
      }
    }
    catch (TransactionDoesNotExist tdne) {throw new UnknownTransactionKeyException(saleId);}
    
  }

}
