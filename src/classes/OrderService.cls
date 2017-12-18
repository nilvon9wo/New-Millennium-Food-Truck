public class OrderService {
	OrderHelper orderHelper;
	
    public OrderService(OrderHelper orderHelper) {
    	this.orderHelper = orderHelper;
    }
    
    public OrderService() {
    	this(new OrderHelper());
    }
    
    public List<SObject> updateQuantityOrdered(Map<Id, Order> newOrderByIdMap) {
     	return this.orderHelper.updateOrderItemQuantities(newOrderByIdMap.keySet());
    } 
}