public class ProductWrapper {
	public Product2 productRecord {get; set;}
	public PriceBookEntry priceBookEntryRecord {get; set;}
	
	public ProductWrapper() {
		this.productRecord = new Product2();
		this.priceBookEntryRecord = new PriceBookEntry();
	}
	
	public Boolean hasAllDataRequiredToSave() {
		return !String.isBlank(this.productRecord.Name)
			&& !String.isBlank(this.productRecord.Family)
			&& (this.productRecord.Family != Constants.SELECT_ONE)
			&& this.productRecord.Initial_Inventory__c != null 
			&& this.productRecord.Initial_Inventory__c > 0
			&& this.productRecord.IsActive

			&& this.priceBookEntryRecord.UnitPrice != null;
	}   
}