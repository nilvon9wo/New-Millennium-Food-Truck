@isTest
public class OrderHelperIntTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
    private static final OrderHelper HELPER_UNDER_TEST = new OrderHelper();

    private static final Integer ORDER_ITEM_QUANTITY = 1;
    private static final OrderItemTestDataFactory.Bundle ORDER_ITEM_BUNDLE 
    		= OrderItemTestDataFactory.createBundle(ORDER_ITEM_QUANTITY, TEST_InsertModeEnum.INSERT_NOW, TEST_InsertRelationshipsEnum.INCLUDE);
    private static final Id TEST_PRODUCT_ID = ORDER_ITEM_BUNDLE.orderItemList[0].PriceBookEntry.Product2Id;
    		
    private static final List<Order> TEST_NEW_ORDER_LIST = ORDER_ITEM_BUNDLE.orderList;
    
    @isTest public static void testAfterUpdateShouldUpdateOrderQuantitiesForSpecifiedOrders() {
    	// Arrange
    	List<Order> testOldOrderList = TEST_NEW_ORDER_LIST.clone();
    	activateOrder(TEST_NEW_ORDER_LIST[0]);
    	
    	// Act 
    	Test.startTest();
    	System.runAs(TEST_USER) {
    		OrderHelper.afterUpdate(TEST_NEW_ORDER_LIST, testOldOrderList);
    	}
    	Test.stopTest();
    	
    	// Assert
    	assertProductQuanityUpdate();
	} 
    
    @isTest public static void testRollUpOrderItemsShouldUpdateOrderQuantitiesForSpecifiedOrders() {
    	// Arrange
    	Set<Id> testActivatedOrderIdSet = new Set<Id>{activateOrder(TEST_NEW_ORDER_LIST[0])};
    	
    	// Act 
    	Test.startTest();
    	System.runAs(TEST_USER) {
    		OrderHelper.rollUpOrderItems(testActivatedOrderIdSet);
    	}
    	Test.stopTest();
    	
    	// Assert
    	assertProductQuanityUpdate();
	} 
	
	private static Id activateOrder(Order testOrder) {
		testOrder.status = 'Activated';
		update testOrder;
		return testOrder.Id;
	}
	
	private static void assertProductQuanityUpdate() {
    	List<Product2> resultProductList = [
    		SELECT Quantity_Ordered__c
    		FROM Product2
    		WHERE Id = :TEST_PRODUCT_ID
    	];
    	Integer expectedQuantity = ProductTestDataFactory.DEFAULT_INITIAL_INVENTORY - OrderItemTestDataFactory.DEFAULT_QUANTITY;
    	System.assertEquals (expectedQuantity, resultProductList[0].Quantity_Ordered__c);
	}
} 