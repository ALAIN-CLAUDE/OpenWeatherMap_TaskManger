global class OpenWeatherMapBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) { 
        OpenWeatherMapBatch batchJob = new OpenWeatherMapBatch();
        Database.executeBatch(batchJob, 200); 
    }
}