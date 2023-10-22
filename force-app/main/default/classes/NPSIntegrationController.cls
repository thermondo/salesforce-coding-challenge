public class NPSIntegrationController {
    
    private static List<NPSIntegration.InvocableResult> results = new List<NPSIntegration.InvocableResult>();

    @InvocableMethod(label='Send Order Data to NPS API')
    public static List<NPSIntegration.InvocableResult> sendOrderData(List<String> orderIds) {
        try {
            results = NPSIntegrationService.processOrders(orderIds);
        } catch (Exception e) {
            // Log the error
            System.debug('Error: ' + e.getMessage());

            // Create an InvocableResult for the error
            results.add(new NPSIntegration.InvocableResult('Error: ' + e.getMessage(), false));
        }
        return results;
    }

    //TODO and Limitations
    //Log errors for later analysis, and provide meaningful error messages to users when appropriate.
    //Consider using custom exceptions to handle different error scenarios.
    //Restrict the amount of data and resources  code can consume.Common limits include SOQL queries (50,000 rows in a transaction),
    // CPU time (6,000,000 milliseconds), and heap size (6 MB).
    //Max 30 orders processed by NPS API
}