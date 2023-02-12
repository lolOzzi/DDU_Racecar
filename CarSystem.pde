class CarSystem {
  //CarSystem -
  //Her kan man lave en generisk alogoritme, der skaber en optimal "hjerne" til de forhåndenværende betingelser

  ArrayList<CarController> CarControllerList  = new ArrayList<CarController>();
  int counter = 0;

  float mutationRate = 0.1;
  ArrayList<Integer> bestLapCounts = new ArrayList<>();
  ArrayList<Integer> bestLapTimes = new ArrayList<>();
  ArrayList<Float> avgLapCounts = new ArrayList<>();
  ArrayList<Integer> lapCounts = new ArrayList<>();
  ArrayList<Integer> lapTimes = new ArrayList<>();
  int totalLapCounts = 0;

  CarSystem(int populationSize) {
    for (int i=0; i<populationSize; i++) {
      CarController controller = new CarController();
      CarControllerList.add(controller);
    }
  }

  void updateAndDisplay() {
    fill(0);
    counter++;
    if (counter >= 1800) {
      counter = 0;
      totalLapCounts = 0;
      for (int i = 0; i < CarControllerList.size(); i++) {
        CarControllerList.get(i).fitness();
        totalLapCounts += CarControllerList.get(i).carSensors.lapCount;
        lapCounts.add(CarControllerList.get(i).carSensors.lapCount);
        lapTimes.add(CarControllerList.get(i).carSensors.fastestLapTime);
      }
      //Avg. Lap count
      avgLapCounts.add(round(((float) totalLapCounts / (float) populationSize )*100) / 100.0);
      
      //Get best lap count
      int bestLap = 0;
      for (int i = 0; i < lapCounts.size(); i++) {
        if (lapCounts.get(i) > bestLap) {
          bestLap = lapCounts.get(i);
        }
      }
      bestLapCounts.add(bestLap);
      
      //Get best lap time
      int bestLapTime = lapTimes.get(0);
      for (int i = 0; i < lapTimes.size(); i++) {
        if (bestLapTime == -1 || (lapTimes.get(i) < bestLapTime && lapTimes.get(i) != -1)) {
          bestLapTime = lapTimes.get(i);
        }
      }
      bestLapTimes.add(bestLapTime);



      ArrayList<CarController> matingPool = new ArrayList<CarController>();

      for (int i = 0; i < CarControllerList.size(); i++) {
        int n = int(CarControllerList.get(i).fitness);
        for (int j = 0; j < n; j++) {
          matingPool.add(CarControllerList.get(i));
        }
      }
      for (int i = 0; i < CarControllerList.size(); i++) {

        int a = int(random(matingPool.size()));

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
    for (int i = 0; i < bestLapCounts.size(); i++) {
      fill(0);
      String info = "Gen: " + (i+1) + ", Best Lap Count: " + bestLapCounts.get(i) +  ", Avg. Lap Count: " + avgLapCounts.get(i) + ", Best lap time: " +  round(((float) bestLapTimes.get(i) / 60.0 )*100.0) / 100.0 + " sec.";
      text(info, width-375, 50+i*10);
    }
  }
}
