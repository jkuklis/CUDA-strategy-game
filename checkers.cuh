#include <iostream>

class my_rep_class {
private:
  static const int side = 8;
  static const int stripes = side - 1;
  static const int per_stripe = side + 4;

  int branch[stripes][per_stripe];

public:
  void __device__ set(int *A) {
    for (int i = 0; i < stripes; ++i) {
      branch[i][0] = branch[i][per_stripe - 1] = 3;
    }

    for (int i = 1; i < side - 1; i += 2) {
      int br = i - 1;
      int len = side - i;
      int separator = len + 1;
      for (int j = 0; j < len; ++j) {
        int real_pos = (i + j) * side + j;
        branch[br][j + 1] = A[real_pos];
      }
      branch[br][separator] = 3;
      int len2 = i + 1;
      for (int j = 0; j < len2; ++j) {
        int real_pos = (side - 1 - j) * side + len + j;
        branch[br][separator + j + 1] = A[real_pos];
      }
    }

    for (int i = 1; i < side - 1; i += 2) {
      int br = i;
      int len = i + 1;
      int separator = len + 1;
      for (int j = 0; j < len; ++j) {
        int real_pos = (i - j) * side + j;
        branch[br][j + 1] = A[real_pos];
      }
      branch[br][separator] = 3;
      int len2 = side - i;
      for (int j = 0; j < len2; ++j){
        int real_pos = j * side + i + j;
        branch[br][separator + j + 1] = A[real_pos];
      }
    }

    for (int i = 0; i < per_stripe; i++) {
      branch[stripes - 1][i] = 3;
    }

    for (int i = 0; i < side; i++) {
      int real_pos = (side - 1 - i) *  side + i;
      branch[stripes - 1][i + 3] = A[real_pos];
    }

    for (int i = 0; i < stripes; ++i) {
      printf("%d: ", i);
      for (int j = 0; j < per_stripe; ++j) {
        printf("%d ", branch[i][j]);
      }
      printf("\n");
    }
  }
};

void __global__ my_representation(int *A, my_rep_class *my_rep) {
  printf("Hello from block %d, thread %d\n", blockIdx.x, threadIdx.x);

  for (int i = 0; i < 10; ++i) {
    printf("%d: %d\n", i, A[i]);
  }

  my_rep->set(A);
}

void __global__ possible_moves(my_rep_class *my_rep, int player, int *n_moves, int4 *moves) {
  int nn_moves = 0;
}


void __global__ update(my_rep_class *my_rep, int4 move) {

}

int my_representation_blocks = 1;
int my_representation_threads = 1;
int possible_moves_blocks = 1;
int possible_moves_threads = 1;
int update_blocks = 1;
int update_threads = 1;
