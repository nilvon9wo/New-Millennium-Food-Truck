@isTest
public class DatabaseHelperMock extends DatabaseHelper{
	public SavePoint returnedSavePoint;
    public override SavePoint setSavePoint() {
    	return this.returnedSavePoint;
    }
    
	public SavePoint receivedSavePoint;
    public override void rollback(SavePoint savePoint) {
    	this.receivedSavePoint = savePoint;
    }
}