@isTest
private class LocationWeatherDisplayTest {

    @isTest
    static void testGetLocationWeatherInfo() {
        // Use TestDataFactory to create test data
        List<Location__c> testLocations = TestDataFactory.createTestLocations();
        List<WeatherInfo__c> testWeatherInfos = TestDataFactory.createTestWeatherInfos(testLocations);
        Location__c testLocation = testLocations[0];
        WeatherInfo__c testWeatherInfo = testWeatherInfos[0];

        Test.startTest();

        // Call the getLocationWeatherInfo method
        List<WeatherInfo__c> result = LocationWeatherDisplay.getLocationWeatherInfo(testLocation.Id);

        Test.stopTest();

        // Verify the result
        System.assertEquals(1, result.size(), 'Expected one WeatherInfo record');
        WeatherInfo__c retrievedWeatherInfo = result[0];

        System.assertEquals(testWeatherInfo.Icon__c, retrievedWeatherInfo.Icon__c);
        System.assertEquals(testWeatherInfo.Name, retrievedWeatherInfo.Name);
        System.assertEquals(testWeatherInfo.Feels_Like__c, retrievedWeatherInfo.Feels_Like__c);

    }
}