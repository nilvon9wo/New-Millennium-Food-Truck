@isTest
public class OrderExtension_StandardSetControllerTest {
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
	
	@isTest private static void testGetStandardControllerShouldReturnPriceBookEntryController() {/* TODO */}
	@isTest private static void testResetStandardSetControllerShouldReselectPricebookEntryItemsForSelectedFamily(){/* TODO */}
	@isTest private static void testFirstShouldMovePageToFirstPriceBookEntryValuesAndUpdateList(){/* TODO */}
	@isTest private static void testPreviousShouldMovePageToPreviousPriceBookEntryValuesAndUpdateList(){/* TODO */}
	@isTest private static void testGetHasPreviousShouldIndicateWhetherControllerHasPreviousValuesAndUpdateList(){/* TODO */}
	@isTest private static void testNextShouldMovePageToNextPriceBookEntryValuesAndUpdateList(){/* TODO */}
	@isTest private static void testGetHasNextShouldIndicateWhetherControllerHasNextValuesAndUpdateList(){/* TODO */}
	@isTest private static void testLastShouldMovePageToLastPriceBookEntryValuesAndUpdateList(){/* TODO */}
	@isTest private static void testGetPageNumberShouldReturnCurrentPageNumber(){/* TODO */}
	@isTest private static void testGetTotalPagesShouldReturnNumberOfPagesRequiredToDisplayAllRows(){/* TODO */}

	private static OrderSelectorMock createMockOrderSelector() {
		OrderSelectorMock mockOrderSelector = new OrderSelectorMock();
		mockOrderSelector.returnedOrderList = new List<Order>{TEST_ORDER};
		return mockOrderSelector;
	}
}