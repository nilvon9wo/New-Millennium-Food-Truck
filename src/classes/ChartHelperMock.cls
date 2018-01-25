@isTest
public class ChartHelperMock extends ChartHelper {
	public List<ProductFamilyDTO> returnedProductFamilyDTOList;
    public override List<ProductFamilyDTO> selectRemainingProductList() {
    	return this.returnedProductFamilyDTOList; 
    }
}  