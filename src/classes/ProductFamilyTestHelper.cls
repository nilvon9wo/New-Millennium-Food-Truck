@isTest
public class ProductFamilyTestHelper {
    public static void assertSelectOptionList(List<SelectOption> resultSelectOptionList){
		System.assertEquals(Constants.PRODUCT_FAMILY_PICKLIST.size() + 1, resultSelectOptionList.size()); 
		
		Map<String, Boolean> hasValueByPicklistLabelMap = new Map<String, Boolean>{
			Constants.SELECT_ONE => false
		};
		Map<String, String> valueByByPicklistLabelMap = new Map<String, String>{
			Constants.SELECT_ONE => Constants.SELECT_ONE
		};
		for (Schema.PicklistEntry picklistEntry : Constants.PRODUCT_FAMILY_PICKLIST) {
			valueByByPicklistLabelMap.put(picklistEntry.getLabel(), picklistEntry.getValue());
			hasValueByPicklistLabelMap.put(picklistEntry.getLabel(), false);
		} 
		
		for (SelectOption resultSelectOption : resultSelectOptionList) { 
			String optionLabel = resultSelectOption.getLabel();
			String optionValue = resultSelectOption.getValue();
			String picklistValue = valueByByPicklistLabelMap.get(optionLabel); 
			
			hasValueByPicklistLabelMap.put(optionLabel, picklistValue.equals(optionValue));
		}
		
		for (String label: hasValueByPicklistLabelMap.keySet()) {
			System.assert(hasValueByPicklistLabelMap.get(label));
		}
    }
}