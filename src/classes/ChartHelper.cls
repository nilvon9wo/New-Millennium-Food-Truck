public without sharing virtual class ChartHelper {
	ProductSelector productAggregateSelector;
	
	public ChartHelper(ProductSelector productAggregateSelector) {
		this.productAggregateSelector = productAggregateSelector;
	}

	public ChartHelper() {
		this(new ProductSelector());
	}

	@AuraEnabled
    public static List<ChartData> getInventory(){
    	return (new ChartHelper()).selectRemainingProductList();
    }
    
    public virtual List<ChartData> selectRemainingProductList() {
    	List<ChartData> chartDataList = new List<ChartData>();
    	for (AggregateResult aggregateResult: this.productAggregateSelector.aggregateRemainingProduct()) {
    		String family = (String) aggregateResult.get('family');
    		Integer total = Integer.valueOf(aggregateResult.get('total'));
    		chartDataList.add(new ChartData(family, total));
    	}
    	return ChartDataList;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }
}