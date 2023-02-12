class CarSystem {
  //CarSystem -
  //Her kan man lave en generisk alogoritme, der skaber en optimal "hjerne" til de forhåndenværende betingelser

  ArrayList<CarController> CarControllerList  = new ArrayList<CarController>();
  int counter = 0;
  
  float mutationRate = 0.2;
  ArrayList<Integer> bestLapCounts = new ArrayList<>();
  ArrayList<Integer> lapCounts = new ArrayList<>();
  int lapCounters = 0;
  
  CarSystem(int populationSize) {
    for (int i=0; i<populationSize; i++) {
      CarController controller = new CarController();
      CarControllerList.add(controller);
    }
  }

  void updateAndDisplay() {
    fill(0);
    text("pog", 10, 100);
    counter++;
    if (counter >= 1800) {
      counter = 0;
      for (int i = 0; i < CarControllerList.size(); i++) {
        CarControllerList.get(i).fitness();
        lapCounters += CarControllerList.get(i).carSensors.lapCount;
        lapCounts.add(CarControllerList.get(i).carSensors.lapCount);
      }

      int bestLap = 0;
      for (int i = 0; i < lapCounts.size(); i++) {
        if (lapCounts.get(i) > bestLap){
          bestLap = lapCounts.get(i);
        }
      }
      bestLapCounts.add(bestLap);

      ArrayList<CarController> matingPool = new ArrayList<CarController>();


      for (int i = 0; i < CarControllerList.size(); i++) {
        int n = int(CarControllerList.get(i).fitness);
        for (int j = 0; j < n; j++) {
          matingPool.add(CarControllerList.get(i));
        }
      }
      for (int i = 0; i < CarControllerList.size(); i++) {

        int a = int(random(matingPool.size()));

        ArrayList<CarController> poolB = new ArrayList<CarController>();
        for (int j = 0; j < matingPool.size(); j++) {
          if (matingPool.get(j) != matingPool.get(a)) {
            poolB.add(matingPool.get(j));
          }
        }
        int b = int(random(matingPool.size()));

        CarController parentA = matingPool.get(a);
        CarController parentB = matingPool.get(b);

        CarController child = parentA.breed(parentB, mutationRate);
        CarControllerList.set(i, child);
      }
    }


  //1.) Opdaterer sensorer og bilpositioner
  for (CarController controller : CarControllerList) {
    controller.update();
  }

  //2.) Tegner tilsidst - så sensorer kun ser banen og ikke andre biler!
  for (CarController controller : CarControllerList) {
    controller.display();
  }
  for (int i = 0; i < bestLapCounts.size(); i++){
    fill(0);
    text("Gen " + (i+1) + " Best Lap Count: " + bestLapCounts.get(i), width-200, 50+i*10);
  }
}
}
