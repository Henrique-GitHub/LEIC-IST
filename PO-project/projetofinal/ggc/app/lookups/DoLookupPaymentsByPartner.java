package ggc.app.lookups;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.exception.PartnerDoesNotExist;

/**
 * Lookup payments by given partner.
 */
public class DoLookupPaymentsByPartner extends Command<WarehouseManager> {

  public DoLookupPaymentsByPartner(WarehouseManager receiver) {
    super(Label.PAID_BY_PARTNER, receiver);
    //FIXME add command fields
    addStringField("id", Message.requestPartnerKey());
  }

  @Override
  public void execute() throws CommandException {
    //FIXME implement command
    String id = stringField("id");

    try {
    _display.addAll(_receiver.getPaymentsByPartner(id));
    _display.display();}
    catch (PartnerDoesNotExist pdne) {throw new UnknownPartnerKeyException(id);}
  }

}
