public class NMFT_PriceBookSelector {
	public static String STANDARD_PRICE_BOOK_NAME = 'Standard Price Book';
	
    public Pricebook2 selectStandardPriceBook() {
    	return [
    		SELECT Id
    		FROM Pricebook2
    		WHERE Name = :STANDARD_PRICE_BOOK_NAME
    	];
    }
}