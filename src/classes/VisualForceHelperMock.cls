@isTest
public class VisualForceHelperMock extends VisualForceHelper {
	public String receivedMessage;
	public ApexPages.message returnedMessage;
	
    public override ApexPages.message addInfoMessage(String message){
    	this.receivedMessage = message;
    	return this.returnedMessage;
    }

    public override ApexPages.message addErrorMessage(String message){
    	this.receivedMessage = message;
    	return this.returnedMessage;
    }
}