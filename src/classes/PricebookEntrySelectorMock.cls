@isTest
public class PricebookEntrySelectorMock extends PricebookEntrySelector {
	public ApexPages.StandardSetController receivedStandardSetController;
	public List<PricebookEntry> returnedPricebookEntryList;
	public override List<PricebookEntry> getStandardSetFrom(ApexPages.StandardSetController standardSetController) {
		this.receivedStandardSetController = standardSetController;
		return this.returnedPricebookEntryList;
	}
}