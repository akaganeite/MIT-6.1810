#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char* fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));//p内容复制到buf
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));//之后空格补全
  return buf;
}

int cmp(char* a,char*b)
{
    int len_a=strlen(a);
    int len_b=strlen(b);
    if(len_a>=len_b)
    {
        for(int i=0;i<len_b;i++)
        {
            if(a[i]-b[i]!=0)return -1;
        }
        return 0;
    }
    else
    {
        for(int i=0;i<len_a;i++)
        {
            if(a[i]-b[i]!=0)return -1;
        }
        return 0;
    }
}


void find(char* path,char*obj)
{
  char buf[512], *p;
  int fd;
  struct dirent de;//inode号？，文件名
  struct stat st;//inode信息

  if((fd = open(path, 0)) < 0){//找到描述符
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){//找到文件信息
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type)
  {
    case T_DEVICE:
    case T_FILE:
        printf("%s\n",path);
        if(cmp(fmtname(path),obj)==0)
        {
            //printf("%s\n",path);
            write(1,path,strlen(path));
            write(1,"\n",1);
        }     
        break;
    case T_DIR://.是个目录
        strcpy(buf, path);//buf:'.'
        p = buf+strlen(buf);
        *p++ = '/';//p:./和buf指向同一个东西,不同地址,先取值再自增
        //printf("%c",*p);
        while(read(fd, &de, sizeof(de)) == sizeof(de))//目录文件由一些dirent组成
        {
            if(de.inum == 0)
                continue;
            memmove(p, de.name, DIRSIZ);//名字赋值给当前目录下的p(./wc)
            p[DIRSIZ] = 0;//结束符(./wc\0)
            stat(buf, &st);//st存储当前文件信息
            if(st.type==T_DIR&&de.name[0]!='.')
            {
                find(buf,obj);//如果是目录就递归查找
            }
            else if (st.type==T_FILE)
                if(cmp(fmtname(buf),obj)==0)//是文件的话如果一致就打印
                {
                  write(1,buf,strlen(buf));
                  write(1,"\n",1);
                }
        }
        break;
  }
  close(fd);
}


int main(int argc, char *argv[])
{
    find(argv[1],argv[2]);//参数一是目录，参数2是目标
    exit(0);
}