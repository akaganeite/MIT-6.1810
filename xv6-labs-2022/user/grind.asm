
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	eaa080e7          	jalr	-342(ra) # f3a <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	34650513          	addi	a0,a0,838 # 13e0 <malloc+0xe8>
      a2:	00001097          	auipc	ra,0x1
      a6:	e78080e7          	jalr	-392(ra) # f1a <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	33650513          	addi	a0,a0,822 # 13e0 <malloc+0xe8>
      b2:	00001097          	auipc	ra,0x1
      b6:	e70080e7          	jalr	-400(ra) # f22 <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	32c50513          	addi	a0,a0,812 # 13e8 <malloc+0xf0>
      c4:	00001097          	auipc	ra,0x1
      c8:	176080e7          	jalr	374(ra) # 123a <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	de4080e7          	jalr	-540(ra) # eb2 <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	33250513          	addi	a0,a0,818 # 1408 <malloc+0x110>
      de:	00001097          	auipc	ra,0x1
      e2:	e44080e7          	jalr	-444(ra) # f22 <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001997          	auipc	s3,0x1
      ea:	33298993          	addi	s3,s3,818 # 1418 <malloc+0x120>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	32098993          	addi	s3,s3,800 # 1410 <malloc+0x118>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	597d                	li	s2,-1
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
      fc:	00002a17          	auipc	s4,0x2
     100:	f24a0a13          	addi	s4,s4,-220 # 2020 <buf.1244>
     104:	a825                	j	13c <go+0xc4>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	31650513          	addi	a0,a0,790 # 1420 <malloc+0x128>
     112:	00001097          	auipc	ra,0x1
     116:	de0080e7          	jalr	-544(ra) # ef2 <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	dc0080e7          	jalr	-576(ra) # eda <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ce                	mv	a1,s3
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	d9e080e7          	jalr	-610(ra) # ed2 <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	4789                	li	a5,2
     152:	18f50563          	beq	a0,a5,2dc <go+0x264>
    } else if(what == 3){
     156:	478d                	li	a5,3
     158:	1af50163          	beq	a0,a5,2fa <go+0x282>
    } else if(what == 4){
     15c:	4791                	li	a5,4
     15e:	1af50763          	beq	a0,a5,30c <go+0x294>
    } else if(what == 5){
     162:	4795                	li	a5,5
     164:	1ef50b63          	beq	a0,a5,35a <go+0x2e2>
    } else if(what == 6){
     168:	4799                	li	a5,6
     16a:	20f50963          	beq	a0,a5,37c <go+0x304>
    } else if(what == 7){
     16e:	479d                	li	a5,7
     170:	22f50763          	beq	a0,a5,39e <go+0x326>
    } else if(what == 8){
     174:	47a1                	li	a5,8
     176:	22f50d63          	beq	a0,a5,3b0 <go+0x338>
    } else if(what == 9){
     17a:	47a5                	li	a5,9
     17c:	24f50363          	beq	a0,a5,3c2 <go+0x34a>
      mkdir("grindir/../a");
      close(open("a/../a/./a", O_CREATE|O_RDWR));
      unlink("a/a");
    } else if(what == 10){
     180:	47a9                	li	a5,10
     182:	26f50f63          	beq	a0,a5,400 <go+0x388>
      mkdir("/../b");
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
      unlink("b/b");
    } else if(what == 11){
     186:	47ad                	li	a5,11
     188:	2af50b63          	beq	a0,a5,43e <go+0x3c6>
      unlink("b");
      link("../grindir/./../a", "../b");
    } else if(what == 12){
     18c:	47b1                	li	a5,12
     18e:	2cf50d63          	beq	a0,a5,468 <go+0x3f0>
      unlink("../grindir/../a");
      link(".././b", "/grindir/../a");
    } else if(what == 13){
     192:	47b5                	li	a5,13
     194:	2ef50f63          	beq	a0,a5,492 <go+0x41a>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 14){
     198:	47b9                	li	a5,14
     19a:	32f50a63          	beq	a0,a5,4ce <go+0x456>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 15){
     19e:	47bd                	li	a5,15
     1a0:	36f50e63          	beq	a0,a5,51c <go+0x4a4>
      sbrk(6011);
    } else if(what == 16){
     1a4:	47c1                	li	a5,16
     1a6:	38f50363          	beq	a0,a5,52c <go+0x4b4>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     1aa:	47c5                	li	a5,17
     1ac:	3af50363          	beq	a0,a5,552 <go+0x4da>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
      wait(0);
    } else if(what == 18){
     1b0:	47c9                	li	a5,18
     1b2:	42f50963          	beq	a0,a5,5e4 <go+0x56c>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 19){
     1b6:	47cd                	li	a5,19
     1b8:	46f50d63          	beq	a0,a5,632 <go+0x5ba>
        exit(1);
      }
      close(fds[0]);
      close(fds[1]);
      wait(0);
    } else if(what == 20){
     1bc:	47d1                	li	a5,20
     1be:	54f50e63          	beq	a0,a5,71a <go+0x6a2>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 21){
     1c2:	47d5                	li	a5,21
     1c4:	5ef50c63          	beq	a0,a5,7bc <go+0x744>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     1c8:	47d9                	li	a5,22
     1ca:	f4f51ce3          	bne	a0,a5,122 <go+0xaa>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1ce:	f9840513          	addi	a0,s0,-104
     1d2:	00001097          	auipc	ra,0x1
     1d6:	cf0080e7          	jalr	-784(ra) # ec2 <pipe>
     1da:	6e054563          	bltz	a0,8c4 <go+0x84c>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     1de:	fa040513          	addi	a0,s0,-96
     1e2:	00001097          	auipc	ra,0x1
     1e6:	ce0080e7          	jalr	-800(ra) # ec2 <pipe>
     1ea:	6e054b63          	bltz	a0,8e0 <go+0x868>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     1ee:	00001097          	auipc	ra,0x1
     1f2:	cbc080e7          	jalr	-836(ra) # eaa <fork>
      if(pid1 == 0){
     1f6:	70050363          	beqz	a0,8fc <go+0x884>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     1fa:	7a054b63          	bltz	a0,9b0 <go+0x938>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     1fe:	00001097          	auipc	ra,0x1
     202:	cac080e7          	jalr	-852(ra) # eaa <fork>
      if(pid2 == 0){
     206:	7c050363          	beqz	a0,9cc <go+0x954>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     20a:	08054fe3          	bltz	a0,aa8 <go+0xa30>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     20e:	f9842503          	lw	a0,-104(s0)
     212:	00001097          	auipc	ra,0x1
     216:	cc8080e7          	jalr	-824(ra) # eda <close>
      close(aa[1]);
     21a:	f9c42503          	lw	a0,-100(s0)
     21e:	00001097          	auipc	ra,0x1
     222:	cbc080e7          	jalr	-836(ra) # eda <close>
      close(bb[1]);
     226:	fa442503          	lw	a0,-92(s0)
     22a:	00001097          	auipc	ra,0x1
     22e:	cb0080e7          	jalr	-848(ra) # eda <close>
      char buf[4] = { 0, 0, 0, 0 };
     232:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     236:	4605                	li	a2,1
     238:	f9040593          	addi	a1,s0,-112
     23c:	fa042503          	lw	a0,-96(s0)
     240:	00001097          	auipc	ra,0x1
     244:	c8a080e7          	jalr	-886(ra) # eca <read>
      read(bb[0], buf+1, 1);
     248:	4605                	li	a2,1
     24a:	f9140593          	addi	a1,s0,-111
     24e:	fa042503          	lw	a0,-96(s0)
     252:	00001097          	auipc	ra,0x1
     256:	c78080e7          	jalr	-904(ra) # eca <read>
      read(bb[0], buf+2, 1);
     25a:	4605                	li	a2,1
     25c:	f9240593          	addi	a1,s0,-110
     260:	fa042503          	lw	a0,-96(s0)
     264:	00001097          	auipc	ra,0x1
     268:	c66080e7          	jalr	-922(ra) # eca <read>
      close(bb[0]);
     26c:	fa042503          	lw	a0,-96(s0)
     270:	00001097          	auipc	ra,0x1
     274:	c6a080e7          	jalr	-918(ra) # eda <close>
      int st1, st2;
      wait(&st1);
     278:	f9440513          	addi	a0,s0,-108
     27c:	00001097          	auipc	ra,0x1
     280:	c3e080e7          	jalr	-962(ra) # eba <wait>
      wait(&st2);
     284:	fa840513          	addi	a0,s0,-88
     288:	00001097          	auipc	ra,0x1
     28c:	c32080e7          	jalr	-974(ra) # eba <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     290:	f9442783          	lw	a5,-108(s0)
     294:	fa842703          	lw	a4,-88(s0)
     298:	8fd9                	or	a5,a5,a4
     29a:	2781                	sext.w	a5,a5
     29c:	ef89                	bnez	a5,2b6 <go+0x23e>
     29e:	00001597          	auipc	a1,0x1
     2a2:	3fa58593          	addi	a1,a1,1018 # 1698 <malloc+0x3a0>
     2a6:	f9040513          	addi	a0,s0,-112
     2aa:	00001097          	auipc	ra,0x1
     2ae:	998080e7          	jalr	-1640(ra) # c42 <strcmp>
     2b2:	e60508e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     2b6:	f9040693          	addi	a3,s0,-112
     2ba:	fa842603          	lw	a2,-88(s0)
     2be:	f9442583          	lw	a1,-108(s0)
     2c2:	00001517          	auipc	a0,0x1
     2c6:	3de50513          	addi	a0,a0,990 # 16a0 <malloc+0x3a8>
     2ca:	00001097          	auipc	ra,0x1
     2ce:	f70080e7          	jalr	-144(ra) # 123a <printf>
        exit(1);
     2d2:	4505                	li	a0,1
     2d4:	00001097          	auipc	ra,0x1
     2d8:	bde080e7          	jalr	-1058(ra) # eb2 <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     2dc:	20200593          	li	a1,514
     2e0:	00001517          	auipc	a0,0x1
     2e4:	15050513          	addi	a0,a0,336 # 1430 <malloc+0x138>
     2e8:	00001097          	auipc	ra,0x1
     2ec:	c0a080e7          	jalr	-1014(ra) # ef2 <open>
     2f0:	00001097          	auipc	ra,0x1
     2f4:	bea080e7          	jalr	-1046(ra) # eda <close>
     2f8:	b52d                	j	122 <go+0xaa>
      unlink("grindir/../a");
     2fa:	00001517          	auipc	a0,0x1
     2fe:	12650513          	addi	a0,a0,294 # 1420 <malloc+0x128>
     302:	00001097          	auipc	ra,0x1
     306:	c00080e7          	jalr	-1024(ra) # f02 <unlink>
     30a:	bd21                	j	122 <go+0xaa>
      if(chdir("grindir") != 0){
     30c:	00001517          	auipc	a0,0x1
     310:	0d450513          	addi	a0,a0,212 # 13e0 <malloc+0xe8>
     314:	00001097          	auipc	ra,0x1
     318:	c0e080e7          	jalr	-1010(ra) # f22 <chdir>
     31c:	e115                	bnez	a0,340 <go+0x2c8>
      unlink("../b");
     31e:	00001517          	auipc	a0,0x1
     322:	12a50513          	addi	a0,a0,298 # 1448 <malloc+0x150>
     326:	00001097          	auipc	ra,0x1
     32a:	bdc080e7          	jalr	-1060(ra) # f02 <unlink>
      chdir("/");
     32e:	00001517          	auipc	a0,0x1
     332:	0da50513          	addi	a0,a0,218 # 1408 <malloc+0x110>
     336:	00001097          	auipc	ra,0x1
     33a:	bec080e7          	jalr	-1044(ra) # f22 <chdir>
     33e:	b3d5                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     340:	00001517          	auipc	a0,0x1
     344:	0a850513          	addi	a0,a0,168 # 13e8 <malloc+0xf0>
     348:	00001097          	auipc	ra,0x1
     34c:	ef2080e7          	jalr	-270(ra) # 123a <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	00001097          	auipc	ra,0x1
     356:	b60080e7          	jalr	-1184(ra) # eb2 <exit>
      close(fd);
     35a:	854a                	mv	a0,s2
     35c:	00001097          	auipc	ra,0x1
     360:	b7e080e7          	jalr	-1154(ra) # eda <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     364:	20200593          	li	a1,514
     368:	00001517          	auipc	a0,0x1
     36c:	0e850513          	addi	a0,a0,232 # 1450 <malloc+0x158>
     370:	00001097          	auipc	ra,0x1
     374:	b82080e7          	jalr	-1150(ra) # ef2 <open>
     378:	892a                	mv	s2,a0
     37a:	b365                	j	122 <go+0xaa>
      close(fd);
     37c:	854a                	mv	a0,s2
     37e:	00001097          	auipc	ra,0x1
     382:	b5c080e7          	jalr	-1188(ra) # eda <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     386:	20200593          	li	a1,514
     38a:	00001517          	auipc	a0,0x1
     38e:	0d650513          	addi	a0,a0,214 # 1460 <malloc+0x168>
     392:	00001097          	auipc	ra,0x1
     396:	b60080e7          	jalr	-1184(ra) # ef2 <open>
     39a:	892a                	mv	s2,a0
     39c:	b359                	j	122 <go+0xaa>
      write(fd, buf, sizeof(buf));
     39e:	3e700613          	li	a2,999
     3a2:	85d2                	mv	a1,s4
     3a4:	854a                	mv	a0,s2
     3a6:	00001097          	auipc	ra,0x1
     3aa:	b2c080e7          	jalr	-1236(ra) # ed2 <write>
     3ae:	bb95                	j	122 <go+0xaa>
      read(fd, buf, sizeof(buf));
     3b0:	3e700613          	li	a2,999
     3b4:	85d2                	mv	a1,s4
     3b6:	854a                	mv	a0,s2
     3b8:	00001097          	auipc	ra,0x1
     3bc:	b12080e7          	jalr	-1262(ra) # eca <read>
     3c0:	b38d                	j	122 <go+0xaa>
      mkdir("grindir/../a");
     3c2:	00001517          	auipc	a0,0x1
     3c6:	05e50513          	addi	a0,a0,94 # 1420 <malloc+0x128>
     3ca:	00001097          	auipc	ra,0x1
     3ce:	b50080e7          	jalr	-1200(ra) # f1a <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     3d2:	20200593          	li	a1,514
     3d6:	00001517          	auipc	a0,0x1
     3da:	0a250513          	addi	a0,a0,162 # 1478 <malloc+0x180>
     3de:	00001097          	auipc	ra,0x1
     3e2:	b14080e7          	jalr	-1260(ra) # ef2 <open>
     3e6:	00001097          	auipc	ra,0x1
     3ea:	af4080e7          	jalr	-1292(ra) # eda <close>
      unlink("a/a");
     3ee:	00001517          	auipc	a0,0x1
     3f2:	09a50513          	addi	a0,a0,154 # 1488 <malloc+0x190>
     3f6:	00001097          	auipc	ra,0x1
     3fa:	b0c080e7          	jalr	-1268(ra) # f02 <unlink>
     3fe:	b315                	j	122 <go+0xaa>
      mkdir("/../b");
     400:	00001517          	auipc	a0,0x1
     404:	09050513          	addi	a0,a0,144 # 1490 <malloc+0x198>
     408:	00001097          	auipc	ra,0x1
     40c:	b12080e7          	jalr	-1262(ra) # f1a <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     410:	20200593          	li	a1,514
     414:	00001517          	auipc	a0,0x1
     418:	08450513          	addi	a0,a0,132 # 1498 <malloc+0x1a0>
     41c:	00001097          	auipc	ra,0x1
     420:	ad6080e7          	jalr	-1322(ra) # ef2 <open>
     424:	00001097          	auipc	ra,0x1
     428:	ab6080e7          	jalr	-1354(ra) # eda <close>
      unlink("b/b");
     42c:	00001517          	auipc	a0,0x1
     430:	07c50513          	addi	a0,a0,124 # 14a8 <malloc+0x1b0>
     434:	00001097          	auipc	ra,0x1
     438:	ace080e7          	jalr	-1330(ra) # f02 <unlink>
     43c:	b1dd                	j	122 <go+0xaa>
      unlink("b");
     43e:	00001517          	auipc	a0,0x1
     442:	03250513          	addi	a0,a0,50 # 1470 <malloc+0x178>
     446:	00001097          	auipc	ra,0x1
     44a:	abc080e7          	jalr	-1348(ra) # f02 <unlink>
      link("../grindir/./../a", "../b");
     44e:	00001597          	auipc	a1,0x1
     452:	ffa58593          	addi	a1,a1,-6 # 1448 <malloc+0x150>
     456:	00001517          	auipc	a0,0x1
     45a:	05a50513          	addi	a0,a0,90 # 14b0 <malloc+0x1b8>
     45e:	00001097          	auipc	ra,0x1
     462:	ab4080e7          	jalr	-1356(ra) # f12 <link>
     466:	b975                	j	122 <go+0xaa>
      unlink("../grindir/../a");
     468:	00001517          	auipc	a0,0x1
     46c:	06050513          	addi	a0,a0,96 # 14c8 <malloc+0x1d0>
     470:	00001097          	auipc	ra,0x1
     474:	a92080e7          	jalr	-1390(ra) # f02 <unlink>
      link(".././b", "/grindir/../a");
     478:	00001597          	auipc	a1,0x1
     47c:	fd858593          	addi	a1,a1,-40 # 1450 <malloc+0x158>
     480:	00001517          	auipc	a0,0x1
     484:	05850513          	addi	a0,a0,88 # 14d8 <malloc+0x1e0>
     488:	00001097          	auipc	ra,0x1
     48c:	a8a080e7          	jalr	-1398(ra) # f12 <link>
     490:	b949                	j	122 <go+0xaa>
      int pid = fork();
     492:	00001097          	auipc	ra,0x1
     496:	a18080e7          	jalr	-1512(ra) # eaa <fork>
      if(pid == 0){
     49a:	c909                	beqz	a0,4ac <go+0x434>
      } else if(pid < 0){
     49c:	00054c63          	bltz	a0,4b4 <go+0x43c>
      wait(0);
     4a0:	4501                	li	a0,0
     4a2:	00001097          	auipc	ra,0x1
     4a6:	a18080e7          	jalr	-1512(ra) # eba <wait>
     4aa:	b9a5                	j	122 <go+0xaa>
        exit(0);
     4ac:	00001097          	auipc	ra,0x1
     4b0:	a06080e7          	jalr	-1530(ra) # eb2 <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	02c50513          	addi	a0,a0,44 # 14e0 <malloc+0x1e8>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	d7e080e7          	jalr	-642(ra) # 123a <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	9ec080e7          	jalr	-1556(ra) # eb2 <exit>
      int pid = fork();
     4ce:	00001097          	auipc	ra,0x1
     4d2:	9dc080e7          	jalr	-1572(ra) # eaa <fork>
      if(pid == 0){
     4d6:	c909                	beqz	a0,4e8 <go+0x470>
      } else if(pid < 0){
     4d8:	02054563          	bltz	a0,502 <go+0x48a>
      wait(0);
     4dc:	4501                	li	a0,0
     4de:	00001097          	auipc	ra,0x1
     4e2:	9dc080e7          	jalr	-1572(ra) # eba <wait>
     4e6:	b935                	j	122 <go+0xaa>
        fork();
     4e8:	00001097          	auipc	ra,0x1
     4ec:	9c2080e7          	jalr	-1598(ra) # eaa <fork>
        fork();
     4f0:	00001097          	auipc	ra,0x1
     4f4:	9ba080e7          	jalr	-1606(ra) # eaa <fork>
        exit(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	9b8080e7          	jalr	-1608(ra) # eb2 <exit>
        printf("grind: fork failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	fde50513          	addi	a0,a0,-34 # 14e0 <malloc+0x1e8>
     50a:	00001097          	auipc	ra,0x1
     50e:	d30080e7          	jalr	-720(ra) # 123a <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	99e080e7          	jalr	-1634(ra) # eb2 <exit>
      sbrk(6011);
     51c:	6505                	lui	a0,0x1
     51e:	77b50513          	addi	a0,a0,1915 # 177b <digits+0xab>
     522:	00001097          	auipc	ra,0x1
     526:	a18080e7          	jalr	-1512(ra) # f3a <sbrk>
     52a:	bee5                	j	122 <go+0xaa>
      if(sbrk(0) > break0)
     52c:	4501                	li	a0,0
     52e:	00001097          	auipc	ra,0x1
     532:	a0c080e7          	jalr	-1524(ra) # f3a <sbrk>
     536:	beaaf6e3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     53a:	4501                	li	a0,0
     53c:	00001097          	auipc	ra,0x1
     540:	9fe080e7          	jalr	-1538(ra) # f3a <sbrk>
     544:	40aa853b          	subw	a0,s5,a0
     548:	00001097          	auipc	ra,0x1
     54c:	9f2080e7          	jalr	-1550(ra) # f3a <sbrk>
     550:	bec9                	j	122 <go+0xaa>
      int pid = fork();
     552:	00001097          	auipc	ra,0x1
     556:	958080e7          	jalr	-1704(ra) # eaa <fork>
     55a:	8b2a                	mv	s6,a0
      if(pid == 0){
     55c:	c51d                	beqz	a0,58a <go+0x512>
      } else if(pid < 0){
     55e:	04054963          	bltz	a0,5b0 <go+0x538>
      if(chdir("../grindir/..") != 0){
     562:	00001517          	auipc	a0,0x1
     566:	f9650513          	addi	a0,a0,-106 # 14f8 <malloc+0x200>
     56a:	00001097          	auipc	ra,0x1
     56e:	9b8080e7          	jalr	-1608(ra) # f22 <chdir>
     572:	ed21                	bnez	a0,5ca <go+0x552>
      kill(pid);
     574:	855a                	mv	a0,s6
     576:	00001097          	auipc	ra,0x1
     57a:	96c080e7          	jalr	-1684(ra) # ee2 <kill>
      wait(0);
     57e:	4501                	li	a0,0
     580:	00001097          	auipc	ra,0x1
     584:	93a080e7          	jalr	-1734(ra) # eba <wait>
     588:	be69                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     58a:	20200593          	li	a1,514
     58e:	00001517          	auipc	a0,0x1
     592:	f3250513          	addi	a0,a0,-206 # 14c0 <malloc+0x1c8>
     596:	00001097          	auipc	ra,0x1
     59a:	95c080e7          	jalr	-1700(ra) # ef2 <open>
     59e:	00001097          	auipc	ra,0x1
     5a2:	93c080e7          	jalr	-1732(ra) # eda <close>
        exit(0);
     5a6:	4501                	li	a0,0
     5a8:	00001097          	auipc	ra,0x1
     5ac:	90a080e7          	jalr	-1782(ra) # eb2 <exit>
        printf("grind: fork failed\n");
     5b0:	00001517          	auipc	a0,0x1
     5b4:	f3050513          	addi	a0,a0,-208 # 14e0 <malloc+0x1e8>
     5b8:	00001097          	auipc	ra,0x1
     5bc:	c82080e7          	jalr	-894(ra) # 123a <printf>
        exit(1);
     5c0:	4505                	li	a0,1
     5c2:	00001097          	auipc	ra,0x1
     5c6:	8f0080e7          	jalr	-1808(ra) # eb2 <exit>
        printf("grind: chdir failed\n");
     5ca:	00001517          	auipc	a0,0x1
     5ce:	f3e50513          	addi	a0,a0,-194 # 1508 <malloc+0x210>
     5d2:	00001097          	auipc	ra,0x1
     5d6:	c68080e7          	jalr	-920(ra) # 123a <printf>
        exit(1);
     5da:	4505                	li	a0,1
     5dc:	00001097          	auipc	ra,0x1
     5e0:	8d6080e7          	jalr	-1834(ra) # eb2 <exit>
      int pid = fork();
     5e4:	00001097          	auipc	ra,0x1
     5e8:	8c6080e7          	jalr	-1850(ra) # eaa <fork>
      if(pid == 0){
     5ec:	c909                	beqz	a0,5fe <go+0x586>
      } else if(pid < 0){
     5ee:	02054563          	bltz	a0,618 <go+0x5a0>
      wait(0);
     5f2:	4501                	li	a0,0
     5f4:	00001097          	auipc	ra,0x1
     5f8:	8c6080e7          	jalr	-1850(ra) # eba <wait>
     5fc:	b61d                	j	122 <go+0xaa>
        kill(getpid());
     5fe:	00001097          	auipc	ra,0x1
     602:	934080e7          	jalr	-1740(ra) # f32 <getpid>
     606:	00001097          	auipc	ra,0x1
     60a:	8dc080e7          	jalr	-1828(ra) # ee2 <kill>
        exit(0);
     60e:	4501                	li	a0,0
     610:	00001097          	auipc	ra,0x1
     614:	8a2080e7          	jalr	-1886(ra) # eb2 <exit>
        printf("grind: fork failed\n");
     618:	00001517          	auipc	a0,0x1
     61c:	ec850513          	addi	a0,a0,-312 # 14e0 <malloc+0x1e8>
     620:	00001097          	auipc	ra,0x1
     624:	c1a080e7          	jalr	-998(ra) # 123a <printf>
        exit(1);
     628:	4505                	li	a0,1
     62a:	00001097          	auipc	ra,0x1
     62e:	888080e7          	jalr	-1912(ra) # eb2 <exit>
      if(pipe(fds) < 0){
     632:	fa840513          	addi	a0,s0,-88
     636:	00001097          	auipc	ra,0x1
     63a:	88c080e7          	jalr	-1908(ra) # ec2 <pipe>
     63e:	02054b63          	bltz	a0,674 <go+0x5fc>
      int pid = fork();
     642:	00001097          	auipc	ra,0x1
     646:	868080e7          	jalr	-1944(ra) # eaa <fork>
      if(pid == 0){
     64a:	c131                	beqz	a0,68e <go+0x616>
      } else if(pid < 0){
     64c:	0a054a63          	bltz	a0,700 <go+0x688>
      close(fds[0]);
     650:	fa842503          	lw	a0,-88(s0)
     654:	00001097          	auipc	ra,0x1
     658:	886080e7          	jalr	-1914(ra) # eda <close>
      close(fds[1]);
     65c:	fac42503          	lw	a0,-84(s0)
     660:	00001097          	auipc	ra,0x1
     664:	87a080e7          	jalr	-1926(ra) # eda <close>
      wait(0);
     668:	4501                	li	a0,0
     66a:	00001097          	auipc	ra,0x1
     66e:	850080e7          	jalr	-1968(ra) # eba <wait>
     672:	bc45                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     674:	00001517          	auipc	a0,0x1
     678:	eac50513          	addi	a0,a0,-340 # 1520 <malloc+0x228>
     67c:	00001097          	auipc	ra,0x1
     680:	bbe080e7          	jalr	-1090(ra) # 123a <printf>
        exit(1);
     684:	4505                	li	a0,1
     686:	00001097          	auipc	ra,0x1
     68a:	82c080e7          	jalr	-2004(ra) # eb2 <exit>
        fork();
     68e:	00001097          	auipc	ra,0x1
     692:	81c080e7          	jalr	-2020(ra) # eaa <fork>
        fork();
     696:	00001097          	auipc	ra,0x1
     69a:	814080e7          	jalr	-2028(ra) # eaa <fork>
        if(write(fds[1], "x", 1) != 1)
     69e:	4605                	li	a2,1
     6a0:	00001597          	auipc	a1,0x1
     6a4:	e9858593          	addi	a1,a1,-360 # 1538 <malloc+0x240>
     6a8:	fac42503          	lw	a0,-84(s0)
     6ac:	00001097          	auipc	ra,0x1
     6b0:	826080e7          	jalr	-2010(ra) # ed2 <write>
     6b4:	4785                	li	a5,1
     6b6:	02f51363          	bne	a0,a5,6dc <go+0x664>
        if(read(fds[0], &c, 1) != 1)
     6ba:	4605                	li	a2,1
     6bc:	fa040593          	addi	a1,s0,-96
     6c0:	fa842503          	lw	a0,-88(s0)
     6c4:	00001097          	auipc	ra,0x1
     6c8:	806080e7          	jalr	-2042(ra) # eca <read>
     6cc:	4785                	li	a5,1
     6ce:	02f51063          	bne	a0,a5,6ee <go+0x676>
        exit(0);
     6d2:	4501                	li	a0,0
     6d4:	00000097          	auipc	ra,0x0
     6d8:	7de080e7          	jalr	2014(ra) # eb2 <exit>
          printf("grind: pipe write failed\n");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	e6450513          	addi	a0,a0,-412 # 1540 <malloc+0x248>
     6e4:	00001097          	auipc	ra,0x1
     6e8:	b56080e7          	jalr	-1194(ra) # 123a <printf>
     6ec:	b7f9                	j	6ba <go+0x642>
          printf("grind: pipe read failed\n");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	e7250513          	addi	a0,a0,-398 # 1560 <malloc+0x268>
     6f6:	00001097          	auipc	ra,0x1
     6fa:	b44080e7          	jalr	-1212(ra) # 123a <printf>
     6fe:	bfd1                	j	6d2 <go+0x65a>
        printf("grind: fork failed\n");
     700:	00001517          	auipc	a0,0x1
     704:	de050513          	addi	a0,a0,-544 # 14e0 <malloc+0x1e8>
     708:	00001097          	auipc	ra,0x1
     70c:	b32080e7          	jalr	-1230(ra) # 123a <printf>
        exit(1);
     710:	4505                	li	a0,1
     712:	00000097          	auipc	ra,0x0
     716:	7a0080e7          	jalr	1952(ra) # eb2 <exit>
      int pid = fork();
     71a:	00000097          	auipc	ra,0x0
     71e:	790080e7          	jalr	1936(ra) # eaa <fork>
      if(pid == 0){
     722:	c909                	beqz	a0,734 <go+0x6bc>
      } else if(pid < 0){
     724:	06054f63          	bltz	a0,7a2 <go+0x72a>
      wait(0);
     728:	4501                	li	a0,0
     72a:	00000097          	auipc	ra,0x0
     72e:	790080e7          	jalr	1936(ra) # eba <wait>
     732:	bac5                	j	122 <go+0xaa>
        unlink("a");
     734:	00001517          	auipc	a0,0x1
     738:	d8c50513          	addi	a0,a0,-628 # 14c0 <malloc+0x1c8>
     73c:	00000097          	auipc	ra,0x0
     740:	7c6080e7          	jalr	1990(ra) # f02 <unlink>
        mkdir("a");
     744:	00001517          	auipc	a0,0x1
     748:	d7c50513          	addi	a0,a0,-644 # 14c0 <malloc+0x1c8>
     74c:	00000097          	auipc	ra,0x0
     750:	7ce080e7          	jalr	1998(ra) # f1a <mkdir>
        chdir("a");
     754:	00001517          	auipc	a0,0x1
     758:	d6c50513          	addi	a0,a0,-660 # 14c0 <malloc+0x1c8>
     75c:	00000097          	auipc	ra,0x0
     760:	7c6080e7          	jalr	1990(ra) # f22 <chdir>
        unlink("../a");
     764:	00001517          	auipc	a0,0x1
     768:	cc450513          	addi	a0,a0,-828 # 1428 <malloc+0x130>
     76c:	00000097          	auipc	ra,0x0
     770:	796080e7          	jalr	1942(ra) # f02 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     774:	20200593          	li	a1,514
     778:	00001517          	auipc	a0,0x1
     77c:	dc050513          	addi	a0,a0,-576 # 1538 <malloc+0x240>
     780:	00000097          	auipc	ra,0x0
     784:	772080e7          	jalr	1906(ra) # ef2 <open>
        unlink("x");
     788:	00001517          	auipc	a0,0x1
     78c:	db050513          	addi	a0,a0,-592 # 1538 <malloc+0x240>
     790:	00000097          	auipc	ra,0x0
     794:	772080e7          	jalr	1906(ra) # f02 <unlink>
        exit(0);
     798:	4501                	li	a0,0
     79a:	00000097          	auipc	ra,0x0
     79e:	718080e7          	jalr	1816(ra) # eb2 <exit>
        printf("grind: fork failed\n");
     7a2:	00001517          	auipc	a0,0x1
     7a6:	d3e50513          	addi	a0,a0,-706 # 14e0 <malloc+0x1e8>
     7aa:	00001097          	auipc	ra,0x1
     7ae:	a90080e7          	jalr	-1392(ra) # 123a <printf>
        exit(1);
     7b2:	4505                	li	a0,1
     7b4:	00000097          	auipc	ra,0x0
     7b8:	6fe080e7          	jalr	1790(ra) # eb2 <exit>
      unlink("c");
     7bc:	00001517          	auipc	a0,0x1
     7c0:	dc450513          	addi	a0,a0,-572 # 1580 <malloc+0x288>
     7c4:	00000097          	auipc	ra,0x0
     7c8:	73e080e7          	jalr	1854(ra) # f02 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     7cc:	20200593          	li	a1,514
     7d0:	00001517          	auipc	a0,0x1
     7d4:	db050513          	addi	a0,a0,-592 # 1580 <malloc+0x288>
     7d8:	00000097          	auipc	ra,0x0
     7dc:	71a080e7          	jalr	1818(ra) # ef2 <open>
     7e0:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     7e2:	04054f63          	bltz	a0,840 <go+0x7c8>
      if(write(fd1, "x", 1) != 1){
     7e6:	4605                	li	a2,1
     7e8:	00001597          	auipc	a1,0x1
     7ec:	d5058593          	addi	a1,a1,-688 # 1538 <malloc+0x240>
     7f0:	00000097          	auipc	ra,0x0
     7f4:	6e2080e7          	jalr	1762(ra) # ed2 <write>
     7f8:	4785                	li	a5,1
     7fa:	06f51063          	bne	a0,a5,85a <go+0x7e2>
      if(fstat(fd1, &st) != 0){
     7fe:	fa840593          	addi	a1,s0,-88
     802:	855a                	mv	a0,s6
     804:	00000097          	auipc	ra,0x0
     808:	706080e7          	jalr	1798(ra) # f0a <fstat>
     80c:	e525                	bnez	a0,874 <go+0x7fc>
      if(st.size != 1){
     80e:	fb843583          	ld	a1,-72(s0)
     812:	4785                	li	a5,1
     814:	06f59d63          	bne	a1,a5,88e <go+0x816>
      if(st.ino > 200){
     818:	fac42583          	lw	a1,-84(s0)
     81c:	0c800793          	li	a5,200
     820:	08b7e563          	bltu	a5,a1,8aa <go+0x832>
      close(fd1);
     824:	855a                	mv	a0,s6
     826:	00000097          	auipc	ra,0x0
     82a:	6b4080e7          	jalr	1716(ra) # eda <close>
      unlink("c");
     82e:	00001517          	auipc	a0,0x1
     832:	d5250513          	addi	a0,a0,-686 # 1580 <malloc+0x288>
     836:	00000097          	auipc	ra,0x0
     83a:	6cc080e7          	jalr	1740(ra) # f02 <unlink>
     83e:	b0d5                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     840:	00001517          	auipc	a0,0x1
     844:	d4850513          	addi	a0,a0,-696 # 1588 <malloc+0x290>
     848:	00001097          	auipc	ra,0x1
     84c:	9f2080e7          	jalr	-1550(ra) # 123a <printf>
        exit(1);
     850:	4505                	li	a0,1
     852:	00000097          	auipc	ra,0x0
     856:	660080e7          	jalr	1632(ra) # eb2 <exit>
        printf("grind: write c failed\n");
     85a:	00001517          	auipc	a0,0x1
     85e:	d4650513          	addi	a0,a0,-698 # 15a0 <malloc+0x2a8>
     862:	00001097          	auipc	ra,0x1
     866:	9d8080e7          	jalr	-1576(ra) # 123a <printf>
        exit(1);
     86a:	4505                	li	a0,1
     86c:	00000097          	auipc	ra,0x0
     870:	646080e7          	jalr	1606(ra) # eb2 <exit>
        printf("grind: fstat failed\n");
     874:	00001517          	auipc	a0,0x1
     878:	d4450513          	addi	a0,a0,-700 # 15b8 <malloc+0x2c0>
     87c:	00001097          	auipc	ra,0x1
     880:	9be080e7          	jalr	-1602(ra) # 123a <printf>
        exit(1);
     884:	4505                	li	a0,1
     886:	00000097          	auipc	ra,0x0
     88a:	62c080e7          	jalr	1580(ra) # eb2 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     88e:	2581                	sext.w	a1,a1
     890:	00001517          	auipc	a0,0x1
     894:	d4050513          	addi	a0,a0,-704 # 15d0 <malloc+0x2d8>
     898:	00001097          	auipc	ra,0x1
     89c:	9a2080e7          	jalr	-1630(ra) # 123a <printf>
        exit(1);
     8a0:	4505                	li	a0,1
     8a2:	00000097          	auipc	ra,0x0
     8a6:	610080e7          	jalr	1552(ra) # eb2 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     8aa:	00001517          	auipc	a0,0x1
     8ae:	d4e50513          	addi	a0,a0,-690 # 15f8 <malloc+0x300>
     8b2:	00001097          	auipc	ra,0x1
     8b6:	988080e7          	jalr	-1656(ra) # 123a <printf>
        exit(1);
     8ba:	4505                	li	a0,1
     8bc:	00000097          	auipc	ra,0x0
     8c0:	5f6080e7          	jalr	1526(ra) # eb2 <exit>
        fprintf(2, "grind: pipe failed\n");
     8c4:	00001597          	auipc	a1,0x1
     8c8:	c5c58593          	addi	a1,a1,-932 # 1520 <malloc+0x228>
     8cc:	4509                	li	a0,2
     8ce:	00001097          	auipc	ra,0x1
     8d2:	93e080e7          	jalr	-1730(ra) # 120c <fprintf>
        exit(1);
     8d6:	4505                	li	a0,1
     8d8:	00000097          	auipc	ra,0x0
     8dc:	5da080e7          	jalr	1498(ra) # eb2 <exit>
        fprintf(2, "grind: pipe failed\n");
     8e0:	00001597          	auipc	a1,0x1
     8e4:	c4058593          	addi	a1,a1,-960 # 1520 <malloc+0x228>
     8e8:	4509                	li	a0,2
     8ea:	00001097          	auipc	ra,0x1
     8ee:	922080e7          	jalr	-1758(ra) # 120c <fprintf>
        exit(1);
     8f2:	4505                	li	a0,1
     8f4:	00000097          	auipc	ra,0x0
     8f8:	5be080e7          	jalr	1470(ra) # eb2 <exit>
        close(bb[0]);
     8fc:	fa042503          	lw	a0,-96(s0)
     900:	00000097          	auipc	ra,0x0
     904:	5da080e7          	jalr	1498(ra) # eda <close>
        close(bb[1]);
     908:	fa442503          	lw	a0,-92(s0)
     90c:	00000097          	auipc	ra,0x0
     910:	5ce080e7          	jalr	1486(ra) # eda <close>
        close(aa[0]);
     914:	f9842503          	lw	a0,-104(s0)
     918:	00000097          	auipc	ra,0x0
     91c:	5c2080e7          	jalr	1474(ra) # eda <close>
        close(1);
     920:	4505                	li	a0,1
     922:	00000097          	auipc	ra,0x0
     926:	5b8080e7          	jalr	1464(ra) # eda <close>
        if(dup(aa[1]) != 1){
     92a:	f9c42503          	lw	a0,-100(s0)
     92e:	00000097          	auipc	ra,0x0
     932:	5fc080e7          	jalr	1532(ra) # f2a <dup>
     936:	4785                	li	a5,1
     938:	02f50063          	beq	a0,a5,958 <go+0x8e0>
          fprintf(2, "grind: dup failed\n");
     93c:	00001597          	auipc	a1,0x1
     940:	ce458593          	addi	a1,a1,-796 # 1620 <malloc+0x328>
     944:	4509                	li	a0,2
     946:	00001097          	auipc	ra,0x1
     94a:	8c6080e7          	jalr	-1850(ra) # 120c <fprintf>
          exit(1);
     94e:	4505                	li	a0,1
     950:	00000097          	auipc	ra,0x0
     954:	562080e7          	jalr	1378(ra) # eb2 <exit>
        close(aa[1]);
     958:	f9c42503          	lw	a0,-100(s0)
     95c:	00000097          	auipc	ra,0x0
     960:	57e080e7          	jalr	1406(ra) # eda <close>
        char *args[3] = { "echo", "hi", 0 };
     964:	00001797          	auipc	a5,0x1
     968:	cd478793          	addi	a5,a5,-812 # 1638 <malloc+0x340>
     96c:	faf43423          	sd	a5,-88(s0)
     970:	00001797          	auipc	a5,0x1
     974:	cd078793          	addi	a5,a5,-816 # 1640 <malloc+0x348>
     978:	faf43823          	sd	a5,-80(s0)
     97c:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     980:	fa840593          	addi	a1,s0,-88
     984:	00001517          	auipc	a0,0x1
     988:	cc450513          	addi	a0,a0,-828 # 1648 <malloc+0x350>
     98c:	00000097          	auipc	ra,0x0
     990:	55e080e7          	jalr	1374(ra) # eea <exec>
        fprintf(2, "grind: echo: not found\n");
     994:	00001597          	auipc	a1,0x1
     998:	cc458593          	addi	a1,a1,-828 # 1658 <malloc+0x360>
     99c:	4509                	li	a0,2
     99e:	00001097          	auipc	ra,0x1
     9a2:	86e080e7          	jalr	-1938(ra) # 120c <fprintf>
        exit(2);
     9a6:	4509                	li	a0,2
     9a8:	00000097          	auipc	ra,0x0
     9ac:	50a080e7          	jalr	1290(ra) # eb2 <exit>
        fprintf(2, "grind: fork failed\n");
     9b0:	00001597          	auipc	a1,0x1
     9b4:	b3058593          	addi	a1,a1,-1232 # 14e0 <malloc+0x1e8>
     9b8:	4509                	li	a0,2
     9ba:	00001097          	auipc	ra,0x1
     9be:	852080e7          	jalr	-1966(ra) # 120c <fprintf>
        exit(3);
     9c2:	450d                	li	a0,3
     9c4:	00000097          	auipc	ra,0x0
     9c8:	4ee080e7          	jalr	1262(ra) # eb2 <exit>
        close(aa[1]);
     9cc:	f9c42503          	lw	a0,-100(s0)
     9d0:	00000097          	auipc	ra,0x0
     9d4:	50a080e7          	jalr	1290(ra) # eda <close>
        close(bb[0]);
     9d8:	fa042503          	lw	a0,-96(s0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	4fe080e7          	jalr	1278(ra) # eda <close>
        close(0);
     9e4:	4501                	li	a0,0
     9e6:	00000097          	auipc	ra,0x0
     9ea:	4f4080e7          	jalr	1268(ra) # eda <close>
        if(dup(aa[0]) != 0){
     9ee:	f9842503          	lw	a0,-104(s0)
     9f2:	00000097          	auipc	ra,0x0
     9f6:	538080e7          	jalr	1336(ra) # f2a <dup>
     9fa:	cd19                	beqz	a0,a18 <go+0x9a0>
          fprintf(2, "grind: dup failed\n");
     9fc:	00001597          	auipc	a1,0x1
     a00:	c2458593          	addi	a1,a1,-988 # 1620 <malloc+0x328>
     a04:	4509                	li	a0,2
     a06:	00001097          	auipc	ra,0x1
     a0a:	806080e7          	jalr	-2042(ra) # 120c <fprintf>
          exit(4);
     a0e:	4511                	li	a0,4
     a10:	00000097          	auipc	ra,0x0
     a14:	4a2080e7          	jalr	1186(ra) # eb2 <exit>
        close(aa[0]);
     a18:	f9842503          	lw	a0,-104(s0)
     a1c:	00000097          	auipc	ra,0x0
     a20:	4be080e7          	jalr	1214(ra) # eda <close>
        close(1);
     a24:	4505                	li	a0,1
     a26:	00000097          	auipc	ra,0x0
     a2a:	4b4080e7          	jalr	1204(ra) # eda <close>
        if(dup(bb[1]) != 1){
     a2e:	fa442503          	lw	a0,-92(s0)
     a32:	00000097          	auipc	ra,0x0
     a36:	4f8080e7          	jalr	1272(ra) # f2a <dup>
     a3a:	4785                	li	a5,1
     a3c:	02f50063          	beq	a0,a5,a5c <go+0x9e4>
          fprintf(2, "grind: dup failed\n");
     a40:	00001597          	auipc	a1,0x1
     a44:	be058593          	addi	a1,a1,-1056 # 1620 <malloc+0x328>
     a48:	4509                	li	a0,2
     a4a:	00000097          	auipc	ra,0x0
     a4e:	7c2080e7          	jalr	1986(ra) # 120c <fprintf>
          exit(5);
     a52:	4515                	li	a0,5
     a54:	00000097          	auipc	ra,0x0
     a58:	45e080e7          	jalr	1118(ra) # eb2 <exit>
        close(bb[1]);
     a5c:	fa442503          	lw	a0,-92(s0)
     a60:	00000097          	auipc	ra,0x0
     a64:	47a080e7          	jalr	1146(ra) # eda <close>
        char *args[2] = { "cat", 0 };
     a68:	00001797          	auipc	a5,0x1
     a6c:	c0878793          	addi	a5,a5,-1016 # 1670 <malloc+0x378>
     a70:	faf43423          	sd	a5,-88(s0)
     a74:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a78:	fa840593          	addi	a1,s0,-88
     a7c:	00001517          	auipc	a0,0x1
     a80:	bfc50513          	addi	a0,a0,-1028 # 1678 <malloc+0x380>
     a84:	00000097          	auipc	ra,0x0
     a88:	466080e7          	jalr	1126(ra) # eea <exec>
        fprintf(2, "grind: cat: not found\n");
     a8c:	00001597          	auipc	a1,0x1
     a90:	bf458593          	addi	a1,a1,-1036 # 1680 <malloc+0x388>
     a94:	4509                	li	a0,2
     a96:	00000097          	auipc	ra,0x0
     a9a:	776080e7          	jalr	1910(ra) # 120c <fprintf>
        exit(6);
     a9e:	4519                	li	a0,6
     aa0:	00000097          	auipc	ra,0x0
     aa4:	412080e7          	jalr	1042(ra) # eb2 <exit>
        fprintf(2, "grind: fork failed\n");
     aa8:	00001597          	auipc	a1,0x1
     aac:	a3858593          	addi	a1,a1,-1480 # 14e0 <malloc+0x1e8>
     ab0:	4509                	li	a0,2
     ab2:	00000097          	auipc	ra,0x0
     ab6:	75a080e7          	jalr	1882(ra) # 120c <fprintf>
        exit(7);
     aba:	451d                	li	a0,7
     abc:	00000097          	auipc	ra,0x0
     ac0:	3f6080e7          	jalr	1014(ra) # eb2 <exit>

0000000000000ac4 <iter>:
  }
}

void
iter()
{
     ac4:	7179                	addi	sp,sp,-48
     ac6:	f406                	sd	ra,40(sp)
     ac8:	f022                	sd	s0,32(sp)
     aca:	ec26                	sd	s1,24(sp)
     acc:	e84a                	sd	s2,16(sp)
     ace:	1800                	addi	s0,sp,48
  unlink("a");
     ad0:	00001517          	auipc	a0,0x1
     ad4:	9f050513          	addi	a0,a0,-1552 # 14c0 <malloc+0x1c8>
     ad8:	00000097          	auipc	ra,0x0
     adc:	42a080e7          	jalr	1066(ra) # f02 <unlink>
  unlink("b");
     ae0:	00001517          	auipc	a0,0x1
     ae4:	99050513          	addi	a0,a0,-1648 # 1470 <malloc+0x178>
     ae8:	00000097          	auipc	ra,0x0
     aec:	41a080e7          	jalr	1050(ra) # f02 <unlink>
  
  int pid1 = fork();
     af0:	00000097          	auipc	ra,0x0
     af4:	3ba080e7          	jalr	954(ra) # eaa <fork>
  if(pid1 < 0){
     af8:	02054163          	bltz	a0,b1a <iter+0x56>
     afc:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     afe:	e91d                	bnez	a0,b34 <iter+0x70>
    rand_next ^= 31;
     b00:	00001717          	auipc	a4,0x1
     b04:	50070713          	addi	a4,a4,1280 # 2000 <rand_next>
     b08:	631c                	ld	a5,0(a4)
     b0a:	01f7c793          	xori	a5,a5,31
     b0e:	e31c                	sd	a5,0(a4)
    go(0);
     b10:	4501                	li	a0,0
     b12:	fffff097          	auipc	ra,0xfffff
     b16:	566080e7          	jalr	1382(ra) # 78 <go>
    printf("grind: fork failed\n");
     b1a:	00001517          	auipc	a0,0x1
     b1e:	9c650513          	addi	a0,a0,-1594 # 14e0 <malloc+0x1e8>
     b22:	00000097          	auipc	ra,0x0
     b26:	718080e7          	jalr	1816(ra) # 123a <printf>
    exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00000097          	auipc	ra,0x0
     b30:	386080e7          	jalr	902(ra) # eb2 <exit>
    exit(0);
  }

  int pid2 = fork();
     b34:	00000097          	auipc	ra,0x0
     b38:	376080e7          	jalr	886(ra) # eaa <fork>
     b3c:	892a                	mv	s2,a0
  if(pid2 < 0){
     b3e:	02054263          	bltz	a0,b62 <iter+0x9e>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b42:	ed0d                	bnez	a0,b7c <iter+0xb8>
    rand_next ^= 7177;
     b44:	00001697          	auipc	a3,0x1
     b48:	4bc68693          	addi	a3,a3,1212 # 2000 <rand_next>
     b4c:	629c                	ld	a5,0(a3)
     b4e:	6709                	lui	a4,0x2
     b50:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x539>
     b54:	8fb9                	xor	a5,a5,a4
     b56:	e29c                	sd	a5,0(a3)
    go(1);
     b58:	4505                	li	a0,1
     b5a:	fffff097          	auipc	ra,0xfffff
     b5e:	51e080e7          	jalr	1310(ra) # 78 <go>
    printf("grind: fork failed\n");
     b62:	00001517          	auipc	a0,0x1
     b66:	97e50513          	addi	a0,a0,-1666 # 14e0 <malloc+0x1e8>
     b6a:	00000097          	auipc	ra,0x0
     b6e:	6d0080e7          	jalr	1744(ra) # 123a <printf>
    exit(1);
     b72:	4505                	li	a0,1
     b74:	00000097          	auipc	ra,0x0
     b78:	33e080e7          	jalr	830(ra) # eb2 <exit>
    exit(0);
  }

  int st1 = -1;
     b7c:	57fd                	li	a5,-1
     b7e:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b82:	fdc40513          	addi	a0,s0,-36
     b86:	00000097          	auipc	ra,0x0
     b8a:	334080e7          	jalr	820(ra) # eba <wait>
  if(st1 != 0){
     b8e:	fdc42783          	lw	a5,-36(s0)
     b92:	ef99                	bnez	a5,bb0 <iter+0xec>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b94:	57fd                	li	a5,-1
     b96:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b9a:	fd840513          	addi	a0,s0,-40
     b9e:	00000097          	auipc	ra,0x0
     ba2:	31c080e7          	jalr	796(ra) # eba <wait>

  exit(0);
     ba6:	4501                	li	a0,0
     ba8:	00000097          	auipc	ra,0x0
     bac:	30a080e7          	jalr	778(ra) # eb2 <exit>
    kill(pid1);
     bb0:	8526                	mv	a0,s1
     bb2:	00000097          	auipc	ra,0x0
     bb6:	330080e7          	jalr	816(ra) # ee2 <kill>
    kill(pid2);
     bba:	854a                	mv	a0,s2
     bbc:	00000097          	auipc	ra,0x0
     bc0:	326080e7          	jalr	806(ra) # ee2 <kill>
     bc4:	bfc1                	j	b94 <iter+0xd0>

0000000000000bc6 <main>:
}

int
main()
{
     bc6:	1101                	addi	sp,sp,-32
     bc8:	ec06                	sd	ra,24(sp)
     bca:	e822                	sd	s0,16(sp)
     bcc:	e426                	sd	s1,8(sp)
     bce:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     bd0:	00001497          	auipc	s1,0x1
     bd4:	43048493          	addi	s1,s1,1072 # 2000 <rand_next>
     bd8:	a829                	j	bf2 <main+0x2c>
      iter();
     bda:	00000097          	auipc	ra,0x0
     bde:	eea080e7          	jalr	-278(ra) # ac4 <iter>
    sleep(20);
     be2:	4551                	li	a0,20
     be4:	00000097          	auipc	ra,0x0
     be8:	35e080e7          	jalr	862(ra) # f42 <sleep>
    rand_next += 1;
     bec:	609c                	ld	a5,0(s1)
     bee:	0785                	addi	a5,a5,1
     bf0:	e09c                	sd	a5,0(s1)
    int pid = fork();
     bf2:	00000097          	auipc	ra,0x0
     bf6:	2b8080e7          	jalr	696(ra) # eaa <fork>
    if(pid == 0){
     bfa:	d165                	beqz	a0,bda <main+0x14>
    if(pid > 0){
     bfc:	fea053e3          	blez	a0,be2 <main+0x1c>
      wait(0);
     c00:	4501                	li	a0,0
     c02:	00000097          	auipc	ra,0x0
     c06:	2b8080e7          	jalr	696(ra) # eba <wait>
     c0a:	bfe1                	j	be2 <main+0x1c>

0000000000000c0c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     c0c:	1141                	addi	sp,sp,-16
     c0e:	e406                	sd	ra,8(sp)
     c10:	e022                	sd	s0,0(sp)
     c12:	0800                	addi	s0,sp,16
  extern int main();
  main();
     c14:	00000097          	auipc	ra,0x0
     c18:	fb2080e7          	jalr	-78(ra) # bc6 <main>
  exit(0);
     c1c:	4501                	li	a0,0
     c1e:	00000097          	auipc	ra,0x0
     c22:	294080e7          	jalr	660(ra) # eb2 <exit>

0000000000000c26 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c26:	1141                	addi	sp,sp,-16
     c28:	e422                	sd	s0,8(sp)
     c2a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c2c:	87aa                	mv	a5,a0
     c2e:	0585                	addi	a1,a1,1
     c30:	0785                	addi	a5,a5,1
     c32:	fff5c703          	lbu	a4,-1(a1)
     c36:	fee78fa3          	sb	a4,-1(a5)
     c3a:	fb75                	bnez	a4,c2e <strcpy+0x8>
    ;
  return os;
}
     c3c:	6422                	ld	s0,8(sp)
     c3e:	0141                	addi	sp,sp,16
     c40:	8082                	ret

0000000000000c42 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c42:	1141                	addi	sp,sp,-16
     c44:	e422                	sd	s0,8(sp)
     c46:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c48:	00054783          	lbu	a5,0(a0)
     c4c:	cb91                	beqz	a5,c60 <strcmp+0x1e>
     c4e:	0005c703          	lbu	a4,0(a1)
     c52:	00f71763          	bne	a4,a5,c60 <strcmp+0x1e>
    p++, q++;
     c56:	0505                	addi	a0,a0,1
     c58:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c5a:	00054783          	lbu	a5,0(a0)
     c5e:	fbe5                	bnez	a5,c4e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c60:	0005c503          	lbu	a0,0(a1)
}
     c64:	40a7853b          	subw	a0,a5,a0
     c68:	6422                	ld	s0,8(sp)
     c6a:	0141                	addi	sp,sp,16
     c6c:	8082                	ret

0000000000000c6e <strlen>:

uint
strlen(const char *s)
{
     c6e:	1141                	addi	sp,sp,-16
     c70:	e422                	sd	s0,8(sp)
     c72:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c74:	00054783          	lbu	a5,0(a0)
     c78:	cf91                	beqz	a5,c94 <strlen+0x26>
     c7a:	0505                	addi	a0,a0,1
     c7c:	87aa                	mv	a5,a0
     c7e:	4685                	li	a3,1
     c80:	9e89                	subw	a3,a3,a0
     c82:	00f6853b          	addw	a0,a3,a5
     c86:	0785                	addi	a5,a5,1
     c88:	fff7c703          	lbu	a4,-1(a5)
     c8c:	fb7d                	bnez	a4,c82 <strlen+0x14>
    ;
  return n;
}
     c8e:	6422                	ld	s0,8(sp)
     c90:	0141                	addi	sp,sp,16
     c92:	8082                	ret
  for(n = 0; s[n]; n++)
     c94:	4501                	li	a0,0
     c96:	bfe5                	j	c8e <strlen+0x20>

0000000000000c98 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c98:	1141                	addi	sp,sp,-16
     c9a:	e422                	sd	s0,8(sp)
     c9c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c9e:	ce09                	beqz	a2,cb8 <memset+0x20>
     ca0:	87aa                	mv	a5,a0
     ca2:	fff6071b          	addiw	a4,a2,-1
     ca6:	1702                	slli	a4,a4,0x20
     ca8:	9301                	srli	a4,a4,0x20
     caa:	0705                	addi	a4,a4,1
     cac:	972a                	add	a4,a4,a0
    cdst[i] = c;
     cae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     cb2:	0785                	addi	a5,a5,1
     cb4:	fee79de3          	bne	a5,a4,cae <memset+0x16>
  }
  return dst;
}
     cb8:	6422                	ld	s0,8(sp)
     cba:	0141                	addi	sp,sp,16
     cbc:	8082                	ret

0000000000000cbe <strchr>:

char*
strchr(const char *s, char c)
{
     cbe:	1141                	addi	sp,sp,-16
     cc0:	e422                	sd	s0,8(sp)
     cc2:	0800                	addi	s0,sp,16
  for(; *s; s++)
     cc4:	00054783          	lbu	a5,0(a0)
     cc8:	cb99                	beqz	a5,cde <strchr+0x20>
    if(*s == c)
     cca:	00f58763          	beq	a1,a5,cd8 <strchr+0x1a>
  for(; *s; s++)
     cce:	0505                	addi	a0,a0,1
     cd0:	00054783          	lbu	a5,0(a0)
     cd4:	fbfd                	bnez	a5,cca <strchr+0xc>
      return (char*)s;
  return 0;
     cd6:	4501                	li	a0,0
}
     cd8:	6422                	ld	s0,8(sp)
     cda:	0141                	addi	sp,sp,16
     cdc:	8082                	ret
  return 0;
     cde:	4501                	li	a0,0
     ce0:	bfe5                	j	cd8 <strchr+0x1a>

0000000000000ce2 <gets>:

char*
gets(char *buf, int max)
{
     ce2:	711d                	addi	sp,sp,-96
     ce4:	ec86                	sd	ra,88(sp)
     ce6:	e8a2                	sd	s0,80(sp)
     ce8:	e4a6                	sd	s1,72(sp)
     cea:	e0ca                	sd	s2,64(sp)
     cec:	fc4e                	sd	s3,56(sp)
     cee:	f852                	sd	s4,48(sp)
     cf0:	f456                	sd	s5,40(sp)
     cf2:	f05a                	sd	s6,32(sp)
     cf4:	ec5e                	sd	s7,24(sp)
     cf6:	1080                	addi	s0,sp,96
     cf8:	8baa                	mv	s7,a0
     cfa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cfc:	892a                	mv	s2,a0
     cfe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     d00:	4aa9                	li	s5,10
     d02:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     d04:	89a6                	mv	s3,s1
     d06:	2485                	addiw	s1,s1,1
     d08:	0344d863          	bge	s1,s4,d38 <gets+0x56>
    cc = read(0, &c, 1);
     d0c:	4605                	li	a2,1
     d0e:	faf40593          	addi	a1,s0,-81
     d12:	4501                	li	a0,0
     d14:	00000097          	auipc	ra,0x0
     d18:	1b6080e7          	jalr	438(ra) # eca <read>
    if(cc < 1)
     d1c:	00a05e63          	blez	a0,d38 <gets+0x56>
    buf[i++] = c;
     d20:	faf44783          	lbu	a5,-81(s0)
     d24:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d28:	01578763          	beq	a5,s5,d36 <gets+0x54>
     d2c:	0905                	addi	s2,s2,1
     d2e:	fd679be3          	bne	a5,s6,d04 <gets+0x22>
  for(i=0; i+1 < max; ){
     d32:	89a6                	mv	s3,s1
     d34:	a011                	j	d38 <gets+0x56>
     d36:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     d38:	99de                	add	s3,s3,s7
     d3a:	00098023          	sb	zero,0(s3)
  return buf;
}
     d3e:	855e                	mv	a0,s7
     d40:	60e6                	ld	ra,88(sp)
     d42:	6446                	ld	s0,80(sp)
     d44:	64a6                	ld	s1,72(sp)
     d46:	6906                	ld	s2,64(sp)
     d48:	79e2                	ld	s3,56(sp)
     d4a:	7a42                	ld	s4,48(sp)
     d4c:	7aa2                	ld	s5,40(sp)
     d4e:	7b02                	ld	s6,32(sp)
     d50:	6be2                	ld	s7,24(sp)
     d52:	6125                	addi	sp,sp,96
     d54:	8082                	ret

0000000000000d56 <stat>:

int
stat(const char *n, struct stat *st)
{
     d56:	1101                	addi	sp,sp,-32
     d58:	ec06                	sd	ra,24(sp)
     d5a:	e822                	sd	s0,16(sp)
     d5c:	e426                	sd	s1,8(sp)
     d5e:	e04a                	sd	s2,0(sp)
     d60:	1000                	addi	s0,sp,32
     d62:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d64:	4581                	li	a1,0
     d66:	00000097          	auipc	ra,0x0
     d6a:	18c080e7          	jalr	396(ra) # ef2 <open>
  if(fd < 0)
     d6e:	02054563          	bltz	a0,d98 <stat+0x42>
     d72:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d74:	85ca                	mv	a1,s2
     d76:	00000097          	auipc	ra,0x0
     d7a:	194080e7          	jalr	404(ra) # f0a <fstat>
     d7e:	892a                	mv	s2,a0
  close(fd);
     d80:	8526                	mv	a0,s1
     d82:	00000097          	auipc	ra,0x0
     d86:	158080e7          	jalr	344(ra) # eda <close>
  return r;
}
     d8a:	854a                	mv	a0,s2
     d8c:	60e2                	ld	ra,24(sp)
     d8e:	6442                	ld	s0,16(sp)
     d90:	64a2                	ld	s1,8(sp)
     d92:	6902                	ld	s2,0(sp)
     d94:	6105                	addi	sp,sp,32
     d96:	8082                	ret
    return -1;
     d98:	597d                	li	s2,-1
     d9a:	bfc5                	j	d8a <stat+0x34>

0000000000000d9c <atoi>:

int
atoi(const char *s)
{
     d9c:	1141                	addi	sp,sp,-16
     d9e:	e422                	sd	s0,8(sp)
     da0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     da2:	00054603          	lbu	a2,0(a0)
     da6:	fd06079b          	addiw	a5,a2,-48
     daa:	0ff7f793          	andi	a5,a5,255
     dae:	4725                	li	a4,9
     db0:	02f76963          	bltu	a4,a5,de2 <atoi+0x46>
     db4:	86aa                	mv	a3,a0
  n = 0;
     db6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     db8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     dba:	0685                	addi	a3,a3,1
     dbc:	0025179b          	slliw	a5,a0,0x2
     dc0:	9fa9                	addw	a5,a5,a0
     dc2:	0017979b          	slliw	a5,a5,0x1
     dc6:	9fb1                	addw	a5,a5,a2
     dc8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     dcc:	0006c603          	lbu	a2,0(a3)
     dd0:	fd06071b          	addiw	a4,a2,-48
     dd4:	0ff77713          	andi	a4,a4,255
     dd8:	fee5f1e3          	bgeu	a1,a4,dba <atoi+0x1e>
  return n;
}
     ddc:	6422                	ld	s0,8(sp)
     dde:	0141                	addi	sp,sp,16
     de0:	8082                	ret
  n = 0;
     de2:	4501                	li	a0,0
     de4:	bfe5                	j	ddc <atoi+0x40>

0000000000000de6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     de6:	1141                	addi	sp,sp,-16
     de8:	e422                	sd	s0,8(sp)
     dea:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     dec:	02b57663          	bgeu	a0,a1,e18 <memmove+0x32>
    while(n-- > 0)
     df0:	02c05163          	blez	a2,e12 <memmove+0x2c>
     df4:	fff6079b          	addiw	a5,a2,-1
     df8:	1782                	slli	a5,a5,0x20
     dfa:	9381                	srli	a5,a5,0x20
     dfc:	0785                	addi	a5,a5,1
     dfe:	97aa                	add	a5,a5,a0
  dst = vdst;
     e00:	872a                	mv	a4,a0
      *dst++ = *src++;
     e02:	0585                	addi	a1,a1,1
     e04:	0705                	addi	a4,a4,1
     e06:	fff5c683          	lbu	a3,-1(a1)
     e0a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e0e:	fee79ae3          	bne	a5,a4,e02 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e12:	6422                	ld	s0,8(sp)
     e14:	0141                	addi	sp,sp,16
     e16:	8082                	ret
    dst += n;
     e18:	00c50733          	add	a4,a0,a2
    src += n;
     e1c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e1e:	fec05ae3          	blez	a2,e12 <memmove+0x2c>
     e22:	fff6079b          	addiw	a5,a2,-1
     e26:	1782                	slli	a5,a5,0x20
     e28:	9381                	srli	a5,a5,0x20
     e2a:	fff7c793          	not	a5,a5
     e2e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e30:	15fd                	addi	a1,a1,-1
     e32:	177d                	addi	a4,a4,-1
     e34:	0005c683          	lbu	a3,0(a1)
     e38:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e3c:	fee79ae3          	bne	a5,a4,e30 <memmove+0x4a>
     e40:	bfc9                	j	e12 <memmove+0x2c>

0000000000000e42 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e42:	1141                	addi	sp,sp,-16
     e44:	e422                	sd	s0,8(sp)
     e46:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e48:	ca05                	beqz	a2,e78 <memcmp+0x36>
     e4a:	fff6069b          	addiw	a3,a2,-1
     e4e:	1682                	slli	a3,a3,0x20
     e50:	9281                	srli	a3,a3,0x20
     e52:	0685                	addi	a3,a3,1
     e54:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e56:	00054783          	lbu	a5,0(a0)
     e5a:	0005c703          	lbu	a4,0(a1)
     e5e:	00e79863          	bne	a5,a4,e6e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e62:	0505                	addi	a0,a0,1
    p2++;
     e64:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e66:	fed518e3          	bne	a0,a3,e56 <memcmp+0x14>
  }
  return 0;
     e6a:	4501                	li	a0,0
     e6c:	a019                	j	e72 <memcmp+0x30>
      return *p1 - *p2;
     e6e:	40e7853b          	subw	a0,a5,a4
}
     e72:	6422                	ld	s0,8(sp)
     e74:	0141                	addi	sp,sp,16
     e76:	8082                	ret
  return 0;
     e78:	4501                	li	a0,0
     e7a:	bfe5                	j	e72 <memcmp+0x30>

0000000000000e7c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e7c:	1141                	addi	sp,sp,-16
     e7e:	e406                	sd	ra,8(sp)
     e80:	e022                	sd	s0,0(sp)
     e82:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e84:	00000097          	auipc	ra,0x0
     e88:	f62080e7          	jalr	-158(ra) # de6 <memmove>
}
     e8c:	60a2                	ld	ra,8(sp)
     e8e:	6402                	ld	s0,0(sp)
     e90:	0141                	addi	sp,sp,16
     e92:	8082                	ret

0000000000000e94 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
     e94:	1141                	addi	sp,sp,-16
     e96:	e422                	sd	s0,8(sp)
     e98:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
     e9a:	040007b7          	lui	a5,0x4000
}
     e9e:	17f5                	addi	a5,a5,-3
     ea0:	07b2                	slli	a5,a5,0xc
     ea2:	4388                	lw	a0,0(a5)
     ea4:	6422                	ld	s0,8(sp)
     ea6:	0141                	addi	sp,sp,16
     ea8:	8082                	ret

0000000000000eaa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     eaa:	4885                	li	a7,1
 ecall
     eac:	00000073          	ecall
 ret
     eb0:	8082                	ret

0000000000000eb2 <exit>:
.global exit
exit:
 li a7, SYS_exit
     eb2:	4889                	li	a7,2
 ecall
     eb4:	00000073          	ecall
 ret
     eb8:	8082                	ret

0000000000000eba <wait>:
.global wait
wait:
 li a7, SYS_wait
     eba:	488d                	li	a7,3
 ecall
     ebc:	00000073          	ecall
 ret
     ec0:	8082                	ret

0000000000000ec2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ec2:	4891                	li	a7,4
 ecall
     ec4:	00000073          	ecall
 ret
     ec8:	8082                	ret

0000000000000eca <read>:
.global read
read:
 li a7, SYS_read
     eca:	4895                	li	a7,5
 ecall
     ecc:	00000073          	ecall
 ret
     ed0:	8082                	ret

0000000000000ed2 <write>:
.global write
write:
 li a7, SYS_write
     ed2:	48c1                	li	a7,16
 ecall
     ed4:	00000073          	ecall
 ret
     ed8:	8082                	ret

0000000000000eda <close>:
.global close
close:
 li a7, SYS_close
     eda:	48d5                	li	a7,21
 ecall
     edc:	00000073          	ecall
 ret
     ee0:	8082                	ret

0000000000000ee2 <kill>:
.global kill
kill:
 li a7, SYS_kill
     ee2:	4899                	li	a7,6
 ecall
     ee4:	00000073          	ecall
 ret
     ee8:	8082                	ret

0000000000000eea <exec>:
.global exec
exec:
 li a7, SYS_exec
     eea:	489d                	li	a7,7
 ecall
     eec:	00000073          	ecall
 ret
     ef0:	8082                	ret

0000000000000ef2 <open>:
.global open
open:
 li a7, SYS_open
     ef2:	48bd                	li	a7,15
 ecall
     ef4:	00000073          	ecall
 ret
     ef8:	8082                	ret

0000000000000efa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     efa:	48c5                	li	a7,17
 ecall
     efc:	00000073          	ecall
 ret
     f00:	8082                	ret

0000000000000f02 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f02:	48c9                	li	a7,18
 ecall
     f04:	00000073          	ecall
 ret
     f08:	8082                	ret

0000000000000f0a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f0a:	48a1                	li	a7,8
 ecall
     f0c:	00000073          	ecall
 ret
     f10:	8082                	ret

0000000000000f12 <link>:
.global link
link:
 li a7, SYS_link
     f12:	48cd                	li	a7,19
 ecall
     f14:	00000073          	ecall
 ret
     f18:	8082                	ret

0000000000000f1a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f1a:	48d1                	li	a7,20
 ecall
     f1c:	00000073          	ecall
 ret
     f20:	8082                	ret

0000000000000f22 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f22:	48a5                	li	a7,9
 ecall
     f24:	00000073          	ecall
 ret
     f28:	8082                	ret

0000000000000f2a <dup>:
.global dup
dup:
 li a7, SYS_dup
     f2a:	48a9                	li	a7,10
 ecall
     f2c:	00000073          	ecall
 ret
     f30:	8082                	ret

0000000000000f32 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f32:	48ad                	li	a7,11
 ecall
     f34:	00000073          	ecall
 ret
     f38:	8082                	ret

0000000000000f3a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f3a:	48b1                	li	a7,12
 ecall
     f3c:	00000073          	ecall
 ret
     f40:	8082                	ret

0000000000000f42 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f42:	48b5                	li	a7,13
 ecall
     f44:	00000073          	ecall
 ret
     f48:	8082                	ret

0000000000000f4a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f4a:	48b9                	li	a7,14
 ecall
     f4c:	00000073          	ecall
 ret
     f50:	8082                	ret

0000000000000f52 <connect>:
.global connect
connect:
 li a7, SYS_connect
     f52:	48f5                	li	a7,29
 ecall
     f54:	00000073          	ecall
 ret
     f58:	8082                	ret

0000000000000f5a <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     f5a:	48f9                	li	a7,30
 ecall
     f5c:	00000073          	ecall
 ret
     f60:	8082                	ret

0000000000000f62 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f62:	1101                	addi	sp,sp,-32
     f64:	ec06                	sd	ra,24(sp)
     f66:	e822                	sd	s0,16(sp)
     f68:	1000                	addi	s0,sp,32
     f6a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f6e:	4605                	li	a2,1
     f70:	fef40593          	addi	a1,s0,-17
     f74:	00000097          	auipc	ra,0x0
     f78:	f5e080e7          	jalr	-162(ra) # ed2 <write>
}
     f7c:	60e2                	ld	ra,24(sp)
     f7e:	6442                	ld	s0,16(sp)
     f80:	6105                	addi	sp,sp,32
     f82:	8082                	ret

0000000000000f84 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f84:	7139                	addi	sp,sp,-64
     f86:	fc06                	sd	ra,56(sp)
     f88:	f822                	sd	s0,48(sp)
     f8a:	f426                	sd	s1,40(sp)
     f8c:	f04a                	sd	s2,32(sp)
     f8e:	ec4e                	sd	s3,24(sp)
     f90:	0080                	addi	s0,sp,64
     f92:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f94:	c299                	beqz	a3,f9a <printint+0x16>
     f96:	0805c863          	bltz	a1,1026 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f9a:	2581                	sext.w	a1,a1
  neg = 0;
     f9c:	4881                	li	a7,0
     f9e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     fa2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     fa4:	2601                	sext.w	a2,a2
     fa6:	00000517          	auipc	a0,0x0
     faa:	72a50513          	addi	a0,a0,1834 # 16d0 <digits>
     fae:	883a                	mv	a6,a4
     fb0:	2705                	addiw	a4,a4,1
     fb2:	02c5f7bb          	remuw	a5,a1,a2
     fb6:	1782                	slli	a5,a5,0x20
     fb8:	9381                	srli	a5,a5,0x20
     fba:	97aa                	add	a5,a5,a0
     fbc:	0007c783          	lbu	a5,0(a5) # 4000000 <base+0x3ffdbf8>
     fc0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     fc4:	0005879b          	sext.w	a5,a1
     fc8:	02c5d5bb          	divuw	a1,a1,a2
     fcc:	0685                	addi	a3,a3,1
     fce:	fec7f0e3          	bgeu	a5,a2,fae <printint+0x2a>
  if(neg)
     fd2:	00088b63          	beqz	a7,fe8 <printint+0x64>
    buf[i++] = '-';
     fd6:	fd040793          	addi	a5,s0,-48
     fda:	973e                	add	a4,a4,a5
     fdc:	02d00793          	li	a5,45
     fe0:	fef70823          	sb	a5,-16(a4)
     fe4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     fe8:	02e05863          	blez	a4,1018 <printint+0x94>
     fec:	fc040793          	addi	a5,s0,-64
     ff0:	00e78933          	add	s2,a5,a4
     ff4:	fff78993          	addi	s3,a5,-1
     ff8:	99ba                	add	s3,s3,a4
     ffa:	377d                	addiw	a4,a4,-1
     ffc:	1702                	slli	a4,a4,0x20
     ffe:	9301                	srli	a4,a4,0x20
    1000:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1004:	fff94583          	lbu	a1,-1(s2)
    1008:	8526                	mv	a0,s1
    100a:	00000097          	auipc	ra,0x0
    100e:	f58080e7          	jalr	-168(ra) # f62 <putc>
  while(--i >= 0)
    1012:	197d                	addi	s2,s2,-1
    1014:	ff3918e3          	bne	s2,s3,1004 <printint+0x80>
}
    1018:	70e2                	ld	ra,56(sp)
    101a:	7442                	ld	s0,48(sp)
    101c:	74a2                	ld	s1,40(sp)
    101e:	7902                	ld	s2,32(sp)
    1020:	69e2                	ld	s3,24(sp)
    1022:	6121                	addi	sp,sp,64
    1024:	8082                	ret
    x = -xx;
    1026:	40b005bb          	negw	a1,a1
    neg = 1;
    102a:	4885                	li	a7,1
    x = -xx;
    102c:	bf8d                	j	f9e <printint+0x1a>

000000000000102e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    102e:	7119                	addi	sp,sp,-128
    1030:	fc86                	sd	ra,120(sp)
    1032:	f8a2                	sd	s0,112(sp)
    1034:	f4a6                	sd	s1,104(sp)
    1036:	f0ca                	sd	s2,96(sp)
    1038:	ecce                	sd	s3,88(sp)
    103a:	e8d2                	sd	s4,80(sp)
    103c:	e4d6                	sd	s5,72(sp)
    103e:	e0da                	sd	s6,64(sp)
    1040:	fc5e                	sd	s7,56(sp)
    1042:	f862                	sd	s8,48(sp)
    1044:	f466                	sd	s9,40(sp)
    1046:	f06a                	sd	s10,32(sp)
    1048:	ec6e                	sd	s11,24(sp)
    104a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    104c:	0005c903          	lbu	s2,0(a1)
    1050:	18090f63          	beqz	s2,11ee <vprintf+0x1c0>
    1054:	8aaa                	mv	s5,a0
    1056:	8b32                	mv	s6,a2
    1058:	00158493          	addi	s1,a1,1
  state = 0;
    105c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    105e:	02500a13          	li	s4,37
      if(c == 'd'){
    1062:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1066:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    106a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    106e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1072:	00000b97          	auipc	s7,0x0
    1076:	65eb8b93          	addi	s7,s7,1630 # 16d0 <digits>
    107a:	a839                	j	1098 <vprintf+0x6a>
        putc(fd, c);
    107c:	85ca                	mv	a1,s2
    107e:	8556                	mv	a0,s5
    1080:	00000097          	auipc	ra,0x0
    1084:	ee2080e7          	jalr	-286(ra) # f62 <putc>
    1088:	a019                	j	108e <vprintf+0x60>
    } else if(state == '%'){
    108a:	01498f63          	beq	s3,s4,10a8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    108e:	0485                	addi	s1,s1,1
    1090:	fff4c903          	lbu	s2,-1(s1)
    1094:	14090d63          	beqz	s2,11ee <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1098:	0009079b          	sext.w	a5,s2
    if(state == 0){
    109c:	fe0997e3          	bnez	s3,108a <vprintf+0x5c>
      if(c == '%'){
    10a0:	fd479ee3          	bne	a5,s4,107c <vprintf+0x4e>
        state = '%';
    10a4:	89be                	mv	s3,a5
    10a6:	b7e5                	j	108e <vprintf+0x60>
      if(c == 'd'){
    10a8:	05878063          	beq	a5,s8,10e8 <vprintf+0xba>
      } else if(c == 'l') {
    10ac:	05978c63          	beq	a5,s9,1104 <vprintf+0xd6>
      } else if(c == 'x') {
    10b0:	07a78863          	beq	a5,s10,1120 <vprintf+0xf2>
      } else if(c == 'p') {
    10b4:	09b78463          	beq	a5,s11,113c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    10b8:	07300713          	li	a4,115
    10bc:	0ce78663          	beq	a5,a4,1188 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    10c0:	06300713          	li	a4,99
    10c4:	0ee78e63          	beq	a5,a4,11c0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    10c8:	11478863          	beq	a5,s4,11d8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    10cc:	85d2                	mv	a1,s4
    10ce:	8556                	mv	a0,s5
    10d0:	00000097          	auipc	ra,0x0
    10d4:	e92080e7          	jalr	-366(ra) # f62 <putc>
        putc(fd, c);
    10d8:	85ca                	mv	a1,s2
    10da:	8556                	mv	a0,s5
    10dc:	00000097          	auipc	ra,0x0
    10e0:	e86080e7          	jalr	-378(ra) # f62 <putc>
      }
      state = 0;
    10e4:	4981                	li	s3,0
    10e6:	b765                	j	108e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    10e8:	008b0913          	addi	s2,s6,8
    10ec:	4685                	li	a3,1
    10ee:	4629                	li	a2,10
    10f0:	000b2583          	lw	a1,0(s6)
    10f4:	8556                	mv	a0,s5
    10f6:	00000097          	auipc	ra,0x0
    10fa:	e8e080e7          	jalr	-370(ra) # f84 <printint>
    10fe:	8b4a                	mv	s6,s2
      state = 0;
    1100:	4981                	li	s3,0
    1102:	b771                	j	108e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1104:	008b0913          	addi	s2,s6,8
    1108:	4681                	li	a3,0
    110a:	4629                	li	a2,10
    110c:	000b2583          	lw	a1,0(s6)
    1110:	8556                	mv	a0,s5
    1112:	00000097          	auipc	ra,0x0
    1116:	e72080e7          	jalr	-398(ra) # f84 <printint>
    111a:	8b4a                	mv	s6,s2
      state = 0;
    111c:	4981                	li	s3,0
    111e:	bf85                	j	108e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1120:	008b0913          	addi	s2,s6,8
    1124:	4681                	li	a3,0
    1126:	4641                	li	a2,16
    1128:	000b2583          	lw	a1,0(s6)
    112c:	8556                	mv	a0,s5
    112e:	00000097          	auipc	ra,0x0
    1132:	e56080e7          	jalr	-426(ra) # f84 <printint>
    1136:	8b4a                	mv	s6,s2
      state = 0;
    1138:	4981                	li	s3,0
    113a:	bf91                	j	108e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    113c:	008b0793          	addi	a5,s6,8
    1140:	f8f43423          	sd	a5,-120(s0)
    1144:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1148:	03000593          	li	a1,48
    114c:	8556                	mv	a0,s5
    114e:	00000097          	auipc	ra,0x0
    1152:	e14080e7          	jalr	-492(ra) # f62 <putc>
  putc(fd, 'x');
    1156:	85ea                	mv	a1,s10
    1158:	8556                	mv	a0,s5
    115a:	00000097          	auipc	ra,0x0
    115e:	e08080e7          	jalr	-504(ra) # f62 <putc>
    1162:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1164:	03c9d793          	srli	a5,s3,0x3c
    1168:	97de                	add	a5,a5,s7
    116a:	0007c583          	lbu	a1,0(a5)
    116e:	8556                	mv	a0,s5
    1170:	00000097          	auipc	ra,0x0
    1174:	df2080e7          	jalr	-526(ra) # f62 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1178:	0992                	slli	s3,s3,0x4
    117a:	397d                	addiw	s2,s2,-1
    117c:	fe0914e3          	bnez	s2,1164 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1180:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1184:	4981                	li	s3,0
    1186:	b721                	j	108e <vprintf+0x60>
        s = va_arg(ap, char*);
    1188:	008b0993          	addi	s3,s6,8
    118c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1190:	02090163          	beqz	s2,11b2 <vprintf+0x184>
        while(*s != 0){
    1194:	00094583          	lbu	a1,0(s2)
    1198:	c9a1                	beqz	a1,11e8 <vprintf+0x1ba>
          putc(fd, *s);
    119a:	8556                	mv	a0,s5
    119c:	00000097          	auipc	ra,0x0
    11a0:	dc6080e7          	jalr	-570(ra) # f62 <putc>
          s++;
    11a4:	0905                	addi	s2,s2,1
        while(*s != 0){
    11a6:	00094583          	lbu	a1,0(s2)
    11aa:	f9e5                	bnez	a1,119a <vprintf+0x16c>
        s = va_arg(ap, char*);
    11ac:	8b4e                	mv	s6,s3
      state = 0;
    11ae:	4981                	li	s3,0
    11b0:	bdf9                	j	108e <vprintf+0x60>
          s = "(null)";
    11b2:	00000917          	auipc	s2,0x0
    11b6:	51690913          	addi	s2,s2,1302 # 16c8 <malloc+0x3d0>
        while(*s != 0){
    11ba:	02800593          	li	a1,40
    11be:	bff1                	j	119a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    11c0:	008b0913          	addi	s2,s6,8
    11c4:	000b4583          	lbu	a1,0(s6)
    11c8:	8556                	mv	a0,s5
    11ca:	00000097          	auipc	ra,0x0
    11ce:	d98080e7          	jalr	-616(ra) # f62 <putc>
    11d2:	8b4a                	mv	s6,s2
      state = 0;
    11d4:	4981                	li	s3,0
    11d6:	bd65                	j	108e <vprintf+0x60>
        putc(fd, c);
    11d8:	85d2                	mv	a1,s4
    11da:	8556                	mv	a0,s5
    11dc:	00000097          	auipc	ra,0x0
    11e0:	d86080e7          	jalr	-634(ra) # f62 <putc>
      state = 0;
    11e4:	4981                	li	s3,0
    11e6:	b565                	j	108e <vprintf+0x60>
        s = va_arg(ap, char*);
    11e8:	8b4e                	mv	s6,s3
      state = 0;
    11ea:	4981                	li	s3,0
    11ec:	b54d                	j	108e <vprintf+0x60>
    }
  }
}
    11ee:	70e6                	ld	ra,120(sp)
    11f0:	7446                	ld	s0,112(sp)
    11f2:	74a6                	ld	s1,104(sp)
    11f4:	7906                	ld	s2,96(sp)
    11f6:	69e6                	ld	s3,88(sp)
    11f8:	6a46                	ld	s4,80(sp)
    11fa:	6aa6                	ld	s5,72(sp)
    11fc:	6b06                	ld	s6,64(sp)
    11fe:	7be2                	ld	s7,56(sp)
    1200:	7c42                	ld	s8,48(sp)
    1202:	7ca2                	ld	s9,40(sp)
    1204:	7d02                	ld	s10,32(sp)
    1206:	6de2                	ld	s11,24(sp)
    1208:	6109                	addi	sp,sp,128
    120a:	8082                	ret

000000000000120c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    120c:	715d                	addi	sp,sp,-80
    120e:	ec06                	sd	ra,24(sp)
    1210:	e822                	sd	s0,16(sp)
    1212:	1000                	addi	s0,sp,32
    1214:	e010                	sd	a2,0(s0)
    1216:	e414                	sd	a3,8(s0)
    1218:	e818                	sd	a4,16(s0)
    121a:	ec1c                	sd	a5,24(s0)
    121c:	03043023          	sd	a6,32(s0)
    1220:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1224:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1228:	8622                	mv	a2,s0
    122a:	00000097          	auipc	ra,0x0
    122e:	e04080e7          	jalr	-508(ra) # 102e <vprintf>
}
    1232:	60e2                	ld	ra,24(sp)
    1234:	6442                	ld	s0,16(sp)
    1236:	6161                	addi	sp,sp,80
    1238:	8082                	ret

000000000000123a <printf>:

void
printf(const char *fmt, ...)
{
    123a:	711d                	addi	sp,sp,-96
    123c:	ec06                	sd	ra,24(sp)
    123e:	e822                	sd	s0,16(sp)
    1240:	1000                	addi	s0,sp,32
    1242:	e40c                	sd	a1,8(s0)
    1244:	e810                	sd	a2,16(s0)
    1246:	ec14                	sd	a3,24(s0)
    1248:	f018                	sd	a4,32(s0)
    124a:	f41c                	sd	a5,40(s0)
    124c:	03043823          	sd	a6,48(s0)
    1250:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1254:	00840613          	addi	a2,s0,8
    1258:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    125c:	85aa                	mv	a1,a0
    125e:	4505                	li	a0,1
    1260:	00000097          	auipc	ra,0x0
    1264:	dce080e7          	jalr	-562(ra) # 102e <vprintf>
}
    1268:	60e2                	ld	ra,24(sp)
    126a:	6442                	ld	s0,16(sp)
    126c:	6125                	addi	sp,sp,96
    126e:	8082                	ret

0000000000001270 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1270:	1141                	addi	sp,sp,-16
    1272:	e422                	sd	s0,8(sp)
    1274:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1276:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    127a:	00001797          	auipc	a5,0x1
    127e:	d967b783          	ld	a5,-618(a5) # 2010 <freep>
    1282:	a805                	j	12b2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1284:	4618                	lw	a4,8(a2)
    1286:	9db9                	addw	a1,a1,a4
    1288:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    128c:	6398                	ld	a4,0(a5)
    128e:	6318                	ld	a4,0(a4)
    1290:	fee53823          	sd	a4,-16(a0)
    1294:	a091                	j	12d8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1296:	ff852703          	lw	a4,-8(a0)
    129a:	9e39                	addw	a2,a2,a4
    129c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    129e:	ff053703          	ld	a4,-16(a0)
    12a2:	e398                	sd	a4,0(a5)
    12a4:	a099                	j	12ea <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12a6:	6398                	ld	a4,0(a5)
    12a8:	00e7e463          	bltu	a5,a4,12b0 <free+0x40>
    12ac:	00e6ea63          	bltu	a3,a4,12c0 <free+0x50>
{
    12b0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12b2:	fed7fae3          	bgeu	a5,a3,12a6 <free+0x36>
    12b6:	6398                	ld	a4,0(a5)
    12b8:	00e6e463          	bltu	a3,a4,12c0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12bc:	fee7eae3          	bltu	a5,a4,12b0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    12c0:	ff852583          	lw	a1,-8(a0)
    12c4:	6390                	ld	a2,0(a5)
    12c6:	02059713          	slli	a4,a1,0x20
    12ca:	9301                	srli	a4,a4,0x20
    12cc:	0712                	slli	a4,a4,0x4
    12ce:	9736                	add	a4,a4,a3
    12d0:	fae60ae3          	beq	a2,a4,1284 <free+0x14>
    bp->s.ptr = p->s.ptr;
    12d4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12d8:	4790                	lw	a2,8(a5)
    12da:	02061713          	slli	a4,a2,0x20
    12de:	9301                	srli	a4,a4,0x20
    12e0:	0712                	slli	a4,a4,0x4
    12e2:	973e                	add	a4,a4,a5
    12e4:	fae689e3          	beq	a3,a4,1296 <free+0x26>
  } else
    p->s.ptr = bp;
    12e8:	e394                	sd	a3,0(a5)
  freep = p;
    12ea:	00001717          	auipc	a4,0x1
    12ee:	d2f73323          	sd	a5,-730(a4) # 2010 <freep>
}
    12f2:	6422                	ld	s0,8(sp)
    12f4:	0141                	addi	sp,sp,16
    12f6:	8082                	ret

00000000000012f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12f8:	7139                	addi	sp,sp,-64
    12fa:	fc06                	sd	ra,56(sp)
    12fc:	f822                	sd	s0,48(sp)
    12fe:	f426                	sd	s1,40(sp)
    1300:	f04a                	sd	s2,32(sp)
    1302:	ec4e                	sd	s3,24(sp)
    1304:	e852                	sd	s4,16(sp)
    1306:	e456                	sd	s5,8(sp)
    1308:	e05a                	sd	s6,0(sp)
    130a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    130c:	02051493          	slli	s1,a0,0x20
    1310:	9081                	srli	s1,s1,0x20
    1312:	04bd                	addi	s1,s1,15
    1314:	8091                	srli	s1,s1,0x4
    1316:	0014899b          	addiw	s3,s1,1
    131a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    131c:	00001517          	auipc	a0,0x1
    1320:	cf453503          	ld	a0,-780(a0) # 2010 <freep>
    1324:	c515                	beqz	a0,1350 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1326:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1328:	4798                	lw	a4,8(a5)
    132a:	02977f63          	bgeu	a4,s1,1368 <malloc+0x70>
    132e:	8a4e                	mv	s4,s3
    1330:	0009871b          	sext.w	a4,s3
    1334:	6685                	lui	a3,0x1
    1336:	00d77363          	bgeu	a4,a3,133c <malloc+0x44>
    133a:	6a05                	lui	s4,0x1
    133c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1340:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1344:	00001917          	auipc	s2,0x1
    1348:	ccc90913          	addi	s2,s2,-820 # 2010 <freep>
  if(p == (char*)-1)
    134c:	5afd                	li	s5,-1
    134e:	a88d                	j	13c0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1350:	00001797          	auipc	a5,0x1
    1354:	0b878793          	addi	a5,a5,184 # 2408 <base>
    1358:	00001717          	auipc	a4,0x1
    135c:	caf73c23          	sd	a5,-840(a4) # 2010 <freep>
    1360:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1362:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1366:	b7e1                	j	132e <malloc+0x36>
      if(p->s.size == nunits)
    1368:	02e48b63          	beq	s1,a4,139e <malloc+0xa6>
        p->s.size -= nunits;
    136c:	4137073b          	subw	a4,a4,s3
    1370:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1372:	1702                	slli	a4,a4,0x20
    1374:	9301                	srli	a4,a4,0x20
    1376:	0712                	slli	a4,a4,0x4
    1378:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    137a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    137e:	00001717          	auipc	a4,0x1
    1382:	c8a73923          	sd	a0,-878(a4) # 2010 <freep>
      return (void*)(p + 1);
    1386:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    138a:	70e2                	ld	ra,56(sp)
    138c:	7442                	ld	s0,48(sp)
    138e:	74a2                	ld	s1,40(sp)
    1390:	7902                	ld	s2,32(sp)
    1392:	69e2                	ld	s3,24(sp)
    1394:	6a42                	ld	s4,16(sp)
    1396:	6aa2                	ld	s5,8(sp)
    1398:	6b02                	ld	s6,0(sp)
    139a:	6121                	addi	sp,sp,64
    139c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    139e:	6398                	ld	a4,0(a5)
    13a0:	e118                	sd	a4,0(a0)
    13a2:	bff1                	j	137e <malloc+0x86>
  hp->s.size = nu;
    13a4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    13a8:	0541                	addi	a0,a0,16
    13aa:	00000097          	auipc	ra,0x0
    13ae:	ec6080e7          	jalr	-314(ra) # 1270 <free>
  return freep;
    13b2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    13b6:	d971                	beqz	a0,138a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13ba:	4798                	lw	a4,8(a5)
    13bc:	fa9776e3          	bgeu	a4,s1,1368 <malloc+0x70>
    if(p == freep)
    13c0:	00093703          	ld	a4,0(s2)
    13c4:	853e                	mv	a0,a5
    13c6:	fef719e3          	bne	a4,a5,13b8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    13ca:	8552                	mv	a0,s4
    13cc:	00000097          	auipc	ra,0x0
    13d0:	b6e080e7          	jalr	-1170(ra) # f3a <sbrk>
  if(p == (char*)-1)
    13d4:	fd5518e3          	bne	a0,s5,13a4 <malloc+0xac>
        return 0;
    13d8:	4501                	li	a0,0
    13da:	bf45                	j	138a <malloc+0x92>
