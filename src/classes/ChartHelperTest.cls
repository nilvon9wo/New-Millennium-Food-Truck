@isTest
public class ChartHelperTest {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static final ProductSelectorMock MOCK_PRODUCT_SELECTOR = new ProductSelectorMock(); 
	private static final ChartHelper HELPER_UNDER_TEST = new ChartHelper(MOCK_PRODUCT_SELECTOR);
	
	@isTest public static void testSelectRemainingProductListShouldReturnRemainingProducts() {
		// Arrange
		MOCK_PRODUCT_SELECTOR.returnedChartDataList = new List<ChartHelper.ChartData>(); 
		
		// Act
		List<ChartHelper.ChartData> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = HELPER_UNDER_TEST.selectRemainingProductList();
		}
		Test.stopTest();
		
		// Asset
		System.assertEquals(MOCK_PRODUCT_SELECTOR.returnedChartDataList, resultList);
	}
}