@isTest
public class ChartHelperMock extends ChartHelper {
	public List<ChartHelper.ChartData> returnedChartDataList;
    public override List<ChartHelper.ChartData> selectRemainingProductList() { 
    	return this.returnedChartDataList; 
    }
}