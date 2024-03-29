/**
 * @description       :This class is used as a wrapper builder , making it easy to get my data from callout
 * @author            : alainclaudebe@outlook.com
 * @group             : 
 * @last modified on  : 02-05-2024
**/

public class OpenWeatherMapApiResponse {
    public Coord coord;
    public List<Weather> weather;
    public String base;
    public Main main;
    public Integer visibility;
    public Wind wind;
    public Clouds clouds;
    public Integer dt;
    public Sys sys;
    public Integer timezone;
    public Integer id;
    public String name;
    public Integer cod;

    public class Coord {
        public Double lon;
        public Double lat;
    }

    public class Weather {
        public Integer id;
        public String main;
        public String description;
        public String icon;
    }

    public class Main {
        public Double temp;
        public Double feels_like;
        public Double temp_min;
        public Double temp_max;
        public Integer pressure;
        public Integer humidity;
        public Integer sea_level;
        public Integer grnd_level;
    }

    public class Wind {
        public Double speed;
        public Integer deg;
        public Double gust;
    }

    public class Clouds {
        public Integer all;
    }

    public class Sys {
        public Integer sunrise;
        public Integer sunset;
    }
}
