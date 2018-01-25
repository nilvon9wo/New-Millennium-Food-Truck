public virtual class PriceBookSelector {
	private static String STANDARD_PRICE_BOOK_NAME = 'Standard Price Book';
	
    public virtual Pricebook2 selectStandardPriceBook() {
    	return [
    		SELECT Id
    		FROM Pricebook2
    		WHERE Name = :STANDARD_PRICE_BOOK_NAME
    		LIMIT 1
    	];
    }
}