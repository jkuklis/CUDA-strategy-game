#include <iostream>

int *initial_state() {
  int side = 8;
  int size = side * side;
  // int *A = new int [size * sizeof *A];
  // int *A = (int *)malloc(sizeof *A * size);
  int *A;
  cudaMalloc(&A, size*sizeof(int));
  // white squares, must be 0
  int zero = 0;
  int one = 1;
  int two = 2;
  int blackCount = 4;
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

  cudaMemcpy(&A[side], &one, sizeof(int), cudaMemcpyHostToDevice);

  return A;
}

int4 selected_move(int *number_of_moves, int4 *moves) {
  if (*numer_of_moves > 0) {
    return moves[0];
  } else {
    return {0,1,1,0};
  }
}
