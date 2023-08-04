#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
int c=0;

void pipeline(int* l_p)
{
    close(l_p[1]);
    int r_p[2];
    pipe(r_p);  
    int num=-1;
    int flag=0;  
    flag=read(l_p[0],&num,sizeof(num));
    if(flag==0)return;
    int prime=num;
    printf("prime %d\n",prime);
    if(fork()!=0)//father
    {   
        close(r_p[0]);    
        while(1)
        {
            flag=read(l_p[0],&num,sizeof(num));
            //printf("%d\n",flag);
            if(flag==0)break;
            if(num%prime!=0)
            {
                write(r_p[1],&num,sizeof(num));
                //int pid=getpid();
                //printf("%d: %d\n",pid,num);           
            }
        }   
        close(l_p[0]);
        close(r_p[1]);
        wait(0);
    }
    else//ch
    {
        //sleep(10);
        //printf("%d \n",getpid());
        pipeline(r_p);
    }
    return;
}

int main(int argc, char *argv[])
{
  int p[2];
  pipe(p);
  if(fork()!=0)
  {
    close(p[0]);
    for(int i=2;i<=35;i++)
    {
        write(p[1],&i,sizeof(i));
    }
    close(p[1]);
    wait(0);
    //printf("father out \n");
  }
  else
  {
    pipeline(p);
  }

  exit(0);
}