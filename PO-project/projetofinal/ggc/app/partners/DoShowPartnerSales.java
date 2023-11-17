package ggc.app.partners;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.core.exception.PartnerDoesNotExist;
import ggc.app.exception.UnknownPartnerKeyException;

/**
 * Show all transactions for a specific partner.
 */
class DoShowPartnerSales extends Command<WarehouseManager> {

  DoShowPartnerSales(WarehouseManager receiver) {
    super(Label.SHOW_PARTNER_SALES, receiver);
    //FIXME add command fields
    addStringField("partnerId", Message.requestPartnerKey());
  }

  @Override
  public void execute() throws CommandException {
    //FIXME implement command
    try{
      if (_receiver.getPartnerSales(stringField("partnerId")).size() > 0){
      _display.addAll(_receiver.getPartnerSales(stringField("partnerId")));
      _display.display();
      }
    }
    catch (PartnerDoesNotExist pdne) {throw new UnknownPartnerKeyException(stringField("partnerId"));}
  }

}
