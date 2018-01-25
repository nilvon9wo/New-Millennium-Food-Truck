@isTest
public class OrderExtensionTest {
	@isTest private static void testSetOrderRecordShouldNotThrowExceptionWhenStandardControllerHasNotBeenSet() {/* TODO */}
	@isTest private static void testSelectOrderRecordShouldSelectRecordForId() {/* TODO */}
	@isTest private static void testRefreshPieChartShouldAddOrderItemRecordsToPieChart() {/* TODO */}
	@isTest private static void testAddToPieChartShouldAddOrderItemRecordToPieChart() {/* TODO */}
	@isTest private static void testAddToPieChartShouldNotAddRecordsWithoutQuantity() {/* TODO */}
	@isTest private static void testGetOrderItemProductIdShouldReturnOrderItemProductIdIfAvailable() {/* TODO */}
	@isTest private static void testGetOrderItemProductIdShouldReturnOrderItemPricebookEntryProductIdIfProductIdNotAvailable() {/* TODO */}
	@isTest private static void testGetOrderItemProductIdShouldReturnNullIfPricebookEntryProductIdNotAvailable() {/* TODO */}
	@isTest private static void testPopulateOrderItemListShouldCreateOrderItemList() {/* TODO */}
	@isTest private static void testPopulateOrderItemListShouldIgnorePricebookEntriesWithoutProductId() {/* TODO */}
	@isTest private static void testPopulateOrderItemListShouldCreateNewOrderItemsIfItemsAreNotInOrderItemByProductMap() {/* TODO */}
	@isTest private static void testOnFieldChangeShouldUpdatePieChart() {/* TODO */}
	@isTest private static void testSelectFamilyShouldResetControllerAndRepopulateOrderItemList() {/* TODO */}
	@isTest private static void testSaveShouldSaveOrderRecordAndOrderItems() {/* TODO */}
	@isTest private static void testSaveShouldRollbackOnFailure() {/* TODO */}
	@isTest private static void testSaveOrderRecordShouldUpsertOrderIntoStandardPricebook() {/* TODO */}
	@isTest private static void testSaveOrderRecordShouldReturnFalseOnFailure() {/* TODO */}
	@isTest private static void testSaveOrderItemsShouldUpsertAndDeleteOrderItems() {/* TODO */}
	@isTest private static void testSaveOrderItemsShouldReturnFalseOnFailure() {/* TODO */}
	@isTest private static void testUpsertOrderItemsShouldUpsertAndDeleteOrderItems() {/* TODO */}
	@isTest private static void testUpsertOrderItemsShouldReturnFalseOnFailure() {/* TODO */}
	@isTest private static void testDeleteOrderItemsShouldUpsertAndDeleteOrderItems() {/* TODO */}
	@isTest private static void testDeleteOrderItemsShouldReturnFalseOnFailure() {/* TODO */}
	@isTest private static void testBuildOrderItemListByDmlOperationMapShouldSeparateRecordsForUpsertFromRecordsForDeletion() {/* TODO */}
	@isTest private static void testOnDmlFailureShouldRollbackAndDisplayMessge() {/* TODO */}
	@isTest private static void testPreserveValuesShouldTranscribeOrderQuantitiesIntoMap() {/* TODO */}
	@isTest private static void testGetFamilyOptionsShouldReturnOptionsForProductFamily() {/* TODO */}
}