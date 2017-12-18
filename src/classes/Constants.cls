public class Constants {
	NMFT_PriceBookSelector priceBookSelector;
	
	public Constants(NMFT_PriceBookSelector priceBookSelector) {
		this.priceBookSelector = priceBookSelector;
	}
	
	public Constants() {
		this(new NMFT_PriceBookSelector());
	}
	
	public static Integer DEFAULT_ROWS = 5;
	public static String SELECT_ONE = Label.Select_One;
	public static String INVENTORY_LEVEL_LOW = Label.Inventory_Level_Low;
	public static List<Schema.PicklistEntry> PRODUCT_FAMILY = Product2.Family.getDescribe().getPicklistValues();
	public static String DRAFT_ORDER_STATUS = 'Draft';
	public static String ACTIVATED_ORDER_STATUS = 'Activated';
	public static String INVENTORY_ANNOUNCEMENT = 'Inventory Announcements';
	public static String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';
	public static Id STANDARD_PRICEBOOK_ID = (new Constants()).priceBookSelector.selectStandardPriceBook().Id;
}