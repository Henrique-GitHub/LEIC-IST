package ggc.app.partners;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.app.exception.DuplicatePartnerKeyException;
import ggc.core.exception.PartnerAlreadyExists;

/**
 * Register new partner.
 */
class DoRegisterPartner extends Command<WarehouseManager> {

  DoRegisterPartner(WarehouseManager receiver) {
    super(Label.REGISTER_PARTNER, receiver);
    //FIXME add command fields
    addStringField("id", Message.requestPartnerKey());
    addStringField("name", Message.requestPartnerName());
    addStringField("address", Message.requestPartnerAddress());

  }

  @Override
  public void execute() throws CommandException {
    //FIXME implement command

    try{_receiver.registerPartner(stringField("id"), stringField("name"), stringField("address"));}
    catch (PartnerAlreadyExists pae){ throw new DuplicatePartnerKeyException(stringField("id"));}
  }
}
