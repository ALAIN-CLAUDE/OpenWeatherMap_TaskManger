public class OpenWeatherMapService {

    public class LocationData {
        public Double lat;
        public Double lon;
        public Id locationId;
        
        public LocationData(Double lat, Double lon, Id locationId) {
            this.lat = lat;
            this.lon = lon;
            this.locationId = locationId;
        }
    }

    @future(callout = true)
    public static void getWeatherInfo(String locationDataListString) {
        try {
            List<LocationData> locationDataList = (List<LocationData>) JSON.deserialize(locationDataListString, List<LocationData>.class);
            getWeatherInfoHelper(locationDataList);
        } catch (Exception ex) {
            System.debug('An exception occurred: ' + ex.getMessage());
        }
    }

    public static void getWeatherInfoHelper(List<LocationData> locationDataList) {
        try {
            String apiKey = getApiKey();

            if (apiKey != null) {
                List<WeatherInfo__c> weatherInfoList = new List<WeatherInfo__c>();

                for (LocationData locationData : locationDataList) {
                    String endpoint = 'callout:openweathermap/data/2.5/weather?lat=' + locationData.lat + '&lon=' + locationData.lon + apiKey;
                    HttpRequest request = buildHttpRequest(endpoint);
                    HttpResponse response = makeHttpRequest(request);

                    if (response.getStatusCode() == 200) {
                        OpenWeatherMapApiResponse weatherData = (OpenWeatherMapApiResponse) JSON.deserialize(response.getBody(), OpenWeatherMapApiResponse.class);
                        System.debug('weatherData: ' + JSON.serializePretty(weatherData));
                        weatherInfoList.add(createWeatherInfoRec(weatherData, locationData.locationId));
                    } else {
                        System.debug('HTTP Request failed with status code: ' + response.getStatusCode());
                        System.debug('Response body: ' + response.getBody());
                    }
                }

                if (!weatherInfoList.isEmpty()) {
                    insert weatherInfoList;
                }
            }
        } catch (Exception ex) {
            System.debug('An exception occurred: ' + ex.getMessage());
        }
    }

    private static HttpRequest buildHttpRequest(String endpoint) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        return request;
    }

    private static HttpResponse makeHttpRequest(HttpRequest request) {
        return new Http().send(request);
    }

    public static String ConvertToCelsius(Double Kelvin) {
        String tempCelsius = String.valueOf(Kelvin - 273.15);
        if(String.isNotBlank(tempCelsius)){
            return tempCelsius;   
        }
        return ''; 
    }

    public static WeatherInfo__c createWeatherInfoRec(OpenWeatherMapApiResponse weatherData, Id locationId) {
        WeatherInfo__c weatherInfo = new WeatherInfo__c();
        
        if (locationId != null) {
            weatherInfo.Name = weatherData.name+' Weather';
            weatherInfo.Temperature__c = ConvertToCelsius(weatherData.main.temp);
            weatherInfo.Description__c = (weatherData.weather != null && weatherData.weather[0].description != null) ? weatherData.weather[0].description : '';
            weatherInfo.Location__c = locationId;
            weatherInfo.Minimum_Temperature__c = ConvertToCelsius(weatherData.main.temp_min);
            weatherInfo.Maximum_Temperature__c = ConvertToCelsius(weatherData.main.temp_max);
            weatherInfo.Feels_Like__c = ConvertToCelsius(weatherData.main.feels_like);
            weatherInfo.Icon__c = (weatherData.weather != null && weatherData.weather[0].icon != null) ? weatherData.weather[0].icon : '';
        }
        
        return weatherInfo;
    }

    private static String getApiKey() {
        openweathermapMeta__mdt metadata = openweathermapMeta__mdt.getInstance('Key');
        if (metadata != null) {
            return metadata.apiKey__c;
        } else {
            System.debug('Custom Metadata Type record not found for API key.');
            return null;
        }
    }
}