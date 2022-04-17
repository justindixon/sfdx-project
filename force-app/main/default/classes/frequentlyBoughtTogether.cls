public with sharing class frequentlyBoughtTogether {
    @InvocableMethod(label='Get Frquently Bought Together Products' description='Returns 5 Product2 Ids And Their Purchased Together Frequencies')
    public static List<Result> frequentlyBoughtTogether(Request[] choosenProducts) {
        List<Result> results = new List<Result>();
        Integer limitCalculation = 49500 / choosenProducts.size();
        System.debug(limitCalculation);
        for(Request rqt : choosenProducts) {
            List<OrderItem> PurchasedOrders = [
            SELECT 
                OrderId 
            FROM 
                OrderItem 
            WHERE 
                Product2Id =: (Id)rqt.Product2Id
                AND Quantity > 0
            ORDER BY
                Order.EffectiveDate DESC
            LIMIT 
                :limitCalculation
                ];
        System.debug(PurchasedOrders);
        Set<Id> uniOrders = new Set<Id>();
        for(OrderItem oi : PurchasedOrders) {
            uniOrders.add(oi.OrderId);
        }
        System.debug(uniOrders);    
        AggregateResult[] aggresult = [
                                    SELECT 
                                        Product2Id,
                                        Count(Id)countId
                                    FROM 
                                        OrderItem
                                    WHERE 
                                        Quantity > 0 
                                        AND OrderId =: uniOrders
                                        AND Order.Status = 'Activated'
                                    GROUP BY Product2Id
                                    ORDER BY Count(Id) DESC
                                    LIMIT 5];
        System.debug(aggresult);
        Set<Id> productIds = new Set<Id>();
        for(AggregateResult ar : aggresult) {
            productIds.add((Id)ar.get('Product2Id'));
        }
        System.debug(productIds);    
        List<Product2> frequencyProducts = [SELECT FIELDS(STANDARD), D_Brand2__c, D_Product_Image__c FROM Product2 WHERE Id=:productIds LIMIT 5];    
        System.debug(frequencyProducts);
        Result singleResult = new Result();
        singleResult.frequentProducts = frequencyProducts;    
        System.debug(singleResult);
        results.add(singleResult);
        System.debug(results);    
        }
        return results;
}

public class Result {
    @InvocableVariable(label='Frequent Products' description='Products Bought Together')
    public List<Product2> frequentProducts;
}

public class Request {
    @InvocableVariable(label='Product2Id' description='Input Product2 Id')
    public Id Product2Id;
}

}