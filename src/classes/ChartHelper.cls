public without sharing virtual class ChartHelper {
	ProductSelector productSelector;
	
	public ChartHelper(ProductSelector productSelector) {
		this.productSelector = productSelector;
	}

	public ChartHelper() { 
		this(new ProductSelector());
	}

	@AuraEnabled
    public static List<ProductFamilyDTO> getInventory(){
    	return (new ChartHelper()).selectRemainingProductList();
    }
    
    public virtual List<ProductFamilyDTO> selectRemainingProductList() {
    	Map<String, Integer> remainingProductByFamilyMap = this.productSelector.selectRemainingProductQuantityByFamily();
    	List<ProductFamilyDTO> ProductFamilyDTOList = new List<ProductFamilyDTO>();
    	for (String family : remainingProductByFamilyMap.keySet()) {
    		ProductFamilyDTOList.add(new ProductFamilyDTO(family, remainingProductByFamilyMap.get(family)));
    	}
    	return ProductFamilyDTOList;
    }
} 