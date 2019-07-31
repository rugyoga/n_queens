#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int offset;
typedef int cindex;
typedef cindex *solution;

const cindex EMPTY = -1;
cindex N, i;
solution current;

cindex northwest(cindex file, cindex rank) {
  return file + rank;
}

cindex northeast(cindex file, cindex rank) {
  return file - rank + N;
}

bool unsafe(cindex file, cindex rank) {
  for (cindex f = 0; f < N; f++) {
    cindex r = current[f];
    if (r == EMPTY) continue;
    if (rank == r ||
        northwest(file, rank) == northwest(f, r) ||
        northeast(file, rank) == northeast(f, r))
        return true;
  }
  return false;
}

void move(cindex file, cindex rank) {
  current[file] = rank;
}

void unmove(cindex file, cindex rank) {
  current[file] = EMPTY;
}

void solve(cindex file, void (*callback)(int[])) {
  if (file == N) {
    callback(current);
  }
  else
  {
    for (cindex rank = 0; rank < N; rank++) {
      if (!unsafe(file, rank)) {
        move(file, rank);
        solve(file+1, callback);
        unmove(file, rank);
      }
    }
  }
}

void display(solution current) {
  i += 1;
  printf("%d:\n", i);
  for (cindex file = 0; file < N; file++) {
    cindex before, rank = current[file];
    for (before = 0; before < rank; before++) {
      printf(".");
    }
    printf("Q");
    before++;
    for (; before < N; before++) {
      printf(".");
    }
    printf("\n");
  }
  printf("\n");
}

void count(solution current) {
  i += 1;
}

solution init_solution(cindex N) {
  solution queens = (solution)malloc(N * sizeof(cindex));
  for (cindex f = 0; f < N; f++) {
    queens[f] = EMPTY;
  }
  return queens;
}

int main(int argc, char const *argv[]) {
  N = atoi(argv[1]);
  current = init_solution(N);
  bool is_display = argc > 2 && strcmp(argv[2], "display") == 0;
  solve(0, is_display ? display : count);
  if (!is_display) {
    printf("%d\n", i);
  }
  return 0;
}
