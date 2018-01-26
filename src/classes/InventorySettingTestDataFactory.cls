@isTest
public class InventorySettingTestDataFactory {
    public static final String PREFIX = Inventory_Setting__mdt.SObjectType.getDescribe().getKeyPrefix();
    public static final Id EXAMPLE_ID = PREFIX + '3E000003NYTS';
	public static final String DEFAULT_NAME_PREFIX = 'Inventory ';
	public static final Integer DEFAULT_LOW_QUANTITY_ALERT = 3;

    public static List<Inventory_Setting__mdt> createList(List<Map<String, Object>> templateValueByPropertyMapList) {
        List<Inventory_Setting__mdt> inventorySettingList = new List<Inventory_Setting__mdt>();
        for (Integer i = 0; i < templateValueByPropertyMapList.size(); i++) {
        	Map<String, Object> templateValueByPropertyMap = templateValueByPropertyMapList[i];
        	Map<String, Object> valueByPropertyMap = new Map<String, Object> {
            	'DeveloperName' 
            		=> (String) TEST_DefaultHelper.valueOrDefault(templateValueByPropertyMap.get('DeveloperName'), DEFAULT_NAME_PREFIX + i), 
            	'Low_Quantity_Alert__c' 
            		=> (Integer) TEST_DefaultHelper.valueOrDefault(templateValueByPropertyMap.get('Low_Quantity_Alert__c'), DEFAULT_LOW_QUANTITY_ALERT)
        	};
            inventorySettingList.add((Inventory_Setting__mdt) JSON.deserialize(JSON.serialize(valueByPropertyMap), Inventory_Setting__mdt.class));
        }
         
        TEST_MockInsertHelper.addIds(inventorySettingList);
        return inventorySettingList;
    }
 
    public static List<Inventory_Setting__mdt> createList(List<Product2> productList) {
        List<Map<String, Object>> templateValueByPropertyMapList = new List<Map<String, Object>>();
        for (Product2 product : productList) {
            templateValueByPropertyMapList.add(new Map<String, Object> {
        		'DeveloperName' => product.Name
        	});
        }
        return createList(templateValueByPropertyMapList);
    } 

    public static List<Inventory_Setting__mdt> createList(Integer quantity) {
        List<Map<String, Object>> templateValueByPropertyMapList = new List<Map<String, Object>>();
        for (Integer i = 1; i <= quantity; i++) {
            templateValueByPropertyMapList.add(new Map<String, Object> {});
        }
        return createList(templateValueByPropertyMapList);
    }    


    public static Inventory_Setting__mdt create() {
    	Integer quantity = 1;
    	return createList(quantity)[0];
    }
}