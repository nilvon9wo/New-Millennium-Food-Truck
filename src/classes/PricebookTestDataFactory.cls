@isTest
public class PricebookTestDataFactory {
	public static final Id STANDARD_PRICEBOOK_ID = (Test.isRunningTest())
			? Test.getStandardPricebookId()
			: [SELECT id FROM PriceBook2 WHERE isStandard = true LIMIT 1].id;
}