package ggc.app.partners;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.exception.PartnerDoesNotExist;

/**
 * Show partner.
 */
class DoShowPartner extends Command<WarehouseManager> {

  DoShowPartner(WarehouseManager receiver) {
    super(Label.SHOW_PARTNER, receiver);
    //FIXME add command fields
    addStringField("id", Message.requestPartnerKey());
  }

  @Override
  public void execute() throws CommandException {
    //FIXME implement command
    String id = stringField("id");

    try {
      _display.addLine(_receiver.getPartner(id));
      _display.addAll(_receiver.getNotifications(id));
      _display.display();
    }
    catch (PartnerDoesNotExist pdne) {throw new UnknownPartnerKeyException(id);}
  }
}
