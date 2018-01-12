@isTest
public class ChartHelperMock extends ChartHelper {
	public List<ChartData> returnedChartDataList;
    public override List<ChartData> selectRemainingProductList() {
    	return this.returnedChartDataList;
    }
}