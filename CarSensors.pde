class CarSensors {
  PVector distance;
  PVector pos;
  PVector vel = new PVector(10, 10);
  PVector size = new PVector(10, 10);
  PVector[] sensors;
  boolean[] signals;
  int angle = 45;
  int length = 25;
  float second = 2.5;

  //crash detection
  int whiteSensorFrameCount    = 0; //udenfor banen
  boolean currentBlueDetection = false;
  boolean currentRedDetection = false;

  //lap calculations
  boolean lastGreenDetection;
  int     lastTimeInFrames      = 0;
  int     lapTimeInFrames       = -1;
  int fastestLapTime = -1;
  int lapCount = 0;
  int checkPointCount = 0;
  int offroad = 0;


  CarSensors() {
    sensors = MakeSix();
    signals = new boolean[6];
  }

  PVector[] MakeSix() {
    PVector[] tempSensors = new PVector[6];
    //Front Sensors
    tempSensors[0] = new PVector(100, 0);
    tempSensors[1] = new PVector(120, 0);
    //Left Sensors
    tempSensors[2] = new PVector(80, 20);
    tempSensors[3] = new PVector(100, 20);
    //Right Sensors
    tempSensors[4] = new PVector(80, 40);
    tempSensors[5] = new PVector(100, 40);

    return tempSensors;
  }

  void display() {
    fill(0);
    
    pushMatrix();
    translate(pos.x, pos.y);
    for (PVector sensor : sensors) {
      ellipse(sensor.x, sensor.y, 10, 10);
    }
    popMatrix();

    strokeWeight(2);
    if (whiteSensorFrameCount>0) {
      fill(whiteSensorFrameCount*10, 0, 0);
      offroad = 1;
    } else {
      //fill(0, clockWiseRotationFrameCounter, 0);
      fill(0, 255, 0);
    }
    ellipse(pos.x, pos.y, 10, 10);
  }

  void update(PVector pos, PVector vel) {
    this.vel = vel;
    //Laptime calculation
    boolean currentGreenDetection =false;
    color color_car_position = get(int(pos.x), int(pos.y));
    if (color_car_position ==-1) {
      whiteSensorFrameCount = whiteSensorFrameCount+1;
    }

    if (red(color_car_position)==0 && blue(color_car_position)==0 && green(color_car_position)!=0 && currentBlueDetection && currentRedDetection) {//den grønne målstreg er detekteret
      currentGreenDetection = true;
      currentBlueDetection = false;
      currentRedDetection = false;
    }
    if (red(color_car_position)==0 && blue(color_car_position)!=0 && green(color_car_position)==0 && !currentRedDetection && !currentBlueDetection) {//den grønne målstreg er detekteret
      currentBlueDetection = true;
      checkPointCount++;
    }
    if (red(color_car_position)!=0 && blue(color_car_position)==0 && green(color_car_position)==0 && currentBlueDetection && !currentRedDetection) {//den grønne målstreg er detekteret
      currentRedDetection = true;
      checkPointCount++;
    }
    if (lastGreenDetection && !currentGreenDetection) {  //sidst grønt - nu ikke -vi har passeret målstregen
      lapTimeInFrames = frameCount - lastTimeInFrames; //LAPTIME BEREGNES - frames nu - frames sidst
      lastTimeInFrames = frameCount;
      if (fastestLapTime == -1 || lapTimeInFrames < fastestLapTime){
        fastestLapTime = lapTimeInFrames;
      }
      lapCount++;
    }
    lastGreenDetection = currentGreenDetection; //Husker om der var grønt sidst
    //count clockWiseRotationFrameCounter

    this.pos = pos;
    updateSensorVectors(vel);
    overGround();
  }
  void updateSensorVectors(PVector vel) {
    if (vel.mag()!=0) {
      sensors[0].set(vel);
      sensors[0].normalize();
      sensors[0].mult(length);
      sensors[1].set(vel);
      sensors[1].normalize();
      sensors[1].mult(length*second);
    }
    sensors[2].set(sensors[0]);
    sensors[2].rotate(angle);
    
    sensors[3].set(sensors[1]);
    sensors[3].rotate(angle);
    
    sensors[4].set(sensors[0]);
    sensors[4].rotate(-angle);
    
    sensors[5].set(sensors[1]);
    sensors[5].rotate(-angle);
  }
  void overGround() {
    for (int i = 0; i < sensors.length; i++) {
      signals[i] = get( (int) (pos.x + sensors[i].x), (int)(pos.y + sensors[i].y)) == -1;
    }
  }
}
