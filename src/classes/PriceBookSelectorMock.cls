@isTest
public class PriceBookSelectorMock extends PriceBookSelector { 
	public Pricebook2 returnedPriceBook;
    public override Pricebook2 selectStandardPriceBook() {
    	return this.returnedPriceBook;
    }
}