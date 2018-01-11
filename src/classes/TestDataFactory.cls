/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public class TestDataFactory {
    /**
     * @name constructCollaborationGroup
     * @description
    **/ 
    public static CollaborationGroup ConstructCollaborationGroup(){ 
    	return CollaborationGroupTestDataFactory.create(); 
    } 
 
    /**
     * @name CreateProducts
     * @description constructs a List of Product2 records for unit tests
    **/
    public static List<Product2> constructProducts(Integer cnt){
    	return ProductTestDataFactory.createList(cnt); 
    }

    /**
     * @name CreatePricebookEntries
     * @description constructs a List of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> constructPricebookEntries(List<Product2> productList){
    	return PricebookEntryTestDataFactory.createList(productList);
    }

    /**
     * @name CreateAccounts
     * @description constructs a List of Account records for unit tests
    **/
    public static List<Account> constructAccounts(Integer cnt){
    	return AccountTestDataFactory.createList(cnt);
    }

    /**
     * @name CreateContacts
     * @description constructs a List of Contacxt records for unit tests
    **/
    public static List<Contact> constructContacts(Integer cnt, List<Account> accts){
    	return ContactTestDataFactory.createList(cnt, accts);
    }

    /**
     * @name CreateOrders
     * @description constructs a List of Order records for unit tests
    **/
    public static List<Order> constructOrders(Integer cnt, List<Account> accts){
    	return OrderTestDataFactory.createList(cnt, accts);
    }

    /**
     * @name CreateOrderItems
     * @description constructs a List of OrderItem records for unit tests
    **/
    public static List<OrderItem> constructOrderItems(Integer cnt, List<Pricebookentry> pbes, List<Order> ords){
    	return OrderItemTestDataFactory.createList(cnt, pbes, ords);
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
    	insert constructCollaborationGroup();
    	
    	List<Product2> productList = constructProducts(cnt); 
    	insert productList;
    	
    	List<PricebookEntry> pbes = constructPricebookEntries(productList);
    	insert pbes;
    	
    	List<Account> accts = constructAccounts(cnt);
    	insert accts;
    	insert constructContacts(cnt, accts);
    	
    	List<Order> ords = constructOrders(cnt, accts);
    	insert ords;
    	insert constructOrderItems(cnt, pbes, ords);
    }
    
    public static void verifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer quantityOrdered) {
    	System.assertEquals(originalProduct.Quantity_Ordered__c + quantityOrdered, updatedProduct.Quantity_Ordered__c);	
    }
}