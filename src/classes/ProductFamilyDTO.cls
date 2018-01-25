public class ProductFamilyDTO {
	public String name {get;set;}
    public Decimal quantity {get;set;}

    public ProductFamilyDTO(String name, Decimal quantity) {
    	this.name = name;
        this.quantity = quantity;
   	} 
}