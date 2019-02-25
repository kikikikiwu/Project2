/*
API from OpenWeatherMap
For Advnaced Digital Design Project 2
by Kiki Wu and Chaoyue Huang
*/

void setup() {
  size(200,200);

  // The URL for the JSON data
  String url = "http://api.openweathermap.org/data/2.5/weather?";
  String query = "zip=11201,us"; //brooklyn
  String unit = "&units=metric"; //replace "imperial" with "metric" for celsius
  String apikey = "d4e9eb06fd3c7aafacc579014a52d197";

  // Load the json document
  JSONObject json = loadJSONObject(url+query+unit+"&APPID="+apikey);
  
  //get current brooklyn's weather
  float temp = json.getJSONObject("main").getFloat("temp");
  println(temp);
}
