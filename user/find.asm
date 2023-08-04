
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char* fmtname(char *path)
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
  14:	3f2080e7          	jalr	1010(ra) # 402 <strlen>
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
  40:	3c6080e7          	jalr	966(ra) # 402 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));//p内容复制到buf
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));//之后空格补全
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
  memmove(buf, p, strlen(p));//p内容复制到buf
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	3a4080e7          	jalr	932(ra) # 402 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	faa98993          	addi	s3,s3,-86 # 1010 <buf.1106>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	504080e7          	jalr	1284(ra) # 57a <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));//之后空格补全
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	382080e7          	jalr	898(ra) # 402 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	374080e7          	jalr	884(ra) # 402 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	384080e7          	jalr	900(ra) # 42c <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <cmp>:

int cmp(char* a,char*b)
{
  b4:	7179                	addi	sp,sp,-48
  b6:	f406                	sd	ra,40(sp)
  b8:	f022                	sd	s0,32(sp)
  ba:	ec26                	sd	s1,24(sp)
  bc:	e84a                	sd	s2,16(sp)
  be:	e44e                	sd	s3,8(sp)
  c0:	e052                	sd	s4,0(sp)
  c2:	1800                	addi	s0,sp,48
  c4:	892a                	mv	s2,a0
  c6:	84ae                	mv	s1,a1
    int len_a=strlen(a);
  c8:	00000097          	auipc	ra,0x0
  cc:	33a080e7          	jalr	826(ra) # 402 <strlen>
  d0:	00050a1b          	sext.w	s4,a0
    int len_b=strlen(b);
  d4:	8526                	mv	a0,s1
  d6:	00000097          	auipc	ra,0x0
  da:	32c080e7          	jalr	812(ra) # 402 <strlen>
  de:	0005071b          	sext.w	a4,a0
    if(len_a>=len_b)
  e2:	02ea5a63          	bge	s4,a4,116 <cmp+0x62>
    {
        for(int i=0;i<len_a;i++)
        {
            if(a[i]-b[i]!=0)return -1;
        }
        return 0;
  e6:	4501                	li	a0,0
        for(int i=0;i<len_a;i++)
  e8:	07405063          	blez	s4,148 <cmp+0x94>
  ec:	87ca                	mv	a5,s2
  ee:	85a6                	mv	a1,s1
  f0:	00190613          	addi	a2,s2,1
  f4:	3a7d                	addiw	s4,s4,-1
  f6:	1a02                	slli	s4,s4,0x20
  f8:	020a5a13          	srli	s4,s4,0x20
  fc:	9652                	add	a2,a2,s4
            if(a[i]-b[i]!=0)return -1;
  fe:	0007c683          	lbu	a3,0(a5)
 102:	0005c703          	lbu	a4,0(a1)
 106:	04e69963          	bne	a3,a4,158 <cmp+0xa4>
        for(int i=0;i<len_a;i++)
 10a:	0785                	addi	a5,a5,1
 10c:	0585                	addi	a1,a1,1
 10e:	fec798e3          	bne	a5,a2,fe <cmp+0x4a>
        return 0;
 112:	4501                	li	a0,0
 114:	a815                	j	148 <cmp+0x94>
        for(int i=0;i<len_b;i++)
 116:	02e05663          	blez	a4,142 <cmp+0x8e>
 11a:	87ca                	mv	a5,s2
 11c:	85a6                	mv	a1,s1
 11e:	00190613          	addi	a2,s2,1
 122:	377d                	addiw	a4,a4,-1
 124:	1702                	slli	a4,a4,0x20
 126:	9301                	srli	a4,a4,0x20
 128:	963a                	add	a2,a2,a4
            if(a[i]-b[i]!=0)return -1;
 12a:	0007c683          	lbu	a3,0(a5)
 12e:	0005c703          	lbu	a4,0(a1)
 132:	00e69a63          	bne	a3,a4,146 <cmp+0x92>
        for(int i=0;i<len_b;i++)
 136:	0785                	addi	a5,a5,1
 138:	0585                	addi	a1,a1,1
 13a:	fec798e3          	bne	a5,a2,12a <cmp+0x76>
        return 0;
 13e:	4501                	li	a0,0
 140:	a021                	j	148 <cmp+0x94>
 142:	4501                	li	a0,0
 144:	a011                	j	148 <cmp+0x94>
            if(a[i]-b[i]!=0)return -1;
 146:	557d                	li	a0,-1
    }
}
 148:	70a2                	ld	ra,40(sp)
 14a:	7402                	ld	s0,32(sp)
 14c:	64e2                	ld	s1,24(sp)
 14e:	6942                	ld	s2,16(sp)
 150:	69a2                	ld	s3,8(sp)
 152:	6a02                	ld	s4,0(sp)
 154:	6145                	addi	sp,sp,48
 156:	8082                	ret
            if(a[i]-b[i]!=0)return -1;
 158:	557d                	li	a0,-1
 15a:	b7fd                	j	148 <cmp+0x94>

000000000000015c <find>:


void find(char* path,char*obj)
{
 15c:	d8010113          	addi	sp,sp,-640
 160:	26113c23          	sd	ra,632(sp)
 164:	26813823          	sd	s0,624(sp)
 168:	26913423          	sd	s1,616(sp)
 16c:	27213023          	sd	s2,608(sp)
 170:	25313c23          	sd	s3,600(sp)
 174:	25413823          	sd	s4,592(sp)
 178:	25513423          	sd	s5,584(sp)
 17c:	25613023          	sd	s6,576(sp)
 180:	23713c23          	sd	s7,568(sp)
 184:	23813823          	sd	s8,560(sp)
 188:	0500                	addi	s0,sp,640
 18a:	892a                	mv	s2,a0
 18c:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;//inode号？，文件名
  struct stat st;//inode信息

  if((fd = open(path, 0)) < 0){//找到描述符
 18e:	4581                	li	a1,0
 190:	00000097          	auipc	ra,0x0
 194:	4e0080e7          	jalr	1248(ra) # 670 <open>
 198:	08054763          	bltz	a0,226 <find+0xca>
 19c:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){//找到文件信息
 19e:	d8840593          	addi	a1,s0,-632
 1a2:	00000097          	auipc	ra,0x0
 1a6:	4e6080e7          	jalr	1254(ra) # 688 <fstat>
 1aa:	08054963          	bltz	a0,23c <find+0xe0>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type)
 1ae:	d9041783          	lh	a5,-624(s0)
 1b2:	0007869b          	sext.w	a3,a5
 1b6:	4705                	li	a4,1
 1b8:	0ce68a63          	beq	a3,a4,28c <find+0x130>
 1bc:	37f9                	addiw	a5,a5,-2
 1be:	17c2                	slli	a5,a5,0x30
 1c0:	93c1                	srli	a5,a5,0x30
 1c2:	02f76663          	bltu	a4,a5,1ee <find+0x92>
  {
    case T_DEVICE:
    case T_FILE:
        printf("%s\n",path);
 1c6:	85ca                	mv	a1,s2
 1c8:	00001517          	auipc	a0,0x1
 1cc:	99850513          	addi	a0,a0,-1640 # b60 <malloc+0xfa>
 1d0:	00000097          	auipc	ra,0x0
 1d4:	7d8080e7          	jalr	2008(ra) # 9a8 <printf>
        if(cmp(fmtname(path),obj)==0)
 1d8:	854a                	mv	a0,s2
 1da:	00000097          	auipc	ra,0x0
 1de:	e26080e7          	jalr	-474(ra) # 0 <fmtname>
 1e2:	85ce                	mv	a1,s3
 1e4:	00000097          	auipc	ra,0x0
 1e8:	ed0080e7          	jalr	-304(ra) # b4 <cmp>
 1ec:	c925                	beqz	a0,25c <find+0x100>
                  write(1,"\n",1);
                }
        }
        break;
  }
  close(fd);
 1ee:	8526                	mv	a0,s1
 1f0:	00000097          	auipc	ra,0x0
 1f4:	468080e7          	jalr	1128(ra) # 658 <close>
}
 1f8:	27813083          	ld	ra,632(sp)
 1fc:	27013403          	ld	s0,624(sp)
 200:	26813483          	ld	s1,616(sp)
 204:	26013903          	ld	s2,608(sp)
 208:	25813983          	ld	s3,600(sp)
 20c:	25013a03          	ld	s4,592(sp)
 210:	24813a83          	ld	s5,584(sp)
 214:	24013b03          	ld	s6,576(sp)
 218:	23813b83          	ld	s7,568(sp)
 21c:	23013c03          	ld	s8,560(sp)
 220:	28010113          	addi	sp,sp,640
 224:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 226:	864a                	mv	a2,s2
 228:	00001597          	auipc	a1,0x1
 22c:	92858593          	addi	a1,a1,-1752 # b50 <malloc+0xea>
 230:	4509                	li	a0,2
 232:	00000097          	auipc	ra,0x0
 236:	748080e7          	jalr	1864(ra) # 97a <fprintf>
    return;
 23a:	bf7d                	j	1f8 <find+0x9c>
    fprintf(2, "ls: cannot stat %s\n", path);
 23c:	864a                	mv	a2,s2
 23e:	00001597          	auipc	a1,0x1
 242:	92a58593          	addi	a1,a1,-1750 # b68 <malloc+0x102>
 246:	4509                	li	a0,2
 248:	00000097          	auipc	ra,0x0
 24c:	732080e7          	jalr	1842(ra) # 97a <fprintf>
    close(fd);
 250:	8526                	mv	a0,s1
 252:	00000097          	auipc	ra,0x0
 256:	406080e7          	jalr	1030(ra) # 658 <close>
    return;
 25a:	bf79                	j	1f8 <find+0x9c>
            write(1,path,strlen(path));
 25c:	854a                	mv	a0,s2
 25e:	00000097          	auipc	ra,0x0
 262:	1a4080e7          	jalr	420(ra) # 402 <strlen>
 266:	0005061b          	sext.w	a2,a0
 26a:	85ca                	mv	a1,s2
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	3e2080e7          	jalr	994(ra) # 650 <write>
            write(1,"\n",1);
 276:	4605                	li	a2,1
 278:	00001597          	auipc	a1,0x1
 27c:	90858593          	addi	a1,a1,-1784 # b80 <malloc+0x11a>
 280:	4505                	li	a0,1
 282:	00000097          	auipc	ra,0x0
 286:	3ce080e7          	jalr	974(ra) # 650 <write>
 28a:	b795                	j	1ee <find+0x92>
        strcpy(buf, path);//buf:'.'
 28c:	85ca                	mv	a1,s2
 28e:	db040513          	addi	a0,s0,-592
 292:	00000097          	auipc	ra,0x0
 296:	128080e7          	jalr	296(ra) # 3ba <strcpy>
        p = buf+strlen(buf);
 29a:	db040513          	addi	a0,s0,-592
 29e:	00000097          	auipc	ra,0x0
 2a2:	164080e7          	jalr	356(ra) # 402 <strlen>
 2a6:	02051913          	slli	s2,a0,0x20
 2aa:	02095913          	srli	s2,s2,0x20
 2ae:	db040793          	addi	a5,s0,-592
 2b2:	993e                	add	s2,s2,a5
        *p++ = '/';//p:./和buf指向同一个东西,不同地址,先取值再自增
 2b4:	00190a93          	addi	s5,s2,1
 2b8:	02f00793          	li	a5,47
 2bc:	00f90023          	sb	a5,0(s2)
            if(st.type==T_DIR&&de.name[0]!='.')
 2c0:	4a05                	li	s4,1
            else if (st.type==T_FILE)
 2c2:	4b09                	li	s6,2
                  write(1,"\n",1);
 2c4:	00001c17          	auipc	s8,0x1
 2c8:	8bcc0c13          	addi	s8,s8,-1860 # b80 <malloc+0x11a>
            if(st.type==T_DIR&&de.name[0]!='.')
 2cc:	02e00b93          	li	s7,46
        while(read(fd, &de, sizeof(de)) == sizeof(de))//目录文件由一些dirent组成
 2d0:	4641                	li	a2,16
 2d2:	da040593          	addi	a1,s0,-608
 2d6:	8526                	mv	a0,s1
 2d8:	00000097          	auipc	ra,0x0
 2dc:	370080e7          	jalr	880(ra) # 648 <read>
 2e0:	47c1                	li	a5,16
 2e2:	f0f516e3          	bne	a0,a5,1ee <find+0x92>
            if(de.inum == 0)
 2e6:	da045783          	lhu	a5,-608(s0)
 2ea:	d3fd                	beqz	a5,2d0 <find+0x174>
            memmove(p, de.name, DIRSIZ);//名字赋值给当前目录下的p(./wc)
 2ec:	4639                	li	a2,14
 2ee:	da240593          	addi	a1,s0,-606
 2f2:	8556                	mv	a0,s5
 2f4:	00000097          	auipc	ra,0x0
 2f8:	286080e7          	jalr	646(ra) # 57a <memmove>
            p[DIRSIZ] = 0;//结束符(./wc\0)
 2fc:	000907a3          	sb	zero,15(s2)
            stat(buf, &st);//st存储当前文件信息
 300:	d8840593          	addi	a1,s0,-632
 304:	db040513          	addi	a0,s0,-592
 308:	00000097          	auipc	ra,0x0
 30c:	1e2080e7          	jalr	482(ra) # 4ea <stat>
            if(st.type==T_DIR&&de.name[0]!='.')
 310:	d9041783          	lh	a5,-624(s0)
 314:	0007871b          	sext.w	a4,a5
 318:	05470863          	beq	a4,s4,368 <find+0x20c>
            else if (st.type==T_FILE)
 31c:	2781                	sext.w	a5,a5
 31e:	fb6799e3          	bne	a5,s6,2d0 <find+0x174>
                if(cmp(fmtname(buf),obj)==0)//是文件的话如果一致就打印
 322:	db040513          	addi	a0,s0,-592
 326:	00000097          	auipc	ra,0x0
 32a:	cda080e7          	jalr	-806(ra) # 0 <fmtname>
 32e:	85ce                	mv	a1,s3
 330:	00000097          	auipc	ra,0x0
 334:	d84080e7          	jalr	-636(ra) # b4 <cmp>
 338:	fd41                	bnez	a0,2d0 <find+0x174>
                  write(1,buf,strlen(buf));
 33a:	db040513          	addi	a0,s0,-592
 33e:	00000097          	auipc	ra,0x0
 342:	0c4080e7          	jalr	196(ra) # 402 <strlen>
 346:	0005061b          	sext.w	a2,a0
 34a:	db040593          	addi	a1,s0,-592
 34e:	8552                	mv	a0,s4
 350:	00000097          	auipc	ra,0x0
 354:	300080e7          	jalr	768(ra) # 650 <write>
                  write(1,"\n",1);
 358:	8652                	mv	a2,s4
 35a:	85e2                	mv	a1,s8
 35c:	8552                	mv	a0,s4
 35e:	00000097          	auipc	ra,0x0
 362:	2f2080e7          	jalr	754(ra) # 650 <write>
 366:	b7ad                	j	2d0 <find+0x174>
            if(st.type==T_DIR&&de.name[0]!='.')
 368:	da244783          	lbu	a5,-606(s0)
 36c:	f77782e3          	beq	a5,s7,2d0 <find+0x174>
                find(buf,obj);//如果是目录就递归查找
 370:	85ce                	mv	a1,s3
 372:	db040513          	addi	a0,s0,-592
 376:	00000097          	auipc	ra,0x0
 37a:	de6080e7          	jalr	-538(ra) # 15c <find>
 37e:	bf89                	j	2d0 <find+0x174>

0000000000000380 <main>:


int main(int argc, char *argv[])
{
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
 388:	87ae                	mv	a5,a1
    find(argv[1],argv[2]);//参数一是目录，参数2是目标
 38a:	698c                	ld	a1,16(a1)
 38c:	6788                	ld	a0,8(a5)
 38e:	00000097          	auipc	ra,0x0
 392:	dce080e7          	jalr	-562(ra) # 15c <find>
    exit(0);
 396:	4501                	li	a0,0
 398:	00000097          	auipc	ra,0x0
 39c:	298080e7          	jalr	664(ra) # 630 <exit>

00000000000003a0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e406                	sd	ra,8(sp)
 3a4:	e022                	sd	s0,0(sp)
 3a6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3a8:	00000097          	auipc	ra,0x0
 3ac:	fd8080e7          	jalr	-40(ra) # 380 <main>
  exit(0);
 3b0:	4501                	li	a0,0
 3b2:	00000097          	auipc	ra,0x0
 3b6:	27e080e7          	jalr	638(ra) # 630 <exit>

00000000000003ba <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e422                	sd	s0,8(sp)
 3be:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3c0:	87aa                	mv	a5,a0
 3c2:	0585                	addi	a1,a1,1
 3c4:	0785                	addi	a5,a5,1
 3c6:	fff5c703          	lbu	a4,-1(a1)
 3ca:	fee78fa3          	sb	a4,-1(a5)
 3ce:	fb75                	bnez	a4,3c2 <strcpy+0x8>
    ;
  return os;
}
 3d0:	6422                	ld	s0,8(sp)
 3d2:	0141                	addi	sp,sp,16
 3d4:	8082                	ret

00000000000003d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3d6:	1141                	addi	sp,sp,-16
 3d8:	e422                	sd	s0,8(sp)
 3da:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3dc:	00054783          	lbu	a5,0(a0)
 3e0:	cb91                	beqz	a5,3f4 <strcmp+0x1e>
 3e2:	0005c703          	lbu	a4,0(a1)
 3e6:	00f71763          	bne	a4,a5,3f4 <strcmp+0x1e>
    p++, q++;
 3ea:	0505                	addi	a0,a0,1
 3ec:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3ee:	00054783          	lbu	a5,0(a0)
 3f2:	fbe5                	bnez	a5,3e2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3f4:	0005c503          	lbu	a0,0(a1)
}
 3f8:	40a7853b          	subw	a0,a5,a0
 3fc:	6422                	ld	s0,8(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret

0000000000000402 <strlen>:

uint
strlen(const char *s)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 408:	00054783          	lbu	a5,0(a0)
 40c:	cf91                	beqz	a5,428 <strlen+0x26>
 40e:	0505                	addi	a0,a0,1
 410:	87aa                	mv	a5,a0
 412:	4685                	li	a3,1
 414:	9e89                	subw	a3,a3,a0
 416:	00f6853b          	addw	a0,a3,a5
 41a:	0785                	addi	a5,a5,1
 41c:	fff7c703          	lbu	a4,-1(a5)
 420:	fb7d                	bnez	a4,416 <strlen+0x14>
    ;
  return n;
}
 422:	6422                	ld	s0,8(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret
  for(n = 0; s[n]; n++)
 428:	4501                	li	a0,0
 42a:	bfe5                	j	422 <strlen+0x20>

000000000000042c <memset>:

void*
memset(void *dst, int c, uint n)
{
 42c:	1141                	addi	sp,sp,-16
 42e:	e422                	sd	s0,8(sp)
 430:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 432:	ce09                	beqz	a2,44c <memset+0x20>
 434:	87aa                	mv	a5,a0
 436:	fff6071b          	addiw	a4,a2,-1
 43a:	1702                	slli	a4,a4,0x20
 43c:	9301                	srli	a4,a4,0x20
 43e:	0705                	addi	a4,a4,1
 440:	972a                	add	a4,a4,a0
    cdst[i] = c;
 442:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 446:	0785                	addi	a5,a5,1
 448:	fee79de3          	bne	a5,a4,442 <memset+0x16>
  }
  return dst;
}
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret

0000000000000452 <strchr>:

char*
strchr(const char *s, char c)
{
 452:	1141                	addi	sp,sp,-16
 454:	e422                	sd	s0,8(sp)
 456:	0800                	addi	s0,sp,16
  for(; *s; s++)
 458:	00054783          	lbu	a5,0(a0)
 45c:	cb99                	beqz	a5,472 <strchr+0x20>
    if(*s == c)
 45e:	00f58763          	beq	a1,a5,46c <strchr+0x1a>
  for(; *s; s++)
 462:	0505                	addi	a0,a0,1
 464:	00054783          	lbu	a5,0(a0)
 468:	fbfd                	bnez	a5,45e <strchr+0xc>
      return (char*)s;
  return 0;
 46a:	4501                	li	a0,0
}
 46c:	6422                	ld	s0,8(sp)
 46e:	0141                	addi	sp,sp,16
 470:	8082                	ret
  return 0;
 472:	4501                	li	a0,0
 474:	bfe5                	j	46c <strchr+0x1a>

0000000000000476 <gets>:

char*
gets(char *buf, int max)
{
 476:	711d                	addi	sp,sp,-96
 478:	ec86                	sd	ra,88(sp)
 47a:	e8a2                	sd	s0,80(sp)
 47c:	e4a6                	sd	s1,72(sp)
 47e:	e0ca                	sd	s2,64(sp)
 480:	fc4e                	sd	s3,56(sp)
 482:	f852                	sd	s4,48(sp)
 484:	f456                	sd	s5,40(sp)
 486:	f05a                	sd	s6,32(sp)
 488:	ec5e                	sd	s7,24(sp)
 48a:	1080                	addi	s0,sp,96
 48c:	8baa                	mv	s7,a0
 48e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 490:	892a                	mv	s2,a0
 492:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 494:	4aa9                	li	s5,10
 496:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 498:	89a6                	mv	s3,s1
 49a:	2485                	addiw	s1,s1,1
 49c:	0344d863          	bge	s1,s4,4cc <gets+0x56>
    cc = read(0, &c, 1);
 4a0:	4605                	li	a2,1
 4a2:	faf40593          	addi	a1,s0,-81
 4a6:	4501                	li	a0,0
 4a8:	00000097          	auipc	ra,0x0
 4ac:	1a0080e7          	jalr	416(ra) # 648 <read>
    if(cc < 1)
 4b0:	00a05e63          	blez	a0,4cc <gets+0x56>
    buf[i++] = c;
 4b4:	faf44783          	lbu	a5,-81(s0)
 4b8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4bc:	01578763          	beq	a5,s5,4ca <gets+0x54>
 4c0:	0905                	addi	s2,s2,1
 4c2:	fd679be3          	bne	a5,s6,498 <gets+0x22>
  for(i=0; i+1 < max; ){
 4c6:	89a6                	mv	s3,s1
 4c8:	a011                	j	4cc <gets+0x56>
 4ca:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4cc:	99de                	add	s3,s3,s7
 4ce:	00098023          	sb	zero,0(s3)
  return buf;
}
 4d2:	855e                	mv	a0,s7
 4d4:	60e6                	ld	ra,88(sp)
 4d6:	6446                	ld	s0,80(sp)
 4d8:	64a6                	ld	s1,72(sp)
 4da:	6906                	ld	s2,64(sp)
 4dc:	79e2                	ld	s3,56(sp)
 4de:	7a42                	ld	s4,48(sp)
 4e0:	7aa2                	ld	s5,40(sp)
 4e2:	7b02                	ld	s6,32(sp)
 4e4:	6be2                	ld	s7,24(sp)
 4e6:	6125                	addi	sp,sp,96
 4e8:	8082                	ret

00000000000004ea <stat>:

int
stat(const char *n, struct stat *st)
{
 4ea:	1101                	addi	sp,sp,-32
 4ec:	ec06                	sd	ra,24(sp)
 4ee:	e822                	sd	s0,16(sp)
 4f0:	e426                	sd	s1,8(sp)
 4f2:	e04a                	sd	s2,0(sp)
 4f4:	1000                	addi	s0,sp,32
 4f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f8:	4581                	li	a1,0
 4fa:	00000097          	auipc	ra,0x0
 4fe:	176080e7          	jalr	374(ra) # 670 <open>
  if(fd < 0)
 502:	02054563          	bltz	a0,52c <stat+0x42>
 506:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 508:	85ca                	mv	a1,s2
 50a:	00000097          	auipc	ra,0x0
 50e:	17e080e7          	jalr	382(ra) # 688 <fstat>
 512:	892a                	mv	s2,a0
  close(fd);
 514:	8526                	mv	a0,s1
 516:	00000097          	auipc	ra,0x0
 51a:	142080e7          	jalr	322(ra) # 658 <close>
  return r;
}
 51e:	854a                	mv	a0,s2
 520:	60e2                	ld	ra,24(sp)
 522:	6442                	ld	s0,16(sp)
 524:	64a2                	ld	s1,8(sp)
 526:	6902                	ld	s2,0(sp)
 528:	6105                	addi	sp,sp,32
 52a:	8082                	ret
    return -1;
 52c:	597d                	li	s2,-1
 52e:	bfc5                	j	51e <stat+0x34>

0000000000000530 <atoi>:

int
atoi(const char *s)
{
 530:	1141                	addi	sp,sp,-16
 532:	e422                	sd	s0,8(sp)
 534:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 536:	00054603          	lbu	a2,0(a0)
 53a:	fd06079b          	addiw	a5,a2,-48
 53e:	0ff7f793          	andi	a5,a5,255
 542:	4725                	li	a4,9
 544:	02f76963          	bltu	a4,a5,576 <atoi+0x46>
 548:	86aa                	mv	a3,a0
  n = 0;
 54a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 54c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 54e:	0685                	addi	a3,a3,1
 550:	0025179b          	slliw	a5,a0,0x2
 554:	9fa9                	addw	a5,a5,a0
 556:	0017979b          	slliw	a5,a5,0x1
 55a:	9fb1                	addw	a5,a5,a2
 55c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 560:	0006c603          	lbu	a2,0(a3)
 564:	fd06071b          	addiw	a4,a2,-48
 568:	0ff77713          	andi	a4,a4,255
 56c:	fee5f1e3          	bgeu	a1,a4,54e <atoi+0x1e>
  return n;
}
 570:	6422                	ld	s0,8(sp)
 572:	0141                	addi	sp,sp,16
 574:	8082                	ret
  n = 0;
 576:	4501                	li	a0,0
 578:	bfe5                	j	570 <atoi+0x40>

000000000000057a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 57a:	1141                	addi	sp,sp,-16
 57c:	e422                	sd	s0,8(sp)
 57e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 580:	02b57663          	bgeu	a0,a1,5ac <memmove+0x32>
    while(n-- > 0)
 584:	02c05163          	blez	a2,5a6 <memmove+0x2c>
 588:	fff6079b          	addiw	a5,a2,-1
 58c:	1782                	slli	a5,a5,0x20
 58e:	9381                	srli	a5,a5,0x20
 590:	0785                	addi	a5,a5,1
 592:	97aa                	add	a5,a5,a0
  dst = vdst;
 594:	872a                	mv	a4,a0
      *dst++ = *src++;
 596:	0585                	addi	a1,a1,1
 598:	0705                	addi	a4,a4,1
 59a:	fff5c683          	lbu	a3,-1(a1)
 59e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5a2:	fee79ae3          	bne	a5,a4,596 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5a6:	6422                	ld	s0,8(sp)
 5a8:	0141                	addi	sp,sp,16
 5aa:	8082                	ret
    dst += n;
 5ac:	00c50733          	add	a4,a0,a2
    src += n;
 5b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5b2:	fec05ae3          	blez	a2,5a6 <memmove+0x2c>
 5b6:	fff6079b          	addiw	a5,a2,-1
 5ba:	1782                	slli	a5,a5,0x20
 5bc:	9381                	srli	a5,a5,0x20
 5be:	fff7c793          	not	a5,a5
 5c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5c4:	15fd                	addi	a1,a1,-1
 5c6:	177d                	addi	a4,a4,-1
 5c8:	0005c683          	lbu	a3,0(a1)
 5cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5d0:	fee79ae3          	bne	a5,a4,5c4 <memmove+0x4a>
 5d4:	bfc9                	j	5a6 <memmove+0x2c>

00000000000005d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5d6:	1141                	addi	sp,sp,-16
 5d8:	e422                	sd	s0,8(sp)
 5da:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5dc:	ca05                	beqz	a2,60c <memcmp+0x36>
 5de:	fff6069b          	addiw	a3,a2,-1
 5e2:	1682                	slli	a3,a3,0x20
 5e4:	9281                	srli	a3,a3,0x20
 5e6:	0685                	addi	a3,a3,1
 5e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5ea:	00054783          	lbu	a5,0(a0)
 5ee:	0005c703          	lbu	a4,0(a1)
 5f2:	00e79863          	bne	a5,a4,602 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5f6:	0505                	addi	a0,a0,1
    p2++;
 5f8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5fa:	fed518e3          	bne	a0,a3,5ea <memcmp+0x14>
  }
  return 0;
 5fe:	4501                	li	a0,0
 600:	a019                	j	606 <memcmp+0x30>
      return *p1 - *p2;
 602:	40e7853b          	subw	a0,a5,a4
}
 606:	6422                	ld	s0,8(sp)
 608:	0141                	addi	sp,sp,16
 60a:	8082                	ret
  return 0;
 60c:	4501                	li	a0,0
 60e:	bfe5                	j	606 <memcmp+0x30>

0000000000000610 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 610:	1141                	addi	sp,sp,-16
 612:	e406                	sd	ra,8(sp)
 614:	e022                	sd	s0,0(sp)
 616:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 618:	00000097          	auipc	ra,0x0
 61c:	f62080e7          	jalr	-158(ra) # 57a <memmove>
}
 620:	60a2                	ld	ra,8(sp)
 622:	6402                	ld	s0,0(sp)
 624:	0141                	addi	sp,sp,16
 626:	8082                	ret

0000000000000628 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 628:	4885                	li	a7,1
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <exit>:
.global exit
exit:
 li a7, SYS_exit
 630:	4889                	li	a7,2
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <wait>:
.global wait
wait:
 li a7, SYS_wait
 638:	488d                	li	a7,3
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 640:	4891                	li	a7,4
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <read>:
.global read
read:
 li a7, SYS_read
 648:	4895                	li	a7,5
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <write>:
.global write
write:
 li a7, SYS_write
 650:	48c1                	li	a7,16
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <close>:
.global close
close:
 li a7, SYS_close
 658:	48d5                	li	a7,21
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <kill>:
.global kill
kill:
 li a7, SYS_kill
 660:	4899                	li	a7,6
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <exec>:
.global exec
exec:
 li a7, SYS_exec
 668:	489d                	li	a7,7
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <open>:
.global open
open:
 li a7, SYS_open
 670:	48bd                	li	a7,15
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 678:	48c5                	li	a7,17
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 680:	48c9                	li	a7,18
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 688:	48a1                	li	a7,8
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <link>:
.global link
link:
 li a7, SYS_link
 690:	48cd                	li	a7,19
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 698:	48d1                	li	a7,20
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6a0:	48a5                	li	a7,9
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6a8:	48a9                	li	a7,10
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6b0:	48ad                	li	a7,11
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6b8:	48b1                	li	a7,12
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6c0:	48b5                	li	a7,13
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6c8:	48b9                	li	a7,14
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6d0:	1101                	addi	sp,sp,-32
 6d2:	ec06                	sd	ra,24(sp)
 6d4:	e822                	sd	s0,16(sp)
 6d6:	1000                	addi	s0,sp,32
 6d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6dc:	4605                	li	a2,1
 6de:	fef40593          	addi	a1,s0,-17
 6e2:	00000097          	auipc	ra,0x0
 6e6:	f6e080e7          	jalr	-146(ra) # 650 <write>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6105                	addi	sp,sp,32
 6f0:	8082                	ret

00000000000006f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6f2:	7139                	addi	sp,sp,-64
 6f4:	fc06                	sd	ra,56(sp)
 6f6:	f822                	sd	s0,48(sp)
 6f8:	f426                	sd	s1,40(sp)
 6fa:	f04a                	sd	s2,32(sp)
 6fc:	ec4e                	sd	s3,24(sp)
 6fe:	0080                	addi	s0,sp,64
 700:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 702:	c299                	beqz	a3,708 <printint+0x16>
 704:	0805c863          	bltz	a1,794 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 708:	2581                	sext.w	a1,a1
  neg = 0;
 70a:	4881                	li	a7,0
 70c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 710:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 712:	2601                	sext.w	a2,a2
 714:	00000517          	auipc	a0,0x0
 718:	47c50513          	addi	a0,a0,1148 # b90 <digits>
 71c:	883a                	mv	a6,a4
 71e:	2705                	addiw	a4,a4,1
 720:	02c5f7bb          	remuw	a5,a1,a2
 724:	1782                	slli	a5,a5,0x20
 726:	9381                	srli	a5,a5,0x20
 728:	97aa                	add	a5,a5,a0
 72a:	0007c783          	lbu	a5,0(a5)
 72e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 732:	0005879b          	sext.w	a5,a1
 736:	02c5d5bb          	divuw	a1,a1,a2
 73a:	0685                	addi	a3,a3,1
 73c:	fec7f0e3          	bgeu	a5,a2,71c <printint+0x2a>
  if(neg)
 740:	00088b63          	beqz	a7,756 <printint+0x64>
    buf[i++] = '-';
 744:	fd040793          	addi	a5,s0,-48
 748:	973e                	add	a4,a4,a5
 74a:	02d00793          	li	a5,45
 74e:	fef70823          	sb	a5,-16(a4)
 752:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 756:	02e05863          	blez	a4,786 <printint+0x94>
 75a:	fc040793          	addi	a5,s0,-64
 75e:	00e78933          	add	s2,a5,a4
 762:	fff78993          	addi	s3,a5,-1
 766:	99ba                	add	s3,s3,a4
 768:	377d                	addiw	a4,a4,-1
 76a:	1702                	slli	a4,a4,0x20
 76c:	9301                	srli	a4,a4,0x20
 76e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 772:	fff94583          	lbu	a1,-1(s2)
 776:	8526                	mv	a0,s1
 778:	00000097          	auipc	ra,0x0
 77c:	f58080e7          	jalr	-168(ra) # 6d0 <putc>
  while(--i >= 0)
 780:	197d                	addi	s2,s2,-1
 782:	ff3918e3          	bne	s2,s3,772 <printint+0x80>
}
 786:	70e2                	ld	ra,56(sp)
 788:	7442                	ld	s0,48(sp)
 78a:	74a2                	ld	s1,40(sp)
 78c:	7902                	ld	s2,32(sp)
 78e:	69e2                	ld	s3,24(sp)
 790:	6121                	addi	sp,sp,64
 792:	8082                	ret
    x = -xx;
 794:	40b005bb          	negw	a1,a1
    neg = 1;
 798:	4885                	li	a7,1
    x = -xx;
 79a:	bf8d                	j	70c <printint+0x1a>

000000000000079c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 79c:	7119                	addi	sp,sp,-128
 79e:	fc86                	sd	ra,120(sp)
 7a0:	f8a2                	sd	s0,112(sp)
 7a2:	f4a6                	sd	s1,104(sp)
 7a4:	f0ca                	sd	s2,96(sp)
 7a6:	ecce                	sd	s3,88(sp)
 7a8:	e8d2                	sd	s4,80(sp)
 7aa:	e4d6                	sd	s5,72(sp)
 7ac:	e0da                	sd	s6,64(sp)
 7ae:	fc5e                	sd	s7,56(sp)
 7b0:	f862                	sd	s8,48(sp)
 7b2:	f466                	sd	s9,40(sp)
 7b4:	f06a                	sd	s10,32(sp)
 7b6:	ec6e                	sd	s11,24(sp)
 7b8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7ba:	0005c903          	lbu	s2,0(a1)
 7be:	18090f63          	beqz	s2,95c <vprintf+0x1c0>
 7c2:	8aaa                	mv	s5,a0
 7c4:	8b32                	mv	s6,a2
 7c6:	00158493          	addi	s1,a1,1
  state = 0;
 7ca:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7cc:	02500a13          	li	s4,37
      if(c == 'd'){
 7d0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7d4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7d8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7dc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e0:	00000b97          	auipc	s7,0x0
 7e4:	3b0b8b93          	addi	s7,s7,944 # b90 <digits>
 7e8:	a839                	j	806 <vprintf+0x6a>
        putc(fd, c);
 7ea:	85ca                	mv	a1,s2
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	ee2080e7          	jalr	-286(ra) # 6d0 <putc>
 7f6:	a019                	j	7fc <vprintf+0x60>
    } else if(state == '%'){
 7f8:	01498f63          	beq	s3,s4,816 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 7fc:	0485                	addi	s1,s1,1
 7fe:	fff4c903          	lbu	s2,-1(s1)
 802:	14090d63          	beqz	s2,95c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 806:	0009079b          	sext.w	a5,s2
    if(state == 0){
 80a:	fe0997e3          	bnez	s3,7f8 <vprintf+0x5c>
      if(c == '%'){
 80e:	fd479ee3          	bne	a5,s4,7ea <vprintf+0x4e>
        state = '%';
 812:	89be                	mv	s3,a5
 814:	b7e5                	j	7fc <vprintf+0x60>
      if(c == 'd'){
 816:	05878063          	beq	a5,s8,856 <vprintf+0xba>
      } else if(c == 'l') {
 81a:	05978c63          	beq	a5,s9,872 <vprintf+0xd6>
      } else if(c == 'x') {
 81e:	07a78863          	beq	a5,s10,88e <vprintf+0xf2>
      } else if(c == 'p') {
 822:	09b78463          	beq	a5,s11,8aa <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 826:	07300713          	li	a4,115
 82a:	0ce78663          	beq	a5,a4,8f6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 82e:	06300713          	li	a4,99
 832:	0ee78e63          	beq	a5,a4,92e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 836:	11478863          	beq	a5,s4,946 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 83a:	85d2                	mv	a1,s4
 83c:	8556                	mv	a0,s5
 83e:	00000097          	auipc	ra,0x0
 842:	e92080e7          	jalr	-366(ra) # 6d0 <putc>
        putc(fd, c);
 846:	85ca                	mv	a1,s2
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	e86080e7          	jalr	-378(ra) # 6d0 <putc>
      }
      state = 0;
 852:	4981                	li	s3,0
 854:	b765                	j	7fc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 856:	008b0913          	addi	s2,s6,8
 85a:	4685                	li	a3,1
 85c:	4629                	li	a2,10
 85e:	000b2583          	lw	a1,0(s6)
 862:	8556                	mv	a0,s5
 864:	00000097          	auipc	ra,0x0
 868:	e8e080e7          	jalr	-370(ra) # 6f2 <printint>
 86c:	8b4a                	mv	s6,s2
      state = 0;
 86e:	4981                	li	s3,0
 870:	b771                	j	7fc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 872:	008b0913          	addi	s2,s6,8
 876:	4681                	li	a3,0
 878:	4629                	li	a2,10
 87a:	000b2583          	lw	a1,0(s6)
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	e72080e7          	jalr	-398(ra) # 6f2 <printint>
 888:	8b4a                	mv	s6,s2
      state = 0;
 88a:	4981                	li	s3,0
 88c:	bf85                	j	7fc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 88e:	008b0913          	addi	s2,s6,8
 892:	4681                	li	a3,0
 894:	4641                	li	a2,16
 896:	000b2583          	lw	a1,0(s6)
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	e56080e7          	jalr	-426(ra) # 6f2 <printint>
 8a4:	8b4a                	mv	s6,s2
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	bf91                	j	7fc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8aa:	008b0793          	addi	a5,s6,8
 8ae:	f8f43423          	sd	a5,-120(s0)
 8b2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8b6:	03000593          	li	a1,48
 8ba:	8556                	mv	a0,s5
 8bc:	00000097          	auipc	ra,0x0
 8c0:	e14080e7          	jalr	-492(ra) # 6d0 <putc>
  putc(fd, 'x');
 8c4:	85ea                	mv	a1,s10
 8c6:	8556                	mv	a0,s5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	e08080e7          	jalr	-504(ra) # 6d0 <putc>
 8d0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8d2:	03c9d793          	srli	a5,s3,0x3c
 8d6:	97de                	add	a5,a5,s7
 8d8:	0007c583          	lbu	a1,0(a5)
 8dc:	8556                	mv	a0,s5
 8de:	00000097          	auipc	ra,0x0
 8e2:	df2080e7          	jalr	-526(ra) # 6d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8e6:	0992                	slli	s3,s3,0x4
 8e8:	397d                	addiw	s2,s2,-1
 8ea:	fe0914e3          	bnez	s2,8d2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 8ee:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8f2:	4981                	li	s3,0
 8f4:	b721                	j	7fc <vprintf+0x60>
        s = va_arg(ap, char*);
 8f6:	008b0993          	addi	s3,s6,8
 8fa:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 8fe:	02090163          	beqz	s2,920 <vprintf+0x184>
        while(*s != 0){
 902:	00094583          	lbu	a1,0(s2)
 906:	c9a1                	beqz	a1,956 <vprintf+0x1ba>
          putc(fd, *s);
 908:	8556                	mv	a0,s5
 90a:	00000097          	auipc	ra,0x0
 90e:	dc6080e7          	jalr	-570(ra) # 6d0 <putc>
          s++;
 912:	0905                	addi	s2,s2,1
        while(*s != 0){
 914:	00094583          	lbu	a1,0(s2)
 918:	f9e5                	bnez	a1,908 <vprintf+0x16c>
        s = va_arg(ap, char*);
 91a:	8b4e                	mv	s6,s3
      state = 0;
 91c:	4981                	li	s3,0
 91e:	bdf9                	j	7fc <vprintf+0x60>
          s = "(null)";
 920:	00000917          	auipc	s2,0x0
 924:	26890913          	addi	s2,s2,616 # b88 <malloc+0x122>
        while(*s != 0){
 928:	02800593          	li	a1,40
 92c:	bff1                	j	908 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 92e:	008b0913          	addi	s2,s6,8
 932:	000b4583          	lbu	a1,0(s6)
 936:	8556                	mv	a0,s5
 938:	00000097          	auipc	ra,0x0
 93c:	d98080e7          	jalr	-616(ra) # 6d0 <putc>
 940:	8b4a                	mv	s6,s2
      state = 0;
 942:	4981                	li	s3,0
 944:	bd65                	j	7fc <vprintf+0x60>
        putc(fd, c);
 946:	85d2                	mv	a1,s4
 948:	8556                	mv	a0,s5
 94a:	00000097          	auipc	ra,0x0
 94e:	d86080e7          	jalr	-634(ra) # 6d0 <putc>
      state = 0;
 952:	4981                	li	s3,0
 954:	b565                	j	7fc <vprintf+0x60>
        s = va_arg(ap, char*);
 956:	8b4e                	mv	s6,s3
      state = 0;
 958:	4981                	li	s3,0
 95a:	b54d                	j	7fc <vprintf+0x60>
    }
  }
}
 95c:	70e6                	ld	ra,120(sp)
 95e:	7446                	ld	s0,112(sp)
 960:	74a6                	ld	s1,104(sp)
 962:	7906                	ld	s2,96(sp)
 964:	69e6                	ld	s3,88(sp)
 966:	6a46                	ld	s4,80(sp)
 968:	6aa6                	ld	s5,72(sp)
 96a:	6b06                	ld	s6,64(sp)
 96c:	7be2                	ld	s7,56(sp)
 96e:	7c42                	ld	s8,48(sp)
 970:	7ca2                	ld	s9,40(sp)
 972:	7d02                	ld	s10,32(sp)
 974:	6de2                	ld	s11,24(sp)
 976:	6109                	addi	sp,sp,128
 978:	8082                	ret

000000000000097a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 97a:	715d                	addi	sp,sp,-80
 97c:	ec06                	sd	ra,24(sp)
 97e:	e822                	sd	s0,16(sp)
 980:	1000                	addi	s0,sp,32
 982:	e010                	sd	a2,0(s0)
 984:	e414                	sd	a3,8(s0)
 986:	e818                	sd	a4,16(s0)
 988:	ec1c                	sd	a5,24(s0)
 98a:	03043023          	sd	a6,32(s0)
 98e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 992:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 996:	8622                	mv	a2,s0
 998:	00000097          	auipc	ra,0x0
 99c:	e04080e7          	jalr	-508(ra) # 79c <vprintf>
}
 9a0:	60e2                	ld	ra,24(sp)
 9a2:	6442                	ld	s0,16(sp)
 9a4:	6161                	addi	sp,sp,80
 9a6:	8082                	ret

00000000000009a8 <printf>:

void
printf(const char *fmt, ...)
{
 9a8:	711d                	addi	sp,sp,-96
 9aa:	ec06                	sd	ra,24(sp)
 9ac:	e822                	sd	s0,16(sp)
 9ae:	1000                	addi	s0,sp,32
 9b0:	e40c                	sd	a1,8(s0)
 9b2:	e810                	sd	a2,16(s0)
 9b4:	ec14                	sd	a3,24(s0)
 9b6:	f018                	sd	a4,32(s0)
 9b8:	f41c                	sd	a5,40(s0)
 9ba:	03043823          	sd	a6,48(s0)
 9be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9c2:	00840613          	addi	a2,s0,8
 9c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9ca:	85aa                	mv	a1,a0
 9cc:	4505                	li	a0,1
 9ce:	00000097          	auipc	ra,0x0
 9d2:	dce080e7          	jalr	-562(ra) # 79c <vprintf>
}
 9d6:	60e2                	ld	ra,24(sp)
 9d8:	6442                	ld	s0,16(sp)
 9da:	6125                	addi	sp,sp,96
 9dc:	8082                	ret

00000000000009de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9de:	1141                	addi	sp,sp,-16
 9e0:	e422                	sd	s0,8(sp)
 9e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e8:	00000797          	auipc	a5,0x0
 9ec:	6187b783          	ld	a5,1560(a5) # 1000 <freep>
 9f0:	a805                	j	a20 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9f2:	4618                	lw	a4,8(a2)
 9f4:	9db9                	addw	a1,a1,a4
 9f6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9fa:	6398                	ld	a4,0(a5)
 9fc:	6318                	ld	a4,0(a4)
 9fe:	fee53823          	sd	a4,-16(a0)
 a02:	a091                	j	a46 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a04:	ff852703          	lw	a4,-8(a0)
 a08:	9e39                	addw	a2,a2,a4
 a0a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a0c:	ff053703          	ld	a4,-16(a0)
 a10:	e398                	sd	a4,0(a5)
 a12:	a099                	j	a58 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a14:	6398                	ld	a4,0(a5)
 a16:	00e7e463          	bltu	a5,a4,a1e <free+0x40>
 a1a:	00e6ea63          	bltu	a3,a4,a2e <free+0x50>
{
 a1e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a20:	fed7fae3          	bgeu	a5,a3,a14 <free+0x36>
 a24:	6398                	ld	a4,0(a5)
 a26:	00e6e463          	bltu	a3,a4,a2e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2a:	fee7eae3          	bltu	a5,a4,a1e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a2e:	ff852583          	lw	a1,-8(a0)
 a32:	6390                	ld	a2,0(a5)
 a34:	02059713          	slli	a4,a1,0x20
 a38:	9301                	srli	a4,a4,0x20
 a3a:	0712                	slli	a4,a4,0x4
 a3c:	9736                	add	a4,a4,a3
 a3e:	fae60ae3          	beq	a2,a4,9f2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a42:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a46:	4790                	lw	a2,8(a5)
 a48:	02061713          	slli	a4,a2,0x20
 a4c:	9301                	srli	a4,a4,0x20
 a4e:	0712                	slli	a4,a4,0x4
 a50:	973e                	add	a4,a4,a5
 a52:	fae689e3          	beq	a3,a4,a04 <free+0x26>
  } else
    p->s.ptr = bp;
 a56:	e394                	sd	a3,0(a5)
  freep = p;
 a58:	00000717          	auipc	a4,0x0
 a5c:	5af73423          	sd	a5,1448(a4) # 1000 <freep>
}
 a60:	6422                	ld	s0,8(sp)
 a62:	0141                	addi	sp,sp,16
 a64:	8082                	ret

0000000000000a66 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a66:	7139                	addi	sp,sp,-64
 a68:	fc06                	sd	ra,56(sp)
 a6a:	f822                	sd	s0,48(sp)
 a6c:	f426                	sd	s1,40(sp)
 a6e:	f04a                	sd	s2,32(sp)
 a70:	ec4e                	sd	s3,24(sp)
 a72:	e852                	sd	s4,16(sp)
 a74:	e456                	sd	s5,8(sp)
 a76:	e05a                	sd	s6,0(sp)
 a78:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a7a:	02051493          	slli	s1,a0,0x20
 a7e:	9081                	srli	s1,s1,0x20
 a80:	04bd                	addi	s1,s1,15
 a82:	8091                	srli	s1,s1,0x4
 a84:	0014899b          	addiw	s3,s1,1
 a88:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a8a:	00000517          	auipc	a0,0x0
 a8e:	57653503          	ld	a0,1398(a0) # 1000 <freep>
 a92:	c515                	beqz	a0,abe <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a94:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a96:	4798                	lw	a4,8(a5)
 a98:	02977f63          	bgeu	a4,s1,ad6 <malloc+0x70>
 a9c:	8a4e                	mv	s4,s3
 a9e:	0009871b          	sext.w	a4,s3
 aa2:	6685                	lui	a3,0x1
 aa4:	00d77363          	bgeu	a4,a3,aaa <malloc+0x44>
 aa8:	6a05                	lui	s4,0x1
 aaa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 aae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ab2:	00000917          	auipc	s2,0x0
 ab6:	54e90913          	addi	s2,s2,1358 # 1000 <freep>
  if(p == (char*)-1)
 aba:	5afd                	li	s5,-1
 abc:	a88d                	j	b2e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 abe:	00000797          	auipc	a5,0x0
 ac2:	56278793          	addi	a5,a5,1378 # 1020 <base>
 ac6:	00000717          	auipc	a4,0x0
 aca:	52f73d23          	sd	a5,1338(a4) # 1000 <freep>
 ace:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ad0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ad4:	b7e1                	j	a9c <malloc+0x36>
      if(p->s.size == nunits)
 ad6:	02e48b63          	beq	s1,a4,b0c <malloc+0xa6>
        p->s.size -= nunits;
 ada:	4137073b          	subw	a4,a4,s3
 ade:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ae0:	1702                	slli	a4,a4,0x20
 ae2:	9301                	srli	a4,a4,0x20
 ae4:	0712                	slli	a4,a4,0x4
 ae6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ae8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aec:	00000717          	auipc	a4,0x0
 af0:	50a73a23          	sd	a0,1300(a4) # 1000 <freep>
      return (void*)(p + 1);
 af4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 af8:	70e2                	ld	ra,56(sp)
 afa:	7442                	ld	s0,48(sp)
 afc:	74a2                	ld	s1,40(sp)
 afe:	7902                	ld	s2,32(sp)
 b00:	69e2                	ld	s3,24(sp)
 b02:	6a42                	ld	s4,16(sp)
 b04:	6aa2                	ld	s5,8(sp)
 b06:	6b02                	ld	s6,0(sp)
 b08:	6121                	addi	sp,sp,64
 b0a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b0c:	6398                	ld	a4,0(a5)
 b0e:	e118                	sd	a4,0(a0)
 b10:	bff1                	j	aec <malloc+0x86>
  hp->s.size = nu;
 b12:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b16:	0541                	addi	a0,a0,16
 b18:	00000097          	auipc	ra,0x0
 b1c:	ec6080e7          	jalr	-314(ra) # 9de <free>
  return freep;
 b20:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b24:	d971                	beqz	a0,af8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b26:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b28:	4798                	lw	a4,8(a5)
 b2a:	fa9776e3          	bgeu	a4,s1,ad6 <malloc+0x70>
    if(p == freep)
 b2e:	00093703          	ld	a4,0(s2)
 b32:	853e                	mv	a0,a5
 b34:	fef719e3          	bne	a4,a5,b26 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b38:	8552                	mv	a0,s4
 b3a:	00000097          	auipc	ra,0x0
 b3e:	b7e080e7          	jalr	-1154(ra) # 6b8 <sbrk>
  if(p == (char*)-1)
 b42:	fd5518e3          	bne	a0,s5,b12 <malloc+0xac>
        return 0;
 b46:	4501                	li	a0,0
 b48:	bf45                	j	af8 <malloc+0x92>
