/**
 * @description       :This is used to schedule the batch for making callout
 * @author            : alainclaudebe@outlook.com
 * @group             : 
 * @last modified on  : 02-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

global class OpenWeatherMapBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) { 
        OpenWeatherMapBatch batchJob = new OpenWeatherMapBatch();
        Database.executeBatch(batchJob, 200); 
    }
}
