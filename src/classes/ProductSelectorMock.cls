@isTest
public class ProductSelectorMock extends ProductSelector {
	public List<PricebookEntry> receivedPricebookEntryList; 
	public List<Product2> returnedProductList;
	public override List<Product2> selectFor(List<PricebookEntry> pricebookEntryList) {
		this.receivedPricebookEntryList = pricebookEntryList;
		return this.returnedProductList;
	}  

    public Map<Id, Product2> receivedProductMap; 
    public Map<Id, Product2> returnedProductMap;
    public override Map<Id, Product2> aggregateQuantityOrderedByProduct2(Map<Id, Product2> productMap) {
    	this.receivedProductMap = productMap;
    	return this.returnedProductMap;
    }
     
    public List<ChartHelper.ChartData> returnedChartDataList;  
	public override List<ChartHelper.ChartData> selectRemainingProductQuantityByFamily() { 
		return this.returnedChartDataList;
	} 
}