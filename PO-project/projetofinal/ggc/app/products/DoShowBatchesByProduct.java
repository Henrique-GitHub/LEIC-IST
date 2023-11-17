package ggc.app.products;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.core.exception.ProductDoesNotExist;
import ggc.app.exception.UnknownProductKeyException;

/**
 * Show all products.
 */
class DoShowBatchesByProduct extends Command<WarehouseManager> {

  DoShowBatchesByProduct(WarehouseManager receiver) {
    super(Label.SHOW_BATCHES_BY_PRODUCT, receiver);
    //FIXME maybe add command fields
    addStringField("productId", Message.requestProductKey());
  }

  @Override
  public final void execute() throws CommandException {
    //FIXME implement command
    String id = stringField("productId");

    try {_receiver.getProduct(id);}
    catch (ProductDoesNotExist pdne) {throw new UnknownProductKeyException(id);}
    _display.addAll(_receiver.getBatchesByProduct(id));
    _display.display();
  }
}
