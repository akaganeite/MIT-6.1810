#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    char* err="an argument is required";
    //char* num[2];
    // char a = argc+'0';
    // write(1,&a,5);
    // write(1, "\n", 1);
    // for (int i=0;i<argc;i++)
    // {
    //     write(1, argv[i], strlen(argv[i]));
    //     write(1, "\n", 1);
    // }
    if (argc != 2)
    {
        write(1, err, strlen(err));
        write(1, "\n", 1);
        exit(0);
    }
    int len = atoi(argv[1]);
    sleep(len);
    exit(0);
}
