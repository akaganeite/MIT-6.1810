
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/param.h"

int
main(int argc, char *argv[])
{
   0:	7165                	addi	sp,sp,-400
   2:	e706                	sd	ra,392(sp)
   4:	e322                	sd	s0,384(sp)
   6:	fea6                	sd	s1,376(sp)
   8:	faca                	sd	s2,368(sp)
   a:	f6ce                	sd	s3,360(sp)
   c:	f2d2                	sd	s4,352(sp)
   e:	eed6                	sd	s5,344(sp)
  10:	eada                	sd	s6,336(sp)
  12:	e6de                	sd	s7,328(sp)
  14:	e2e2                	sd	s8,320(sp)
  16:	fe66                	sd	s9,312(sp)
  18:	0b00                	addi	s0,sp,400
  char* xarg[MAXARG];
  int  i;
  for(i=1;i<argc;i++)//将xargs需要执行的命令及其参数赋值
  1a:	4785                	li	a5,1
  1c:	04a7d763          	bge	a5,a0,6a <main+0x6a>
  20:	05a1                	addi	a1,a1,8
  22:	ea040793          	addi	a5,s0,-352
  26:	ffe5069b          	addiw	a3,a0,-2
  2a:	1682                	slli	a3,a3,0x20
  2c:	9281                	srli	a3,a3,0x20
  2e:	068e                	slli	a3,a3,0x3
  30:	ea840713          	addi	a4,s0,-344
  34:	96ba                	add	a3,a3,a4
  {
    xarg[i-1]=argv[i];
  36:	6198                	ld	a4,0(a1)
  38:	e398                	sd	a4,0(a5)
  for(i=1;i<argc;i++)//将xargs需要执行的命令及其参数赋值
  3a:	05a1                	addi	a1,a1,8
  3c:	07a1                	addi	a5,a5,8
  3e:	fed79ce3          	bne	a5,a3,36 <main+0x36>
  }
  i--;//i-1是正确的位置，插入下一个argument
  42:	fff50b1b          	addiw	s6,a0,-1
  int flag=0;
  int ch_count=0;//参数内字符标点
  int arg_count=i;//参数间标点
  46:	8c2a                	mv	s8,a0
  48:	00351a93          	slli	s5,a0,0x3
  4c:	fa040793          	addi	a5,s0,-96
  50:	9abe                	add	s5,s5,a5
  52:	ef8a8a93          	addi	s5,s5,-264
  56:	89da                	mv	s3,s6
  int ch_count=0;//参数内字符标点
  58:	4481                	li	s1,0
  char temp[MAXARG];//一个参数
  do{
    char ch;
    flag=read(0,&ch,1);//读上一个命令执行结果
    if(flag==0)break;
    if(ch!=' '&&ch!='\n')
  5a:	02000913          	li	s2,32
  5e:	4a29                	li	s4,10
            memset(temp,' ',MAXARG);//重置temp
            for(int k=i;k<=arg_count;k++)//释放空间
            {
                free(xarg[k]);
            }
            arg_count=i;
  60:	8bda                	mv	s7,s6
  62:	4c85                	li	s9,1
  64:	40ac8cbb          	subw	s9,s9,a0
  68:	a809                	j	7a <main+0x7a>
  for(i=1;i<argc;i++)//将xargs需要执行的命令及其参数赋值
  6a:	4505                	li	a0,1
  6c:	bfd9                	j	42 <main+0x42>
        temp[ch_count]=ch;//参数内
  6e:	fa040713          	addi	a4,s0,-96
  72:	9726                	add	a4,a4,s1
  74:	eef70023          	sb	a5,-288(a4)
        ch_count++;
  78:	2485                	addiw	s1,s1,1
    flag=read(0,&ch,1);//读上一个命令执行结果
  7a:	4605                	li	a2,1
  7c:	e7f40593          	addi	a1,s0,-385
  80:	4501                	li	a0,0
  82:	00000097          	auipc	ra,0x0
  86:	3d2080e7          	jalr	978(ra) # 454 <read>
    if(flag==0)break;
  8a:	10050c63          	beqz	a0,1a2 <main+0x1a2>
    if(ch!=' '&&ch!='\n')
  8e:	e7f44783          	lbu	a5,-385(s0)
  92:	07278863          	beq	a5,s2,102 <main+0x102>
  96:	fd479ce3          	bne	a5,s4,6e <main+0x6e>
        temp[ch_count]=0;
  9a:	fa040793          	addi	a5,s0,-96
  9e:	94be                	add	s1,s1,a5
  a0:	ee048023          	sb	zero,-288(s1)
        xarg[arg_count]=(char*)malloc((strlen(temp)+1)*1);  
  a4:	e8040513          	addi	a0,s0,-384
  a8:	00000097          	auipc	ra,0x0
  ac:	166080e7          	jalr	358(ra) # 20e <strlen>
  b0:	2505                	addiw	a0,a0,1
  b2:	00000097          	auipc	ra,0x0
  b6:	7c0080e7          	jalr	1984(ra) # 872 <malloc>
  ba:	00399793          	slli	a5,s3,0x3
  be:	fa040713          	addi	a4,s0,-96
  c2:	97ba                	add	a5,a5,a4
  c4:	f0a7b023          	sd	a0,-256(a5)
        strcpy(xarg[arg_count],temp);
  c8:	e8040593          	addi	a1,s0,-384
  cc:	00000097          	auipc	ra,0x0
  d0:	0fa080e7          	jalr	250(ra) # 1c6 <strcpy>
        if(fork()==0)
  d4:	00000097          	auipc	ra,0x0
  d8:	360080e7          	jalr	864(ra) # 434 <fork>
  dc:	84aa                	mv	s1,a0
  de:	e935                	bnez	a0,152 <main+0x152>
            exec(xarg[0],xarg);
  e0:	ea040593          	addi	a1,s0,-352
  e4:	ea043503          	ld	a0,-352(s0)
  e8:	00000097          	auipc	ra,0x0
  ec:	38c080e7          	jalr	908(ra) # 474 <exec>
            printf("xargs failed\n");
  f0:	00001517          	auipc	a0,0x1
  f4:	87050513          	addi	a0,a0,-1936 # 960 <malloc+0xee>
  f8:	00000097          	auipc	ra,0x0
  fc:	6bc080e7          	jalr	1724(ra) # 7b4 <printf>
 100:	bfad                	j	7a <main+0x7a>
        temp[ch_count]=0;//插入结束符
 102:	fa040793          	addi	a5,s0,-96
 106:	94be                	add	s1,s1,a5
 108:	ee048023          	sb	zero,-288(s1)
        xarg[arg_count]=(char*)malloc((strlen(temp)+1)*1);//申请空间
 10c:	e8040513          	addi	a0,s0,-384
 110:	00000097          	auipc	ra,0x0
 114:	0fe080e7          	jalr	254(ra) # 20e <strlen>
 118:	2505                	addiw	a0,a0,1
 11a:	00000097          	auipc	ra,0x0
 11e:	758080e7          	jalr	1880(ra) # 872 <malloc>
 122:	00399793          	slli	a5,s3,0x3
 126:	fa040713          	addi	a4,s0,-96
 12a:	97ba                	add	a5,a5,a4
 12c:	f0a7b023          	sd	a0,-256(a5)
        strcpy(xarg[arg_count],temp);//深拷贝
 130:	e8040593          	addi	a1,s0,-384
 134:	00000097          	auipc	ra,0x0
 138:	092080e7          	jalr	146(ra) # 1c6 <strcpy>
        memset(temp,' ',MAXARG);//重置temp
 13c:	864a                	mv	a2,s2
 13e:	85ca                	mv	a1,s2
 140:	e8040513          	addi	a0,s0,-384
 144:	00000097          	auipc	ra,0x0
 148:	0f4080e7          	jalr	244(ra) # 238 <memset>
        arg_count++;
 14c:	2985                	addiw	s3,s3,1
        ch_count=0;
 14e:	4481                	li	s1,0
 150:	b72d                	j	7a <main+0x7a>
            wait(0);
 152:	4501                	li	a0,0
 154:	00000097          	auipc	ra,0x0
 158:	2f0080e7          	jalr	752(ra) # 444 <wait>
            memset(temp,' ',MAXARG);//重置temp
 15c:	864a                	mv	a2,s2
 15e:	85ca                	mv	a1,s2
 160:	e8040513          	addi	a0,s0,-384
 164:	00000097          	auipc	ra,0x0
 168:	0d4080e7          	jalr	212(ra) # 238 <memset>
            for(int k=i;k<=arg_count;k++)//释放空间
 16c:	0369c863          	blt	s3,s6,19c <main+0x19c>
 170:	013c89bb          	addw	s3,s9,s3
 174:	1982                	slli	s3,s3,0x20
 176:	0209d993          	srli	s3,s3,0x20
 17a:	99e2                	add	s3,s3,s8
 17c:	098e                	slli	s3,s3,0x3
 17e:	ea040793          	addi	a5,s0,-352
 182:	99be                	add	s3,s3,a5
 184:	84d6                	mv	s1,s5
                free(xarg[k]);
 186:	6088                	ld	a0,0(s1)
 188:	00000097          	auipc	ra,0x0
 18c:	662080e7          	jalr	1634(ra) # 7ea <free>
            for(int k=i;k<=arg_count;k++)//释放空间
 190:	04a1                	addi	s1,s1,8
 192:	ff349ae3          	bne	s1,s3,186 <main+0x186>
            arg_count=i;
 196:	89de                	mv	s3,s7
        ch_count=0;
 198:	4481                	li	s1,0
 19a:	b5c5                	j	7a <main+0x7a>
            arg_count=i;
 19c:	89de                	mv	s3,s7
        ch_count=0;
 19e:	4481                	li	s1,0
        }
    }
  }while(flag!=0);
 1a0:	bde9                	j	7a <main+0x7a>
  exit(0);
 1a2:	4501                	li	a0,0
 1a4:	00000097          	auipc	ra,0x0
 1a8:	298080e7          	jalr	664(ra) # 43c <exit>

00000000000001ac <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1b4:	00000097          	auipc	ra,0x0
 1b8:	e4c080e7          	jalr	-436(ra) # 0 <main>
  exit(0);
 1bc:	4501                	li	a0,0
 1be:	00000097          	auipc	ra,0x0
 1c2:	27e080e7          	jalr	638(ra) # 43c <exit>

00000000000001c6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1cc:	87aa                	mv	a5,a0
 1ce:	0585                	addi	a1,a1,1
 1d0:	0785                	addi	a5,a5,1
 1d2:	fff5c703          	lbu	a4,-1(a1)
 1d6:	fee78fa3          	sb	a4,-1(a5)
 1da:	fb75                	bnez	a4,1ce <strcpy+0x8>
    ;
  return os;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret

00000000000001e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1e8:	00054783          	lbu	a5,0(a0)
 1ec:	cb91                	beqz	a5,200 <strcmp+0x1e>
 1ee:	0005c703          	lbu	a4,0(a1)
 1f2:	00f71763          	bne	a4,a5,200 <strcmp+0x1e>
    p++, q++;
 1f6:	0505                	addi	a0,a0,1
 1f8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1fa:	00054783          	lbu	a5,0(a0)
 1fe:	fbe5                	bnez	a5,1ee <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 200:	0005c503          	lbu	a0,0(a1)
}
 204:	40a7853b          	subw	a0,a5,a0
 208:	6422                	ld	s0,8(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret

000000000000020e <strlen>:

uint
strlen(const char *s)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e422                	sd	s0,8(sp)
 212:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 214:	00054783          	lbu	a5,0(a0)
 218:	cf91                	beqz	a5,234 <strlen+0x26>
 21a:	0505                	addi	a0,a0,1
 21c:	87aa                	mv	a5,a0
 21e:	4685                	li	a3,1
 220:	9e89                	subw	a3,a3,a0
 222:	00f6853b          	addw	a0,a3,a5
 226:	0785                	addi	a5,a5,1
 228:	fff7c703          	lbu	a4,-1(a5)
 22c:	fb7d                	bnez	a4,222 <strlen+0x14>
    ;
  return n;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  for(n = 0; s[n]; n++)
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <strlen+0x20>

0000000000000238 <memset>:

void*
memset(void *dst, int c, uint n)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 23e:	ce09                	beqz	a2,258 <memset+0x20>
 240:	87aa                	mv	a5,a0
 242:	fff6071b          	addiw	a4,a2,-1
 246:	1702                	slli	a4,a4,0x20
 248:	9301                	srli	a4,a4,0x20
 24a:	0705                	addi	a4,a4,1
 24c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 24e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 252:	0785                	addi	a5,a5,1
 254:	fee79de3          	bne	a5,a4,24e <memset+0x16>
  }
  return dst;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <strchr>:

char*
strchr(const char *s, char c)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  for(; *s; s++)
 264:	00054783          	lbu	a5,0(a0)
 268:	cb99                	beqz	a5,27e <strchr+0x20>
    if(*s == c)
 26a:	00f58763          	beq	a1,a5,278 <strchr+0x1a>
  for(; *s; s++)
 26e:	0505                	addi	a0,a0,1
 270:	00054783          	lbu	a5,0(a0)
 274:	fbfd                	bnez	a5,26a <strchr+0xc>
      return (char*)s;
  return 0;
 276:	4501                	li	a0,0
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  return 0;
 27e:	4501                	li	a0,0
 280:	bfe5                	j	278 <strchr+0x1a>

0000000000000282 <gets>:

char*
gets(char *buf, int max)
{
 282:	711d                	addi	sp,sp,-96
 284:	ec86                	sd	ra,88(sp)
 286:	e8a2                	sd	s0,80(sp)
 288:	e4a6                	sd	s1,72(sp)
 28a:	e0ca                	sd	s2,64(sp)
 28c:	fc4e                	sd	s3,56(sp)
 28e:	f852                	sd	s4,48(sp)
 290:	f456                	sd	s5,40(sp)
 292:	f05a                	sd	s6,32(sp)
 294:	ec5e                	sd	s7,24(sp)
 296:	1080                	addi	s0,sp,96
 298:	8baa                	mv	s7,a0
 29a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29c:	892a                	mv	s2,a0
 29e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2a0:	4aa9                	li	s5,10
 2a2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2a4:	89a6                	mv	s3,s1
 2a6:	2485                	addiw	s1,s1,1
 2a8:	0344d863          	bge	s1,s4,2d8 <gets+0x56>
    cc = read(0, &c, 1);
 2ac:	4605                	li	a2,1
 2ae:	faf40593          	addi	a1,s0,-81
 2b2:	4501                	li	a0,0
 2b4:	00000097          	auipc	ra,0x0
 2b8:	1a0080e7          	jalr	416(ra) # 454 <read>
    if(cc < 1)
 2bc:	00a05e63          	blez	a0,2d8 <gets+0x56>
    buf[i++] = c;
 2c0:	faf44783          	lbu	a5,-81(s0)
 2c4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2c8:	01578763          	beq	a5,s5,2d6 <gets+0x54>
 2cc:	0905                	addi	s2,s2,1
 2ce:	fd679be3          	bne	a5,s6,2a4 <gets+0x22>
  for(i=0; i+1 < max; ){
 2d2:	89a6                	mv	s3,s1
 2d4:	a011                	j	2d8 <gets+0x56>
 2d6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2d8:	99de                	add	s3,s3,s7
 2da:	00098023          	sb	zero,0(s3)
  return buf;
}
 2de:	855e                	mv	a0,s7
 2e0:	60e6                	ld	ra,88(sp)
 2e2:	6446                	ld	s0,80(sp)
 2e4:	64a6                	ld	s1,72(sp)
 2e6:	6906                	ld	s2,64(sp)
 2e8:	79e2                	ld	s3,56(sp)
 2ea:	7a42                	ld	s4,48(sp)
 2ec:	7aa2                	ld	s5,40(sp)
 2ee:	7b02                	ld	s6,32(sp)
 2f0:	6be2                	ld	s7,24(sp)
 2f2:	6125                	addi	sp,sp,96
 2f4:	8082                	ret

00000000000002f6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f6:	1101                	addi	sp,sp,-32
 2f8:	ec06                	sd	ra,24(sp)
 2fa:	e822                	sd	s0,16(sp)
 2fc:	e426                	sd	s1,8(sp)
 2fe:	e04a                	sd	s2,0(sp)
 300:	1000                	addi	s0,sp,32
 302:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 304:	4581                	li	a1,0
 306:	00000097          	auipc	ra,0x0
 30a:	176080e7          	jalr	374(ra) # 47c <open>
  if(fd < 0)
 30e:	02054563          	bltz	a0,338 <stat+0x42>
 312:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 314:	85ca                	mv	a1,s2
 316:	00000097          	auipc	ra,0x0
 31a:	17e080e7          	jalr	382(ra) # 494 <fstat>
 31e:	892a                	mv	s2,a0
  close(fd);
 320:	8526                	mv	a0,s1
 322:	00000097          	auipc	ra,0x0
 326:	142080e7          	jalr	322(ra) # 464 <close>
  return r;
}
 32a:	854a                	mv	a0,s2
 32c:	60e2                	ld	ra,24(sp)
 32e:	6442                	ld	s0,16(sp)
 330:	64a2                	ld	s1,8(sp)
 332:	6902                	ld	s2,0(sp)
 334:	6105                	addi	sp,sp,32
 336:	8082                	ret
    return -1;
 338:	597d                	li	s2,-1
 33a:	bfc5                	j	32a <stat+0x34>

000000000000033c <atoi>:

int
atoi(const char *s)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 342:	00054603          	lbu	a2,0(a0)
 346:	fd06079b          	addiw	a5,a2,-48
 34a:	0ff7f793          	andi	a5,a5,255
 34e:	4725                	li	a4,9
 350:	02f76963          	bltu	a4,a5,382 <atoi+0x46>
 354:	86aa                	mv	a3,a0
  n = 0;
 356:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 358:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 35a:	0685                	addi	a3,a3,1
 35c:	0025179b          	slliw	a5,a0,0x2
 360:	9fa9                	addw	a5,a5,a0
 362:	0017979b          	slliw	a5,a5,0x1
 366:	9fb1                	addw	a5,a5,a2
 368:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 36c:	0006c603          	lbu	a2,0(a3)
 370:	fd06071b          	addiw	a4,a2,-48
 374:	0ff77713          	andi	a4,a4,255
 378:	fee5f1e3          	bgeu	a1,a4,35a <atoi+0x1e>
  return n;
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret
  n = 0;
 382:	4501                	li	a0,0
 384:	bfe5                	j	37c <atoi+0x40>

0000000000000386 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 386:	1141                	addi	sp,sp,-16
 388:	e422                	sd	s0,8(sp)
 38a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 38c:	02b57663          	bgeu	a0,a1,3b8 <memmove+0x32>
    while(n-- > 0)
 390:	02c05163          	blez	a2,3b2 <memmove+0x2c>
 394:	fff6079b          	addiw	a5,a2,-1
 398:	1782                	slli	a5,a5,0x20
 39a:	9381                	srli	a5,a5,0x20
 39c:	0785                	addi	a5,a5,1
 39e:	97aa                	add	a5,a5,a0
  dst = vdst;
 3a0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3a2:	0585                	addi	a1,a1,1
 3a4:	0705                	addi	a4,a4,1
 3a6:	fff5c683          	lbu	a3,-1(a1)
 3aa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3ae:	fee79ae3          	bne	a5,a4,3a2 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3b2:	6422                	ld	s0,8(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret
    dst += n;
 3b8:	00c50733          	add	a4,a0,a2
    src += n;
 3bc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3be:	fec05ae3          	blez	a2,3b2 <memmove+0x2c>
 3c2:	fff6079b          	addiw	a5,a2,-1
 3c6:	1782                	slli	a5,a5,0x20
 3c8:	9381                	srli	a5,a5,0x20
 3ca:	fff7c793          	not	a5,a5
 3ce:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3d0:	15fd                	addi	a1,a1,-1
 3d2:	177d                	addi	a4,a4,-1
 3d4:	0005c683          	lbu	a3,0(a1)
 3d8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3dc:	fee79ae3          	bne	a5,a4,3d0 <memmove+0x4a>
 3e0:	bfc9                	j	3b2 <memmove+0x2c>

00000000000003e2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e422                	sd	s0,8(sp)
 3e6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e8:	ca05                	beqz	a2,418 <memcmp+0x36>
 3ea:	fff6069b          	addiw	a3,a2,-1
 3ee:	1682                	slli	a3,a3,0x20
 3f0:	9281                	srli	a3,a3,0x20
 3f2:	0685                	addi	a3,a3,1
 3f4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3f6:	00054783          	lbu	a5,0(a0)
 3fa:	0005c703          	lbu	a4,0(a1)
 3fe:	00e79863          	bne	a5,a4,40e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 402:	0505                	addi	a0,a0,1
    p2++;
 404:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 406:	fed518e3          	bne	a0,a3,3f6 <memcmp+0x14>
  }
  return 0;
 40a:	4501                	li	a0,0
 40c:	a019                	j	412 <memcmp+0x30>
      return *p1 - *p2;
 40e:	40e7853b          	subw	a0,a5,a4
}
 412:	6422                	ld	s0,8(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret
  return 0;
 418:	4501                	li	a0,0
 41a:	bfe5                	j	412 <memcmp+0x30>

000000000000041c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 41c:	1141                	addi	sp,sp,-16
 41e:	e406                	sd	ra,8(sp)
 420:	e022                	sd	s0,0(sp)
 422:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 424:	00000097          	auipc	ra,0x0
 428:	f62080e7          	jalr	-158(ra) # 386 <memmove>
}
 42c:	60a2                	ld	ra,8(sp)
 42e:	6402                	ld	s0,0(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret

0000000000000434 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 434:	4885                	li	a7,1
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <exit>:
.global exit
exit:
 li a7, SYS_exit
 43c:	4889                	li	a7,2
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <wait>:
.global wait
wait:
 li a7, SYS_wait
 444:	488d                	li	a7,3
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 44c:	4891                	li	a7,4
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <read>:
.global read
read:
 li a7, SYS_read
 454:	4895                	li	a7,5
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <write>:
.global write
write:
 li a7, SYS_write
 45c:	48c1                	li	a7,16
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <close>:
.global close
close:
 li a7, SYS_close
 464:	48d5                	li	a7,21
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <kill>:
.global kill
kill:
 li a7, SYS_kill
 46c:	4899                	li	a7,6
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <exec>:
.global exec
exec:
 li a7, SYS_exec
 474:	489d                	li	a7,7
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <open>:
.global open
open:
 li a7, SYS_open
 47c:	48bd                	li	a7,15
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 484:	48c5                	li	a7,17
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 48c:	48c9                	li	a7,18
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 494:	48a1                	li	a7,8
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <link>:
.global link
link:
 li a7, SYS_link
 49c:	48cd                	li	a7,19
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4a4:	48d1                	li	a7,20
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ac:	48a5                	li	a7,9
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4b4:	48a9                	li	a7,10
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4bc:	48ad                	li	a7,11
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4c4:	48b1                	li	a7,12
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4cc:	48b5                	li	a7,13
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4d4:	48b9                	li	a7,14
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4dc:	1101                	addi	sp,sp,-32
 4de:	ec06                	sd	ra,24(sp)
 4e0:	e822                	sd	s0,16(sp)
 4e2:	1000                	addi	s0,sp,32
 4e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e8:	4605                	li	a2,1
 4ea:	fef40593          	addi	a1,s0,-17
 4ee:	00000097          	auipc	ra,0x0
 4f2:	f6e080e7          	jalr	-146(ra) # 45c <write>
}
 4f6:	60e2                	ld	ra,24(sp)
 4f8:	6442                	ld	s0,16(sp)
 4fa:	6105                	addi	sp,sp,32
 4fc:	8082                	ret

00000000000004fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4fe:	7139                	addi	sp,sp,-64
 500:	fc06                	sd	ra,56(sp)
 502:	f822                	sd	s0,48(sp)
 504:	f426                	sd	s1,40(sp)
 506:	f04a                	sd	s2,32(sp)
 508:	ec4e                	sd	s3,24(sp)
 50a:	0080                	addi	s0,sp,64
 50c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 50e:	c299                	beqz	a3,514 <printint+0x16>
 510:	0805c863          	bltz	a1,5a0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 514:	2581                	sext.w	a1,a1
  neg = 0;
 516:	4881                	li	a7,0
 518:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 51c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 51e:	2601                	sext.w	a2,a2
 520:	00000517          	auipc	a0,0x0
 524:	45850513          	addi	a0,a0,1112 # 978 <digits>
 528:	883a                	mv	a6,a4
 52a:	2705                	addiw	a4,a4,1
 52c:	02c5f7bb          	remuw	a5,a1,a2
 530:	1782                	slli	a5,a5,0x20
 532:	9381                	srli	a5,a5,0x20
 534:	97aa                	add	a5,a5,a0
 536:	0007c783          	lbu	a5,0(a5)
 53a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 53e:	0005879b          	sext.w	a5,a1
 542:	02c5d5bb          	divuw	a1,a1,a2
 546:	0685                	addi	a3,a3,1
 548:	fec7f0e3          	bgeu	a5,a2,528 <printint+0x2a>
  if(neg)
 54c:	00088b63          	beqz	a7,562 <printint+0x64>
    buf[i++] = '-';
 550:	fd040793          	addi	a5,s0,-48
 554:	973e                	add	a4,a4,a5
 556:	02d00793          	li	a5,45
 55a:	fef70823          	sb	a5,-16(a4)
 55e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 562:	02e05863          	blez	a4,592 <printint+0x94>
 566:	fc040793          	addi	a5,s0,-64
 56a:	00e78933          	add	s2,a5,a4
 56e:	fff78993          	addi	s3,a5,-1
 572:	99ba                	add	s3,s3,a4
 574:	377d                	addiw	a4,a4,-1
 576:	1702                	slli	a4,a4,0x20
 578:	9301                	srli	a4,a4,0x20
 57a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 57e:	fff94583          	lbu	a1,-1(s2)
 582:	8526                	mv	a0,s1
 584:	00000097          	auipc	ra,0x0
 588:	f58080e7          	jalr	-168(ra) # 4dc <putc>
  while(--i >= 0)
 58c:	197d                	addi	s2,s2,-1
 58e:	ff3918e3          	bne	s2,s3,57e <printint+0x80>
}
 592:	70e2                	ld	ra,56(sp)
 594:	7442                	ld	s0,48(sp)
 596:	74a2                	ld	s1,40(sp)
 598:	7902                	ld	s2,32(sp)
 59a:	69e2                	ld	s3,24(sp)
 59c:	6121                	addi	sp,sp,64
 59e:	8082                	ret
    x = -xx;
 5a0:	40b005bb          	negw	a1,a1
    neg = 1;
 5a4:	4885                	li	a7,1
    x = -xx;
 5a6:	bf8d                	j	518 <printint+0x1a>

00000000000005a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a8:	7119                	addi	sp,sp,-128
 5aa:	fc86                	sd	ra,120(sp)
 5ac:	f8a2                	sd	s0,112(sp)
 5ae:	f4a6                	sd	s1,104(sp)
 5b0:	f0ca                	sd	s2,96(sp)
 5b2:	ecce                	sd	s3,88(sp)
 5b4:	e8d2                	sd	s4,80(sp)
 5b6:	e4d6                	sd	s5,72(sp)
 5b8:	e0da                	sd	s6,64(sp)
 5ba:	fc5e                	sd	s7,56(sp)
 5bc:	f862                	sd	s8,48(sp)
 5be:	f466                	sd	s9,40(sp)
 5c0:	f06a                	sd	s10,32(sp)
 5c2:	ec6e                	sd	s11,24(sp)
 5c4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c6:	0005c903          	lbu	s2,0(a1)
 5ca:	18090f63          	beqz	s2,768 <vprintf+0x1c0>
 5ce:	8aaa                	mv	s5,a0
 5d0:	8b32                	mv	s6,a2
 5d2:	00158493          	addi	s1,a1,1
  state = 0;
 5d6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d8:	02500a13          	li	s4,37
      if(c == 'd'){
 5dc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5e0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5e4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5e8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ec:	00000b97          	auipc	s7,0x0
 5f0:	38cb8b93          	addi	s7,s7,908 # 978 <digits>
 5f4:	a839                	j	612 <vprintf+0x6a>
        putc(fd, c);
 5f6:	85ca                	mv	a1,s2
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	ee2080e7          	jalr	-286(ra) # 4dc <putc>
 602:	a019                	j	608 <vprintf+0x60>
    } else if(state == '%'){
 604:	01498f63          	beq	s3,s4,622 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 608:	0485                	addi	s1,s1,1
 60a:	fff4c903          	lbu	s2,-1(s1)
 60e:	14090d63          	beqz	s2,768 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 612:	0009079b          	sext.w	a5,s2
    if(state == 0){
 616:	fe0997e3          	bnez	s3,604 <vprintf+0x5c>
      if(c == '%'){
 61a:	fd479ee3          	bne	a5,s4,5f6 <vprintf+0x4e>
        state = '%';
 61e:	89be                	mv	s3,a5
 620:	b7e5                	j	608 <vprintf+0x60>
      if(c == 'd'){
 622:	05878063          	beq	a5,s8,662 <vprintf+0xba>
      } else if(c == 'l') {
 626:	05978c63          	beq	a5,s9,67e <vprintf+0xd6>
      } else if(c == 'x') {
 62a:	07a78863          	beq	a5,s10,69a <vprintf+0xf2>
      } else if(c == 'p') {
 62e:	09b78463          	beq	a5,s11,6b6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 632:	07300713          	li	a4,115
 636:	0ce78663          	beq	a5,a4,702 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63a:	06300713          	li	a4,99
 63e:	0ee78e63          	beq	a5,a4,73a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 642:	11478863          	beq	a5,s4,752 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 646:	85d2                	mv	a1,s4
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	e92080e7          	jalr	-366(ra) # 4dc <putc>
        putc(fd, c);
 652:	85ca                	mv	a1,s2
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e86080e7          	jalr	-378(ra) # 4dc <putc>
      }
      state = 0;
 65e:	4981                	li	s3,0
 660:	b765                	j	608 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 662:	008b0913          	addi	s2,s6,8
 666:	4685                	li	a3,1
 668:	4629                	li	a2,10
 66a:	000b2583          	lw	a1,0(s6)
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	e8e080e7          	jalr	-370(ra) # 4fe <printint>
 678:	8b4a                	mv	s6,s2
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b771                	j	608 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67e:	008b0913          	addi	s2,s6,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000b2583          	lw	a1,0(s6)
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	e72080e7          	jalr	-398(ra) # 4fe <printint>
 694:	8b4a                	mv	s6,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	bf85                	j	608 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 69a:	008b0913          	addi	s2,s6,8
 69e:	4681                	li	a3,0
 6a0:	4641                	li	a2,16
 6a2:	000b2583          	lw	a1,0(s6)
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e56080e7          	jalr	-426(ra) # 4fe <printint>
 6b0:	8b4a                	mv	s6,s2
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bf91                	j	608 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6b6:	008b0793          	addi	a5,s6,8
 6ba:	f8f43423          	sd	a5,-120(s0)
 6be:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6c2:	03000593          	li	a1,48
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	e14080e7          	jalr	-492(ra) # 4dc <putc>
  putc(fd, 'x');
 6d0:	85ea                	mv	a1,s10
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e08080e7          	jalr	-504(ra) # 4dc <putc>
 6dc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6de:	03c9d793          	srli	a5,s3,0x3c
 6e2:	97de                	add	a5,a5,s7
 6e4:	0007c583          	lbu	a1,0(a5)
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	df2080e7          	jalr	-526(ra) # 4dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f2:	0992                	slli	s3,s3,0x4
 6f4:	397d                	addiw	s2,s2,-1
 6f6:	fe0914e3          	bnez	s2,6de <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6fa:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b721                	j	608 <vprintf+0x60>
        s = va_arg(ap, char*);
 702:	008b0993          	addi	s3,s6,8
 706:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 70a:	02090163          	beqz	s2,72c <vprintf+0x184>
        while(*s != 0){
 70e:	00094583          	lbu	a1,0(s2)
 712:	c9a1                	beqz	a1,762 <vprintf+0x1ba>
          putc(fd, *s);
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	dc6080e7          	jalr	-570(ra) # 4dc <putc>
          s++;
 71e:	0905                	addi	s2,s2,1
        while(*s != 0){
 720:	00094583          	lbu	a1,0(s2)
 724:	f9e5                	bnez	a1,714 <vprintf+0x16c>
        s = va_arg(ap, char*);
 726:	8b4e                	mv	s6,s3
      state = 0;
 728:	4981                	li	s3,0
 72a:	bdf9                	j	608 <vprintf+0x60>
          s = "(null)";
 72c:	00000917          	auipc	s2,0x0
 730:	24490913          	addi	s2,s2,580 # 970 <malloc+0xfe>
        while(*s != 0){
 734:	02800593          	li	a1,40
 738:	bff1                	j	714 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 73a:	008b0913          	addi	s2,s6,8
 73e:	000b4583          	lbu	a1,0(s6)
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	d98080e7          	jalr	-616(ra) # 4dc <putc>
 74c:	8b4a                	mv	s6,s2
      state = 0;
 74e:	4981                	li	s3,0
 750:	bd65                	j	608 <vprintf+0x60>
        putc(fd, c);
 752:	85d2                	mv	a1,s4
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	d86080e7          	jalr	-634(ra) # 4dc <putc>
      state = 0;
 75e:	4981                	li	s3,0
 760:	b565                	j	608 <vprintf+0x60>
        s = va_arg(ap, char*);
 762:	8b4e                	mv	s6,s3
      state = 0;
 764:	4981                	li	s3,0
 766:	b54d                	j	608 <vprintf+0x60>
    }
  }
}
 768:	70e6                	ld	ra,120(sp)
 76a:	7446                	ld	s0,112(sp)
 76c:	74a6                	ld	s1,104(sp)
 76e:	7906                	ld	s2,96(sp)
 770:	69e6                	ld	s3,88(sp)
 772:	6a46                	ld	s4,80(sp)
 774:	6aa6                	ld	s5,72(sp)
 776:	6b06                	ld	s6,64(sp)
 778:	7be2                	ld	s7,56(sp)
 77a:	7c42                	ld	s8,48(sp)
 77c:	7ca2                	ld	s9,40(sp)
 77e:	7d02                	ld	s10,32(sp)
 780:	6de2                	ld	s11,24(sp)
 782:	6109                	addi	sp,sp,128
 784:	8082                	ret

0000000000000786 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 786:	715d                	addi	sp,sp,-80
 788:	ec06                	sd	ra,24(sp)
 78a:	e822                	sd	s0,16(sp)
 78c:	1000                	addi	s0,sp,32
 78e:	e010                	sd	a2,0(s0)
 790:	e414                	sd	a3,8(s0)
 792:	e818                	sd	a4,16(s0)
 794:	ec1c                	sd	a5,24(s0)
 796:	03043023          	sd	a6,32(s0)
 79a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a2:	8622                	mv	a2,s0
 7a4:	00000097          	auipc	ra,0x0
 7a8:	e04080e7          	jalr	-508(ra) # 5a8 <vprintf>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6161                	addi	sp,sp,80
 7b2:	8082                	ret

00000000000007b4 <printf>:

void
printf(const char *fmt, ...)
{
 7b4:	711d                	addi	sp,sp,-96
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	addi	s0,sp,32
 7bc:	e40c                	sd	a1,8(s0)
 7be:	e810                	sd	a2,16(s0)
 7c0:	ec14                	sd	a3,24(s0)
 7c2:	f018                	sd	a4,32(s0)
 7c4:	f41c                	sd	a5,40(s0)
 7c6:	03043823          	sd	a6,48(s0)
 7ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ce:	00840613          	addi	a2,s0,8
 7d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d6:	85aa                	mv	a1,a0
 7d8:	4505                	li	a0,1
 7da:	00000097          	auipc	ra,0x0
 7de:	dce080e7          	jalr	-562(ra) # 5a8 <vprintf>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6125                	addi	sp,sp,96
 7e8:	8082                	ret

00000000000007ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ea:	1141                	addi	sp,sp,-16
 7ec:	e422                	sd	s0,8(sp)
 7ee:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	00001797          	auipc	a5,0x1
 7f8:	80c7b783          	ld	a5,-2036(a5) # 1000 <freep>
 7fc:	a805                	j	82c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fe:	4618                	lw	a4,8(a2)
 800:	9db9                	addw	a1,a1,a4
 802:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	6398                	ld	a4,0(a5)
 808:	6318                	ld	a4,0(a4)
 80a:	fee53823          	sd	a4,-16(a0)
 80e:	a091                	j	852 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 810:	ff852703          	lw	a4,-8(a0)
 814:	9e39                	addw	a2,a2,a4
 816:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 818:	ff053703          	ld	a4,-16(a0)
 81c:	e398                	sd	a4,0(a5)
 81e:	a099                	j	864 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	6398                	ld	a4,0(a5)
 822:	00e7e463          	bltu	a5,a4,82a <free+0x40>
 826:	00e6ea63          	bltu	a3,a4,83a <free+0x50>
{
 82a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82c:	fed7fae3          	bgeu	a5,a3,820 <free+0x36>
 830:	6398                	ld	a4,0(a5)
 832:	00e6e463          	bltu	a3,a4,83a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	fee7eae3          	bltu	a5,a4,82a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 83a:	ff852583          	lw	a1,-8(a0)
 83e:	6390                	ld	a2,0(a5)
 840:	02059713          	slli	a4,a1,0x20
 844:	9301                	srli	a4,a4,0x20
 846:	0712                	slli	a4,a4,0x4
 848:	9736                	add	a4,a4,a3
 84a:	fae60ae3          	beq	a2,a4,7fe <free+0x14>
    bp->s.ptr = p->s.ptr;
 84e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 852:	4790                	lw	a2,8(a5)
 854:	02061713          	slli	a4,a2,0x20
 858:	9301                	srli	a4,a4,0x20
 85a:	0712                	slli	a4,a4,0x4
 85c:	973e                	add	a4,a4,a5
 85e:	fae689e3          	beq	a3,a4,810 <free+0x26>
  } else
    p->s.ptr = bp;
 862:	e394                	sd	a3,0(a5)
  freep = p;
 864:	00000717          	auipc	a4,0x0
 868:	78f73e23          	sd	a5,1948(a4) # 1000 <freep>
}
 86c:	6422                	ld	s0,8(sp)
 86e:	0141                	addi	sp,sp,16
 870:	8082                	ret

0000000000000872 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 872:	7139                	addi	sp,sp,-64
 874:	fc06                	sd	ra,56(sp)
 876:	f822                	sd	s0,48(sp)
 878:	f426                	sd	s1,40(sp)
 87a:	f04a                	sd	s2,32(sp)
 87c:	ec4e                	sd	s3,24(sp)
 87e:	e852                	sd	s4,16(sp)
 880:	e456                	sd	s5,8(sp)
 882:	e05a                	sd	s6,0(sp)
 884:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 886:	02051493          	slli	s1,a0,0x20
 88a:	9081                	srli	s1,s1,0x20
 88c:	04bd                	addi	s1,s1,15
 88e:	8091                	srli	s1,s1,0x4
 890:	0014899b          	addiw	s3,s1,1
 894:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 896:	00000517          	auipc	a0,0x0
 89a:	76a53503          	ld	a0,1898(a0) # 1000 <freep>
 89e:	c515                	beqz	a0,8ca <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a2:	4798                	lw	a4,8(a5)
 8a4:	02977f63          	bgeu	a4,s1,8e2 <malloc+0x70>
 8a8:	8a4e                	mv	s4,s3
 8aa:	0009871b          	sext.w	a4,s3
 8ae:	6685                	lui	a3,0x1
 8b0:	00d77363          	bgeu	a4,a3,8b6 <malloc+0x44>
 8b4:	6a05                	lui	s4,0x1
 8b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8be:	00000917          	auipc	s2,0x0
 8c2:	74290913          	addi	s2,s2,1858 # 1000 <freep>
  if(p == (char*)-1)
 8c6:	5afd                	li	s5,-1
 8c8:	a88d                	j	93a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8ca:	00000797          	auipc	a5,0x0
 8ce:	74678793          	addi	a5,a5,1862 # 1010 <base>
 8d2:	00000717          	auipc	a4,0x0
 8d6:	72f73723          	sd	a5,1838(a4) # 1000 <freep>
 8da:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8dc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e0:	b7e1                	j	8a8 <malloc+0x36>
      if(p->s.size == nunits)
 8e2:	02e48b63          	beq	s1,a4,918 <malloc+0xa6>
        p->s.size -= nunits;
 8e6:	4137073b          	subw	a4,a4,s3
 8ea:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ec:	1702                	slli	a4,a4,0x20
 8ee:	9301                	srli	a4,a4,0x20
 8f0:	0712                	slli	a4,a4,0x4
 8f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f8:	00000717          	auipc	a4,0x0
 8fc:	70a73423          	sd	a0,1800(a4) # 1000 <freep>
      return (void*)(p + 1);
 900:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 904:	70e2                	ld	ra,56(sp)
 906:	7442                	ld	s0,48(sp)
 908:	74a2                	ld	s1,40(sp)
 90a:	7902                	ld	s2,32(sp)
 90c:	69e2                	ld	s3,24(sp)
 90e:	6a42                	ld	s4,16(sp)
 910:	6aa2                	ld	s5,8(sp)
 912:	6b02                	ld	s6,0(sp)
 914:	6121                	addi	sp,sp,64
 916:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 918:	6398                	ld	a4,0(a5)
 91a:	e118                	sd	a4,0(a0)
 91c:	bff1                	j	8f8 <malloc+0x86>
  hp->s.size = nu;
 91e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 922:	0541                	addi	a0,a0,16
 924:	00000097          	auipc	ra,0x0
 928:	ec6080e7          	jalr	-314(ra) # 7ea <free>
  return freep;
 92c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 930:	d971                	beqz	a0,904 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 932:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 934:	4798                	lw	a4,8(a5)
 936:	fa9776e3          	bgeu	a4,s1,8e2 <malloc+0x70>
    if(p == freep)
 93a:	00093703          	ld	a4,0(s2)
 93e:	853e                	mv	a0,a5
 940:	fef719e3          	bne	a4,a5,932 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 944:	8552                	mv	a0,s4
 946:	00000097          	auipc	ra,0x0
 94a:	b7e080e7          	jalr	-1154(ra) # 4c4 <sbrk>
  if(p == (char*)-1)
 94e:	fd5518e3          	bne	a0,s5,91e <malloc+0xac>
        return 0;
 952:	4501                	li	a0,0
 954:	bf45                	j	904 <malloc+0x92>
