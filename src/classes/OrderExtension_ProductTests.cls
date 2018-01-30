@isTest
public class OrderExtension_ProductTests {
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
	
	private static final Integer TEST_ORDER_ITEM_QUANTITY = 1;
	private static final OrderItemTestDataFactory.Bundle TEST_ORDER_ITEM_BUNDLE = OrderItemTestDataFactory.createBundle(
		TEST_ORDER_ITEM_QUANTITY, MOCK_INSERT, TEST_InsertRelationshipsEnum.INCLUDE
	);
	private static final List<OrderItem> TEST_ORDER_ITEM_LIST = TEST_ORDER_ITEM_BUNDLE.orderItemList;
	private static final OrderItem TEST_ORDER_ITEM = TEST_ORDER_ITEM_LIST[0];

	// preserveValues Tests ------------------------------------------------------------------------------------------

	@isTest private static void testPreserveValuesShouldTranscribeOrderQuantitiesIntoMap() {
		// Arrange
		Id testProductId = ProductTestDataFactory.EXAMPLE_ID; 
		OrderItem testOrderItem = createOrderItemWithProductId(testProductId);
		EXTENSION_UNDER_TEST.orderItemList = new List<OrderItem>{testOrderItem};
		EXTENSION_UNDER_TEST.orderItemMap = new Map<Id,OrderItem>();

		// Act 
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.preserveValues();
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(1, EXTENSION_UNDER_TEST.orderItemMap.size());
		System.assertEquals(testOrderItem, EXTENSION_UNDER_TEST.orderItemMap.get(testProductId));
	}
	
	@isTest private static void testPreserveValuesShouldNotTranscribeOrdersWithoutProductId() {
		// Arrange
		Id testProductId = null; 
		OrderItem testOrderItem = createOrderItemWithProductId(testProductId);
		testOrderItem.Pricebookentry = null;
		EXTENSION_UNDER_TEST.orderItemList = new List<OrderItem>{testOrderItem};
		EXTENSION_UNDER_TEST.orderItemMap = new Map<Id,OrderItem>();

		// Act 
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.preserveValues();
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(0, EXTENSION_UNDER_TEST.orderItemMap.size());
	}


	// onFieldChange Tests ------------------------------------------------------------------------------------------

	@isTest private static void testOnFieldChangeShouldUpdatePieChart() {
		// Arrange
		EXTENSION_UNDER_TEST.orderItemList = TEST_ORDER_ITEM_LIST;
		TEST_ORDER_ITEM.Quantity = 2;
		
		// Act
		Test.startTest();
		System.runAs(TEST_USER) {
			EXTENSION_UNDER_TEST.onFieldChange();
		} 
		Test.stopTest();
		
		// Assert
		List<ChartHelper.ChartData> resultList = EXTENSION_UNDER_TEST.pieData;
		System.assertEquals(1, resultList.size());
		
		ChartHelper.ChartData resultDto = resultList[0];
		System.assertEquals(TEST_ORDER_ITEM.PricebookEntry.Product2.Name, resultDto.name);
		Decimal expectedItemValue = TEST_ORDER_ITEM.Quantity * OrderItemTestDataFactory.DEFAULT_UNIT_PRICE; 
		System.assertEquals(expectedItemValue, resultDto.value);
		System.assertEquals(expectedItemValue, EXTENSION_UNDER_TEST.total);		 
	}

	// refreshPieChart Tests ------------------------------------------------------------------------------------------

	@isTest private static void testRefreshPieChartShouldAddOrderItemRecordsToPieChart() {
		// Arrange
		EXTENSION_UNDER_TEST.orderItemMap = new Map<Id,OrderItem>{
			TEST_ORDER_ITEM.PriceBookEntry.Product2Id => TEST_ORDER_ITEM
		};
		TEST_ORDER_ITEM.Quantity = 2;
		
		// Act
		List<ChartHelper.ChartData> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTENSION_UNDER_TEST.refreshPieChart(TEST_ORDER_ITEM_LIST);
		} 
		Test.stopTest();
		
		// Assert
		System.assertEquals(1, resultList.size());
		
		ChartHelper.ChartData resultDto = resultList[0];
		System.assertEquals(TEST_ORDER_ITEM.PricebookEntry.Product2.Name, resultDto.name);
		Decimal expectedItemValue = TEST_ORDER_ITEM.Quantity * OrderItemTestDataFactory.DEFAULT_UNIT_PRICE; 
		System.assertEquals(expectedItemValue, resultDto.value);
		System.assertEquals(expectedItemValue, EXTENSION_UNDER_TEST.total);		 
		
		System.assertEquals(resultList, EXTENSION_UNDER_TEST.pieData);		 
	} 

	// addToPieChart Tests ------------------------------------------------------------------------------------------
	
	@isTest private static void testAddToPieChartShouldAddOrderItemRecordToPieChart() {
		// Arrange
		EXTENSION_UNDER_TEST.orderItemMap = new Map<Id,OrderItem>{
			TEST_ORDER_ITEM.PriceBookEntry.Product2Id => TEST_ORDER_ITEM
		};
		EXTENSION_UNDER_TEST.total = 0;
	
		TEST_ORDER_ITEM.Quantity = 2;
		
		// Act
		List<ChartHelper.ChartData> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTENSION_UNDER_TEST.addToPieChart(TEST_ORDER_ITEM);
		} 
		Test.stopTest();
		
		// Assert
		System.assertEquals(1, resultList.size());
		
		ChartHelper.ChartData resultDto = resultList[0];
		System.assertEquals(TEST_ORDER_ITEM.PricebookEntry.Product2.Name, resultDto.name);
		Decimal expectedItemValue = TEST_ORDER_ITEM.Quantity * OrderItemTestDataFactory.DEFAULT_UNIT_PRICE; 
		System.assertEquals(expectedItemValue, resultDto.value);
		System.assertEquals(expectedItemValue, EXTENSION_UNDER_TEST.total);		 
		
		System.assertEquals(resultList, EXTENSION_UNDER_TEST.pieData);		 
	} 
	
	@isTest private static void testAddToPieChartShouldNotAddRecordsWithoutQuantity() {
		// Arrange
		EXTENSION_UNDER_TEST.orderItemMap = new Map<Id,OrderItem>{
			TEST_ORDER_ITEM.PriceBookEntry.Product2Id => TEST_ORDER_ITEM
		};
		EXTENSION_UNDER_TEST.total = 0;
		EXTENSION_UNDER_TEST.pieData = new List<ChartHelper.ChartData>();

		TEST_ORDER_ITEM.Quantity = 0;
		
		// Act
		List<ChartHelper.ChartData> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTENSION_UNDER_TEST.addToPieChart(TEST_ORDER_ITEM);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(0, resultList.size());
		System.assertEquals(resultList, EXTENSION_UNDER_TEST.pieData);		 
		System.assertEquals(0, EXTENSION_UNDER_TEST.total);		 
	}

	@isTest private static void testAddToPieChartShouldReturnNullIfPieChartHasNoData() {
		// Arrange
		EXTENSION_UNDER_TEST.orderItemMap = new Map<Id,OrderItem>{
			TEST_ORDER_ITEM.PriceBookEntry.Product2Id => TEST_ORDER_ITEM
		};
		EXTENSION_UNDER_TEST.total = 0;
		EXTENSION_UNDER_TEST.pieData = null;

		TEST_ORDER_ITEM.Quantity = 0;
		
		// Act
		List<ChartHelper.ChartData> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTENSION_UNDER_TEST.addToPieChart(TEST_ORDER_ITEM);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(null, resultList);
		System.assertEquals(null, EXTENSION_UNDER_TEST.pieData);		 
		System.assertEquals(0, EXTENSION_UNDER_TEST.total);		 
	}


	// getOrderItemProductId Tests ------------------------------------------------------------------------------------------

	@isTest private static void testGetOrderItemProductIdShouldReturnOrderItemProductIdIfAvailable() {
		// Arrange
		OrderItem testOrderItem = createOrderItemWithProductId(ProductTestDataFactory.EXAMPLE_ID);
		
		// Act
		Id resultId;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultId = EXTENSION_UNDER_TEST.getOrderItemProductId(testOrderItem);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(ProductTestDataFactory.EXAMPLE_ID, resultId);
	}

	@isTest private static void testGetOrderItemProductIdShouldReturnOrderItemPricebookEntryProductIdIfProductIdNotAvailable() {
		// Arrange
		OrderItem testOrderItem = createOrderItemWithProductId(null);
		testOrderItem.Pricebookentry = createPricebookentryWithProductId(testOrderItem.Pricebookentry, ProductTestDataFactory.EXAMPLE_ID);
		
		// Act
		Id resultId;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultId = EXTENSION_UNDER_TEST.getOrderItemProductId(testOrderItem);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(ProductTestDataFactory.EXAMPLE_ID, resultId);
	}

	@isTest private static void testGetOrderItemProductIdShouldReturnNullIfPricebookEntryProductIdNotAvailable() {
		// Arrange
		OrderItem testOrderItem = createOrderItemWithProductId(null);
		testOrderItem.Pricebookentry = null;
		
		// Act
		Id resultId;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultId = EXTENSION_UNDER_TEST.getOrderItemProductId(testOrderItem);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(null, resultId);
	}

	// getFamilyOptions Tests ------------------------------------------------------------------------------------------
	
	@isTest private static void testGetFamilyOptionsShouldReturnOptionsForProductFamily()  {
		// Arrange
		// Nothing to do here

		// Act 
		List<SelectOption> resultSelectOptionList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultSelectOptionList = EXTENSION_UNDER_TEST.getFamilyOptions();
		}
		Test.stopTest();
		
		// Assert
		ProductFamilyTestHelper.assertSelectOptionList(resultSelectOptionList);
	}
	
	// Helpers ------------------------------------------------------------------------------------------

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

	private static Pricebookentry createPricebookentryWithProductId(Pricebookentry pricebookEntry, Id productId) {
		Map<String, Object> mappedPricebookentry = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(pricebookEntry));	
		mappedPricebookentry.put('Product2Id', String.valueOf(productId));
		return (Pricebookentry) JSON.deserialize(JSON.serialize(mappedPricebookentry), SObject.class);
	}

}