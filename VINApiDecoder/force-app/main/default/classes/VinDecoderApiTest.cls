@isTest
private class VinDecoderApiTest {

    @isTest
    static void testGetAllVehicleInfo_Success() {
        // Mock the HTTP response
        HttpCalloutMock mock = new VinDecoderApiHttpMock();
        Test.setMock(HttpCalloutMock.class, mock);

        // Test VIN number
        String vinNumber = '12345678901234567';

        // Call the method
        Test.startTest();
        Vehicle__c vehicle = VinDecoderApi.getAllVehicleInfo(vinNumber);
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, vehicle, 'Vehicle should not be null');
        System.assertEquals('12345678901234567', vehicle.VIN_External_ID__c, 'VIN should match');
        // Add more assertions for other fields as needed
    }

    @isTest
    static void testGetAllVehicleInfo_HTTPError() {
        // Mock the HTTP response to simulate an error
        HttpCalloutMock mock = new VinDecoderApiHttpMock(500, 'Internal Server Error');
        Test.setMock(HttpCalloutMock.class, mock);

        // Test VIN number
        String vinNumber = '12345678901234567';

        // Call the method
        Test.startTest();
        Vehicle__c vehicle = VinDecoderApi.getAllVehicleInfo(vinNumber);
        Test.stopTest();

        // Verify that the method handles errors gracefully
        System.assertEquals(null, vehicle, 'Vehicle should be null');
    }
}
