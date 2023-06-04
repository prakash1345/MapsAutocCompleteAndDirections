@isTest
global class DirectionsHttpCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"predictions": [{"description": "Mock Address"}], "routes": [{"legs": [{"distance": {"text": "Mock Distance", "value": 100}, "duration": {"text": "Mock Duration"}}]}]}');
        res.setStatusCode(200);
        return res; 
    }
}