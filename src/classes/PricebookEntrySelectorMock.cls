@isTest
public class PricebookEntrySelectorMock extends PricebookEntrySelector {
	public Boolean wasCalledWithoutParam;
	public Database.QueryLocator returnedQueryLocator; 
    public override Database.QueryLocator getQueryLocator() {
    	this.wasCalledWithoutParam = true;
		return this.returnedQueryLocator; 
    } 

	public String receivedSelectedFamily;
    public override Database.QueryLocator getQueryLocatorForFamily(String selectedFamily) {
    	this.receivedSelectedFamily = selectedFamily;
		return this.returnedQueryLocator; 
    }    
}