#include <stdlib.h>
#include <stdio.h>

int main(int argc, char** argv) {
  // just to produce a PHI instruction
  int i = argv[1] || 0;
  int max = 0;
  while (i < argc) {
    int aux = atoi(argv[i]);
    i++;
    if (aux > max) {
      max = aux;
    }
  }
  printf("Max = %d\n", max);
}
