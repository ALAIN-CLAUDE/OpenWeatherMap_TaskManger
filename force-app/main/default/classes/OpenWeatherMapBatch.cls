global class OpenWeatherMapBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Latitude__c, Longitude__c FROM Location__c where Latitude__c != null and Longitude__c != null ';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Location__c> scope) {
        // Process each batch of records here
        List<OpenWeatherMapService.LocationData> locationDataList = new List<OpenWeatherMapService.LocationData>();

        for (Location__c location : scope) {
            String latString = location.Latitude__c;
            String lonString = location.Longitude__c;
            Double lat = Double.valueOf(latString);
            Double lon = Double.valueOf(lonString);
            locationDataList.add(new OpenWeatherMapService.LocationData(lat, lon, location.Id));
        }

        String locationDataListString = JSON.serialize(locationDataList);
        OpenWeatherMapService.getWeatherInfoHelper(locationDataList);
    }

    global void finish(Database.BatchableContext BC) {
        // Perform any post-processing if needed
    }
}