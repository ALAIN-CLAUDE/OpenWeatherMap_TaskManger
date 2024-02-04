// LocationWeatherDisplay.js
import { LightningElement, api, wire } from 'lwc';
import getLocationWeatherInfo from '@salesforce/apex/LocationWeatherDisplay.getLocationWeatherInfo';

export default class LocationWeatherDisplay extends LightningElement {
    @api recordId;
    weatherInfoData = [];
    error;

    @wire(getLocationWeatherInfo, { locationId: '$recordId' })
    wiredLocation({ error, data }) {
        if (data) {
            this.weatherInfoData = data.map(weatherInfo => ({
              
                id: weatherInfo.Id,
                iconUrl: weatherInfo.Icon__c
                    ? `https://openweathermap.org/img/wn/${weatherInfo.Icon__c}.png`
                    : 'slds-spinner',
                temperatureCelsius: weatherInfo.temperature__c
                    ? weatherInfo.temperature__c 
                    : '',
                Description: weatherInfo.description__c  ? weatherInfo.description__c : '',
                Minimum_Temperature: weatherInfo.Minimum_Temperature__c  ? weatherInfo.Minimum_Temperature__c : '',
                Maximum_Temperature: weatherInfo.Maximum_Temperature__c ? weatherInfo.Maximum_Temperature__c : '',
                Feels_Like: weatherInfo.Feels_Like__c ? weatherInfo.Feels_Like__c : '',
                LocationName : weatherInfo.Name,
                // Add other properties as needed
            }));
            console.log('this.data===> '+JSON.stringify(data));
            console.log('this.locationData===> '+JSON.stringify(this.weatherInfoData));
            console.log('this.locationData length===> '+this.weatherInfoData.length);
        } else if (error) {
            this.error = error;
            console.error('Error loading location weather:', error);
        }
    }

    get hasData() {
        return this.weatherInfoData && this.weatherInfoData.length > 0;
    }

    get LocationName(){
        return this.weatherInfoData[0].LocationName;
    }
}