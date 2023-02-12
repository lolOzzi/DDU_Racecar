import java.util.ArrayList;
import java.lang.Math;


PImage trackImage;
int populationSize = 100;
CarSystem carSystem       = new CarSystem(populationSize);

void setup() {
  size(1300, 635);
  trackImage = loadImage("track.png");
}

void draw() {
  clear();
  background(255);
  fill(255);
  image(trackImage, 0, 0);
  carSystem.updateAndDisplay();
  
}
