/**
 * @description       : This class is used to display latest weather record on lwc
 * @author            : alainclaudebe@outlook.com
 * @group             : 
 * @last modified on  : 02-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class LocationWeatherDisplay {
    @AuraEnabled(cacheable=true)
    public static List<WeatherInfo__c> getLocationWeatherInfo(Id locationId) {
        return [SELECT Id,
                Icon__c,
                Name,
                Feels_Like__c,
                Maximum_Temperature__c,
                Minimum_Temperature__c,
                Temperature__c,
                Location__r.Name,
                Description__c
                FROM WeatherInfo__c
                WHERE Location__c = :locationId
                ORDER BY CreatedDate DESC
                LIMIT 1
               ];
        
    }
}
