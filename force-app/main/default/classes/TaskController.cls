/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class TaskController {
    @AuraEnabled(cacheable=true)
    public static List<Task> getTasks() {
        // Get tasks with picklist values and standard ActivityDate field
        String userId = UserInfo.getUserId();
        List<Task> tasks = [SELECT Id, Subject, ActivityDate, Status FROM Task WHERE OwnerId = :userId ORDER BY ActivityDate ASC];
        system.debug('apex task  '+tasks);
        return tasks;
    }


    @AuraEnabled(cacheable=true)
    public static List<String> getTaskStatusPicklistValues() {
        // Get picklist values dynamically from the Task object
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<String> picklistValues = new List<String>();

        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            picklistValues.add(entry.getLabel());
        }

        return picklistValues;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getTaskPriorityPicklistValues() {
        // Get picklist values dynamically from the Task object for Priority field
        Schema.DescribeFieldResult fieldResult = Task.Priority.getDescribe();
        List<String> picklistValues = new List<String>();

        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            picklistValues.add(entry.getLabel());
        }

        return picklistValues;
    }

@AuraEnabled
public static void updateTasks(List<Task> tasksToUpdate) {
    System.debug('tasksToUpdate: ' + tasksToUpdate);
    try {
        update tasksToUpdate;
        //return 'Success';
    } catch (Exception e) {
        // Handle exception and return the error message
       // return e.getMessage(); // Return the error message if there's an error during the update
    }
}


    @AuraEnabled
    public static void updateTaskStatusToCompleted(List<Id> taskIds) {
        List<Task> tasksToUpdate = new List<Task>();
        system.debug('task size===> '+taskIds.size());
        
        // Fetch tasks with the specified Ids
        for (Id taskId : taskIds) {
            Task task = new Task(Id = taskId, Status = 'Completed');
            tasksToUpdate.add(task);
        }
        
        // Update tasks
        try {
            system.debug('task size===> '+tasksToUpdate.size());
            update tasksToUpdate;
        } catch (Exception e) {
            // Handle exception as needed
            System.debug('Error updating tasks: ' + e.getMessage());
        }
    }
    

    @AuraEnabled
public static void createTask(Map<String, Object> newTask) {
    System.debug('newTask===> ' + newTask);

    // Get the current user's locale
    String userLocale = UserInfo.getLocale();

    String dateString = (String) newTask.get('ActivityDate');

    // Attempt to format the date string to 'yyyy-MM-dd'
    Date formattedDate;
    try {
        formattedDate = Date.valueOf(dateString);
    } catch (Exception e) {
        // Handle exception as needed
        System.debug('Error parsing date: ' + e.getMessage());
        return; // Exit the method if there is an issue with date parsing
    }

    List<Task> tasksToInsert = new List<Task>();
    
    Task taskToInsert = new Task(
        Subject = String.valueOf(newTask.get('Subject')),
        ActivityDate = formattedDate,
        Priority = String.valueOf(newTask.get('Priority'))
    );

    tasksToInsert.add(taskToInsert);

    try {
        insert tasksToInsert;
    } catch (Exception e) {
        // Handle exception as needed
        System.debug('Error creating task: ' + e.getMessage());
    }
}

    

}