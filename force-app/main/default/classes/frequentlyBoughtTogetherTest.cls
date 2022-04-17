@IsTest
public class frequentlyBoughtTogetherTest {
	@TestSetup
    public static void Setup() {
        //For Creating Account Record.
        Account newAcct = new Account();
        newAcct.BillingCity = 'THOMASTOWN';
        newAcct.BillingStreet = '241-243 High Street';
        newAcct.BillingState = 'VIC';
        newAcct.BillingPostalCode = '3074';
        newAcct.Phone='9876543210';
        newAcct.Name = 'Acct';
        Insert newAcct;
        
        //For Creating Contact Record.
        Contact cont = new Contact();
        cont.AccountId = newAcct.Id;
        cont.LastName ='contact1';
        Insert cont;
        
        //For Creating brand Record.
        Brand__c brandInstance = new Brand__c();
        brandInstance.Name='Brand1';
        brandInstance.CurrencyIsoCode = 'AUD';
        Insert brandInstance;
        
        //For Creating Product Records.
        List<Product2> productsList = new List<Product2>();
        for(Integer i=0;i<=20;i++){
        Product2 prod = new Product2();
            prod.Name = 'Product'+i;
            prod.ProductCode = String.valueof(i);
            prod.Family = 'Test Practices';
            prod.IsActive = true;
            prod.D_Brand2__c = brandInstance.Id;
            productsList.add(prod);
        }
        Insert productsList;
        
        // Standard PriceBook.
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        //For Creating PriceBookEntries.
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        for(Integer i=0;i<=20;i++){
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = standardPricebook.Id;
            pbe.Product2Id = productsList[i].Id;
            pbe.UnitPrice = 10;
            pbe.D_Group_Net_Price__c = 10;
            pbe.IsActive = true;
            pbeList.add(pbe);
        }
        Insert pbeList;
        
        //For Creating RetailStore.
        RetailStore retailStoreInstance = new RetailStore();
        retailStoreInstance.Name = 'Retail Store';
        retailStoreInstance.AccountId = newAcct.Id;
        retailStoreInstance.D_Price_Book__c = standardPricebook.Id;
        retailStoreInstance.Country='India';
        retailStoreInstance.City='Jaiput';
        retailStoreInstance.D_Sales_History_JSON_String__c = '[]';
        retailStoreInstance.State = 'Raj';
        retailStoreInstance.D_Account_Type__c = 'I';
        retailStoreInstance.Street = 'Tagore Path';
        retailStoreInstance.PostalCode = '302001';
        retailStoreInstance.D_Type__c = 'Health';
        Insert retailStoreInstance;
        
        //For Creating Visit Records.
        Visit v = new Visit();
        v.ContextId = brandInstance.Id;
        v.PlaceId = retailStoreInstance.Id;
        v.Retail_Store__c = retailStoreInstance.Id;
        v.PlannedVisitStartTime = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        v.PlannedVisitEndTime = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        Insert v;
        
        //For Creating Order.
        Order o = new Order();
        o.AccountId = newAcct.Id;
        o.Status = 'Draft';
        o.Retail_Store__c = retailStoreInstance.Id;
        o.Pricebook2Id = retailStoreInstance.D_Price_Book__c;
        o.EffectiveDate = Date.newInstance(2016, 12, 9);
        o.PoNumber = '1234';
        o.D_Order_Comments__c = 'Notes';
        Insert o;
        
        //For Creating OrderItems.
        OrderItem oItem = new OrderItem();
        oItem.OrderId = o.Id;
        oItem.UnitPrice = pbeList[0].UnitPrice;
        oItem.Quantity = 1;
        oItem.PricebookEntryId = pbeList[0].Id;
        oItem.Product2Id = pbeList[0].Product2Id;
        Insert oItem;
        
        //For Creating InvoiceSales.
        D_Invoice__c invoiceSales = new D_Invoice__c();
        invoiceSales.Name = '1234567';
        invoiceSales.D_Retail_Store__c = retailStoreInstance.Id;
        invoiceSales.D_Processing_Date__c = Date.newInstance(2020, 12, 9);
        Insert invoiceSales;
        
        //For Creating Invoice Line Items.
        D_Invoice_Line_Item__c invoiceLItem = new D_Invoice_Line_Item__c();
        invoiceLItem.Name = '1';
        invoiceLItem.D_Invoice__c = invoiceSales.Id;
        invoiceLItem.D_Sales_Quantity__c = 1;
        invoiceLItem.D_Product__c=productsList[0].Id;
        Insert invoiceLItem;
    }
    
    @IsTest
    public static void testfrequentlyBoughtTogether() {
      List<frequentlyBoughtTogether.request> rqts = new List<frequentlyBoughtTogether.request>();
      frequentlyBoughtTogether.request rqt = new frequentlyBoughtTogether.request();
      Product2 testProduct = [SELECT ID FROM PRODUCT2 LIMIT 1];
      rqt.Product2Id = testProduct.Id;
      rqts.add(rqt);
      List<frequentlyBoughtTogether.Result> rslts = frequentlyBoughtTogether.frequentlyBoughtTogether(rqts);
      List<Product2> rsltsProducts = rslts[0].frequentProducts;  
    }
}