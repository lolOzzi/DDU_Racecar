class NeuralNetwork {
  float[] weights = new float[16];

  float[] bias = new float[3];

  NeuralNetwork(float variance) {
    for (int i=0; i < weights.length -1; i++) {
      weights[i] = random(-variance, variance);
    }
    for (int i=0; i < bias.length -1; i++) {
      bias[i] = random(-variance, variance);
    }
  }

  float getOutput(float[] x) {
    //Layer 1
    float o11 = weights[0] * x[0] + weights[1] * x[1] + weights[2] * x[2] + weights[3] * x[3] + weights[4] * x[4] + weights[5] * x[5] + bias[0];
    float o12 = weights[6] * x[0] + weights[7] * x[1] + weights[8] * x[2] + weights[9] * x[3] + weights[10] * x[4] + weights[11] * x[5] + bias[1];

    //Layer 2
    return o11 * weights[12] + o12 * weights[13] + bias[2];
  }
}
