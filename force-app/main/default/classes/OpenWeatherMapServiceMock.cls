@isTest
public class OpenWeatherMapServiceMock  implements HttpCalloutMock {
   public HTTPResponse respond(HTTPRequest req) {
        // Create a mock HTTP response
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"coord":{"lon":-122.4194,"lat":37.7749},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"base":"stations","main":{"temp":301.39,"feels_like":304.58,"temp_min":301.39,"temp_max":301.39,"pressure":1014,"humidity":72,"sea_level":1014,"grnd_level":1014},"visibility":10000,"wind":{"speed":2.62,"deg":22,"gust":2.61},"clouds":{"all":100},"dt":1706803246,"sys":{"sunrise":1706755424,"sunset":1706799061},"timezone":10800,"id":0,"name":"","cod":200}');

        return res;
    }
}