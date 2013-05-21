#include <stdio.h>
#include <stdlib.h>

int main() {

  int i = 0;
  for (i = 0; i < 50; i++) {
    if (i < 25) {
      if (i < 10 ) {
        printf("less than 10\n");
      } else {
        printf("more than 10\n");
      }
    } else {
      printf("more than 25\n");
    }
  }
  return 0;
}
