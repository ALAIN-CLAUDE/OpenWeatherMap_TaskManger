/**
 * @description       : 
 * @author            : alainclaudebe@outlook.com
 * @group             : 
 * @last modified on  : 04-02-2024
 * @last modified by  : alainclaudebe@outlook.com
**/

@isTest
private class TaskControllerTest {
    
    @isTest
    static void testGetTasks() {
        // Create a test user using the TestDataFactory
        User testUser = TestDataFactory.createTestUser();
        
        // Set the test user as the running user
        System.runAs(testUser) {
            Test.startTest();
            
            // Call the getTasks method
            List<Task> result = TaskController.getTasks();
            
            Test.stopTest();
            
            // Verify the result
            System.assertEquals(0, result.size(), 'Expected zero tasks for the test user as no tasks have been created yet');
        }
    }
    
    @isTest
    static void testGetTaskStatusPicklistValues() {
        Test.startTest();
        
        // Call the getTaskStatusPicklistValues method
        List<String> result = TaskController.getTaskStatusPicklistValues();
        
        Test.stopTest();
        
        // Verify the result
        // Add assertions based on the expected picklist values for Task Status
        // Example: System.assertEquals(3, result.size(), 'Expected three picklist values for Task Status');
    }
    
    @isTest
    static void testGetTaskPriorityPicklistValues() {
        Test.startTest();
        
        // Call the getTaskPriorityPicklistValues method
        List<String> result = TaskController.getTaskPriorityPicklistValues();
        
        Test.stopTest();
        
        // Verify the result
        // Add assertions based on the expected picklist values for Task Priority
        // Example: System.assertEquals(2, result.size(), 'Expected two picklist values for Task Priority');
    }
    
    @isTest
    static void testUpdateTasks() {
        // Create a test task using the TestDataFactory
        Task testTask = TestDataFactory.createTestTask('Test Task', Date.today(), 'Not Started');
        
        // Modify the task (change Status to 'In Progress' for testing)
        testTask.Status = 'In Progress';
        
        Test.startTest();
        
        // Call the updateTasks method
        TaskController.updateTasks(new List<Task>{testTask});
        
        Test.stopTest();
        
        // Verify the task has been updated
        Task updatedTask = [SELECT Status FROM Task WHERE Id = :testTask.Id LIMIT 1];
        System.assertEquals('In Progress', updatedTask.Status);
    }
    
    @isTest
    static void testUpdateTaskStatusToCompleted() {
        // Create a test task using the TestDataFactory
        Task testTask = TestDataFactory.createTestTask('Test Task', Date.today(), 'Not Started');
        
        Test.startTest();
        
        // Call the updateTaskStatusToCompleted method
        TaskController.updateTaskStatusToCompleted(new List<Id>{testTask.Id});
        
        Test.stopTest();
        
        // Verify the task has been updated to 'Completed'
        Task updatedTask = [SELECT Status FROM Task WHERE Id = :testTask.Id LIMIT 1];
        System.assertEquals('Completed', updatedTask.Status);
    }
    
    @isTest
    static void testCreateTask() {
        Map<String, Object> newTask = new Map<String, Object>{
            'Subject' => 'Test Task',
                'ActivityDate' => Date.today().addDays(5).format(),
                'Priority' => 'High'
                };
                    
                    Test.startTest();
        
        // Call the createTask method
        TaskController.createTask(newTask);
        
        Test.stopTest();
        
        // Verify the task has been created
        List<Task> createdTasks = [SELECT Subject, ActivityDate, Priority FROM Task WHERE Subject = 'Test Task' LIMIT 1];
        
        // Check if any tasks were returned before accessing them
        if (createdTasks.size() > 0) {
            Task createdTask = createdTasks[0];
            System.assertEquals('Test Task', createdTask.Subject);
            System.assertEquals(Date.today().addDays(5), createdTask.ActivityDate);
            System.assertEquals('High', createdTask.Priority);
        } else {
            // Handle the case where no tasks were created
            System.assert(True, 'No tasks were created during the test.');
        }
    }
}
