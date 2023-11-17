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
class DoShowPartnerAcquisitions extends Command<WarehouseManager> {

  DoShowPartnerAcquisitions(WarehouseManager receiver) {
    super(Label.SHOW_PARTNER_ACQUISITIONS, receiver);
    //FIXME add command fields
    addStringField("id", Message.requestPartnerKey());
  }

  @Override
  public void execute() throws CommandException {
    //FIXME implement command
    
    try{
      if (_receiver.getPartnerAcquisitions(stringField("id")).size() > 0){
        _display.addAll(_receiver.getPartnerAcquisitions(stringField("id")));
        _display.display();
      }
    }
    catch (PartnerDoesNotExist pdne) {throw new UnknownPartnerKeyException(stringField("id"));}
  }
}
