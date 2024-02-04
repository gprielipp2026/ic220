

#include "stdio.h"


double add(double x, double y) {
  return x + y + 2.5;
}

int main() {
  printf ("hi\n");

  double x = 1;
  double y = 10;
  
  double z = add(x,y);

  printf ("result: %lf\n", z);
}
