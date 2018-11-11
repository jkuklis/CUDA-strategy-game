#include <iostream>

int *initial_state() {
  int size = 2048 * 2048;
  // int *A = new int [size * sizeof *A];
  // int *A = (int *)malloc(sizeof *A * size);
  int *A;
  cudaMalloc(&A, size*sizeof(int));
  // white squares, must be 0
  int zero = 0;
  int one = 1;
  int two = 2;
  int blackCount = 3;
  for (int i = 0; i < size; i += 2) {
    cudaMemcpy(&A[i], &zero, sizeof(int), cudaMemcpyHostToDevice);
  }
  // black squares, can have values 0, 1, 2
  for (int i = 1; i < size; i += 2) {
    cudaMemcpy(&A[i], &zero, sizeof(int), cudaMemcpyHostToDevice);
  }
  for (int i = 1; i < blackCount * 2; i += 2) {
    cudaMemcpy(&A[i], &one, sizeof(int), cudaMemcpyHostToDevice);
  }

  return A;
}

int4 selected_move(int *number_of_moves, int4 *moves) {
  return moves[0];
}