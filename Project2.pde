/*
API from OpenWeatherMap
For Advnaced Digital Design Project 2
by Kiki Wu and Chaoyue Huang
*/

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

JSONObject weather;
float temp, w_deg, w_s, h, cloud, p; //temperature, wind degree, wind speed, humidity, cloudiness, air pressure

Minim minim;
AudioOutput out;
float dB;

float [] notes = new float [5]; //five notes's index
float [] startPoint = new float [16]; //16 different start points
float [] dur = new float [16]; //16 different duration for each notePlay

boolean windChimeIsPlayed = false;

void setup() {
  // The URL for the JSON data
  String url = "http://api.openweathermap.org/data/2.5/weather?";
  String query = "zip=11201,us"; //brooklyn
  String unit = "&units=metric"; //replace "imperial" with "metric" for celsius
  String apikey = "d4e9eb06fd3c7aafacc579014a52d197";

  // Load the json document
  weather = loadJSONObject(url+query+unit+"&APPID="+apikey);
  
  //wind chime effect
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut(); 
    
  //initialize the notes array
  for(int i = 0; i < notes.length; i++){
      
      //create an array of note names
      String [] noteNames = {"C4", "D4", "E4", "G4", "A4"};
      
      //assign note names to notes: [0] -> C4, [1] -> D4 ...
      notes[i] = Frequency.ofPitch( noteNames[i] ).asHz();
  }  
}  

void draw(){
  //get current brooklyn's weather data
  temp = round(weather.getJSONObject("main").getFloat("temp"));
  w_deg = weather.getJSONObject("wind").getFloat("deg");
  w_s = weather.getJSONObject("wind").getFloat("speed");
  h = weather.getJSONObject("main").getFloat("humidity");
  cloud = weather.getJSONObject("clouds").getFloat("all");
  p = weather.getJSONObject("main").getFloat("pressure");
  
  //print data in console
  println(temp, w_deg, w_s, h, cloud, p);
  
  //all the parameter in Flanger effect
  println(cloud*0.01, 0.2, 1, abs(p-1013.25)*0.01, 1-h*0.01, h*0.01);
  
  if(windChimeIsPlayed == false){
    windChime();
    windChimeIsPlayed = true;
  }
  
  //press key to replay windchime
  if(keyCode == ENTER){
    windChimeIsPlayed = false;
  }
}

void windChime(){
  //flip the boolean flag to let it play once
 // windChimeIsPlayed = true;
  
  //play 8 notes at various time points
  for(int i = 0; i < startPoint.length; i++){
    int r = (int)random(5);

    //play all the note within 16 beats
    //>=33m/s is considered as hurricane & music won't help at this point
    //the faster the wind speed is the earlier the notes are played out
    startPoint[i] = random(map(w_s, 0, 33, 16, 0));  
 
    //finish all the notes within 4 beats based on wind speed
    dur[i] = random(0.1, map(w_s, 0, 33, 4, 0.5));
    
    //generate random combinations of 8 notes at various length
    out.playNote( startPoint[i], dur[i], new SineInstrument( notes[r] ));
  }
  
}
