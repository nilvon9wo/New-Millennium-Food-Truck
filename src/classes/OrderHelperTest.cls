@isTest
public class OrderHelperTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
    
    private static final F45_DML_GenericDmlMock MOCK_GENERIC_DML = new F45_DML_GenericDmlMock();
    private static final OrderItemSelectorMock MOCK_ORDER_ITEM_SELECTOR = new OrderItemSelectorMock();
    private static final SetHelperMock MOCK_SET_HELPER = new SetHelperMock();
	private static final TEST_InsertModeEnum MOCK_INSERT = TEST_InsertModeEnum.MOCK_INSERT;

    private static final OrderHelper HELPER_UNDER_TEST = new OrderHelper(MOCK_GENERIC_DML, MOCK_ORDER_ITEM_SELECTOR, MOCK_SET_HELPER);

    private static final Integer TEST_ORDER_QUANTITY = 1;
	private static final List<Order> TEST_NEW_ORDER_LIST = OrderTestDataFactory.createList(TEST_ORDER_QUANTITY, MOCK_INSERT);
	private static final List<Order> TEST_OLD_ORDER_LIST = OrderTestDataFactory.createList(TEST_ORDER_QUANTITY, MOCK_INSERT);
   	private static final Set<Id> TEST_ACTIVATED_ORDER_ID_SET = new Set<Id>{TEST_NEW_ORDER_LIST[0].id};

    private static final Integer TEST_ORDER_ITEM_QUANTITY = 1;
   	private static final List<OrderItem> TEST_ORDER_ITEM_LIST = OrderItemTestDataFactory.createList(TEST_ORDER_ITEM_QUANTITY, MOCK_INSERT);
    private static final OrderItem TEST_ORDER_ITEM = TEST_ORDER_ITEM_LIST[0];
    private static final PricebookEntry TEST_PRICEBOOK_ENTRY = TEST_ORDER_ITEM.PricebookEntry;
   	
    
    @isTest public static void testOnAfterUpdateShouldUpdateOrderQuantitiesForSpecifiedOrders() {
    	// Arrange
		MOCK_SET_HELPER.returnedIdSet = TEST_ACTIVATED_ORDER_ID_SET;
		setupMocksForUpdate();
		
    	// Act
    	List<OrderItem> resultOrderItemList;
    	Test.startTest();
    	System.runAs(TEST_USER) {
    		resultOrderItemList = HELPER_UNDER_TEST.onAfterUpdate(TEST_NEW_ORDER_LIST, TEST_OLD_ORDER_LIST);
    	} 
    	Test.stopTest();
    	
    	// Assert
    	System.assertEquals(TEST_NEW_ORDER_LIST, MOCK_SET_HELPER.receivedNewSObjectList);
    	System.assertEquals(TEST_OLD_ORDER_LIST, MOCK_SET_HELPER.receivedOldSObjectList);
    	System.assertEquals(Order.Status, MOCK_SET_HELPER.receivedSObjectField);
    	System.assertEquals(Constants.ACTIVATED_ORDER_STATUS, MOCK_SET_HELPER.receivedTargetValue);
    	assertUpdateOrderItemQuantities(resultOrderItemList);
    }
     
    @isTest public static void testUpdateOrderItemQuantitiesShouldUpdateOrderQuantitiesForSpecifiedOrders() {
    	// Arrange
    	setupMocksForUpdate();
    	
    	// Act 
    	List<OrderItem> resultOrderItemList;
    	Test.startTest();
    	System.runAs(TEST_USER) {
    		resultOrderItemList = HELPER_UNDER_TEST.updateOrderItemQuantities(TEST_ACTIVATED_ORDER_ID_SET);
    	}
    	Test.stopTest();
    	
    	// Assert
    	assertUpdateOrderItemQuantities(resultOrderItemList);
	} 
	
	private static void setupMocksForUpdate() {
    	MOCK_ORDER_ITEM_SELECTOR.returnedOrderItemList = TEST_ORDER_ITEM_LIST;
    	Product2 testProduct = ProductTestDataFactory.create(MOCK_INSERT);
    	MOCK_ORDER_ITEM_SELECTOR.returnedProductMap = new Map<Id, Product2>{testProduct.id => testProduct}; 
	}
	
	private static void assertUpdateOrderItemQuantities(List<OrderItem> resultOrderItemList) {
    	System.assertEquals(TEST_ACTIVATED_ORDER_ID_SET, MOCK_ORDER_ITEM_SELECTOR.receivedOrderIdSet);

    	Map<Id, Product2> expectedProductMap = new Map<Id, Product2>{TEST_PRICEBOOK_ENTRY.Product2Id => TEST_PRICEBOOK_ENTRY.Product2};
    	System.assertEquals(expectedProductMap, MOCK_ORDER_ITEM_SELECTOR.receivedProductMap);
    	
    	System.assertEquals(MOCK_ORDER_ITEM_SELECTOR.returnedProductMap.values(), MOCK_GENERIC_DML.updatedSObjectListList[0]);
    	System.assertEquals(TEST_ORDER_ITEM_LIST, resultOrderItemList);
	}
    
} 