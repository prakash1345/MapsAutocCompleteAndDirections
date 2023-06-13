public with sharing class DirectionsController {
    private static String API_KEY; // replace with your actual API key
    // Your name, Base64 encoded
    private static String vHash = EncodingUtil.base64Encode(Blob.valueOf('Bhanu Prakash')); // replace 'Your Full Name' with your name

    @AuraEnabled
    public static List<String> getPlaceAutocomplete(String input) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<ApiKey__mdt> mylist=[Select apiKeyValue__c from ApiKey__mdt limit 1];
        API_KEY=mylist[0].apiKeyValue__c;
        request.setEndpoint('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' + EncodingUtil.urlEncode(input, 'UTF-8') + '&key=' + API_KEY);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> predictions = (List<Object>) responseData.get('predictions');
            List<String> placeSuggestions = new List<String>();
            for (Object prediction : predictions) {
                Map<String, Object> predictionMap = (Map<String, Object>) prediction;
                placeSuggestions.add((String) predictionMap.get('description'));
            }
            return placeSuggestions;
        }
        return null;
    }
    //...

    //...
    @AuraEnabled
    public static Map<String, String> getDirections(String origin, String destination, String mode) {
        // Call the Google Maps Directions API
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<ApiKey__mdt> mylist=[Select apiKeyValue__c from ApiKey__mdt limit 1];
        API_KEY=mylist[0].apiKeyValue__c;
        request.setEndpoint('https://maps.googleapis.com/maps/api/directions/json?origin=' + EncodingUtil.urlEncode(origin, 'UTF-8') + '&destination=' + EncodingUtil.urlEncode(destination, 'UTF-8') + '&mode=' + mode + '&key=' + API_KEY);
        System.debug(request.getEndpoint());
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // Parse the response
        if (response.getStatusCode() == 200) {
            Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> routes = (List<Object>) responseData.get('routes');
            Map<String, Object> route = (Map<String, Object>) routes.get(0);
            List<Object> legs = (List<Object>) route.get('legs');
            Map<String, Object> leg = (Map<String, Object>) legs.get(0);
            Map<String, Object> distanceMap = (Map<String, Object>) leg.get('distance');
            String distanceText = (String) distanceMap.get('text');
            Integer distanceValue = Integer.valueOf(distanceMap.get('value')); // distance in meters
            Map<String, Object> durationMap = (Map<String, Object>) leg.get('duration');
            String durationText = (String) durationMap.get('text');

            // Calculate cost of travel
            // Fetch the rate from the custom metadata type
            //Transportation_Cost__mdt rateRecord = [SELECT Rate__c FROM Transportation_Cost__mdt WHERE Mode__c = :mode LIMIT 1];
            
            Double rate;
            
            
          Transportation_Cost__mdt costRecord = [SELECT Rate__c FROM Transportation_Cost__mdt WHERE Mode__c = :mode LIMIT 1];
          rate=costRecord.Rate__c;

                
            Double cost = ((distanceValue / 1609.34)*rate).setScale(2); // convert distance from meters to miles
            

            // Prepare the data to return
            Map<String, String> directionsData = new Map<String, String>();
            directionsData.put('distance', distanceText);
            directionsData.put('time', durationText);
            directionsData.put('cost', String.valueOf(cost));

            return directionsData;
        }
        return null;
    }
}