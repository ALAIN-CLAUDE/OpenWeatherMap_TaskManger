@isTest
public class OpenWeatherMapBatchTest {
	 @testSetup
    static void setup() {
        // Create test location records
        TestDataFactory.createTestLocations();
    }

    @isTest
    static void testBatchExecution() {
        // Start the batch job
        Test.startTest();
        Database.executeBatch(new OpenWeatherMapBatch());
        Test.stopTest();
        
        // Add assertions as needed
        
        // Check if WeatherInfo records are created for the processed locations
        List<WeatherInfo__c> weatherInfos = [SELECT Id FROM WeatherInfo__c];
        System.assertNotEquals(1, weatherInfos.size(), 'WeatherInfo records should be created');
    }
}