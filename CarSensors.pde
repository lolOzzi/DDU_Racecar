class CarSensors {
  PVector distance;
  PVector pos;
  PVector vel;
  PVector size = new PVector(10, 10);
  PVector[] sensors;
  boolean[] signals;
  int angle = 45;
  int length = 10;
  int second = 2;
  
  //crash detection
  int whiteSensorFrameCount    = 0; //udenfor banen
  boolean currentBlueDetection = false;
  boolean currentRedDetection = false;

  //lap calculations
  boolean lastGreenDetection;
  int     lastTimeInFrames      = 0;
  int     lapTimeInFrames       = -1;
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

  void display(float turnAngle) {
    fill(0);
    pushMatrix();
    translate(pos.x, pos.y);
    for (PVector sensor : sensors) {
      sensor.rotate(turnAngle);
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

  void update(PVector pos) {

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
      lapCount++;
    }
    lastGreenDetection = currentGreenDetection; //Husker om der var grønt sidst
    //count clockWiseRotationFrameCounter

    this.pos = pos;
    pushMatrix();
    translate(pos.x + (size.x / 2), pos.y + (size.y / 2));
    //Front Sensore
    sensors[0] = new PVector(length, 0);
    sensors[1] = new PVector((length * second), 0);

    //Venstre Sensore
    sensors[2] = new PVector(Math.abs((float)(Math.sin(angle - 90)) * length), -(float)(Math.abs(Math.sin(angle))) * length);
    sensors[3] = new PVector(Math.abs(((float)(Math.sin(angle - 90)) * length) * second), -((float)(Math.abs(Math.sin(angle))) * length * 2));

    //Højre Sensore
    sensors[4] = new PVector(((float)(Math.abs(Math.sin(angle - 90) * length))), (float)(Math.abs(Math.sin(angle))) * length);
    sensors[5] = new PVector(Math.abs(((float)(Math.sin(angle - 90)) * length) * second), ((float)(Math.abs(Math.sin(angle)) * length * 2)));
    popMatrix();
    overGround();
  }

  void overGround() {
    for (int i = 0; i < sensors.length; i++) {
      signals[i] = get((int)sensors[i].x, (int)sensors[i].y) == -1;
    }
  }
}
