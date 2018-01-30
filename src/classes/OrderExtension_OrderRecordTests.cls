@isTest
public class OrderExtension_OrderRecordTests {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static final TEST_InsertModeEnum MOCK_INSERT = TEST_InsertModeEnum.MOCK_INSERT;
	private static final Order TEST_ORDER = OrderTestDataFactory.create(MOCK_INSERT);
	private static final Id TEST_ORDER_ID = TEST_ORDER.Id;

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
	
	@isTest private static void testSetOrderRecordShouldSetControllerRecordToCurrentOrderRecordWhenRecordHasNoId() {
		// Arrange
		Order testOrder = TEST_ORDER.clone();
		testOrder.Id = null;
		EXTENSION_UNDER_TEST.standardController = new ApexPages.StandardController(testOrder);

		// Act  
		Order result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.setOrderRecord();
		}
		Test.stopTest();
		
		// Assert 
		System.assertEquals(testOrder, result); 
	}
	
	@isTest private static void testSetOrderRecordShouldSetControllerRecordToUpdatedOrderRecordWhenRecordHasId() {
		// Arrange
		Order testOrder = TEST_ORDER.clone();
		testOrder.Id = TEST_ORDER_ID;
		EXTENSION_UNDER_TEST.standardController = new ApexPages.StandardController(testOrder);
		MOCK_ORDER_SELECTOR.returnedOrderList = new List<Order>{TEST_ORDER};

		// Act 
		Order result;
		Test.startTest();
		System.runAs(TEST_USER) { 
			result = EXTENSION_UNDER_TEST.setOrderRecord();
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(1, MOCK_ORDER_SELECTOR.receivedIdSet.size());
		System.assert(MOCK_ORDER_SELECTOR.receivedIdSet.contains(TEST_ORDER_ID));
		System.assertEquals(testOrder, result); 
	}
	
	@isTest private static void testSetOrderRecordShouldNotThrowExceptionWhenStandardControllerHasNotBeenSet() {
		// Arrange
		EXTENSION_UNDER_TEST.standardController = null;
		EXTENSION_UNDER_TEST.orderRecord = null; 

		// Act 
		Order result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.setOrderRecord();
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(null, result); 
	}

	// selectOrderRecord tests -----------------------------------------------------------------------------------------------

	@isTest private static void testSelectOrderRecordShouldReturnOrder() {
		// Arrange
		Id testOrderId = OrderTestDataFactory.EXAMPLE_ID;
		MOCK_ORDER_SELECTOR.returnedOrderList = new List<Order>{TEST_ORDER}; 

		// Act  
		Order result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.selectOrderRecord(testOrderId);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(1, MOCK_ORDER_SELECTOR.receivedIdSet.size());
		System.assert(MOCK_ORDER_SELECTOR.receivedIdSet.contains(testOrderId));
		System.assertEquals(TEST_ORDER, result);
	}
	
	// saveOrderRecord tests -----------------------------------------------------------------------------------------------

	@isTest private static void testSaveOrderRecordShouldUpsertOrderIntoStandardPricebook() {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = false;
		EXTENSION_UNDER_TEST.orderRecord = TEST_ORDER;
		TEST_ORDER.Pricebook2Id = PricebookTestDataFactory.EXAMPLE_ID;

		// Act 
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.saveOrderRecord();
		}
		Test.stopTest();
		
		// Assert
		System.assert(result); 
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList.size());
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList[0].size());

		Order resultOrder = (Order) MOCK_GENERIC_DML.upsertedSObjectListList[0][0];
		System.assertEquals(TEST_ORDER, resultOrder);
		System.assertEquals(PricebookTestDataFactory.EXAMPLE_ID, resultOrder.Pricebook2Id);
	}
	
	@isTest private static void testSaveOrderRecordShouldSetPricebookToStandardIfNull() {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = false;
		EXTENSION_UNDER_TEST.orderRecord = TEST_ORDER;
		TEST_ORDER.Pricebook2Id = null;

		// Act 
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.saveOrderRecord();
		}
		Test.stopTest();
		
		// Assert
		System.assert(result); 
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList.size());
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList[0].size());

		Order resultOrder = (Order) MOCK_GENERIC_DML.upsertedSObjectListList[0][0];
		System.assertEquals(TEST_ORDER, resultOrder);
		System.assertEquals(Constants.STANDARD_PRICEBOOK_ID, resultOrder.Pricebook2Id);
	}
	
	@isTest private static void testSaveOrderRecordShouldReturnFalseOnFailure() {
		// Arrange
		MOCK_GENERIC_DML.upsertThrowsDmlException = true;
		EXTENSION_UNDER_TEST.orderRecord = TEST_ORDER;

		// Act 
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = EXTENSION_UNDER_TEST.saveOrderRecord();
		}
		Test.stopTest();
		
		// Assert
		System.assert(!result); 
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList.size());
		System.assertEquals(1, MOCK_GENERIC_DML.upsertedSObjectListList[0].size());
		System.assertEquals(TEST_ORDER, MOCK_GENERIC_DML.upsertedSObjectListList[0][0]);
	}
	
	// Helpers -----------------------------------------------------------------------------------------------

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

}