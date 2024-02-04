public class TestDataFactory {
    public static List<Location__c> createTestLocations() {
        List<Location__c> testLocations = new List<Location__c>();
        testLocations.add(new Location__c(Name='Test Location', Latitude__c='51.5074', Longitude__c='-0.1278'));
        insert testLocations;
        return testLocations;
    }

    public static List<WeatherInfo__c> createTestWeatherInfos(List<Location__c> locations) {
        List<WeatherInfo__c> testWeatherInfos = new List<WeatherInfo__c>();
        
        for (Location__c location : locations) {
            testWeatherInfos.add(new WeatherInfo__c(
                Name = 'Test Weather',
                Icon__c = 'test-icon',
                Feels_Like__c = '25.0',
                Maximum_Temperature__c = '30.0',
                Minimum_Temperature__c = '20.0',
                Temperature__c = '27.0',
                Location__c = location.Id,
                Description__c = 'Test weather description'
            ));
        }
        
        insert testWeatherInfos;
        return testWeatherInfos;
    }
    
    public static User createTestUser() {
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'tasktestuser@example.com',
            Username = 'tasktestuser@example.com',
            ProfileId = profile.Id,
            Alias = 'tuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        return testUser;
    }

    public static Task createTestTask(String subject, Date activityDate, String status) {
        Task testTask = new Task(
            Subject = subject,
            ActivityDate = activityDate,
            Status = status
        );
        insert testTask;
        return testTask;
    }
}