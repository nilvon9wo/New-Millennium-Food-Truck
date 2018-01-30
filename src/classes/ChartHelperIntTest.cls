@isTest
public class ChartHelperIntTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create();  
	
	@isTest public static void testGetInventoryShouldReturnRemainingProducts() { 
		// Arrange
		Product2 testProduct = ProductTestDataFactory.create(TEST_InsertModeEnum.INSERT_NOW);
		
		// Act
		List<ChartHelper.ChartData> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = ChartHelper.getInventory();
		}
		Test.stopTest();
		
		// Asset
		System.assertEquals(1, resultList.size());
		
		ChartHelper.ChartData dto = resultList[0];
		System.assertEquals(testProduct.Family, dto.name);
		System.assertEquals(ProductTestDataFactory.DEFAULT_INITIAL_INVENTORY, dto.value);
	}	 
}