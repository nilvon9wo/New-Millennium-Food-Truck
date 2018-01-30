@isTest
public class OrderExtension_populateOrderItemTests {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static final TEST_InsertModeEnum MOCK_INSERT = TEST_InsertModeEnum.MOCK_INSERT; 
	private static final Order TEST_ORDER = OrderTestDataFactory.create(MOCK_INSERT);

	private static final Integer TEST_PRICEBOOK_ENTRY_QUANTITY = 1;
	private static final PricebookEntryTestDataFactory.Bundle TEST_PRICEBOOK_ENTRY_BUNDLE = PricebookEntryTestDataFactory.createBundle(
		TEST_PRICEBOOK_ENTRY_QUANTITY, MOCK_INSERT, TEST_InsertRelationshipsEnum.INCLUDE
	);
	private static final List<PricebookEntry> TEST_PRICEBOOK_ENTRY_LIST = TEST_PRICEBOOK_ENTRY_BUNDLE.pricebookEntryList;
	private static final PricebookEntry TEST_PRICEBOOK_ENTRY = TEST_PRICEBOOK_ENTRY_LIST[0];
	
	private static final List<Product2> TEST_PRODUCT_LIST = TEST_PRICEBOOK_ENTRY_BUNDLE.productList;
	private static final Product2 TEST_PRODUCT = TEST_PRODUCT_LIST[0];

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
	
	private static final Integer TEST_ORDER_ITEM_QUANTITY = 1;
	private static final OrderItemTestDataFactory.Bundle TEST_ORDER_ITEM_BUNDLE = OrderItemTestDataFactory.createBundle(
		TEST_ORDER_ITEM_QUANTITY, MOCK_INSERT, TEST_InsertRelationshipsEnum.INCLUDE
	);
	private static final List<OrderItem> TEST_ORDER_ITEM_LIST = TEST_ORDER_ITEM_BUNDLE.orderItemList;
	private static final OrderItem TEST_ORDER_ITEM = TEST_ORDER_ITEM_LIST[0];
	
	// selectFamily Tests ------------------------------------------------------------------------------------------
	
	@isTest private static void testSelectFamilyShouldResetControllerAndRepopulateOrderItemList() {
		// Arrange
		MOCK_PRICEBOOK_ENTRY_SELECTOR.returnedPricebookEntryList = TEST_PRICEBOOK_ENTRY_LIST;
		MOCK_PRODUCT_SELECTOR.returnedProductList = TEST_PRODUCT_LIST;  

		EXTENSION_UNDER_TEST.orderItemByProductIdMap = new Map<Id,OrderItem>();

		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.selectFamily();
		}
		Test.stopTest();

		// Assert	
		System.assertEquals(Constants.DEFAULT_ROWS, EXTENSION_UNDER_TEST.standardSetController.getPageSize());
		
		List<OrderItem> resultOrderItemList = EXTENSION_UNDER_TEST.orderItemList;
		System.assertEquals(1, resultOrderItemList.size());
		
		OrderItem resultOrderItem = resultOrderItemList[0];
		System.assertEquals(TEST_PRICEBOOK_ENTRY, resultOrderItem.PricebookEntry);
		System.assertEquals(TEST_PRICEBOOK_ENTRY.Id, resultOrderItem.PricebookEntryId);
		System.assertEquals(0, resultOrderItem.Quantity);
		System.assertEquals(TEST_PRICEBOOK_ENTRY.UnitPrice, resultOrderItem.UnitPrice);
	}

	// populateOrderItemList Tests ------------------------------------------------------------------------------------------
	
	@isTest private static void testPopulateOrderItemListShouldCreateNewOrderItemsIfItemsAreNotInOrderItemByProductMap() {
		// Arrange
		MOCK_PRICEBOOK_ENTRY_SELECTOR.returnedPricebookEntryList = TEST_PRICEBOOK_ENTRY_LIST;
		MOCK_PRODUCT_SELECTOR.returnedProductList = TEST_PRODUCT_LIST;  

		EXTENSION_UNDER_TEST.orderItemByProductIdMap = new Map<Id,OrderItem>();

		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.populateOrderItemList();
		}
		Test.stopTest();

		// Assert	
		List<OrderItem> resultOrderItemList = EXTENSION_UNDER_TEST.orderItemList;
		System.assertEquals(1, resultOrderItemList.size());
		
		OrderItem resultOrderItem = resultOrderItemList[0];
		System.assertEquals(TEST_PRICEBOOK_ENTRY, resultOrderItem.PricebookEntry);
		System.assertEquals(TEST_PRICEBOOK_ENTRY.Id, resultOrderItem.PricebookEntryId);
		System.assertEquals(0, resultOrderItem.Quantity);
		System.assertEquals(TEST_PRICEBOOK_ENTRY.UnitPrice, resultOrderItem.UnitPrice);
	}
	
	@isTest private static void testPopulateOrderItemListShouldCreateOrderItemList()  {
		// Arrange
		MOCK_PRICEBOOK_ENTRY_SELECTOR.returnedPricebookEntryList = TEST_PRICEBOOK_ENTRY_LIST;
		MOCK_PRODUCT_SELECTOR.returnedProductList = TEST_PRODUCT_LIST;  

		EXTENSION_UNDER_TEST.orderItemByProductIdMap = new Map<Id,OrderItem>{
			TEST_PRODUCT.Id => TEST_ORDER_ITEM
		};

		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.populateOrderItemList();
		}
		Test.stopTest();

		// Assert	
		List<OrderItem> resultOrderItemList = EXTENSION_UNDER_TEST.orderItemList;
		System.assertEquals(1, resultOrderItemList.size());
		
		OrderItem resultOrderItem = resultOrderItemList[0];
		System.assertEquals(TEST_ORDER_ITEM.PricebookEntry, resultOrderItem.PricebookEntry);
		System.assertEquals(TEST_ORDER_ITEM.PricebookEntryId, resultOrderItem.PricebookEntryId);
		System.assertEquals(TEST_ORDER_ITEM.Quantity, resultOrderItem.Quantity);
		System.assertEquals(TEST_ORDER_ITEM.UnitPrice, resultOrderItem.UnitPrice);
	}
	
	@isTest private static void testPopulateOrderItemListShouldIgnorePricebookEntriesWithoutProductId() {
		// Arrange
		PriceBookEntry testPricebookEntry = createPricebookentryWithProductId(TEST_PRICEBOOK_ENTRY, null);
		MOCK_PRICEBOOK_ENTRY_SELECTOR.returnedPricebookEntryList = new List<PricebookEntry>{testPricebookEntry};
		
		MOCK_PRODUCT_SELECTOR.returnedProductList = TEST_PRODUCT_LIST;  
		EXTENSION_UNDER_TEST.orderItemByProductIdMap = new Map<Id,OrderItem>();

		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.populateOrderItemList();
		}
		Test.stopTest();

		// Assert	
		List<OrderItem> resultOrderItemList = EXTENSION_UNDER_TEST.orderItemList;
		System.assertEquals(0, resultOrderItemList.size());
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
	
	private static Pricebookentry createPricebookentryWithProductId(Pricebookentry pricebookEntry, Id productId) {
		Map<String, Object> mappedPricebookentry = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(pricebookEntry));	
		mappedPricebookentry.put('Product2Id', String.valueOf(productId));
		return (Pricebookentry) JSON.deserialize(JSON.serialize(mappedPricebookentry), SObject.class);
	}
}