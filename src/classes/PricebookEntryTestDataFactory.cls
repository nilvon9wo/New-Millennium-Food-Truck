@isTest
public class PricebookEntryTestDataFactory {
    public static List<PricebookEntry> createList(List<Product2> productList){
    	List<PricebookEntry> pbes = new List<PricebookEntry>();
    	for (Product2 product: productList) { 
    		pbes.add(new PricebookEntry(
    			Pricebook2Id = PricebookTestDataFactory.STANDARD_PRICEBOOK_ID,
    			Product2Id = product.id,
    			IsActive = true,
    			UnitPrice = 1
    		));
    	} 
        return pbes;
    }
}