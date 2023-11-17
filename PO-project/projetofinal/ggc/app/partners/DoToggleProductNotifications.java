package ggc.app.partners;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.exception.PartnerDoesNotExist;
import ggc.app.exception.UnknownProductKeyException;
import ggc.core.exception.ProductDoesNotExist;

/**
 * Toggle product-related notifications.
 */
class DoToggleProductNotifications extends Command<WarehouseManager> {

  DoToggleProductNotifications(WarehouseManager receiver) {
    super(Label.TOGGLE_PRODUCT_NOTIFICATIONS, receiver);
    //FIXME add command fields
    addStringField("partnerId", Message.requestPartnerKey());
    addStringField("productId", Message.requestProductKey());
  }

  @Override
  public void execute() throws CommandException {
    //FIXME implement command
    String partnerId = stringField("partnerId");
    String productId = stringField("productId");

    try {
      _receiver.getPartner(partnerId);
      _receiver.getProduct(productId);
    }
    catch (ProductDoesNotExist pdne) {throw new UnknownProductKeyException(productId);}
    catch (PartnerDoesNotExist pdne) {throw new UnknownPartnerKeyException(partnerId);}
  }
}
