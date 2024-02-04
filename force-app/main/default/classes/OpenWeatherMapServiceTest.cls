@isTest
public class OpenWeatherMapServiceTest {

 @testSetup
    static void setup() {
        // Call the utility method to create test data
        TestDataFactory.createTestLocations();
    }
    
    @isTest
    static void testWeatherInfoCreation() {
        // Retrieve the test location created in the @testSetup method
        List<Location__c> testLocations = [SELECT Id, Latitude__c, Longitude__c FROM Location__c LIMIT 1];
        
        // Create LocationData objects from the test locations
        List<OpenWeatherMapService.LocationData> locationDataList = new List<OpenWeatherMapService.LocationData>();
        for (Location__c location : testLocations) {
            locationDataList.add(new OpenWeatherMapService.LocationData(Double.valueOf(location.Latitude__c), Double.valueOf(location.Longitude__c), location.Id));
        }
        
        // Serialize the list of LocationData objects into a string
        String locationDataListString = JSON.serialize(locationDataList);
        
        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new OpenWeatherMapServiceMock());
        
        // Call the asynchronous method for weather info with the mock response
        Test.startTest();
        OpenWeatherMapService.getWeatherInfo(locationDataListString);
        Test.stopTest();
        
        // Assertions
        // Check specific values in the created WeatherInfo records
        WeatherInfo__c weatherInfo = [SELECT Id, Temperature__c, Description__c FROM WeatherInfo__c WHERE Location__c = :testLocations[0].Id LIMIT 1];
        System.assertNotEquals(null, weatherInfo, 'WeatherInfo record should be created for the test location');
        System.assertNotEquals(null, weatherInfo.Temperature__c, 'Temperature should not be null');
        System.assertNotEquals(null, weatherInfo.Description__c, 'Description should not be null');
    }
}