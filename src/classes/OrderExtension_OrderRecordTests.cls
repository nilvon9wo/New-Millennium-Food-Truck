@isTest
public class OrderExtension_OrderRecordTests {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static final TEST_InsertModeEnum MOCK_INSERT = TEST_InsertModeEnum.MOCK_INSERT;
	private static final Order TEST_ORDER = OrderTestDataFactory.create(MOCK_INSERT);
	private static final ApexPages.StandardController TEST_STANDARD_CONTROLLER = new ApexPages.StandardController(TEST_ORDER);

	private static final DatabaseHelperMock MOCK_DATABASE_HELPER = new DatabaseHelperMock();
	private static final F45_DML_GenericDmlMock MOCK_GENERIC_DML = new F45_DML_GenericDmlMock();
	private static final OrderSelectorMock MOCK_ORDER_SELECTOR = createMockOrderSelector(); 
	private static final PricebookEntrySelectorMock MOCK_PRICEBOOK_ENTRY_SELECTOR = new PricebookEntrySelectorMock();
	private static final Product2HelperMock MOCK_PRODUCT_HELPER = new Product2HelperMock();
	private static final ProductSelectorMock MOCK_PRODUCT_SELECTOR = new ProductSelectorMock();
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
	
	@isTest private static void testSetOrderRecordShouldNotThrowExceptionWhenStandardControllerHasNotBeenSet() {/* TODO */}
	@isTest private static void testSetOrderRecordShouldSetControllerRecordToCurrentOrderRecordWhenRecordHasNoId() {/* TODO */}
	@isTest private static void testSetOrderRecordShouldSetControllerRecordToUpdatedOrderRecordWhenRecordHasId() {/* TODO */}
	@isTest private static void testQueryOrderRecordShouldGetRecordForIndicatedId(){/* TODO */}
	@isTest private static void testSelectOrderRecordShouldSelectRecordForId() {/* TODO */}
	@isTest private static void testSaveOrderRecordShouldReturnFalseOnFailure() {/* TODO */}
	@isTest private static void testSaveOrderRecordShouldUpsertOrderIntoStandardPricebook() {/* TODO */}
	
	private static OrderSelectorMock createMockOrderSelector() {
		OrderSelectorMock mockOrderSelector = new OrderSelectorMock();
		mockOrderSelector.returnedOrderList = new List<Order>{TEST_ORDER};
		return mockOrderSelector;
	}
}