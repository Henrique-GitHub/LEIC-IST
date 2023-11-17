package ggc.app.main;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
import pt.tecnico.uilib.Display;
/**
 * Show current date.
 */


class DoDisplayDate extends Command<WarehouseManager> {
  Display _display = new Display();

  DoDisplayDate(WarehouseManager receiver) {
    super(Label.SHOW_DATE, receiver);
  }

  @Override
  public final void execute() throws CommandException {
    //FIXME implement command

    _display.popup(Message.currentDate(_receiver.displayDate()));
  }
}
