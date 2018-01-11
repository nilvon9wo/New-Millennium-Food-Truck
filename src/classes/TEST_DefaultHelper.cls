@isTest
public class TEST_DefaultHelper {
    public static Object valueOrDefault(Object templateValue, Object defaultValue) {
    	return (templateValue != null)
    		? templateValue
    		: defaultValue;
    }
}