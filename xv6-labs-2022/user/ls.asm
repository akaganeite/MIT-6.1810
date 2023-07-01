
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	32a080e7          	jalr	810(ra) # 33a <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2fe080e7          	jalr	766(ra) # 33a <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2dc080e7          	jalr	732(ra) # 33a <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	faa98993          	addi	s3,s3,-86 # 1010 <buf.1115>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	43c080e7          	jalr	1084(ra) # 4b2 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2ba080e7          	jalr	698(ra) # 33a <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2ac080e7          	jalr	684(ra) # 33a <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2bc080e7          	jalr	700(ra) # 364 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	4e4080e7          	jalr	1252(ra) # 5be <open>
  e2:	08054163          	bltz	a0,164 <ls+0xb0>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	4ea080e7          	jalr	1258(ra) # 5d6 <fstat>
  f4:	08054363          	bltz	a0,17a <ls+0xc6>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68c63          	beq	a3,a4,19a <ls+0xe6>
 106:	37f9                	addiw	a5,a5,-2
 108:	17c2                	slli	a5,a5,0x30
 10a:	93c1                	srli	a5,a5,0x30
 10c:	02f76663          	bltu	a4,a5,138 <ls+0x84>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 110:	854a                	mv	a0,s2
 112:	00000097          	auipc	ra,0x0
 116:	eee080e7          	jalr	-274(ra) # 0 <fmtname>
 11a:	85aa                	mv	a1,a0
 11c:	da843703          	ld	a4,-600(s0)
 120:	d9c42683          	lw	a3,-612(s0)
 124:	da041603          	lh	a2,-608(s0)
 128:	00001517          	auipc	a0,0x1
 12c:	9b850513          	addi	a0,a0,-1608 # ae0 <malloc+0x11c>
 130:	00000097          	auipc	ra,0x0
 134:	7d6080e7          	jalr	2006(ra) # 906 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 138:	8526                	mv	a0,s1
 13a:	00000097          	auipc	ra,0x0
 13e:	46c080e7          	jalr	1132(ra) # 5a6 <close>
}
 142:	26813083          	ld	ra,616(sp)
 146:	26013403          	ld	s0,608(sp)
 14a:	25813483          	ld	s1,600(sp)
 14e:	25013903          	ld	s2,592(sp)
 152:	24813983          	ld	s3,584(sp)
 156:	24013a03          	ld	s4,576(sp)
 15a:	23813a83          	ld	s5,568(sp)
 15e:	27010113          	addi	sp,sp,624
 162:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 164:	864a                	mv	a2,s2
 166:	00001597          	auipc	a1,0x1
 16a:	94a58593          	addi	a1,a1,-1718 # ab0 <malloc+0xec>
 16e:	4509                	li	a0,2
 170:	00000097          	auipc	ra,0x0
 174:	768080e7          	jalr	1896(ra) # 8d8 <fprintf>
    return;
 178:	b7e9                	j	142 <ls+0x8e>
    fprintf(2, "ls: cannot stat %s\n", path);
 17a:	864a                	mv	a2,s2
 17c:	00001597          	auipc	a1,0x1
 180:	94c58593          	addi	a1,a1,-1716 # ac8 <malloc+0x104>
 184:	4509                	li	a0,2
 186:	00000097          	auipc	ra,0x0
 18a:	752080e7          	jalr	1874(ra) # 8d8 <fprintf>
    close(fd);
 18e:	8526                	mv	a0,s1
 190:	00000097          	auipc	ra,0x0
 194:	416080e7          	jalr	1046(ra) # 5a6 <close>
    return;
 198:	b76d                	j	142 <ls+0x8e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19a:	854a                	mv	a0,s2
 19c:	00000097          	auipc	ra,0x0
 1a0:	19e080e7          	jalr	414(ra) # 33a <strlen>
 1a4:	2541                	addiw	a0,a0,16
 1a6:	20000793          	li	a5,512
 1aa:	00a7fb63          	bgeu	a5,a0,1c0 <ls+0x10c>
      printf("ls: path too long\n");
 1ae:	00001517          	auipc	a0,0x1
 1b2:	94250513          	addi	a0,a0,-1726 # af0 <malloc+0x12c>
 1b6:	00000097          	auipc	ra,0x0
 1ba:	750080e7          	jalr	1872(ra) # 906 <printf>
      break;
 1be:	bfad                	j	138 <ls+0x84>
    strcpy(buf, path);
 1c0:	85ca                	mv	a1,s2
 1c2:	dc040513          	addi	a0,s0,-576
 1c6:	00000097          	auipc	ra,0x0
 1ca:	12c080e7          	jalr	300(ra) # 2f2 <strcpy>
    p = buf+strlen(buf);
 1ce:	dc040513          	addi	a0,s0,-576
 1d2:	00000097          	auipc	ra,0x0
 1d6:	168080e7          	jalr	360(ra) # 33a <strlen>
 1da:	02051913          	slli	s2,a0,0x20
 1de:	02095913          	srli	s2,s2,0x20
 1e2:	dc040793          	addi	a5,s0,-576
 1e6:	993e                	add	s2,s2,a5
    *p++ = '/';
 1e8:	00190993          	addi	s3,s2,1
 1ec:	02f00793          	li	a5,47
 1f0:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f4:	00001a17          	auipc	s4,0x1
 1f8:	914a0a13          	addi	s4,s4,-1772 # b08 <malloc+0x144>
        printf("ls: cannot stat %s\n", buf);
 1fc:	00001a97          	auipc	s5,0x1
 200:	8cca8a93          	addi	s5,s5,-1844 # ac8 <malloc+0x104>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 204:	a801                	j	214 <ls+0x160>
        printf("ls: cannot stat %s\n", buf);
 206:	dc040593          	addi	a1,s0,-576
 20a:	8556                	mv	a0,s5
 20c:	00000097          	auipc	ra,0x0
 210:	6fa080e7          	jalr	1786(ra) # 906 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 214:	4641                	li	a2,16
 216:	db040593          	addi	a1,s0,-592
 21a:	8526                	mv	a0,s1
 21c:	00000097          	auipc	ra,0x0
 220:	37a080e7          	jalr	890(ra) # 596 <read>
 224:	47c1                	li	a5,16
 226:	f0f519e3          	bne	a0,a5,138 <ls+0x84>
      if(de.inum == 0)
 22a:	db045783          	lhu	a5,-592(s0)
 22e:	d3fd                	beqz	a5,214 <ls+0x160>
      memmove(p, de.name, DIRSIZ);
 230:	4639                	li	a2,14
 232:	db240593          	addi	a1,s0,-590
 236:	854e                	mv	a0,s3
 238:	00000097          	auipc	ra,0x0
 23c:	27a080e7          	jalr	634(ra) # 4b2 <memmove>
      p[DIRSIZ] = 0;
 240:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 244:	d9840593          	addi	a1,s0,-616
 248:	dc040513          	addi	a0,s0,-576
 24c:	00000097          	auipc	ra,0x0
 250:	1d6080e7          	jalr	470(ra) # 422 <stat>
 254:	fa0549e3          	bltz	a0,206 <ls+0x152>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 258:	dc040513          	addi	a0,s0,-576
 25c:	00000097          	auipc	ra,0x0
 260:	da4080e7          	jalr	-604(ra) # 0 <fmtname>
 264:	85aa                	mv	a1,a0
 266:	da843703          	ld	a4,-600(s0)
 26a:	d9c42683          	lw	a3,-612(s0)
 26e:	da041603          	lh	a2,-608(s0)
 272:	8552                	mv	a0,s4
 274:	00000097          	auipc	ra,0x0
 278:	692080e7          	jalr	1682(ra) # 906 <printf>
 27c:	bf61                	j	214 <ls+0x160>

000000000000027e <main>:

int
main(int argc, char *argv[])
{
 27e:	1101                	addi	sp,sp,-32
 280:	ec06                	sd	ra,24(sp)
 282:	e822                	sd	s0,16(sp)
 284:	e426                	sd	s1,8(sp)
 286:	e04a                	sd	s2,0(sp)
 288:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 28a:	4785                	li	a5,1
 28c:	02a7d963          	bge	a5,a0,2be <main+0x40>
 290:	00858493          	addi	s1,a1,8
 294:	ffe5091b          	addiw	s2,a0,-2
 298:	1902                	slli	s2,s2,0x20
 29a:	02095913          	srli	s2,s2,0x20
 29e:	090e                	slli	s2,s2,0x3
 2a0:	05c1                	addi	a1,a1,16
 2a2:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a4:	6088                	ld	a0,0(s1)
 2a6:	00000097          	auipc	ra,0x0
 2aa:	e0e080e7          	jalr	-498(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2ae:	04a1                	addi	s1,s1,8
 2b0:	ff249ae3          	bne	s1,s2,2a4 <main+0x26>
  exit(0);
 2b4:	4501                	li	a0,0
 2b6:	00000097          	auipc	ra,0x0
 2ba:	2c8080e7          	jalr	712(ra) # 57e <exit>
    ls(".");
 2be:	00001517          	auipc	a0,0x1
 2c2:	85a50513          	addi	a0,a0,-1958 # b18 <malloc+0x154>
 2c6:	00000097          	auipc	ra,0x0
 2ca:	dee080e7          	jalr	-530(ra) # b4 <ls>
    exit(0);
 2ce:	4501                	li	a0,0
 2d0:	00000097          	auipc	ra,0x0
 2d4:	2ae080e7          	jalr	686(ra) # 57e <exit>

00000000000002d8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2e0:	00000097          	auipc	ra,0x0
 2e4:	f9e080e7          	jalr	-98(ra) # 27e <main>
  exit(0);
 2e8:	4501                	li	a0,0
 2ea:	00000097          	auipc	ra,0x0
 2ee:	294080e7          	jalr	660(ra) # 57e <exit>

00000000000002f2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f8:	87aa                	mv	a5,a0
 2fa:	0585                	addi	a1,a1,1
 2fc:	0785                	addi	a5,a5,1
 2fe:	fff5c703          	lbu	a4,-1(a1)
 302:	fee78fa3          	sb	a4,-1(a5)
 306:	fb75                	bnez	a4,2fa <strcpy+0x8>
    ;
  return os;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 314:	00054783          	lbu	a5,0(a0)
 318:	cb91                	beqz	a5,32c <strcmp+0x1e>
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00f71763          	bne	a4,a5,32c <strcmp+0x1e>
    p++, q++;
 322:	0505                	addi	a0,a0,1
 324:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 326:	00054783          	lbu	a5,0(a0)
 32a:	fbe5                	bnez	a5,31a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 32c:	0005c503          	lbu	a0,0(a1)
}
 330:	40a7853b          	subw	a0,a5,a0
 334:	6422                	ld	s0,8(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <strlen>:

uint
strlen(const char *s)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 340:	00054783          	lbu	a5,0(a0)
 344:	cf91                	beqz	a5,360 <strlen+0x26>
 346:	0505                	addi	a0,a0,1
 348:	87aa                	mv	a5,a0
 34a:	4685                	li	a3,1
 34c:	9e89                	subw	a3,a3,a0
 34e:	00f6853b          	addw	a0,a3,a5
 352:	0785                	addi	a5,a5,1
 354:	fff7c703          	lbu	a4,-1(a5)
 358:	fb7d                	bnez	a4,34e <strlen+0x14>
    ;
  return n;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  for(n = 0; s[n]; n++)
 360:	4501                	li	a0,0
 362:	bfe5                	j	35a <strlen+0x20>

0000000000000364 <memset>:

void*
memset(void *dst, int c, uint n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 36a:	ce09                	beqz	a2,384 <memset+0x20>
 36c:	87aa                	mv	a5,a0
 36e:	fff6071b          	addiw	a4,a2,-1
 372:	1702                	slli	a4,a4,0x20
 374:	9301                	srli	a4,a4,0x20
 376:	0705                	addi	a4,a4,1
 378:	972a                	add	a4,a4,a0
    cdst[i] = c;
 37a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 37e:	0785                	addi	a5,a5,1
 380:	fee79de3          	bne	a5,a4,37a <memset+0x16>
  }
  return dst;
}
 384:	6422                	ld	s0,8(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <strchr>:

char*
strchr(const char *s, char c)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e422                	sd	s0,8(sp)
 38e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 390:	00054783          	lbu	a5,0(a0)
 394:	cb99                	beqz	a5,3aa <strchr+0x20>
    if(*s == c)
 396:	00f58763          	beq	a1,a5,3a4 <strchr+0x1a>
  for(; *s; s++)
 39a:	0505                	addi	a0,a0,1
 39c:	00054783          	lbu	a5,0(a0)
 3a0:	fbfd                	bnez	a5,396 <strchr+0xc>
      return (char*)s;
  return 0;
 3a2:	4501                	li	a0,0
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	bfe5                	j	3a4 <strchr+0x1a>

00000000000003ae <gets>:

char*
gets(char *buf, int max)
{
 3ae:	711d                	addi	sp,sp,-96
 3b0:	ec86                	sd	ra,88(sp)
 3b2:	e8a2                	sd	s0,80(sp)
 3b4:	e4a6                	sd	s1,72(sp)
 3b6:	e0ca                	sd	s2,64(sp)
 3b8:	fc4e                	sd	s3,56(sp)
 3ba:	f852                	sd	s4,48(sp)
 3bc:	f456                	sd	s5,40(sp)
 3be:	f05a                	sd	s6,32(sp)
 3c0:	ec5e                	sd	s7,24(sp)
 3c2:	1080                	addi	s0,sp,96
 3c4:	8baa                	mv	s7,a0
 3c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c8:	892a                	mv	s2,a0
 3ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3cc:	4aa9                	li	s5,10
 3ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3d0:	89a6                	mv	s3,s1
 3d2:	2485                	addiw	s1,s1,1
 3d4:	0344d863          	bge	s1,s4,404 <gets+0x56>
    cc = read(0, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	faf40593          	addi	a1,s0,-81
 3de:	4501                	li	a0,0
 3e0:	00000097          	auipc	ra,0x0
 3e4:	1b6080e7          	jalr	438(ra) # 596 <read>
    if(cc < 1)
 3e8:	00a05e63          	blez	a0,404 <gets+0x56>
    buf[i++] = c;
 3ec:	faf44783          	lbu	a5,-81(s0)
 3f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3f4:	01578763          	beq	a5,s5,402 <gets+0x54>
 3f8:	0905                	addi	s2,s2,1
 3fa:	fd679be3          	bne	a5,s6,3d0 <gets+0x22>
  for(i=0; i+1 < max; ){
 3fe:	89a6                	mv	s3,s1
 400:	a011                	j	404 <gets+0x56>
 402:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 404:	99de                	add	s3,s3,s7
 406:	00098023          	sb	zero,0(s3)
  return buf;
}
 40a:	855e                	mv	a0,s7
 40c:	60e6                	ld	ra,88(sp)
 40e:	6446                	ld	s0,80(sp)
 410:	64a6                	ld	s1,72(sp)
 412:	6906                	ld	s2,64(sp)
 414:	79e2                	ld	s3,56(sp)
 416:	7a42                	ld	s4,48(sp)
 418:	7aa2                	ld	s5,40(sp)
 41a:	7b02                	ld	s6,32(sp)
 41c:	6be2                	ld	s7,24(sp)
 41e:	6125                	addi	sp,sp,96
 420:	8082                	ret

0000000000000422 <stat>:

int
stat(const char *n, struct stat *st)
{
 422:	1101                	addi	sp,sp,-32
 424:	ec06                	sd	ra,24(sp)
 426:	e822                	sd	s0,16(sp)
 428:	e426                	sd	s1,8(sp)
 42a:	e04a                	sd	s2,0(sp)
 42c:	1000                	addi	s0,sp,32
 42e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 430:	4581                	li	a1,0
 432:	00000097          	auipc	ra,0x0
 436:	18c080e7          	jalr	396(ra) # 5be <open>
  if(fd < 0)
 43a:	02054563          	bltz	a0,464 <stat+0x42>
 43e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 440:	85ca                	mv	a1,s2
 442:	00000097          	auipc	ra,0x0
 446:	194080e7          	jalr	404(ra) # 5d6 <fstat>
 44a:	892a                	mv	s2,a0
  close(fd);
 44c:	8526                	mv	a0,s1
 44e:	00000097          	auipc	ra,0x0
 452:	158080e7          	jalr	344(ra) # 5a6 <close>
  return r;
}
 456:	854a                	mv	a0,s2
 458:	60e2                	ld	ra,24(sp)
 45a:	6442                	ld	s0,16(sp)
 45c:	64a2                	ld	s1,8(sp)
 45e:	6902                	ld	s2,0(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret
    return -1;
 464:	597d                	li	s2,-1
 466:	bfc5                	j	456 <stat+0x34>

0000000000000468 <atoi>:

int
atoi(const char *s)
{
 468:	1141                	addi	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 46e:	00054603          	lbu	a2,0(a0)
 472:	fd06079b          	addiw	a5,a2,-48
 476:	0ff7f793          	andi	a5,a5,255
 47a:	4725                	li	a4,9
 47c:	02f76963          	bltu	a4,a5,4ae <atoi+0x46>
 480:	86aa                	mv	a3,a0
  n = 0;
 482:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 484:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 486:	0685                	addi	a3,a3,1
 488:	0025179b          	slliw	a5,a0,0x2
 48c:	9fa9                	addw	a5,a5,a0
 48e:	0017979b          	slliw	a5,a5,0x1
 492:	9fb1                	addw	a5,a5,a2
 494:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 498:	0006c603          	lbu	a2,0(a3)
 49c:	fd06071b          	addiw	a4,a2,-48
 4a0:	0ff77713          	andi	a4,a4,255
 4a4:	fee5f1e3          	bgeu	a1,a4,486 <atoi+0x1e>
  return n;
}
 4a8:	6422                	ld	s0,8(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret
  n = 0;
 4ae:	4501                	li	a0,0
 4b0:	bfe5                	j	4a8 <atoi+0x40>

00000000000004b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4b8:	02b57663          	bgeu	a0,a1,4e4 <memmove+0x32>
    while(n-- > 0)
 4bc:	02c05163          	blez	a2,4de <memmove+0x2c>
 4c0:	fff6079b          	addiw	a5,a2,-1
 4c4:	1782                	slli	a5,a5,0x20
 4c6:	9381                	srli	a5,a5,0x20
 4c8:	0785                	addi	a5,a5,1
 4ca:	97aa                	add	a5,a5,a0
  dst = vdst;
 4cc:	872a                	mv	a4,a0
      *dst++ = *src++;
 4ce:	0585                	addi	a1,a1,1
 4d0:	0705                	addi	a4,a4,1
 4d2:	fff5c683          	lbu	a3,-1(a1)
 4d6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4da:	fee79ae3          	bne	a5,a4,4ce <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4de:	6422                	ld	s0,8(sp)
 4e0:	0141                	addi	sp,sp,16
 4e2:	8082                	ret
    dst += n;
 4e4:	00c50733          	add	a4,a0,a2
    src += n;
 4e8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4ea:	fec05ae3          	blez	a2,4de <memmove+0x2c>
 4ee:	fff6079b          	addiw	a5,a2,-1
 4f2:	1782                	slli	a5,a5,0x20
 4f4:	9381                	srli	a5,a5,0x20
 4f6:	fff7c793          	not	a5,a5
 4fa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4fc:	15fd                	addi	a1,a1,-1
 4fe:	177d                	addi	a4,a4,-1
 500:	0005c683          	lbu	a3,0(a1)
 504:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 508:	fee79ae3          	bne	a5,a4,4fc <memmove+0x4a>
 50c:	bfc9                	j	4de <memmove+0x2c>

000000000000050e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 50e:	1141                	addi	sp,sp,-16
 510:	e422                	sd	s0,8(sp)
 512:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 514:	ca05                	beqz	a2,544 <memcmp+0x36>
 516:	fff6069b          	addiw	a3,a2,-1
 51a:	1682                	slli	a3,a3,0x20
 51c:	9281                	srli	a3,a3,0x20
 51e:	0685                	addi	a3,a3,1
 520:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 522:	00054783          	lbu	a5,0(a0)
 526:	0005c703          	lbu	a4,0(a1)
 52a:	00e79863          	bne	a5,a4,53a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 52e:	0505                	addi	a0,a0,1
    p2++;
 530:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 532:	fed518e3          	bne	a0,a3,522 <memcmp+0x14>
  }
  return 0;
 536:	4501                	li	a0,0
 538:	a019                	j	53e <memcmp+0x30>
      return *p1 - *p2;
 53a:	40e7853b          	subw	a0,a5,a4
}
 53e:	6422                	ld	s0,8(sp)
 540:	0141                	addi	sp,sp,16
 542:	8082                	ret
  return 0;
 544:	4501                	li	a0,0
 546:	bfe5                	j	53e <memcmp+0x30>

0000000000000548 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 548:	1141                	addi	sp,sp,-16
 54a:	e406                	sd	ra,8(sp)
 54c:	e022                	sd	s0,0(sp)
 54e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 550:	00000097          	auipc	ra,0x0
 554:	f62080e7          	jalr	-158(ra) # 4b2 <memmove>
}
 558:	60a2                	ld	ra,8(sp)
 55a:	6402                	ld	s0,0(sp)
 55c:	0141                	addi	sp,sp,16
 55e:	8082                	ret

0000000000000560 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 560:	1141                	addi	sp,sp,-16
 562:	e422                	sd	s0,8(sp)
 564:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 566:	040007b7          	lui	a5,0x4000
}
 56a:	17f5                	addi	a5,a5,-3
 56c:	07b2                	slli	a5,a5,0xc
 56e:	4388                	lw	a0,0(a5)
 570:	6422                	ld	s0,8(sp)
 572:	0141                	addi	sp,sp,16
 574:	8082                	ret

0000000000000576 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 576:	4885                	li	a7,1
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <exit>:
.global exit
exit:
 li a7, SYS_exit
 57e:	4889                	li	a7,2
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <wait>:
.global wait
wait:
 li a7, SYS_wait
 586:	488d                	li	a7,3
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 58e:	4891                	li	a7,4
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <read>:
.global read
read:
 li a7, SYS_read
 596:	4895                	li	a7,5
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <write>:
.global write
write:
 li a7, SYS_write
 59e:	48c1                	li	a7,16
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <close>:
.global close
close:
 li a7, SYS_close
 5a6:	48d5                	li	a7,21
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 5ae:	4899                	li	a7,6
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b6:	489d                	li	a7,7
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <open>:
.global open
open:
 li a7, SYS_open
 5be:	48bd                	li	a7,15
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c6:	48c5                	li	a7,17
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ce:	48c9                	li	a7,18
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d6:	48a1                	li	a7,8
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <link>:
.global link
link:
 li a7, SYS_link
 5de:	48cd                	li	a7,19
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e6:	48d1                	li	a7,20
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ee:	48a5                	li	a7,9
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f6:	48a9                	li	a7,10
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5fe:	48ad                	li	a7,11
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 606:	48b1                	li	a7,12
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 60e:	48b5                	li	a7,13
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 616:	48b9                	li	a7,14
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <connect>:
.global connect
connect:
 li a7, SYS_connect
 61e:	48f5                	li	a7,29
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 626:	48f9                	li	a7,30
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 62e:	1101                	addi	sp,sp,-32
 630:	ec06                	sd	ra,24(sp)
 632:	e822                	sd	s0,16(sp)
 634:	1000                	addi	s0,sp,32
 636:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 63a:	4605                	li	a2,1
 63c:	fef40593          	addi	a1,s0,-17
 640:	00000097          	auipc	ra,0x0
 644:	f5e080e7          	jalr	-162(ra) # 59e <write>
}
 648:	60e2                	ld	ra,24(sp)
 64a:	6442                	ld	s0,16(sp)
 64c:	6105                	addi	sp,sp,32
 64e:	8082                	ret

0000000000000650 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 650:	7139                	addi	sp,sp,-64
 652:	fc06                	sd	ra,56(sp)
 654:	f822                	sd	s0,48(sp)
 656:	f426                	sd	s1,40(sp)
 658:	f04a                	sd	s2,32(sp)
 65a:	ec4e                	sd	s3,24(sp)
 65c:	0080                	addi	s0,sp,64
 65e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 660:	c299                	beqz	a3,666 <printint+0x16>
 662:	0805c863          	bltz	a1,6f2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 666:	2581                	sext.w	a1,a1
  neg = 0;
 668:	4881                	li	a7,0
 66a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 66e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 670:	2601                	sext.w	a2,a2
 672:	00000517          	auipc	a0,0x0
 676:	4b650513          	addi	a0,a0,1206 # b28 <digits>
 67a:	883a                	mv	a6,a4
 67c:	2705                	addiw	a4,a4,1
 67e:	02c5f7bb          	remuw	a5,a1,a2
 682:	1782                	slli	a5,a5,0x20
 684:	9381                	srli	a5,a5,0x20
 686:	97aa                	add	a5,a5,a0
 688:	0007c783          	lbu	a5,0(a5) # 4000000 <base+0x3ffefe0>
 68c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 690:	0005879b          	sext.w	a5,a1
 694:	02c5d5bb          	divuw	a1,a1,a2
 698:	0685                	addi	a3,a3,1
 69a:	fec7f0e3          	bgeu	a5,a2,67a <printint+0x2a>
  if(neg)
 69e:	00088b63          	beqz	a7,6b4 <printint+0x64>
    buf[i++] = '-';
 6a2:	fd040793          	addi	a5,s0,-48
 6a6:	973e                	add	a4,a4,a5
 6a8:	02d00793          	li	a5,45
 6ac:	fef70823          	sb	a5,-16(a4)
 6b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6b4:	02e05863          	blez	a4,6e4 <printint+0x94>
 6b8:	fc040793          	addi	a5,s0,-64
 6bc:	00e78933          	add	s2,a5,a4
 6c0:	fff78993          	addi	s3,a5,-1
 6c4:	99ba                	add	s3,s3,a4
 6c6:	377d                	addiw	a4,a4,-1
 6c8:	1702                	slli	a4,a4,0x20
 6ca:	9301                	srli	a4,a4,0x20
 6cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d0:	fff94583          	lbu	a1,-1(s2)
 6d4:	8526                	mv	a0,s1
 6d6:	00000097          	auipc	ra,0x0
 6da:	f58080e7          	jalr	-168(ra) # 62e <putc>
  while(--i >= 0)
 6de:	197d                	addi	s2,s2,-1
 6e0:	ff3918e3          	bne	s2,s3,6d0 <printint+0x80>
}
 6e4:	70e2                	ld	ra,56(sp)
 6e6:	7442                	ld	s0,48(sp)
 6e8:	74a2                	ld	s1,40(sp)
 6ea:	7902                	ld	s2,32(sp)
 6ec:	69e2                	ld	s3,24(sp)
 6ee:	6121                	addi	sp,sp,64
 6f0:	8082                	ret
    x = -xx;
 6f2:	40b005bb          	negw	a1,a1
    neg = 1;
 6f6:	4885                	li	a7,1
    x = -xx;
 6f8:	bf8d                	j	66a <printint+0x1a>

00000000000006fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6fa:	7119                	addi	sp,sp,-128
 6fc:	fc86                	sd	ra,120(sp)
 6fe:	f8a2                	sd	s0,112(sp)
 700:	f4a6                	sd	s1,104(sp)
 702:	f0ca                	sd	s2,96(sp)
 704:	ecce                	sd	s3,88(sp)
 706:	e8d2                	sd	s4,80(sp)
 708:	e4d6                	sd	s5,72(sp)
 70a:	e0da                	sd	s6,64(sp)
 70c:	fc5e                	sd	s7,56(sp)
 70e:	f862                	sd	s8,48(sp)
 710:	f466                	sd	s9,40(sp)
 712:	f06a                	sd	s10,32(sp)
 714:	ec6e                	sd	s11,24(sp)
 716:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 718:	0005c903          	lbu	s2,0(a1)
 71c:	18090f63          	beqz	s2,8ba <vprintf+0x1c0>
 720:	8aaa                	mv	s5,a0
 722:	8b32                	mv	s6,a2
 724:	00158493          	addi	s1,a1,1
  state = 0;
 728:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 72a:	02500a13          	li	s4,37
      if(c == 'd'){
 72e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 732:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 736:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 73a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73e:	00000b97          	auipc	s7,0x0
 742:	3eab8b93          	addi	s7,s7,1002 # b28 <digits>
 746:	a839                	j	764 <vprintf+0x6a>
        putc(fd, c);
 748:	85ca                	mv	a1,s2
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	ee2080e7          	jalr	-286(ra) # 62e <putc>
 754:	a019                	j	75a <vprintf+0x60>
    } else if(state == '%'){
 756:	01498f63          	beq	s3,s4,774 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 75a:	0485                	addi	s1,s1,1
 75c:	fff4c903          	lbu	s2,-1(s1)
 760:	14090d63          	beqz	s2,8ba <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 764:	0009079b          	sext.w	a5,s2
    if(state == 0){
 768:	fe0997e3          	bnez	s3,756 <vprintf+0x5c>
      if(c == '%'){
 76c:	fd479ee3          	bne	a5,s4,748 <vprintf+0x4e>
        state = '%';
 770:	89be                	mv	s3,a5
 772:	b7e5                	j	75a <vprintf+0x60>
      if(c == 'd'){
 774:	05878063          	beq	a5,s8,7b4 <vprintf+0xba>
      } else if(c == 'l') {
 778:	05978c63          	beq	a5,s9,7d0 <vprintf+0xd6>
      } else if(c == 'x') {
 77c:	07a78863          	beq	a5,s10,7ec <vprintf+0xf2>
      } else if(c == 'p') {
 780:	09b78463          	beq	a5,s11,808 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 784:	07300713          	li	a4,115
 788:	0ce78663          	beq	a5,a4,854 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78c:	06300713          	li	a4,99
 790:	0ee78e63          	beq	a5,a4,88c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 794:	11478863          	beq	a5,s4,8a4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 798:	85d2                	mv	a1,s4
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e92080e7          	jalr	-366(ra) # 62e <putc>
        putc(fd, c);
 7a4:	85ca                	mv	a1,s2
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e86080e7          	jalr	-378(ra) # 62e <putc>
      }
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b765                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7b4:	008b0913          	addi	s2,s6,8
 7b8:	4685                	li	a3,1
 7ba:	4629                	li	a2,10
 7bc:	000b2583          	lw	a1,0(s6)
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e8e080e7          	jalr	-370(ra) # 650 <printint>
 7ca:	8b4a                	mv	s6,s2
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b771                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d0:	008b0913          	addi	s2,s6,8
 7d4:	4681                	li	a3,0
 7d6:	4629                	li	a2,10
 7d8:	000b2583          	lw	a1,0(s6)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e72080e7          	jalr	-398(ra) # 650 <printint>
 7e6:	8b4a                	mv	s6,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bf85                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7ec:	008b0913          	addi	s2,s6,8
 7f0:	4681                	li	a3,0
 7f2:	4641                	li	a2,16
 7f4:	000b2583          	lw	a1,0(s6)
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	e56080e7          	jalr	-426(ra) # 650 <printint>
 802:	8b4a                	mv	s6,s2
      state = 0;
 804:	4981                	li	s3,0
 806:	bf91                	j	75a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 808:	008b0793          	addi	a5,s6,8
 80c:	f8f43423          	sd	a5,-120(s0)
 810:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 814:	03000593          	li	a1,48
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	e14080e7          	jalr	-492(ra) # 62e <putc>
  putc(fd, 'x');
 822:	85ea                	mv	a1,s10
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	e08080e7          	jalr	-504(ra) # 62e <putc>
 82e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 830:	03c9d793          	srli	a5,s3,0x3c
 834:	97de                	add	a5,a5,s7
 836:	0007c583          	lbu	a1,0(a5)
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	df2080e7          	jalr	-526(ra) # 62e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 844:	0992                	slli	s3,s3,0x4
 846:	397d                	addiw	s2,s2,-1
 848:	fe0914e3          	bnez	s2,830 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 84c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 850:	4981                	li	s3,0
 852:	b721                	j	75a <vprintf+0x60>
        s = va_arg(ap, char*);
 854:	008b0993          	addi	s3,s6,8
 858:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 85c:	02090163          	beqz	s2,87e <vprintf+0x184>
        while(*s != 0){
 860:	00094583          	lbu	a1,0(s2)
 864:	c9a1                	beqz	a1,8b4 <vprintf+0x1ba>
          putc(fd, *s);
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	dc6080e7          	jalr	-570(ra) # 62e <putc>
          s++;
 870:	0905                	addi	s2,s2,1
        while(*s != 0){
 872:	00094583          	lbu	a1,0(s2)
 876:	f9e5                	bnez	a1,866 <vprintf+0x16c>
        s = va_arg(ap, char*);
 878:	8b4e                	mv	s6,s3
      state = 0;
 87a:	4981                	li	s3,0
 87c:	bdf9                	j	75a <vprintf+0x60>
          s = "(null)";
 87e:	00000917          	auipc	s2,0x0
 882:	2a290913          	addi	s2,s2,674 # b20 <malloc+0x15c>
        while(*s != 0){
 886:	02800593          	li	a1,40
 88a:	bff1                	j	866 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 88c:	008b0913          	addi	s2,s6,8
 890:	000b4583          	lbu	a1,0(s6)
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	d98080e7          	jalr	-616(ra) # 62e <putc>
 89e:	8b4a                	mv	s6,s2
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	bd65                	j	75a <vprintf+0x60>
        putc(fd, c);
 8a4:	85d2                	mv	a1,s4
 8a6:	8556                	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	d86080e7          	jalr	-634(ra) # 62e <putc>
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	b565                	j	75a <vprintf+0x60>
        s = va_arg(ap, char*);
 8b4:	8b4e                	mv	s6,s3
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	b54d                	j	75a <vprintf+0x60>
    }
  }
}
 8ba:	70e6                	ld	ra,120(sp)
 8bc:	7446                	ld	s0,112(sp)
 8be:	74a6                	ld	s1,104(sp)
 8c0:	7906                	ld	s2,96(sp)
 8c2:	69e6                	ld	s3,88(sp)
 8c4:	6a46                	ld	s4,80(sp)
 8c6:	6aa6                	ld	s5,72(sp)
 8c8:	6b06                	ld	s6,64(sp)
 8ca:	7be2                	ld	s7,56(sp)
 8cc:	7c42                	ld	s8,48(sp)
 8ce:	7ca2                	ld	s9,40(sp)
 8d0:	7d02                	ld	s10,32(sp)
 8d2:	6de2                	ld	s11,24(sp)
 8d4:	6109                	addi	sp,sp,128
 8d6:	8082                	ret

00000000000008d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d8:	715d                	addi	sp,sp,-80
 8da:	ec06                	sd	ra,24(sp)
 8dc:	e822                	sd	s0,16(sp)
 8de:	1000                	addi	s0,sp,32
 8e0:	e010                	sd	a2,0(s0)
 8e2:	e414                	sd	a3,8(s0)
 8e4:	e818                	sd	a4,16(s0)
 8e6:	ec1c                	sd	a5,24(s0)
 8e8:	03043023          	sd	a6,32(s0)
 8ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f4:	8622                	mv	a2,s0
 8f6:	00000097          	auipc	ra,0x0
 8fa:	e04080e7          	jalr	-508(ra) # 6fa <vprintf>
}
 8fe:	60e2                	ld	ra,24(sp)
 900:	6442                	ld	s0,16(sp)
 902:	6161                	addi	sp,sp,80
 904:	8082                	ret

0000000000000906 <printf>:

void
printf(const char *fmt, ...)
{
 906:	711d                	addi	sp,sp,-96
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e40c                	sd	a1,8(s0)
 910:	e810                	sd	a2,16(s0)
 912:	ec14                	sd	a3,24(s0)
 914:	f018                	sd	a4,32(s0)
 916:	f41c                	sd	a5,40(s0)
 918:	03043823          	sd	a6,48(s0)
 91c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 920:	00840613          	addi	a2,s0,8
 924:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 928:	85aa                	mv	a1,a0
 92a:	4505                	li	a0,1
 92c:	00000097          	auipc	ra,0x0
 930:	dce080e7          	jalr	-562(ra) # 6fa <vprintf>
}
 934:	60e2                	ld	ra,24(sp)
 936:	6442                	ld	s0,16(sp)
 938:	6125                	addi	sp,sp,96
 93a:	8082                	ret

000000000000093c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 93c:	1141                	addi	sp,sp,-16
 93e:	e422                	sd	s0,8(sp)
 940:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 942:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 946:	00000797          	auipc	a5,0x0
 94a:	6ba7b783          	ld	a5,1722(a5) # 1000 <freep>
 94e:	a805                	j	97e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 950:	4618                	lw	a4,8(a2)
 952:	9db9                	addw	a1,a1,a4
 954:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 958:	6398                	ld	a4,0(a5)
 95a:	6318                	ld	a4,0(a4)
 95c:	fee53823          	sd	a4,-16(a0)
 960:	a091                	j	9a4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 962:	ff852703          	lw	a4,-8(a0)
 966:	9e39                	addw	a2,a2,a4
 968:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 96a:	ff053703          	ld	a4,-16(a0)
 96e:	e398                	sd	a4,0(a5)
 970:	a099                	j	9b6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 972:	6398                	ld	a4,0(a5)
 974:	00e7e463          	bltu	a5,a4,97c <free+0x40>
 978:	00e6ea63          	bltu	a3,a4,98c <free+0x50>
{
 97c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97e:	fed7fae3          	bgeu	a5,a3,972 <free+0x36>
 982:	6398                	ld	a4,0(a5)
 984:	00e6e463          	bltu	a3,a4,98c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 988:	fee7eae3          	bltu	a5,a4,97c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 98c:	ff852583          	lw	a1,-8(a0)
 990:	6390                	ld	a2,0(a5)
 992:	02059713          	slli	a4,a1,0x20
 996:	9301                	srli	a4,a4,0x20
 998:	0712                	slli	a4,a4,0x4
 99a:	9736                	add	a4,a4,a3
 99c:	fae60ae3          	beq	a2,a4,950 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9a0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9a4:	4790                	lw	a2,8(a5)
 9a6:	02061713          	slli	a4,a2,0x20
 9aa:	9301                	srli	a4,a4,0x20
 9ac:	0712                	slli	a4,a4,0x4
 9ae:	973e                	add	a4,a4,a5
 9b0:	fae689e3          	beq	a3,a4,962 <free+0x26>
  } else
    p->s.ptr = bp;
 9b4:	e394                	sd	a3,0(a5)
  freep = p;
 9b6:	00000717          	auipc	a4,0x0
 9ba:	64f73523          	sd	a5,1610(a4) # 1000 <freep>
}
 9be:	6422                	ld	s0,8(sp)
 9c0:	0141                	addi	sp,sp,16
 9c2:	8082                	ret

00000000000009c4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c4:	7139                	addi	sp,sp,-64
 9c6:	fc06                	sd	ra,56(sp)
 9c8:	f822                	sd	s0,48(sp)
 9ca:	f426                	sd	s1,40(sp)
 9cc:	f04a                	sd	s2,32(sp)
 9ce:	ec4e                	sd	s3,24(sp)
 9d0:	e852                	sd	s4,16(sp)
 9d2:	e456                	sd	s5,8(sp)
 9d4:	e05a                	sd	s6,0(sp)
 9d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d8:	02051493          	slli	s1,a0,0x20
 9dc:	9081                	srli	s1,s1,0x20
 9de:	04bd                	addi	s1,s1,15
 9e0:	8091                	srli	s1,s1,0x4
 9e2:	0014899b          	addiw	s3,s1,1
 9e6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e8:	00000517          	auipc	a0,0x0
 9ec:	61853503          	ld	a0,1560(a0) # 1000 <freep>
 9f0:	c515                	beqz	a0,a1c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f4:	4798                	lw	a4,8(a5)
 9f6:	02977f63          	bgeu	a4,s1,a34 <malloc+0x70>
 9fa:	8a4e                	mv	s4,s3
 9fc:	0009871b          	sext.w	a4,s3
 a00:	6685                	lui	a3,0x1
 a02:	00d77363          	bgeu	a4,a3,a08 <malloc+0x44>
 a06:	6a05                	lui	s4,0x1
 a08:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a0c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a10:	00000917          	auipc	s2,0x0
 a14:	5f090913          	addi	s2,s2,1520 # 1000 <freep>
  if(p == (char*)-1)
 a18:	5afd                	li	s5,-1
 a1a:	a88d                	j	a8c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a1c:	00000797          	auipc	a5,0x0
 a20:	60478793          	addi	a5,a5,1540 # 1020 <base>
 a24:	00000717          	auipc	a4,0x0
 a28:	5cf73e23          	sd	a5,1500(a4) # 1000 <freep>
 a2c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a2e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a32:	b7e1                	j	9fa <malloc+0x36>
      if(p->s.size == nunits)
 a34:	02e48b63          	beq	s1,a4,a6a <malloc+0xa6>
        p->s.size -= nunits;
 a38:	4137073b          	subw	a4,a4,s3
 a3c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a3e:	1702                	slli	a4,a4,0x20
 a40:	9301                	srli	a4,a4,0x20
 a42:	0712                	slli	a4,a4,0x4
 a44:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a46:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a4a:	00000717          	auipc	a4,0x0
 a4e:	5aa73b23          	sd	a0,1462(a4) # 1000 <freep>
      return (void*)(p + 1);
 a52:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a56:	70e2                	ld	ra,56(sp)
 a58:	7442                	ld	s0,48(sp)
 a5a:	74a2                	ld	s1,40(sp)
 a5c:	7902                	ld	s2,32(sp)
 a5e:	69e2                	ld	s3,24(sp)
 a60:	6a42                	ld	s4,16(sp)
 a62:	6aa2                	ld	s5,8(sp)
 a64:	6b02                	ld	s6,0(sp)
 a66:	6121                	addi	sp,sp,64
 a68:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a6a:	6398                	ld	a4,0(a5)
 a6c:	e118                	sd	a4,0(a0)
 a6e:	bff1                	j	a4a <malloc+0x86>
  hp->s.size = nu;
 a70:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a74:	0541                	addi	a0,a0,16
 a76:	00000097          	auipc	ra,0x0
 a7a:	ec6080e7          	jalr	-314(ra) # 93c <free>
  return freep;
 a7e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a82:	d971                	beqz	a0,a56 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a84:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a86:	4798                	lw	a4,8(a5)
 a88:	fa9776e3          	bgeu	a4,s1,a34 <malloc+0x70>
    if(p == freep)
 a8c:	00093703          	ld	a4,0(s2)
 a90:	853e                	mv	a0,a5
 a92:	fef719e3          	bne	a4,a5,a84 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a96:	8552                	mv	a0,s4
 a98:	00000097          	auipc	ra,0x0
 a9c:	b6e080e7          	jalr	-1170(ra) # 606 <sbrk>
  if(p == (char*)-1)
 aa0:	fd5518e3          	bne	a0,s5,a70 <malloc+0xac>
        return 0;
 aa4:	4501                	li	a0,0
 aa6:	bf45                	j	a56 <malloc+0x92>
