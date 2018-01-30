// A god-object full of "constants" that need to be mutated for testing...
// Let's not count the reasons why this is a bad idea.

// TODO: Refactor so this class does not exist.
public class Constants {
	PriceBookSelector priceBookSelector;
	
	public Constants(PriceBookSelector priceBookSelector) {
		this.priceBookSelector = priceBookSelector;
	}
	
	public Constants() {
		this(new PriceBookSelector());
	}

	// This is a terrible work around, so we can test that code works normally outside of testing.   	
	public static final String ACTIVATED_ORDER_STATUS = 'Activated';
	public static final String DRAFT_ORDER_STATUS = 'Draft';
	public static final String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';
	
	// Existing Chatter Groups prevent SFDC from using the same name when groups are created as test data.  :-(
	public static final String INVENTORY_ANNOUNCEMENTS = ((!Test.isRunningTest()) ? '' : 'TEST ') + 'Inventory Announcements';	

	public static final String INVENTORY_LEVEL_LOW = Label.Inventory_Level_Low;
	public static final String SELECT_ONE = Label.Select_One;
	
	public static final Integer DEFAULT_ROWS = 5;

	public static final List<Schema.PicklistEntry> PRODUCT_FAMILY = Product2.Family.getDescribe().getPicklistValues();

	// Use of Test.isRunningTest is a shitty solution.
	// This constant does not belong here; its presence complicates dependency injection and therefore mocking.	
	public static final Id STANDARD_PRICEBOOK_ID = getStandardPriceBookId();

	@testVisible		
	private static Id getStandardPriceBookId() {
		return (new Constants()).selectStandardPriceBookId();
	}
	
	@testVisible private Boolean TEST_OF_SELECTOR = false; 
	
	@testVisible		
	private Id selectStandardPriceBookId() {
		return (!Test.isRunningTest() || TEST_OF_SELECTOR) 
		? this.priceBookSelector.selectStandardPriceBook().Id
		: PricebookTestDataFactory.STANDARD_PRICEBOOK_ID;
	}
}