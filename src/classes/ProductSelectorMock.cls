@isTest
public class ProductSelectorMock extends ProductSelector {
    public Map<Id, Product2> receivedProductMap;
    public Map<Id, Product2> returnedProductMap;
    public override Map<Id, Product2> aggregateQuantityOrderedByProduct2(Map<Id, Product2> productMap) {
    	this.receivedProductMap = productMap;
    	return this.returnedProductMap;
    }    
}