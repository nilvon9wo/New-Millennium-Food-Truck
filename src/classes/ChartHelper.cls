public without sharing virtual class ChartHelper {
	ProductSelector productSelector;
	 
	public ChartHelper(ProductSelector productSelector) {
		this.productSelector = productSelector;
	}
 
	public ChartHelper() { 
		this(new ProductSelector());
	}
 
	@AuraEnabled
    public static List<ChartHelper.ChartData> getInventory(){
    	return (new ChartHelper()).selectRemainingProductList(); 
    }
    
    public virtual List<ChartHelper.ChartData> selectRemainingProductList() {
    	return this.productSelector.selectRemainingProductQuantityByFamily();
    }
     
    public class ChartData {
		public String name {get;set;}
	    public Decimal value {get;set;}
	
	    public ChartData(String name, Decimal value) {
	    	this.name = name;
	        this.value = value;
	   	}
    }   
}