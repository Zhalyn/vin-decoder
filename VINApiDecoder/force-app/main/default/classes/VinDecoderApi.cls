public with sharing class VinDecoderApi {

    public class Results {
        public String value;
        public String valueId;
        public String variable;
        public Integer variableId;
    }

    public Integer count;
    public String message;
    public String searchCriteria;
    public List<Results> results;

    public static VinDecoderApi parse(String json) {
        return (VinDecoderApi) System.JSON.deserialize(json, VinDecoderApi.class);
    }

    @AuraEnabled
    public static Vehicle__c getAllVehicleInfo(String vinNumber) {
        final String apiUrl = 'callout:vinDecoder/api/vehicles/decodevin/' + vinNumber+'?format=json';

        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('GET');
            request.setHeader('format', 'json');
            request.setHeader('Content-Type', 'application/json');

            Http http = new Http();
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                VinDecoderApi apiResponse = (VinDecoderApi) JSON.deserialize(response.getBody(), VinDecoderApi.class);

                if (apiResponse != null && apiResponse.results != null && !apiResponse.results.isEmpty()) {
                    Vehicle__c vehicle = new Vehicle__c();
                    String vinExternal = apiResponse.searchCriteria;
                    vehicle.VIN_External_ID__c = vinExternal.substring(vinExternal.length() - 17, vinExternal.length());

                    for (VinDecoderApi.Results result : apiResponse.results) {
                        switch on result.variable {
                            when 'Make' {
                                vehicle.Make__c = result.value;
                            }
                            when 'Model Year' {
                                vehicle.Year__c = String.valueOf(result.value);
                            }
                            when 'Model' {
                                vehicle.Model__c = result.value;
                            }
                            when 'Engine' {
                                vehicle.Engine__c = result.value;
                            }
                            when 'Trim' {
                                vehicle.Trim__c = result.value;
                            }
                            when 'Transmission Style' {
                                vehicle.Transmission__c = result.value;
                            }
                            when 'Manufacturer Name' {
                                vehicle.Manufacturer__c = result.value;
                            }
                            when 'Vehicle Type' {
                                vehicle.Vehicle_Type__c = result.value;
                            }
                            when 'Fuel Type - Primary' {
                                vehicle.Fuel_Type__c = result.value;
                            }
                        }
                    }
                    return vehicle;
                }
            }
            return null;
        } catch (Exception e) {
            System.debug('Error during HTTP Callout: ' + e.getMessage());
            return null;
        }
    }   
}