#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
  int p[2];
  int a = pipe(p);
  char* err="pipe creation failed";
  if (a!=0)
  {
    write(1, err, strlen(err));
    write(1, "\n", 1);
    exit(0);
  }
  if(fork()==0)
  {
    close(p[1]);
    char *msg="b";
    char* receive=": received ping";
    //close(0);//close stdin
    //dup(p[0]);//redir to pipe in
    //close(p[0]);
    read(p[0],msg,sizeof(msg));
    char pid = getpid()+'0';
    write(1,&pid,sizeof(pid));
    write(1,receive,strlen(receive));
    write(1, "\n", 1);
    close(p[0]);

  }//child
  else
  {
    close(p[0]);
    char *msg="a";
    char* receive=": received pong";
    write(p[1],msg,sizeof(msg));
    wait(0);
    char pid = getpid()+'0';
    write(1,&pid,sizeof(pid));
    write(1,receive,strlen(receive));
    write(1, "\n", 1);
    close(p[1]);
  }
  exit(0);
}