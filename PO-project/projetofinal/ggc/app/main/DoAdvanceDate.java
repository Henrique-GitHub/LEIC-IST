package ggc.app.main;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.app.exception.InvalidDateException;
import ggc.core.exception.InvalidDate;

/**
 * Advance current date.
 */
class DoAdvanceDate extends Command<WarehouseManager> {

  DoAdvanceDate(WarehouseManager receiver) {
    super(Label.ADVANCE_DATE, receiver);
    //FIXME add command fields
    addIntegerField("days", Message.requestDaysToAdvance());

  }

  @Override
  public final void execute() throws CommandException {
    //FIXME implement command
    
    try{_receiver.advanceDate(integerField("days"));
    }catch(InvalidDate id){ throw new InvalidDateException(integerField("days"));}
  }
}
