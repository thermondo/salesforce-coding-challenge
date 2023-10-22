public with sharing class NPSIntegration {
    
    // Define a class to hold the result of the invocable action
    public class InvocableResult {
        @InvocableVariable(label='Result Message')
        public String message;

        @InvocableVariable(label='Success')
        public Boolean success;

        public InvocableResult(String message, Boolean success) {
            this.message = message;
            this.success = success;
        }
        public InvocableResult() {
            
        }
    }
}