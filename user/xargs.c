#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/param.h"

int
main(int argc, char *argv[])
{
  char* xarg[MAXARG];
  int  i;
  for(i=1;i<argc;i++)//将xargs需要执行的命令及其参数赋值
  {
    xarg[i-1]=argv[i];
  }
  i--;//i-1是正确的位置，插入下一个argument
  int flag=0;
  int ch_count=0;//参数内字符标点
  int arg_count=i;//参数间标点
  char temp[MAXARG];//一个参数
  do{
    char ch;
    flag=read(0,&ch,1);//读上一个命令执行结果
    if(flag==0)break;
    if(ch!=' '&&ch!='\n')
    {
        temp[ch_count]=ch;//参数内
        ch_count++;
    }
    else if(ch==' ')//换参数
    {
        temp[ch_count]=0;//插入结束符
        ch_count=0;
        xarg[arg_count]=(char*)malloc((strlen(temp)+1)*1);//申请空间
        strcpy(xarg[arg_count],temp);//深拷贝
        memset(temp,' ',MAXARG);//重置temp
        arg_count++;
    }
    else if(ch=='\n')//换行，新命令
    {
        temp[ch_count]=0;
        ch_count=0;
        xarg[arg_count]=(char*)malloc((strlen(temp)+1)*1);  
        strcpy(xarg[arg_count],temp);
        if(fork()==0)
        {
            exec(xarg[0],xarg);
            printf("xargs failed\n");
        }
        else
        {
            wait(0);
            memset(temp,' ',MAXARG);//重置temp
            for(int k=i;k<=arg_count;k++)//释放空间
            {
                free(xarg[k]);
            }
            arg_count=i;
        }
    }
  }while(flag!=0);
  exit(0);
}