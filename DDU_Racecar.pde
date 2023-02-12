import java.util.ArrayList;
import java.lang.Math;


PImage trackImage;
float mutationRate = 0.01;
int populationSize = 30;
CarSystem carSystem       = new CarSystem(populationSize);

void setup() {
  size(1084, 635);
  trackImage = loadImage("track.png");
}

void draw() {
  clear();
  background(255);
  fill(255);
  image(trackImage, 0, 0);
  carSystem.updateAndDisplay();
  
}
