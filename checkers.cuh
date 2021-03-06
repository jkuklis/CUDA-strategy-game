struct my_rep_class {
// this struct could have private variables and public setters/getters
public:
  // side of the board
  static const int b_side = 2048;
  // side of the board's representation, additional border to omit extra checks
  // in possible_moves
  static const int side = b_side + 2;
  static const int b_size = b_side * b_side;
  static const int size = side * side;

  // board representation;
  int board_rep[size];

  // which player had moves updated last time
  int player;
};


// parameters tested with NVIDIA Tesla P4
const int my_representation_threads = 512;
const int my_representation_blocks = 256;
const int possible_moves_threads = 128;
const int possible_moves_blocks = 256;
const int update_threads = 512;
const int update_blocks = 256;


void __global__ my_representation(int *A, my_rep_class *my_rep) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;

  int b_side = my_rep->b_side;
  int side = my_rep->side;

  int border = 4;

  for (int i = index; i < my_rep->b_size; i += stride) {
    int x = i % b_side;
    int y = i / b_side;

    int pos = side * (y + 1) + (x + 1);

    my_rep->board_rep[pos] = A[i];

    // extra border filling
    if (x == 0) {
      if (y == 0) {
        my_rep->board_rep[pos - side - 1] = border;
        my_rep->board_rep[pos - side] = border;
      } else if (y == b_side - 1) {
        my_rep->board_rep[pos + side - 1] = border;
        my_rep->board_rep[pos + side] = border;
      }
      my_rep->board_rep[pos - 1] = border;
    } else if (x == b_side - 1) {
      if (y == 0) {
        my_rep->board_rep[pos - side + 1] = border;
        my_rep->board_rep[pos - side] = border;
      } else if (y == b_side - 1) {
        my_rep->board_rep[pos + side + 1] = border;
        my_rep->board_rep[pos + side] = border;
      }
      my_rep->board_rep[pos + 1] = border;
    } else if (y == 0) {
      my_rep->board_rep[pos - side] = border;
    } else if (y == b_side - 1) {
      my_rep->board_rep[pos + side] = border;
    }
  }
}

void __global__ possible_moves(my_rep_class *my_rep, int player, int *n_moves, int4 *moves) {
  my_rep->player = player;

  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  int side = my_rep->side;
  int b_side = my_rep->b_side;

  for (int i = index; i < my_rep->b_size; i += stride) {

    int x = i % b_side;
    int y = i / b_side;

    int pos = side * (y + 1) + (x + 1);

    if (my_rep->board_rep[pos] == my_rep->player) {
      if (my_rep->board_rep[pos - side - 1] == 0) {
        int j = atomicAdd(n_moves, 1);
        moves[j] = {x, y, x-1, y-1};
      }
      if (my_rep->board_rep[pos - side + 1] == 0) {
        int j = atomicAdd(n_moves, 1);
        moves[j] = {x, y, x+1, y-1};
      }
      if (my_rep->board_rep[pos + side - 1] == 0) {
        int j = atomicAdd(n_moves, 1);
        moves[j] = {x, y, x-1, y+1};
      }
      if (my_rep->board_rep[pos + side + 1] == 0) {
        int j = atomicAdd(n_moves, 1);
        moves[j] = {x, y, x+1, y+1};
      }
    }
  }

}

void __global__ update(my_rep_class *my_rep, int4 move) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;

  int side = my_rep->side;
  int b_side = my_rep->b_side;

  for (int i = index; i < my_rep->size - 1; i += stride) {
    int x = i % b_side;
    int y = i / b_side;

    int pos = side * (y + 1) + (x + 1);

    if (x == move.x && y == move.y) {
      my_rep->board_rep[pos] = 0;
    }

    if (x == move.z && y == move.w) {
      my_rep->board_rep[pos] = my_rep->player;
    }
  }
}
