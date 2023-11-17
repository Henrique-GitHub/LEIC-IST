package ggc.app.transactions;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.exception.PartnerDoesNotExist;
import ggc.app.exception.UnknownProductKeyException;
import ggc.core.exception.ProductDoesNotExist;
import java.util.List;
import java.util.ArrayList;
import pt.tecnico.uilib.forms.Form;


/**
 * Register order.
 */
public class DoRegisterAcquisitionTransaction extends Command<WarehouseManager> {

  public DoRegisterAcquisitionTransaction(WarehouseManager receiver) {
    super(Label.REGISTER_ACQUISITION_TRANSACTION, receiver);
    //FIXME maybe add command fields
    addStringField("partnerId", Message.requestPartnerKey());
    addStringField("productId", Message.requestProductKey());
    addRealField("productPrice", Message.requestPrice());
    addIntegerField("productAmount", Message.requestAmount());
  }

  @Override
  public final void execute() throws CommandException {
    //FIXME implement command
    Form recipeForm = new Form("recipe");
    recipeForm.addBooleanField("addRecipe", Message.requestAddRecipe());
    Form recipeDataForm = new Form("recipeData");
    recipeDataForm.addIntegerField("numberOfComponents", Message.requestNumberOfComponents());
    recipeDataForm.addRealField("alpha", Message.requestAlpha());
    Form componentsForm = new Form("components");
    componentsForm.addStringField("product", Message.requestProductKey());
    componentsForm.addIntegerField("amount", Message.requestAmount());


    String partnerId = stringField("partnerId");
    String productId = stringField("productId");
    Double productPrice = realField("productPrice");
    int productAmount = integerField("productAmount");

    try{
      if(!_receiver.hasProduct(productId)){
        recipeForm.parse();
        if(!recipeForm.booleanField("addRecipe")){
          _receiver.addSimpleProduct(productId);
        }
        else{
          ArrayList<String> products = new ArrayList<>();
          ArrayList<Integer> amounts = new ArrayList<>();
          
          recipeDataForm.parse();
          for (int i = 0; i < recipeDataForm.integerField("numberOfComponents"); i++){
            componentsForm.parse();
            products.add(componentsForm.stringField("product"));
            amounts.add(componentsForm.integerField("amount"));
          }
          _receiver.addAggregateProduct(productId, recipeDataForm.integerField("numberOfComponents"), recipeDataForm.realField("alpha"), products, amounts);
        }
      }
      _receiver.registerPurchase(partnerId, productId, productPrice, productAmount);
    } catch (PartnerDoesNotExist pdne){ throw new UnknownPartnerKeyException(partnerId);}
    catch (ProductDoesNotExist pdne){ throw new UnknownProductKeyException(productId);}
  }
}
