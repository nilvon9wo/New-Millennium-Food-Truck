@isTest
public class OrderHelperTest {
    private static final User TEST_USER = F45_FTY_TestUserFactory.DEFAULT_TEST_RUNNER;
    
    private static final F45_DML_GenericDml MOCK_GENERIC_DML = new F45_DML_GenericDmlMock();
    private static final OrderItemSelectorMock MOCK_ORDER_ITEM_SELECTOR = new OrderItemSelectorMock();
    private static final OrderItemAggregateSelector MOCK_ORDER_ITEM_AGGREGATE_SELECTOR = new OrderItemAggregateSelectorMock();
    private static final SetHelper MOCK_SET_HELPER = new SetHelperMock();

    private static final OrderHelper HELPER_UNDER_TEST 
    	= new OrderHelper(MOCK_GENERIC_DML, MOCK_ORDER_ITEM_SELECTOR, MOCK_ORDER_ITEM_AGGREGATE_SELECTOR, MOCK_SET_HELPER);
    
    @isTest public static void testOnAfterUpdateShouldUpdateOrderQuantitiesForSpecifiedOrders() {
    	/* TODO */
    }
     
    @isTest public static void testUpdateOrderItemQuantitiesShouldUpdateOrderQuantitiesForSpecifiedOrders() {
    	// Arrange
    	Set<Id> testActivatedOrderIdSet = null; // TODO 
    	
    	// Act
    	List<OrderItem> resultOrderItemList;
    	Test.startTest();
    	System.runAs(TEST_USER) {
    		resultOrderItemList = HELPER_UNDER_TEST.updateOrderItemQuantities(testActivatedOrderIdSet);
    	}
    	Test.stopTest();
    	
    	// Assert
	} 
    
} 