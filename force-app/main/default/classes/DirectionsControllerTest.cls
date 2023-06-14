@isTest
private class DirectionsControllerTest {
    @isTest 
    static void testGetPlaceAutocomplete() {
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new DirectionsHttpCalloutMock());

        // Run test method and assert results
        Test.startTest();
        List<String> results = DirectionsController.getPlaceAutocomplete('Mock Address');
        Test.stopTest();
        System.assertEquals(1, results.size(), 'Should have one address returned.');
        System.assertEquals('Mock Address', results[0], 'Address should match mock data.');
    }

    @isTest
    static void testGetDirections() {
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new DirectionsHttpCalloutMock());

        // Run test method and assert results
        Test.startTest();
        Map<String, String> directionsData = DirectionsController.getDirections('San Francisco', 'Los Angeles', 'driving');
        Test.stopTest();
        System.assertEquals('10 km', directionsData.get('distance'));
        System.assertEquals('15 mins', directionsData.get('time'));
        // Here you can also validate the cost calculation.
        // Assuming the rate for driving is $0.6/mile, the cost should be about $3.73 (10km is about 6.213 miles)
        // System.assertEquals('3.73', directionsData.get('cost'));
    }

    @isTest
    static void testGetDirections_CustomRate() {
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new DirectionsHttpCalloutMock());

        // Load test data for Transportation_Cost__mdt
        Test.loadData(Transportation_Cost__mdt.SObjectType, 'Test_Transportation_Cost_Data');

        // Run test method and assert results
        Test.startTest();
        Map<String, String> directionsData = DirectionsController.getDirections('San Francisco', 'Los Angeles', 'driving');
        Test.stopTest();
        System.assertEquals('10 km', directionsData.get('distance'));
        System.assertEquals('15 mins', directionsData.get('time'));
        // Validate the cost calculation using the loaded test data
        // Assuming the custom rate for driving is $0.7/mile, the cost should be about $4.36 (10km is about 6.213 miles)
        // System.assertEquals('4.36', directionsData.get('cost'));
    }
}