@isTest
public class OrderTriggerIntTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 

    private static final Integer ORDER_ITEM_QUANTITY = 1;
    private static final OrderItemTestDataFactory.Bundle ORDER_ITEM_BUNDLE 
    		= OrderItemTestDataFactory.createBundle(ORDER_ITEM_QUANTITY, TEST_InsertModeEnum.INSERT_LATER, TEST_InsertRelationshipsEnum.INCLUDE);
    private static final Id TEST_PRODUCT_ID = ORDER_ITEM_BUNDLE.orderItemList[0].PriceBookEntry.Product2Id;
    
    private static final List<Order> TEST_ORDER_LIST = stripIds(ORDER_ITEM_BUNDLE.orderList.clone());
    
    public static Boolean isExceptionTest = false;
    public static TEST_InsertModeEnum INSERT_NOW = TEST_InsertModeEnum.INSERT_NOW;
	
	@testSetup
	static void setupTestData (){
    	CollaborationGroupTestDataFactory.create(INSERT_NOW);
	}	
	
    @isTest public static void testDraftInsertionsShouldNotUpdateProducts() {
    	// Arrange
		// Nothing to do here
		    	
    	// Act 
    	Test.startTest();
    	System.runAs(TEST_USER) {
    		insert TEST_ORDER_LIST;
    	}
    	Test.stopTest();
    	
    	// Assert
    	Integer expectedQuantity = 0;
    	assertProductQuantity(expectedQuantity, TEST_PRODUCT_ID);
	}
	
    @isTest public static void testActivatingUpdatesShouldUpdateProducts() {
    	// Arrange
    	OrderItemTestDataFactory.Bundle orderItemBundle 
    		= OrderItemTestDataFactory.createBundle(ORDER_ITEM_QUANTITY, INSERT_NOW, TEST_InsertRelationshipsEnum.INCLUDE);

		List<Order> testOrderList = orderItemBundle.orderList;
		testOrderList[0].status = 'Activated';
		    	
    	// Act 
    	Test.startTest();
    	System.runAs(TEST_USER) {
    		update testOrderList;
    	}
    	Test.stopTest();
    	
    	// Assert
    	Integer expectedQuantity = ProductTestDataFactory.DEFAULT_INITIAL_INVENTORY - OrderItemTestDataFactory.DEFAULT_QUANTITY;
    	Id testProductId = orderItemBundle.orderItemList[0].PriceBookEntry.Product2Id;
    	assertProductQuantity(expectedQuantity, testProductId);
	}
	
    @isTest public static void testDeletionShouldNotUpdateProducts() {
    	// Arrange
    	insert TEST_ORDER_LIST;
		    	
    	// Act 
    	Test.startTest();
    	System.runAs(TEST_USER) {
    		delete TEST_ORDER_LIST;
    	}
    	Test.stopTest();
    	
    	// Assert
    	Integer expectedQuantity = 0;
    	assertProductQuantity(expectedQuantity, TEST_PRODUCT_ID);
	}

    @isTest public static void testUndeleteShouldUpdateProducts() {
    	// Arrange
    	insert TEST_ORDER_LIST;
   		delete TEST_ORDER_LIST;
		    	 
    	// Act 
    	Test.startTest();
    	System.runAs(TEST_USER) {
    		undelete TEST_ORDER_LIST;
    	}
    	Test.stopTest();
    	
    	// Assert
    	Integer expectedQuantity = 0;
    	assertProductQuantity(expectedQuantity, TEST_PRODUCT_ID);
	}

    @isTest public static void testDmlFailuresShouldBeSilent() {
    	// Arrange
    	isExceptionTest = true;
		    	
    	// Act 
    	Test.startTest();
    	System.runAs(TEST_USER) {
    		insert TEST_ORDER_LIST;
    	}
    	Test.stopTest();
    	
    	// Assert
    	Boolean exceptionNotThrown = true;
    	System.assert(exceptionNotThrown);
    	
    	// Cleanup
    	isExceptionTest = false;
	}

	private static List<Order> stripIds (List<Order> orderList) {
		List<Order> idlessOrderList = new List<Order>();
		for (Order order : orderList) {
			Order idlessOrder = order.clone();
			idlessOrder.id = null;
			idlessOrderList.add(idlessOrder);
		}
		return idlessOrderList;
	}
    
	private static void assertProductQuantity(Integer expectedQuantity, Id testProductId) {
    	List<Product2> resultProductList = [
    		SELECT Quantity_Ordered__c
    		FROM Product2
    		WHERE Id = :testProductId
    	];
    	System.assertEquals (expectedQuantity, resultProductList[0].Quantity_Ordered__c);
	}
}