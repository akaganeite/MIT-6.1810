
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2c0080e7          	jalr	704(ra) # 2c8 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	2ba080e7          	jalr	698(ra) # 2d0 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	340080e7          	jalr	832(ra) # 360 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	294080e7          	jalr	660(ra) # 2d0 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
    ;
  return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
    p++, q++;
  74:	0505                	addi	a0,a0,1
  76:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	addi	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	4685                	li	a3,1
  9e:	9e89                	subw	a3,a3,a0
  a0:	00f6853b          	addw	a0,a3,a5
  a4:	0785                	addi	a5,a5,1
  a6:	fff7c703          	lbu	a4,-1(a5)
  aa:	fb7d                	bnez	a4,a0 <strlen+0x14>
    ;
  return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret
  for(n = 0; s[n]; n++)
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  bc:	ce09                	beqz	a2,d6 <memset+0x20>
  be:	87aa                	mv	a5,a0
  c0:	fff6071b          	addiw	a4,a2,-1
  c4:	1702                	slli	a4,a4,0x20
  c6:	9301                	srli	a4,a4,0x20
  c8:	0705                	addi	a4,a4,1
  ca:	972a                	add	a4,a4,a0
    cdst[i] = c;
  cc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  d0:	0785                	addi	a5,a5,1
  d2:	fee79de3          	bne	a5,a4,cc <memset+0x16>
  }
  return dst;
}
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strchr>:

char*
strchr(const char *s, char c)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e422                	sd	s0,8(sp)
  e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	cb99                	beqz	a5,fc <strchr+0x20>
    if(*s == c)
  e8:	00f58763          	beq	a1,a5,f6 <strchr+0x1a>
  for(; *s; s++)
  ec:	0505                	addi	a0,a0,1
  ee:	00054783          	lbu	a5,0(a0)
  f2:	fbfd                	bnez	a5,e8 <strchr+0xc>
      return (char*)s;
  return 0;
  f4:	4501                	li	a0,0
}
  f6:	6422                	ld	s0,8(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret
  return 0;
  fc:	4501                	li	a0,0
  fe:	bfe5                	j	f6 <strchr+0x1a>

0000000000000100 <gets>:

char*
gets(char *buf, int max)
{
 100:	711d                	addi	sp,sp,-96
 102:	ec86                	sd	ra,88(sp)
 104:	e8a2                	sd	s0,80(sp)
 106:	e4a6                	sd	s1,72(sp)
 108:	e0ca                	sd	s2,64(sp)
 10a:	fc4e                	sd	s3,56(sp)
 10c:	f852                	sd	s4,48(sp)
 10e:	f456                	sd	s5,40(sp)
 110:	f05a                	sd	s6,32(sp)
 112:	ec5e                	sd	s7,24(sp)
 114:	1080                	addi	s0,sp,96
 116:	8baa                	mv	s7,a0
 118:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11a:	892a                	mv	s2,a0
 11c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11e:	4aa9                	li	s5,10
 120:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 122:	89a6                	mv	s3,s1
 124:	2485                	addiw	s1,s1,1
 126:	0344d863          	bge	s1,s4,156 <gets+0x56>
    cc = read(0, &c, 1);
 12a:	4605                	li	a2,1
 12c:	faf40593          	addi	a1,s0,-81
 130:	4501                	li	a0,0
 132:	00000097          	auipc	ra,0x0
 136:	1b6080e7          	jalr	438(ra) # 2e8 <read>
    if(cc < 1)
 13a:	00a05e63          	blez	a0,156 <gets+0x56>
    buf[i++] = c;
 13e:	faf44783          	lbu	a5,-81(s0)
 142:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 146:	01578763          	beq	a5,s5,154 <gets+0x54>
 14a:	0905                	addi	s2,s2,1
 14c:	fd679be3          	bne	a5,s6,122 <gets+0x22>
  for(i=0; i+1 < max; ){
 150:	89a6                	mv	s3,s1
 152:	a011                	j	156 <gets+0x56>
 154:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 156:	99de                	add	s3,s3,s7
 158:	00098023          	sb	zero,0(s3)
  return buf;
}
 15c:	855e                	mv	a0,s7
 15e:	60e6                	ld	ra,88(sp)
 160:	6446                	ld	s0,80(sp)
 162:	64a6                	ld	s1,72(sp)
 164:	6906                	ld	s2,64(sp)
 166:	79e2                	ld	s3,56(sp)
 168:	7a42                	ld	s4,48(sp)
 16a:	7aa2                	ld	s5,40(sp)
 16c:	7b02                	ld	s6,32(sp)
 16e:	6be2                	ld	s7,24(sp)
 170:	6125                	addi	sp,sp,96
 172:	8082                	ret

0000000000000174 <stat>:

int
stat(const char *n, struct stat *st)
{
 174:	1101                	addi	sp,sp,-32
 176:	ec06                	sd	ra,24(sp)
 178:	e822                	sd	s0,16(sp)
 17a:	e426                	sd	s1,8(sp)
 17c:	e04a                	sd	s2,0(sp)
 17e:	1000                	addi	s0,sp,32
 180:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 182:	4581                	li	a1,0
 184:	00000097          	auipc	ra,0x0
 188:	18c080e7          	jalr	396(ra) # 310 <open>
  if(fd < 0)
 18c:	02054563          	bltz	a0,1b6 <stat+0x42>
 190:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 192:	85ca                	mv	a1,s2
 194:	00000097          	auipc	ra,0x0
 198:	194080e7          	jalr	404(ra) # 328 <fstat>
 19c:	892a                	mv	s2,a0
  close(fd);
 19e:	8526                	mv	a0,s1
 1a0:	00000097          	auipc	ra,0x0
 1a4:	158080e7          	jalr	344(ra) # 2f8 <close>
  return r;
}
 1a8:	854a                	mv	a0,s2
 1aa:	60e2                	ld	ra,24(sp)
 1ac:	6442                	ld	s0,16(sp)
 1ae:	64a2                	ld	s1,8(sp)
 1b0:	6902                	ld	s2,0(sp)
 1b2:	6105                	addi	sp,sp,32
 1b4:	8082                	ret
    return -1;
 1b6:	597d                	li	s2,-1
 1b8:	bfc5                	j	1a8 <stat+0x34>

00000000000001ba <atoi>:

int
atoi(const char *s)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c0:	00054603          	lbu	a2,0(a0)
 1c4:	fd06079b          	addiw	a5,a2,-48
 1c8:	0ff7f793          	andi	a5,a5,255
 1cc:	4725                	li	a4,9
 1ce:	02f76963          	bltu	a4,a5,200 <atoi+0x46>
 1d2:	86aa                	mv	a3,a0
  n = 0;
 1d4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1d6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1d8:	0685                	addi	a3,a3,1
 1da:	0025179b          	slliw	a5,a0,0x2
 1de:	9fa9                	addw	a5,a5,a0
 1e0:	0017979b          	slliw	a5,a5,0x1
 1e4:	9fb1                	addw	a5,a5,a2
 1e6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ea:	0006c603          	lbu	a2,0(a3)
 1ee:	fd06071b          	addiw	a4,a2,-48
 1f2:	0ff77713          	andi	a4,a4,255
 1f6:	fee5f1e3          	bgeu	a1,a4,1d8 <atoi+0x1e>
  return n;
}
 1fa:	6422                	ld	s0,8(sp)
 1fc:	0141                	addi	sp,sp,16
 1fe:	8082                	ret
  n = 0;
 200:	4501                	li	a0,0
 202:	bfe5                	j	1fa <atoi+0x40>

0000000000000204 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20a:	02b57663          	bgeu	a0,a1,236 <memmove+0x32>
    while(n-- > 0)
 20e:	02c05163          	blez	a2,230 <memmove+0x2c>
 212:	fff6079b          	addiw	a5,a2,-1
 216:	1782                	slli	a5,a5,0x20
 218:	9381                	srli	a5,a5,0x20
 21a:	0785                	addi	a5,a5,1
 21c:	97aa                	add	a5,a5,a0
  dst = vdst;
 21e:	872a                	mv	a4,a0
      *dst++ = *src++;
 220:	0585                	addi	a1,a1,1
 222:	0705                	addi	a4,a4,1
 224:	fff5c683          	lbu	a3,-1(a1)
 228:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 230:	6422                	ld	s0,8(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
    dst += n;
 236:	00c50733          	add	a4,a0,a2
    src += n;
 23a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23c:	fec05ae3          	blez	a2,230 <memmove+0x2c>
 240:	fff6079b          	addiw	a5,a2,-1
 244:	1782                	slli	a5,a5,0x20
 246:	9381                	srli	a5,a5,0x20
 248:	fff7c793          	not	a5,a5
 24c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 24e:	15fd                	addi	a1,a1,-1
 250:	177d                	addi	a4,a4,-1
 252:	0005c683          	lbu	a3,0(a1)
 256:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25a:	fee79ae3          	bne	a5,a4,24e <memmove+0x4a>
 25e:	bfc9                	j	230 <memmove+0x2c>

0000000000000260 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 260:	1141                	addi	sp,sp,-16
 262:	e422                	sd	s0,8(sp)
 264:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 266:	ca05                	beqz	a2,296 <memcmp+0x36>
 268:	fff6069b          	addiw	a3,a2,-1
 26c:	1682                	slli	a3,a3,0x20
 26e:	9281                	srli	a3,a3,0x20
 270:	0685                	addi	a3,a3,1
 272:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 274:	00054783          	lbu	a5,0(a0)
 278:	0005c703          	lbu	a4,0(a1)
 27c:	00e79863          	bne	a5,a4,28c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 280:	0505                	addi	a0,a0,1
    p2++;
 282:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 284:	fed518e3          	bne	a0,a3,274 <memcmp+0x14>
  }
  return 0;
 288:	4501                	li	a0,0
 28a:	a019                	j	290 <memcmp+0x30>
      return *p1 - *p2;
 28c:	40e7853b          	subw	a0,a5,a4
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
  return 0;
 296:	4501                	li	a0,0
 298:	bfe5                	j	290 <memcmp+0x30>

000000000000029a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a2:	00000097          	auipc	ra,0x0
 2a6:	f62080e7          	jalr	-158(ra) # 204 <memmove>
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 2b8:	040007b7          	lui	a5,0x4000
}
 2bc:	17f5                	addi	a5,a5,-3
 2be:	07b2                	slli	a5,a5,0xc
 2c0:	4388                	lw	a0,0(a5)
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c8:	4885                	li	a7,1
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d0:	4889                	li	a7,2
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d8:	488d                	li	a7,3
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e0:	4891                	li	a7,4
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <read>:
.global read
read:
 li a7, SYS_read
 2e8:	4895                	li	a7,5
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <write>:
.global write
write:
 li a7, SYS_write
 2f0:	48c1                	li	a7,16
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <close>:
.global close
close:
 li a7, SYS_close
 2f8:	48d5                	li	a7,21
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <kill>:
.global kill
kill:
 li a7, SYS_kill
 300:	4899                	li	a7,6
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <exec>:
.global exec
exec:
 li a7, SYS_exec
 308:	489d                	li	a7,7
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <open>:
.global open
open:
 li a7, SYS_open
 310:	48bd                	li	a7,15
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 318:	48c5                	li	a7,17
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 320:	48c9                	li	a7,18
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 328:	48a1                	li	a7,8
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <link>:
.global link
link:
 li a7, SYS_link
 330:	48cd                	li	a7,19
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 338:	48d1                	li	a7,20
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 340:	48a5                	li	a7,9
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <dup>:
.global dup
dup:
 li a7, SYS_dup
 348:	48a9                	li	a7,10
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 350:	48ad                	li	a7,11
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 358:	48b1                	li	a7,12
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 360:	48b5                	li	a7,13
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 368:	48b9                	li	a7,14
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <connect>:
.global connect
connect:
 li a7, SYS_connect
 370:	48f5                	li	a7,29
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 378:	48f9                	li	a7,30
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 380:	1101                	addi	sp,sp,-32
 382:	ec06                	sd	ra,24(sp)
 384:	e822                	sd	s0,16(sp)
 386:	1000                	addi	s0,sp,32
 388:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 38c:	4605                	li	a2,1
 38e:	fef40593          	addi	a1,s0,-17
 392:	00000097          	auipc	ra,0x0
 396:	f5e080e7          	jalr	-162(ra) # 2f0 <write>
}
 39a:	60e2                	ld	ra,24(sp)
 39c:	6442                	ld	s0,16(sp)
 39e:	6105                	addi	sp,sp,32
 3a0:	8082                	ret

00000000000003a2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a2:	7139                	addi	sp,sp,-64
 3a4:	fc06                	sd	ra,56(sp)
 3a6:	f822                	sd	s0,48(sp)
 3a8:	f426                	sd	s1,40(sp)
 3aa:	f04a                	sd	s2,32(sp)
 3ac:	ec4e                	sd	s3,24(sp)
 3ae:	0080                	addi	s0,sp,64
 3b0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b2:	c299                	beqz	a3,3b8 <printint+0x16>
 3b4:	0805c863          	bltz	a1,444 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b8:	2581                	sext.w	a1,a1
  neg = 0;
 3ba:	4881                	li	a7,0
 3bc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3c0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c2:	2601                	sext.w	a2,a2
 3c4:	00000517          	auipc	a0,0x0
 3c8:	44450513          	addi	a0,a0,1092 # 808 <digits>
 3cc:	883a                	mv	a6,a4
 3ce:	2705                	addiw	a4,a4,1
 3d0:	02c5f7bb          	remuw	a5,a1,a2
 3d4:	1782                	slli	a5,a5,0x20
 3d6:	9381                	srli	a5,a5,0x20
 3d8:	97aa                	add	a5,a5,a0
 3da:	0007c783          	lbu	a5,0(a5) # 4000000 <base+0x3ffeff0>
 3de:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e2:	0005879b          	sext.w	a5,a1
 3e6:	02c5d5bb          	divuw	a1,a1,a2
 3ea:	0685                	addi	a3,a3,1
 3ec:	fec7f0e3          	bgeu	a5,a2,3cc <printint+0x2a>
  if(neg)
 3f0:	00088b63          	beqz	a7,406 <printint+0x64>
    buf[i++] = '-';
 3f4:	fd040793          	addi	a5,s0,-48
 3f8:	973e                	add	a4,a4,a5
 3fa:	02d00793          	li	a5,45
 3fe:	fef70823          	sb	a5,-16(a4)
 402:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 406:	02e05863          	blez	a4,436 <printint+0x94>
 40a:	fc040793          	addi	a5,s0,-64
 40e:	00e78933          	add	s2,a5,a4
 412:	fff78993          	addi	s3,a5,-1
 416:	99ba                	add	s3,s3,a4
 418:	377d                	addiw	a4,a4,-1
 41a:	1702                	slli	a4,a4,0x20
 41c:	9301                	srli	a4,a4,0x20
 41e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 422:	fff94583          	lbu	a1,-1(s2)
 426:	8526                	mv	a0,s1
 428:	00000097          	auipc	ra,0x0
 42c:	f58080e7          	jalr	-168(ra) # 380 <putc>
  while(--i >= 0)
 430:	197d                	addi	s2,s2,-1
 432:	ff3918e3          	bne	s2,s3,422 <printint+0x80>
}
 436:	70e2                	ld	ra,56(sp)
 438:	7442                	ld	s0,48(sp)
 43a:	74a2                	ld	s1,40(sp)
 43c:	7902                	ld	s2,32(sp)
 43e:	69e2                	ld	s3,24(sp)
 440:	6121                	addi	sp,sp,64
 442:	8082                	ret
    x = -xx;
 444:	40b005bb          	negw	a1,a1
    neg = 1;
 448:	4885                	li	a7,1
    x = -xx;
 44a:	bf8d                	j	3bc <printint+0x1a>

000000000000044c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44c:	7119                	addi	sp,sp,-128
 44e:	fc86                	sd	ra,120(sp)
 450:	f8a2                	sd	s0,112(sp)
 452:	f4a6                	sd	s1,104(sp)
 454:	f0ca                	sd	s2,96(sp)
 456:	ecce                	sd	s3,88(sp)
 458:	e8d2                	sd	s4,80(sp)
 45a:	e4d6                	sd	s5,72(sp)
 45c:	e0da                	sd	s6,64(sp)
 45e:	fc5e                	sd	s7,56(sp)
 460:	f862                	sd	s8,48(sp)
 462:	f466                	sd	s9,40(sp)
 464:	f06a                	sd	s10,32(sp)
 466:	ec6e                	sd	s11,24(sp)
 468:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 46a:	0005c903          	lbu	s2,0(a1)
 46e:	18090f63          	beqz	s2,60c <vprintf+0x1c0>
 472:	8aaa                	mv	s5,a0
 474:	8b32                	mv	s6,a2
 476:	00158493          	addi	s1,a1,1
  state = 0;
 47a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 47c:	02500a13          	li	s4,37
      if(c == 'd'){
 480:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 484:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 488:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 48c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 490:	00000b97          	auipc	s7,0x0
 494:	378b8b93          	addi	s7,s7,888 # 808 <digits>
 498:	a839                	j	4b6 <vprintf+0x6a>
        putc(fd, c);
 49a:	85ca                	mv	a1,s2
 49c:	8556                	mv	a0,s5
 49e:	00000097          	auipc	ra,0x0
 4a2:	ee2080e7          	jalr	-286(ra) # 380 <putc>
 4a6:	a019                	j	4ac <vprintf+0x60>
    } else if(state == '%'){
 4a8:	01498f63          	beq	s3,s4,4c6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4ac:	0485                	addi	s1,s1,1
 4ae:	fff4c903          	lbu	s2,-1(s1)
 4b2:	14090d63          	beqz	s2,60c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4b6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4ba:	fe0997e3          	bnez	s3,4a8 <vprintf+0x5c>
      if(c == '%'){
 4be:	fd479ee3          	bne	a5,s4,49a <vprintf+0x4e>
        state = '%';
 4c2:	89be                	mv	s3,a5
 4c4:	b7e5                	j	4ac <vprintf+0x60>
      if(c == 'd'){
 4c6:	05878063          	beq	a5,s8,506 <vprintf+0xba>
      } else if(c == 'l') {
 4ca:	05978c63          	beq	a5,s9,522 <vprintf+0xd6>
      } else if(c == 'x') {
 4ce:	07a78863          	beq	a5,s10,53e <vprintf+0xf2>
      } else if(c == 'p') {
 4d2:	09b78463          	beq	a5,s11,55a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4d6:	07300713          	li	a4,115
 4da:	0ce78663          	beq	a5,a4,5a6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4de:	06300713          	li	a4,99
 4e2:	0ee78e63          	beq	a5,a4,5de <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4e6:	11478863          	beq	a5,s4,5f6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4ea:	85d2                	mv	a1,s4
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	e92080e7          	jalr	-366(ra) # 380 <putc>
        putc(fd, c);
 4f6:	85ca                	mv	a1,s2
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	e86080e7          	jalr	-378(ra) # 380 <putc>
      }
      state = 0;
 502:	4981                	li	s3,0
 504:	b765                	j	4ac <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 506:	008b0913          	addi	s2,s6,8
 50a:	4685                	li	a3,1
 50c:	4629                	li	a2,10
 50e:	000b2583          	lw	a1,0(s6)
 512:	8556                	mv	a0,s5
 514:	00000097          	auipc	ra,0x0
 518:	e8e080e7          	jalr	-370(ra) # 3a2 <printint>
 51c:	8b4a                	mv	s6,s2
      state = 0;
 51e:	4981                	li	s3,0
 520:	b771                	j	4ac <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 522:	008b0913          	addi	s2,s6,8
 526:	4681                	li	a3,0
 528:	4629                	li	a2,10
 52a:	000b2583          	lw	a1,0(s6)
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	e72080e7          	jalr	-398(ra) # 3a2 <printint>
 538:	8b4a                	mv	s6,s2
      state = 0;
 53a:	4981                	li	s3,0
 53c:	bf85                	j	4ac <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 53e:	008b0913          	addi	s2,s6,8
 542:	4681                	li	a3,0
 544:	4641                	li	a2,16
 546:	000b2583          	lw	a1,0(s6)
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	e56080e7          	jalr	-426(ra) # 3a2 <printint>
 554:	8b4a                	mv	s6,s2
      state = 0;
 556:	4981                	li	s3,0
 558:	bf91                	j	4ac <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 55a:	008b0793          	addi	a5,s6,8
 55e:	f8f43423          	sd	a5,-120(s0)
 562:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 566:	03000593          	li	a1,48
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	e14080e7          	jalr	-492(ra) # 380 <putc>
  putc(fd, 'x');
 574:	85ea                	mv	a1,s10
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	e08080e7          	jalr	-504(ra) # 380 <putc>
 580:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 582:	03c9d793          	srli	a5,s3,0x3c
 586:	97de                	add	a5,a5,s7
 588:	0007c583          	lbu	a1,0(a5)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	df2080e7          	jalr	-526(ra) # 380 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 596:	0992                	slli	s3,s3,0x4
 598:	397d                	addiw	s2,s2,-1
 59a:	fe0914e3          	bnez	s2,582 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 59e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b721                	j	4ac <vprintf+0x60>
        s = va_arg(ap, char*);
 5a6:	008b0993          	addi	s3,s6,8
 5aa:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5ae:	02090163          	beqz	s2,5d0 <vprintf+0x184>
        while(*s != 0){
 5b2:	00094583          	lbu	a1,0(s2)
 5b6:	c9a1                	beqz	a1,606 <vprintf+0x1ba>
          putc(fd, *s);
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	dc6080e7          	jalr	-570(ra) # 380 <putc>
          s++;
 5c2:	0905                	addi	s2,s2,1
        while(*s != 0){
 5c4:	00094583          	lbu	a1,0(s2)
 5c8:	f9e5                	bnez	a1,5b8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5ca:	8b4e                	mv	s6,s3
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	bdf9                	j	4ac <vprintf+0x60>
          s = "(null)";
 5d0:	00000917          	auipc	s2,0x0
 5d4:	23090913          	addi	s2,s2,560 # 800 <malloc+0xea>
        while(*s != 0){
 5d8:	02800593          	li	a1,40
 5dc:	bff1                	j	5b8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5de:	008b0913          	addi	s2,s6,8
 5e2:	000b4583          	lbu	a1,0(s6)
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	d98080e7          	jalr	-616(ra) # 380 <putc>
 5f0:	8b4a                	mv	s6,s2
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	bd65                	j	4ac <vprintf+0x60>
        putc(fd, c);
 5f6:	85d2                	mv	a1,s4
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	d86080e7          	jalr	-634(ra) # 380 <putc>
      state = 0;
 602:	4981                	li	s3,0
 604:	b565                	j	4ac <vprintf+0x60>
        s = va_arg(ap, char*);
 606:	8b4e                	mv	s6,s3
      state = 0;
 608:	4981                	li	s3,0
 60a:	b54d                	j	4ac <vprintf+0x60>
    }
  }
}
 60c:	70e6                	ld	ra,120(sp)
 60e:	7446                	ld	s0,112(sp)
 610:	74a6                	ld	s1,104(sp)
 612:	7906                	ld	s2,96(sp)
 614:	69e6                	ld	s3,88(sp)
 616:	6a46                	ld	s4,80(sp)
 618:	6aa6                	ld	s5,72(sp)
 61a:	6b06                	ld	s6,64(sp)
 61c:	7be2                	ld	s7,56(sp)
 61e:	7c42                	ld	s8,48(sp)
 620:	7ca2                	ld	s9,40(sp)
 622:	7d02                	ld	s10,32(sp)
 624:	6de2                	ld	s11,24(sp)
 626:	6109                	addi	sp,sp,128
 628:	8082                	ret

000000000000062a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 62a:	715d                	addi	sp,sp,-80
 62c:	ec06                	sd	ra,24(sp)
 62e:	e822                	sd	s0,16(sp)
 630:	1000                	addi	s0,sp,32
 632:	e010                	sd	a2,0(s0)
 634:	e414                	sd	a3,8(s0)
 636:	e818                	sd	a4,16(s0)
 638:	ec1c                	sd	a5,24(s0)
 63a:	03043023          	sd	a6,32(s0)
 63e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 642:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 646:	8622                	mv	a2,s0
 648:	00000097          	auipc	ra,0x0
 64c:	e04080e7          	jalr	-508(ra) # 44c <vprintf>
}
 650:	60e2                	ld	ra,24(sp)
 652:	6442                	ld	s0,16(sp)
 654:	6161                	addi	sp,sp,80
 656:	8082                	ret

0000000000000658 <printf>:

void
printf(const char *fmt, ...)
{
 658:	711d                	addi	sp,sp,-96
 65a:	ec06                	sd	ra,24(sp)
 65c:	e822                	sd	s0,16(sp)
 65e:	1000                	addi	s0,sp,32
 660:	e40c                	sd	a1,8(s0)
 662:	e810                	sd	a2,16(s0)
 664:	ec14                	sd	a3,24(s0)
 666:	f018                	sd	a4,32(s0)
 668:	f41c                	sd	a5,40(s0)
 66a:	03043823          	sd	a6,48(s0)
 66e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 672:	00840613          	addi	a2,s0,8
 676:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 67a:	85aa                	mv	a1,a0
 67c:	4505                	li	a0,1
 67e:	00000097          	auipc	ra,0x0
 682:	dce080e7          	jalr	-562(ra) # 44c <vprintf>
}
 686:	60e2                	ld	ra,24(sp)
 688:	6442                	ld	s0,16(sp)
 68a:	6125                	addi	sp,sp,96
 68c:	8082                	ret

000000000000068e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68e:	1141                	addi	sp,sp,-16
 690:	e422                	sd	s0,8(sp)
 692:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 694:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 698:	00001797          	auipc	a5,0x1
 69c:	9687b783          	ld	a5,-1688(a5) # 1000 <freep>
 6a0:	a805                	j	6d0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6a2:	4618                	lw	a4,8(a2)
 6a4:	9db9                	addw	a1,a1,a4
 6a6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6aa:	6398                	ld	a4,0(a5)
 6ac:	6318                	ld	a4,0(a4)
 6ae:	fee53823          	sd	a4,-16(a0)
 6b2:	a091                	j	6f6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6b4:	ff852703          	lw	a4,-8(a0)
 6b8:	9e39                	addw	a2,a2,a4
 6ba:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6bc:	ff053703          	ld	a4,-16(a0)
 6c0:	e398                	sd	a4,0(a5)
 6c2:	a099                	j	708 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	6398                	ld	a4,0(a5)
 6c6:	00e7e463          	bltu	a5,a4,6ce <free+0x40>
 6ca:	00e6ea63          	bltu	a3,a4,6de <free+0x50>
{
 6ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d0:	fed7fae3          	bgeu	a5,a3,6c4 <free+0x36>
 6d4:	6398                	ld	a4,0(a5)
 6d6:	00e6e463          	bltu	a3,a4,6de <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6da:	fee7eae3          	bltu	a5,a4,6ce <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6de:	ff852583          	lw	a1,-8(a0)
 6e2:	6390                	ld	a2,0(a5)
 6e4:	02059713          	slli	a4,a1,0x20
 6e8:	9301                	srli	a4,a4,0x20
 6ea:	0712                	slli	a4,a4,0x4
 6ec:	9736                	add	a4,a4,a3
 6ee:	fae60ae3          	beq	a2,a4,6a2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6f6:	4790                	lw	a2,8(a5)
 6f8:	02061713          	slli	a4,a2,0x20
 6fc:	9301                	srli	a4,a4,0x20
 6fe:	0712                	slli	a4,a4,0x4
 700:	973e                	add	a4,a4,a5
 702:	fae689e3          	beq	a3,a4,6b4 <free+0x26>
  } else
    p->s.ptr = bp;
 706:	e394                	sd	a3,0(a5)
  freep = p;
 708:	00001717          	auipc	a4,0x1
 70c:	8ef73c23          	sd	a5,-1800(a4) # 1000 <freep>
}
 710:	6422                	ld	s0,8(sp)
 712:	0141                	addi	sp,sp,16
 714:	8082                	ret

0000000000000716 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 716:	7139                	addi	sp,sp,-64
 718:	fc06                	sd	ra,56(sp)
 71a:	f822                	sd	s0,48(sp)
 71c:	f426                	sd	s1,40(sp)
 71e:	f04a                	sd	s2,32(sp)
 720:	ec4e                	sd	s3,24(sp)
 722:	e852                	sd	s4,16(sp)
 724:	e456                	sd	s5,8(sp)
 726:	e05a                	sd	s6,0(sp)
 728:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72a:	02051493          	slli	s1,a0,0x20
 72e:	9081                	srli	s1,s1,0x20
 730:	04bd                	addi	s1,s1,15
 732:	8091                	srli	s1,s1,0x4
 734:	0014899b          	addiw	s3,s1,1
 738:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 73a:	00001517          	auipc	a0,0x1
 73e:	8c653503          	ld	a0,-1850(a0) # 1000 <freep>
 742:	c515                	beqz	a0,76e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 744:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 746:	4798                	lw	a4,8(a5)
 748:	02977f63          	bgeu	a4,s1,786 <malloc+0x70>
 74c:	8a4e                	mv	s4,s3
 74e:	0009871b          	sext.w	a4,s3
 752:	6685                	lui	a3,0x1
 754:	00d77363          	bgeu	a4,a3,75a <malloc+0x44>
 758:	6a05                	lui	s4,0x1
 75a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 75e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 762:	00001917          	auipc	s2,0x1
 766:	89e90913          	addi	s2,s2,-1890 # 1000 <freep>
  if(p == (char*)-1)
 76a:	5afd                	li	s5,-1
 76c:	a88d                	j	7de <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 76e:	00001797          	auipc	a5,0x1
 772:	8a278793          	addi	a5,a5,-1886 # 1010 <base>
 776:	00001717          	auipc	a4,0x1
 77a:	88f73523          	sd	a5,-1910(a4) # 1000 <freep>
 77e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 780:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 784:	b7e1                	j	74c <malloc+0x36>
      if(p->s.size == nunits)
 786:	02e48b63          	beq	s1,a4,7bc <malloc+0xa6>
        p->s.size -= nunits;
 78a:	4137073b          	subw	a4,a4,s3
 78e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 790:	1702                	slli	a4,a4,0x20
 792:	9301                	srli	a4,a4,0x20
 794:	0712                	slli	a4,a4,0x4
 796:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 798:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 79c:	00001717          	auipc	a4,0x1
 7a0:	86a73223          	sd	a0,-1948(a4) # 1000 <freep>
      return (void*)(p + 1);
 7a4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7a8:	70e2                	ld	ra,56(sp)
 7aa:	7442                	ld	s0,48(sp)
 7ac:	74a2                	ld	s1,40(sp)
 7ae:	7902                	ld	s2,32(sp)
 7b0:	69e2                	ld	s3,24(sp)
 7b2:	6a42                	ld	s4,16(sp)
 7b4:	6aa2                	ld	s5,8(sp)
 7b6:	6b02                	ld	s6,0(sp)
 7b8:	6121                	addi	sp,sp,64
 7ba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7bc:	6398                	ld	a4,0(a5)
 7be:	e118                	sd	a4,0(a0)
 7c0:	bff1                	j	79c <malloc+0x86>
  hp->s.size = nu;
 7c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7c6:	0541                	addi	a0,a0,16
 7c8:	00000097          	auipc	ra,0x0
 7cc:	ec6080e7          	jalr	-314(ra) # 68e <free>
  return freep;
 7d0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7d4:	d971                	beqz	a0,7a8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d8:	4798                	lw	a4,8(a5)
 7da:	fa9776e3          	bgeu	a4,s1,786 <malloc+0x70>
    if(p == freep)
 7de:	00093703          	ld	a4,0(s2)
 7e2:	853e                	mv	a0,a5
 7e4:	fef719e3          	bne	a4,a5,7d6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7e8:	8552                	mv	a0,s4
 7ea:	00000097          	auipc	ra,0x0
 7ee:	b6e080e7          	jalr	-1170(ra) # 358 <sbrk>
  if(p == (char*)-1)
 7f2:	fd5518e3          	bne	a0,s5,7c2 <malloc+0xac>
        return 0;
 7f6:	4501                	li	a0,0
 7f8:	bf45                	j	7a8 <malloc+0x92>
