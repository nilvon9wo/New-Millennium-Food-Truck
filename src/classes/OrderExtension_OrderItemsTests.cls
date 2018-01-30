@isTest
public class OrderExtension_OrderItemsTests {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static final TEST_InsertModeEnum MOCK_INSERT = TEST_InsertModeEnum.MOCK_INSERT; 
	private static final Order TEST_ORDER = OrderTestDataFactory.create(MOCK_INSERT);

	private static final Integer TEST_PRICEBOOK_ENTRY_QUANTITY = 1;
	private static final PricebookEntryTestDataFactory.Bundle TEST_PRICEBOOK_ENTRY_BUNDLE = PricebookEntryTestDataFactory.createBundle(
		TEST_PRICEBOOK_ENTRY_QUANTITY, MOCK_INSERT, TEST_InsertRelationshipsEnum.INCLUDE
	);
	private static final List<PricebookEntry> TEST_PRICEBOOK_ENTRY_LIST = TEST_PRICEBOOK_ENTRY_BUNDLE.pricebookEntryList;
	private static final List<Product2> TEST_PRODUCT_LIST = TEST_PRICEBOOK_ENTRY_BUNDLE.productList;

	private static final ApexPages.StandardController TEST_STANDARD_CONTROLLER = new ApexPages.StandardController(TEST_ORDER);

	private static final DatabaseHelperMock MOCK_DATABASE_HELPER = new DatabaseHelperMock();
	private static final F45_DML_GenericDmlMock MOCK_GENERIC_DML = new F45_DML_GenericDmlMock();  
	private static final OrderSelectorMock MOCK_ORDER_SELECTOR = createMockOrderSelector();  
	private static final PricebookEntrySelectorMock MOCK_PRICEBOOK_ENTRY_SELECTOR = createMockPricebookEntrySelector();
	private static final Product2HelperMock MOCK_PRODUCT_HELPER = new Product2HelperMock(); 
	private static final ProductSelectorMock MOCK_PRODUCT_SELECTOR = createMockProductSelector();
	private static final VisualForceHelperMock MOCK_VISUALFORCE_HELPER = new VisualForceHelperMock();
    	 
	private static final OrderExtension EXTENSION_UNDER_TEST = new OrderExtension(  
		TEST_STANDARD_CONTROLLER,
		MOCK_DATABASE_HELPER,  
		MOCK_GENERIC_DML,
		MOCK_ORDER_SELECTOR,
		MOCK_PRICEBOOK_ENTRY_SELECTOR,	
		MOCK_PRODUCT_HELPER, 
		MOCK_PRODUCT_SELECTOR,
		MOCK_VISUALFORCE_HELPER	
	);
	
	private static final Integer TEST_ORDER_ITEM_QUANTITY = 2;
	private static final OrderItemTestDataFactory.Bundle TEST_ORDER_ITEM_BUNDLE = OrderItemTestDataFactory.createBundle(
		TEST_ORDER_ITEM_QUANTITY, MOCK_INSERT, TEST_InsertRelationshipsEnum.INCLUDE
	);
	private static final List<OrderItem> TEST_ORDER_ITEM_LIST = TEST_ORDER_ITEM_BUNDLE.orderItemList;
	private static final OrderItem TEST_ORDER_ITEM = TEST_ORDER_ITEM_LIST[0];
	
	// save Tests ------------------------------------------------------------------------------------------

	@isTest private static void testSaveShouldSaveOrderRecordAndOrderItems() {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = false; 
		MOCK_GENERIC_DML.deleteThrowsDmlException = false; 
		
		EXTENSION_UNDER_TEST.orderRecord = TEST_ORDER;
		TEST_ORDER.Pricebook2Id = PricebookTestDataFactory.EXAMPLE_ID;

		OrderItem orderItemToUpsert = TEST_ORDER_ITEM_LIST[0];
		OrderItem orderItemToDelete = TEST_ORDER_ITEM_LIST[1]; 
		EXTENSION_UNDER_TEST.orderItemMap = prepareOrderItemByProductIdMap(orderItemToUpsert, orderItemToDelete);
		
		SavePoint testSavePoint = Database.setSavePoint();  
		MOCK_DATABASE_HELPER.returnedSavePoint = testSavePoint;

		// Act 
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.save();
		}
		Test.stopTest();
		
		// Assert
		System.assert(MOCK_DATABASE_HELPER.savePointCreated);
		System.assertEquals(2, MOCK_GENERIC_DML.upsertedSObjectListList.size());

		// Check Order Upserted	
		List<Order> resultOrderUpsertedList = (List<Order>) MOCK_GENERIC_DML.upsertedSObjectListList[0];
		System.assertEquals(1, resultOrderUpsertedList.size());
		Order resultOrder = (Order) resultOrderUpsertedList[0];
		System.assertEquals(TEST_ORDER, resultOrder);
		System.assertEquals(PricebookTestDataFactory.EXAMPLE_ID, resultOrder.Pricebook2Id);
		
		// Check Order Item Upserted	
		List<OrderItem> resultOrderItemUpsertedList = (List<OrderItem>) MOCK_GENERIC_DML.upsertedSObjectListList[1];
		System.assertEquals(1, resultOrderItemUpsertedList.size());
		System.assertEquals(orderItemToUpsert, resultOrderItemUpsertedList[0]);

		// Check Order Item Deleted	
		System.assertEquals(1, MOCK_GENERIC_DML.deletedSObjectListList.size());
		List<OrderItem> resultOrderItemDeletedList = (List<OrderItem>) MOCK_GENERIC_DML.deletedSObjectListList[0];
		System.assertEquals(1, resultOrderItemDeletedList.size());
		System.assertEquals(orderItemToDelete, resultOrderItemDeletedList[0]);
	}
	
	@isTest private static void testSaveShouldRollbackOnSaveOrderRecordFailure() {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = true; 
		MOCK_GENERIC_DML.deleteThrowsDmlException = false; 
		
		EXTENSION_UNDER_TEST.orderRecord = TEST_ORDER;
		TEST_ORDER.Pricebook2Id = PricebookTestDataFactory.EXAMPLE_ID;
		
		SavePoint testSavePoint = Database.setSavePoint(); 
		MOCK_DATABASE_HELPER.returnedSavePoint = testSavePoint;

		// Act 
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.save();
		}
		Test.stopTest();
		
		// Assert
		System.assert(MOCK_DATABASE_HELPER.savePointCreated);
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList.size());

		// Check Order Upserted	
		List<Order> resultOrderUpsertedList = (List<Order>) MOCK_GENERIC_DML.upsertedSObjectListList[0];
		System.assertEquals(1, resultOrderUpsertedList.size());
		Order resultOrder = (Order) resultOrderUpsertedList[0];
		System.assertEquals(TEST_ORDER, resultOrder);
		System.assertEquals(PricebookTestDataFactory.EXAMPLE_ID, resultOrder.Pricebook2Id);
		
		assertRollback(testSavePoint);
	}
	
	@isTest private static void testSaveShouldRollbackOnSaveOrderItemsFailure() {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = false; 
		MOCK_GENERIC_DML.deleteThrowsDmlException = true; 
		
		EXTENSION_UNDER_TEST.orderRecord = TEST_ORDER;
		TEST_ORDER.Pricebook2Id = PricebookTestDataFactory.EXAMPLE_ID;

		OrderItem orderItemToUpsert = TEST_ORDER_ITEM_LIST[0];
		OrderItem orderItemToDelete = TEST_ORDER_ITEM_LIST[1]; 
		EXTENSION_UNDER_TEST.orderItemMap = prepareOrderItemByProductIdMap(orderItemToUpsert, orderItemToDelete);
		
		SavePoint testSavePoint = Database.setSavePoint();  
		MOCK_DATABASE_HELPER.returnedSavePoint = testSavePoint;

		// Act 
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.save();
		}
		Test.stopTest();
		
		// Assert
		System.assert(MOCK_DATABASE_HELPER.savePointCreated);
		System.assertEquals(2, MOCK_GENERIC_DML.upsertedSObjectListList.size());

		// Check Order Upserted	
		List<Order> resultOrderUpsertedList = (List<Order>) MOCK_GENERIC_DML.upsertedSObjectListList[0];
		System.assertEquals(1, resultOrderUpsertedList.size());
		Order resultOrder = (Order) resultOrderUpsertedList[0];
		System.assertEquals(TEST_ORDER, resultOrder);
		System.assertEquals(PricebookTestDataFactory.EXAMPLE_ID, resultOrder.Pricebook2Id);
		
		// Check Order Item Upserted	
		List<OrderItem> resultOrderItemUpsertedList = (List<OrderItem>) MOCK_GENERIC_DML.upsertedSObjectListList[1];
		System.assertEquals(1, resultOrderItemUpsertedList.size());
		System.assertEquals(orderItemToUpsert, resultOrderItemUpsertedList[0]);

		// Check Order Item Deleted	
		System.assertEquals(1, MOCK_GENERIC_DML.deletedSObjectListList.size());
		List<OrderItem> resultOrderItemDeletedList = (List<OrderItem>) MOCK_GENERIC_DML.deletedSObjectListList[0];
		System.assertEquals(1, resultOrderItemDeletedList.size());
		System.assertEquals(orderItemToDelete, resultOrderItemDeletedList[0]);

		assertRollback(testSavePoint);
	}

	// saveOrderItems Tests ------------------------------------------------------------------------------------------

	@isTest private static void testSaveOrderItemsShouldUpsertAndDeleteOrderItems() {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = false; 
		MOCK_GENERIC_DML.deleteThrowsDmlException = false; 
		
		OrderItem orderItemToUpsert = TEST_ORDER_ITEM_LIST[0];
		OrderItem orderItemToDelete = TEST_ORDER_ITEM_LIST[1]; 
		EXTENSION_UNDER_TEST.orderItemMap = prepareOrderItemByProductIdMap(orderItemToUpsert, orderItemToDelete);

		// Act 
		Boolean result; 
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.saveOrderItems();
		}
		Test.stopTest();
		
		// Assert
		System.assert(result);
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList.size());
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList[0].size());
		System.assertEquals(orderItemToUpsert, MOCK_GENERIC_DML.upsertedSObjectListList[0][0]);

		System.assertEquals(1, MOCK_GENERIC_DML.deletedSObjectListList.size());
		System.assertEquals(1, MOCK_GENERIC_DML.deletedSObjectListList[0].size());
		System.assertEquals(orderItemToDelete, MOCK_GENERIC_DML.deletedSObjectListList[0][0]);
	}
	
	@isTest private static void testSaveOrderItemsShouldReturnFalseOnUpsertFailure() {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = true; 
		MOCK_GENERIC_DML.deleteThrowsDmlException = false; 
		
		OrderItem orderItemToUpsert = TEST_ORDER_ITEM_LIST[0];
		OrderItem orderItemToDelete = TEST_ORDER_ITEM_LIST[1]; 
		EXTENSION_UNDER_TEST.orderItemMap = prepareOrderItemByProductIdMap(orderItemToUpsert, orderItemToDelete);

		// Act 
		Boolean result;
		Test.startTest(); 
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.saveOrderItems();
		}
		Test.stopTest();
		
		// Assert
		System.assert(!result);
	}
	
	@isTest private static void testSaveOrderItemsShouldReturnFalseOnDeleteFailure()  {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = false;  
		MOCK_GENERIC_DML.deleteThrowsDmlException = true; 
		
		OrderItem orderItemToUpsert = TEST_ORDER_ITEM_LIST[0];
		OrderItem orderItemToDelete = TEST_ORDER_ITEM_LIST[1]; 
		EXTENSION_UNDER_TEST.orderItemMap = prepareOrderItemByProductIdMap(orderItemToUpsert, orderItemToDelete);

		// Act  
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.saveOrderItems();
		}
		Test.stopTest();
		
		// Assert
		System.assert(!result);
	}

	// buildOrderItemListByDmlOperationMap Tests ------------------------------------------------------------------------------------------

	@isTest private static void testBuildOrderItemListByDmlOperationMapShouldSeparateRecordsForUpsertFromRecordsForDeletion() {
		// Arrange
		OrderItem orderItemToUpsert = TEST_ORDER_ITEM_LIST[0];
		OrderItem orderItemToDelete = TEST_ORDER_ITEM_LIST[1]; 
		EXTENSION_UNDER_TEST.orderItemMap = prepareOrderItemByProductIdMap(orderItemToUpsert, orderItemToDelete);

		// Act 
		Map<OrderExtension.DmlOperation, List<OrderItem>> resultOrderItemListByDmlOperationMap;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultOrderItemListByDmlOperationMap = EXTENSION_UNDER_TEST.buildOrderItemListByDmlOperationMap();
		}
		Test.stopTest(); 
		
		// Assert
		System.assertEquals(2, resultOrderItemListByDmlOperationMap.size());

		List<OrderItem> resultOrderItemToUpsertList = resultOrderItemListByDmlOperationMap.get(OrderExtension.DmlOperation.FOR_UPSERT);
		System.assertEquals(1, resultOrderItemToUpsertList.size());
		System.assertEquals(orderItemToUpsert, resultOrderItemToUpsertList[0]);

		List<OrderItem> resultOrderItemToDeleteList = resultOrderItemListByDmlOperationMap.get(OrderExtension.DmlOperation.FOR_DELETE);
		System.assertEquals(1, resultOrderItemToDeleteList.size());
		System.assertEquals(orderItemToDelete, resultOrderItemToDeleteList[0]);
	}

	// deleteOrderItems Tests ------------------------------------------------------------------------------------------

	@isTest private static void testUpsertOrderItemsShouldUpsertOrderItems()  {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = false; 

		// Act 
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.upsertOrderItems(TEST_ORDER_ITEM_LIST);
		}
		Test.stopTest();
		
		// Assert
		System.assert(result); 
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList.size());
		System.assertEquals(TEST_ORDER_ITEM_LIST, MOCK_GENERIC_DML.upsertedSObjectListList[0]);
	}
	
	@isTest private static void testUpsertOrderItemsShouldReturnFalseOnFailure() {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = true; 

		// Act 
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.upsertOrderItems(TEST_ORDER_ITEM_LIST);
		}
		Test.stopTest();
		
		// Assert
		System.assert(!result);
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList.size());
		System.assertEquals(TEST_ORDER_ITEM_LIST, MOCK_GENERIC_DML.upsertedSObjectListList[0]);
	}

	// deleteOrderItems Tests ------------------------------------------------------------------------------------------

	@isTest private static void testDeleteOrderItemsShouldDeleteOrderItems() {
		// Arrange
		MOCK_GENERIC_DML.deleteThrowsDmlException = false; 

		// Act 
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.deleteOrderItems(TEST_ORDER_ITEM_LIST);
		}
		Test.stopTest();
		
		// Assert
		System.assert(result); 
		System.assertEquals(1, MOCK_GENERIC_DML.deletedSObjectListList.size());
		System.assertEquals(TEST_ORDER_ITEM_LIST, MOCK_GENERIC_DML.deletedSObjectListList[0]);
	}
	
	@isTest private static void testDeleteOrderItemsShouldReturnFalseOnFailure() {
		// Arrange
		MOCK_GENERIC_DML.deleteThrowsDmlException = true; 

		// Act 
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.deleteOrderItems(TEST_ORDER_ITEM_LIST);
		}
		Test.stopTest();
		
		// Assert
		System.assert(!result);
		System.assertEquals(1, MOCK_GENERIC_DML.deletedSObjectListList.size());
		System.assertEquals(TEST_ORDER_ITEM_LIST, MOCK_GENERIC_DML.deletedSObjectListList[0]);
	}
	
	// onDmlFailure Tests ------------------------------------------------------------------------------------------

	@isTest private static void testOnDmlFailureShouldRollbackAndDisplayMessge() {
		// Arrange
		SavePoint testSavePoint = Database.setSavePoint(); 

		// Act 
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.onDmlFailure(testSavePoint);
		}
		Test.stopTest();
		
		// Assert
		assertRollback(testSavePoint);
	}

	// Helpers -------------------------------------------------------------------------------
	
	private static OrderSelectorMock createMockOrderSelector() {
		OrderSelectorMock mockOrderSelector = new OrderSelectorMock();
		mockOrderSelector.returnedOrderList = new List<Order>{TEST_ORDER};
		return mockOrderSelector;
	}

	private static PricebookEntrySelectorMock createMockPricebookEntrySelector() {
		PricebookEntrySelectorMock mockPricebookEntrySelector = new PricebookEntrySelectorMock();
		mockPricebookEntrySelector.returnedPricebookEntryList = TEST_PRICEBOOK_ENTRY_LIST;
		return mockPricebookEntrySelector; 
	}

	private static ProductSelectorMock createMockProductSelector() {
		ProductSelectorMock mockProductSelector = new ProductSelectorMock();
		mockProductSelector.returnedProductList = TEST_PRODUCT_LIST;
		return mockProductSelector; 
	}

	private static OrderItem createOrderItemWithProductId(Id productId) {
		Map<String, Object> mappedOrderItem = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(TEST_ORDER_ITEM));	
		mappedOrderItem.put('Product2Id', String.valueOf(productId));
		return (OrderItem) JSON.deserialize(JSON.serialize(mappedOrderItem), OrderItem.class);
	}

	private static Map<Id,OrderItem> prepareOrderItemByProductIdMap(OrderItem orderItemToUpsert, OrderItem orderItemToDelete) {
		orderItemToUpsert.Quantity = 2;
		orderItemToDelete.Quantity = 0;

		return new Map<Id,OrderItem>{
			orderItemToUpsert.PriceBookEntry.Product2Id => orderItemToUpsert,
			orderItemToDelete.PriceBookEntry.Product2Id => orderItemToDelete
		};
	}
	
	private static void assertRollback(Savepoint testSavepoint) {
		System.assertEquals(testSavePoint, MOCK_DATABASE_HELPER.receivedSavePoint);
		System.assertEquals(Constants.ERROR_MESSAGE, MOCK_VISUALFORCE_HELPER.receivedMessage);
	}
}