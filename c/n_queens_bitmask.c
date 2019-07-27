#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef unsigned long bitmask;
typedef int offset;
typedef int cindex;
typedef cindex *solution;

cindex N, i;
solution current;
bitmask ranks, northwests, northeasts;

cindex northwest(cindex file, cindex rank) {
  return file + rank;
}

cindex northeast(cindex file, cindex rank) {
  return file - rank + N;
}

bitmask get(bitmask bits, offset i) {
  return ((bits >> i) & 1) == 1;
}

bitmask set(bitmask bits, offset i) {
  return (1 << i) | bits;
}

bitmask clear(bitmask bits, offset i) {
  return ~(1 << i) & bits;
}

bool unsafe(cindex file, cindex rank) {
  return get(ranks, rank) ||
    get(northwests, northwest(file, rank)) ||
    get(northeasts, northeast(file, rank));
}

void move(cindex file, cindex rank) {
  current[file] = rank;
  ranks = set(ranks, rank);
  northwests = set(northwests, northwest(file, rank));
  northeasts = set(northeasts, northeast(file, rank));
}

void unmove(cindex file, cindex rank) {
  ranks = clear(ranks, rank);
  northwests = clear(northwests, northwest(file, rank));
  northeasts = clear(northeasts, northeast(file, rank));
}

void solve(cindex file, void (*callback)(int[])) {
  if (file == N) {
    callback(current);
  }
  else
  {
    for (int rank = 0; rank < N; rank++) {
      if (!unsafe(file, rank)) {
        move(file, rank);
        solve(file+1, callback);
        unmove(file, rank);
      }
    }
  }
}

void display(solution current) {
  for (int file = N; file >=0; file--) {
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
}

void count(solution current) {
  i += 1;
}

int main(int argc, char const *argv[]) {
  N = atoi(argv[1]);
  current = (solution)malloc(N * sizeof(cindex));
  bool is_display = argc > 2 && strcmp(argv[2], "display") == 0;
  solve(0, is_display ? display : count);
  if (!is_display) {
    printf("%d\n", i);
  }
  return 0;
}
