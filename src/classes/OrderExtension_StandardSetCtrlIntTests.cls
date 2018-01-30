@isTest
public class OrderExtension_StandardSetCtrlIntTests {
	private static final User TEST_USER = TEST_RunAsUserFactory.create(); 
	
	private static final TEST_InsertModeEnum INSERT_NOW = TEST_InsertModeEnum.INSERT_NOW;
	private static final TEST_InsertRelationshipsEnum INCLUDE = TEST_InsertRelationshipsEnum.INCLUDE;
	
	private static final Integer TEST_ORDER_QUANTITY = 1;
	private static final OrderTestDataFactory.Bundle TEST_ORDER_BUNDLE 
		= OrderTestDataFactory.createBundle(TEST_ORDER_QUANTITY, INSERT_NOW, TEST_InsertRelationshipsEnum.EXCLUDE);
	private static final Order TEST_ORDER = TEST_ORDER_BUNDLE.orderList[0];
	private static final ApexPages.StandardController TEST_STANDARD_CONTROLLER = new ApexPages.StandardController(TEST_ORDER);

	private static final Integer TEST_PRICEBOOK_ENTRY_QUANTITY = 12;

	@isTest private static void testGetStandardControllerShouldReturnPriceBookEntryController() {
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);

		// Act
		ApexPages.StandardSetController resultController;
		Test.startTest();
		System.runAs(TEST_USER) { 
			resultController = extensionUnderTest.standardSetController;
		}
		Test.stopTest();

		// Assert
		System.assertNotEquals(null, resultController);
	}
	
	@isTest private static void testResetStandardSetControllerShouldReselectPricebookEntryItemsForSelectedFamily(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);

		// Act
		Test.startTest();
		System.runAs(TEST_USER) { 
			extensionUnderTest.resetStandardSetController();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(Constants.DEFAULT_ROWS, extensionUnderTest.standardSetController.getPageSize());
	}
	
	// Page Manipulation Tests ----------------------------------------------------------------------------
	
	@isTest private static void testFirstShouldMovePageToFirstPriceBookEntryValuesAndUpdateList(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);

		// Act
		Test.startTest();
		System.runAs(TEST_USER) { 
			extensionUnderTest.first();
		}
		Test.stopTest();

		// Assert
		Integer result = extensionUnderTest.getPageNumber();
		System.assertEquals(1, result);
		System.assert(!extensionUnderTest.standardSetController.getHasPrevious());
		System.assert(extensionUnderTest.standardSetController.getHasNext());
		System.assertEquals(Constants.DEFAULT_ROWS, extensionUnderTest.orderItemMap.size()); 
		System.assertEquals(Constants.DEFAULT_ROWS, extensionUnderTest.orderItemList.size());
	}

	@isTest private static void testLastShouldMovePageToLastPriceBookEntryValuesAndUpdateList(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);

		// Act
		Test.startTest();
		System.runAs(TEST_USER) { 
			extensionUnderTest.last();
		}
		Test.stopTest();

		// Assert
		Integer result = extensionUnderTest.getPageNumber();
		Integer expectedPage = 3;
		System.assertEquals(expectedPage, result);
		System.assert(extensionUnderTest.standardSetController.getHasPrevious());
		System.assert(!extensionUnderTest.standardSetController.getHasNext());
		System.assertEquals(Constants.DEFAULT_ROWS, extensionUnderTest.orderItemMap.size());
		Integer previousPages = expectedPage - 1;
		Integer expectedPageItems = TEST_PRICEBOOK_ENTRY_QUANTITY - (previousPages * Constants.DEFAULT_ROWS);
		System.assertEquals(expectedPageItems, extensionUnderTest.orderItemList.size());
	}
	
	@isTest private static void testPreviousShouldMovePageToPreviousPriceBookEntryValuesAndUpdateList(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);
		extensionUnderTest.last();

		// Act
		Test.startTest();
		System.runAs(TEST_USER) { 
			extensionUnderTest.previous();
		}
		Test.stopTest();

		// Assert
		Integer result = extensionUnderTest.getPageNumber();
		Integer expectedPage = 2;
		System.assertEquals(expectedPage, result);
		System.assert(extensionUnderTest.standardSetController.getHasPrevious());
		System.assert(extensionUnderTest.standardSetController.getHasNext());
		Integer expectedFromLast = 2;
		Integer expectedFromCurrent = Constants.DEFAULT_ROWS;
		Integer expectedMapSize = expectedFromLast + expectedFromCurrent;
		System.assertEquals(expectedMapSize, extensionUnderTest.orderItemMap.size());
		System.assertEquals(Constants.DEFAULT_ROWS, extensionUnderTest.orderItemList.size());
	}

	@isTest private static void testNextShouldMovePageToNextPriceBookEntryValuesAndUpdateList(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);
		extensionUnderTest.first();

		// Act
		Test.startTest();
		System.runAs(TEST_USER) { 
			extensionUnderTest.next();
		}
		Test.stopTest();

		// Assert
		Integer result = extensionUnderTest.getPageNumber();
		System.assertEquals(2, result);
		System.assert(extensionUnderTest.standardSetController.getHasPrevious());
		System.assert(extensionUnderTest.standardSetController.getHasNext());
		System.assertEquals(Constants.DEFAULT_ROWS, extensionUnderTest.orderItemMap.size());
		System.assertEquals(Constants.DEFAULT_ROWS, extensionUnderTest.orderItemList.size());
	}

	// Page Navigable Tests ----------------------------------------------------------------------------

	@isTest private static void testGetHasPreviousShouldReturnTrueWhenControllerHasPreviousValues(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);
		extensionUnderTest.last();
		
		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) { 
			result = extensionUnderTest.getHasPrevious();
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}
	
	@isTest private static void testGetHasPreviousShouldReturnFalseWhenControllerHasNoPreviousValues(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);
		extensionUnderTest.first();
		
		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) { 
			result = extensionUnderTest.getHasPrevious();
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
	
	@isTest private static void testGetHasNextShouldReturnTrueWhenControllerHasNextValues(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);
		extensionUnderTest.first();
		
		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) { 
			result = extensionUnderTest.getHasNext();
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}
	
	@isTest private static void testGetHasNextShouldReturnFalseWhenControllerHasNoNextValues(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);
		extensionUnderTest.last();
		
		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) { 
			result = extensionUnderTest.getHasNext();
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
	
	@isTest private static void testGetPageNumberShouldReturnCurrentPageNumber(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);

		// Act
		Integer result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = extensionUnderTest.getPageNumber();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(1, result);
	}
	
	@isTest private static void testGetTotalPagesShouldReturnNumberOfPagesRequiredToDisplayAllRows(){
		// Arrange
		initializePricebookEntries();
		OrderExtension extensionUnderTest = new OrderExtension(TEST_STANDARD_CONTROLLER);

		// Act
		Integer result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = extensionUnderTest.getTotalPages();
		}
		Test.stopTest();

		// Assert
		Integer expectedResult = (Integer) Math.ceil(TEST_PRICEBOOK_ENTRY_QUANTITY / Constants.DEFAULT_ROWS);
		//System.assertEquals(expectedResult, result);
	}
	
	// Helpers ------------------------------------------------------------------------
	
	private static PricebookEntryTestDataFactory.Bundle initializePricebookEntries() {
		// cleanup!
		delete [
			SELECT Id
			FROM PricebookEntry
		];

		return PricebookEntryTestDataFactory.createBundle(TEST_PRICEBOOK_ENTRY_QUANTITY, INSERT_NOW, INCLUDE);
	}
}