@isTest
public class InventorySettingSelectorMock extends InventorySettingSelector {
	public List<Inventory_Setting__mdt> returnedInventorySettingList;
    public override List<Inventory_Setting__mdt> selectAll() {
    	return returnedInventorySettingList;
    } 
}