public without sharing virtual class ChartHelper {
	ProductSelector productSelector;
	
	public ChartHelper(ProductSelector productSelector) {
		this.productSelector = productSelector;
	}
 
	public ChartHelper() { 
		this(new ProductSelector());
	}
 
	@AuraEnabled
    public static List<ChartData> getInventory(){
    	return (new ChartHelper()).selectRemainingProductList(); 
    }
    
    public virtual List<ChartData> selectRemainingProductList() {
    	return this.productSelector.selectRemainingProductQuantityByFamily();
    } 
}