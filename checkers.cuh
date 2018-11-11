#include <iostream>

class my_rep_class {
public:
  static const int board = 8;
  static const int side = 8 + 2;
  static const int size = side * side;
  int A[size];

  int player;
};

void __global__ my_representation(int *A, my_rep_class *my_rep) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;

  for (int i = index; i < my_rep->size; i += stride) {
    my_rep->A[i] = A[i] + 1;
  }
}

void __global__ possible_moves(my_rep_class *my_rep, int player, int *n_moves, int4 *moves) {
  my_repr->player = player;

  int nn_moves = 0;
  int4 new_moves[4 * (my_rep->size + stride - 1) / stride];

  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  int side = my_rep->side;

  for (int i = index; i < my_rep->size - 1; i += stride) {

    int x = i % side;
    int y = i / side;

    int pos = index + side + y;

    if (my_rep->branch[pos] == player + 1) {
      if (my_rep->branch[i - side - 1] == 1) {
        new_moves[nn_moves] = {x, y, x-1, y-1};
        nn_moves++;
      }
      if (my_rep->branch[i - side + 1] == 1) {
        new_moves[nn_moves] = {x, y, x+1, y-1};
        nn_moves++;
      }
      if (my_rep->branch[i + side - 1] == 1) {
        new_moves[nn_moves] = {x, y, x-1, y+1};
        nn_moves++;
      }
      if (my_rep->branch[i + side + 1] == 1) {
        new_moves[nn_moves] = {x, y, x+1, y-1};
        nn_moves++;
      }
    }
  }

}

void __global__ update(my_rep_class *my_rep, int4 move) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;

  int side = my_rep->side;

  for (int i = index; i < my_rep->size - 1; i += stride) {
    int x = i % side;
    int y = i / side;

    int pos = index + side + y;

    if (x == move.x && y == move.y) {
      my_rep->branch[pos] = 1;
    }

    if (x == move.z && y == move.w) {
      my_rep->branch[pos] = my_rep->player;
    }
  }
}

int my_representation_threads = 256;
int my_representation_blocks = my_rep->size / my_representation_threads;
int possible_moves_threads = 256;
int possible_moves_blocks = my_rep->size / possible_moves_threads;
int update_threads = 256;
int update_blocks = my_rep->size / update_threads;
