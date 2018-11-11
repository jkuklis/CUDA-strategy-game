#include <iostream>

class my_rep_class {
public:
  __device__ my_rep_class() {}

  __device__ my_rep_class(int *A) {
    int rows = 2048;
    int columns = 2048;
    _A[3] = A[3];
    // cudaMalloc(&_A, sizeof(int) * rows * columns);
    // for (int i = 0; i < rows; i += 1) {
      // for (int j = (i + 1) % 2; j < columns; j += 2) {
        // _A[i][j] = A[i * columns + j];
        // _A[i][j] = 3;
        // cudaMemcpy(A, _A, sizeof(int) * rows * columns, cudaMemcpyDeviceToHost);
      // }
    // }
  }
// private:
  int *_A;
};

void __global__ my_representation(int *A, my_rep_class *my_rep) {
  printf("Hello from block %d, thread %d\n", blockIdx.x, threadIdx.x);

  for (int i = 0; i < 10; ++i) {
    printf("%d: %d\n", i, A[i]);
  }

  printf("Hello from block %d, thread %d\n", blockIdx.x, threadIdx.x);

  // my_rep_class rep(A);
  // *my_rep = rep;
  int _A[100];
  _A[3] = A[3];

  my_rep->_A[3] = A[3];
}
// void __global__ possible_moves(my_rep_class *my_rep, int player, int *n_moves, int4 *moves);
// void __global__ update(my_rep_class *my_rep, int4 move);

int my_representation_blocks = 1;
int my_representation_threads = 1;
int possible_moves_blocks = 1;
int possible_moves_threads = 1;
int update_blocks = 1;
int update_threads = 1;
