#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int g(int x) {
  return x+3;
}

int f(int x) {
  return g(x);
}

void main(void) {
  //printf("%d %d\n", f(8)+1, 13);
  //printf("x=%d y=%d", 3);
  unsigned int i = 0x00646c72;
	printf("H%x Wo%s", 57616, &i);//r:0x72,l:0x6c,d:0x64;57620=0xe110 %x is the Hex form of input
  exit(0);
}
