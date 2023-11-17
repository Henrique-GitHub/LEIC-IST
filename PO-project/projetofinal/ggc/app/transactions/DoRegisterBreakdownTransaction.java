package ggc.app.transactions;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.core.exception.PartnerDoesNotExist;
import ggc.core.exception.ProductDoesNotExist;
import ggc.core.exception.ProductNotEnough;
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.app.exception.UnknownProductKeyException;
import ggc.app.exception.UnavailableProductException;


/**
 * Register order.
 */
public class DoRegisterBreakdownTransaction extends Command<WarehouseManager> {

  public DoRegisterBreakdownTransaction(WarehouseManager receiver) {
    super(Label.REGISTER_BREAKDOWN_TRANSACTION, receiver);
    //FIXME maybe add command fields
    addStringField("partnerId", Message.requestPartnerKey());
    addStringField("productId", Message.requestProductKey());
    addIntegerField("amount", Message.requestAmount());
  }

  @Override
  public final void execute() throws CommandException {
    //FIXME implement command
    String partnerId = stringField("partnerId");
    String productId = stringField("productId");
    Integer amount = integerField("amount");

    try {
      _receiver.hasEnoughProduct(productId, amount);
      _receiver.getPartner(partnerId);
      _receiver.getProduct(productId);
    }
    catch (ProductNotEnough pne) {throw new UnavailableProductException(productId, amount, pne.getTotal());}
    catch (ProductDoesNotExist pdne) {throw new UnknownProductKeyException(productId);}
    catch (PartnerDoesNotExist pdne) {throw new UnknownPartnerKeyException(partnerId);}
  }
}
