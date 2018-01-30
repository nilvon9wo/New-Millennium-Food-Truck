@isTest
public class OrderExtension_OrderRecordIntTests {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	private static final Order TEST_ORDER = OrderTestDataFactory.create(TEST_InsertModeEnum.INSERT_NOW);

	// queryOrderRecord tests ----------------------------------------------1-------------------------------------------------
	
	@isTest private static void testSelectOrderRecordShouldSelectRecordForId() {
		// Arrange
		Id testOrderId = TEST_ORDER.Id;

		// Act 
		Order result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = OrderExtension.queryOrderRecord(testOrderId);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(TEST_ORDER, result);
	}

    
}