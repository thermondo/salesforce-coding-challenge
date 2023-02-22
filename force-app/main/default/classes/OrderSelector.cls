public with sharing class OrderSelector {
    public OrderSelector() {}

    public Set<String> getFields(){
        return new Set<String>{
            'Id',
            'OrderNumber',
            'AccountId.PersonEmail'
        };
    }

    public List<Order> getOrderByIds(Set<Id> ids){
        String baseQuery = 'SELECT {0} FROM {1} WHERE {2}';

        String query = String.format(baseQuery, new List<String>{
            String.join(new List<String>(getFields()),','),
            'Order',
            'Id IN :ids'
        });

        return Database.query(query);
    }
}