//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class orderSyncModel {

	
    public String sfId;
    public String orderNumber;
    public String customerEmail;
	
	public static orderSyncModel parse(String json) {
		return (orderSyncModel) System.JSON.deserialize(json, orderSyncModel.class);
	}
}