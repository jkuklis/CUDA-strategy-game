#include <iostream>
#include "checkers.cuh"
#include "initial.cuh"

int main() {
  int *A = initial_state();
  my_rep_class *my_rep;
  int *n_moves;
  int4 *moves;

  // for (int i = 0; i < 20; ++i) {
  //   std::cout << i << ": " << A[i] << "\n";
  // }

  cudaMalloc(&my_rep, sizeof(my_rep_class));
  cudaMalloc(&n_moves, sizeof(int));
  cudaMalloc(&moves, 1024*2048*4*sizeof(int4));
  my_representation<<<my_representation_blocks,
    my_representation_threads>>>(A, my_rep);


  cudaFree(n_moves);
  cudaFree(moves);
  cudaFree(my_rep);
  cudaFree(A);
  // free(A);
  // delete[] A;
  return 0;
}
