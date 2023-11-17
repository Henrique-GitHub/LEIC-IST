package ggc.app.transactions;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.app.exception.UnavailableProductException;
import ggc.app.exception.UnknownProductKeyException;
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.exception.ProductNotEnough;
import ggc.core.exception.ProductDoesNotExist;
import ggc.core.exception.PartnerDoesNotExist;


/**
 * 
 */
public class DoRegisterSaleTransaction extends Command<WarehouseManager> {

  public DoRegisterSaleTransaction(WarehouseManager receiver) {
    super(Label.REGISTER_SALE_TRANSACTION, receiver);
    //FIXME maybe add command fields
    addStringField("partnerId", Message.requestPartnerKey());
    addIntegerField("deadline", Message.requestPaymentDeadline());
    addStringField("productId", Message.requestProductKey());
    addIntegerField("amount", Message.requestAmount());
  }

  @Override
  public final void execute() throws CommandException {
    //FIXME implement command
    String productId = stringField("productId");
    Integer amount = integerField("amount");
    Integer deadline = integerField("deadline");
    String partnerId = stringField("partnerId");


    try {
      _receiver.hasEnoughProduct(productId, amount);
      _receiver.registerSale(partnerId, deadline, productId, amount);
    }
    catch (ProductNotEnough pne) {throw new UnavailableProductException(productId, amount, pne.getTotal());}
    catch (ProductDoesNotExist pdne) {throw new UnknownProductKeyException(productId);}
    catch (PartnerDoesNotExist pdne) {throw new UnknownPartnerKeyException(partnerId);}

  }
}
