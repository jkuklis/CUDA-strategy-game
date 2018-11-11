#include <iostream>

class my_rep_class {
public:
  static const int b_side = 8;
  static const int side = 8 + 2;
  static const int b_size = b_side * b_side;
  static const int size = side * side;
  int A[size];

  int player;
};

const int my_representation_threads = 256;
const int my_representation_blocks = (my_rep_class::size + my_representation_threads - 1) / my_representation_threads;
const int possible_moves_threads = 256;
const int possible_moves_blocks = (my_rep_class::size + possible_moves_threads - 1) / possible_moves_threads;
const int update_threads = 256;
const int update_blocks = (my_rep_class::size + update_threads - 1) / update_threads;


void __global__ my_representation(int *A, my_rep_class *my_rep) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;

  int side = my_rep->side;

  int border = 4;

  for (int i = index; i < my_rep->b_size; i += stride) {
    int x = i % side;
    int y = i / side;

    int pos = i + side + y + 1;
    my_rep->A[pos] = A[i] + 1;

    if (x == 0) {
      if (y == 0) {
        my_rep->A[pos - side - 1] = border;
      } else if (y == side - 1) {
        my_rep->A[pos + side - 1] = border;
      }
      my_rep->A[pos - 1] = border;
    } else if (x == side - 1) {
      if (y == 0) {
        my_rep->A[pos - side + 1] = border;
      } else if (y == side - 1) {
        my_rep->A[pos + side + 1] = border;
      }
      my_rep->A[pos + 1] = border;
    } else if (y == 0) {
      my_rep->A[pos - side] = border;
    } else if (y == side - 1) {
      my_rep->A[pos + side] = border;
    }
  }
}

void __global__ possible_moves(my_rep_class *my_rep, int player, int *n_moves, int4 *moves) {
  my_rep->player = player;

  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  int side = my_rep->side;

  for (int i = index; i < my_rep->size - 1; i += stride) {

    int x = i % side;
    int y = i / side;

    int pos = index + side + y + 1;

    if (my_rep->A[pos] == player + 1) {
      if (my_rep->A[i - side - 1] == 1) {
        int j = atomicAdd(n_moves, 1);
        moves[j] = {x, y, x-1, y-1};
      }
      if (my_rep->A[i - side + 1] == 1) {
        int j = atomicAdd(n_moves, 1);
        moves[j] = {x, y, x+1, y-1};
      }
      if (my_rep->A[i + side - 1] == 1) {
        int j = atomicAdd(n_moves, 1);
        moves[j] = {x, y, x-1, y+1};
      }
      if (my_rep->A[i + side + 1] == 1) {
        int j = atomicAdd(n_moves, 1);
        moves[j] = {x, y, x+1, y-1};
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
      my_rep->A[pos] = 1;
    }

    if (x == move.z && y == move.w) {
      my_rep->A[pos] = my_rep->player;
    }
  }
}
