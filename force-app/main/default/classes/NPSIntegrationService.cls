public class NPSIntegrationService {
    public static List<NPSIntegration.InvocableResult> processOrders(List<String> orderIds) {
        List<NPSIntegration.InvocableResult> results = new List<NPSIntegration.InvocableResult>();        
            results = NPSIntegrationHandler.sendToNPSAPI(orderIds);
            return results;
    }
}