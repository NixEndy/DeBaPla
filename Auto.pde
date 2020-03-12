
import android.os.Bundle;
import android.content.Intent;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import ketai.camera.*;

import ketai.sensors.*;

import cassette.audiofiles.SoundFile;

KetaiSensor sensor;
PVector accelerometer;
float light, proximity = Float.POSITIVE_INFINITY;
KetaiLocation location;
double longitude, latitude, altitude;

KetaiList connectionList;
String info = "";
boolean isConfiguring = true;
String UIText;

ArrayList<String> devices = new ArrayList<String>();
boolean isWatching = false;
color c= color(180,0,125);
String[] alerta = {"", "", ""};
int currentEvent = -1;

SoundFile honk;
KetaiCamera cam;
PImage intruderPhoto = null;

void setup() {
  orientation(PORTRAIT);
  stroke(255);
    
  sensor = new KetaiSensor(this);
  sensor.start();
  sensor.list();
  accelerometer = new PVector();
  location = new KetaiLocation(this);

  textFont(createFont("FontsFree-Net-Proxima-Nova-Bold.otf", 64));
  honk = new SoundFile(this, "honk.mp3");
  cam = new KetaiCamera(this, 480, 480, 60);
  cam.start();
  if (cam.getNumberOfCameras() > 1)
    cam.setCameraID(1);
}

void draw() {
  background(c);
  int tSize = 128;
  textAlign(CENTER);
  textSize(tSize);
  while(textWidth(alerta[0]) > width*0.8
    || textWidth(alerta[1]) > width*0.8
    || textWidth(alerta[2]) > width*0.8){
    tSize--;
    textSize(tSize);
  }
  push();
  if(intruderPhoto != null) {
    translate(width/2, height/4 + tSize/2);
  }
  else {
    translate(width/2, (height+tSize)/2);
  }
  fill(38, 174, 232);
  text(alerta[0], 0, -tSize*2/3 - 4);
  fill(35, 67, 150);
  text(alerta[1], 0, 0);
  fill(34, 34, 34);
  text(alerta[2], 0, tSize*2/3 + 4);
  pop();

  if(intruderPhoto != null){
    push();
    imageMode(CENTER);
    translate(width/2, height*5/8 + 80);
    textSize(64);
    text("FOTO DEL INTRUSO", 0, -intruderPhoto.height/2 - 120);
    rotate(-PI/2); 
    image(intruderPhoto, 0, 0);
    pop();
  }
}

void onCameraPreviewEvent() {
  cam.read();
}
