@isTest
public class OrderTests {

	@testSetup
	static void setupTestData (){
	    TestDataFactory.InsertTestData(5);   
	}
 
    static testmethod void OrderUpdate_UnitTest (){
        Product2 product = selectProduct();

        test.startTest();
        Order order = [
        	SELECT Id, Status 
        	FROM Order 
        	LIMIT 1
        ];
        order.status = Constants.ACTIVATED_ORDER_STATUS;
        update order;
        Test.stopTest();

        Product2 updatedprod = selectProduct();
        
        // FIXME
        TestDataFactory.VerifyQuantityOrdered(product, updatedprod, Constants.DEFAULT_ROWS); 
    }
    
    private static Product2 selectProduct() {
    	return [
        	SELECT Id, Name, Family, Quantity_Ordered__c, Quantity_Remaining__c 
        	FROM Product2 
        	LIMIT 1
        ];
    }
    
 	public static testMethod void OrderExtension_UnitTest(){
        Account testAccount = new Account();
        testAccount.Name = 'test';
        insert testAccount;
        
        List<Schema.PicklistEntry> familyEntries = Constants.PRODUCT_FAMILY;
        Integer familySize = familyEntries.size();
        
         List<Account> ConstructAccounts = TestDataFactory.constructAccounts(Constants.DEFAULT_ROWS);
        insert ConstructAccounts;
        // Insert Order
        List<Order> ConstructOrders = TestDataFactory.constructOrders(Constants.DEFAULT_ROWS, ConstructAccounts);
        insert ConstructOrders;
        
        List<Product2> productList = new List<product2>();
        // Insert Product 
        List<Product2> productsList = TestDataFactory.constructProducts(Constants.DEFAULT_ROWS);
        insert productsList;
        
        List<PricebookEntry> ConstructPricebookEntries = TestDataFactory.constructPricebookEntries(productsList);
        insert ConstructPricebookEntries;
        
        List<OrderItem> ConstructOrderItems = TestDataFactory.constructOrderItems(Constants.DEFAULT_ROWS, ConstructPricebookEntries, ConstructOrders);
        insert ConstructOrderItems;

        orderExtension ext = new orderExtension(new apexPages.standardController(ConstructOrders[0]));
        ext.orderRecord.AccountId = testAccount.Id;
        ext.orderRecord.EffectiveDate = system.today();
        ext.orderRecord.Status = constants.DRAFT_ORDER_STATUS;
        ext.orderRecord.Pricebook2Id = constants.STANDARD_PRICEBOOK_ID;
        ext.orderItemList[0].Quantity = 1;
        ext.orderItemList[0].UnitPrice = 1;
        ext.orderItemList[1].Quantity = 2;
        ext.orderItemList[1].UnitPrice = 2;
        ext.save();
        
        List<Order> savedOrders = [SELECT Id, (SELECT Quantity, UnitPrice FROM OrderItems ORDER BY Quantity) FROM Order WHERE AccountId = :testAccount.Id];
        system.assert( savedOrders.size() == 1 );
        system.assert( savedOrders[0].OrderItems.size() == 2 );
        
        ext.GetFamilyOptions();
        ext.selectedFamily =  familyEntries[(familySize - 1) - Math.mod(1, familySize)].value;
        ext.SelectFamily();
        ext.orderItemList[0].Quantity = 10;
        ext.OnFieldChange();
        ext.First();
        ext.Next();
        ext.Previous();
        ext.Last();
        ext.GetHasPrevious();
        ext.GetHasNext();
        ext.GetTotalPages();
        ext.GetPageNumber();
    }

	public static TestMethod void Product2Trigger_UnitTest(){
         Integer productCount = [SELECT Count() FROM Product2]; 
         Integer pricebookCount = [SELECT Count() FROM PricebookEntry];
         PageReference pageRef = Page.Product2New;
         Test.setCurrentPage(pageRef);
         product2Extension ext = new product2Extension(new apexPages.standardController(new Product2()));
         ext.addRows();
         ext.addRows();
         ext.productsToInsert[0].productRecord.Name = 'TestTestTest';
         ext.productsToInsert[0].productRecord.Family = 'Entree';
         ext.productsToInsert[0].pricebookEntryRecord.UnitPrice = 1;
         ext.productsToInsert[0].pricebookEntryRecord.IsActive = true;
         ext.productsToInsert[0].productRecord.Initial_Inventory__c = 10;
         ext.save();
         
         system.assert( productCount+1 == [SELECT Count() FROM Product2] );
         system.assert( pricebookCount+1 == [SELECT Count() FROM PricebookEntry]);
         
         delete [SELECT Id FROM Product2 WHERE Name = 'TestTestTest'];
    }        
}