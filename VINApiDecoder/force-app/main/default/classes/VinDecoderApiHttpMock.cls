@isTest
global class VinDecoderApiHttpMock implements HttpCalloutMock {
    private Integer statusCode;
    private String statusReason;

    public VinDecoderApiHttpMock() {
        this.statusCode = 200;
        this.statusReason = 'OK';
    }

    public VinDecoderApiHttpMock(Integer statusCode, String statusReason) {
        this.statusCode = statusCode;
        this.statusReason = statusReason;
    }

    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setStatus(statusReason);
        if (statusCode == 200) {
            // Simulate a successful response
            res.setBody('{"count":1,"message":null,"searchCriteria":"12345678901234567","results":[{"value":"Honda","valueId":null,"variable":"Make","variableId":1}]}');
        } else {
            // Simulate an error response
            res.setBody('{"count":0,"message":"Error","searchCriteria":null,"results":null}');
        }
        return res;
    }
}
