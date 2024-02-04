@isTest
public class OpenWeatherMapBatchSchedulerTest {
    @testSetup
    static void setup() {
        // Create test location records
        TestDataFactory.createTestLocations();
    }
    @isTest
    static void testScheduler() {
        // Call the scheduler
        Test.startTest();
        OpenWeatherMapBatchScheduler scheduler = new OpenWeatherMapBatchScheduler();
        String cronExpression = '0 0 0 1 1 ?'; // Any valid cron expression
        System.schedule('Test Scheduler', cronExpression, scheduler);
        Test.stopTest();
        
        // Verify the updates made by the scheduler
        List<Location__c> loc = [SELECT Id FROM Location__c];
        System.assertEquals(1, loc.size());    
    }
}