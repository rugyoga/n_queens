// See https://medium.com/@guy.argo/efficient-n-queens-solution-c58706170a3a
class NQueens {
  int size;
  int[] queens;

  NQueens (int size) {
    this.size = size;
    this.queens = new int[size];
  }

  int northwest(int file, int rank) {
    return file + rank;
  }

  int northeast(int file, int rank) {
    return file + this.size - rank;
  }

  boolean unsafe(int file, int rank) {
    for (int f = 0; f < file; f++) {
      int r = queens[f];
      if (r == rank ||
          northwest(f, r) == northwest(file, rank) ||
          northeast(f, r) == northeast(file, rank))
          return true;
    }
    return false;
  }

  void move(int file, int rank) {
    this.queens[file] = rank;
  }

  void unmove(int file, int rank) {
  }

  void solve(int file, Solver solver) {
    if (file == this.size) {
      solver.solve(this);
    }
    else {
      for (int rank = 0; rank < this.size; rank++) {
        if (!unsafe(file, rank)) {
          move(file, rank);
          solve(file + 1, solver);
          unmove(file, rank);
        }
      }
    }
  }

  interface Solver {
    void solve(NQueens solution);
  }

  static class Printer implements Solver {
    public int count = 0;

    public void solve(NQueens solution) {
      System.out.println(++count + ":");
      System.out.println(solution.toString());
    }
  }

  static class Counter implements Solver {
    public int count = 0;

    public void solve(NQueens solution) {
      this.count += 1;
    }
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();
    for (int file = 0; file < this.size; file++) {
      int rank = this.queens[file];
      for (int r = 0; r < rank; r++)
        sb.append('.');
      sb.append('Q');
      for (int r = rank+1; r < this.size; r++)
        sb.append('.');
      sb.append("\n");
    }
    return sb.toString();
  }

  static void solve_and_display(int size, boolean display) {
    if (display) {
      new NQueens(size).solve(0, new Printer());
    } else {
      Counter counter = new Counter();
      new NQueens(size).solve(0, counter);
      System.out.println(counter.count);
    }
  }

  public static void main(String [] args) {
    solve_and_display(
      args.length == 0 ? 8 : Integer.parseInt(args[0]),
      args.length > 1 && args[1].equals("display")
    );
  }
}
