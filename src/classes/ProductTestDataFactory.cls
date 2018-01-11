@isTest
public class ProductTestDataFactory {
    public static List<Product2> createList(Integer quantity){
    	List<Schema.PickListEntry> familyValueList = Product2.Family.getDescribe().getPickListValues();
    	Integer possibleFamilyValues = familyValueList.size();
    	
    	List<Product2> productList = new List<Product2>();
    	for (Integer i = 0; i < quantity; i++) {
    		productList.add(new Product2( 
    			Name = 'Product ' + (i + 1),
    			Family = familyValueList[Math.mod(i, possibleFamilyValues)].getValue(),
    			Initial_Inventory__c = 10,
    			IsActive = true
    		));
    	} 
    	return productList;
    }
}