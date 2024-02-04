/**
 * @description       : 
 * @author            : alainclaudebe@outlook.com
 * @group             : 
 * @last modified on  : 04-02-2024
 * @last modified by  : alainclaudebe@outlook.com
**/

global class OpenWeatherMapBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) { 
        OpenWeatherMapBatch batchJob = new OpenWeatherMapBatch();
        Database.executeBatch(batchJob, 200); 
    }
}
