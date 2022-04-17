public with sharing class FreqProdImgCarouselController {
    //public FreqProdImgCarouselController() {
    //
    //}
    @AuraEnabled(cacheable=true)
    public static List<Product2> getFrequentProducts(Id product2Id){
        List<frequentlyBoughtTogether.request> rqts = new List<frequentlyBoughtTogether.request>();
        frequentlyBoughtTogether.request rqt = new frequentlyBoughtTogether.request();
        rqt.Product2Id = product2Id;
        rqts.add(rqt);
        List<frequentlyBoughtTogether.Result> rslts = frequentlyBoughtTogether.frequentlyBoughtTogether(rqts);
        List<Product2> rsltsProducts = rslts[0].frequentProducts;
        return rsltsProducts;
    }
}
