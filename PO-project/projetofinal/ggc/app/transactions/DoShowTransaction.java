package ggc.app.transactions;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.core.exception.TransactionDoesNotExist;
import ggc.app.exception.UnknownTransactionKeyException;

/**
 * Show specific transaction.
 */
public class DoShowTransaction extends Command<WarehouseManager> {

  public DoShowTransaction(WarehouseManager receiver) {
    super(Label.SHOW_TRANSACTION, receiver);
    //FIXME maybe add command fields
    addIntegerField("transactionId", Message.requestTransactionKey());
  }

  @Override
  public final void execute() throws CommandException {
    //FIXME implement command
    try{
      _receiver.updateSalePrice(integerField("transactionId"));
      _display.addLine(_receiver.getTransactionById(integerField("transactionId")));
    }catch (TransactionDoesNotExist tdne) {throw new UnknownTransactionKeyException(integerField("transactionId"));}
    _display.display();
  }

}
