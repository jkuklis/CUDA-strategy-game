#include <iostream>
#include "checkers.cuh"
#include "initial.cuh"

int main() {
  int *A = initial_state();
  my_rep_class *my_rep;
  int *n_moves;
  int4 *moves;

  cudaMalloc(&my_rep, sizeof(my_rep_class));
  cudaMalloc(&n_moves, sizeof(int));
  cudaMalloc(&moves, 1024*2048*4*sizeof(int4));
  my_representation<<<my_representation_blocks,
    my_representation_threads>>>(A, my_rep);
  for (int i = 0; i < 100; i++){
    cudaMemset(n_moves, 0, sizeof(int));
    possible_moves<<<possible_moves_blocks,
      possible_moves_threads>>>(my_rep, 1, n_moves, moves);
    update<<<update_blocks, update_threads>>>(my_rep,
      selected_move(n_moves, moves));
    cudaMemset(n_moves, 0, sizeof(int));
    possible_moves<<<possible_moves_blocks,
      possible_moves_threads>>>(my_rep, 2, n_moves, moves);
    update<<<update_blocks, update_threads>>>(my_rep,
      selected_move(n_moves, moves));
  }

  cudaFree(n_moves);
  cudaFree(moves);
  cudaFree(my_rep);
  cudaFree(A);
  // free(A);
  // delete[] A;
  return 0;
}
