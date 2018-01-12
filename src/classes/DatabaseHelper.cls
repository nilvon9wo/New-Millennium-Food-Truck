public virtual class DatabaseHelper {
    public virtual SavePoint setSavePoint() {
    	return Database.setSavePoint();
    }
    
    public virtual void rollback(SavePoint savePoint) {
    	Database.rollback(savePoint); 
    }
}