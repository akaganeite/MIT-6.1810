
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    // for (int i=0;i<argc;i++)
    // {
    //     write(1, argv[i], strlen(argv[i]));
    //     write(1, "\n", 1);
    // }
    if (argc != 2)
   8:	4789                	li	a5,2
   a:	04f50463          	beq	a0,a5,52 <main+0x52>
    {
        write(1, err, strlen(err));
   e:	00001517          	auipc	a0,0x1
  12:	81250513          	addi	a0,a0,-2030 # 820 <malloc+0xec>
  16:	00000097          	auipc	ra,0x0
  1a:	0ba080e7          	jalr	186(ra) # d0 <strlen>
  1e:	0005061b          	sext.w	a2,a0
  22:	00000597          	auipc	a1,0x0
  26:	7fe58593          	addi	a1,a1,2046 # 820 <malloc+0xec>
  2a:	4505                	li	a0,1
  2c:	00000097          	auipc	ra,0x0
  30:	2f2080e7          	jalr	754(ra) # 31e <write>
        write(1, "\n", 1);
  34:	4605                	li	a2,1
  36:	00001597          	auipc	a1,0x1
  3a:	80258593          	addi	a1,a1,-2046 # 838 <malloc+0x104>
  3e:	4505                	li	a0,1
  40:	00000097          	auipc	ra,0x0
  44:	2de080e7          	jalr	734(ra) # 31e <write>
        exit(0);
  48:	4501                	li	a0,0
  4a:	00000097          	auipc	ra,0x0
  4e:	2b4080e7          	jalr	692(ra) # 2fe <exit>
    }
    int len = atoi(argv[1]);
  52:	6588                	ld	a0,8(a1)
  54:	00000097          	auipc	ra,0x0
  58:	1aa080e7          	jalr	426(ra) # 1fe <atoi>
    sleep(len);
  5c:	00000097          	auipc	ra,0x0
  60:	332080e7          	jalr	818(ra) # 38e <sleep>
    exit(0);
  64:	4501                	li	a0,0
  66:	00000097          	auipc	ra,0x0
  6a:	298080e7          	jalr	664(ra) # 2fe <exit>

000000000000006e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  6e:	1141                	addi	sp,sp,-16
  70:	e406                	sd	ra,8(sp)
  72:	e022                	sd	s0,0(sp)
  74:	0800                	addi	s0,sp,16
  extern int main();
  main();
  76:	00000097          	auipc	ra,0x0
  7a:	f8a080e7          	jalr	-118(ra) # 0 <main>
  exit(0);
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	27e080e7          	jalr	638(ra) # 2fe <exit>

0000000000000088 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e422                	sd	s0,8(sp)
  8c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8e:	87aa                	mv	a5,a0
  90:	0585                	addi	a1,a1,1
  92:	0785                	addi	a5,a5,1
  94:	fff5c703          	lbu	a4,-1(a1)
  98:	fee78fa3          	sb	a4,-1(a5)
  9c:	fb75                	bnez	a4,90 <strcpy+0x8>
    ;
  return os;
}
  9e:	6422                	ld	s0,8(sp)
  a0:	0141                	addi	sp,sp,16
  a2:	8082                	ret

00000000000000a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e422                	sd	s0,8(sp)
  a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  aa:	00054783          	lbu	a5,0(a0)
  ae:	cb91                	beqz	a5,c2 <strcmp+0x1e>
  b0:	0005c703          	lbu	a4,0(a1)
  b4:	00f71763          	bne	a4,a5,c2 <strcmp+0x1e>
    p++, q++;
  b8:	0505                	addi	a0,a0,1
  ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	fbe5                	bnez	a5,b0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c2:	0005c503          	lbu	a0,0(a1)
}
  c6:	40a7853b          	subw	a0,a5,a0
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strlen>:

uint
strlen(const char *s)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d6:	00054783          	lbu	a5,0(a0)
  da:	cf91                	beqz	a5,f6 <strlen+0x26>
  dc:	0505                	addi	a0,a0,1
  de:	87aa                	mv	a5,a0
  e0:	4685                	li	a3,1
  e2:	9e89                	subw	a3,a3,a0
  e4:	00f6853b          	addw	a0,a3,a5
  e8:	0785                	addi	a5,a5,1
  ea:	fff7c703          	lbu	a4,-1(a5)
  ee:	fb7d                	bnez	a4,e4 <strlen+0x14>
    ;
  return n;
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret
  for(n = 0; s[n]; n++)
  f6:	4501                	li	a0,0
  f8:	bfe5                	j	f0 <strlen+0x20>

00000000000000fa <memset>:

void*
memset(void *dst, int c, uint n)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 100:	ce09                	beqz	a2,11a <memset+0x20>
 102:	87aa                	mv	a5,a0
 104:	fff6071b          	addiw	a4,a2,-1
 108:	1702                	slli	a4,a4,0x20
 10a:	9301                	srli	a4,a4,0x20
 10c:	0705                	addi	a4,a4,1
 10e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 110:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 114:	0785                	addi	a5,a5,1
 116:	fee79de3          	bne	a5,a4,110 <memset+0x16>
  }
  return dst;
}
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	1141                	addi	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	addi	s0,sp,16
  for(; *s; s++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cb99                	beqz	a5,140 <strchr+0x20>
    if(*s == c)
 12c:	00f58763          	beq	a1,a5,13a <strchr+0x1a>
  for(; *s; s++)
 130:	0505                	addi	a0,a0,1
 132:	00054783          	lbu	a5,0(a0)
 136:	fbfd                	bnez	a5,12c <strchr+0xc>
      return (char*)s;
  return 0;
 138:	4501                	li	a0,0
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret
  return 0;
 140:	4501                	li	a0,0
 142:	bfe5                	j	13a <strchr+0x1a>

0000000000000144 <gets>:

char*
gets(char *buf, int max)
{
 144:	711d                	addi	sp,sp,-96
 146:	ec86                	sd	ra,88(sp)
 148:	e8a2                	sd	s0,80(sp)
 14a:	e4a6                	sd	s1,72(sp)
 14c:	e0ca                	sd	s2,64(sp)
 14e:	fc4e                	sd	s3,56(sp)
 150:	f852                	sd	s4,48(sp)
 152:	f456                	sd	s5,40(sp)
 154:	f05a                	sd	s6,32(sp)
 156:	ec5e                	sd	s7,24(sp)
 158:	1080                	addi	s0,sp,96
 15a:	8baa                	mv	s7,a0
 15c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15e:	892a                	mv	s2,a0
 160:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 162:	4aa9                	li	s5,10
 164:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 166:	89a6                	mv	s3,s1
 168:	2485                	addiw	s1,s1,1
 16a:	0344d863          	bge	s1,s4,19a <gets+0x56>
    cc = read(0, &c, 1);
 16e:	4605                	li	a2,1
 170:	faf40593          	addi	a1,s0,-81
 174:	4501                	li	a0,0
 176:	00000097          	auipc	ra,0x0
 17a:	1a0080e7          	jalr	416(ra) # 316 <read>
    if(cc < 1)
 17e:	00a05e63          	blez	a0,19a <gets+0x56>
    buf[i++] = c;
 182:	faf44783          	lbu	a5,-81(s0)
 186:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 18a:	01578763          	beq	a5,s5,198 <gets+0x54>
 18e:	0905                	addi	s2,s2,1
 190:	fd679be3          	bne	a5,s6,166 <gets+0x22>
  for(i=0; i+1 < max; ){
 194:	89a6                	mv	s3,s1
 196:	a011                	j	19a <gets+0x56>
 198:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 19a:	99de                	add	s3,s3,s7
 19c:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a0:	855e                	mv	a0,s7
 1a2:	60e6                	ld	ra,88(sp)
 1a4:	6446                	ld	s0,80(sp)
 1a6:	64a6                	ld	s1,72(sp)
 1a8:	6906                	ld	s2,64(sp)
 1aa:	79e2                	ld	s3,56(sp)
 1ac:	7a42                	ld	s4,48(sp)
 1ae:	7aa2                	ld	s5,40(sp)
 1b0:	7b02                	ld	s6,32(sp)
 1b2:	6be2                	ld	s7,24(sp)
 1b4:	6125                	addi	sp,sp,96
 1b6:	8082                	ret

00000000000001b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b8:	1101                	addi	sp,sp,-32
 1ba:	ec06                	sd	ra,24(sp)
 1bc:	e822                	sd	s0,16(sp)
 1be:	e426                	sd	s1,8(sp)
 1c0:	e04a                	sd	s2,0(sp)
 1c2:	1000                	addi	s0,sp,32
 1c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c6:	4581                	li	a1,0
 1c8:	00000097          	auipc	ra,0x0
 1cc:	176080e7          	jalr	374(ra) # 33e <open>
  if(fd < 0)
 1d0:	02054563          	bltz	a0,1fa <stat+0x42>
 1d4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d6:	85ca                	mv	a1,s2
 1d8:	00000097          	auipc	ra,0x0
 1dc:	17e080e7          	jalr	382(ra) # 356 <fstat>
 1e0:	892a                	mv	s2,a0
  close(fd);
 1e2:	8526                	mv	a0,s1
 1e4:	00000097          	auipc	ra,0x0
 1e8:	142080e7          	jalr	322(ra) # 326 <close>
  return r;
}
 1ec:	854a                	mv	a0,s2
 1ee:	60e2                	ld	ra,24(sp)
 1f0:	6442                	ld	s0,16(sp)
 1f2:	64a2                	ld	s1,8(sp)
 1f4:	6902                	ld	s2,0(sp)
 1f6:	6105                	addi	sp,sp,32
 1f8:	8082                	ret
    return -1;
 1fa:	597d                	li	s2,-1
 1fc:	bfc5                	j	1ec <stat+0x34>

00000000000001fe <atoi>:

int
atoi(const char *s)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 204:	00054603          	lbu	a2,0(a0)
 208:	fd06079b          	addiw	a5,a2,-48
 20c:	0ff7f793          	andi	a5,a5,255
 210:	4725                	li	a4,9
 212:	02f76963          	bltu	a4,a5,244 <atoi+0x46>
 216:	86aa                	mv	a3,a0
  n = 0;
 218:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 21a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 21c:	0685                	addi	a3,a3,1
 21e:	0025179b          	slliw	a5,a0,0x2
 222:	9fa9                	addw	a5,a5,a0
 224:	0017979b          	slliw	a5,a5,0x1
 228:	9fb1                	addw	a5,a5,a2
 22a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22e:	0006c603          	lbu	a2,0(a3)
 232:	fd06071b          	addiw	a4,a2,-48
 236:	0ff77713          	andi	a4,a4,255
 23a:	fee5f1e3          	bgeu	a1,a4,21c <atoi+0x1e>
  return n;
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret
  n = 0;
 244:	4501                	li	a0,0
 246:	bfe5                	j	23e <atoi+0x40>

0000000000000248 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24e:	02b57663          	bgeu	a0,a1,27a <memmove+0x32>
    while(n-- > 0)
 252:	02c05163          	blez	a2,274 <memmove+0x2c>
 256:	fff6079b          	addiw	a5,a2,-1
 25a:	1782                	slli	a5,a5,0x20
 25c:	9381                	srli	a5,a5,0x20
 25e:	0785                	addi	a5,a5,1
 260:	97aa                	add	a5,a5,a0
  dst = vdst;
 262:	872a                	mv	a4,a0
      *dst++ = *src++;
 264:	0585                	addi	a1,a1,1
 266:	0705                	addi	a4,a4,1
 268:	fff5c683          	lbu	a3,-1(a1)
 26c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 270:	fee79ae3          	bne	a5,a4,264 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
    dst += n;
 27a:	00c50733          	add	a4,a0,a2
    src += n;
 27e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 280:	fec05ae3          	blez	a2,274 <memmove+0x2c>
 284:	fff6079b          	addiw	a5,a2,-1
 288:	1782                	slli	a5,a5,0x20
 28a:	9381                	srli	a5,a5,0x20
 28c:	fff7c793          	not	a5,a5
 290:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 292:	15fd                	addi	a1,a1,-1
 294:	177d                	addi	a4,a4,-1
 296:	0005c683          	lbu	a3,0(a1)
 29a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 29e:	fee79ae3          	bne	a5,a4,292 <memmove+0x4a>
 2a2:	bfc9                	j	274 <memmove+0x2c>

00000000000002a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2aa:	ca05                	beqz	a2,2da <memcmp+0x36>
 2ac:	fff6069b          	addiw	a3,a2,-1
 2b0:	1682                	slli	a3,a3,0x20
 2b2:	9281                	srli	a3,a3,0x20
 2b4:	0685                	addi	a3,a3,1
 2b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	0005c703          	lbu	a4,0(a1)
 2c0:	00e79863          	bne	a5,a4,2d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c4:	0505                	addi	a0,a0,1
    p2++;
 2c6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c8:	fed518e3          	bne	a0,a3,2b8 <memcmp+0x14>
  }
  return 0;
 2cc:	4501                	li	a0,0
 2ce:	a019                	j	2d4 <memcmp+0x30>
      return *p1 - *p2;
 2d0:	40e7853b          	subw	a0,a5,a4
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  return 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <memcmp+0x30>

00000000000002de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e6:	00000097          	auipc	ra,0x0
 2ea:	f62080e7          	jalr	-158(ra) # 248 <memmove>
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f6:	4885                	li	a7,1
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fe:	4889                	li	a7,2
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <wait>:
.global wait
wait:
 li a7, SYS_wait
 306:	488d                	li	a7,3
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30e:	4891                	li	a7,4
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <read>:
.global read
read:
 li a7, SYS_read
 316:	4895                	li	a7,5
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <write>:
.global write
write:
 li a7, SYS_write
 31e:	48c1                	li	a7,16
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <close>:
.global close
close:
 li a7, SYS_close
 326:	48d5                	li	a7,21
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <kill>:
.global kill
kill:
 li a7, SYS_kill
 32e:	4899                	li	a7,6
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <exec>:
.global exec
exec:
 li a7, SYS_exec
 336:	489d                	li	a7,7
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <open>:
.global open
open:
 li a7, SYS_open
 33e:	48bd                	li	a7,15
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 346:	48c5                	li	a7,17
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34e:	48c9                	li	a7,18
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 356:	48a1                	li	a7,8
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <link>:
.global link
link:
 li a7, SYS_link
 35e:	48cd                	li	a7,19
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 366:	48d1                	li	a7,20
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36e:	48a5                	li	a7,9
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <dup>:
.global dup
dup:
 li a7, SYS_dup
 376:	48a9                	li	a7,10
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37e:	48ad                	li	a7,11
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 386:	48b1                	li	a7,12
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38e:	48b5                	li	a7,13
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 396:	48b9                	li	a7,14
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39e:	1101                	addi	sp,sp,-32
 3a0:	ec06                	sd	ra,24(sp)
 3a2:	e822                	sd	s0,16(sp)
 3a4:	1000                	addi	s0,sp,32
 3a6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3aa:	4605                	li	a2,1
 3ac:	fef40593          	addi	a1,s0,-17
 3b0:	00000097          	auipc	ra,0x0
 3b4:	f6e080e7          	jalr	-146(ra) # 31e <write>
}
 3b8:	60e2                	ld	ra,24(sp)
 3ba:	6442                	ld	s0,16(sp)
 3bc:	6105                	addi	sp,sp,32
 3be:	8082                	ret

00000000000003c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c0:	7139                	addi	sp,sp,-64
 3c2:	fc06                	sd	ra,56(sp)
 3c4:	f822                	sd	s0,48(sp)
 3c6:	f426                	sd	s1,40(sp)
 3c8:	f04a                	sd	s2,32(sp)
 3ca:	ec4e                	sd	s3,24(sp)
 3cc:	0080                	addi	s0,sp,64
 3ce:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d0:	c299                	beqz	a3,3d6 <printint+0x16>
 3d2:	0805c863          	bltz	a1,462 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3d6:	2581                	sext.w	a1,a1
  neg = 0;
 3d8:	4881                	li	a7,0
 3da:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3de:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3e0:	2601                	sext.w	a2,a2
 3e2:	00000517          	auipc	a0,0x0
 3e6:	46650513          	addi	a0,a0,1126 # 848 <digits>
 3ea:	883a                	mv	a6,a4
 3ec:	2705                	addiw	a4,a4,1
 3ee:	02c5f7bb          	remuw	a5,a1,a2
 3f2:	1782                	slli	a5,a5,0x20
 3f4:	9381                	srli	a5,a5,0x20
 3f6:	97aa                	add	a5,a5,a0
 3f8:	0007c783          	lbu	a5,0(a5)
 3fc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 400:	0005879b          	sext.w	a5,a1
 404:	02c5d5bb          	divuw	a1,a1,a2
 408:	0685                	addi	a3,a3,1
 40a:	fec7f0e3          	bgeu	a5,a2,3ea <printint+0x2a>
  if(neg)
 40e:	00088b63          	beqz	a7,424 <printint+0x64>
    buf[i++] = '-';
 412:	fd040793          	addi	a5,s0,-48
 416:	973e                	add	a4,a4,a5
 418:	02d00793          	li	a5,45
 41c:	fef70823          	sb	a5,-16(a4)
 420:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 424:	02e05863          	blez	a4,454 <printint+0x94>
 428:	fc040793          	addi	a5,s0,-64
 42c:	00e78933          	add	s2,a5,a4
 430:	fff78993          	addi	s3,a5,-1
 434:	99ba                	add	s3,s3,a4
 436:	377d                	addiw	a4,a4,-1
 438:	1702                	slli	a4,a4,0x20
 43a:	9301                	srli	a4,a4,0x20
 43c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 440:	fff94583          	lbu	a1,-1(s2)
 444:	8526                	mv	a0,s1
 446:	00000097          	auipc	ra,0x0
 44a:	f58080e7          	jalr	-168(ra) # 39e <putc>
  while(--i >= 0)
 44e:	197d                	addi	s2,s2,-1
 450:	ff3918e3          	bne	s2,s3,440 <printint+0x80>
}
 454:	70e2                	ld	ra,56(sp)
 456:	7442                	ld	s0,48(sp)
 458:	74a2                	ld	s1,40(sp)
 45a:	7902                	ld	s2,32(sp)
 45c:	69e2                	ld	s3,24(sp)
 45e:	6121                	addi	sp,sp,64
 460:	8082                	ret
    x = -xx;
 462:	40b005bb          	negw	a1,a1
    neg = 1;
 466:	4885                	li	a7,1
    x = -xx;
 468:	bf8d                	j	3da <printint+0x1a>

000000000000046a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 46a:	7119                	addi	sp,sp,-128
 46c:	fc86                	sd	ra,120(sp)
 46e:	f8a2                	sd	s0,112(sp)
 470:	f4a6                	sd	s1,104(sp)
 472:	f0ca                	sd	s2,96(sp)
 474:	ecce                	sd	s3,88(sp)
 476:	e8d2                	sd	s4,80(sp)
 478:	e4d6                	sd	s5,72(sp)
 47a:	e0da                	sd	s6,64(sp)
 47c:	fc5e                	sd	s7,56(sp)
 47e:	f862                	sd	s8,48(sp)
 480:	f466                	sd	s9,40(sp)
 482:	f06a                	sd	s10,32(sp)
 484:	ec6e                	sd	s11,24(sp)
 486:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 488:	0005c903          	lbu	s2,0(a1)
 48c:	18090f63          	beqz	s2,62a <vprintf+0x1c0>
 490:	8aaa                	mv	s5,a0
 492:	8b32                	mv	s6,a2
 494:	00158493          	addi	s1,a1,1
  state = 0;
 498:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 49a:	02500a13          	li	s4,37
      if(c == 'd'){
 49e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4a2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4a6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4aa:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4ae:	00000b97          	auipc	s7,0x0
 4b2:	39ab8b93          	addi	s7,s7,922 # 848 <digits>
 4b6:	a839                	j	4d4 <vprintf+0x6a>
        putc(fd, c);
 4b8:	85ca                	mv	a1,s2
 4ba:	8556                	mv	a0,s5
 4bc:	00000097          	auipc	ra,0x0
 4c0:	ee2080e7          	jalr	-286(ra) # 39e <putc>
 4c4:	a019                	j	4ca <vprintf+0x60>
    } else if(state == '%'){
 4c6:	01498f63          	beq	s3,s4,4e4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4ca:	0485                	addi	s1,s1,1
 4cc:	fff4c903          	lbu	s2,-1(s1)
 4d0:	14090d63          	beqz	s2,62a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4d4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4d8:	fe0997e3          	bnez	s3,4c6 <vprintf+0x5c>
      if(c == '%'){
 4dc:	fd479ee3          	bne	a5,s4,4b8 <vprintf+0x4e>
        state = '%';
 4e0:	89be                	mv	s3,a5
 4e2:	b7e5                	j	4ca <vprintf+0x60>
      if(c == 'd'){
 4e4:	05878063          	beq	a5,s8,524 <vprintf+0xba>
      } else if(c == 'l') {
 4e8:	05978c63          	beq	a5,s9,540 <vprintf+0xd6>
      } else if(c == 'x') {
 4ec:	07a78863          	beq	a5,s10,55c <vprintf+0xf2>
      } else if(c == 'p') {
 4f0:	09b78463          	beq	a5,s11,578 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4f4:	07300713          	li	a4,115
 4f8:	0ce78663          	beq	a5,a4,5c4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4fc:	06300713          	li	a4,99
 500:	0ee78e63          	beq	a5,a4,5fc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 504:	11478863          	beq	a5,s4,614 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 508:	85d2                	mv	a1,s4
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	e92080e7          	jalr	-366(ra) # 39e <putc>
        putc(fd, c);
 514:	85ca                	mv	a1,s2
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	e86080e7          	jalr	-378(ra) # 39e <putc>
      }
      state = 0;
 520:	4981                	li	s3,0
 522:	b765                	j	4ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 524:	008b0913          	addi	s2,s6,8
 528:	4685                	li	a3,1
 52a:	4629                	li	a2,10
 52c:	000b2583          	lw	a1,0(s6)
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e8e080e7          	jalr	-370(ra) # 3c0 <printint>
 53a:	8b4a                	mv	s6,s2
      state = 0;
 53c:	4981                	li	s3,0
 53e:	b771                	j	4ca <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 540:	008b0913          	addi	s2,s6,8
 544:	4681                	li	a3,0
 546:	4629                	li	a2,10
 548:	000b2583          	lw	a1,0(s6)
 54c:	8556                	mv	a0,s5
 54e:	00000097          	auipc	ra,0x0
 552:	e72080e7          	jalr	-398(ra) # 3c0 <printint>
 556:	8b4a                	mv	s6,s2
      state = 0;
 558:	4981                	li	s3,0
 55a:	bf85                	j	4ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 55c:	008b0913          	addi	s2,s6,8
 560:	4681                	li	a3,0
 562:	4641                	li	a2,16
 564:	000b2583          	lw	a1,0(s6)
 568:	8556                	mv	a0,s5
 56a:	00000097          	auipc	ra,0x0
 56e:	e56080e7          	jalr	-426(ra) # 3c0 <printint>
 572:	8b4a                	mv	s6,s2
      state = 0;
 574:	4981                	li	s3,0
 576:	bf91                	j	4ca <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 578:	008b0793          	addi	a5,s6,8
 57c:	f8f43423          	sd	a5,-120(s0)
 580:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 584:	03000593          	li	a1,48
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	e14080e7          	jalr	-492(ra) # 39e <putc>
  putc(fd, 'x');
 592:	85ea                	mv	a1,s10
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	e08080e7          	jalr	-504(ra) # 39e <putc>
 59e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a0:	03c9d793          	srli	a5,s3,0x3c
 5a4:	97de                	add	a5,a5,s7
 5a6:	0007c583          	lbu	a1,0(a5)
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	df2080e7          	jalr	-526(ra) # 39e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5b4:	0992                	slli	s3,s3,0x4
 5b6:	397d                	addiw	s2,s2,-1
 5b8:	fe0914e3          	bnez	s2,5a0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5bc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b721                	j	4ca <vprintf+0x60>
        s = va_arg(ap, char*);
 5c4:	008b0993          	addi	s3,s6,8
 5c8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5cc:	02090163          	beqz	s2,5ee <vprintf+0x184>
        while(*s != 0){
 5d0:	00094583          	lbu	a1,0(s2)
 5d4:	c9a1                	beqz	a1,624 <vprintf+0x1ba>
          putc(fd, *s);
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	dc6080e7          	jalr	-570(ra) # 39e <putc>
          s++;
 5e0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5e2:	00094583          	lbu	a1,0(s2)
 5e6:	f9e5                	bnez	a1,5d6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5e8:	8b4e                	mv	s6,s3
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	bdf9                	j	4ca <vprintf+0x60>
          s = "(null)";
 5ee:	00000917          	auipc	s2,0x0
 5f2:	25290913          	addi	s2,s2,594 # 840 <malloc+0x10c>
        while(*s != 0){
 5f6:	02800593          	li	a1,40
 5fa:	bff1                	j	5d6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5fc:	008b0913          	addi	s2,s6,8
 600:	000b4583          	lbu	a1,0(s6)
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	d98080e7          	jalr	-616(ra) # 39e <putc>
 60e:	8b4a                	mv	s6,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	bd65                	j	4ca <vprintf+0x60>
        putc(fd, c);
 614:	85d2                	mv	a1,s4
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	d86080e7          	jalr	-634(ra) # 39e <putc>
      state = 0;
 620:	4981                	li	s3,0
 622:	b565                	j	4ca <vprintf+0x60>
        s = va_arg(ap, char*);
 624:	8b4e                	mv	s6,s3
      state = 0;
 626:	4981                	li	s3,0
 628:	b54d                	j	4ca <vprintf+0x60>
    }
  }
}
 62a:	70e6                	ld	ra,120(sp)
 62c:	7446                	ld	s0,112(sp)
 62e:	74a6                	ld	s1,104(sp)
 630:	7906                	ld	s2,96(sp)
 632:	69e6                	ld	s3,88(sp)
 634:	6a46                	ld	s4,80(sp)
 636:	6aa6                	ld	s5,72(sp)
 638:	6b06                	ld	s6,64(sp)
 63a:	7be2                	ld	s7,56(sp)
 63c:	7c42                	ld	s8,48(sp)
 63e:	7ca2                	ld	s9,40(sp)
 640:	7d02                	ld	s10,32(sp)
 642:	6de2                	ld	s11,24(sp)
 644:	6109                	addi	sp,sp,128
 646:	8082                	ret

0000000000000648 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 648:	715d                	addi	sp,sp,-80
 64a:	ec06                	sd	ra,24(sp)
 64c:	e822                	sd	s0,16(sp)
 64e:	1000                	addi	s0,sp,32
 650:	e010                	sd	a2,0(s0)
 652:	e414                	sd	a3,8(s0)
 654:	e818                	sd	a4,16(s0)
 656:	ec1c                	sd	a5,24(s0)
 658:	03043023          	sd	a6,32(s0)
 65c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 660:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 664:	8622                	mv	a2,s0
 666:	00000097          	auipc	ra,0x0
 66a:	e04080e7          	jalr	-508(ra) # 46a <vprintf>
}
 66e:	60e2                	ld	ra,24(sp)
 670:	6442                	ld	s0,16(sp)
 672:	6161                	addi	sp,sp,80
 674:	8082                	ret

0000000000000676 <printf>:

void
printf(const char *fmt, ...)
{
 676:	711d                	addi	sp,sp,-96
 678:	ec06                	sd	ra,24(sp)
 67a:	e822                	sd	s0,16(sp)
 67c:	1000                	addi	s0,sp,32
 67e:	e40c                	sd	a1,8(s0)
 680:	e810                	sd	a2,16(s0)
 682:	ec14                	sd	a3,24(s0)
 684:	f018                	sd	a4,32(s0)
 686:	f41c                	sd	a5,40(s0)
 688:	03043823          	sd	a6,48(s0)
 68c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 690:	00840613          	addi	a2,s0,8
 694:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 698:	85aa                	mv	a1,a0
 69a:	4505                	li	a0,1
 69c:	00000097          	auipc	ra,0x0
 6a0:	dce080e7          	jalr	-562(ra) # 46a <vprintf>
}
 6a4:	60e2                	ld	ra,24(sp)
 6a6:	6442                	ld	s0,16(sp)
 6a8:	6125                	addi	sp,sp,96
 6aa:	8082                	ret

00000000000006ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ac:	1141                	addi	sp,sp,-16
 6ae:	e422                	sd	s0,8(sp)
 6b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b6:	00001797          	auipc	a5,0x1
 6ba:	94a7b783          	ld	a5,-1718(a5) # 1000 <freep>
 6be:	a805                	j	6ee <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6c0:	4618                	lw	a4,8(a2)
 6c2:	9db9                	addw	a1,a1,a4
 6c4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c8:	6398                	ld	a4,0(a5)
 6ca:	6318                	ld	a4,0(a4)
 6cc:	fee53823          	sd	a4,-16(a0)
 6d0:	a091                	j	714 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6d2:	ff852703          	lw	a4,-8(a0)
 6d6:	9e39                	addw	a2,a2,a4
 6d8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6da:	ff053703          	ld	a4,-16(a0)
 6de:	e398                	sd	a4,0(a5)
 6e0:	a099                	j	726 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e2:	6398                	ld	a4,0(a5)
 6e4:	00e7e463          	bltu	a5,a4,6ec <free+0x40>
 6e8:	00e6ea63          	bltu	a3,a4,6fc <free+0x50>
{
 6ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ee:	fed7fae3          	bgeu	a5,a3,6e2 <free+0x36>
 6f2:	6398                	ld	a4,0(a5)
 6f4:	00e6e463          	bltu	a3,a4,6fc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f8:	fee7eae3          	bltu	a5,a4,6ec <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6fc:	ff852583          	lw	a1,-8(a0)
 700:	6390                	ld	a2,0(a5)
 702:	02059713          	slli	a4,a1,0x20
 706:	9301                	srli	a4,a4,0x20
 708:	0712                	slli	a4,a4,0x4
 70a:	9736                	add	a4,a4,a3
 70c:	fae60ae3          	beq	a2,a4,6c0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 710:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 714:	4790                	lw	a2,8(a5)
 716:	02061713          	slli	a4,a2,0x20
 71a:	9301                	srli	a4,a4,0x20
 71c:	0712                	slli	a4,a4,0x4
 71e:	973e                	add	a4,a4,a5
 720:	fae689e3          	beq	a3,a4,6d2 <free+0x26>
  } else
    p->s.ptr = bp;
 724:	e394                	sd	a3,0(a5)
  freep = p;
 726:	00001717          	auipc	a4,0x1
 72a:	8cf73d23          	sd	a5,-1830(a4) # 1000 <freep>
}
 72e:	6422                	ld	s0,8(sp)
 730:	0141                	addi	sp,sp,16
 732:	8082                	ret

0000000000000734 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 734:	7139                	addi	sp,sp,-64
 736:	fc06                	sd	ra,56(sp)
 738:	f822                	sd	s0,48(sp)
 73a:	f426                	sd	s1,40(sp)
 73c:	f04a                	sd	s2,32(sp)
 73e:	ec4e                	sd	s3,24(sp)
 740:	e852                	sd	s4,16(sp)
 742:	e456                	sd	s5,8(sp)
 744:	e05a                	sd	s6,0(sp)
 746:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 748:	02051493          	slli	s1,a0,0x20
 74c:	9081                	srli	s1,s1,0x20
 74e:	04bd                	addi	s1,s1,15
 750:	8091                	srli	s1,s1,0x4
 752:	0014899b          	addiw	s3,s1,1
 756:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 758:	00001517          	auipc	a0,0x1
 75c:	8a853503          	ld	a0,-1880(a0) # 1000 <freep>
 760:	c515                	beqz	a0,78c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 762:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 764:	4798                	lw	a4,8(a5)
 766:	02977f63          	bgeu	a4,s1,7a4 <malloc+0x70>
 76a:	8a4e                	mv	s4,s3
 76c:	0009871b          	sext.w	a4,s3
 770:	6685                	lui	a3,0x1
 772:	00d77363          	bgeu	a4,a3,778 <malloc+0x44>
 776:	6a05                	lui	s4,0x1
 778:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 77c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 780:	00001917          	auipc	s2,0x1
 784:	88090913          	addi	s2,s2,-1920 # 1000 <freep>
  if(p == (char*)-1)
 788:	5afd                	li	s5,-1
 78a:	a88d                	j	7fc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 78c:	00001797          	auipc	a5,0x1
 790:	88478793          	addi	a5,a5,-1916 # 1010 <base>
 794:	00001717          	auipc	a4,0x1
 798:	86f73623          	sd	a5,-1940(a4) # 1000 <freep>
 79c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 79e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7a2:	b7e1                	j	76a <malloc+0x36>
      if(p->s.size == nunits)
 7a4:	02e48b63          	beq	s1,a4,7da <malloc+0xa6>
        p->s.size -= nunits;
 7a8:	4137073b          	subw	a4,a4,s3
 7ac:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ae:	1702                	slli	a4,a4,0x20
 7b0:	9301                	srli	a4,a4,0x20
 7b2:	0712                	slli	a4,a4,0x4
 7b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ba:	00001717          	auipc	a4,0x1
 7be:	84a73323          	sd	a0,-1978(a4) # 1000 <freep>
      return (void*)(p + 1);
 7c2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7c6:	70e2                	ld	ra,56(sp)
 7c8:	7442                	ld	s0,48(sp)
 7ca:	74a2                	ld	s1,40(sp)
 7cc:	7902                	ld	s2,32(sp)
 7ce:	69e2                	ld	s3,24(sp)
 7d0:	6a42                	ld	s4,16(sp)
 7d2:	6aa2                	ld	s5,8(sp)
 7d4:	6b02                	ld	s6,0(sp)
 7d6:	6121                	addi	sp,sp,64
 7d8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7da:	6398                	ld	a4,0(a5)
 7dc:	e118                	sd	a4,0(a0)
 7de:	bff1                	j	7ba <malloc+0x86>
  hp->s.size = nu;
 7e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7e4:	0541                	addi	a0,a0,16
 7e6:	00000097          	auipc	ra,0x0
 7ea:	ec6080e7          	jalr	-314(ra) # 6ac <free>
  return freep;
 7ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7f2:	d971                	beqz	a0,7c6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f6:	4798                	lw	a4,8(a5)
 7f8:	fa9776e3          	bgeu	a4,s1,7a4 <malloc+0x70>
    if(p == freep)
 7fc:	00093703          	ld	a4,0(s2)
 800:	853e                	mv	a0,a5
 802:	fef719e3          	bne	a4,a5,7f4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 806:	8552                	mv	a0,s4
 808:	00000097          	auipc	ra,0x0
 80c:	b7e080e7          	jalr	-1154(ra) # 386 <sbrk>
  if(p == (char*)-1)
 810:	fd5518e3          	bne	a0,s5,7e0 <malloc+0xac>
        return 0;
 814:	4501                	li	a0,0
 816:	bf45                	j	7c6 <malloc+0x92>
