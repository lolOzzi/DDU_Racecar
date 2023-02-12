class Car {
  PVector pos;
  PVector vel;
  PVector size;
  boolean amOut;
  float turnAngle;

  Car() {
    pos = new PVector(110, 240);
    vel = new PVector(0, 5);
    size = new PVector(10, 10);
  }

  void update() {
    pos.add(vel);
    overGround();
  }

  void turnCar(float turnAngle) {
    
    this.turnAngle = turnAngle;
    vel.rotate(turnAngle);
  }


  void display() {
    fill(0);
    pushMatrix();
    translate(pos.x - (size.x/2), pos.y - (size.y/2));
    rotate(turnAngle);
    rect(0, 0, size.x, size.y);
    popMatrix();
  }

  void overGround() {
    color color_car_pos = get(int(pos.x), int(pos.y));
    if (color_car_pos == -1) {
      print("I Am Over");
    } else print("I Am Not Over");
  }
}
