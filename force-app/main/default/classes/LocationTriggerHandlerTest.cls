@isTest
public class LocationTriggerHandlerTest {
    
    @testSetup
    static void setup() {
        // Call the utility method to create test data
        TestDataFactory.createTestLocations();
    }

    @isTest
    static void testAfterInsert() {
        // Retrieve the test location created in the @testSetup method
        Location__c testLocation = [SELECT Id,Latitude__c,Longitude__c FROM Location__c LIMIT 1];
        List<Location__c> newLocations = new List<Location__c>{testLocation};
            
        // Test the afterInsert logic
        Test.startTest();
        LocationTriggerHandler.afterInsert(newLocations);
        Test.stopTest();
        
        // Assertions
        // Check if WeatherInfo records are created for the new location
        List<WeatherInfo__c> weatherInfos = [SELECT Id FROM WeatherInfo__c WHERE Location__c = :testLocation.Id];
        System.assertNotEquals(1, weatherInfos.size(), 'WeatherInfo record should be created for the new location');
    }
    
    @isTest
    static void testAfterUpdate() {
        // Retrieve the test location created in the @testSetup method
        Location__c testLocation = [SELECT Id,Latitude__c,Longitude__c FROM Location__c LIMIT 1];
        List<Location__c> updatedLocations = new List<Location__c>{testLocation};
            
        // Test the afterUpdate logic
        Test.startTest();
        LocationTriggerHandler.afterUpdate(updatedLocations);
        Test.stopTest();
        
        // Assertions
        // Check if WeatherInfo records are created for the updated location
        List<WeatherInfo__c> weatherInfos = [SELECT Id FROM WeatherInfo__c WHERE Location__c = :testLocation.Id];
        System.assertNotEquals(1, weatherInfos.size(), 'WeatherInfo record should be created for the updated location');
    }
}