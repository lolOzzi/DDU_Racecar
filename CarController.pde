class CarController {

  float variance = 2;
  float carRot;
  float fitness = 0;
  float turnAngle = 0;
  Car car = new Car();
  CarSensors carSensors = new CarSensors();
  NeuralNetwork neuralNetwork = new NeuralNetwork(variance);

  float fitness() {
    if (carSensors.lapTimeInFrames != -1 && carSensors.lapCount != -1 ) {
      return fitness = ((300 / carSensors.lapTimeInFrames) + carSensors.lapCount*5 + carSensors.checkPointCount)  * (1 - carSensors.offroad);
    } else {
      return 0;
    }
  }

  CarController breed(CarController partner, float mutationRate) {
    CarController child = new CarController();
    for (int i = 0; i < child.neuralNetwork.weights.length; i++) {
      int rand = int(random(0, 2));
      if (rand == 1) {
        child.neuralNetwork.weights[i] = partner.neuralNetwork.weights[i];
      } else {
        child.neuralNetwork.weights[i] = neuralNetwork.weights[i];
      }
      if (random(1) < mutationRate) {
        child.neuralNetwork.weights[i] += random(-0.1, 0.1);
      }
    }
    for (int i = 0; i < child.neuralNetwork.bias.length; i++) {
      int rand = int(random(0, 2));
      if (rand == 1) {
        child.neuralNetwork.bias[i] = partner.neuralNetwork.bias[i];
      } else {
        child.neuralNetwork.bias[i] = neuralNetwork.bias[i];
      }
      if (random(1) < mutationRate) {
        child.neuralNetwork.bias[i] += random(-0.1, 0.1);
      }
    }
    return child;
  }

  void update() {

    car.update();
    float[] x = new float[6];
    for (int i = 0; i < carSensors.signals.length; i++) {
      x[i] = int(carSensors.signals[i]);
    }
    turnAngle = neuralNetwork.getOutput(x);
    car.turnCar(turnAngle);

    carSensors.update(car.pos);
  }

  void display() {

    car.display();
    carSensors.display(turnAngle);
  }

  CarController() {
  }
}
