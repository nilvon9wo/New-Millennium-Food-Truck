@isTest
public class DatabaseHelperMock extends DatabaseHelper{
	public Boolean savePointCreated;
	public SavePoint returnedSavePoint;
    public override SavePoint setSavePoint() {
    	this.savePointCreated = true;
    	return this.returnedSavePoint;
    }
    
	public SavePoint receivedSavePoint;
    public override void rollback(SavePoint savePoint) {
    	this.receivedSavePoint = savePoint;
    }
}