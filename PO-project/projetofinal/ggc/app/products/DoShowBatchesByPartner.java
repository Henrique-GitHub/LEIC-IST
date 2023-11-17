package ggc.app.products;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.exception.PartnerDoesNotExist;

/**
 * Show batches supplied by partner.
 */
class DoShowBatchesByPartner extends Command<WarehouseManager> {

  DoShowBatchesByPartner(WarehouseManager receiver) {
    super(Label.SHOW_BATCHES_SUPPLIED_BY_PARTNER, receiver);
    //FIXME maybe add command fields
    addStringField("partnerId", Message.requestPartnerKey());
  }

  @Override
  public final void execute() throws CommandException {
    //FIXME implement command
    String id = stringField("partnerId");

    try {_receiver.getPartner(id);}
    catch (PartnerDoesNotExist pdne) {throw new UnknownPartnerKeyException(id);}
    _display.addAll(_receiver.getBatchesByPartner(id));
    _display.display();
  }

}
