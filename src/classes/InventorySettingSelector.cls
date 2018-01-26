public virtual class InventorySettingSelector {
    public virtual List<Inventory_Setting__mdt> selectAll() {
    	return [
    		SELECT Id, DeveloperName, Low_Quantity_Alert__c  
    		FROM Inventory_Setting__mdt
    	];
    } 
}