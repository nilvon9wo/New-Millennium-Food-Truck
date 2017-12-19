public class DatabaseHelper {
    public SavePoint setSavePoint() {
    	return Database.setSavePoint();
    }
    
    public void rollback(SavePoint savePoint) {
    	Database.rollback(savePoint); 
    }
} 