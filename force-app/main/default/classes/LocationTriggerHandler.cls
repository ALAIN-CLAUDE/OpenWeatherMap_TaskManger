/**
 * @description       : this class is used as handler for the apex trigger for a new or updated location record 
 * @author            : alainclaudebe@outlook.com
 * @group             : 
 * @last modified on  : 02-05-2024
**/

public class LocationTriggerHandler {

    public static void handleTrigger(List<Location__c> newLocations, Map<Id, Location__c> oldLocationMap, System.TriggerOperation operation) {
        if (operation == System.TriggerOperation.AFTER_INSERT) {
            afterInsert(newLocations);
        } else if (operation == System.TriggerOperation.AFTER_UPDATE) {
            afterUpdate(newLocations);
        }
    }
	
    
    private static void processLocations(List<Location__c> locations) {
        List<OpenWeatherMapService.LocationData> locationDataList = new List<OpenWeatherMapService.LocationData>();

        for (Location__c location : locations) {
            String latString = location.Latitude__c;
            String lonString = location.Longitude__c;
            Double lat = Double.valueOf(latString);
            Double lon = Double.valueOf(lonString);
            locationDataList.add(new OpenWeatherMapService.LocationData(lat, lon, location.Id));
        }

        String locationDataListString = JSON.serialize(locationDataList);
        
        
        OpenWeatherMapService.getWeatherInfo(locationDataListString);
    }

    public static void afterInsert(List<Location__c> newLocations) {
        processLocations(newLocations);
    }

    public static void afterUpdate(List<Location__c> updatedLocations) {
        processLocations(updatedLocations);
    }
}
