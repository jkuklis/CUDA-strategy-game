#include <iostream>
#include <random>

std::random_device rd;     // only used once to initialise (seed) engine
std::mt19937 rng(rd());    // random-number engine used (Mersenne-Twister in this case)

int *initial_state() {
  int side = 548;
  int size = side * side;
  // int *A = new int [size * sizeof *A];
  // int *A = (int *)malloc(sizeof *A * size);
  int *A;
  cudaMalloc(&A, size*sizeof(int));
  // white squares, must be 0
  int zero = 0;
  int one = 1;
  int two = 2;
  int blackCount = 8;
  // for (int i = 0; i < size; i += 2) {
  //   cudaMemcpy(&A[i], &zero, sizeof(int), cudaMemcpyHostToDevice);
  // }
  // // black squares, can have values 0, 1, 2
  // for (int i = 1; i < size; i += 2) {
  //   cudaMemcpy(&A[i], &zero, sizeof(int), cudaMemcpyHostToDevice);
  // }
  // for (int i = 1; i < blackCount * 8; i += 2) {
  //   cudaMemcpy(&A[i], &one, sizeof(int), cudaMemcpyHostToDevice);
  // }
  // for (int i = 2048; i < 2048 + blackCount * 3; i += 2) {
  //   cudaMemcpy(&A[i], &two, sizeof(int), cudaMemcpyHostToDevice);
  // }

  // cudaMemcpy(&A[side], &one, sizeof(int), cudaMemcpyHostToDevice);

  return A;
}

int4 selected_move(int *number_of_moves, int4 *moves) {
  // int nm;
  // cudaMemcpy(&nm, number_of_moves, sizeof(int), cudaMemcpyDeviceToHost);
  // if (nm > 0) {
  //   int4 a;
  //   std::uniform_int_distribution<int> uni(0,nm - 1); // guaranteed unbiased
  //
  //   cudaMemcpy(&a, &moves[uni(rng)], sizeof(int4), cudaMemcpyDeviceToHost);
  //   return a;
  // } else {
    return {0,1,1,0};
  // }
}
