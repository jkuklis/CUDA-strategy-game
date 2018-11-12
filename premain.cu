#include <iostream>
#include "checkers.cuh"
#include "initial.cuh"

int main() {
  cudaFree(0);

  int *A = initial_state();
  my_rep_class *my_rep;
  int *n_moves;
  int4 *moves;

  cudaMalloc(&my_rep, sizeof(my_rep_class));
  cudaMalloc(&n_moves, sizeof(int));
  cudaMalloc(&moves, 1024*2048*4*sizeof(int4));
  // cudaMalloc(&moves, 4*8*4*sizeof(int4));
  // my_representation<<<my_representation_blocks,
  //   my_representation_threads>>>(A, my_rep);

  // std::cout << "\n";
  // for (int i = 0; i < 10; i++) {
  //   for (int j = 0; j < 10; j++) {
  //     int a;
  //     cudaMemcpy(&a, &(my_rep->A[i * 10 + j]), sizeof(int), cudaMemcpyDeviceToHost);
  //     if (a != 1) {
  //       std::cout << a << " ";
  //     } else {
  //       std::cout << "  ";
  //     }
  //   }
  //   std::cout << "\n";
  // }
  //
  // int turns = 1;
  //
  // for (int i = 0; i < turns; i++){
  //   cudaMemset(n_moves, 0, sizeof(int));
  //   possible_moves<<<possible_moves_blocks,
  //     possible_moves_threads>>>(my_rep, 1, n_moves, moves);
  //   update<<<update_blocks, update_threads>>>(my_rep,
  //     selected_move(n_moves, moves));
  //
  //   // std::cout << "\n";
  //   // int nm;
  //   // cudaMemcpy(&nm, n_moves, sizeof(int), cudaMemcpyDeviceToHost);
  //   // for (int i = 0; i < nm; i++) {
  //   //   int4 a;
  //   //   cudaMemcpy(&a, &moves[i], sizeof(int4), cudaMemcpyDeviceToHost);
  //   //   std::cout << a.x << " " << a.y << " " << a.z << " " << a.w << "\n";
  //   // }
  //   // std::cout << "\n";
  //   // for (int i = 0; i < 10; i++) {
  //   //   for (int j = 0; j < 10; j++) {
  //   //     int a;
  //   //     cudaMemcpy(&a, &(my_rep->A[i * 10 + j]), sizeof(int), cudaMemcpyDeviceToHost);
  //   //     if (a != 1) {
  //   //       std::cout << a << " ";
  //   //     } else {
  //   //       std::cout << "  ";
  //   //     }
  //   //   }
  //   //   std::cout << "\n";
  //   // }
  //
  //   cudaMemset(n_moves, 0, sizeof(int));
  //   possible_moves<<<possible_moves_blocks,
  //     possible_moves_threads>>>(my_rep, 2, n_moves, moves);
  //   update<<<update_blocks, update_threads>>>(my_rep,
  //     selected_move(n_moves, moves));
  //
  //   // cudaDeviceSynchronize();
  //
  //   // std::cout << "\n";
  //   // cudaMemcpy(&nm, n_moves, sizeof(int), cudaMemcpyDeviceToHost);
  //   // for (int i = 0; i < nm; i++) {
  //   //   int4 a;
  //   //   cudaMemcpy(&a, &moves[i], sizeof(int4), cudaMemcpyDeviceToHost);
  //   //   std::cout << a.x << " " << a.y << " " << a.z << " " << a.w << "\n";
  //   // }
  //   // std::cout << "\n";
  //   // for (int i = 0; i < 10; i++) {
  //   //   for (int j = 0; j < 10; j++) {
  //   //     int a;
  //   //     cudaMemcpy(&a, &(my_rep->A[i * 10 + j]), sizeof(int), cudaMemcpyDeviceToHost);
  //   //     if (a != 1) {
  //   //       std::cout << a << " ";
  //   //     } else {
  //   //       std::cout << "  ";
  //   //     }
  //   //   }
  //   //   std::cout << "\n";
  //   // }
  // }

  // int side = 2 + 248;
  //
  // std::cout << "\n";
  // for (int i = 0; i < side; i++) {
  //   for (int j = 0; j < side; j++) {
  //     int a;
  //     cudaMemcpy(&a, &(my_rep->A[i * side + j]), sizeof(int), cudaMemcpyDeviceToHost);
  //     if (a != 1) {
  //       std::cout << a << " ";
  //     } else {
  //       std::cout << "  ";
  //     }
  //   }
  //   std::cout << "\n";
  // }

  cudaFree(n_moves);
  cudaFree(moves);
  cudaFree(my_rep);
  cudaFree(A);
  // free(A);
  // delete[] A;
  return 0;
}
