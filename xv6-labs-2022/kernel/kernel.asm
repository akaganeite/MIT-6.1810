
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	93013103          	ld	sp,-1744(sp) # 80008930 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1b7050ef          	jal	ra,800059cc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	fc078793          	addi	a5,a5,-64 # 80021ff0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	93090913          	addi	s2,s2,-1744 # 80008980 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	372080e7          	jalr	882(ra) # 800063cc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	412080e7          	jalr	1042(ra) # 80006480 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	df8080e7          	jalr	-520(ra) # 80005e82 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	89450513          	addi	a0,a0,-1900 # 80008980 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	248080e7          	jalr	584(ra) # 8000633c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	ef050513          	addi	a0,a0,-272 # 80021ff0 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	85e48493          	addi	s1,s1,-1954 # 80008980 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	2a0080e7          	jalr	672(ra) # 800063cc <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	84650513          	addi	a0,a0,-1978 # 80008980 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	33c080e7          	jalr	828(ra) # 80006480 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	81a50513          	addi	a0,a0,-2022 # 80008980 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	312080e7          	jalr	786(ra) # 80006480 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	c18080e7          	jalr	-1000(ra) # 80000f46 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	61a70713          	addi	a4,a4,1562 # 80008950 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	bfc080e7          	jalr	-1028(ra) # 80000f46 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	b70080e7          	jalr	-1168(ra) # 80005ecc <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	938080e7          	jalr	-1736(ra) # 80001ca4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	fac080e7          	jalr	-84(ra) # 80005320 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	182080e7          	jalr	386(ra) # 800014fe <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a10080e7          	jalr	-1520(ra) # 80005d94 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	d26080e7          	jalr	-730(ra) # 800060b2 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	b30080e7          	jalr	-1232(ra) # 80005ecc <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	b20080e7          	jalr	-1248(ra) # 80005ecc <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	b10080e7          	jalr	-1264(ra) # 80005ecc <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	326080e7          	jalr	806(ra) # 800006f2 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	ab8080e7          	jalr	-1352(ra) # 80000e94 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	898080e7          	jalr	-1896(ra) # 80001c7c <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	8b8080e7          	jalr	-1864(ra) # 80001ca4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	f16080e7          	jalr	-234(ra) # 8000530a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	f24080e7          	jalr	-220(ra) # 80005320 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	0c4080e7          	jalr	196(ra) # 800024c8 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	768080e7          	jalr	1896(ra) # 80002b74 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	706080e7          	jalr	1798(ra) # 80003b1a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	00c080e7          	jalr	12(ra) # 80005428 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	ec0080e7          	jalr	-320(ra) # 800012e4 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	50f72f23          	sw	a5,1310(a4) # 80008950 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	5127b783          	ld	a5,1298(a5) # 80008958 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00006097          	auipc	ra,0x6
    80000496:	9f0080e7          	jalr	-1552(ra) # 80005e82 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000562:	c205                	beqz	a2,80000582 <mappages+0x36>
    80000564:	8aaa                	mv	s5,a0
    80000566:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000568:	77fd                	lui	a5,0xfffff
    8000056a:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056e:	15fd                	addi	a1,a1,-1
    80000570:	00c589b3          	add	s3,a1,a2
    80000574:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000578:	8952                	mv	s2,s4
    8000057a:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057e:	6b85                	lui	s7,0x1
    80000580:	a015                	j	800005a4 <mappages+0x58>
    panic("mappages: size");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ad650513          	addi	a0,a0,-1322 # 80008058 <etext+0x58>
    8000058a:	00006097          	auipc	ra,0x6
    8000058e:	8f8080e7          	jalr	-1800(ra) # 80005e82 <panic>
      panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00006097          	auipc	ra,0x6
    8000059e:	8e8080e7          	jalr	-1816(ra) # 80005e82 <panic>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
  for(;;){
    800005a4:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	4605                	li	a2,1
    800005aa:	85ca                	mv	a1,s2
    800005ac:	8556                	mv	a0,s5
    800005ae:	00000097          	auipc	ra,0x0
    800005b2:	eb6080e7          	jalr	-330(ra) # 80000464 <walk>
    800005b6:	cd19                	beqz	a0,800005d4 <mappages+0x88>
    if(*pte & PTE_V)
    800005b8:	611c                	ld	a5,0(a0)
    800005ba:	8b85                	andi	a5,a5,1
    800005bc:	fbf9                	bnez	a5,80000592 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005be:	80b1                	srli	s1,s1,0xc
    800005c0:	04aa                	slli	s1,s1,0xa
    800005c2:	0164e4b3          	or	s1,s1,s6
    800005c6:	0014e493          	ori	s1,s1,1
    800005ca:	e104                	sd	s1,0(a0)
    if(a == last)
    800005cc:	fd391be3          	bne	s2,s3,800005a2 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005d0:	4501                	li	a0,0
    800005d2:	a011                	j	800005d6 <mappages+0x8a>
      return -1;
    800005d4:	557d                	li	a0,-1
}
    800005d6:	60a6                	ld	ra,72(sp)
    800005d8:	6406                	ld	s0,64(sp)
    800005da:	74e2                	ld	s1,56(sp)
    800005dc:	7942                	ld	s2,48(sp)
    800005de:	79a2                	ld	s3,40(sp)
    800005e0:	7a02                	ld	s4,32(sp)
    800005e2:	6ae2                	ld	s5,24(sp)
    800005e4:	6b42                	ld	s6,16(sp)
    800005e6:	6ba2                	ld	s7,8(sp)
    800005e8:	6161                	addi	sp,sp,80
    800005ea:	8082                	ret

00000000800005ec <kvmmap>:
{
    800005ec:	1141                	addi	sp,sp,-16
    800005ee:	e406                	sd	ra,8(sp)
    800005f0:	e022                	sd	s0,0(sp)
    800005f2:	0800                	addi	s0,sp,16
    800005f4:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f6:	86b2                	mv	a3,a2
    800005f8:	863e                	mv	a2,a5
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	f52080e7          	jalr	-174(ra) # 8000054c <mappages>
    80000602:	e509                	bnez	a0,8000060c <kvmmap+0x20>
}
    80000604:	60a2                	ld	ra,8(sp)
    80000606:	6402                	ld	s0,0(sp)
    80000608:	0141                	addi	sp,sp,16
    8000060a:	8082                	ret
    panic("kvmmap");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a6c50513          	addi	a0,a0,-1428 # 80008078 <etext+0x78>
    80000614:	00006097          	auipc	ra,0x6
    80000618:	86e080e7          	jalr	-1938(ra) # 80005e82 <panic>

000000008000061c <kvmmake>:
{
    8000061c:	1101                	addi	sp,sp,-32
    8000061e:	ec06                	sd	ra,24(sp)
    80000620:	e822                	sd	s0,16(sp)
    80000622:	e426                	sd	s1,8(sp)
    80000624:	e04a                	sd	s2,0(sp)
    80000626:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	af0080e7          	jalr	-1296(ra) # 80000118 <kalloc>
    80000630:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000632:	6605                	lui	a2,0x1
    80000634:	4581                	li	a1,0
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	b42080e7          	jalr	-1214(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063e:	4719                	li	a4,6
    80000640:	6685                	lui	a3,0x1
    80000642:	10000637          	lui	a2,0x10000
    80000646:	100005b7          	lui	a1,0x10000
    8000064a:	8526                	mv	a0,s1
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	fa0080e7          	jalr	-96(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10001637          	lui	a2,0x10001
    8000065c:	100015b7          	lui	a1,0x10001
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	f8a080e7          	jalr	-118(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	004006b7          	lui	a3,0x400
    80000670:	0c000637          	lui	a2,0xc000
    80000674:	0c0005b7          	lui	a1,0xc000
    80000678:	8526                	mv	a0,s1
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	f72080e7          	jalr	-142(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000682:	00008917          	auipc	s2,0x8
    80000686:	97e90913          	addi	s2,s2,-1666 # 80008000 <etext>
    8000068a:	4729                	li	a4,10
    8000068c:	80008697          	auipc	a3,0x80008
    80000690:	97468693          	addi	a3,a3,-1676 # 8000 <_entry-0x7fff8000>
    80000694:	4605                	li	a2,1
    80000696:	067e                	slli	a2,a2,0x1f
    80000698:	85b2                	mv	a1,a2
    8000069a:	8526                	mv	a0,s1
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f50080e7          	jalr	-176(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a4:	4719                	li	a4,6
    800006a6:	46c5                	li	a3,17
    800006a8:	06ee                	slli	a3,a3,0x1b
    800006aa:	412686b3          	sub	a3,a3,s2
    800006ae:	864a                	mv	a2,s2
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8526                	mv	a0,s1
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	f38080e7          	jalr	-200(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006bc:	4729                	li	a4,10
    800006be:	6685                	lui	a3,0x1
    800006c0:	00007617          	auipc	a2,0x7
    800006c4:	94060613          	addi	a2,a2,-1728 # 80007000 <_trampoline>
    800006c8:	040005b7          	lui	a1,0x4000
    800006cc:	15fd                	addi	a1,a1,-1
    800006ce:	05b2                	slli	a1,a1,0xc
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f1a080e7          	jalr	-230(ra) # 800005ec <kvmmap>
  proc_mapstacks(kpgtbl);
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	724080e7          	jalr	1828(ra) # 80000e00 <proc_mapstacks>
}
    800006e4:	8526                	mv	a0,s1
    800006e6:	60e2                	ld	ra,24(sp)
    800006e8:	6442                	ld	s0,16(sp)
    800006ea:	64a2                	ld	s1,8(sp)
    800006ec:	6902                	ld	s2,0(sp)
    800006ee:	6105                	addi	sp,sp,32
    800006f0:	8082                	ret

00000000800006f2 <kvminit>:
{
    800006f2:	1141                	addi	sp,sp,-16
    800006f4:	e406                	sd	ra,8(sp)
    800006f6:	e022                	sd	s0,0(sp)
    800006f8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f22080e7          	jalr	-222(ra) # 8000061c <kvmmake>
    80000702:	00008797          	auipc	a5,0x8
    80000706:	24a7bb23          	sd	a0,598(a5) # 80008958 <kernel_pagetable>
}
    8000070a:	60a2                	ld	ra,8(sp)
    8000070c:	6402                	ld	s0,0(sp)
    8000070e:	0141                	addi	sp,sp,16
    80000710:	8082                	ret

0000000080000712 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000712:	715d                	addi	sp,sp,-80
    80000714:	e486                	sd	ra,72(sp)
    80000716:	e0a2                	sd	s0,64(sp)
    80000718:	fc26                	sd	s1,56(sp)
    8000071a:	f84a                	sd	s2,48(sp)
    8000071c:	f44e                	sd	s3,40(sp)
    8000071e:	f052                	sd	s4,32(sp)
    80000720:	ec56                	sd	s5,24(sp)
    80000722:	e85a                	sd	s6,16(sp)
    80000724:	e45e                	sd	s7,8(sp)
    80000726:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000728:	03459793          	slli	a5,a1,0x34
    8000072c:	e795                	bnez	a5,80000758 <uvmunmap+0x46>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	892e                	mv	s2,a1
    80000732:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	0632                	slli	a2,a2,0xc
    80000736:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000073a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000073c:	6b05                	lui	s6,0x1
    8000073e:	0735e863          	bltu	a1,s3,800007ae <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000742:	60a6                	ld	ra,72(sp)
    80000744:	6406                	ld	s0,64(sp)
    80000746:	74e2                	ld	s1,56(sp)
    80000748:	7942                	ld	s2,48(sp)
    8000074a:	79a2                	ld	s3,40(sp)
    8000074c:	7a02                	ld	s4,32(sp)
    8000074e:	6ae2                	ld	s5,24(sp)
    80000750:	6b42                	ld	s6,16(sp)
    80000752:	6ba2                	ld	s7,8(sp)
    80000754:	6161                	addi	sp,sp,80
    80000756:	8082                	ret
    panic("uvmunmap: not aligned");
    80000758:	00008517          	auipc	a0,0x8
    8000075c:	92850513          	addi	a0,a0,-1752 # 80008080 <etext+0x80>
    80000760:	00005097          	auipc	ra,0x5
    80000764:	722080e7          	jalr	1826(ra) # 80005e82 <panic>
      panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	712080e7          	jalr	1810(ra) # 80005e82 <panic>
      panic("uvmunmap: not mapped");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	702080e7          	jalr	1794(ra) # 80005e82 <panic>
      panic("uvmunmap: not a leaf");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	93850513          	addi	a0,a0,-1736 # 800080c0 <etext+0xc0>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	6f2080e7          	jalr	1778(ra) # 80005e82 <panic>
      uint64 pa = PTE2PA(*pte);
    80000798:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000079a:	0532                	slli	a0,a0,0xc
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	880080e7          	jalr	-1920(ra) # 8000001c <kfree>
    *pte = 0;
    800007a4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a8:	995a                	add	s2,s2,s6
    800007aa:	f9397ce3          	bgeu	s2,s3,80000742 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007ae:	4601                	li	a2,0
    800007b0:	85ca                	mv	a1,s2
    800007b2:	8552                	mv	a0,s4
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	cb0080e7          	jalr	-848(ra) # 80000464 <walk>
    800007bc:	84aa                	mv	s1,a0
    800007be:	d54d                	beqz	a0,80000768 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007c0:	6108                	ld	a0,0(a0)
    800007c2:	00157793          	andi	a5,a0,1
    800007c6:	dbcd                	beqz	a5,80000778 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c8:	3ff57793          	andi	a5,a0,1023
    800007cc:	fb778ee3          	beq	a5,s7,80000788 <uvmunmap+0x76>
    if(do_free){
    800007d0:	fc0a8ae3          	beqz	s5,800007a4 <uvmunmap+0x92>
    800007d4:	b7d1                	j	80000798 <uvmunmap+0x86>

00000000800007d6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	938080e7          	jalr	-1736(ra) # 80000118 <kalloc>
    800007e8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007ea:	c519                	beqz	a0,800007f8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ec:	6605                	lui	a2,0x1
    800007ee:	4581                	li	a1,0
    800007f0:	00000097          	auipc	ra,0x0
    800007f4:	988080e7          	jalr	-1656(ra) # 80000178 <memset>
  return pagetable;
}
    800007f8:	8526                	mv	a0,s1
    800007fa:	60e2                	ld	ra,24(sp)
    800007fc:	6442                	ld	s0,16(sp)
    800007fe:	64a2                	ld	s1,8(sp)
    80000800:	6105                	addi	sp,sp,32
    80000802:	8082                	ret

0000000080000804 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000804:	7179                	addi	sp,sp,-48
    80000806:	f406                	sd	ra,40(sp)
    80000808:	f022                	sd	s0,32(sp)
    8000080a:	ec26                	sd	s1,24(sp)
    8000080c:	e84a                	sd	s2,16(sp)
    8000080e:	e44e                	sd	s3,8(sp)
    80000810:	e052                	sd	s4,0(sp)
    80000812:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000814:	6785                	lui	a5,0x1
    80000816:	04f67863          	bgeu	a2,a5,80000866 <uvmfirst+0x62>
    8000081a:	8a2a                	mv	s4,a0
    8000081c:	89ae                	mv	s3,a1
    8000081e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	8f8080e7          	jalr	-1800(ra) # 80000118 <kalloc>
    80000828:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	94a080e7          	jalr	-1718(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000836:	4779                	li	a4,30
    80000838:	86ca                	mv	a3,s2
    8000083a:	6605                	lui	a2,0x1
    8000083c:	4581                	li	a1,0
    8000083e:	8552                	mv	a0,s4
    80000840:	00000097          	auipc	ra,0x0
    80000844:	d0c080e7          	jalr	-756(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    80000848:	8626                	mv	a2,s1
    8000084a:	85ce                	mv	a1,s3
    8000084c:	854a                	mv	a0,s2
    8000084e:	00000097          	auipc	ra,0x0
    80000852:	98a080e7          	jalr	-1654(ra) # 800001d8 <memmove>
}
    80000856:	70a2                	ld	ra,40(sp)
    80000858:	7402                	ld	s0,32(sp)
    8000085a:	64e2                	ld	s1,24(sp)
    8000085c:	6942                	ld	s2,16(sp)
    8000085e:	69a2                	ld	s3,8(sp)
    80000860:	6a02                	ld	s4,0(sp)
    80000862:	6145                	addi	sp,sp,48
    80000864:	8082                	ret
    panic("uvmfirst: more than a page");
    80000866:	00008517          	auipc	a0,0x8
    8000086a:	87250513          	addi	a0,a0,-1934 # 800080d8 <etext+0xd8>
    8000086e:	00005097          	auipc	ra,0x5
    80000872:	614080e7          	jalr	1556(ra) # 80005e82 <panic>

0000000080000876 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000876:	1101                	addi	sp,sp,-32
    80000878:	ec06                	sd	ra,24(sp)
    8000087a:	e822                	sd	s0,16(sp)
    8000087c:	e426                	sd	s1,8(sp)
    8000087e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000880:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000882:	00b67d63          	bgeu	a2,a1,8000089c <uvmdealloc+0x26>
    80000886:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000888:	6785                	lui	a5,0x1
    8000088a:	17fd                	addi	a5,a5,-1
    8000088c:	00f60733          	add	a4,a2,a5
    80000890:	767d                	lui	a2,0xfffff
    80000892:	8f71                	and	a4,a4,a2
    80000894:	97ae                	add	a5,a5,a1
    80000896:	8ff1                	and	a5,a5,a2
    80000898:	00f76863          	bltu	a4,a5,800008a8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089c:	8526                	mv	a0,s1
    8000089e:	60e2                	ld	ra,24(sp)
    800008a0:	6442                	ld	s0,16(sp)
    800008a2:	64a2                	ld	s1,8(sp)
    800008a4:	6105                	addi	sp,sp,32
    800008a6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a8:	8f99                	sub	a5,a5,a4
    800008aa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ac:	4685                	li	a3,1
    800008ae:	0007861b          	sext.w	a2,a5
    800008b2:	85ba                	mv	a1,a4
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	e5e080e7          	jalr	-418(ra) # 80000712 <uvmunmap>
    800008bc:	b7c5                	j	8000089c <uvmdealloc+0x26>

00000000800008be <uvmalloc>:
  if(newsz < oldsz)
    800008be:	0ab66563          	bltu	a2,a1,80000968 <uvmalloc+0xaa>
{
    800008c2:	7139                	addi	sp,sp,-64
    800008c4:	fc06                	sd	ra,56(sp)
    800008c6:	f822                	sd	s0,48(sp)
    800008c8:	f426                	sd	s1,40(sp)
    800008ca:	f04a                	sd	s2,32(sp)
    800008cc:	ec4e                	sd	s3,24(sp)
    800008ce:	e852                	sd	s4,16(sp)
    800008d0:	e456                	sd	s5,8(sp)
    800008d2:	e05a                	sd	s6,0(sp)
    800008d4:	0080                	addi	s0,sp,64
    800008d6:	8aaa                	mv	s5,a0
    800008d8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008da:	6985                	lui	s3,0x1
    800008dc:	19fd                	addi	s3,s3,-1
    800008de:	95ce                	add	a1,a1,s3
    800008e0:	79fd                	lui	s3,0xfffff
    800008e2:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e6:	08c9f363          	bgeu	s3,a2,8000096c <uvmalloc+0xae>
    800008ea:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008ec:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	828080e7          	jalr	-2008(ra) # 80000118 <kalloc>
    800008f8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008fa:	c51d                	beqz	a0,80000928 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008fc:	6605                	lui	a2,0x1
    800008fe:	4581                	li	a1,0
    80000900:	00000097          	auipc	ra,0x0
    80000904:	878080e7          	jalr	-1928(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000908:	875a                	mv	a4,s6
    8000090a:	86a6                	mv	a3,s1
    8000090c:	6605                	lui	a2,0x1
    8000090e:	85ca                	mv	a1,s2
    80000910:	8556                	mv	a0,s5
    80000912:	00000097          	auipc	ra,0x0
    80000916:	c3a080e7          	jalr	-966(ra) # 8000054c <mappages>
    8000091a:	e90d                	bnez	a0,8000094c <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000091c:	6785                	lui	a5,0x1
    8000091e:	993e                	add	s2,s2,a5
    80000920:	fd4968e3          	bltu	s2,s4,800008f0 <uvmalloc+0x32>
  return newsz;
    80000924:	8552                	mv	a0,s4
    80000926:	a809                	j	80000938 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000928:	864e                	mv	a2,s3
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	f48080e7          	jalr	-184(ra) # 80000876 <uvmdealloc>
      return 0;
    80000936:	4501                	li	a0,0
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	74a2                	ld	s1,40(sp)
    8000093e:	7902                	ld	s2,32(sp)
    80000940:	69e2                	ld	s3,24(sp)
    80000942:	6a42                	ld	s4,16(sp)
    80000944:	6aa2                	ld	s5,8(sp)
    80000946:	6b02                	ld	s6,0(sp)
    80000948:	6121                	addi	sp,sp,64
    8000094a:	8082                	ret
      kfree(mem);
    8000094c:	8526                	mv	a0,s1
    8000094e:	fffff097          	auipc	ra,0xfffff
    80000952:	6ce080e7          	jalr	1742(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000956:	864e                	mv	a2,s3
    80000958:	85ca                	mv	a1,s2
    8000095a:	8556                	mv	a0,s5
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	f1a080e7          	jalr	-230(ra) # 80000876 <uvmdealloc>
      return 0;
    80000964:	4501                	li	a0,0
    80000966:	bfc9                	j	80000938 <uvmalloc+0x7a>
    return oldsz;
    80000968:	852e                	mv	a0,a1
}
    8000096a:	8082                	ret
  return newsz;
    8000096c:	8532                	mv	a0,a2
    8000096e:	b7e9                	j	80000938 <uvmalloc+0x7a>

0000000080000970 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000970:	7179                	addi	sp,sp,-48
    80000972:	f406                	sd	ra,40(sp)
    80000974:	f022                	sd	s0,32(sp)
    80000976:	ec26                	sd	s1,24(sp)
    80000978:	e84a                	sd	s2,16(sp)
    8000097a:	e44e                	sd	s3,8(sp)
    8000097c:	e052                	sd	s4,0(sp)
    8000097e:	1800                	addi	s0,sp,48
    80000980:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000982:	84aa                	mv	s1,a0
    80000984:	6905                	lui	s2,0x1
    80000986:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000988:	4985                	li	s3,1
    8000098a:	a821                	j	800009a2 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098c:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000098e:	0532                	slli	a0,a0,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fe0080e7          	jalr	-32(ra) # 80000970 <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009a2:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f57793          	andi	a5,a0,15
    800009a8:	ff3782e3          	beq	a5,s3,8000098c <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8905                	andi	a0,a0,1
    800009ae:	d57d                	beqz	a0,8000099c <freewalk+0x2c>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	4ca080e7          	jalr	1226(ra) # 80005e82 <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f86080e7          	jalr	-122(ra) # 80000970 <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6605                	lui	a2,0x1
    800009fe:	167d                	addi	a2,a2,-1
    80000a00:	962e                	add	a2,a2,a1
    80000a02:	4685                	li	a3,1
    80000a04:	8231                	srli	a2,a2,0xc
    80000a06:	4581                	li	a1,0
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	d0a080e7          	jalr	-758(ra) # 80000712 <uvmunmap>
    80000a10:	bfe1                	j	800009e8 <uvmfree+0xe>

0000000080000a12 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a12:	c679                	beqz	a2,80000ae0 <uvmcopy+0xce>
{
    80000a14:	715d                	addi	sp,sp,-80
    80000a16:	e486                	sd	ra,72(sp)
    80000a18:	e0a2                	sd	s0,64(sp)
    80000a1a:	fc26                	sd	s1,56(sp)
    80000a1c:	f84a                	sd	s2,48(sp)
    80000a1e:	f44e                	sd	s3,40(sp)
    80000a20:	f052                	sd	s4,32(sp)
    80000a22:	ec56                	sd	s5,24(sp)
    80000a24:	e85a                	sd	s6,16(sp)
    80000a26:	e45e                	sd	s7,8(sp)
    80000a28:	0880                	addi	s0,sp,80
    80000a2a:	8b2a                	mv	s6,a0
    80000a2c:	8aae                	mv	s5,a1
    80000a2e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a30:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a32:	4601                	li	a2,0
    80000a34:	85ce                	mv	a1,s3
    80000a36:	855a                	mv	a0,s6
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	a2c080e7          	jalr	-1492(ra) # 80000464 <walk>
    80000a40:	c531                	beqz	a0,80000a8c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a42:	6118                	ld	a4,0(a0)
    80000a44:	00177793          	andi	a5,a4,1
    80000a48:	cbb1                	beqz	a5,80000a9c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4a:	00a75593          	srli	a1,a4,0xa
    80000a4e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a52:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a56:	fffff097          	auipc	ra,0xfffff
    80000a5a:	6c2080e7          	jalr	1730(ra) # 80000118 <kalloc>
    80000a5e:	892a                	mv	s2,a0
    80000a60:	c939                	beqz	a0,80000ab6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85de                	mv	a1,s7
    80000a66:	fffff097          	auipc	ra,0xfffff
    80000a6a:	772080e7          	jalr	1906(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6e:	8726                	mv	a4,s1
    80000a70:	86ca                	mv	a3,s2
    80000a72:	6605                	lui	a2,0x1
    80000a74:	85ce                	mv	a1,s3
    80000a76:	8556                	mv	a0,s5
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	ad4080e7          	jalr	-1324(ra) # 8000054c <mappages>
    80000a80:	e515                	bnez	a0,80000aac <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a82:	6785                	lui	a5,0x1
    80000a84:	99be                	add	s3,s3,a5
    80000a86:	fb49e6e3          	bltu	s3,s4,80000a32 <uvmcopy+0x20>
    80000a8a:	a081                	j	80000aca <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8c:	00007517          	auipc	a0,0x7
    80000a90:	67c50513          	addi	a0,a0,1660 # 80008108 <etext+0x108>
    80000a94:	00005097          	auipc	ra,0x5
    80000a98:	3ee080e7          	jalr	1006(ra) # 80005e82 <panic>
      panic("uvmcopy: page not present");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	68c50513          	addi	a0,a0,1676 # 80008128 <etext+0x128>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	3de080e7          	jalr	990(ra) # 80005e82 <panic>
      kfree(mem);
    80000aac:	854a                	mv	a0,s2
    80000aae:	fffff097          	auipc	ra,0xfffff
    80000ab2:	56e080e7          	jalr	1390(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab6:	4685                	li	a3,1
    80000ab8:	00c9d613          	srli	a2,s3,0xc
    80000abc:	4581                	li	a1,0
    80000abe:	8556                	mv	a0,s5
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	c52080e7          	jalr	-942(ra) # 80000712 <uvmunmap>
  return -1;
    80000ac8:	557d                	li	a0,-1
}
    80000aca:	60a6                	ld	ra,72(sp)
    80000acc:	6406                	ld	s0,64(sp)
    80000ace:	74e2                	ld	s1,56(sp)
    80000ad0:	7942                	ld	s2,48(sp)
    80000ad2:	79a2                	ld	s3,40(sp)
    80000ad4:	7a02                	ld	s4,32(sp)
    80000ad6:	6ae2                	ld	s5,24(sp)
    80000ad8:	6b42                	ld	s6,16(sp)
    80000ada:	6ba2                	ld	s7,8(sp)
    80000adc:	6161                	addi	sp,sp,80
    80000ade:	8082                	ret
  return 0;
    80000ae0:	4501                	li	a0,0
}
    80000ae2:	8082                	ret

0000000080000ae4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae4:	1141                	addi	sp,sp,-16
    80000ae6:	e406                	sd	ra,8(sp)
    80000ae8:	e022                	sd	s0,0(sp)
    80000aea:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aec:	4601                	li	a2,0
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	976080e7          	jalr	-1674(ra) # 80000464 <walk>
  if(pte == 0)
    80000af6:	c901                	beqz	a0,80000b06 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af8:	611c                	ld	a5,0(a0)
    80000afa:	9bbd                	andi	a5,a5,-17
    80000afc:	e11c                	sd	a5,0(a0)
}
    80000afe:	60a2                	ld	ra,8(sp)
    80000b00:	6402                	ld	s0,0(sp)
    80000b02:	0141                	addi	sp,sp,16
    80000b04:	8082                	ret
    panic("uvmclear");
    80000b06:	00007517          	auipc	a0,0x7
    80000b0a:	64250513          	addi	a0,a0,1602 # 80008148 <etext+0x148>
    80000b0e:	00005097          	auipc	ra,0x5
    80000b12:	374080e7          	jalr	884(ra) # 80005e82 <panic>

0000000080000b16 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b16:	c6bd                	beqz	a3,80000b84 <copyout+0x6e>
{
    80000b18:	715d                	addi	sp,sp,-80
    80000b1a:	e486                	sd	ra,72(sp)
    80000b1c:	e0a2                	sd	s0,64(sp)
    80000b1e:	fc26                	sd	s1,56(sp)
    80000b20:	f84a                	sd	s2,48(sp)
    80000b22:	f44e                	sd	s3,40(sp)
    80000b24:	f052                	sd	s4,32(sp)
    80000b26:	ec56                	sd	s5,24(sp)
    80000b28:	e85a                	sd	s6,16(sp)
    80000b2a:	e45e                	sd	s7,8(sp)
    80000b2c:	e062                	sd	s8,0(sp)
    80000b2e:	0880                	addi	s0,sp,80
    80000b30:	8b2a                	mv	s6,a0
    80000b32:	8c2e                	mv	s8,a1
    80000b34:	8a32                	mv	s4,a2
    80000b36:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b38:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);//44位的物理地址
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3a:	6a85                	lui	s5,0x1
    80000b3c:	a015                	j	80000b60 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);//物理地址+页内偏移
    80000b3e:	9562                	add	a0,a0,s8
    80000b40:	0004861b          	sext.w	a2,s1
    80000b44:	85d2                	mv	a1,s4
    80000b46:	41250533          	sub	a0,a0,s2
    80000b4a:	fffff097          	auipc	ra,0xfffff
    80000b4e:	68e080e7          	jalr	1678(ra) # 800001d8 <memmove>

    len -= n;//为copy下一页内容做准备
    80000b52:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b56:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b58:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5c:	02098263          	beqz	s3,80000b80 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b60:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);//44位的物理地址
    80000b64:	85ca                	mv	a1,s2
    80000b66:	855a                	mv	a0,s6
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	9a2080e7          	jalr	-1630(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000b70:	cd01                	beqz	a0,80000b88 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b72:	418904b3          	sub	s1,s2,s8
    80000b76:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b78:	fc99f3e3          	bgeu	s3,s1,80000b3e <copyout+0x28>
    80000b7c:	84ce                	mv	s1,s3
    80000b7e:	b7c1                	j	80000b3e <copyout+0x28>
  }
  return 0;
    80000b80:	4501                	li	a0,0
    80000b82:	a021                	j	80000b8a <copyout+0x74>
    80000b84:	4501                	li	a0,0
}
    80000b86:	8082                	ret
      return -1;
    80000b88:	557d                	li	a0,-1
}
    80000b8a:	60a6                	ld	ra,72(sp)
    80000b8c:	6406                	ld	s0,64(sp)
    80000b8e:	74e2                	ld	s1,56(sp)
    80000b90:	7942                	ld	s2,48(sp)
    80000b92:	79a2                	ld	s3,40(sp)
    80000b94:	7a02                	ld	s4,32(sp)
    80000b96:	6ae2                	ld	s5,24(sp)
    80000b98:	6b42                	ld	s6,16(sp)
    80000b9a:	6ba2                	ld	s7,8(sp)
    80000b9c:	6c02                	ld	s8,0(sp)
    80000b9e:	6161                	addi	sp,sp,80
    80000ba0:	8082                	ret

0000000080000ba2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba2:	c6bd                	beqz	a3,80000c10 <copyin+0x6e>
{
    80000ba4:	715d                	addi	sp,sp,-80
    80000ba6:	e486                	sd	ra,72(sp)
    80000ba8:	e0a2                	sd	s0,64(sp)
    80000baa:	fc26                	sd	s1,56(sp)
    80000bac:	f84a                	sd	s2,48(sp)
    80000bae:	f44e                	sd	s3,40(sp)
    80000bb0:	f052                	sd	s4,32(sp)
    80000bb2:	ec56                	sd	s5,24(sp)
    80000bb4:	e85a                	sd	s6,16(sp)
    80000bb6:	e45e                	sd	s7,8(sp)
    80000bb8:	e062                	sd	s8,0(sp)
    80000bba:	0880                	addi	s0,sp,80
    80000bbc:	8b2a                	mv	s6,a0
    80000bbe:	8a2e                	mv	s4,a1
    80000bc0:	8c32                	mv	s8,a2
    80000bc2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc6:	6a85                	lui	s5,0x1
    80000bc8:	a015                	j	80000bec <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bca:	9562                	add	a0,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412505b3          	sub	a1,a0,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	602080e7          	jalr	1538(ra) # 800001d8 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	916080e7          	jalr	-1770(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c04:	fc99f3e3          	bgeu	s3,s1,80000bca <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	b7c1                	j	80000bca <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x74>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2e:	c6c5                	beqz	a3,80000cd6 <copyinstr+0xa8>
{
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a035                	j	80000c7e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5a:	0017b793          	seqz	a5,a5
    80000c5e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c62:	60a6                	ld	ra,72(sp)
    80000c64:	6406                	ld	s0,64(sp)
    80000c66:	74e2                	ld	s1,56(sp)
    80000c68:	7942                	ld	s2,48(sp)
    80000c6a:	79a2                	ld	s3,40(sp)
    80000c6c:	7a02                	ld	s4,32(sp)
    80000c6e:	6ae2                	ld	s5,24(sp)
    80000c70:	6b42                	ld	s6,16(sp)
    80000c72:	6ba2                	ld	s7,8(sp)
    80000c74:	6161                	addi	sp,sp,80
    80000c76:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c78:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c7c:	c8a9                	beqz	s1,80000cce <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c7e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c82:	85ca                	mv	a1,s2
    80000c84:	8552                	mv	a0,s4
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	884080e7          	jalr	-1916(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c8e:	c131                	beqz	a0,80000cd2 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c90:	41790833          	sub	a6,s2,s7
    80000c94:	984e                	add	a6,a6,s3
    if(n > max)
    80000c96:	0104f363          	bgeu	s1,a6,80000c9c <copyinstr+0x6e>
    80000c9a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9c:	955e                	add	a0,a0,s7
    80000c9e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ca2:	fc080be3          	beqz	a6,80000c78 <copyinstr+0x4a>
    80000ca6:	985a                	add	a6,a6,s6
    80000ca8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000caa:	41650633          	sub	a2,a0,s6
    80000cae:	14fd                	addi	s1,s1,-1
    80000cb0:	9b26                	add	s6,s6,s1
    80000cb2:	00f60733          	add	a4,a2,a5
    80000cb6:	00074703          	lbu	a4,0(a4)
    80000cba:	df49                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cbc:	00e78023          	sb	a4,0(a5)
      --max;
    80000cc0:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cc4:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc6:	ff0796e3          	bne	a5,a6,80000cb2 <copyinstr+0x84>
      dst++;
    80000cca:	8b42                	mv	s6,a6
    80000ccc:	b775                	j	80000c78 <copyinstr+0x4a>
    80000cce:	4781                	li	a5,0
    80000cd0:	b769                	j	80000c5a <copyinstr+0x2c>
      return -1;
    80000cd2:	557d                	li	a0,-1
    80000cd4:	b779                	j	80000c62 <copyinstr+0x34>
  int got_null = 0;
    80000cd6:	4781                	li	a5,0
  if(got_null){
    80000cd8:	0017b793          	seqz	a5,a5
    80000cdc:	40f00533          	neg	a0,a5
}
    80000ce0:	8082                	ret

0000000080000ce2 <page_print>:

void page_print(int level)
{
    80000ce2:	7179                	addi	sp,sp,-48
    80000ce4:	f406                	sd	ra,40(sp)
    80000ce6:	f022                	sd	s0,32(sp)
    80000ce8:	ec26                	sd	s1,24(sp)
    80000cea:	e84a                	sd	s2,16(sp)
    80000cec:	e44e                	sd	s3,8(sp)
    80000cee:	1800                	addi	s0,sp,48
  for(int j=0;j<level-1;j++)
    80000cf0:	4785                	li	a5,1
    80000cf2:	02a7d163          	bge	a5,a0,80000d14 <page_print+0x32>
    80000cf6:	fff5091b          	addiw	s2,a0,-1
    80000cfa:	4481                	li	s1,0
    printf(".. ");
    80000cfc:	00007997          	auipc	s3,0x7
    80000d00:	45c98993          	addi	s3,s3,1116 # 80008158 <etext+0x158>
    80000d04:	854e                	mv	a0,s3
    80000d06:	00005097          	auipc	ra,0x5
    80000d0a:	1c6080e7          	jalr	454(ra) # 80005ecc <printf>
  for(int j=0;j<level-1;j++)
    80000d0e:	2485                	addiw	s1,s1,1
    80000d10:	fe991ae3          	bne	s2,s1,80000d04 <page_print+0x22>
  printf("..");
    80000d14:	00007517          	auipc	a0,0x7
    80000d18:	44c50513          	addi	a0,a0,1100 # 80008160 <etext+0x160>
    80000d1c:	00005097          	auipc	ra,0x5
    80000d20:	1b0080e7          	jalr	432(ra) # 80005ecc <printf>
}
    80000d24:	70a2                	ld	ra,40(sp)
    80000d26:	7402                	ld	s0,32(sp)
    80000d28:	64e2                	ld	s1,24(sp)
    80000d2a:	6942                	ld	s2,16(sp)
    80000d2c:	69a2                	ld	s3,8(sp)
    80000d2e:	6145                	addi	sp,sp,48
    80000d30:	8082                	ret

0000000080000d32 <vmprint>:

void vmprint(pagetable_t pagetable,int level)
{
    80000d32:	711d                	addi	sp,sp,-96
    80000d34:	ec86                	sd	ra,88(sp)
    80000d36:	e8a2                	sd	s0,80(sp)
    80000d38:	e4a6                	sd	s1,72(sp)
    80000d3a:	e0ca                	sd	s2,64(sp)
    80000d3c:	fc4e                	sd	s3,56(sp)
    80000d3e:	f852                	sd	s4,48(sp)
    80000d40:	f456                	sd	s5,40(sp)
    80000d42:	f05a                	sd	s6,32(sp)
    80000d44:	ec5e                	sd	s7,24(sp)
    80000d46:	e862                	sd	s8,16(sp)
    80000d48:	e466                	sd	s9,8(sp)
    80000d4a:	1080                	addi	s0,sp,96
    80000d4c:	89aa                	mv	s3,a0
    80000d4e:	8bae                	mv	s7,a1
  if(level==0)
    80000d50:	cd81                	beqz	a1,80000d68 <vmprint+0x36>
  {
    printf("page table %p\n",pagetable);
    level+=1;
  }
  for(int i = 0; i < 512; i++){
    80000d52:	4901                	li	s2,0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d54:	4a85                	li	s5,1
      printf("%d: pte %p pa %p\n",i,pte,PTE2PA(pte));
      uint64 child = PTE2PA(pte);
      vmprint((pagetable_t)child,level+1);
    } else if(pte & PTE_V){
      page_print(level);
      printf("%d: pte %p pa %p\n",i,pte,PTE2PA(pte));
    80000d56:	00007c17          	auipc	s8,0x7
    80000d5a:	422c0c13          	addi	s8,s8,1058 # 80008178 <etext+0x178>
      vmprint((pagetable_t)child,level+1);
    80000d5e:	001b8c9b          	addiw	s9,s7,1
  for(int i = 0; i < 512; i++){
    80000d62:	20000a13          	li	s4,512
    80000d66:	a0b5                	j	80000dd2 <vmprint+0xa0>
    printf("page table %p\n",pagetable);
    80000d68:	85aa                	mv	a1,a0
    80000d6a:	00007517          	auipc	a0,0x7
    80000d6e:	3fe50513          	addi	a0,a0,1022 # 80008168 <etext+0x168>
    80000d72:	00005097          	auipc	ra,0x5
    80000d76:	15a080e7          	jalr	346(ra) # 80005ecc <printf>
    level+=1;
    80000d7a:	4b85                	li	s7,1
    80000d7c:	bfd9                	j	80000d52 <vmprint+0x20>
      page_print(level);
    80000d7e:	855e                	mv	a0,s7
    80000d80:	00000097          	auipc	ra,0x0
    80000d84:	f62080e7          	jalr	-158(ra) # 80000ce2 <page_print>
      printf("%d: pte %p pa %p\n",i,pte,PTE2PA(pte));
    80000d88:	00a4db13          	srli	s6,s1,0xa
    80000d8c:	0b32                	slli	s6,s6,0xc
    80000d8e:	86da                	mv	a3,s6
    80000d90:	8626                	mv	a2,s1
    80000d92:	85ca                	mv	a1,s2
    80000d94:	8562                	mv	a0,s8
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	136080e7          	jalr	310(ra) # 80005ecc <printf>
      vmprint((pagetable_t)child,level+1);
    80000d9e:	85e6                	mv	a1,s9
    80000da0:	855a                	mv	a0,s6
    80000da2:	00000097          	auipc	ra,0x0
    80000da6:	f90080e7          	jalr	-112(ra) # 80000d32 <vmprint>
    80000daa:	a005                	j	80000dca <vmprint+0x98>
      page_print(level);
    80000dac:	855e                	mv	a0,s7
    80000dae:	00000097          	auipc	ra,0x0
    80000db2:	f34080e7          	jalr	-204(ra) # 80000ce2 <page_print>
      printf("%d: pte %p pa %p\n",i,pte,PTE2PA(pte));
    80000db6:	00a4d693          	srli	a3,s1,0xa
    80000dba:	06b2                	slli	a3,a3,0xc
    80000dbc:	8626                	mv	a2,s1
    80000dbe:	85ca                	mv	a1,s2
    80000dc0:	8562                	mv	a0,s8
    80000dc2:	00005097          	auipc	ra,0x5
    80000dc6:	10a080e7          	jalr	266(ra) # 80005ecc <printf>
  for(int i = 0; i < 512; i++){
    80000dca:	2905                	addiw	s2,s2,1
    80000dcc:	09a1                	addi	s3,s3,8
    80000dce:	01490c63          	beq	s2,s4,80000de6 <vmprint+0xb4>
    pte_t pte = pagetable[i];
    80000dd2:	0009b483          	ld	s1,0(s3)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000dd6:	00f4f793          	andi	a5,s1,15
    80000dda:	fb5782e3          	beq	a5,s5,80000d7e <vmprint+0x4c>
    } else if(pte & PTE_V){
    80000dde:	0014f793          	andi	a5,s1,1
    80000de2:	d7e5                	beqz	a5,80000dca <vmprint+0x98>
    80000de4:	b7e1                	j	80000dac <vmprint+0x7a>
    }
  }
}
    80000de6:	60e6                	ld	ra,88(sp)
    80000de8:	6446                	ld	s0,80(sp)
    80000dea:	64a6                	ld	s1,72(sp)
    80000dec:	6906                	ld	s2,64(sp)
    80000dee:	79e2                	ld	s3,56(sp)
    80000df0:	7a42                	ld	s4,48(sp)
    80000df2:	7aa2                	ld	s5,40(sp)
    80000df4:	7b02                	ld	s6,32(sp)
    80000df6:	6be2                	ld	s7,24(sp)
    80000df8:	6c42                	ld	s8,16(sp)
    80000dfa:	6ca2                	ld	s9,8(sp)
    80000dfc:	6125                	addi	sp,sp,96
    80000dfe:	8082                	ret

0000000080000e00 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000e00:	7139                	addi	sp,sp,-64
    80000e02:	fc06                	sd	ra,56(sp)
    80000e04:	f822                	sd	s0,48(sp)
    80000e06:	f426                	sd	s1,40(sp)
    80000e08:	f04a                	sd	s2,32(sp)
    80000e0a:	ec4e                	sd	s3,24(sp)
    80000e0c:	e852                	sd	s4,16(sp)
    80000e0e:	e456                	sd	s5,8(sp)
    80000e10:	e05a                	sd	s6,0(sp)
    80000e12:	0080                	addi	s0,sp,64
    80000e14:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e16:	00008497          	auipc	s1,0x8
    80000e1a:	fba48493          	addi	s1,s1,-70 # 80008dd0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e1e:	8b26                	mv	s6,s1
    80000e20:	00007a97          	auipc	s5,0x7
    80000e24:	1e0a8a93          	addi	s5,s5,480 # 80008000 <etext>
    80000e28:	01000937          	lui	s2,0x1000
    80000e2c:	197d                	addi	s2,s2,-1
    80000e2e:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e30:	0000ea17          	auipc	s4,0xe
    80000e34:	ba0a0a13          	addi	s4,s4,-1120 # 8000e9d0 <tickslock>
    char *pa = kalloc();
    80000e38:	fffff097          	auipc	ra,0xfffff
    80000e3c:	2e0080e7          	jalr	736(ra) # 80000118 <kalloc>
    80000e40:	862a                	mv	a2,a0
    if(pa == 0)
    80000e42:	c129                	beqz	a0,80000e84 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e44:	416485b3          	sub	a1,s1,s6
    80000e48:	8591                	srai	a1,a1,0x4
    80000e4a:	000ab783          	ld	a5,0(s5)
    80000e4e:	02f585b3          	mul	a1,a1,a5
    80000e52:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e56:	4719                	li	a4,6
    80000e58:	6685                	lui	a3,0x1
    80000e5a:	40b905b3          	sub	a1,s2,a1
    80000e5e:	854e                	mv	a0,s3
    80000e60:	fffff097          	auipc	ra,0xfffff
    80000e64:	78c080e7          	jalr	1932(ra) # 800005ec <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e68:	17048493          	addi	s1,s1,368
    80000e6c:	fd4496e3          	bne	s1,s4,80000e38 <proc_mapstacks+0x38>
  }
}
    80000e70:	70e2                	ld	ra,56(sp)
    80000e72:	7442                	ld	s0,48(sp)
    80000e74:	74a2                	ld	s1,40(sp)
    80000e76:	7902                	ld	s2,32(sp)
    80000e78:	69e2                	ld	s3,24(sp)
    80000e7a:	6a42                	ld	s4,16(sp)
    80000e7c:	6aa2                	ld	s5,8(sp)
    80000e7e:	6b02                	ld	s6,0(sp)
    80000e80:	6121                	addi	sp,sp,64
    80000e82:	8082                	ret
      panic("kalloc");
    80000e84:	00007517          	auipc	a0,0x7
    80000e88:	30c50513          	addi	a0,a0,780 # 80008190 <etext+0x190>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	ff6080e7          	jalr	-10(ra) # 80005e82 <panic>

0000000080000e94 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e94:	7139                	addi	sp,sp,-64
    80000e96:	fc06                	sd	ra,56(sp)
    80000e98:	f822                	sd	s0,48(sp)
    80000e9a:	f426                	sd	s1,40(sp)
    80000e9c:	f04a                	sd	s2,32(sp)
    80000e9e:	ec4e                	sd	s3,24(sp)
    80000ea0:	e852                	sd	s4,16(sp)
    80000ea2:	e456                	sd	s5,8(sp)
    80000ea4:	e05a                	sd	s6,0(sp)
    80000ea6:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ea8:	00007597          	auipc	a1,0x7
    80000eac:	2f058593          	addi	a1,a1,752 # 80008198 <etext+0x198>
    80000eb0:	00008517          	auipc	a0,0x8
    80000eb4:	af050513          	addi	a0,a0,-1296 # 800089a0 <pid_lock>
    80000eb8:	00005097          	auipc	ra,0x5
    80000ebc:	484080e7          	jalr	1156(ra) # 8000633c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ec0:	00007597          	auipc	a1,0x7
    80000ec4:	2e058593          	addi	a1,a1,736 # 800081a0 <etext+0x1a0>
    80000ec8:	00008517          	auipc	a0,0x8
    80000ecc:	af050513          	addi	a0,a0,-1296 # 800089b8 <wait_lock>
    80000ed0:	00005097          	auipc	ra,0x5
    80000ed4:	46c080e7          	jalr	1132(ra) # 8000633c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed8:	00008497          	auipc	s1,0x8
    80000edc:	ef848493          	addi	s1,s1,-264 # 80008dd0 <proc>
      initlock(&p->lock, "proc");
    80000ee0:	00007b17          	auipc	s6,0x7
    80000ee4:	2d0b0b13          	addi	s6,s6,720 # 800081b0 <etext+0x1b0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ee8:	8aa6                	mv	s5,s1
    80000eea:	00007a17          	auipc	s4,0x7
    80000eee:	116a0a13          	addi	s4,s4,278 # 80008000 <etext>
    80000ef2:	01000937          	lui	s2,0x1000
    80000ef6:	197d                	addi	s2,s2,-1
    80000ef8:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000efa:	0000e997          	auipc	s3,0xe
    80000efe:	ad698993          	addi	s3,s3,-1322 # 8000e9d0 <tickslock>
      initlock(&p->lock, "proc");
    80000f02:	85da                	mv	a1,s6
    80000f04:	8526                	mv	a0,s1
    80000f06:	00005097          	auipc	ra,0x5
    80000f0a:	436080e7          	jalr	1078(ra) # 8000633c <initlock>
      p->state = UNUSED;
    80000f0e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000f12:	415487b3          	sub	a5,s1,s5
    80000f16:	8791                	srai	a5,a5,0x4
    80000f18:	000a3703          	ld	a4,0(s4)
    80000f1c:	02e787b3          	mul	a5,a5,a4
    80000f20:	00d7979b          	slliw	a5,a5,0xd
    80000f24:	40f907b3          	sub	a5,s2,a5
    80000f28:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2a:	17048493          	addi	s1,s1,368
    80000f2e:	fd349ae3          	bne	s1,s3,80000f02 <procinit+0x6e>
  }
}
    80000f32:	70e2                	ld	ra,56(sp)
    80000f34:	7442                	ld	s0,48(sp)
    80000f36:	74a2                	ld	s1,40(sp)
    80000f38:	7902                	ld	s2,32(sp)
    80000f3a:	69e2                	ld	s3,24(sp)
    80000f3c:	6a42                	ld	s4,16(sp)
    80000f3e:	6aa2                	ld	s5,8(sp)
    80000f40:	6b02                	ld	s6,0(sp)
    80000f42:	6121                	addi	sp,sp,64
    80000f44:	8082                	ret

0000000080000f46 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f46:	1141                	addi	sp,sp,-16
    80000f48:	e422                	sd	s0,8(sp)
    80000f4a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f4c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f4e:	2501                	sext.w	a0,a0
    80000f50:	6422                	ld	s0,8(sp)
    80000f52:	0141                	addi	sp,sp,16
    80000f54:	8082                	ret

0000000080000f56 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f56:	1141                	addi	sp,sp,-16
    80000f58:	e422                	sd	s0,8(sp)
    80000f5a:	0800                	addi	s0,sp,16
    80000f5c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f5e:	2781                	sext.w	a5,a5
    80000f60:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f62:	00008517          	auipc	a0,0x8
    80000f66:	a6e50513          	addi	a0,a0,-1426 # 800089d0 <cpus>
    80000f6a:	953e                	add	a0,a0,a5
    80000f6c:	6422                	ld	s0,8(sp)
    80000f6e:	0141                	addi	sp,sp,16
    80000f70:	8082                	ret

0000000080000f72 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f72:	1101                	addi	sp,sp,-32
    80000f74:	ec06                	sd	ra,24(sp)
    80000f76:	e822                	sd	s0,16(sp)
    80000f78:	e426                	sd	s1,8(sp)
    80000f7a:	1000                	addi	s0,sp,32
  push_off();
    80000f7c:	00005097          	auipc	ra,0x5
    80000f80:	404080e7          	jalr	1028(ra) # 80006380 <push_off>
    80000f84:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f86:	2781                	sext.w	a5,a5
    80000f88:	079e                	slli	a5,a5,0x7
    80000f8a:	00008717          	auipc	a4,0x8
    80000f8e:	a1670713          	addi	a4,a4,-1514 # 800089a0 <pid_lock>
    80000f92:	97ba                	add	a5,a5,a4
    80000f94:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f96:	00005097          	auipc	ra,0x5
    80000f9a:	48a080e7          	jalr	1162(ra) # 80006420 <pop_off>
  return p;
}
    80000f9e:	8526                	mv	a0,s1
    80000fa0:	60e2                	ld	ra,24(sp)
    80000fa2:	6442                	ld	s0,16(sp)
    80000fa4:	64a2                	ld	s1,8(sp)
    80000fa6:	6105                	addi	sp,sp,32
    80000fa8:	8082                	ret

0000000080000faa <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000faa:	1141                	addi	sp,sp,-16
    80000fac:	e406                	sd	ra,8(sp)
    80000fae:	e022                	sd	s0,0(sp)
    80000fb0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fb2:	00000097          	auipc	ra,0x0
    80000fb6:	fc0080e7          	jalr	-64(ra) # 80000f72 <myproc>
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	4c6080e7          	jalr	1222(ra) # 80006480 <release>

  if (first) {
    80000fc2:	00008797          	auipc	a5,0x8
    80000fc6:	91e7a783          	lw	a5,-1762(a5) # 800088e0 <first.1685>
    80000fca:	eb89                	bnez	a5,80000fdc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fcc:	00001097          	auipc	ra,0x1
    80000fd0:	cf0080e7          	jalr	-784(ra) # 80001cbc <usertrapret>
}
    80000fd4:	60a2                	ld	ra,8(sp)
    80000fd6:	6402                	ld	s0,0(sp)
    80000fd8:	0141                	addi	sp,sp,16
    80000fda:	8082                	ret
    first = 0;
    80000fdc:	00008797          	auipc	a5,0x8
    80000fe0:	9007a223          	sw	zero,-1788(a5) # 800088e0 <first.1685>
    fsinit(ROOTDEV);
    80000fe4:	4505                	li	a0,1
    80000fe6:	00002097          	auipc	ra,0x2
    80000fea:	b0e080e7          	jalr	-1266(ra) # 80002af4 <fsinit>
    80000fee:	bff9                	j	80000fcc <forkret+0x22>

0000000080000ff0 <allocpid>:
{
    80000ff0:	1101                	addi	sp,sp,-32
    80000ff2:	ec06                	sd	ra,24(sp)
    80000ff4:	e822                	sd	s0,16(sp)
    80000ff6:	e426                	sd	s1,8(sp)
    80000ff8:	e04a                	sd	s2,0(sp)
    80000ffa:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ffc:	00008917          	auipc	s2,0x8
    80001000:	9a490913          	addi	s2,s2,-1628 # 800089a0 <pid_lock>
    80001004:	854a                	mv	a0,s2
    80001006:	00005097          	auipc	ra,0x5
    8000100a:	3c6080e7          	jalr	966(ra) # 800063cc <acquire>
  pid = nextpid;
    8000100e:	00008797          	auipc	a5,0x8
    80001012:	8d678793          	addi	a5,a5,-1834 # 800088e4 <nextpid>
    80001016:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001018:	0014871b          	addiw	a4,s1,1
    8000101c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000101e:	854a                	mv	a0,s2
    80001020:	00005097          	auipc	ra,0x5
    80001024:	460080e7          	jalr	1120(ra) # 80006480 <release>
}
    80001028:	8526                	mv	a0,s1
    8000102a:	60e2                	ld	ra,24(sp)
    8000102c:	6442                	ld	s0,16(sp)
    8000102e:	64a2                	ld	s1,8(sp)
    80001030:	6902                	ld	s2,0(sp)
    80001032:	6105                	addi	sp,sp,32
    80001034:	8082                	ret

0000000080001036 <proc_pagetable>:
{
    80001036:	1101                	addi	sp,sp,-32
    80001038:	ec06                	sd	ra,24(sp)
    8000103a:	e822                	sd	s0,16(sp)
    8000103c:	e426                	sd	s1,8(sp)
    8000103e:	e04a                	sd	s2,0(sp)
    80001040:	1000                	addi	s0,sp,32
    80001042:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001044:	fffff097          	auipc	ra,0xfffff
    80001048:	792080e7          	jalr	1938(ra) # 800007d6 <uvmcreate>
    8000104c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000104e:	cd39                	beqz	a0,800010ac <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001050:	4729                	li	a4,10
    80001052:	00006697          	auipc	a3,0x6
    80001056:	fae68693          	addi	a3,a3,-82 # 80007000 <_trampoline>
    8000105a:	6605                	lui	a2,0x1
    8000105c:	040005b7          	lui	a1,0x4000
    80001060:	15fd                	addi	a1,a1,-1
    80001062:	05b2                	slli	a1,a1,0xc
    80001064:	fffff097          	auipc	ra,0xfffff
    80001068:	4e8080e7          	jalr	1256(ra) # 8000054c <mappages>
    8000106c:	04054763          	bltz	a0,800010ba <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001070:	4719                	li	a4,6
    80001072:	05893683          	ld	a3,88(s2)
    80001076:	6605                	lui	a2,0x1
    80001078:	020005b7          	lui	a1,0x2000
    8000107c:	15fd                	addi	a1,a1,-1
    8000107e:	05b6                	slli	a1,a1,0xd
    80001080:	8526                	mv	a0,s1
    80001082:	fffff097          	auipc	ra,0xfffff
    80001086:	4ca080e7          	jalr	1226(ra) # 8000054c <mappages>
    8000108a:	04054063          	bltz	a0,800010ca <proc_pagetable+0x94>
  if(mappages(pagetable,USYSCALL,PGSIZE,(uint64)p->s_pa,PTE_R|PTE_U)<0)
    8000108e:	4749                	li	a4,18
    80001090:	16893683          	ld	a3,360(s2)
    80001094:	6605                	lui	a2,0x1
    80001096:	040005b7          	lui	a1,0x4000
    8000109a:	15f5                	addi	a1,a1,-3
    8000109c:	05b2                	slli	a1,a1,0xc
    8000109e:	8526                	mv	a0,s1
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	4ac080e7          	jalr	1196(ra) # 8000054c <mappages>
    800010a8:	04054463          	bltz	a0,800010f0 <proc_pagetable+0xba>
}
    800010ac:	8526                	mv	a0,s1
    800010ae:	60e2                	ld	ra,24(sp)
    800010b0:	6442                	ld	s0,16(sp)
    800010b2:	64a2                	ld	s1,8(sp)
    800010b4:	6902                	ld	s2,0(sp)
    800010b6:	6105                	addi	sp,sp,32
    800010b8:	8082                	ret
    uvmfree(pagetable, 0);
    800010ba:	4581                	li	a1,0
    800010bc:	8526                	mv	a0,s1
    800010be:	00000097          	auipc	ra,0x0
    800010c2:	91c080e7          	jalr	-1764(ra) # 800009da <uvmfree>
    return 0;
    800010c6:	4481                	li	s1,0
    800010c8:	b7d5                	j	800010ac <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010ca:	4681                	li	a3,0
    800010cc:	4605                	li	a2,1
    800010ce:	040005b7          	lui	a1,0x4000
    800010d2:	15fd                	addi	a1,a1,-1
    800010d4:	05b2                	slli	a1,a1,0xc
    800010d6:	8526                	mv	a0,s1
    800010d8:	fffff097          	auipc	ra,0xfffff
    800010dc:	63a080e7          	jalr	1594(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, 0);
    800010e0:	4581                	li	a1,0
    800010e2:	8526                	mv	a0,s1
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	8f6080e7          	jalr	-1802(ra) # 800009da <uvmfree>
    return 0;
    800010ec:	4481                	li	s1,0
    800010ee:	bf7d                	j	800010ac <proc_pagetable+0x76>
    printf("mapfail\n");
    800010f0:	00007517          	auipc	a0,0x7
    800010f4:	0c850513          	addi	a0,a0,200 # 800081b8 <etext+0x1b8>
    800010f8:	00005097          	auipc	ra,0x5
    800010fc:	dd4080e7          	jalr	-556(ra) # 80005ecc <printf>
    return 0;
    80001100:	4481                	li	s1,0
    80001102:	b76d                	j	800010ac <proc_pagetable+0x76>

0000000080001104 <proc_freepagetable>:
{
    80001104:	7179                	addi	sp,sp,-48
    80001106:	f406                	sd	ra,40(sp)
    80001108:	f022                	sd	s0,32(sp)
    8000110a:	ec26                	sd	s1,24(sp)
    8000110c:	e84a                	sd	s2,16(sp)
    8000110e:	e44e                	sd	s3,8(sp)
    80001110:	1800                	addi	s0,sp,48
    80001112:	84aa                	mv	s1,a0
    80001114:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001116:	4681                	li	a3,0
    80001118:	4605                	li	a2,1
    8000111a:	04000937          	lui	s2,0x4000
    8000111e:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001122:	05b2                	slli	a1,a1,0xc
    80001124:	fffff097          	auipc	ra,0xfffff
    80001128:	5ee080e7          	jalr	1518(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000112c:	4681                	li	a3,0
    8000112e:	4605                	li	a2,1
    80001130:	020005b7          	lui	a1,0x2000
    80001134:	15fd                	addi	a1,a1,-1
    80001136:	05b6                	slli	a1,a1,0xd
    80001138:	8526                	mv	a0,s1
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	5d8080e7          	jalr	1496(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable,USYSCALL,1,0);
    80001142:	4681                	li	a3,0
    80001144:	4605                	li	a2,1
    80001146:	1975                	addi	s2,s2,-3
    80001148:	00c91593          	slli	a1,s2,0xc
    8000114c:	8526                	mv	a0,s1
    8000114e:	fffff097          	auipc	ra,0xfffff
    80001152:	5c4080e7          	jalr	1476(ra) # 80000712 <uvmunmap>
  uvmfree(pagetable, sz);
    80001156:	85ce                	mv	a1,s3
    80001158:	8526                	mv	a0,s1
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	880080e7          	jalr	-1920(ra) # 800009da <uvmfree>
}
    80001162:	70a2                	ld	ra,40(sp)
    80001164:	7402                	ld	s0,32(sp)
    80001166:	64e2                	ld	s1,24(sp)
    80001168:	6942                	ld	s2,16(sp)
    8000116a:	69a2                	ld	s3,8(sp)
    8000116c:	6145                	addi	sp,sp,48
    8000116e:	8082                	ret

0000000080001170 <freeproc>:
{
    80001170:	1101                	addi	sp,sp,-32
    80001172:	ec06                	sd	ra,24(sp)
    80001174:	e822                	sd	s0,16(sp)
    80001176:	e426                	sd	s1,8(sp)
    80001178:	1000                	addi	s0,sp,32
    8000117a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000117c:	6d28                	ld	a0,88(a0)
    8000117e:	c509                	beqz	a0,80001188 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	e9c080e7          	jalr	-356(ra) # 8000001c <kfree>
  if(p->s_pa)
    80001188:	1684b503          	ld	a0,360(s1)
    8000118c:	c509                	beqz	a0,80001196 <freeproc+0x26>
    kfree((void*)p->s_pa);
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	e8e080e7          	jalr	-370(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001196:	0404bc23          	sd	zero,88(s1)
  p->s_pa=0;
    8000119a:	1604b423          	sd	zero,360(s1)
  if(p->pagetable)
    8000119e:	68a8                	ld	a0,80(s1)
    800011a0:	c511                	beqz	a0,800011ac <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    800011a2:	64ac                	ld	a1,72(s1)
    800011a4:	00000097          	auipc	ra,0x0
    800011a8:	f60080e7          	jalr	-160(ra) # 80001104 <proc_freepagetable>
  p->pagetable = 0;
    800011ac:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011b0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011b4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011b8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011bc:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011c0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011c4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011c8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011cc:	0004ac23          	sw	zero,24(s1)
}
    800011d0:	60e2                	ld	ra,24(sp)
    800011d2:	6442                	ld	s0,16(sp)
    800011d4:	64a2                	ld	s1,8(sp)
    800011d6:	6105                	addi	sp,sp,32
    800011d8:	8082                	ret

00000000800011da <allocproc>:
{
    800011da:	7179                	addi	sp,sp,-48
    800011dc:	f406                	sd	ra,40(sp)
    800011de:	f022                	sd	s0,32(sp)
    800011e0:	ec26                	sd	s1,24(sp)
    800011e2:	e84a                	sd	s2,16(sp)
    800011e4:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    800011e6:	00008497          	auipc	s1,0x8
    800011ea:	bea48493          	addi	s1,s1,-1046 # 80008dd0 <proc>
    800011ee:	0000d917          	auipc	s2,0xd
    800011f2:	7e290913          	addi	s2,s2,2018 # 8000e9d0 <tickslock>
    acquire(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	00005097          	auipc	ra,0x5
    800011fc:	1d4080e7          	jalr	468(ra) # 800063cc <acquire>
    if(p->state == UNUSED) {
    80001200:	4c9c                	lw	a5,24(s1)
    80001202:	cf81                	beqz	a5,8000121a <allocproc+0x40>
      release(&p->lock);
    80001204:	8526                	mv	a0,s1
    80001206:	00005097          	auipc	ra,0x5
    8000120a:	27a080e7          	jalr	634(ra) # 80006480 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000120e:	17048493          	addi	s1,s1,368
    80001212:	ff2492e3          	bne	s1,s2,800011f6 <allocproc+0x1c>
  return 0;
    80001216:	4481                	li	s1,0
    80001218:	a89d                	j	8000128e <allocproc+0xb4>
  p->pid = allocpid();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	dd6080e7          	jalr	-554(ra) # 80000ff0 <allocpid>
    80001222:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001224:	4785                	li	a5,1
    80001226:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001228:	fffff097          	auipc	ra,0xfffff
    8000122c:	ef0080e7          	jalr	-272(ra) # 80000118 <kalloc>
    80001230:	892a                	mv	s2,a0
    80001232:	eca8                	sd	a0,88(s1)
    80001234:	c525                	beqz	a0,8000129c <allocproc+0xc2>
  call.pid=p->pid;
    80001236:	589c                	lw	a5,48(s1)
    80001238:	fcf42c23          	sw	a5,-40(s0)
  if((p->s_pa=kalloc())==0){
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	edc080e7          	jalr	-292(ra) # 80000118 <kalloc>
    80001244:	892a                	mv	s2,a0
    80001246:	16a4b423          	sd	a0,360(s1)
    8000124a:	c52d                	beqz	a0,800012b4 <allocproc+0xda>
  memmove(p->s_pa,&call,sizeof(call));
    8000124c:	4611                	li	a2,4
    8000124e:	fd840593          	addi	a1,s0,-40
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	f86080e7          	jalr	-122(ra) # 800001d8 <memmove>
  p->pagetable = proc_pagetable(p);
    8000125a:	8526                	mv	a0,s1
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	dda080e7          	jalr	-550(ra) # 80001036 <proc_pagetable>
    80001264:	892a                	mv	s2,a0
    80001266:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001268:	c135                	beqz	a0,800012cc <allocproc+0xf2>
  memset(&p->context, 0, sizeof(p->context));
    8000126a:	07000613          	li	a2,112
    8000126e:	4581                	li	a1,0
    80001270:	06048513          	addi	a0,s1,96
    80001274:	fffff097          	auipc	ra,0xfffff
    80001278:	f04080e7          	jalr	-252(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000127c:	00000797          	auipc	a5,0x0
    80001280:	d2e78793          	addi	a5,a5,-722 # 80000faa <forkret>
    80001284:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001286:	60bc                	ld	a5,64(s1)
    80001288:	6705                	lui	a4,0x1
    8000128a:	97ba                	add	a5,a5,a4
    8000128c:	f4bc                	sd	a5,104(s1)
}
    8000128e:	8526                	mv	a0,s1
    80001290:	70a2                	ld	ra,40(sp)
    80001292:	7402                	ld	s0,32(sp)
    80001294:	64e2                	ld	s1,24(sp)
    80001296:	6942                	ld	s2,16(sp)
    80001298:	6145                	addi	sp,sp,48
    8000129a:	8082                	ret
    freeproc(p);
    8000129c:	8526                	mv	a0,s1
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	ed2080e7          	jalr	-302(ra) # 80001170 <freeproc>
    release(&p->lock);
    800012a6:	8526                	mv	a0,s1
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	1d8080e7          	jalr	472(ra) # 80006480 <release>
    return 0;
    800012b0:	84ca                	mv	s1,s2
    800012b2:	bff1                	j	8000128e <allocproc+0xb4>
    freeproc(p);
    800012b4:	8526                	mv	a0,s1
    800012b6:	00000097          	auipc	ra,0x0
    800012ba:	eba080e7          	jalr	-326(ra) # 80001170 <freeproc>
    release(&p->lock);
    800012be:	8526                	mv	a0,s1
    800012c0:	00005097          	auipc	ra,0x5
    800012c4:	1c0080e7          	jalr	448(ra) # 80006480 <release>
    return 0;
    800012c8:	84ca                	mv	s1,s2
    800012ca:	b7d1                	j	8000128e <allocproc+0xb4>
    freeproc(p);
    800012cc:	8526                	mv	a0,s1
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	ea2080e7          	jalr	-350(ra) # 80001170 <freeproc>
    release(&p->lock);
    800012d6:	8526                	mv	a0,s1
    800012d8:	00005097          	auipc	ra,0x5
    800012dc:	1a8080e7          	jalr	424(ra) # 80006480 <release>
    return 0;
    800012e0:	84ca                	mv	s1,s2
    800012e2:	b775                	j	8000128e <allocproc+0xb4>

00000000800012e4 <userinit>:
{
    800012e4:	1101                	addi	sp,sp,-32
    800012e6:	ec06                	sd	ra,24(sp)
    800012e8:	e822                	sd	s0,16(sp)
    800012ea:	e426                	sd	s1,8(sp)
    800012ec:	1000                	addi	s0,sp,32
  p = allocproc();
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	eec080e7          	jalr	-276(ra) # 800011da <allocproc>
    800012f6:	84aa                	mv	s1,a0
  initproc = p;
    800012f8:	00007797          	auipc	a5,0x7
    800012fc:	66a7b423          	sd	a0,1640(a5) # 80008960 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001300:	03400613          	li	a2,52
    80001304:	00007597          	auipc	a1,0x7
    80001308:	5ec58593          	addi	a1,a1,1516 # 800088f0 <initcode>
    8000130c:	6928                	ld	a0,80(a0)
    8000130e:	fffff097          	auipc	ra,0xfffff
    80001312:	4f6080e7          	jalr	1270(ra) # 80000804 <uvmfirst>
  p->sz = PGSIZE;
    80001316:	6785                	lui	a5,0x1
    80001318:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000131a:	6cb8                	ld	a4,88(s1)
    8000131c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001320:	6cb8                	ld	a4,88(s1)
    80001322:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001324:	4641                	li	a2,16
    80001326:	00007597          	auipc	a1,0x7
    8000132a:	ea258593          	addi	a1,a1,-350 # 800081c8 <etext+0x1c8>
    8000132e:	15848513          	addi	a0,s1,344
    80001332:	fffff097          	auipc	ra,0xfffff
    80001336:	f98080e7          	jalr	-104(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000133a:	00007517          	auipc	a0,0x7
    8000133e:	e9e50513          	addi	a0,a0,-354 # 800081d8 <etext+0x1d8>
    80001342:	00002097          	auipc	ra,0x2
    80001346:	1d4080e7          	jalr	468(ra) # 80003516 <namei>
    8000134a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000134e:	478d                	li	a5,3
    80001350:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001352:	8526                	mv	a0,s1
    80001354:	00005097          	auipc	ra,0x5
    80001358:	12c080e7          	jalr	300(ra) # 80006480 <release>
}
    8000135c:	60e2                	ld	ra,24(sp)
    8000135e:	6442                	ld	s0,16(sp)
    80001360:	64a2                	ld	s1,8(sp)
    80001362:	6105                	addi	sp,sp,32
    80001364:	8082                	ret

0000000080001366 <growproc>:
{
    80001366:	1101                	addi	sp,sp,-32
    80001368:	ec06                	sd	ra,24(sp)
    8000136a:	e822                	sd	s0,16(sp)
    8000136c:	e426                	sd	s1,8(sp)
    8000136e:	e04a                	sd	s2,0(sp)
    80001370:	1000                	addi	s0,sp,32
    80001372:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001374:	00000097          	auipc	ra,0x0
    80001378:	bfe080e7          	jalr	-1026(ra) # 80000f72 <myproc>
    8000137c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000137e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001380:	01204c63          	bgtz	s2,80001398 <growproc+0x32>
  } else if(n < 0){
    80001384:	02094663          	bltz	s2,800013b0 <growproc+0x4a>
  p->sz = sz;
    80001388:	e4ac                	sd	a1,72(s1)
  return 0;
    8000138a:	4501                	li	a0,0
}
    8000138c:	60e2                	ld	ra,24(sp)
    8000138e:	6442                	ld	s0,16(sp)
    80001390:	64a2                	ld	s1,8(sp)
    80001392:	6902                	ld	s2,0(sp)
    80001394:	6105                	addi	sp,sp,32
    80001396:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001398:	4691                	li	a3,4
    8000139a:	00b90633          	add	a2,s2,a1
    8000139e:	6928                	ld	a0,80(a0)
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	51e080e7          	jalr	1310(ra) # 800008be <uvmalloc>
    800013a8:	85aa                	mv	a1,a0
    800013aa:	fd79                	bnez	a0,80001388 <growproc+0x22>
      return -1;
    800013ac:	557d                	li	a0,-1
    800013ae:	bff9                	j	8000138c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013b0:	00b90633          	add	a2,s2,a1
    800013b4:	6928                	ld	a0,80(a0)
    800013b6:	fffff097          	auipc	ra,0xfffff
    800013ba:	4c0080e7          	jalr	1216(ra) # 80000876 <uvmdealloc>
    800013be:	85aa                	mv	a1,a0
    800013c0:	b7e1                	j	80001388 <growproc+0x22>

00000000800013c2 <fork>:
{
    800013c2:	7179                	addi	sp,sp,-48
    800013c4:	f406                	sd	ra,40(sp)
    800013c6:	f022                	sd	s0,32(sp)
    800013c8:	ec26                	sd	s1,24(sp)
    800013ca:	e84a                	sd	s2,16(sp)
    800013cc:	e44e                	sd	s3,8(sp)
    800013ce:	e052                	sd	s4,0(sp)
    800013d0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013d2:	00000097          	auipc	ra,0x0
    800013d6:	ba0080e7          	jalr	-1120(ra) # 80000f72 <myproc>
    800013da:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	dfe080e7          	jalr	-514(ra) # 800011da <allocproc>
    800013e4:	10050b63          	beqz	a0,800014fa <fork+0x138>
    800013e8:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013ea:	04893603          	ld	a2,72(s2)
    800013ee:	692c                	ld	a1,80(a0)
    800013f0:	05093503          	ld	a0,80(s2)
    800013f4:	fffff097          	auipc	ra,0xfffff
    800013f8:	61e080e7          	jalr	1566(ra) # 80000a12 <uvmcopy>
    800013fc:	04054663          	bltz	a0,80001448 <fork+0x86>
  np->sz = p->sz;
    80001400:	04893783          	ld	a5,72(s2)
    80001404:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001408:	05893683          	ld	a3,88(s2)
    8000140c:	87b6                	mv	a5,a3
    8000140e:	0589b703          	ld	a4,88(s3)
    80001412:	12068693          	addi	a3,a3,288
    80001416:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000141a:	6788                	ld	a0,8(a5)
    8000141c:	6b8c                	ld	a1,16(a5)
    8000141e:	6f90                	ld	a2,24(a5)
    80001420:	01073023          	sd	a6,0(a4)
    80001424:	e708                	sd	a0,8(a4)
    80001426:	eb0c                	sd	a1,16(a4)
    80001428:	ef10                	sd	a2,24(a4)
    8000142a:	02078793          	addi	a5,a5,32
    8000142e:	02070713          	addi	a4,a4,32
    80001432:	fed792e3          	bne	a5,a3,80001416 <fork+0x54>
  np->trapframe->a0 = 0;
    80001436:	0589b783          	ld	a5,88(s3)
    8000143a:	0607b823          	sd	zero,112(a5)
    8000143e:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001442:	15000a13          	li	s4,336
    80001446:	a03d                	j	80001474 <fork+0xb2>
    freeproc(np);
    80001448:	854e                	mv	a0,s3
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	d26080e7          	jalr	-730(ra) # 80001170 <freeproc>
    release(&np->lock);
    80001452:	854e                	mv	a0,s3
    80001454:	00005097          	auipc	ra,0x5
    80001458:	02c080e7          	jalr	44(ra) # 80006480 <release>
    return -1;
    8000145c:	5a7d                	li	s4,-1
    8000145e:	a069                	j	800014e8 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001460:	00002097          	auipc	ra,0x2
    80001464:	74c080e7          	jalr	1868(ra) # 80003bac <filedup>
    80001468:	009987b3          	add	a5,s3,s1
    8000146c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000146e:	04a1                	addi	s1,s1,8
    80001470:	01448763          	beq	s1,s4,8000147e <fork+0xbc>
    if(p->ofile[i])
    80001474:	009907b3          	add	a5,s2,s1
    80001478:	6388                	ld	a0,0(a5)
    8000147a:	f17d                	bnez	a0,80001460 <fork+0x9e>
    8000147c:	bfcd                	j	8000146e <fork+0xac>
  np->cwd = idup(p->cwd);
    8000147e:	15093503          	ld	a0,336(s2)
    80001482:	00002097          	auipc	ra,0x2
    80001486:	8b0080e7          	jalr	-1872(ra) # 80002d32 <idup>
    8000148a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000148e:	4641                	li	a2,16
    80001490:	15890593          	addi	a1,s2,344
    80001494:	15898513          	addi	a0,s3,344
    80001498:	fffff097          	auipc	ra,0xfffff
    8000149c:	e32080e7          	jalr	-462(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800014a0:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800014a4:	854e                	mv	a0,s3
    800014a6:	00005097          	auipc	ra,0x5
    800014aa:	fda080e7          	jalr	-38(ra) # 80006480 <release>
  acquire(&wait_lock);
    800014ae:	00007497          	auipc	s1,0x7
    800014b2:	50a48493          	addi	s1,s1,1290 # 800089b8 <wait_lock>
    800014b6:	8526                	mv	a0,s1
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	f14080e7          	jalr	-236(ra) # 800063cc <acquire>
  np->parent = p;
    800014c0:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014c4:	8526                	mv	a0,s1
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	fba080e7          	jalr	-70(ra) # 80006480 <release>
  acquire(&np->lock);
    800014ce:	854e                	mv	a0,s3
    800014d0:	00005097          	auipc	ra,0x5
    800014d4:	efc080e7          	jalr	-260(ra) # 800063cc <acquire>
  np->state = RUNNABLE;
    800014d8:	478d                	li	a5,3
    800014da:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014de:	854e                	mv	a0,s3
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	fa0080e7          	jalr	-96(ra) # 80006480 <release>
}
    800014e8:	8552                	mv	a0,s4
    800014ea:	70a2                	ld	ra,40(sp)
    800014ec:	7402                	ld	s0,32(sp)
    800014ee:	64e2                	ld	s1,24(sp)
    800014f0:	6942                	ld	s2,16(sp)
    800014f2:	69a2                	ld	s3,8(sp)
    800014f4:	6a02                	ld	s4,0(sp)
    800014f6:	6145                	addi	sp,sp,48
    800014f8:	8082                	ret
    return -1;
    800014fa:	5a7d                	li	s4,-1
    800014fc:	b7f5                	j	800014e8 <fork+0x126>

00000000800014fe <scheduler>:
{
    800014fe:	7139                	addi	sp,sp,-64
    80001500:	fc06                	sd	ra,56(sp)
    80001502:	f822                	sd	s0,48(sp)
    80001504:	f426                	sd	s1,40(sp)
    80001506:	f04a                	sd	s2,32(sp)
    80001508:	ec4e                	sd	s3,24(sp)
    8000150a:	e852                	sd	s4,16(sp)
    8000150c:	e456                	sd	s5,8(sp)
    8000150e:	e05a                	sd	s6,0(sp)
    80001510:	0080                	addi	s0,sp,64
    80001512:	8792                	mv	a5,tp
  int id = r_tp();
    80001514:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001516:	00779a93          	slli	s5,a5,0x7
    8000151a:	00007717          	auipc	a4,0x7
    8000151e:	48670713          	addi	a4,a4,1158 # 800089a0 <pid_lock>
    80001522:	9756                	add	a4,a4,s5
    80001524:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001528:	00007717          	auipc	a4,0x7
    8000152c:	4b070713          	addi	a4,a4,1200 # 800089d8 <cpus+0x8>
    80001530:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001532:	498d                	li	s3,3
        p->state = RUNNING;
    80001534:	4b11                	li	s6,4
        c->proc = p;
    80001536:	079e                	slli	a5,a5,0x7
    80001538:	00007a17          	auipc	s4,0x7
    8000153c:	468a0a13          	addi	s4,s4,1128 # 800089a0 <pid_lock>
    80001540:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001542:	0000d917          	auipc	s2,0xd
    80001546:	48e90913          	addi	s2,s2,1166 # 8000e9d0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000154a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000154e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001552:	10079073          	csrw	sstatus,a5
    80001556:	00008497          	auipc	s1,0x8
    8000155a:	87a48493          	addi	s1,s1,-1926 # 80008dd0 <proc>
    8000155e:	a03d                	j	8000158c <scheduler+0x8e>
        p->state = RUNNING;
    80001560:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001564:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001568:	06048593          	addi	a1,s1,96
    8000156c:	8556                	mv	a0,s5
    8000156e:	00000097          	auipc	ra,0x0
    80001572:	6a4080e7          	jalr	1700(ra) # 80001c12 <swtch>
        c->proc = 0;
    80001576:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000157a:	8526                	mv	a0,s1
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	f04080e7          	jalr	-252(ra) # 80006480 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001584:	17048493          	addi	s1,s1,368
    80001588:	fd2481e3          	beq	s1,s2,8000154a <scheduler+0x4c>
      acquire(&p->lock);
    8000158c:	8526                	mv	a0,s1
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	e3e080e7          	jalr	-450(ra) # 800063cc <acquire>
      if(p->state == RUNNABLE) {
    80001596:	4c9c                	lw	a5,24(s1)
    80001598:	ff3791e3          	bne	a5,s3,8000157a <scheduler+0x7c>
    8000159c:	b7d1                	j	80001560 <scheduler+0x62>

000000008000159e <sched>:
{
    8000159e:	7179                	addi	sp,sp,-48
    800015a0:	f406                	sd	ra,40(sp)
    800015a2:	f022                	sd	s0,32(sp)
    800015a4:	ec26                	sd	s1,24(sp)
    800015a6:	e84a                	sd	s2,16(sp)
    800015a8:	e44e                	sd	s3,8(sp)
    800015aa:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015ac:	00000097          	auipc	ra,0x0
    800015b0:	9c6080e7          	jalr	-1594(ra) # 80000f72 <myproc>
    800015b4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	d9c080e7          	jalr	-612(ra) # 80006352 <holding>
    800015be:	c93d                	beqz	a0,80001634 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015c0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015c2:	2781                	sext.w	a5,a5
    800015c4:	079e                	slli	a5,a5,0x7
    800015c6:	00007717          	auipc	a4,0x7
    800015ca:	3da70713          	addi	a4,a4,986 # 800089a0 <pid_lock>
    800015ce:	97ba                	add	a5,a5,a4
    800015d0:	0a87a703          	lw	a4,168(a5)
    800015d4:	4785                	li	a5,1
    800015d6:	06f71763          	bne	a4,a5,80001644 <sched+0xa6>
  if(p->state == RUNNING)
    800015da:	4c98                	lw	a4,24(s1)
    800015dc:	4791                	li	a5,4
    800015de:	06f70b63          	beq	a4,a5,80001654 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015e2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015e6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015e8:	efb5                	bnez	a5,80001664 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ea:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015ec:	00007917          	auipc	s2,0x7
    800015f0:	3b490913          	addi	s2,s2,948 # 800089a0 <pid_lock>
    800015f4:	2781                	sext.w	a5,a5
    800015f6:	079e                	slli	a5,a5,0x7
    800015f8:	97ca                	add	a5,a5,s2
    800015fa:	0ac7a983          	lw	s3,172(a5)
    800015fe:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001600:	2781                	sext.w	a5,a5
    80001602:	079e                	slli	a5,a5,0x7
    80001604:	00007597          	auipc	a1,0x7
    80001608:	3d458593          	addi	a1,a1,980 # 800089d8 <cpus+0x8>
    8000160c:	95be                	add	a1,a1,a5
    8000160e:	06048513          	addi	a0,s1,96
    80001612:	00000097          	auipc	ra,0x0
    80001616:	600080e7          	jalr	1536(ra) # 80001c12 <swtch>
    8000161a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000161c:	2781                	sext.w	a5,a5
    8000161e:	079e                	slli	a5,a5,0x7
    80001620:	97ca                	add	a5,a5,s2
    80001622:	0b37a623          	sw	s3,172(a5)
}
    80001626:	70a2                	ld	ra,40(sp)
    80001628:	7402                	ld	s0,32(sp)
    8000162a:	64e2                	ld	s1,24(sp)
    8000162c:	6942                	ld	s2,16(sp)
    8000162e:	69a2                	ld	s3,8(sp)
    80001630:	6145                	addi	sp,sp,48
    80001632:	8082                	ret
    panic("sched p->lock");
    80001634:	00007517          	auipc	a0,0x7
    80001638:	bac50513          	addi	a0,a0,-1108 # 800081e0 <etext+0x1e0>
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	846080e7          	jalr	-1978(ra) # 80005e82 <panic>
    panic("sched locks");
    80001644:	00007517          	auipc	a0,0x7
    80001648:	bac50513          	addi	a0,a0,-1108 # 800081f0 <etext+0x1f0>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	836080e7          	jalr	-1994(ra) # 80005e82 <panic>
    panic("sched running");
    80001654:	00007517          	auipc	a0,0x7
    80001658:	bac50513          	addi	a0,a0,-1108 # 80008200 <etext+0x200>
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	826080e7          	jalr	-2010(ra) # 80005e82 <panic>
    panic("sched interruptible");
    80001664:	00007517          	auipc	a0,0x7
    80001668:	bac50513          	addi	a0,a0,-1108 # 80008210 <etext+0x210>
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	816080e7          	jalr	-2026(ra) # 80005e82 <panic>

0000000080001674 <yield>:
{
    80001674:	1101                	addi	sp,sp,-32
    80001676:	ec06                	sd	ra,24(sp)
    80001678:	e822                	sd	s0,16(sp)
    8000167a:	e426                	sd	s1,8(sp)
    8000167c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000167e:	00000097          	auipc	ra,0x0
    80001682:	8f4080e7          	jalr	-1804(ra) # 80000f72 <myproc>
    80001686:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001688:	00005097          	auipc	ra,0x5
    8000168c:	d44080e7          	jalr	-700(ra) # 800063cc <acquire>
  p->state = RUNNABLE;
    80001690:	478d                	li	a5,3
    80001692:	cc9c                	sw	a5,24(s1)
  sched();
    80001694:	00000097          	auipc	ra,0x0
    80001698:	f0a080e7          	jalr	-246(ra) # 8000159e <sched>
  release(&p->lock);
    8000169c:	8526                	mv	a0,s1
    8000169e:	00005097          	auipc	ra,0x5
    800016a2:	de2080e7          	jalr	-542(ra) # 80006480 <release>
}
    800016a6:	60e2                	ld	ra,24(sp)
    800016a8:	6442                	ld	s0,16(sp)
    800016aa:	64a2                	ld	s1,8(sp)
    800016ac:	6105                	addi	sp,sp,32
    800016ae:	8082                	ret

00000000800016b0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016b0:	7179                	addi	sp,sp,-48
    800016b2:	f406                	sd	ra,40(sp)
    800016b4:	f022                	sd	s0,32(sp)
    800016b6:	ec26                	sd	s1,24(sp)
    800016b8:	e84a                	sd	s2,16(sp)
    800016ba:	e44e                	sd	s3,8(sp)
    800016bc:	1800                	addi	s0,sp,48
    800016be:	89aa                	mv	s3,a0
    800016c0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016c2:	00000097          	auipc	ra,0x0
    800016c6:	8b0080e7          	jalr	-1872(ra) # 80000f72 <myproc>
    800016ca:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016cc:	00005097          	auipc	ra,0x5
    800016d0:	d00080e7          	jalr	-768(ra) # 800063cc <acquire>
  release(lk);
    800016d4:	854a                	mv	a0,s2
    800016d6:	00005097          	auipc	ra,0x5
    800016da:	daa080e7          	jalr	-598(ra) # 80006480 <release>

  // Go to sleep.
  p->chan = chan;
    800016de:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016e2:	4789                	li	a5,2
    800016e4:	cc9c                	sw	a5,24(s1)

  sched();
    800016e6:	00000097          	auipc	ra,0x0
    800016ea:	eb8080e7          	jalr	-328(ra) # 8000159e <sched>

  // Tidy up.
  p->chan = 0;
    800016ee:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016f2:	8526                	mv	a0,s1
    800016f4:	00005097          	auipc	ra,0x5
    800016f8:	d8c080e7          	jalr	-628(ra) # 80006480 <release>
  acquire(lk);
    800016fc:	854a                	mv	a0,s2
    800016fe:	00005097          	auipc	ra,0x5
    80001702:	cce080e7          	jalr	-818(ra) # 800063cc <acquire>
}
    80001706:	70a2                	ld	ra,40(sp)
    80001708:	7402                	ld	s0,32(sp)
    8000170a:	64e2                	ld	s1,24(sp)
    8000170c:	6942                	ld	s2,16(sp)
    8000170e:	69a2                	ld	s3,8(sp)
    80001710:	6145                	addi	sp,sp,48
    80001712:	8082                	ret

0000000080001714 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001714:	7139                	addi	sp,sp,-64
    80001716:	fc06                	sd	ra,56(sp)
    80001718:	f822                	sd	s0,48(sp)
    8000171a:	f426                	sd	s1,40(sp)
    8000171c:	f04a                	sd	s2,32(sp)
    8000171e:	ec4e                	sd	s3,24(sp)
    80001720:	e852                	sd	s4,16(sp)
    80001722:	e456                	sd	s5,8(sp)
    80001724:	0080                	addi	s0,sp,64
    80001726:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001728:	00007497          	auipc	s1,0x7
    8000172c:	6a848493          	addi	s1,s1,1704 # 80008dd0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001730:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001732:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001734:	0000d917          	auipc	s2,0xd
    80001738:	29c90913          	addi	s2,s2,668 # 8000e9d0 <tickslock>
    8000173c:	a821                	j	80001754 <wakeup+0x40>
        p->state = RUNNABLE;
    8000173e:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001742:	8526                	mv	a0,s1
    80001744:	00005097          	auipc	ra,0x5
    80001748:	d3c080e7          	jalr	-708(ra) # 80006480 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000174c:	17048493          	addi	s1,s1,368
    80001750:	03248463          	beq	s1,s2,80001778 <wakeup+0x64>
    if(p != myproc()){
    80001754:	00000097          	auipc	ra,0x0
    80001758:	81e080e7          	jalr	-2018(ra) # 80000f72 <myproc>
    8000175c:	fea488e3          	beq	s1,a0,8000174c <wakeup+0x38>
      acquire(&p->lock);
    80001760:	8526                	mv	a0,s1
    80001762:	00005097          	auipc	ra,0x5
    80001766:	c6a080e7          	jalr	-918(ra) # 800063cc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000176a:	4c9c                	lw	a5,24(s1)
    8000176c:	fd379be3          	bne	a5,s3,80001742 <wakeup+0x2e>
    80001770:	709c                	ld	a5,32(s1)
    80001772:	fd4798e3          	bne	a5,s4,80001742 <wakeup+0x2e>
    80001776:	b7e1                	j	8000173e <wakeup+0x2a>
    }
  }
}
    80001778:	70e2                	ld	ra,56(sp)
    8000177a:	7442                	ld	s0,48(sp)
    8000177c:	74a2                	ld	s1,40(sp)
    8000177e:	7902                	ld	s2,32(sp)
    80001780:	69e2                	ld	s3,24(sp)
    80001782:	6a42                	ld	s4,16(sp)
    80001784:	6aa2                	ld	s5,8(sp)
    80001786:	6121                	addi	sp,sp,64
    80001788:	8082                	ret

000000008000178a <reparent>:
{
    8000178a:	7179                	addi	sp,sp,-48
    8000178c:	f406                	sd	ra,40(sp)
    8000178e:	f022                	sd	s0,32(sp)
    80001790:	ec26                	sd	s1,24(sp)
    80001792:	e84a                	sd	s2,16(sp)
    80001794:	e44e                	sd	s3,8(sp)
    80001796:	e052                	sd	s4,0(sp)
    80001798:	1800                	addi	s0,sp,48
    8000179a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000179c:	00007497          	auipc	s1,0x7
    800017a0:	63448493          	addi	s1,s1,1588 # 80008dd0 <proc>
      pp->parent = initproc;
    800017a4:	00007a17          	auipc	s4,0x7
    800017a8:	1bca0a13          	addi	s4,s4,444 # 80008960 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017ac:	0000d997          	auipc	s3,0xd
    800017b0:	22498993          	addi	s3,s3,548 # 8000e9d0 <tickslock>
    800017b4:	a029                	j	800017be <reparent+0x34>
    800017b6:	17048493          	addi	s1,s1,368
    800017ba:	01348d63          	beq	s1,s3,800017d4 <reparent+0x4a>
    if(pp->parent == p){
    800017be:	7c9c                	ld	a5,56(s1)
    800017c0:	ff279be3          	bne	a5,s2,800017b6 <reparent+0x2c>
      pp->parent = initproc;
    800017c4:	000a3503          	ld	a0,0(s4)
    800017c8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017ca:	00000097          	auipc	ra,0x0
    800017ce:	f4a080e7          	jalr	-182(ra) # 80001714 <wakeup>
    800017d2:	b7d5                	j	800017b6 <reparent+0x2c>
}
    800017d4:	70a2                	ld	ra,40(sp)
    800017d6:	7402                	ld	s0,32(sp)
    800017d8:	64e2                	ld	s1,24(sp)
    800017da:	6942                	ld	s2,16(sp)
    800017dc:	69a2                	ld	s3,8(sp)
    800017de:	6a02                	ld	s4,0(sp)
    800017e0:	6145                	addi	sp,sp,48
    800017e2:	8082                	ret

00000000800017e4 <exit>:
{
    800017e4:	7179                	addi	sp,sp,-48
    800017e6:	f406                	sd	ra,40(sp)
    800017e8:	f022                	sd	s0,32(sp)
    800017ea:	ec26                	sd	s1,24(sp)
    800017ec:	e84a                	sd	s2,16(sp)
    800017ee:	e44e                	sd	s3,8(sp)
    800017f0:	e052                	sd	s4,0(sp)
    800017f2:	1800                	addi	s0,sp,48
    800017f4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017f6:	fffff097          	auipc	ra,0xfffff
    800017fa:	77c080e7          	jalr	1916(ra) # 80000f72 <myproc>
    800017fe:	89aa                	mv	s3,a0
  if(p == initproc)
    80001800:	00007797          	auipc	a5,0x7
    80001804:	1607b783          	ld	a5,352(a5) # 80008960 <initproc>
    80001808:	0d050493          	addi	s1,a0,208
    8000180c:	15050913          	addi	s2,a0,336
    80001810:	02a79363          	bne	a5,a0,80001836 <exit+0x52>
    panic("init exiting");
    80001814:	00007517          	auipc	a0,0x7
    80001818:	a1450513          	addi	a0,a0,-1516 # 80008228 <etext+0x228>
    8000181c:	00004097          	auipc	ra,0x4
    80001820:	666080e7          	jalr	1638(ra) # 80005e82 <panic>
      fileclose(f);
    80001824:	00002097          	auipc	ra,0x2
    80001828:	3da080e7          	jalr	986(ra) # 80003bfe <fileclose>
      p->ofile[fd] = 0;
    8000182c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001830:	04a1                	addi	s1,s1,8
    80001832:	01248563          	beq	s1,s2,8000183c <exit+0x58>
    if(p->ofile[fd]){
    80001836:	6088                	ld	a0,0(s1)
    80001838:	f575                	bnez	a0,80001824 <exit+0x40>
    8000183a:	bfdd                	j	80001830 <exit+0x4c>
  begin_op();
    8000183c:	00002097          	auipc	ra,0x2
    80001840:	ef6080e7          	jalr	-266(ra) # 80003732 <begin_op>
  iput(p->cwd);
    80001844:	1509b503          	ld	a0,336(s3)
    80001848:	00001097          	auipc	ra,0x1
    8000184c:	6e2080e7          	jalr	1762(ra) # 80002f2a <iput>
  end_op();
    80001850:	00002097          	auipc	ra,0x2
    80001854:	f62080e7          	jalr	-158(ra) # 800037b2 <end_op>
  p->cwd = 0;
    80001858:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000185c:	00007497          	auipc	s1,0x7
    80001860:	15c48493          	addi	s1,s1,348 # 800089b8 <wait_lock>
    80001864:	8526                	mv	a0,s1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	b66080e7          	jalr	-1178(ra) # 800063cc <acquire>
  reparent(p);
    8000186e:	854e                	mv	a0,s3
    80001870:	00000097          	auipc	ra,0x0
    80001874:	f1a080e7          	jalr	-230(ra) # 8000178a <reparent>
  wakeup(p->parent);
    80001878:	0389b503          	ld	a0,56(s3)
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	e98080e7          	jalr	-360(ra) # 80001714 <wakeup>
  acquire(&p->lock);
    80001884:	854e                	mv	a0,s3
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	b46080e7          	jalr	-1210(ra) # 800063cc <acquire>
  p->xstate = status;
    8000188e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001892:	4795                	li	a5,5
    80001894:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001898:	8526                	mv	a0,s1
    8000189a:	00005097          	auipc	ra,0x5
    8000189e:	be6080e7          	jalr	-1050(ra) # 80006480 <release>
  sched();
    800018a2:	00000097          	auipc	ra,0x0
    800018a6:	cfc080e7          	jalr	-772(ra) # 8000159e <sched>
  panic("zombie exit");
    800018aa:	00007517          	auipc	a0,0x7
    800018ae:	98e50513          	addi	a0,a0,-1650 # 80008238 <etext+0x238>
    800018b2:	00004097          	auipc	ra,0x4
    800018b6:	5d0080e7          	jalr	1488(ra) # 80005e82 <panic>

00000000800018ba <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018ba:	7179                	addi	sp,sp,-48
    800018bc:	f406                	sd	ra,40(sp)
    800018be:	f022                	sd	s0,32(sp)
    800018c0:	ec26                	sd	s1,24(sp)
    800018c2:	e84a                	sd	s2,16(sp)
    800018c4:	e44e                	sd	s3,8(sp)
    800018c6:	1800                	addi	s0,sp,48
    800018c8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018ca:	00007497          	auipc	s1,0x7
    800018ce:	50648493          	addi	s1,s1,1286 # 80008dd0 <proc>
    800018d2:	0000d997          	auipc	s3,0xd
    800018d6:	0fe98993          	addi	s3,s3,254 # 8000e9d0 <tickslock>
    acquire(&p->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	af0080e7          	jalr	-1296(ra) # 800063cc <acquire>
    if(p->pid == pid){
    800018e4:	589c                	lw	a5,48(s1)
    800018e6:	01278d63          	beq	a5,s2,80001900 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ea:	8526                	mv	a0,s1
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	b94080e7          	jalr	-1132(ra) # 80006480 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018f4:	17048493          	addi	s1,s1,368
    800018f8:	ff3491e3          	bne	s1,s3,800018da <kill+0x20>
  }
  return -1;
    800018fc:	557d                	li	a0,-1
    800018fe:	a829                	j	80001918 <kill+0x5e>
      p->killed = 1;
    80001900:	4785                	li	a5,1
    80001902:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001904:	4c98                	lw	a4,24(s1)
    80001906:	4789                	li	a5,2
    80001908:	00f70f63          	beq	a4,a5,80001926 <kill+0x6c>
      release(&p->lock);
    8000190c:	8526                	mv	a0,s1
    8000190e:	00005097          	auipc	ra,0x5
    80001912:	b72080e7          	jalr	-1166(ra) # 80006480 <release>
      return 0;
    80001916:	4501                	li	a0,0
}
    80001918:	70a2                	ld	ra,40(sp)
    8000191a:	7402                	ld	s0,32(sp)
    8000191c:	64e2                	ld	s1,24(sp)
    8000191e:	6942                	ld	s2,16(sp)
    80001920:	69a2                	ld	s3,8(sp)
    80001922:	6145                	addi	sp,sp,48
    80001924:	8082                	ret
        p->state = RUNNABLE;
    80001926:	478d                	li	a5,3
    80001928:	cc9c                	sw	a5,24(s1)
    8000192a:	b7cd                	j	8000190c <kill+0x52>

000000008000192c <setkilled>:

void
setkilled(struct proc *p)
{
    8000192c:	1101                	addi	sp,sp,-32
    8000192e:	ec06                	sd	ra,24(sp)
    80001930:	e822                	sd	s0,16(sp)
    80001932:	e426                	sd	s1,8(sp)
    80001934:	1000                	addi	s0,sp,32
    80001936:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001938:	00005097          	auipc	ra,0x5
    8000193c:	a94080e7          	jalr	-1388(ra) # 800063cc <acquire>
  p->killed = 1;
    80001940:	4785                	li	a5,1
    80001942:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001944:	8526                	mv	a0,s1
    80001946:	00005097          	auipc	ra,0x5
    8000194a:	b3a080e7          	jalr	-1222(ra) # 80006480 <release>
}
    8000194e:	60e2                	ld	ra,24(sp)
    80001950:	6442                	ld	s0,16(sp)
    80001952:	64a2                	ld	s1,8(sp)
    80001954:	6105                	addi	sp,sp,32
    80001956:	8082                	ret

0000000080001958 <killed>:

int
killed(struct proc *p)
{
    80001958:	1101                	addi	sp,sp,-32
    8000195a:	ec06                	sd	ra,24(sp)
    8000195c:	e822                	sd	s0,16(sp)
    8000195e:	e426                	sd	s1,8(sp)
    80001960:	e04a                	sd	s2,0(sp)
    80001962:	1000                	addi	s0,sp,32
    80001964:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001966:	00005097          	auipc	ra,0x5
    8000196a:	a66080e7          	jalr	-1434(ra) # 800063cc <acquire>
  k = p->killed;
    8000196e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001972:	8526                	mv	a0,s1
    80001974:	00005097          	auipc	ra,0x5
    80001978:	b0c080e7          	jalr	-1268(ra) # 80006480 <release>
  return k;
}
    8000197c:	854a                	mv	a0,s2
    8000197e:	60e2                	ld	ra,24(sp)
    80001980:	6442                	ld	s0,16(sp)
    80001982:	64a2                	ld	s1,8(sp)
    80001984:	6902                	ld	s2,0(sp)
    80001986:	6105                	addi	sp,sp,32
    80001988:	8082                	ret

000000008000198a <wait>:
{
    8000198a:	715d                	addi	sp,sp,-80
    8000198c:	e486                	sd	ra,72(sp)
    8000198e:	e0a2                	sd	s0,64(sp)
    80001990:	fc26                	sd	s1,56(sp)
    80001992:	f84a                	sd	s2,48(sp)
    80001994:	f44e                	sd	s3,40(sp)
    80001996:	f052                	sd	s4,32(sp)
    80001998:	ec56                	sd	s5,24(sp)
    8000199a:	e85a                	sd	s6,16(sp)
    8000199c:	e45e                	sd	s7,8(sp)
    8000199e:	e062                	sd	s8,0(sp)
    800019a0:	0880                	addi	s0,sp,80
    800019a2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	5ce080e7          	jalr	1486(ra) # 80000f72 <myproc>
    800019ac:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800019ae:	00007517          	auipc	a0,0x7
    800019b2:	00a50513          	addi	a0,a0,10 # 800089b8 <wait_lock>
    800019b6:	00005097          	auipc	ra,0x5
    800019ba:	a16080e7          	jalr	-1514(ra) # 800063cc <acquire>
    havekids = 0;
    800019be:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800019c0:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019c2:	0000d997          	auipc	s3,0xd
    800019c6:	00e98993          	addi	s3,s3,14 # 8000e9d0 <tickslock>
        havekids = 1;
    800019ca:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019cc:	00007c17          	auipc	s8,0x7
    800019d0:	fecc0c13          	addi	s8,s8,-20 # 800089b8 <wait_lock>
    havekids = 0;
    800019d4:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019d6:	00007497          	auipc	s1,0x7
    800019da:	3fa48493          	addi	s1,s1,1018 # 80008dd0 <proc>
    800019de:	a0bd                	j	80001a4c <wait+0xc2>
          pid = pp->pid;
    800019e0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800019e4:	000b0e63          	beqz	s6,80001a00 <wait+0x76>
    800019e8:	4691                	li	a3,4
    800019ea:	02c48613          	addi	a2,s1,44
    800019ee:	85da                	mv	a1,s6
    800019f0:	05093503          	ld	a0,80(s2)
    800019f4:	fffff097          	auipc	ra,0xfffff
    800019f8:	122080e7          	jalr	290(ra) # 80000b16 <copyout>
    800019fc:	02054563          	bltz	a0,80001a26 <wait+0x9c>
          freeproc(pp);
    80001a00:	8526                	mv	a0,s1
    80001a02:	fffff097          	auipc	ra,0xfffff
    80001a06:	76e080e7          	jalr	1902(ra) # 80001170 <freeproc>
          release(&pp->lock);
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	00005097          	auipc	ra,0x5
    80001a10:	a74080e7          	jalr	-1420(ra) # 80006480 <release>
          release(&wait_lock);
    80001a14:	00007517          	auipc	a0,0x7
    80001a18:	fa450513          	addi	a0,a0,-92 # 800089b8 <wait_lock>
    80001a1c:	00005097          	auipc	ra,0x5
    80001a20:	a64080e7          	jalr	-1436(ra) # 80006480 <release>
          return pid;
    80001a24:	a0b5                	j	80001a90 <wait+0x106>
            release(&pp->lock);
    80001a26:	8526                	mv	a0,s1
    80001a28:	00005097          	auipc	ra,0x5
    80001a2c:	a58080e7          	jalr	-1448(ra) # 80006480 <release>
            release(&wait_lock);
    80001a30:	00007517          	auipc	a0,0x7
    80001a34:	f8850513          	addi	a0,a0,-120 # 800089b8 <wait_lock>
    80001a38:	00005097          	auipc	ra,0x5
    80001a3c:	a48080e7          	jalr	-1464(ra) # 80006480 <release>
            return -1;
    80001a40:	59fd                	li	s3,-1
    80001a42:	a0b9                	j	80001a90 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a44:	17048493          	addi	s1,s1,368
    80001a48:	03348463          	beq	s1,s3,80001a70 <wait+0xe6>
      if(pp->parent == p){
    80001a4c:	7c9c                	ld	a5,56(s1)
    80001a4e:	ff279be3          	bne	a5,s2,80001a44 <wait+0xba>
        acquire(&pp->lock);
    80001a52:	8526                	mv	a0,s1
    80001a54:	00005097          	auipc	ra,0x5
    80001a58:	978080e7          	jalr	-1672(ra) # 800063cc <acquire>
        if(pp->state == ZOMBIE){
    80001a5c:	4c9c                	lw	a5,24(s1)
    80001a5e:	f94781e3          	beq	a5,s4,800019e0 <wait+0x56>
        release(&pp->lock);
    80001a62:	8526                	mv	a0,s1
    80001a64:	00005097          	auipc	ra,0x5
    80001a68:	a1c080e7          	jalr	-1508(ra) # 80006480 <release>
        havekids = 1;
    80001a6c:	8756                	mv	a4,s5
    80001a6e:	bfd9                	j	80001a44 <wait+0xba>
    if(!havekids || killed(p)){
    80001a70:	c719                	beqz	a4,80001a7e <wait+0xf4>
    80001a72:	854a                	mv	a0,s2
    80001a74:	00000097          	auipc	ra,0x0
    80001a78:	ee4080e7          	jalr	-284(ra) # 80001958 <killed>
    80001a7c:	c51d                	beqz	a0,80001aaa <wait+0x120>
      release(&wait_lock);
    80001a7e:	00007517          	auipc	a0,0x7
    80001a82:	f3a50513          	addi	a0,a0,-198 # 800089b8 <wait_lock>
    80001a86:	00005097          	auipc	ra,0x5
    80001a8a:	9fa080e7          	jalr	-1542(ra) # 80006480 <release>
      return -1;
    80001a8e:	59fd                	li	s3,-1
}
    80001a90:	854e                	mv	a0,s3
    80001a92:	60a6                	ld	ra,72(sp)
    80001a94:	6406                	ld	s0,64(sp)
    80001a96:	74e2                	ld	s1,56(sp)
    80001a98:	7942                	ld	s2,48(sp)
    80001a9a:	79a2                	ld	s3,40(sp)
    80001a9c:	7a02                	ld	s4,32(sp)
    80001a9e:	6ae2                	ld	s5,24(sp)
    80001aa0:	6b42                	ld	s6,16(sp)
    80001aa2:	6ba2                	ld	s7,8(sp)
    80001aa4:	6c02                	ld	s8,0(sp)
    80001aa6:	6161                	addi	sp,sp,80
    80001aa8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001aaa:	85e2                	mv	a1,s8
    80001aac:	854a                	mv	a0,s2
    80001aae:	00000097          	auipc	ra,0x0
    80001ab2:	c02080e7          	jalr	-1022(ra) # 800016b0 <sleep>
    havekids = 0;
    80001ab6:	bf39                	j	800019d4 <wait+0x4a>

0000000080001ab8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001ab8:	7179                	addi	sp,sp,-48
    80001aba:	f406                	sd	ra,40(sp)
    80001abc:	f022                	sd	s0,32(sp)
    80001abe:	ec26                	sd	s1,24(sp)
    80001ac0:	e84a                	sd	s2,16(sp)
    80001ac2:	e44e                	sd	s3,8(sp)
    80001ac4:	e052                	sd	s4,0(sp)
    80001ac6:	1800                	addi	s0,sp,48
    80001ac8:	84aa                	mv	s1,a0
    80001aca:	892e                	mv	s2,a1
    80001acc:	89b2                	mv	s3,a2
    80001ace:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	4a2080e7          	jalr	1186(ra) # 80000f72 <myproc>
  if(user_dst){
    80001ad8:	c08d                	beqz	s1,80001afa <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001ada:	86d2                	mv	a3,s4
    80001adc:	864e                	mv	a2,s3
    80001ade:	85ca                	mv	a1,s2
    80001ae0:	6928                	ld	a0,80(a0)
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	034080e7          	jalr	52(ra) # 80000b16 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001aea:	70a2                	ld	ra,40(sp)
    80001aec:	7402                	ld	s0,32(sp)
    80001aee:	64e2                	ld	s1,24(sp)
    80001af0:	6942                	ld	s2,16(sp)
    80001af2:	69a2                	ld	s3,8(sp)
    80001af4:	6a02                	ld	s4,0(sp)
    80001af6:	6145                	addi	sp,sp,48
    80001af8:	8082                	ret
    memmove((char *)dst, src, len);
    80001afa:	000a061b          	sext.w	a2,s4
    80001afe:	85ce                	mv	a1,s3
    80001b00:	854a                	mv	a0,s2
    80001b02:	ffffe097          	auipc	ra,0xffffe
    80001b06:	6d6080e7          	jalr	1750(ra) # 800001d8 <memmove>
    return 0;
    80001b0a:	8526                	mv	a0,s1
    80001b0c:	bff9                	j	80001aea <either_copyout+0x32>

0000000080001b0e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b0e:	7179                	addi	sp,sp,-48
    80001b10:	f406                	sd	ra,40(sp)
    80001b12:	f022                	sd	s0,32(sp)
    80001b14:	ec26                	sd	s1,24(sp)
    80001b16:	e84a                	sd	s2,16(sp)
    80001b18:	e44e                	sd	s3,8(sp)
    80001b1a:	e052                	sd	s4,0(sp)
    80001b1c:	1800                	addi	s0,sp,48
    80001b1e:	892a                	mv	s2,a0
    80001b20:	84ae                	mv	s1,a1
    80001b22:	89b2                	mv	s3,a2
    80001b24:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	44c080e7          	jalr	1100(ra) # 80000f72 <myproc>
  if(user_src){
    80001b2e:	c08d                	beqz	s1,80001b50 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b30:	86d2                	mv	a3,s4
    80001b32:	864e                	mv	a2,s3
    80001b34:	85ca                	mv	a1,s2
    80001b36:	6928                	ld	a0,80(a0)
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	06a080e7          	jalr	106(ra) # 80000ba2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b40:	70a2                	ld	ra,40(sp)
    80001b42:	7402                	ld	s0,32(sp)
    80001b44:	64e2                	ld	s1,24(sp)
    80001b46:	6942                	ld	s2,16(sp)
    80001b48:	69a2                	ld	s3,8(sp)
    80001b4a:	6a02                	ld	s4,0(sp)
    80001b4c:	6145                	addi	sp,sp,48
    80001b4e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b50:	000a061b          	sext.w	a2,s4
    80001b54:	85ce                	mv	a1,s3
    80001b56:	854a                	mv	a0,s2
    80001b58:	ffffe097          	auipc	ra,0xffffe
    80001b5c:	680080e7          	jalr	1664(ra) # 800001d8 <memmove>
    return 0;
    80001b60:	8526                	mv	a0,s1
    80001b62:	bff9                	j	80001b40 <either_copyin+0x32>

0000000080001b64 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b64:	715d                	addi	sp,sp,-80
    80001b66:	e486                	sd	ra,72(sp)
    80001b68:	e0a2                	sd	s0,64(sp)
    80001b6a:	fc26                	sd	s1,56(sp)
    80001b6c:	f84a                	sd	s2,48(sp)
    80001b6e:	f44e                	sd	s3,40(sp)
    80001b70:	f052                	sd	s4,32(sp)
    80001b72:	ec56                	sd	s5,24(sp)
    80001b74:	e85a                	sd	s6,16(sp)
    80001b76:	e45e                	sd	s7,8(sp)
    80001b78:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b7a:	00006517          	auipc	a0,0x6
    80001b7e:	4ce50513          	addi	a0,a0,1230 # 80008048 <etext+0x48>
    80001b82:	00004097          	auipc	ra,0x4
    80001b86:	34a080e7          	jalr	842(ra) # 80005ecc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b8a:	00007497          	auipc	s1,0x7
    80001b8e:	39e48493          	addi	s1,s1,926 # 80008f28 <proc+0x158>
    80001b92:	0000d917          	auipc	s2,0xd
    80001b96:	f9690913          	addi	s2,s2,-106 # 8000eb28 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b9a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b9c:	00006997          	auipc	s3,0x6
    80001ba0:	6ac98993          	addi	s3,s3,1708 # 80008248 <etext+0x248>
    printf("%d %s %s", p->pid, state, p->name);
    80001ba4:	00006a97          	auipc	s5,0x6
    80001ba8:	6aca8a93          	addi	s5,s5,1708 # 80008250 <etext+0x250>
    printf("\n");
    80001bac:	00006a17          	auipc	s4,0x6
    80001bb0:	49ca0a13          	addi	s4,s4,1180 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bb4:	00006b97          	auipc	s7,0x6
    80001bb8:	6dcb8b93          	addi	s7,s7,1756 # 80008290 <states.1729>
    80001bbc:	a00d                	j	80001bde <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bbe:	ed86a583          	lw	a1,-296(a3)
    80001bc2:	8556                	mv	a0,s5
    80001bc4:	00004097          	auipc	ra,0x4
    80001bc8:	308080e7          	jalr	776(ra) # 80005ecc <printf>
    printf("\n");
    80001bcc:	8552                	mv	a0,s4
    80001bce:	00004097          	auipc	ra,0x4
    80001bd2:	2fe080e7          	jalr	766(ra) # 80005ecc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bd6:	17048493          	addi	s1,s1,368
    80001bda:	03248163          	beq	s1,s2,80001bfc <procdump+0x98>
    if(p->state == UNUSED)
    80001bde:	86a6                	mv	a3,s1
    80001be0:	ec04a783          	lw	a5,-320(s1)
    80001be4:	dbed                	beqz	a5,80001bd6 <procdump+0x72>
      state = "???";
    80001be6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001be8:	fcfb6be3          	bltu	s6,a5,80001bbe <procdump+0x5a>
    80001bec:	1782                	slli	a5,a5,0x20
    80001bee:	9381                	srli	a5,a5,0x20
    80001bf0:	078e                	slli	a5,a5,0x3
    80001bf2:	97de                	add	a5,a5,s7
    80001bf4:	6390                	ld	a2,0(a5)
    80001bf6:	f661                	bnez	a2,80001bbe <procdump+0x5a>
      state = "???";
    80001bf8:	864e                	mv	a2,s3
    80001bfa:	b7d1                	j	80001bbe <procdump+0x5a>
  }
}
    80001bfc:	60a6                	ld	ra,72(sp)
    80001bfe:	6406                	ld	s0,64(sp)
    80001c00:	74e2                	ld	s1,56(sp)
    80001c02:	7942                	ld	s2,48(sp)
    80001c04:	79a2                	ld	s3,40(sp)
    80001c06:	7a02                	ld	s4,32(sp)
    80001c08:	6ae2                	ld	s5,24(sp)
    80001c0a:	6b42                	ld	s6,16(sp)
    80001c0c:	6ba2                	ld	s7,8(sp)
    80001c0e:	6161                	addi	sp,sp,80
    80001c10:	8082                	ret

0000000080001c12 <swtch>:
    80001c12:	00153023          	sd	ra,0(a0)
    80001c16:	00253423          	sd	sp,8(a0)
    80001c1a:	e900                	sd	s0,16(a0)
    80001c1c:	ed04                	sd	s1,24(a0)
    80001c1e:	03253023          	sd	s2,32(a0)
    80001c22:	03353423          	sd	s3,40(a0)
    80001c26:	03453823          	sd	s4,48(a0)
    80001c2a:	03553c23          	sd	s5,56(a0)
    80001c2e:	05653023          	sd	s6,64(a0)
    80001c32:	05753423          	sd	s7,72(a0)
    80001c36:	05853823          	sd	s8,80(a0)
    80001c3a:	05953c23          	sd	s9,88(a0)
    80001c3e:	07a53023          	sd	s10,96(a0)
    80001c42:	07b53423          	sd	s11,104(a0)
    80001c46:	0005b083          	ld	ra,0(a1)
    80001c4a:	0085b103          	ld	sp,8(a1)
    80001c4e:	6980                	ld	s0,16(a1)
    80001c50:	6d84                	ld	s1,24(a1)
    80001c52:	0205b903          	ld	s2,32(a1)
    80001c56:	0285b983          	ld	s3,40(a1)
    80001c5a:	0305ba03          	ld	s4,48(a1)
    80001c5e:	0385ba83          	ld	s5,56(a1)
    80001c62:	0405bb03          	ld	s6,64(a1)
    80001c66:	0485bb83          	ld	s7,72(a1)
    80001c6a:	0505bc03          	ld	s8,80(a1)
    80001c6e:	0585bc83          	ld	s9,88(a1)
    80001c72:	0605bd03          	ld	s10,96(a1)
    80001c76:	0685bd83          	ld	s11,104(a1)
    80001c7a:	8082                	ret

0000000080001c7c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c7c:	1141                	addi	sp,sp,-16
    80001c7e:	e406                	sd	ra,8(sp)
    80001c80:	e022                	sd	s0,0(sp)
    80001c82:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c84:	00006597          	auipc	a1,0x6
    80001c88:	63c58593          	addi	a1,a1,1596 # 800082c0 <states.1729+0x30>
    80001c8c:	0000d517          	auipc	a0,0xd
    80001c90:	d4450513          	addi	a0,a0,-700 # 8000e9d0 <tickslock>
    80001c94:	00004097          	auipc	ra,0x4
    80001c98:	6a8080e7          	jalr	1704(ra) # 8000633c <initlock>
}
    80001c9c:	60a2                	ld	ra,8(sp)
    80001c9e:	6402                	ld	s0,0(sp)
    80001ca0:	0141                	addi	sp,sp,16
    80001ca2:	8082                	ret

0000000080001ca4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ca4:	1141                	addi	sp,sp,-16
    80001ca6:	e422                	sd	s0,8(sp)
    80001ca8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001caa:	00003797          	auipc	a5,0x3
    80001cae:	5a678793          	addi	a5,a5,1446 # 80005250 <kernelvec>
    80001cb2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cb6:	6422                	ld	s0,8(sp)
    80001cb8:	0141                	addi	sp,sp,16
    80001cba:	8082                	ret

0000000080001cbc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cbc:	1141                	addi	sp,sp,-16
    80001cbe:	e406                	sd	ra,8(sp)
    80001cc0:	e022                	sd	s0,0(sp)
    80001cc2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cc4:	fffff097          	auipc	ra,0xfffff
    80001cc8:	2ae080e7          	jalr	686(ra) # 80000f72 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ccc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cd0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cd6:	00005617          	auipc	a2,0x5
    80001cda:	32a60613          	addi	a2,a2,810 # 80007000 <_trampoline>
    80001cde:	00005697          	auipc	a3,0x5
    80001ce2:	32268693          	addi	a3,a3,802 # 80007000 <_trampoline>
    80001ce6:	8e91                	sub	a3,a3,a2
    80001ce8:	040007b7          	lui	a5,0x4000
    80001cec:	17fd                	addi	a5,a5,-1
    80001cee:	07b2                	slli	a5,a5,0xc
    80001cf0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf2:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cf6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cf8:	180026f3          	csrr	a3,satp
    80001cfc:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cfe:	6d38                	ld	a4,88(a0)
    80001d00:	6134                	ld	a3,64(a0)
    80001d02:	6585                	lui	a1,0x1
    80001d04:	96ae                	add	a3,a3,a1
    80001d06:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d08:	6d38                	ld	a4,88(a0)
    80001d0a:	00000697          	auipc	a3,0x0
    80001d0e:	13068693          	addi	a3,a3,304 # 80001e3a <usertrap>
    80001d12:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d14:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d16:	8692                	mv	a3,tp
    80001d18:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d1e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d22:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d26:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d2a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d2c:	6f18                	ld	a4,24(a4)
    80001d2e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d32:	6928                	ld	a0,80(a0)
    80001d34:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d36:	00005717          	auipc	a4,0x5
    80001d3a:	36670713          	addi	a4,a4,870 # 8000709c <userret>
    80001d3e:	8f11                	sub	a4,a4,a2
    80001d40:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d42:	577d                	li	a4,-1
    80001d44:	177e                	slli	a4,a4,0x3f
    80001d46:	8d59                	or	a0,a0,a4
    80001d48:	9782                	jalr	a5
}
    80001d4a:	60a2                	ld	ra,8(sp)
    80001d4c:	6402                	ld	s0,0(sp)
    80001d4e:	0141                	addi	sp,sp,16
    80001d50:	8082                	ret

0000000080001d52 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d52:	1101                	addi	sp,sp,-32
    80001d54:	ec06                	sd	ra,24(sp)
    80001d56:	e822                	sd	s0,16(sp)
    80001d58:	e426                	sd	s1,8(sp)
    80001d5a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d5c:	0000d497          	auipc	s1,0xd
    80001d60:	c7448493          	addi	s1,s1,-908 # 8000e9d0 <tickslock>
    80001d64:	8526                	mv	a0,s1
    80001d66:	00004097          	auipc	ra,0x4
    80001d6a:	666080e7          	jalr	1638(ra) # 800063cc <acquire>
  ticks++;
    80001d6e:	00007517          	auipc	a0,0x7
    80001d72:	bfa50513          	addi	a0,a0,-1030 # 80008968 <ticks>
    80001d76:	411c                	lw	a5,0(a0)
    80001d78:	2785                	addiw	a5,a5,1
    80001d7a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d7c:	00000097          	auipc	ra,0x0
    80001d80:	998080e7          	jalr	-1640(ra) # 80001714 <wakeup>
  release(&tickslock);
    80001d84:	8526                	mv	a0,s1
    80001d86:	00004097          	auipc	ra,0x4
    80001d8a:	6fa080e7          	jalr	1786(ra) # 80006480 <release>
}
    80001d8e:	60e2                	ld	ra,24(sp)
    80001d90:	6442                	ld	s0,16(sp)
    80001d92:	64a2                	ld	s1,8(sp)
    80001d94:	6105                	addi	sp,sp,32
    80001d96:	8082                	ret

0000000080001d98 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d98:	1101                	addi	sp,sp,-32
    80001d9a:	ec06                	sd	ra,24(sp)
    80001d9c:	e822                	sd	s0,16(sp)
    80001d9e:	e426                	sd	s1,8(sp)
    80001da0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001da6:	00074d63          	bltz	a4,80001dc0 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001daa:	57fd                	li	a5,-1
    80001dac:	17fe                	slli	a5,a5,0x3f
    80001dae:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001db0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001db2:	06f70363          	beq	a4,a5,80001e18 <devintr+0x80>
  }
}
    80001db6:	60e2                	ld	ra,24(sp)
    80001db8:	6442                	ld	s0,16(sp)
    80001dba:	64a2                	ld	s1,8(sp)
    80001dbc:	6105                	addi	sp,sp,32
    80001dbe:	8082                	ret
     (scause & 0xff) == 9){
    80001dc0:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001dc4:	46a5                	li	a3,9
    80001dc6:	fed792e3          	bne	a5,a3,80001daa <devintr+0x12>
    int irq = plic_claim();
    80001dca:	00003097          	auipc	ra,0x3
    80001dce:	58e080e7          	jalr	1422(ra) # 80005358 <plic_claim>
    80001dd2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dd4:	47a9                	li	a5,10
    80001dd6:	02f50763          	beq	a0,a5,80001e04 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001dda:	4785                	li	a5,1
    80001ddc:	02f50963          	beq	a0,a5,80001e0e <devintr+0x76>
    return 1;
    80001de0:	4505                	li	a0,1
    } else if(irq){
    80001de2:	d8f1                	beqz	s1,80001db6 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001de4:	85a6                	mv	a1,s1
    80001de6:	00006517          	auipc	a0,0x6
    80001dea:	4e250513          	addi	a0,a0,1250 # 800082c8 <states.1729+0x38>
    80001dee:	00004097          	auipc	ra,0x4
    80001df2:	0de080e7          	jalr	222(ra) # 80005ecc <printf>
      plic_complete(irq);
    80001df6:	8526                	mv	a0,s1
    80001df8:	00003097          	auipc	ra,0x3
    80001dfc:	584080e7          	jalr	1412(ra) # 8000537c <plic_complete>
    return 1;
    80001e00:	4505                	li	a0,1
    80001e02:	bf55                	j	80001db6 <devintr+0x1e>
      uartintr();
    80001e04:	00004097          	auipc	ra,0x4
    80001e08:	4e8080e7          	jalr	1256(ra) # 800062ec <uartintr>
    80001e0c:	b7ed                	j	80001df6 <devintr+0x5e>
      virtio_disk_intr();
    80001e0e:	00004097          	auipc	ra,0x4
    80001e12:	a98080e7          	jalr	-1384(ra) # 800058a6 <virtio_disk_intr>
    80001e16:	b7c5                	j	80001df6 <devintr+0x5e>
    if(cpuid() == 0){
    80001e18:	fffff097          	auipc	ra,0xfffff
    80001e1c:	12e080e7          	jalr	302(ra) # 80000f46 <cpuid>
    80001e20:	c901                	beqz	a0,80001e30 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e22:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e26:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e28:	14479073          	csrw	sip,a5
    return 2;
    80001e2c:	4509                	li	a0,2
    80001e2e:	b761                	j	80001db6 <devintr+0x1e>
      clockintr();
    80001e30:	00000097          	auipc	ra,0x0
    80001e34:	f22080e7          	jalr	-222(ra) # 80001d52 <clockintr>
    80001e38:	b7ed                	j	80001e22 <devintr+0x8a>

0000000080001e3a <usertrap>:
{
    80001e3a:	1101                	addi	sp,sp,-32
    80001e3c:	ec06                	sd	ra,24(sp)
    80001e3e:	e822                	sd	s0,16(sp)
    80001e40:	e426                	sd	s1,8(sp)
    80001e42:	e04a                	sd	s2,0(sp)
    80001e44:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e46:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e4a:	1007f793          	andi	a5,a5,256
    80001e4e:	e3b1                	bnez	a5,80001e92 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e50:	00003797          	auipc	a5,0x3
    80001e54:	40078793          	addi	a5,a5,1024 # 80005250 <kernelvec>
    80001e58:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	116080e7          	jalr	278(ra) # 80000f72 <myproc>
    80001e64:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e66:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e68:	14102773          	csrr	a4,sepc
    80001e6c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e6e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e72:	47a1                	li	a5,8
    80001e74:	02f70763          	beq	a4,a5,80001ea2 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e78:	00000097          	auipc	ra,0x0
    80001e7c:	f20080e7          	jalr	-224(ra) # 80001d98 <devintr>
    80001e80:	892a                	mv	s2,a0
    80001e82:	c151                	beqz	a0,80001f06 <usertrap+0xcc>
  if(killed(p))
    80001e84:	8526                	mv	a0,s1
    80001e86:	00000097          	auipc	ra,0x0
    80001e8a:	ad2080e7          	jalr	-1326(ra) # 80001958 <killed>
    80001e8e:	c929                	beqz	a0,80001ee0 <usertrap+0xa6>
    80001e90:	a099                	j	80001ed6 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e92:	00006517          	auipc	a0,0x6
    80001e96:	45650513          	addi	a0,a0,1110 # 800082e8 <states.1729+0x58>
    80001e9a:	00004097          	auipc	ra,0x4
    80001e9e:	fe8080e7          	jalr	-24(ra) # 80005e82 <panic>
    if(killed(p))
    80001ea2:	00000097          	auipc	ra,0x0
    80001ea6:	ab6080e7          	jalr	-1354(ra) # 80001958 <killed>
    80001eaa:	e921                	bnez	a0,80001efa <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001eac:	6cb8                	ld	a4,88(s1)
    80001eae:	6f1c                	ld	a5,24(a4)
    80001eb0:	0791                	addi	a5,a5,4
    80001eb2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eb4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eb8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ebc:	10079073          	csrw	sstatus,a5
    syscall();
    80001ec0:	00000097          	auipc	ra,0x0
    80001ec4:	2d4080e7          	jalr	724(ra) # 80002194 <syscall>
  if(killed(p))
    80001ec8:	8526                	mv	a0,s1
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	a8e080e7          	jalr	-1394(ra) # 80001958 <killed>
    80001ed2:	c911                	beqz	a0,80001ee6 <usertrap+0xac>
    80001ed4:	4901                	li	s2,0
    exit(-1);
    80001ed6:	557d                	li	a0,-1
    80001ed8:	00000097          	auipc	ra,0x0
    80001edc:	90c080e7          	jalr	-1780(ra) # 800017e4 <exit>
  if(which_dev == 2)
    80001ee0:	4789                	li	a5,2
    80001ee2:	04f90f63          	beq	s2,a5,80001f40 <usertrap+0x106>
  usertrapret();
    80001ee6:	00000097          	auipc	ra,0x0
    80001eea:	dd6080e7          	jalr	-554(ra) # 80001cbc <usertrapret>
}
    80001eee:	60e2                	ld	ra,24(sp)
    80001ef0:	6442                	ld	s0,16(sp)
    80001ef2:	64a2                	ld	s1,8(sp)
    80001ef4:	6902                	ld	s2,0(sp)
    80001ef6:	6105                	addi	sp,sp,32
    80001ef8:	8082                	ret
      exit(-1);
    80001efa:	557d                	li	a0,-1
    80001efc:	00000097          	auipc	ra,0x0
    80001f00:	8e8080e7          	jalr	-1816(ra) # 800017e4 <exit>
    80001f04:	b765                	j	80001eac <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f06:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f0a:	5890                	lw	a2,48(s1)
    80001f0c:	00006517          	auipc	a0,0x6
    80001f10:	3fc50513          	addi	a0,a0,1020 # 80008308 <states.1729+0x78>
    80001f14:	00004097          	auipc	ra,0x4
    80001f18:	fb8080e7          	jalr	-72(ra) # 80005ecc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f1c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f20:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f24:	00006517          	auipc	a0,0x6
    80001f28:	41450513          	addi	a0,a0,1044 # 80008338 <states.1729+0xa8>
    80001f2c:	00004097          	auipc	ra,0x4
    80001f30:	fa0080e7          	jalr	-96(ra) # 80005ecc <printf>
    setkilled(p);
    80001f34:	8526                	mv	a0,s1
    80001f36:	00000097          	auipc	ra,0x0
    80001f3a:	9f6080e7          	jalr	-1546(ra) # 8000192c <setkilled>
    80001f3e:	b769                	j	80001ec8 <usertrap+0x8e>
    yield();
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	734080e7          	jalr	1844(ra) # 80001674 <yield>
    80001f48:	bf79                	j	80001ee6 <usertrap+0xac>

0000000080001f4a <kerneltrap>:
{
    80001f4a:	7179                	addi	sp,sp,-48
    80001f4c:	f406                	sd	ra,40(sp)
    80001f4e:	f022                	sd	s0,32(sp)
    80001f50:	ec26                	sd	s1,24(sp)
    80001f52:	e84a                	sd	s2,16(sp)
    80001f54:	e44e                	sd	s3,8(sp)
    80001f56:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f58:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f5c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f60:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f64:	1004f793          	andi	a5,s1,256
    80001f68:	cb85                	beqz	a5,80001f98 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f6a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f6e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f70:	ef85                	bnez	a5,80001fa8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f72:	00000097          	auipc	ra,0x0
    80001f76:	e26080e7          	jalr	-474(ra) # 80001d98 <devintr>
    80001f7a:	cd1d                	beqz	a0,80001fb8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f7c:	4789                	li	a5,2
    80001f7e:	06f50a63          	beq	a0,a5,80001ff2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f82:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f86:	10049073          	csrw	sstatus,s1
}
    80001f8a:	70a2                	ld	ra,40(sp)
    80001f8c:	7402                	ld	s0,32(sp)
    80001f8e:	64e2                	ld	s1,24(sp)
    80001f90:	6942                	ld	s2,16(sp)
    80001f92:	69a2                	ld	s3,8(sp)
    80001f94:	6145                	addi	sp,sp,48
    80001f96:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f98:	00006517          	auipc	a0,0x6
    80001f9c:	3c050513          	addi	a0,a0,960 # 80008358 <states.1729+0xc8>
    80001fa0:	00004097          	auipc	ra,0x4
    80001fa4:	ee2080e7          	jalr	-286(ra) # 80005e82 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fa8:	00006517          	auipc	a0,0x6
    80001fac:	3d850513          	addi	a0,a0,984 # 80008380 <states.1729+0xf0>
    80001fb0:	00004097          	auipc	ra,0x4
    80001fb4:	ed2080e7          	jalr	-302(ra) # 80005e82 <panic>
    printf("scause %p\n", scause);
    80001fb8:	85ce                	mv	a1,s3
    80001fba:	00006517          	auipc	a0,0x6
    80001fbe:	3e650513          	addi	a0,a0,998 # 800083a0 <states.1729+0x110>
    80001fc2:	00004097          	auipc	ra,0x4
    80001fc6:	f0a080e7          	jalr	-246(ra) # 80005ecc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fca:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fce:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fd2:	00006517          	auipc	a0,0x6
    80001fd6:	3de50513          	addi	a0,a0,990 # 800083b0 <states.1729+0x120>
    80001fda:	00004097          	auipc	ra,0x4
    80001fde:	ef2080e7          	jalr	-270(ra) # 80005ecc <printf>
    panic("kerneltrap");
    80001fe2:	00006517          	auipc	a0,0x6
    80001fe6:	3e650513          	addi	a0,a0,998 # 800083c8 <states.1729+0x138>
    80001fea:	00004097          	auipc	ra,0x4
    80001fee:	e98080e7          	jalr	-360(ra) # 80005e82 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	f80080e7          	jalr	-128(ra) # 80000f72 <myproc>
    80001ffa:	d541                	beqz	a0,80001f82 <kerneltrap+0x38>
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	f76080e7          	jalr	-138(ra) # 80000f72 <myproc>
    80002004:	4d18                	lw	a4,24(a0)
    80002006:	4791                	li	a5,4
    80002008:	f6f71de3          	bne	a4,a5,80001f82 <kerneltrap+0x38>
    yield();
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	668080e7          	jalr	1640(ra) # 80001674 <yield>
    80002014:	b7bd                	j	80001f82 <kerneltrap+0x38>

0000000080002016 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	e426                	sd	s1,8(sp)
    8000201e:	1000                	addi	s0,sp,32
    80002020:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	f50080e7          	jalr	-176(ra) # 80000f72 <myproc>
  switch (n) {
    8000202a:	4795                	li	a5,5
    8000202c:	0497e163          	bltu	a5,s1,8000206e <argraw+0x58>
    80002030:	048a                	slli	s1,s1,0x2
    80002032:	00006717          	auipc	a4,0x6
    80002036:	3ce70713          	addi	a4,a4,974 # 80008400 <states.1729+0x170>
    8000203a:	94ba                	add	s1,s1,a4
    8000203c:	409c                	lw	a5,0(s1)
    8000203e:	97ba                	add	a5,a5,a4
    80002040:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002042:	6d3c                	ld	a5,88(a0)
    80002044:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002046:	60e2                	ld	ra,24(sp)
    80002048:	6442                	ld	s0,16(sp)
    8000204a:	64a2                	ld	s1,8(sp)
    8000204c:	6105                	addi	sp,sp,32
    8000204e:	8082                	ret
    return p->trapframe->a1;
    80002050:	6d3c                	ld	a5,88(a0)
    80002052:	7fa8                	ld	a0,120(a5)
    80002054:	bfcd                	j	80002046 <argraw+0x30>
    return p->trapframe->a2;
    80002056:	6d3c                	ld	a5,88(a0)
    80002058:	63c8                	ld	a0,128(a5)
    8000205a:	b7f5                	j	80002046 <argraw+0x30>
    return p->trapframe->a3;
    8000205c:	6d3c                	ld	a5,88(a0)
    8000205e:	67c8                	ld	a0,136(a5)
    80002060:	b7dd                	j	80002046 <argraw+0x30>
    return p->trapframe->a4;
    80002062:	6d3c                	ld	a5,88(a0)
    80002064:	6bc8                	ld	a0,144(a5)
    80002066:	b7c5                	j	80002046 <argraw+0x30>
    return p->trapframe->a5;
    80002068:	6d3c                	ld	a5,88(a0)
    8000206a:	6fc8                	ld	a0,152(a5)
    8000206c:	bfe9                	j	80002046 <argraw+0x30>
  panic("argraw");
    8000206e:	00006517          	auipc	a0,0x6
    80002072:	36a50513          	addi	a0,a0,874 # 800083d8 <states.1729+0x148>
    80002076:	00004097          	auipc	ra,0x4
    8000207a:	e0c080e7          	jalr	-500(ra) # 80005e82 <panic>

000000008000207e <fetchaddr>:
{
    8000207e:	1101                	addi	sp,sp,-32
    80002080:	ec06                	sd	ra,24(sp)
    80002082:	e822                	sd	s0,16(sp)
    80002084:	e426                	sd	s1,8(sp)
    80002086:	e04a                	sd	s2,0(sp)
    80002088:	1000                	addi	s0,sp,32
    8000208a:	84aa                	mv	s1,a0
    8000208c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	ee4080e7          	jalr	-284(ra) # 80000f72 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002096:	653c                	ld	a5,72(a0)
    80002098:	02f4f863          	bgeu	s1,a5,800020c8 <fetchaddr+0x4a>
    8000209c:	00848713          	addi	a4,s1,8
    800020a0:	02e7e663          	bltu	a5,a4,800020cc <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020a4:	46a1                	li	a3,8
    800020a6:	8626                	mv	a2,s1
    800020a8:	85ca                	mv	a1,s2
    800020aa:	6928                	ld	a0,80(a0)
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	af6080e7          	jalr	-1290(ra) # 80000ba2 <copyin>
    800020b4:	00a03533          	snez	a0,a0
    800020b8:	40a00533          	neg	a0,a0
}
    800020bc:	60e2                	ld	ra,24(sp)
    800020be:	6442                	ld	s0,16(sp)
    800020c0:	64a2                	ld	s1,8(sp)
    800020c2:	6902                	ld	s2,0(sp)
    800020c4:	6105                	addi	sp,sp,32
    800020c6:	8082                	ret
    return -1;
    800020c8:	557d                	li	a0,-1
    800020ca:	bfcd                	j	800020bc <fetchaddr+0x3e>
    800020cc:	557d                	li	a0,-1
    800020ce:	b7fd                	j	800020bc <fetchaddr+0x3e>

00000000800020d0 <fetchstr>:
{
    800020d0:	7179                	addi	sp,sp,-48
    800020d2:	f406                	sd	ra,40(sp)
    800020d4:	f022                	sd	s0,32(sp)
    800020d6:	ec26                	sd	s1,24(sp)
    800020d8:	e84a                	sd	s2,16(sp)
    800020da:	e44e                	sd	s3,8(sp)
    800020dc:	1800                	addi	s0,sp,48
    800020de:	892a                	mv	s2,a0
    800020e0:	84ae                	mv	s1,a1
    800020e2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020e4:	fffff097          	auipc	ra,0xfffff
    800020e8:	e8e080e7          	jalr	-370(ra) # 80000f72 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020ec:	86ce                	mv	a3,s3
    800020ee:	864a                	mv	a2,s2
    800020f0:	85a6                	mv	a1,s1
    800020f2:	6928                	ld	a0,80(a0)
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	b3a080e7          	jalr	-1222(ra) # 80000c2e <copyinstr>
    800020fc:	00054e63          	bltz	a0,80002118 <fetchstr+0x48>
  return strlen(buf);
    80002100:	8526                	mv	a0,s1
    80002102:	ffffe097          	auipc	ra,0xffffe
    80002106:	1fa080e7          	jalr	506(ra) # 800002fc <strlen>
}
    8000210a:	70a2                	ld	ra,40(sp)
    8000210c:	7402                	ld	s0,32(sp)
    8000210e:	64e2                	ld	s1,24(sp)
    80002110:	6942                	ld	s2,16(sp)
    80002112:	69a2                	ld	s3,8(sp)
    80002114:	6145                	addi	sp,sp,48
    80002116:	8082                	ret
    return -1;
    80002118:	557d                	li	a0,-1
    8000211a:	bfc5                	j	8000210a <fetchstr+0x3a>

000000008000211c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000211c:	1101                	addi	sp,sp,-32
    8000211e:	ec06                	sd	ra,24(sp)
    80002120:	e822                	sd	s0,16(sp)
    80002122:	e426                	sd	s1,8(sp)
    80002124:	1000                	addi	s0,sp,32
    80002126:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002128:	00000097          	auipc	ra,0x0
    8000212c:	eee080e7          	jalr	-274(ra) # 80002016 <argraw>
    80002130:	c088                	sw	a0,0(s1)
}
    80002132:	60e2                	ld	ra,24(sp)
    80002134:	6442                	ld	s0,16(sp)
    80002136:	64a2                	ld	s1,8(sp)
    80002138:	6105                	addi	sp,sp,32
    8000213a:	8082                	ret

000000008000213c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000213c:	1101                	addi	sp,sp,-32
    8000213e:	ec06                	sd	ra,24(sp)
    80002140:	e822                	sd	s0,16(sp)
    80002142:	e426                	sd	s1,8(sp)
    80002144:	1000                	addi	s0,sp,32
    80002146:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002148:	00000097          	auipc	ra,0x0
    8000214c:	ece080e7          	jalr	-306(ra) # 80002016 <argraw>
    80002150:	e088                	sd	a0,0(s1)
}
    80002152:	60e2                	ld	ra,24(sp)
    80002154:	6442                	ld	s0,16(sp)
    80002156:	64a2                	ld	s1,8(sp)
    80002158:	6105                	addi	sp,sp,32
    8000215a:	8082                	ret

000000008000215c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000215c:	7179                	addi	sp,sp,-48
    8000215e:	f406                	sd	ra,40(sp)
    80002160:	f022                	sd	s0,32(sp)
    80002162:	ec26                	sd	s1,24(sp)
    80002164:	e84a                	sd	s2,16(sp)
    80002166:	1800                	addi	s0,sp,48
    80002168:	84ae                	mv	s1,a1
    8000216a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000216c:	fd840593          	addi	a1,s0,-40
    80002170:	00000097          	auipc	ra,0x0
    80002174:	fcc080e7          	jalr	-52(ra) # 8000213c <argaddr>
  return fetchstr(addr, buf, max);
    80002178:	864a                	mv	a2,s2
    8000217a:	85a6                	mv	a1,s1
    8000217c:	fd843503          	ld	a0,-40(s0)
    80002180:	00000097          	auipc	ra,0x0
    80002184:	f50080e7          	jalr	-176(ra) # 800020d0 <fetchstr>
}
    80002188:	70a2                	ld	ra,40(sp)
    8000218a:	7402                	ld	s0,32(sp)
    8000218c:	64e2                	ld	s1,24(sp)
    8000218e:	6942                	ld	s2,16(sp)
    80002190:	6145                	addi	sp,sp,48
    80002192:	8082                	ret

0000000080002194 <syscall>:



void
syscall(void)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	e04a                	sd	s2,0(sp)
    8000219e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021a0:	fffff097          	auipc	ra,0xfffff
    800021a4:	dd2080e7          	jalr	-558(ra) # 80000f72 <myproc>
    800021a8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021aa:	05853903          	ld	s2,88(a0)
    800021ae:	0a893783          	ld	a5,168(s2)
    800021b2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021b6:	37fd                	addiw	a5,a5,-1
    800021b8:	4775                	li	a4,29
    800021ba:	00f76f63          	bltu	a4,a5,800021d8 <syscall+0x44>
    800021be:	00369713          	slli	a4,a3,0x3
    800021c2:	00006797          	auipc	a5,0x6
    800021c6:	25678793          	addi	a5,a5,598 # 80008418 <syscalls>
    800021ca:	97ba                	add	a5,a5,a4
    800021cc:	639c                	ld	a5,0(a5)
    800021ce:	c789                	beqz	a5,800021d8 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021d0:	9782                	jalr	a5
    800021d2:	06a93823          	sd	a0,112(s2)
    800021d6:	a839                	j	800021f4 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021d8:	15848613          	addi	a2,s1,344
    800021dc:	588c                	lw	a1,48(s1)
    800021de:	00006517          	auipc	a0,0x6
    800021e2:	20250513          	addi	a0,a0,514 # 800083e0 <states.1729+0x150>
    800021e6:	00004097          	auipc	ra,0x4
    800021ea:	ce6080e7          	jalr	-794(ra) # 80005ecc <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021ee:	6cbc                	ld	a5,88(s1)
    800021f0:	577d                	li	a4,-1
    800021f2:	fbb8                	sd	a4,112(a5)
  }
}
    800021f4:	60e2                	ld	ra,24(sp)
    800021f6:	6442                	ld	s0,16(sp)
    800021f8:	64a2                	ld	s1,8(sp)
    800021fa:	6902                	ld	s2,0(sp)
    800021fc:	6105                	addi	sp,sp,32
    800021fe:	8082                	ret

0000000080002200 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002200:	1101                	addi	sp,sp,-32
    80002202:	ec06                	sd	ra,24(sp)
    80002204:	e822                	sd	s0,16(sp)
    80002206:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002208:	fec40593          	addi	a1,s0,-20
    8000220c:	4501                	li	a0,0
    8000220e:	00000097          	auipc	ra,0x0
    80002212:	f0e080e7          	jalr	-242(ra) # 8000211c <argint>
  exit(n);
    80002216:	fec42503          	lw	a0,-20(s0)
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	5ca080e7          	jalr	1482(ra) # 800017e4 <exit>
  return 0;  // not reached
}
    80002222:	4501                	li	a0,0
    80002224:	60e2                	ld	ra,24(sp)
    80002226:	6442                	ld	s0,16(sp)
    80002228:	6105                	addi	sp,sp,32
    8000222a:	8082                	ret

000000008000222c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000222c:	1141                	addi	sp,sp,-16
    8000222e:	e406                	sd	ra,8(sp)
    80002230:	e022                	sd	s0,0(sp)
    80002232:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	d3e080e7          	jalr	-706(ra) # 80000f72 <myproc>
}
    8000223c:	5908                	lw	a0,48(a0)
    8000223e:	60a2                	ld	ra,8(sp)
    80002240:	6402                	ld	s0,0(sp)
    80002242:	0141                	addi	sp,sp,16
    80002244:	8082                	ret

0000000080002246 <sys_fork>:

uint64
sys_fork(void)
{
    80002246:	1141                	addi	sp,sp,-16
    80002248:	e406                	sd	ra,8(sp)
    8000224a:	e022                	sd	s0,0(sp)
    8000224c:	0800                	addi	s0,sp,16
  return fork();
    8000224e:	fffff097          	auipc	ra,0xfffff
    80002252:	174080e7          	jalr	372(ra) # 800013c2 <fork>
}
    80002256:	60a2                	ld	ra,8(sp)
    80002258:	6402                	ld	s0,0(sp)
    8000225a:	0141                	addi	sp,sp,16
    8000225c:	8082                	ret

000000008000225e <sys_wait>:

uint64
sys_wait(void)
{
    8000225e:	1101                	addi	sp,sp,-32
    80002260:	ec06                	sd	ra,24(sp)
    80002262:	e822                	sd	s0,16(sp)
    80002264:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002266:	fe840593          	addi	a1,s0,-24
    8000226a:	4501                	li	a0,0
    8000226c:	00000097          	auipc	ra,0x0
    80002270:	ed0080e7          	jalr	-304(ra) # 8000213c <argaddr>
  return wait(p);
    80002274:	fe843503          	ld	a0,-24(s0)
    80002278:	fffff097          	auipc	ra,0xfffff
    8000227c:	712080e7          	jalr	1810(ra) # 8000198a <wait>
}
    80002280:	60e2                	ld	ra,24(sp)
    80002282:	6442                	ld	s0,16(sp)
    80002284:	6105                	addi	sp,sp,32
    80002286:	8082                	ret

0000000080002288 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002288:	7179                	addi	sp,sp,-48
    8000228a:	f406                	sd	ra,40(sp)
    8000228c:	f022                	sd	s0,32(sp)
    8000228e:	ec26                	sd	s1,24(sp)
    80002290:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002292:	fdc40593          	addi	a1,s0,-36
    80002296:	4501                	li	a0,0
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	e84080e7          	jalr	-380(ra) # 8000211c <argint>
  addr = myproc()->sz;
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	cd2080e7          	jalr	-814(ra) # 80000f72 <myproc>
    800022a8:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800022aa:	fdc42503          	lw	a0,-36(s0)
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	0b8080e7          	jalr	184(ra) # 80001366 <growproc>
    800022b6:	00054863          	bltz	a0,800022c6 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800022ba:	8526                	mv	a0,s1
    800022bc:	70a2                	ld	ra,40(sp)
    800022be:	7402                	ld	s0,32(sp)
    800022c0:	64e2                	ld	s1,24(sp)
    800022c2:	6145                	addi	sp,sp,48
    800022c4:	8082                	ret
    return -1;
    800022c6:	54fd                	li	s1,-1
    800022c8:	bfcd                	j	800022ba <sys_sbrk+0x32>

00000000800022ca <sys_sleep>:

uint64
sys_sleep(void)
{
    800022ca:	7139                	addi	sp,sp,-64
    800022cc:	fc06                	sd	ra,56(sp)
    800022ce:	f822                	sd	s0,48(sp)
    800022d0:	f426                	sd	s1,40(sp)
    800022d2:	f04a                	sd	s2,32(sp)
    800022d4:	ec4e                	sd	s3,24(sp)
    800022d6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800022d8:	fcc40593          	addi	a1,s0,-52
    800022dc:	4501                	li	a0,0
    800022de:	00000097          	auipc	ra,0x0
    800022e2:	e3e080e7          	jalr	-450(ra) # 8000211c <argint>
  acquire(&tickslock);
    800022e6:	0000c517          	auipc	a0,0xc
    800022ea:	6ea50513          	addi	a0,a0,1770 # 8000e9d0 <tickslock>
    800022ee:	00004097          	auipc	ra,0x4
    800022f2:	0de080e7          	jalr	222(ra) # 800063cc <acquire>
  ticks0 = ticks;
    800022f6:	00006917          	auipc	s2,0x6
    800022fa:	67292903          	lw	s2,1650(s2) # 80008968 <ticks>
  while(ticks - ticks0 < n){
    800022fe:	fcc42783          	lw	a5,-52(s0)
    80002302:	cf9d                	beqz	a5,80002340 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002304:	0000c997          	auipc	s3,0xc
    80002308:	6cc98993          	addi	s3,s3,1740 # 8000e9d0 <tickslock>
    8000230c:	00006497          	auipc	s1,0x6
    80002310:	65c48493          	addi	s1,s1,1628 # 80008968 <ticks>
    if(killed(myproc())){
    80002314:	fffff097          	auipc	ra,0xfffff
    80002318:	c5e080e7          	jalr	-930(ra) # 80000f72 <myproc>
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	63c080e7          	jalr	1596(ra) # 80001958 <killed>
    80002324:	ed15                	bnez	a0,80002360 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002326:	85ce                	mv	a1,s3
    80002328:	8526                	mv	a0,s1
    8000232a:	fffff097          	auipc	ra,0xfffff
    8000232e:	386080e7          	jalr	902(ra) # 800016b0 <sleep>
  while(ticks - ticks0 < n){
    80002332:	409c                	lw	a5,0(s1)
    80002334:	412787bb          	subw	a5,a5,s2
    80002338:	fcc42703          	lw	a4,-52(s0)
    8000233c:	fce7ece3          	bltu	a5,a4,80002314 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002340:	0000c517          	auipc	a0,0xc
    80002344:	69050513          	addi	a0,a0,1680 # 8000e9d0 <tickslock>
    80002348:	00004097          	auipc	ra,0x4
    8000234c:	138080e7          	jalr	312(ra) # 80006480 <release>
  return 0;
    80002350:	4501                	li	a0,0
}
    80002352:	70e2                	ld	ra,56(sp)
    80002354:	7442                	ld	s0,48(sp)
    80002356:	74a2                	ld	s1,40(sp)
    80002358:	7902                	ld	s2,32(sp)
    8000235a:	69e2                	ld	s3,24(sp)
    8000235c:	6121                	addi	sp,sp,64
    8000235e:	8082                	ret
      release(&tickslock);
    80002360:	0000c517          	auipc	a0,0xc
    80002364:	67050513          	addi	a0,a0,1648 # 8000e9d0 <tickslock>
    80002368:	00004097          	auipc	ra,0x4
    8000236c:	118080e7          	jalr	280(ra) # 80006480 <release>
      return -1;
    80002370:	557d                	li	a0,-1
    80002372:	b7c5                	j	80002352 <sys_sleep+0x88>

0000000080002374 <sys_pgaccess>:

//#define LAB_PGTBL
#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002374:	715d                	addi	sp,sp,-80
    80002376:	e486                	sd	ra,72(sp)
    80002378:	e0a2                	sd	s0,64(sp)
    8000237a:	fc26                	sd	s1,56(sp)
    8000237c:	f84a                	sd	s2,48(sp)
    8000237e:	f44e                	sd	s3,40(sp)
    80002380:	f052                	sd	s4,32(sp)
    80002382:	0880                	addi	s0,sp,80
  // lab pgtbl: your code here.
  int n,buffer=0;//buffer-abits
    80002384:	fc042423          	sw	zero,-56(s0)
  uint64 va;
  uint64 abits;//address
  struct proc* p=myproc();
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	bea080e7          	jalr	-1046(ra) # 80000f72 <myproc>
    80002390:	892a                	mv	s2,a0
  argint(1,&n);
    80002392:	fcc40593          	addi	a1,s0,-52
    80002396:	4505                	li	a0,1
    80002398:	00000097          	auipc	ra,0x0
    8000239c:	d84080e7          	jalr	-636(ra) # 8000211c <argint>
  argaddr(0,&va);
    800023a0:	fc040593          	addi	a1,s0,-64
    800023a4:	4501                	li	a0,0
    800023a6:	00000097          	auipc	ra,0x0
    800023aa:	d96080e7          	jalr	-618(ra) # 8000213c <argaddr>
  argaddr(2,&abits);
    800023ae:	fb840593          	addi	a1,s0,-72
    800023b2:	4509                	li	a0,2
    800023b4:	00000097          	auipc	ra,0x0
    800023b8:	d88080e7          	jalr	-632(ra) # 8000213c <argaddr>
  if(n>32)return -1;
    800023bc:	fcc42783          	lw	a5,-52(s0)
    800023c0:	02000713          	li	a4,32
    800023c4:	08f74a63          	blt	a4,a5,80002458 <sys_pgaccess+0xe4>
  for(int i=0;i<n;i++)
    800023c8:	04f05963          	blez	a5,8000241a <sys_pgaccess+0xa6>
    800023cc:	4481                	li	s1,0
  {
    pte_t* pte=walk(p->pagetable,va,0);
    if(*pte&PTE_A){
      buffer|=(1<<i);
    800023ce:	4a05                	li	s4,1
      *pte&=~(PTE_A);
    }
    va+=PGSIZE;
    800023d0:	6985                	lui	s3,0x1
    800023d2:	a819                	j	800023e8 <sys_pgaccess+0x74>
    800023d4:	fc043783          	ld	a5,-64(s0)
    800023d8:	97ce                	add	a5,a5,s3
    800023da:	fcf43023          	sd	a5,-64(s0)
  for(int i=0;i<n;i++)
    800023de:	2485                	addiw	s1,s1,1
    800023e0:	fcc42783          	lw	a5,-52(s0)
    800023e4:	02f4db63          	bge	s1,a5,8000241a <sys_pgaccess+0xa6>
    pte_t* pte=walk(p->pagetable,va,0);
    800023e8:	4601                	li	a2,0
    800023ea:	fc043583          	ld	a1,-64(s0)
    800023ee:	05093503          	ld	a0,80(s2)
    800023f2:	ffffe097          	auipc	ra,0xffffe
    800023f6:	072080e7          	jalr	114(ra) # 80000464 <walk>
    if(*pte&PTE_A){
    800023fa:	611c                	ld	a5,0(a0)
    800023fc:	0407f793          	andi	a5,a5,64
    80002400:	dbf1                	beqz	a5,800023d4 <sys_pgaccess+0x60>
      buffer|=(1<<i);
    80002402:	009a17bb          	sllw	a5,s4,s1
    80002406:	fc842703          	lw	a4,-56(s0)
    8000240a:	8fd9                	or	a5,a5,a4
    8000240c:	fcf42423          	sw	a5,-56(s0)
      *pte&=~(PTE_A);
    80002410:	611c                	ld	a5,0(a0)
    80002412:	fbf7f793          	andi	a5,a5,-65
    80002416:	e11c                	sd	a5,0(a0)
    80002418:	bf75                	j	800023d4 <sys_pgaccess+0x60>
  }
  if(copyout(p->pagetable,abits,(char*)&buffer,sizeof(int))<0)
    8000241a:	4691                	li	a3,4
    8000241c:	fc840613          	addi	a2,s0,-56
    80002420:	fb843583          	ld	a1,-72(s0)
    80002424:	05093503          	ld	a0,80(s2)
    80002428:	ffffe097          	auipc	ra,0xffffe
    8000242c:	6ee080e7          	jalr	1774(ra) # 80000b16 <copyout>
    80002430:	87aa                	mv	a5,a0
    panic("pgaccess_copy");
  return 0;
    80002432:	4501                	li	a0,0
  if(copyout(p->pagetable,abits,(char*)&buffer,sizeof(int))<0)
    80002434:	0007ca63          	bltz	a5,80002448 <sys_pgaccess+0xd4>
}
    80002438:	60a6                	ld	ra,72(sp)
    8000243a:	6406                	ld	s0,64(sp)
    8000243c:	74e2                	ld	s1,56(sp)
    8000243e:	7942                	ld	s2,48(sp)
    80002440:	79a2                	ld	s3,40(sp)
    80002442:	7a02                	ld	s4,32(sp)
    80002444:	6161                	addi	sp,sp,80
    80002446:	8082                	ret
    panic("pgaccess_copy");
    80002448:	00006517          	auipc	a0,0x6
    8000244c:	0c850513          	addi	a0,a0,200 # 80008510 <syscalls+0xf8>
    80002450:	00004097          	auipc	ra,0x4
    80002454:	a32080e7          	jalr	-1486(ra) # 80005e82 <panic>
  if(n>32)return -1;
    80002458:	557d                	li	a0,-1
    8000245a:	bff9                	j	80002438 <sys_pgaccess+0xc4>

000000008000245c <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000245c:	1101                	addi	sp,sp,-32
    8000245e:	ec06                	sd	ra,24(sp)
    80002460:	e822                	sd	s0,16(sp)
    80002462:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002464:	fec40593          	addi	a1,s0,-20
    80002468:	4501                	li	a0,0
    8000246a:	00000097          	auipc	ra,0x0
    8000246e:	cb2080e7          	jalr	-846(ra) # 8000211c <argint>
  return kill(pid);
    80002472:	fec42503          	lw	a0,-20(s0)
    80002476:	fffff097          	auipc	ra,0xfffff
    8000247a:	444080e7          	jalr	1092(ra) # 800018ba <kill>
}
    8000247e:	60e2                	ld	ra,24(sp)
    80002480:	6442                	ld	s0,16(sp)
    80002482:	6105                	addi	sp,sp,32
    80002484:	8082                	ret

0000000080002486 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002486:	1101                	addi	sp,sp,-32
    80002488:	ec06                	sd	ra,24(sp)
    8000248a:	e822                	sd	s0,16(sp)
    8000248c:	e426                	sd	s1,8(sp)
    8000248e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002490:	0000c517          	auipc	a0,0xc
    80002494:	54050513          	addi	a0,a0,1344 # 8000e9d0 <tickslock>
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	f34080e7          	jalr	-204(ra) # 800063cc <acquire>
  xticks = ticks;
    800024a0:	00006497          	auipc	s1,0x6
    800024a4:	4c84a483          	lw	s1,1224(s1) # 80008968 <ticks>
  release(&tickslock);
    800024a8:	0000c517          	auipc	a0,0xc
    800024ac:	52850513          	addi	a0,a0,1320 # 8000e9d0 <tickslock>
    800024b0:	00004097          	auipc	ra,0x4
    800024b4:	fd0080e7          	jalr	-48(ra) # 80006480 <release>
  return xticks;
}
    800024b8:	02049513          	slli	a0,s1,0x20
    800024bc:	9101                	srli	a0,a0,0x20
    800024be:	60e2                	ld	ra,24(sp)
    800024c0:	6442                	ld	s0,16(sp)
    800024c2:	64a2                	ld	s1,8(sp)
    800024c4:	6105                	addi	sp,sp,32
    800024c6:	8082                	ret

00000000800024c8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024c8:	7179                	addi	sp,sp,-48
    800024ca:	f406                	sd	ra,40(sp)
    800024cc:	f022                	sd	s0,32(sp)
    800024ce:	ec26                	sd	s1,24(sp)
    800024d0:	e84a                	sd	s2,16(sp)
    800024d2:	e44e                	sd	s3,8(sp)
    800024d4:	e052                	sd	s4,0(sp)
    800024d6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024d8:	00006597          	auipc	a1,0x6
    800024dc:	04858593          	addi	a1,a1,72 # 80008520 <syscalls+0x108>
    800024e0:	0000c517          	auipc	a0,0xc
    800024e4:	50850513          	addi	a0,a0,1288 # 8000e9e8 <bcache>
    800024e8:	00004097          	auipc	ra,0x4
    800024ec:	e54080e7          	jalr	-428(ra) # 8000633c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024f0:	00014797          	auipc	a5,0x14
    800024f4:	4f878793          	addi	a5,a5,1272 # 800169e8 <bcache+0x8000>
    800024f8:	00014717          	auipc	a4,0x14
    800024fc:	75870713          	addi	a4,a4,1880 # 80016c50 <bcache+0x8268>
    80002500:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002504:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002508:	0000c497          	auipc	s1,0xc
    8000250c:	4f848493          	addi	s1,s1,1272 # 8000ea00 <bcache+0x18>
    b->next = bcache.head.next;
    80002510:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002512:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002514:	00006a17          	auipc	s4,0x6
    80002518:	014a0a13          	addi	s4,s4,20 # 80008528 <syscalls+0x110>
    b->next = bcache.head.next;
    8000251c:	2b893783          	ld	a5,696(s2)
    80002520:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002522:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002526:	85d2                	mv	a1,s4
    80002528:	01048513          	addi	a0,s1,16
    8000252c:	00001097          	auipc	ra,0x1
    80002530:	4c4080e7          	jalr	1220(ra) # 800039f0 <initsleeplock>
    bcache.head.next->prev = b;
    80002534:	2b893783          	ld	a5,696(s2)
    80002538:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000253a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000253e:	45848493          	addi	s1,s1,1112
    80002542:	fd349de3          	bne	s1,s3,8000251c <binit+0x54>
  }
}
    80002546:	70a2                	ld	ra,40(sp)
    80002548:	7402                	ld	s0,32(sp)
    8000254a:	64e2                	ld	s1,24(sp)
    8000254c:	6942                	ld	s2,16(sp)
    8000254e:	69a2                	ld	s3,8(sp)
    80002550:	6a02                	ld	s4,0(sp)
    80002552:	6145                	addi	sp,sp,48
    80002554:	8082                	ret

0000000080002556 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002556:	7179                	addi	sp,sp,-48
    80002558:	f406                	sd	ra,40(sp)
    8000255a:	f022                	sd	s0,32(sp)
    8000255c:	ec26                	sd	s1,24(sp)
    8000255e:	e84a                	sd	s2,16(sp)
    80002560:	e44e                	sd	s3,8(sp)
    80002562:	1800                	addi	s0,sp,48
    80002564:	89aa                	mv	s3,a0
    80002566:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002568:	0000c517          	auipc	a0,0xc
    8000256c:	48050513          	addi	a0,a0,1152 # 8000e9e8 <bcache>
    80002570:	00004097          	auipc	ra,0x4
    80002574:	e5c080e7          	jalr	-420(ra) # 800063cc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002578:	00014497          	auipc	s1,0x14
    8000257c:	7284b483          	ld	s1,1832(s1) # 80016ca0 <bcache+0x82b8>
    80002580:	00014797          	auipc	a5,0x14
    80002584:	6d078793          	addi	a5,a5,1744 # 80016c50 <bcache+0x8268>
    80002588:	02f48f63          	beq	s1,a5,800025c6 <bread+0x70>
    8000258c:	873e                	mv	a4,a5
    8000258e:	a021                	j	80002596 <bread+0x40>
    80002590:	68a4                	ld	s1,80(s1)
    80002592:	02e48a63          	beq	s1,a4,800025c6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002596:	449c                	lw	a5,8(s1)
    80002598:	ff379ce3          	bne	a5,s3,80002590 <bread+0x3a>
    8000259c:	44dc                	lw	a5,12(s1)
    8000259e:	ff2799e3          	bne	a5,s2,80002590 <bread+0x3a>
      b->refcnt++;
    800025a2:	40bc                	lw	a5,64(s1)
    800025a4:	2785                	addiw	a5,a5,1
    800025a6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025a8:	0000c517          	auipc	a0,0xc
    800025ac:	44050513          	addi	a0,a0,1088 # 8000e9e8 <bcache>
    800025b0:	00004097          	auipc	ra,0x4
    800025b4:	ed0080e7          	jalr	-304(ra) # 80006480 <release>
      acquiresleep(&b->lock);
    800025b8:	01048513          	addi	a0,s1,16
    800025bc:	00001097          	auipc	ra,0x1
    800025c0:	46e080e7          	jalr	1134(ra) # 80003a2a <acquiresleep>
      return b;
    800025c4:	a8b9                	j	80002622 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025c6:	00014497          	auipc	s1,0x14
    800025ca:	6d24b483          	ld	s1,1746(s1) # 80016c98 <bcache+0x82b0>
    800025ce:	00014797          	auipc	a5,0x14
    800025d2:	68278793          	addi	a5,a5,1666 # 80016c50 <bcache+0x8268>
    800025d6:	00f48863          	beq	s1,a5,800025e6 <bread+0x90>
    800025da:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025dc:	40bc                	lw	a5,64(s1)
    800025de:	cf81                	beqz	a5,800025f6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025e0:	64a4                	ld	s1,72(s1)
    800025e2:	fee49de3          	bne	s1,a4,800025dc <bread+0x86>
  panic("bget: no buffers");
    800025e6:	00006517          	auipc	a0,0x6
    800025ea:	f4a50513          	addi	a0,a0,-182 # 80008530 <syscalls+0x118>
    800025ee:	00004097          	auipc	ra,0x4
    800025f2:	894080e7          	jalr	-1900(ra) # 80005e82 <panic>
      b->dev = dev;
    800025f6:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800025fa:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025fe:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002602:	4785                	li	a5,1
    80002604:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002606:	0000c517          	auipc	a0,0xc
    8000260a:	3e250513          	addi	a0,a0,994 # 8000e9e8 <bcache>
    8000260e:	00004097          	auipc	ra,0x4
    80002612:	e72080e7          	jalr	-398(ra) # 80006480 <release>
      acquiresleep(&b->lock);
    80002616:	01048513          	addi	a0,s1,16
    8000261a:	00001097          	auipc	ra,0x1
    8000261e:	410080e7          	jalr	1040(ra) # 80003a2a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002622:	409c                	lw	a5,0(s1)
    80002624:	cb89                	beqz	a5,80002636 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002626:	8526                	mv	a0,s1
    80002628:	70a2                	ld	ra,40(sp)
    8000262a:	7402                	ld	s0,32(sp)
    8000262c:	64e2                	ld	s1,24(sp)
    8000262e:	6942                	ld	s2,16(sp)
    80002630:	69a2                	ld	s3,8(sp)
    80002632:	6145                	addi	sp,sp,48
    80002634:	8082                	ret
    virtio_disk_rw(b, 0);
    80002636:	4581                	li	a1,0
    80002638:	8526                	mv	a0,s1
    8000263a:	00003097          	auipc	ra,0x3
    8000263e:	fde080e7          	jalr	-34(ra) # 80005618 <virtio_disk_rw>
    b->valid = 1;
    80002642:	4785                	li	a5,1
    80002644:	c09c                	sw	a5,0(s1)
  return b;
    80002646:	b7c5                	j	80002626 <bread+0xd0>

0000000080002648 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002648:	1101                	addi	sp,sp,-32
    8000264a:	ec06                	sd	ra,24(sp)
    8000264c:	e822                	sd	s0,16(sp)
    8000264e:	e426                	sd	s1,8(sp)
    80002650:	1000                	addi	s0,sp,32
    80002652:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002654:	0541                	addi	a0,a0,16
    80002656:	00001097          	auipc	ra,0x1
    8000265a:	46e080e7          	jalr	1134(ra) # 80003ac4 <holdingsleep>
    8000265e:	cd01                	beqz	a0,80002676 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002660:	4585                	li	a1,1
    80002662:	8526                	mv	a0,s1
    80002664:	00003097          	auipc	ra,0x3
    80002668:	fb4080e7          	jalr	-76(ra) # 80005618 <virtio_disk_rw>
}
    8000266c:	60e2                	ld	ra,24(sp)
    8000266e:	6442                	ld	s0,16(sp)
    80002670:	64a2                	ld	s1,8(sp)
    80002672:	6105                	addi	sp,sp,32
    80002674:	8082                	ret
    panic("bwrite");
    80002676:	00006517          	auipc	a0,0x6
    8000267a:	ed250513          	addi	a0,a0,-302 # 80008548 <syscalls+0x130>
    8000267e:	00004097          	auipc	ra,0x4
    80002682:	804080e7          	jalr	-2044(ra) # 80005e82 <panic>

0000000080002686 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002686:	1101                	addi	sp,sp,-32
    80002688:	ec06                	sd	ra,24(sp)
    8000268a:	e822                	sd	s0,16(sp)
    8000268c:	e426                	sd	s1,8(sp)
    8000268e:	e04a                	sd	s2,0(sp)
    80002690:	1000                	addi	s0,sp,32
    80002692:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002694:	01050913          	addi	s2,a0,16
    80002698:	854a                	mv	a0,s2
    8000269a:	00001097          	auipc	ra,0x1
    8000269e:	42a080e7          	jalr	1066(ra) # 80003ac4 <holdingsleep>
    800026a2:	c92d                	beqz	a0,80002714 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026a4:	854a                	mv	a0,s2
    800026a6:	00001097          	auipc	ra,0x1
    800026aa:	3da080e7          	jalr	986(ra) # 80003a80 <releasesleep>

  acquire(&bcache.lock);
    800026ae:	0000c517          	auipc	a0,0xc
    800026b2:	33a50513          	addi	a0,a0,826 # 8000e9e8 <bcache>
    800026b6:	00004097          	auipc	ra,0x4
    800026ba:	d16080e7          	jalr	-746(ra) # 800063cc <acquire>
  b->refcnt--;
    800026be:	40bc                	lw	a5,64(s1)
    800026c0:	37fd                	addiw	a5,a5,-1
    800026c2:	0007871b          	sext.w	a4,a5
    800026c6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026c8:	eb05                	bnez	a4,800026f8 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026ca:	68bc                	ld	a5,80(s1)
    800026cc:	64b8                	ld	a4,72(s1)
    800026ce:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026d0:	64bc                	ld	a5,72(s1)
    800026d2:	68b8                	ld	a4,80(s1)
    800026d4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026d6:	00014797          	auipc	a5,0x14
    800026da:	31278793          	addi	a5,a5,786 # 800169e8 <bcache+0x8000>
    800026de:	2b87b703          	ld	a4,696(a5)
    800026e2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026e4:	00014717          	auipc	a4,0x14
    800026e8:	56c70713          	addi	a4,a4,1388 # 80016c50 <bcache+0x8268>
    800026ec:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026ee:	2b87b703          	ld	a4,696(a5)
    800026f2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026f4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026f8:	0000c517          	auipc	a0,0xc
    800026fc:	2f050513          	addi	a0,a0,752 # 8000e9e8 <bcache>
    80002700:	00004097          	auipc	ra,0x4
    80002704:	d80080e7          	jalr	-640(ra) # 80006480 <release>
}
    80002708:	60e2                	ld	ra,24(sp)
    8000270a:	6442                	ld	s0,16(sp)
    8000270c:	64a2                	ld	s1,8(sp)
    8000270e:	6902                	ld	s2,0(sp)
    80002710:	6105                	addi	sp,sp,32
    80002712:	8082                	ret
    panic("brelse");
    80002714:	00006517          	auipc	a0,0x6
    80002718:	e3c50513          	addi	a0,a0,-452 # 80008550 <syscalls+0x138>
    8000271c:	00003097          	auipc	ra,0x3
    80002720:	766080e7          	jalr	1894(ra) # 80005e82 <panic>

0000000080002724 <bpin>:

void
bpin(struct buf *b) {
    80002724:	1101                	addi	sp,sp,-32
    80002726:	ec06                	sd	ra,24(sp)
    80002728:	e822                	sd	s0,16(sp)
    8000272a:	e426                	sd	s1,8(sp)
    8000272c:	1000                	addi	s0,sp,32
    8000272e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002730:	0000c517          	auipc	a0,0xc
    80002734:	2b850513          	addi	a0,a0,696 # 8000e9e8 <bcache>
    80002738:	00004097          	auipc	ra,0x4
    8000273c:	c94080e7          	jalr	-876(ra) # 800063cc <acquire>
  b->refcnt++;
    80002740:	40bc                	lw	a5,64(s1)
    80002742:	2785                	addiw	a5,a5,1
    80002744:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002746:	0000c517          	auipc	a0,0xc
    8000274a:	2a250513          	addi	a0,a0,674 # 8000e9e8 <bcache>
    8000274e:	00004097          	auipc	ra,0x4
    80002752:	d32080e7          	jalr	-718(ra) # 80006480 <release>
}
    80002756:	60e2                	ld	ra,24(sp)
    80002758:	6442                	ld	s0,16(sp)
    8000275a:	64a2                	ld	s1,8(sp)
    8000275c:	6105                	addi	sp,sp,32
    8000275e:	8082                	ret

0000000080002760 <bunpin>:

void
bunpin(struct buf *b) {
    80002760:	1101                	addi	sp,sp,-32
    80002762:	ec06                	sd	ra,24(sp)
    80002764:	e822                	sd	s0,16(sp)
    80002766:	e426                	sd	s1,8(sp)
    80002768:	1000                	addi	s0,sp,32
    8000276a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000276c:	0000c517          	auipc	a0,0xc
    80002770:	27c50513          	addi	a0,a0,636 # 8000e9e8 <bcache>
    80002774:	00004097          	auipc	ra,0x4
    80002778:	c58080e7          	jalr	-936(ra) # 800063cc <acquire>
  b->refcnt--;
    8000277c:	40bc                	lw	a5,64(s1)
    8000277e:	37fd                	addiw	a5,a5,-1
    80002780:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002782:	0000c517          	auipc	a0,0xc
    80002786:	26650513          	addi	a0,a0,614 # 8000e9e8 <bcache>
    8000278a:	00004097          	auipc	ra,0x4
    8000278e:	cf6080e7          	jalr	-778(ra) # 80006480 <release>
}
    80002792:	60e2                	ld	ra,24(sp)
    80002794:	6442                	ld	s0,16(sp)
    80002796:	64a2                	ld	s1,8(sp)
    80002798:	6105                	addi	sp,sp,32
    8000279a:	8082                	ret

000000008000279c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000279c:	1101                	addi	sp,sp,-32
    8000279e:	ec06                	sd	ra,24(sp)
    800027a0:	e822                	sd	s0,16(sp)
    800027a2:	e426                	sd	s1,8(sp)
    800027a4:	e04a                	sd	s2,0(sp)
    800027a6:	1000                	addi	s0,sp,32
    800027a8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027aa:	00d5d59b          	srliw	a1,a1,0xd
    800027ae:	00015797          	auipc	a5,0x15
    800027b2:	9167a783          	lw	a5,-1770(a5) # 800170c4 <sb+0x1c>
    800027b6:	9dbd                	addw	a1,a1,a5
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	d9e080e7          	jalr	-610(ra) # 80002556 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027c0:	0074f713          	andi	a4,s1,7
    800027c4:	4785                	li	a5,1
    800027c6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027ca:	14ce                	slli	s1,s1,0x33
    800027cc:	90d9                	srli	s1,s1,0x36
    800027ce:	00950733          	add	a4,a0,s1
    800027d2:	05874703          	lbu	a4,88(a4)
    800027d6:	00e7f6b3          	and	a3,a5,a4
    800027da:	c69d                	beqz	a3,80002808 <bfree+0x6c>
    800027dc:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027de:	94aa                	add	s1,s1,a0
    800027e0:	fff7c793          	not	a5,a5
    800027e4:	8ff9                	and	a5,a5,a4
    800027e6:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027ea:	00001097          	auipc	ra,0x1
    800027ee:	120080e7          	jalr	288(ra) # 8000390a <log_write>
  brelse(bp);
    800027f2:	854a                	mv	a0,s2
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	e92080e7          	jalr	-366(ra) # 80002686 <brelse>
}
    800027fc:	60e2                	ld	ra,24(sp)
    800027fe:	6442                	ld	s0,16(sp)
    80002800:	64a2                	ld	s1,8(sp)
    80002802:	6902                	ld	s2,0(sp)
    80002804:	6105                	addi	sp,sp,32
    80002806:	8082                	ret
    panic("freeing free block");
    80002808:	00006517          	auipc	a0,0x6
    8000280c:	d5050513          	addi	a0,a0,-688 # 80008558 <syscalls+0x140>
    80002810:	00003097          	auipc	ra,0x3
    80002814:	672080e7          	jalr	1650(ra) # 80005e82 <panic>

0000000080002818 <balloc>:
{
    80002818:	711d                	addi	sp,sp,-96
    8000281a:	ec86                	sd	ra,88(sp)
    8000281c:	e8a2                	sd	s0,80(sp)
    8000281e:	e4a6                	sd	s1,72(sp)
    80002820:	e0ca                	sd	s2,64(sp)
    80002822:	fc4e                	sd	s3,56(sp)
    80002824:	f852                	sd	s4,48(sp)
    80002826:	f456                	sd	s5,40(sp)
    80002828:	f05a                	sd	s6,32(sp)
    8000282a:	ec5e                	sd	s7,24(sp)
    8000282c:	e862                	sd	s8,16(sp)
    8000282e:	e466                	sd	s9,8(sp)
    80002830:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002832:	00015797          	auipc	a5,0x15
    80002836:	87a7a783          	lw	a5,-1926(a5) # 800170ac <sb+0x4>
    8000283a:	10078163          	beqz	a5,8000293c <balloc+0x124>
    8000283e:	8baa                	mv	s7,a0
    80002840:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002842:	00015b17          	auipc	s6,0x15
    80002846:	866b0b13          	addi	s6,s6,-1946 # 800170a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000284c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002850:	6c89                	lui	s9,0x2
    80002852:	a061                	j	800028da <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002854:	974a                	add	a4,a4,s2
    80002856:	8fd5                	or	a5,a5,a3
    80002858:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000285c:	854a                	mv	a0,s2
    8000285e:	00001097          	auipc	ra,0x1
    80002862:	0ac080e7          	jalr	172(ra) # 8000390a <log_write>
        brelse(bp);
    80002866:	854a                	mv	a0,s2
    80002868:	00000097          	auipc	ra,0x0
    8000286c:	e1e080e7          	jalr	-482(ra) # 80002686 <brelse>
  bp = bread(dev, bno);
    80002870:	85a6                	mv	a1,s1
    80002872:	855e                	mv	a0,s7
    80002874:	00000097          	auipc	ra,0x0
    80002878:	ce2080e7          	jalr	-798(ra) # 80002556 <bread>
    8000287c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000287e:	40000613          	li	a2,1024
    80002882:	4581                	li	a1,0
    80002884:	05850513          	addi	a0,a0,88
    80002888:	ffffe097          	auipc	ra,0xffffe
    8000288c:	8f0080e7          	jalr	-1808(ra) # 80000178 <memset>
  log_write(bp);
    80002890:	854a                	mv	a0,s2
    80002892:	00001097          	auipc	ra,0x1
    80002896:	078080e7          	jalr	120(ra) # 8000390a <log_write>
  brelse(bp);
    8000289a:	854a                	mv	a0,s2
    8000289c:	00000097          	auipc	ra,0x0
    800028a0:	dea080e7          	jalr	-534(ra) # 80002686 <brelse>
}
    800028a4:	8526                	mv	a0,s1
    800028a6:	60e6                	ld	ra,88(sp)
    800028a8:	6446                	ld	s0,80(sp)
    800028aa:	64a6                	ld	s1,72(sp)
    800028ac:	6906                	ld	s2,64(sp)
    800028ae:	79e2                	ld	s3,56(sp)
    800028b0:	7a42                	ld	s4,48(sp)
    800028b2:	7aa2                	ld	s5,40(sp)
    800028b4:	7b02                	ld	s6,32(sp)
    800028b6:	6be2                	ld	s7,24(sp)
    800028b8:	6c42                	ld	s8,16(sp)
    800028ba:	6ca2                	ld	s9,8(sp)
    800028bc:	6125                	addi	sp,sp,96
    800028be:	8082                	ret
    brelse(bp);
    800028c0:	854a                	mv	a0,s2
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	dc4080e7          	jalr	-572(ra) # 80002686 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028ca:	015c87bb          	addw	a5,s9,s5
    800028ce:	00078a9b          	sext.w	s5,a5
    800028d2:	004b2703          	lw	a4,4(s6)
    800028d6:	06eaf363          	bgeu	s5,a4,8000293c <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800028da:	41fad79b          	sraiw	a5,s5,0x1f
    800028de:	0137d79b          	srliw	a5,a5,0x13
    800028e2:	015787bb          	addw	a5,a5,s5
    800028e6:	40d7d79b          	sraiw	a5,a5,0xd
    800028ea:	01cb2583          	lw	a1,28(s6)
    800028ee:	9dbd                	addw	a1,a1,a5
    800028f0:	855e                	mv	a0,s7
    800028f2:	00000097          	auipc	ra,0x0
    800028f6:	c64080e7          	jalr	-924(ra) # 80002556 <bread>
    800028fa:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028fc:	004b2503          	lw	a0,4(s6)
    80002900:	000a849b          	sext.w	s1,s5
    80002904:	8662                	mv	a2,s8
    80002906:	faa4fde3          	bgeu	s1,a0,800028c0 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000290a:	41f6579b          	sraiw	a5,a2,0x1f
    8000290e:	01d7d69b          	srliw	a3,a5,0x1d
    80002912:	00c6873b          	addw	a4,a3,a2
    80002916:	00777793          	andi	a5,a4,7
    8000291a:	9f95                	subw	a5,a5,a3
    8000291c:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002920:	4037571b          	sraiw	a4,a4,0x3
    80002924:	00e906b3          	add	a3,s2,a4
    80002928:	0586c683          	lbu	a3,88(a3)
    8000292c:	00d7f5b3          	and	a1,a5,a3
    80002930:	d195                	beqz	a1,80002854 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002932:	2605                	addiw	a2,a2,1
    80002934:	2485                	addiw	s1,s1,1
    80002936:	fd4618e3          	bne	a2,s4,80002906 <balloc+0xee>
    8000293a:	b759                	j	800028c0 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    8000293c:	00006517          	auipc	a0,0x6
    80002940:	c3450513          	addi	a0,a0,-972 # 80008570 <syscalls+0x158>
    80002944:	00003097          	auipc	ra,0x3
    80002948:	588080e7          	jalr	1416(ra) # 80005ecc <printf>
  return 0;
    8000294c:	4481                	li	s1,0
    8000294e:	bf99                	j	800028a4 <balloc+0x8c>

0000000080002950 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002950:	7179                	addi	sp,sp,-48
    80002952:	f406                	sd	ra,40(sp)
    80002954:	f022                	sd	s0,32(sp)
    80002956:	ec26                	sd	s1,24(sp)
    80002958:	e84a                	sd	s2,16(sp)
    8000295a:	e44e                	sd	s3,8(sp)
    8000295c:	e052                	sd	s4,0(sp)
    8000295e:	1800                	addi	s0,sp,48
    80002960:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002962:	47ad                	li	a5,11
    80002964:	02b7e763          	bltu	a5,a1,80002992 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002968:	02059493          	slli	s1,a1,0x20
    8000296c:	9081                	srli	s1,s1,0x20
    8000296e:	048a                	slli	s1,s1,0x2
    80002970:	94aa                	add	s1,s1,a0
    80002972:	0504a903          	lw	s2,80(s1)
    80002976:	06091e63          	bnez	s2,800029f2 <bmap+0xa2>
      addr = balloc(ip->dev);
    8000297a:	4108                	lw	a0,0(a0)
    8000297c:	00000097          	auipc	ra,0x0
    80002980:	e9c080e7          	jalr	-356(ra) # 80002818 <balloc>
    80002984:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002988:	06090563          	beqz	s2,800029f2 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    8000298c:	0524a823          	sw	s2,80(s1)
    80002990:	a08d                	j	800029f2 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002992:	ff45849b          	addiw	s1,a1,-12
    80002996:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000299a:	0ff00793          	li	a5,255
    8000299e:	08e7e563          	bltu	a5,a4,80002a28 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800029a2:	08052903          	lw	s2,128(a0)
    800029a6:	00091d63          	bnez	s2,800029c0 <bmap+0x70>
      addr = balloc(ip->dev);
    800029aa:	4108                	lw	a0,0(a0)
    800029ac:	00000097          	auipc	ra,0x0
    800029b0:	e6c080e7          	jalr	-404(ra) # 80002818 <balloc>
    800029b4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029b8:	02090d63          	beqz	s2,800029f2 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029bc:	0929a023          	sw	s2,128(s3) # 1080 <_entry-0x7fffef80>
    }
    bp = bread(ip->dev, addr);
    800029c0:	85ca                	mv	a1,s2
    800029c2:	0009a503          	lw	a0,0(s3)
    800029c6:	00000097          	auipc	ra,0x0
    800029ca:	b90080e7          	jalr	-1136(ra) # 80002556 <bread>
    800029ce:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029d0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029d4:	02049593          	slli	a1,s1,0x20
    800029d8:	9181                	srli	a1,a1,0x20
    800029da:	058a                	slli	a1,a1,0x2
    800029dc:	00b784b3          	add	s1,a5,a1
    800029e0:	0004a903          	lw	s2,0(s1)
    800029e4:	02090063          	beqz	s2,80002a04 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029e8:	8552                	mv	a0,s4
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	c9c080e7          	jalr	-868(ra) # 80002686 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029f2:	854a                	mv	a0,s2
    800029f4:	70a2                	ld	ra,40(sp)
    800029f6:	7402                	ld	s0,32(sp)
    800029f8:	64e2                	ld	s1,24(sp)
    800029fa:	6942                	ld	s2,16(sp)
    800029fc:	69a2                	ld	s3,8(sp)
    800029fe:	6a02                	ld	s4,0(sp)
    80002a00:	6145                	addi	sp,sp,48
    80002a02:	8082                	ret
      addr = balloc(ip->dev);
    80002a04:	0009a503          	lw	a0,0(s3)
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	e10080e7          	jalr	-496(ra) # 80002818 <balloc>
    80002a10:	0005091b          	sext.w	s2,a0
      if(addr){
    80002a14:	fc090ae3          	beqz	s2,800029e8 <bmap+0x98>
        a[bn] = addr;
    80002a18:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a1c:	8552                	mv	a0,s4
    80002a1e:	00001097          	auipc	ra,0x1
    80002a22:	eec080e7          	jalr	-276(ra) # 8000390a <log_write>
    80002a26:	b7c9                	j	800029e8 <bmap+0x98>
  panic("bmap: out of range");
    80002a28:	00006517          	auipc	a0,0x6
    80002a2c:	b6050513          	addi	a0,a0,-1184 # 80008588 <syscalls+0x170>
    80002a30:	00003097          	auipc	ra,0x3
    80002a34:	452080e7          	jalr	1106(ra) # 80005e82 <panic>

0000000080002a38 <iget>:
{
    80002a38:	7179                	addi	sp,sp,-48
    80002a3a:	f406                	sd	ra,40(sp)
    80002a3c:	f022                	sd	s0,32(sp)
    80002a3e:	ec26                	sd	s1,24(sp)
    80002a40:	e84a                	sd	s2,16(sp)
    80002a42:	e44e                	sd	s3,8(sp)
    80002a44:	e052                	sd	s4,0(sp)
    80002a46:	1800                	addi	s0,sp,48
    80002a48:	89aa                	mv	s3,a0
    80002a4a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a4c:	00014517          	auipc	a0,0x14
    80002a50:	67c50513          	addi	a0,a0,1660 # 800170c8 <itable>
    80002a54:	00004097          	auipc	ra,0x4
    80002a58:	978080e7          	jalr	-1672(ra) # 800063cc <acquire>
  empty = 0;
    80002a5c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a5e:	00014497          	auipc	s1,0x14
    80002a62:	68248493          	addi	s1,s1,1666 # 800170e0 <itable+0x18>
    80002a66:	00016697          	auipc	a3,0x16
    80002a6a:	10a68693          	addi	a3,a3,266 # 80018b70 <log>
    80002a6e:	a039                	j	80002a7c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a70:	02090b63          	beqz	s2,80002aa6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a74:	08848493          	addi	s1,s1,136
    80002a78:	02d48a63          	beq	s1,a3,80002aac <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a7c:	449c                	lw	a5,8(s1)
    80002a7e:	fef059e3          	blez	a5,80002a70 <iget+0x38>
    80002a82:	4098                	lw	a4,0(s1)
    80002a84:	ff3716e3          	bne	a4,s3,80002a70 <iget+0x38>
    80002a88:	40d8                	lw	a4,4(s1)
    80002a8a:	ff4713e3          	bne	a4,s4,80002a70 <iget+0x38>
      ip->ref++;
    80002a8e:	2785                	addiw	a5,a5,1
    80002a90:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a92:	00014517          	auipc	a0,0x14
    80002a96:	63650513          	addi	a0,a0,1590 # 800170c8 <itable>
    80002a9a:	00004097          	auipc	ra,0x4
    80002a9e:	9e6080e7          	jalr	-1562(ra) # 80006480 <release>
      return ip;
    80002aa2:	8926                	mv	s2,s1
    80002aa4:	a03d                	j	80002ad2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aa6:	f7f9                	bnez	a5,80002a74 <iget+0x3c>
    80002aa8:	8926                	mv	s2,s1
    80002aaa:	b7e9                	j	80002a74 <iget+0x3c>
  if(empty == 0)
    80002aac:	02090c63          	beqz	s2,80002ae4 <iget+0xac>
  ip->dev = dev;
    80002ab0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ab4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ab8:	4785                	li	a5,1
    80002aba:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002abe:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ac2:	00014517          	auipc	a0,0x14
    80002ac6:	60650513          	addi	a0,a0,1542 # 800170c8 <itable>
    80002aca:	00004097          	auipc	ra,0x4
    80002ace:	9b6080e7          	jalr	-1610(ra) # 80006480 <release>
}
    80002ad2:	854a                	mv	a0,s2
    80002ad4:	70a2                	ld	ra,40(sp)
    80002ad6:	7402                	ld	s0,32(sp)
    80002ad8:	64e2                	ld	s1,24(sp)
    80002ada:	6942                	ld	s2,16(sp)
    80002adc:	69a2                	ld	s3,8(sp)
    80002ade:	6a02                	ld	s4,0(sp)
    80002ae0:	6145                	addi	sp,sp,48
    80002ae2:	8082                	ret
    panic("iget: no inodes");
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	abc50513          	addi	a0,a0,-1348 # 800085a0 <syscalls+0x188>
    80002aec:	00003097          	auipc	ra,0x3
    80002af0:	396080e7          	jalr	918(ra) # 80005e82 <panic>

0000000080002af4 <fsinit>:
fsinit(int dev) {
    80002af4:	7179                	addi	sp,sp,-48
    80002af6:	f406                	sd	ra,40(sp)
    80002af8:	f022                	sd	s0,32(sp)
    80002afa:	ec26                	sd	s1,24(sp)
    80002afc:	e84a                	sd	s2,16(sp)
    80002afe:	e44e                	sd	s3,8(sp)
    80002b00:	1800                	addi	s0,sp,48
    80002b02:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b04:	4585                	li	a1,1
    80002b06:	00000097          	auipc	ra,0x0
    80002b0a:	a50080e7          	jalr	-1456(ra) # 80002556 <bread>
    80002b0e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b10:	00014997          	auipc	s3,0x14
    80002b14:	59898993          	addi	s3,s3,1432 # 800170a8 <sb>
    80002b18:	02000613          	li	a2,32
    80002b1c:	05850593          	addi	a1,a0,88
    80002b20:	854e                	mv	a0,s3
    80002b22:	ffffd097          	auipc	ra,0xffffd
    80002b26:	6b6080e7          	jalr	1718(ra) # 800001d8 <memmove>
  brelse(bp);
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	00000097          	auipc	ra,0x0
    80002b30:	b5a080e7          	jalr	-1190(ra) # 80002686 <brelse>
  if(sb.magic != FSMAGIC)
    80002b34:	0009a703          	lw	a4,0(s3)
    80002b38:	102037b7          	lui	a5,0x10203
    80002b3c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b40:	02f71263          	bne	a4,a5,80002b64 <fsinit+0x70>
  initlog(dev, &sb);
    80002b44:	00014597          	auipc	a1,0x14
    80002b48:	56458593          	addi	a1,a1,1380 # 800170a8 <sb>
    80002b4c:	854a                	mv	a0,s2
    80002b4e:	00001097          	auipc	ra,0x1
    80002b52:	b40080e7          	jalr	-1216(ra) # 8000368e <initlog>
}
    80002b56:	70a2                	ld	ra,40(sp)
    80002b58:	7402                	ld	s0,32(sp)
    80002b5a:	64e2                	ld	s1,24(sp)
    80002b5c:	6942                	ld	s2,16(sp)
    80002b5e:	69a2                	ld	s3,8(sp)
    80002b60:	6145                	addi	sp,sp,48
    80002b62:	8082                	ret
    panic("invalid file system");
    80002b64:	00006517          	auipc	a0,0x6
    80002b68:	a4c50513          	addi	a0,a0,-1460 # 800085b0 <syscalls+0x198>
    80002b6c:	00003097          	auipc	ra,0x3
    80002b70:	316080e7          	jalr	790(ra) # 80005e82 <panic>

0000000080002b74 <iinit>:
{
    80002b74:	7179                	addi	sp,sp,-48
    80002b76:	f406                	sd	ra,40(sp)
    80002b78:	f022                	sd	s0,32(sp)
    80002b7a:	ec26                	sd	s1,24(sp)
    80002b7c:	e84a                	sd	s2,16(sp)
    80002b7e:	e44e                	sd	s3,8(sp)
    80002b80:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b82:	00006597          	auipc	a1,0x6
    80002b86:	a4658593          	addi	a1,a1,-1466 # 800085c8 <syscalls+0x1b0>
    80002b8a:	00014517          	auipc	a0,0x14
    80002b8e:	53e50513          	addi	a0,a0,1342 # 800170c8 <itable>
    80002b92:	00003097          	auipc	ra,0x3
    80002b96:	7aa080e7          	jalr	1962(ra) # 8000633c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b9a:	00014497          	auipc	s1,0x14
    80002b9e:	55648493          	addi	s1,s1,1366 # 800170f0 <itable+0x28>
    80002ba2:	00016997          	auipc	s3,0x16
    80002ba6:	fde98993          	addi	s3,s3,-34 # 80018b80 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002baa:	00006917          	auipc	s2,0x6
    80002bae:	a2690913          	addi	s2,s2,-1498 # 800085d0 <syscalls+0x1b8>
    80002bb2:	85ca                	mv	a1,s2
    80002bb4:	8526                	mv	a0,s1
    80002bb6:	00001097          	auipc	ra,0x1
    80002bba:	e3a080e7          	jalr	-454(ra) # 800039f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bbe:	08848493          	addi	s1,s1,136
    80002bc2:	ff3498e3          	bne	s1,s3,80002bb2 <iinit+0x3e>
}
    80002bc6:	70a2                	ld	ra,40(sp)
    80002bc8:	7402                	ld	s0,32(sp)
    80002bca:	64e2                	ld	s1,24(sp)
    80002bcc:	6942                	ld	s2,16(sp)
    80002bce:	69a2                	ld	s3,8(sp)
    80002bd0:	6145                	addi	sp,sp,48
    80002bd2:	8082                	ret

0000000080002bd4 <ialloc>:
{
    80002bd4:	715d                	addi	sp,sp,-80
    80002bd6:	e486                	sd	ra,72(sp)
    80002bd8:	e0a2                	sd	s0,64(sp)
    80002bda:	fc26                	sd	s1,56(sp)
    80002bdc:	f84a                	sd	s2,48(sp)
    80002bde:	f44e                	sd	s3,40(sp)
    80002be0:	f052                	sd	s4,32(sp)
    80002be2:	ec56                	sd	s5,24(sp)
    80002be4:	e85a                	sd	s6,16(sp)
    80002be6:	e45e                	sd	s7,8(sp)
    80002be8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bea:	00014717          	auipc	a4,0x14
    80002bee:	4ca72703          	lw	a4,1226(a4) # 800170b4 <sb+0xc>
    80002bf2:	4785                	li	a5,1
    80002bf4:	04e7fa63          	bgeu	a5,a4,80002c48 <ialloc+0x74>
    80002bf8:	8aaa                	mv	s5,a0
    80002bfa:	8bae                	mv	s7,a1
    80002bfc:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bfe:	00014a17          	auipc	s4,0x14
    80002c02:	4aaa0a13          	addi	s4,s4,1194 # 800170a8 <sb>
    80002c06:	00048b1b          	sext.w	s6,s1
    80002c0a:	0044d593          	srli	a1,s1,0x4
    80002c0e:	018a2783          	lw	a5,24(s4)
    80002c12:	9dbd                	addw	a1,a1,a5
    80002c14:	8556                	mv	a0,s5
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	940080e7          	jalr	-1728(ra) # 80002556 <bread>
    80002c1e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c20:	05850993          	addi	s3,a0,88
    80002c24:	00f4f793          	andi	a5,s1,15
    80002c28:	079a                	slli	a5,a5,0x6
    80002c2a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c2c:	00099783          	lh	a5,0(s3)
    80002c30:	c3a1                	beqz	a5,80002c70 <ialloc+0x9c>
    brelse(bp);
    80002c32:	00000097          	auipc	ra,0x0
    80002c36:	a54080e7          	jalr	-1452(ra) # 80002686 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c3a:	0485                	addi	s1,s1,1
    80002c3c:	00ca2703          	lw	a4,12(s4)
    80002c40:	0004879b          	sext.w	a5,s1
    80002c44:	fce7e1e3          	bltu	a5,a4,80002c06 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002c48:	00006517          	auipc	a0,0x6
    80002c4c:	99050513          	addi	a0,a0,-1648 # 800085d8 <syscalls+0x1c0>
    80002c50:	00003097          	auipc	ra,0x3
    80002c54:	27c080e7          	jalr	636(ra) # 80005ecc <printf>
  return 0;
    80002c58:	4501                	li	a0,0
}
    80002c5a:	60a6                	ld	ra,72(sp)
    80002c5c:	6406                	ld	s0,64(sp)
    80002c5e:	74e2                	ld	s1,56(sp)
    80002c60:	7942                	ld	s2,48(sp)
    80002c62:	79a2                	ld	s3,40(sp)
    80002c64:	7a02                	ld	s4,32(sp)
    80002c66:	6ae2                	ld	s5,24(sp)
    80002c68:	6b42                	ld	s6,16(sp)
    80002c6a:	6ba2                	ld	s7,8(sp)
    80002c6c:	6161                	addi	sp,sp,80
    80002c6e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c70:	04000613          	li	a2,64
    80002c74:	4581                	li	a1,0
    80002c76:	854e                	mv	a0,s3
    80002c78:	ffffd097          	auipc	ra,0xffffd
    80002c7c:	500080e7          	jalr	1280(ra) # 80000178 <memset>
      dip->type = type;
    80002c80:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c84:	854a                	mv	a0,s2
    80002c86:	00001097          	auipc	ra,0x1
    80002c8a:	c84080e7          	jalr	-892(ra) # 8000390a <log_write>
      brelse(bp);
    80002c8e:	854a                	mv	a0,s2
    80002c90:	00000097          	auipc	ra,0x0
    80002c94:	9f6080e7          	jalr	-1546(ra) # 80002686 <brelse>
      return iget(dev, inum);
    80002c98:	85da                	mv	a1,s6
    80002c9a:	8556                	mv	a0,s5
    80002c9c:	00000097          	auipc	ra,0x0
    80002ca0:	d9c080e7          	jalr	-612(ra) # 80002a38 <iget>
    80002ca4:	bf5d                	j	80002c5a <ialloc+0x86>

0000000080002ca6 <iupdate>:
{
    80002ca6:	1101                	addi	sp,sp,-32
    80002ca8:	ec06                	sd	ra,24(sp)
    80002caa:	e822                	sd	s0,16(sp)
    80002cac:	e426                	sd	s1,8(sp)
    80002cae:	e04a                	sd	s2,0(sp)
    80002cb0:	1000                	addi	s0,sp,32
    80002cb2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cb4:	415c                	lw	a5,4(a0)
    80002cb6:	0047d79b          	srliw	a5,a5,0x4
    80002cba:	00014597          	auipc	a1,0x14
    80002cbe:	4065a583          	lw	a1,1030(a1) # 800170c0 <sb+0x18>
    80002cc2:	9dbd                	addw	a1,a1,a5
    80002cc4:	4108                	lw	a0,0(a0)
    80002cc6:	00000097          	auipc	ra,0x0
    80002cca:	890080e7          	jalr	-1904(ra) # 80002556 <bread>
    80002cce:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cd0:	05850793          	addi	a5,a0,88
    80002cd4:	40c8                	lw	a0,4(s1)
    80002cd6:	893d                	andi	a0,a0,15
    80002cd8:	051a                	slli	a0,a0,0x6
    80002cda:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002cdc:	04449703          	lh	a4,68(s1)
    80002ce0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002ce4:	04649703          	lh	a4,70(s1)
    80002ce8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002cec:	04849703          	lh	a4,72(s1)
    80002cf0:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002cf4:	04a49703          	lh	a4,74(s1)
    80002cf8:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002cfc:	44f8                	lw	a4,76(s1)
    80002cfe:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d00:	03400613          	li	a2,52
    80002d04:	05048593          	addi	a1,s1,80
    80002d08:	0531                	addi	a0,a0,12
    80002d0a:	ffffd097          	auipc	ra,0xffffd
    80002d0e:	4ce080e7          	jalr	1230(ra) # 800001d8 <memmove>
  log_write(bp);
    80002d12:	854a                	mv	a0,s2
    80002d14:	00001097          	auipc	ra,0x1
    80002d18:	bf6080e7          	jalr	-1034(ra) # 8000390a <log_write>
  brelse(bp);
    80002d1c:	854a                	mv	a0,s2
    80002d1e:	00000097          	auipc	ra,0x0
    80002d22:	968080e7          	jalr	-1688(ra) # 80002686 <brelse>
}
    80002d26:	60e2                	ld	ra,24(sp)
    80002d28:	6442                	ld	s0,16(sp)
    80002d2a:	64a2                	ld	s1,8(sp)
    80002d2c:	6902                	ld	s2,0(sp)
    80002d2e:	6105                	addi	sp,sp,32
    80002d30:	8082                	ret

0000000080002d32 <idup>:
{
    80002d32:	1101                	addi	sp,sp,-32
    80002d34:	ec06                	sd	ra,24(sp)
    80002d36:	e822                	sd	s0,16(sp)
    80002d38:	e426                	sd	s1,8(sp)
    80002d3a:	1000                	addi	s0,sp,32
    80002d3c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d3e:	00014517          	auipc	a0,0x14
    80002d42:	38a50513          	addi	a0,a0,906 # 800170c8 <itable>
    80002d46:	00003097          	auipc	ra,0x3
    80002d4a:	686080e7          	jalr	1670(ra) # 800063cc <acquire>
  ip->ref++;
    80002d4e:	449c                	lw	a5,8(s1)
    80002d50:	2785                	addiw	a5,a5,1
    80002d52:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d54:	00014517          	auipc	a0,0x14
    80002d58:	37450513          	addi	a0,a0,884 # 800170c8 <itable>
    80002d5c:	00003097          	auipc	ra,0x3
    80002d60:	724080e7          	jalr	1828(ra) # 80006480 <release>
}
    80002d64:	8526                	mv	a0,s1
    80002d66:	60e2                	ld	ra,24(sp)
    80002d68:	6442                	ld	s0,16(sp)
    80002d6a:	64a2                	ld	s1,8(sp)
    80002d6c:	6105                	addi	sp,sp,32
    80002d6e:	8082                	ret

0000000080002d70 <ilock>:
{
    80002d70:	1101                	addi	sp,sp,-32
    80002d72:	ec06                	sd	ra,24(sp)
    80002d74:	e822                	sd	s0,16(sp)
    80002d76:	e426                	sd	s1,8(sp)
    80002d78:	e04a                	sd	s2,0(sp)
    80002d7a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d7c:	c115                	beqz	a0,80002da0 <ilock+0x30>
    80002d7e:	84aa                	mv	s1,a0
    80002d80:	451c                	lw	a5,8(a0)
    80002d82:	00f05f63          	blez	a5,80002da0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d86:	0541                	addi	a0,a0,16
    80002d88:	00001097          	auipc	ra,0x1
    80002d8c:	ca2080e7          	jalr	-862(ra) # 80003a2a <acquiresleep>
  if(ip->valid == 0){
    80002d90:	40bc                	lw	a5,64(s1)
    80002d92:	cf99                	beqz	a5,80002db0 <ilock+0x40>
}
    80002d94:	60e2                	ld	ra,24(sp)
    80002d96:	6442                	ld	s0,16(sp)
    80002d98:	64a2                	ld	s1,8(sp)
    80002d9a:	6902                	ld	s2,0(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret
    panic("ilock");
    80002da0:	00006517          	auipc	a0,0x6
    80002da4:	85050513          	addi	a0,a0,-1968 # 800085f0 <syscalls+0x1d8>
    80002da8:	00003097          	auipc	ra,0x3
    80002dac:	0da080e7          	jalr	218(ra) # 80005e82 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002db0:	40dc                	lw	a5,4(s1)
    80002db2:	0047d79b          	srliw	a5,a5,0x4
    80002db6:	00014597          	auipc	a1,0x14
    80002dba:	30a5a583          	lw	a1,778(a1) # 800170c0 <sb+0x18>
    80002dbe:	9dbd                	addw	a1,a1,a5
    80002dc0:	4088                	lw	a0,0(s1)
    80002dc2:	fffff097          	auipc	ra,0xfffff
    80002dc6:	794080e7          	jalr	1940(ra) # 80002556 <bread>
    80002dca:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dcc:	05850593          	addi	a1,a0,88
    80002dd0:	40dc                	lw	a5,4(s1)
    80002dd2:	8bbd                	andi	a5,a5,15
    80002dd4:	079a                	slli	a5,a5,0x6
    80002dd6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dd8:	00059783          	lh	a5,0(a1)
    80002ddc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002de0:	00259783          	lh	a5,2(a1)
    80002de4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002de8:	00459783          	lh	a5,4(a1)
    80002dec:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002df0:	00659783          	lh	a5,6(a1)
    80002df4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002df8:	459c                	lw	a5,8(a1)
    80002dfa:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002dfc:	03400613          	li	a2,52
    80002e00:	05b1                	addi	a1,a1,12
    80002e02:	05048513          	addi	a0,s1,80
    80002e06:	ffffd097          	auipc	ra,0xffffd
    80002e0a:	3d2080e7          	jalr	978(ra) # 800001d8 <memmove>
    brelse(bp);
    80002e0e:	854a                	mv	a0,s2
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	876080e7          	jalr	-1930(ra) # 80002686 <brelse>
    ip->valid = 1;
    80002e18:	4785                	li	a5,1
    80002e1a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e1c:	04449783          	lh	a5,68(s1)
    80002e20:	fbb5                	bnez	a5,80002d94 <ilock+0x24>
      panic("ilock: no type");
    80002e22:	00005517          	auipc	a0,0x5
    80002e26:	7d650513          	addi	a0,a0,2006 # 800085f8 <syscalls+0x1e0>
    80002e2a:	00003097          	auipc	ra,0x3
    80002e2e:	058080e7          	jalr	88(ra) # 80005e82 <panic>

0000000080002e32 <iunlock>:
{
    80002e32:	1101                	addi	sp,sp,-32
    80002e34:	ec06                	sd	ra,24(sp)
    80002e36:	e822                	sd	s0,16(sp)
    80002e38:	e426                	sd	s1,8(sp)
    80002e3a:	e04a                	sd	s2,0(sp)
    80002e3c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e3e:	c905                	beqz	a0,80002e6e <iunlock+0x3c>
    80002e40:	84aa                	mv	s1,a0
    80002e42:	01050913          	addi	s2,a0,16
    80002e46:	854a                	mv	a0,s2
    80002e48:	00001097          	auipc	ra,0x1
    80002e4c:	c7c080e7          	jalr	-900(ra) # 80003ac4 <holdingsleep>
    80002e50:	cd19                	beqz	a0,80002e6e <iunlock+0x3c>
    80002e52:	449c                	lw	a5,8(s1)
    80002e54:	00f05d63          	blez	a5,80002e6e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e58:	854a                	mv	a0,s2
    80002e5a:	00001097          	auipc	ra,0x1
    80002e5e:	c26080e7          	jalr	-986(ra) # 80003a80 <releasesleep>
}
    80002e62:	60e2                	ld	ra,24(sp)
    80002e64:	6442                	ld	s0,16(sp)
    80002e66:	64a2                	ld	s1,8(sp)
    80002e68:	6902                	ld	s2,0(sp)
    80002e6a:	6105                	addi	sp,sp,32
    80002e6c:	8082                	ret
    panic("iunlock");
    80002e6e:	00005517          	auipc	a0,0x5
    80002e72:	79a50513          	addi	a0,a0,1946 # 80008608 <syscalls+0x1f0>
    80002e76:	00003097          	auipc	ra,0x3
    80002e7a:	00c080e7          	jalr	12(ra) # 80005e82 <panic>

0000000080002e7e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e7e:	7179                	addi	sp,sp,-48
    80002e80:	f406                	sd	ra,40(sp)
    80002e82:	f022                	sd	s0,32(sp)
    80002e84:	ec26                	sd	s1,24(sp)
    80002e86:	e84a                	sd	s2,16(sp)
    80002e88:	e44e                	sd	s3,8(sp)
    80002e8a:	e052                	sd	s4,0(sp)
    80002e8c:	1800                	addi	s0,sp,48
    80002e8e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e90:	05050493          	addi	s1,a0,80
    80002e94:	08050913          	addi	s2,a0,128
    80002e98:	a021                	j	80002ea0 <itrunc+0x22>
    80002e9a:	0491                	addi	s1,s1,4
    80002e9c:	01248d63          	beq	s1,s2,80002eb6 <itrunc+0x38>
    if(ip->addrs[i]){
    80002ea0:	408c                	lw	a1,0(s1)
    80002ea2:	dde5                	beqz	a1,80002e9a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ea4:	0009a503          	lw	a0,0(s3)
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	8f4080e7          	jalr	-1804(ra) # 8000279c <bfree>
      ip->addrs[i] = 0;
    80002eb0:	0004a023          	sw	zero,0(s1)
    80002eb4:	b7dd                	j	80002e9a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002eb6:	0809a583          	lw	a1,128(s3)
    80002eba:	e185                	bnez	a1,80002eda <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ebc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ec0:	854e                	mv	a0,s3
    80002ec2:	00000097          	auipc	ra,0x0
    80002ec6:	de4080e7          	jalr	-540(ra) # 80002ca6 <iupdate>
}
    80002eca:	70a2                	ld	ra,40(sp)
    80002ecc:	7402                	ld	s0,32(sp)
    80002ece:	64e2                	ld	s1,24(sp)
    80002ed0:	6942                	ld	s2,16(sp)
    80002ed2:	69a2                	ld	s3,8(sp)
    80002ed4:	6a02                	ld	s4,0(sp)
    80002ed6:	6145                	addi	sp,sp,48
    80002ed8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002eda:	0009a503          	lw	a0,0(s3)
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	678080e7          	jalr	1656(ra) # 80002556 <bread>
    80002ee6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ee8:	05850493          	addi	s1,a0,88
    80002eec:	45850913          	addi	s2,a0,1112
    80002ef0:	a811                	j	80002f04 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002ef2:	0009a503          	lw	a0,0(s3)
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	8a6080e7          	jalr	-1882(ra) # 8000279c <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002efe:	0491                	addi	s1,s1,4
    80002f00:	01248563          	beq	s1,s2,80002f0a <itrunc+0x8c>
      if(a[j])
    80002f04:	408c                	lw	a1,0(s1)
    80002f06:	dde5                	beqz	a1,80002efe <itrunc+0x80>
    80002f08:	b7ed                	j	80002ef2 <itrunc+0x74>
    brelse(bp);
    80002f0a:	8552                	mv	a0,s4
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	77a080e7          	jalr	1914(ra) # 80002686 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f14:	0809a583          	lw	a1,128(s3)
    80002f18:	0009a503          	lw	a0,0(s3)
    80002f1c:	00000097          	auipc	ra,0x0
    80002f20:	880080e7          	jalr	-1920(ra) # 8000279c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f24:	0809a023          	sw	zero,128(s3)
    80002f28:	bf51                	j	80002ebc <itrunc+0x3e>

0000000080002f2a <iput>:
{
    80002f2a:	1101                	addi	sp,sp,-32
    80002f2c:	ec06                	sd	ra,24(sp)
    80002f2e:	e822                	sd	s0,16(sp)
    80002f30:	e426                	sd	s1,8(sp)
    80002f32:	e04a                	sd	s2,0(sp)
    80002f34:	1000                	addi	s0,sp,32
    80002f36:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f38:	00014517          	auipc	a0,0x14
    80002f3c:	19050513          	addi	a0,a0,400 # 800170c8 <itable>
    80002f40:	00003097          	auipc	ra,0x3
    80002f44:	48c080e7          	jalr	1164(ra) # 800063cc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f48:	4498                	lw	a4,8(s1)
    80002f4a:	4785                	li	a5,1
    80002f4c:	02f70363          	beq	a4,a5,80002f72 <iput+0x48>
  ip->ref--;
    80002f50:	449c                	lw	a5,8(s1)
    80002f52:	37fd                	addiw	a5,a5,-1
    80002f54:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f56:	00014517          	auipc	a0,0x14
    80002f5a:	17250513          	addi	a0,a0,370 # 800170c8 <itable>
    80002f5e:	00003097          	auipc	ra,0x3
    80002f62:	522080e7          	jalr	1314(ra) # 80006480 <release>
}
    80002f66:	60e2                	ld	ra,24(sp)
    80002f68:	6442                	ld	s0,16(sp)
    80002f6a:	64a2                	ld	s1,8(sp)
    80002f6c:	6902                	ld	s2,0(sp)
    80002f6e:	6105                	addi	sp,sp,32
    80002f70:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f72:	40bc                	lw	a5,64(s1)
    80002f74:	dff1                	beqz	a5,80002f50 <iput+0x26>
    80002f76:	04a49783          	lh	a5,74(s1)
    80002f7a:	fbf9                	bnez	a5,80002f50 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f7c:	01048913          	addi	s2,s1,16
    80002f80:	854a                	mv	a0,s2
    80002f82:	00001097          	auipc	ra,0x1
    80002f86:	aa8080e7          	jalr	-1368(ra) # 80003a2a <acquiresleep>
    release(&itable.lock);
    80002f8a:	00014517          	auipc	a0,0x14
    80002f8e:	13e50513          	addi	a0,a0,318 # 800170c8 <itable>
    80002f92:	00003097          	auipc	ra,0x3
    80002f96:	4ee080e7          	jalr	1262(ra) # 80006480 <release>
    itrunc(ip);
    80002f9a:	8526                	mv	a0,s1
    80002f9c:	00000097          	auipc	ra,0x0
    80002fa0:	ee2080e7          	jalr	-286(ra) # 80002e7e <itrunc>
    ip->type = 0;
    80002fa4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fa8:	8526                	mv	a0,s1
    80002faa:	00000097          	auipc	ra,0x0
    80002fae:	cfc080e7          	jalr	-772(ra) # 80002ca6 <iupdate>
    ip->valid = 0;
    80002fb2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fb6:	854a                	mv	a0,s2
    80002fb8:	00001097          	auipc	ra,0x1
    80002fbc:	ac8080e7          	jalr	-1336(ra) # 80003a80 <releasesleep>
    acquire(&itable.lock);
    80002fc0:	00014517          	auipc	a0,0x14
    80002fc4:	10850513          	addi	a0,a0,264 # 800170c8 <itable>
    80002fc8:	00003097          	auipc	ra,0x3
    80002fcc:	404080e7          	jalr	1028(ra) # 800063cc <acquire>
    80002fd0:	b741                	j	80002f50 <iput+0x26>

0000000080002fd2 <iunlockput>:
{
    80002fd2:	1101                	addi	sp,sp,-32
    80002fd4:	ec06                	sd	ra,24(sp)
    80002fd6:	e822                	sd	s0,16(sp)
    80002fd8:	e426                	sd	s1,8(sp)
    80002fda:	1000                	addi	s0,sp,32
    80002fdc:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fde:	00000097          	auipc	ra,0x0
    80002fe2:	e54080e7          	jalr	-428(ra) # 80002e32 <iunlock>
  iput(ip);
    80002fe6:	8526                	mv	a0,s1
    80002fe8:	00000097          	auipc	ra,0x0
    80002fec:	f42080e7          	jalr	-190(ra) # 80002f2a <iput>
}
    80002ff0:	60e2                	ld	ra,24(sp)
    80002ff2:	6442                	ld	s0,16(sp)
    80002ff4:	64a2                	ld	s1,8(sp)
    80002ff6:	6105                	addi	sp,sp,32
    80002ff8:	8082                	ret

0000000080002ffa <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ffa:	1141                	addi	sp,sp,-16
    80002ffc:	e422                	sd	s0,8(sp)
    80002ffe:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003000:	411c                	lw	a5,0(a0)
    80003002:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003004:	415c                	lw	a5,4(a0)
    80003006:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003008:	04451783          	lh	a5,68(a0)
    8000300c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003010:	04a51783          	lh	a5,74(a0)
    80003014:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003018:	04c56783          	lwu	a5,76(a0)
    8000301c:	e99c                	sd	a5,16(a1)
}
    8000301e:	6422                	ld	s0,8(sp)
    80003020:	0141                	addi	sp,sp,16
    80003022:	8082                	ret

0000000080003024 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003024:	457c                	lw	a5,76(a0)
    80003026:	0ed7e963          	bltu	a5,a3,80003118 <readi+0xf4>
{
    8000302a:	7159                	addi	sp,sp,-112
    8000302c:	f486                	sd	ra,104(sp)
    8000302e:	f0a2                	sd	s0,96(sp)
    80003030:	eca6                	sd	s1,88(sp)
    80003032:	e8ca                	sd	s2,80(sp)
    80003034:	e4ce                	sd	s3,72(sp)
    80003036:	e0d2                	sd	s4,64(sp)
    80003038:	fc56                	sd	s5,56(sp)
    8000303a:	f85a                	sd	s6,48(sp)
    8000303c:	f45e                	sd	s7,40(sp)
    8000303e:	f062                	sd	s8,32(sp)
    80003040:	ec66                	sd	s9,24(sp)
    80003042:	e86a                	sd	s10,16(sp)
    80003044:	e46e                	sd	s11,8(sp)
    80003046:	1880                	addi	s0,sp,112
    80003048:	8b2a                	mv	s6,a0
    8000304a:	8bae                	mv	s7,a1
    8000304c:	8a32                	mv	s4,a2
    8000304e:	84b6                	mv	s1,a3
    80003050:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003052:	9f35                	addw	a4,a4,a3
    return 0;
    80003054:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003056:	0ad76063          	bltu	a4,a3,800030f6 <readi+0xd2>
  if(off + n > ip->size)
    8000305a:	00e7f463          	bgeu	a5,a4,80003062 <readi+0x3e>
    n = ip->size - off;
    8000305e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003062:	0a0a8963          	beqz	s5,80003114 <readi+0xf0>
    80003066:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003068:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000306c:	5c7d                	li	s8,-1
    8000306e:	a82d                	j	800030a8 <readi+0x84>
    80003070:	020d1d93          	slli	s11,s10,0x20
    80003074:	020ddd93          	srli	s11,s11,0x20
    80003078:	05890613          	addi	a2,s2,88
    8000307c:	86ee                	mv	a3,s11
    8000307e:	963a                	add	a2,a2,a4
    80003080:	85d2                	mv	a1,s4
    80003082:	855e                	mv	a0,s7
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	a34080e7          	jalr	-1484(ra) # 80001ab8 <either_copyout>
    8000308c:	05850d63          	beq	a0,s8,800030e6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003090:	854a                	mv	a0,s2
    80003092:	fffff097          	auipc	ra,0xfffff
    80003096:	5f4080e7          	jalr	1524(ra) # 80002686 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000309a:	013d09bb          	addw	s3,s10,s3
    8000309e:	009d04bb          	addw	s1,s10,s1
    800030a2:	9a6e                	add	s4,s4,s11
    800030a4:	0559f763          	bgeu	s3,s5,800030f2 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800030a8:	00a4d59b          	srliw	a1,s1,0xa
    800030ac:	855a                	mv	a0,s6
    800030ae:	00000097          	auipc	ra,0x0
    800030b2:	8a2080e7          	jalr	-1886(ra) # 80002950 <bmap>
    800030b6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030ba:	cd85                	beqz	a1,800030f2 <readi+0xce>
    bp = bread(ip->dev, addr);
    800030bc:	000b2503          	lw	a0,0(s6)
    800030c0:	fffff097          	auipc	ra,0xfffff
    800030c4:	496080e7          	jalr	1174(ra) # 80002556 <bread>
    800030c8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ca:	3ff4f713          	andi	a4,s1,1023
    800030ce:	40ec87bb          	subw	a5,s9,a4
    800030d2:	413a86bb          	subw	a3,s5,s3
    800030d6:	8d3e                	mv	s10,a5
    800030d8:	2781                	sext.w	a5,a5
    800030da:	0006861b          	sext.w	a2,a3
    800030de:	f8f679e3          	bgeu	a2,a5,80003070 <readi+0x4c>
    800030e2:	8d36                	mv	s10,a3
    800030e4:	b771                	j	80003070 <readi+0x4c>
      brelse(bp);
    800030e6:	854a                	mv	a0,s2
    800030e8:	fffff097          	auipc	ra,0xfffff
    800030ec:	59e080e7          	jalr	1438(ra) # 80002686 <brelse>
      tot = -1;
    800030f0:	59fd                	li	s3,-1
  }
  return tot;
    800030f2:	0009851b          	sext.w	a0,s3
}
    800030f6:	70a6                	ld	ra,104(sp)
    800030f8:	7406                	ld	s0,96(sp)
    800030fa:	64e6                	ld	s1,88(sp)
    800030fc:	6946                	ld	s2,80(sp)
    800030fe:	69a6                	ld	s3,72(sp)
    80003100:	6a06                	ld	s4,64(sp)
    80003102:	7ae2                	ld	s5,56(sp)
    80003104:	7b42                	ld	s6,48(sp)
    80003106:	7ba2                	ld	s7,40(sp)
    80003108:	7c02                	ld	s8,32(sp)
    8000310a:	6ce2                	ld	s9,24(sp)
    8000310c:	6d42                	ld	s10,16(sp)
    8000310e:	6da2                	ld	s11,8(sp)
    80003110:	6165                	addi	sp,sp,112
    80003112:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003114:	89d6                	mv	s3,s5
    80003116:	bff1                	j	800030f2 <readi+0xce>
    return 0;
    80003118:	4501                	li	a0,0
}
    8000311a:	8082                	ret

000000008000311c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000311c:	457c                	lw	a5,76(a0)
    8000311e:	10d7e863          	bltu	a5,a3,8000322e <writei+0x112>
{
    80003122:	7159                	addi	sp,sp,-112
    80003124:	f486                	sd	ra,104(sp)
    80003126:	f0a2                	sd	s0,96(sp)
    80003128:	eca6                	sd	s1,88(sp)
    8000312a:	e8ca                	sd	s2,80(sp)
    8000312c:	e4ce                	sd	s3,72(sp)
    8000312e:	e0d2                	sd	s4,64(sp)
    80003130:	fc56                	sd	s5,56(sp)
    80003132:	f85a                	sd	s6,48(sp)
    80003134:	f45e                	sd	s7,40(sp)
    80003136:	f062                	sd	s8,32(sp)
    80003138:	ec66                	sd	s9,24(sp)
    8000313a:	e86a                	sd	s10,16(sp)
    8000313c:	e46e                	sd	s11,8(sp)
    8000313e:	1880                	addi	s0,sp,112
    80003140:	8aaa                	mv	s5,a0
    80003142:	8bae                	mv	s7,a1
    80003144:	8a32                	mv	s4,a2
    80003146:	8936                	mv	s2,a3
    80003148:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000314a:	00e687bb          	addw	a5,a3,a4
    8000314e:	0ed7e263          	bltu	a5,a3,80003232 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003152:	00043737          	lui	a4,0x43
    80003156:	0ef76063          	bltu	a4,a5,80003236 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000315a:	0c0b0863          	beqz	s6,8000322a <writei+0x10e>
    8000315e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003160:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003164:	5c7d                	li	s8,-1
    80003166:	a091                	j	800031aa <writei+0x8e>
    80003168:	020d1d93          	slli	s11,s10,0x20
    8000316c:	020ddd93          	srli	s11,s11,0x20
    80003170:	05848513          	addi	a0,s1,88
    80003174:	86ee                	mv	a3,s11
    80003176:	8652                	mv	a2,s4
    80003178:	85de                	mv	a1,s7
    8000317a:	953a                	add	a0,a0,a4
    8000317c:	fffff097          	auipc	ra,0xfffff
    80003180:	992080e7          	jalr	-1646(ra) # 80001b0e <either_copyin>
    80003184:	07850263          	beq	a0,s8,800031e8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003188:	8526                	mv	a0,s1
    8000318a:	00000097          	auipc	ra,0x0
    8000318e:	780080e7          	jalr	1920(ra) # 8000390a <log_write>
    brelse(bp);
    80003192:	8526                	mv	a0,s1
    80003194:	fffff097          	auipc	ra,0xfffff
    80003198:	4f2080e7          	jalr	1266(ra) # 80002686 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000319c:	013d09bb          	addw	s3,s10,s3
    800031a0:	012d093b          	addw	s2,s10,s2
    800031a4:	9a6e                	add	s4,s4,s11
    800031a6:	0569f663          	bgeu	s3,s6,800031f2 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800031aa:	00a9559b          	srliw	a1,s2,0xa
    800031ae:	8556                	mv	a0,s5
    800031b0:	fffff097          	auipc	ra,0xfffff
    800031b4:	7a0080e7          	jalr	1952(ra) # 80002950 <bmap>
    800031b8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031bc:	c99d                	beqz	a1,800031f2 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800031be:	000aa503          	lw	a0,0(s5)
    800031c2:	fffff097          	auipc	ra,0xfffff
    800031c6:	394080e7          	jalr	916(ra) # 80002556 <bread>
    800031ca:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031cc:	3ff97713          	andi	a4,s2,1023
    800031d0:	40ec87bb          	subw	a5,s9,a4
    800031d4:	413b06bb          	subw	a3,s6,s3
    800031d8:	8d3e                	mv	s10,a5
    800031da:	2781                	sext.w	a5,a5
    800031dc:	0006861b          	sext.w	a2,a3
    800031e0:	f8f674e3          	bgeu	a2,a5,80003168 <writei+0x4c>
    800031e4:	8d36                	mv	s10,a3
    800031e6:	b749                	j	80003168 <writei+0x4c>
      brelse(bp);
    800031e8:	8526                	mv	a0,s1
    800031ea:	fffff097          	auipc	ra,0xfffff
    800031ee:	49c080e7          	jalr	1180(ra) # 80002686 <brelse>
  }

  if(off > ip->size)
    800031f2:	04caa783          	lw	a5,76(s5)
    800031f6:	0127f463          	bgeu	a5,s2,800031fe <writei+0xe2>
    ip->size = off;
    800031fa:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031fe:	8556                	mv	a0,s5
    80003200:	00000097          	auipc	ra,0x0
    80003204:	aa6080e7          	jalr	-1370(ra) # 80002ca6 <iupdate>

  return tot;
    80003208:	0009851b          	sext.w	a0,s3
}
    8000320c:	70a6                	ld	ra,104(sp)
    8000320e:	7406                	ld	s0,96(sp)
    80003210:	64e6                	ld	s1,88(sp)
    80003212:	6946                	ld	s2,80(sp)
    80003214:	69a6                	ld	s3,72(sp)
    80003216:	6a06                	ld	s4,64(sp)
    80003218:	7ae2                	ld	s5,56(sp)
    8000321a:	7b42                	ld	s6,48(sp)
    8000321c:	7ba2                	ld	s7,40(sp)
    8000321e:	7c02                	ld	s8,32(sp)
    80003220:	6ce2                	ld	s9,24(sp)
    80003222:	6d42                	ld	s10,16(sp)
    80003224:	6da2                	ld	s11,8(sp)
    80003226:	6165                	addi	sp,sp,112
    80003228:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000322a:	89da                	mv	s3,s6
    8000322c:	bfc9                	j	800031fe <writei+0xe2>
    return -1;
    8000322e:	557d                	li	a0,-1
}
    80003230:	8082                	ret
    return -1;
    80003232:	557d                	li	a0,-1
    80003234:	bfe1                	j	8000320c <writei+0xf0>
    return -1;
    80003236:	557d                	li	a0,-1
    80003238:	bfd1                	j	8000320c <writei+0xf0>

000000008000323a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000323a:	1141                	addi	sp,sp,-16
    8000323c:	e406                	sd	ra,8(sp)
    8000323e:	e022                	sd	s0,0(sp)
    80003240:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003242:	4639                	li	a2,14
    80003244:	ffffd097          	auipc	ra,0xffffd
    80003248:	00c080e7          	jalr	12(ra) # 80000250 <strncmp>
}
    8000324c:	60a2                	ld	ra,8(sp)
    8000324e:	6402                	ld	s0,0(sp)
    80003250:	0141                	addi	sp,sp,16
    80003252:	8082                	ret

0000000080003254 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003254:	7139                	addi	sp,sp,-64
    80003256:	fc06                	sd	ra,56(sp)
    80003258:	f822                	sd	s0,48(sp)
    8000325a:	f426                	sd	s1,40(sp)
    8000325c:	f04a                	sd	s2,32(sp)
    8000325e:	ec4e                	sd	s3,24(sp)
    80003260:	e852                	sd	s4,16(sp)
    80003262:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003264:	04451703          	lh	a4,68(a0)
    80003268:	4785                	li	a5,1
    8000326a:	00f71a63          	bne	a4,a5,8000327e <dirlookup+0x2a>
    8000326e:	892a                	mv	s2,a0
    80003270:	89ae                	mv	s3,a1
    80003272:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003274:	457c                	lw	a5,76(a0)
    80003276:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003278:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000327a:	e79d                	bnez	a5,800032a8 <dirlookup+0x54>
    8000327c:	a8a5                	j	800032f4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000327e:	00005517          	auipc	a0,0x5
    80003282:	39250513          	addi	a0,a0,914 # 80008610 <syscalls+0x1f8>
    80003286:	00003097          	auipc	ra,0x3
    8000328a:	bfc080e7          	jalr	-1028(ra) # 80005e82 <panic>
      panic("dirlookup read");
    8000328e:	00005517          	auipc	a0,0x5
    80003292:	39a50513          	addi	a0,a0,922 # 80008628 <syscalls+0x210>
    80003296:	00003097          	auipc	ra,0x3
    8000329a:	bec080e7          	jalr	-1044(ra) # 80005e82 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000329e:	24c1                	addiw	s1,s1,16
    800032a0:	04c92783          	lw	a5,76(s2)
    800032a4:	04f4f763          	bgeu	s1,a5,800032f2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032a8:	4741                	li	a4,16
    800032aa:	86a6                	mv	a3,s1
    800032ac:	fc040613          	addi	a2,s0,-64
    800032b0:	4581                	li	a1,0
    800032b2:	854a                	mv	a0,s2
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	d70080e7          	jalr	-656(ra) # 80003024 <readi>
    800032bc:	47c1                	li	a5,16
    800032be:	fcf518e3          	bne	a0,a5,8000328e <dirlookup+0x3a>
    if(de.inum == 0)
    800032c2:	fc045783          	lhu	a5,-64(s0)
    800032c6:	dfe1                	beqz	a5,8000329e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032c8:	fc240593          	addi	a1,s0,-62
    800032cc:	854e                	mv	a0,s3
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	f6c080e7          	jalr	-148(ra) # 8000323a <namecmp>
    800032d6:	f561                	bnez	a0,8000329e <dirlookup+0x4a>
      if(poff)
    800032d8:	000a0463          	beqz	s4,800032e0 <dirlookup+0x8c>
        *poff = off;
    800032dc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032e0:	fc045583          	lhu	a1,-64(s0)
    800032e4:	00092503          	lw	a0,0(s2)
    800032e8:	fffff097          	auipc	ra,0xfffff
    800032ec:	750080e7          	jalr	1872(ra) # 80002a38 <iget>
    800032f0:	a011                	j	800032f4 <dirlookup+0xa0>
  return 0;
    800032f2:	4501                	li	a0,0
}
    800032f4:	70e2                	ld	ra,56(sp)
    800032f6:	7442                	ld	s0,48(sp)
    800032f8:	74a2                	ld	s1,40(sp)
    800032fa:	7902                	ld	s2,32(sp)
    800032fc:	69e2                	ld	s3,24(sp)
    800032fe:	6a42                	ld	s4,16(sp)
    80003300:	6121                	addi	sp,sp,64
    80003302:	8082                	ret

0000000080003304 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003304:	711d                	addi	sp,sp,-96
    80003306:	ec86                	sd	ra,88(sp)
    80003308:	e8a2                	sd	s0,80(sp)
    8000330a:	e4a6                	sd	s1,72(sp)
    8000330c:	e0ca                	sd	s2,64(sp)
    8000330e:	fc4e                	sd	s3,56(sp)
    80003310:	f852                	sd	s4,48(sp)
    80003312:	f456                	sd	s5,40(sp)
    80003314:	f05a                	sd	s6,32(sp)
    80003316:	ec5e                	sd	s7,24(sp)
    80003318:	e862                	sd	s8,16(sp)
    8000331a:	e466                	sd	s9,8(sp)
    8000331c:	1080                	addi	s0,sp,96
    8000331e:	84aa                	mv	s1,a0
    80003320:	8b2e                	mv	s6,a1
    80003322:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003324:	00054703          	lbu	a4,0(a0)
    80003328:	02f00793          	li	a5,47
    8000332c:	02f70363          	beq	a4,a5,80003352 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003330:	ffffe097          	auipc	ra,0xffffe
    80003334:	c42080e7          	jalr	-958(ra) # 80000f72 <myproc>
    80003338:	15053503          	ld	a0,336(a0)
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	9f6080e7          	jalr	-1546(ra) # 80002d32 <idup>
    80003344:	89aa                	mv	s3,a0
  while(*path == '/')
    80003346:	02f00913          	li	s2,47
  len = path - s;
    8000334a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000334c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000334e:	4c05                	li	s8,1
    80003350:	a865                	j	80003408 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003352:	4585                	li	a1,1
    80003354:	4505                	li	a0,1
    80003356:	fffff097          	auipc	ra,0xfffff
    8000335a:	6e2080e7          	jalr	1762(ra) # 80002a38 <iget>
    8000335e:	89aa                	mv	s3,a0
    80003360:	b7dd                	j	80003346 <namex+0x42>
      iunlockput(ip);
    80003362:	854e                	mv	a0,s3
    80003364:	00000097          	auipc	ra,0x0
    80003368:	c6e080e7          	jalr	-914(ra) # 80002fd2 <iunlockput>
      return 0;
    8000336c:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000336e:	854e                	mv	a0,s3
    80003370:	60e6                	ld	ra,88(sp)
    80003372:	6446                	ld	s0,80(sp)
    80003374:	64a6                	ld	s1,72(sp)
    80003376:	6906                	ld	s2,64(sp)
    80003378:	79e2                	ld	s3,56(sp)
    8000337a:	7a42                	ld	s4,48(sp)
    8000337c:	7aa2                	ld	s5,40(sp)
    8000337e:	7b02                	ld	s6,32(sp)
    80003380:	6be2                	ld	s7,24(sp)
    80003382:	6c42                	ld	s8,16(sp)
    80003384:	6ca2                	ld	s9,8(sp)
    80003386:	6125                	addi	sp,sp,96
    80003388:	8082                	ret
      iunlock(ip);
    8000338a:	854e                	mv	a0,s3
    8000338c:	00000097          	auipc	ra,0x0
    80003390:	aa6080e7          	jalr	-1370(ra) # 80002e32 <iunlock>
      return ip;
    80003394:	bfe9                	j	8000336e <namex+0x6a>
      iunlockput(ip);
    80003396:	854e                	mv	a0,s3
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	c3a080e7          	jalr	-966(ra) # 80002fd2 <iunlockput>
      return 0;
    800033a0:	89d2                	mv	s3,s4
    800033a2:	b7f1                	j	8000336e <namex+0x6a>
  len = path - s;
    800033a4:	40b48633          	sub	a2,s1,a1
    800033a8:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800033ac:	094cd463          	bge	s9,s4,80003434 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033b0:	4639                	li	a2,14
    800033b2:	8556                	mv	a0,s5
    800033b4:	ffffd097          	auipc	ra,0xffffd
    800033b8:	e24080e7          	jalr	-476(ra) # 800001d8 <memmove>
  while(*path == '/')
    800033bc:	0004c783          	lbu	a5,0(s1)
    800033c0:	01279763          	bne	a5,s2,800033ce <namex+0xca>
    path++;
    800033c4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033c6:	0004c783          	lbu	a5,0(s1)
    800033ca:	ff278de3          	beq	a5,s2,800033c4 <namex+0xc0>
    ilock(ip);
    800033ce:	854e                	mv	a0,s3
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	9a0080e7          	jalr	-1632(ra) # 80002d70 <ilock>
    if(ip->type != T_DIR){
    800033d8:	04499783          	lh	a5,68(s3)
    800033dc:	f98793e3          	bne	a5,s8,80003362 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033e0:	000b0563          	beqz	s6,800033ea <namex+0xe6>
    800033e4:	0004c783          	lbu	a5,0(s1)
    800033e8:	d3cd                	beqz	a5,8000338a <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033ea:	865e                	mv	a2,s7
    800033ec:	85d6                	mv	a1,s5
    800033ee:	854e                	mv	a0,s3
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	e64080e7          	jalr	-412(ra) # 80003254 <dirlookup>
    800033f8:	8a2a                	mv	s4,a0
    800033fa:	dd51                	beqz	a0,80003396 <namex+0x92>
    iunlockput(ip);
    800033fc:	854e                	mv	a0,s3
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	bd4080e7          	jalr	-1068(ra) # 80002fd2 <iunlockput>
    ip = next;
    80003406:	89d2                	mv	s3,s4
  while(*path == '/')
    80003408:	0004c783          	lbu	a5,0(s1)
    8000340c:	05279763          	bne	a5,s2,8000345a <namex+0x156>
    path++;
    80003410:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003412:	0004c783          	lbu	a5,0(s1)
    80003416:	ff278de3          	beq	a5,s2,80003410 <namex+0x10c>
  if(*path == 0)
    8000341a:	c79d                	beqz	a5,80003448 <namex+0x144>
    path++;
    8000341c:	85a6                	mv	a1,s1
  len = path - s;
    8000341e:	8a5e                	mv	s4,s7
    80003420:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003422:	01278963          	beq	a5,s2,80003434 <namex+0x130>
    80003426:	dfbd                	beqz	a5,800033a4 <namex+0xa0>
    path++;
    80003428:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000342a:	0004c783          	lbu	a5,0(s1)
    8000342e:	ff279ce3          	bne	a5,s2,80003426 <namex+0x122>
    80003432:	bf8d                	j	800033a4 <namex+0xa0>
    memmove(name, s, len);
    80003434:	2601                	sext.w	a2,a2
    80003436:	8556                	mv	a0,s5
    80003438:	ffffd097          	auipc	ra,0xffffd
    8000343c:	da0080e7          	jalr	-608(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003440:	9a56                	add	s4,s4,s5
    80003442:	000a0023          	sb	zero,0(s4)
    80003446:	bf9d                	j	800033bc <namex+0xb8>
  if(nameiparent){
    80003448:	f20b03e3          	beqz	s6,8000336e <namex+0x6a>
    iput(ip);
    8000344c:	854e                	mv	a0,s3
    8000344e:	00000097          	auipc	ra,0x0
    80003452:	adc080e7          	jalr	-1316(ra) # 80002f2a <iput>
    return 0;
    80003456:	4981                	li	s3,0
    80003458:	bf19                	j	8000336e <namex+0x6a>
  if(*path == 0)
    8000345a:	d7fd                	beqz	a5,80003448 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000345c:	0004c783          	lbu	a5,0(s1)
    80003460:	85a6                	mv	a1,s1
    80003462:	b7d1                	j	80003426 <namex+0x122>

0000000080003464 <dirlink>:
{
    80003464:	7139                	addi	sp,sp,-64
    80003466:	fc06                	sd	ra,56(sp)
    80003468:	f822                	sd	s0,48(sp)
    8000346a:	f426                	sd	s1,40(sp)
    8000346c:	f04a                	sd	s2,32(sp)
    8000346e:	ec4e                	sd	s3,24(sp)
    80003470:	e852                	sd	s4,16(sp)
    80003472:	0080                	addi	s0,sp,64
    80003474:	892a                	mv	s2,a0
    80003476:	8a2e                	mv	s4,a1
    80003478:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000347a:	4601                	li	a2,0
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	dd8080e7          	jalr	-552(ra) # 80003254 <dirlookup>
    80003484:	e93d                	bnez	a0,800034fa <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003486:	04c92483          	lw	s1,76(s2)
    8000348a:	c49d                	beqz	s1,800034b8 <dirlink+0x54>
    8000348c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000348e:	4741                	li	a4,16
    80003490:	86a6                	mv	a3,s1
    80003492:	fc040613          	addi	a2,s0,-64
    80003496:	4581                	li	a1,0
    80003498:	854a                	mv	a0,s2
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	b8a080e7          	jalr	-1142(ra) # 80003024 <readi>
    800034a2:	47c1                	li	a5,16
    800034a4:	06f51163          	bne	a0,a5,80003506 <dirlink+0xa2>
    if(de.inum == 0)
    800034a8:	fc045783          	lhu	a5,-64(s0)
    800034ac:	c791                	beqz	a5,800034b8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034ae:	24c1                	addiw	s1,s1,16
    800034b0:	04c92783          	lw	a5,76(s2)
    800034b4:	fcf4ede3          	bltu	s1,a5,8000348e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034b8:	4639                	li	a2,14
    800034ba:	85d2                	mv	a1,s4
    800034bc:	fc240513          	addi	a0,s0,-62
    800034c0:	ffffd097          	auipc	ra,0xffffd
    800034c4:	dcc080e7          	jalr	-564(ra) # 8000028c <strncpy>
  de.inum = inum;
    800034c8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034cc:	4741                	li	a4,16
    800034ce:	86a6                	mv	a3,s1
    800034d0:	fc040613          	addi	a2,s0,-64
    800034d4:	4581                	li	a1,0
    800034d6:	854a                	mv	a0,s2
    800034d8:	00000097          	auipc	ra,0x0
    800034dc:	c44080e7          	jalr	-956(ra) # 8000311c <writei>
    800034e0:	1541                	addi	a0,a0,-16
    800034e2:	00a03533          	snez	a0,a0
    800034e6:	40a00533          	neg	a0,a0
}
    800034ea:	70e2                	ld	ra,56(sp)
    800034ec:	7442                	ld	s0,48(sp)
    800034ee:	74a2                	ld	s1,40(sp)
    800034f0:	7902                	ld	s2,32(sp)
    800034f2:	69e2                	ld	s3,24(sp)
    800034f4:	6a42                	ld	s4,16(sp)
    800034f6:	6121                	addi	sp,sp,64
    800034f8:	8082                	ret
    iput(ip);
    800034fa:	00000097          	auipc	ra,0x0
    800034fe:	a30080e7          	jalr	-1488(ra) # 80002f2a <iput>
    return -1;
    80003502:	557d                	li	a0,-1
    80003504:	b7dd                	j	800034ea <dirlink+0x86>
      panic("dirlink read");
    80003506:	00005517          	auipc	a0,0x5
    8000350a:	13250513          	addi	a0,a0,306 # 80008638 <syscalls+0x220>
    8000350e:	00003097          	auipc	ra,0x3
    80003512:	974080e7          	jalr	-1676(ra) # 80005e82 <panic>

0000000080003516 <namei>:

struct inode*
namei(char *path)
{
    80003516:	1101                	addi	sp,sp,-32
    80003518:	ec06                	sd	ra,24(sp)
    8000351a:	e822                	sd	s0,16(sp)
    8000351c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000351e:	fe040613          	addi	a2,s0,-32
    80003522:	4581                	li	a1,0
    80003524:	00000097          	auipc	ra,0x0
    80003528:	de0080e7          	jalr	-544(ra) # 80003304 <namex>
}
    8000352c:	60e2                	ld	ra,24(sp)
    8000352e:	6442                	ld	s0,16(sp)
    80003530:	6105                	addi	sp,sp,32
    80003532:	8082                	ret

0000000080003534 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003534:	1141                	addi	sp,sp,-16
    80003536:	e406                	sd	ra,8(sp)
    80003538:	e022                	sd	s0,0(sp)
    8000353a:	0800                	addi	s0,sp,16
    8000353c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000353e:	4585                	li	a1,1
    80003540:	00000097          	auipc	ra,0x0
    80003544:	dc4080e7          	jalr	-572(ra) # 80003304 <namex>
}
    80003548:	60a2                	ld	ra,8(sp)
    8000354a:	6402                	ld	s0,0(sp)
    8000354c:	0141                	addi	sp,sp,16
    8000354e:	8082                	ret

0000000080003550 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003550:	1101                	addi	sp,sp,-32
    80003552:	ec06                	sd	ra,24(sp)
    80003554:	e822                	sd	s0,16(sp)
    80003556:	e426                	sd	s1,8(sp)
    80003558:	e04a                	sd	s2,0(sp)
    8000355a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000355c:	00015917          	auipc	s2,0x15
    80003560:	61490913          	addi	s2,s2,1556 # 80018b70 <log>
    80003564:	01892583          	lw	a1,24(s2)
    80003568:	02892503          	lw	a0,40(s2)
    8000356c:	fffff097          	auipc	ra,0xfffff
    80003570:	fea080e7          	jalr	-22(ra) # 80002556 <bread>
    80003574:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003576:	02c92683          	lw	a3,44(s2)
    8000357a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000357c:	02d05763          	blez	a3,800035aa <write_head+0x5a>
    80003580:	00015797          	auipc	a5,0x15
    80003584:	62078793          	addi	a5,a5,1568 # 80018ba0 <log+0x30>
    80003588:	05c50713          	addi	a4,a0,92
    8000358c:	36fd                	addiw	a3,a3,-1
    8000358e:	1682                	slli	a3,a3,0x20
    80003590:	9281                	srli	a3,a3,0x20
    80003592:	068a                	slli	a3,a3,0x2
    80003594:	00015617          	auipc	a2,0x15
    80003598:	61060613          	addi	a2,a2,1552 # 80018ba4 <log+0x34>
    8000359c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000359e:	4390                	lw	a2,0(a5)
    800035a0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035a2:	0791                	addi	a5,a5,4
    800035a4:	0711                	addi	a4,a4,4
    800035a6:	fed79ce3          	bne	a5,a3,8000359e <write_head+0x4e>
  }
  bwrite(buf);
    800035aa:	8526                	mv	a0,s1
    800035ac:	fffff097          	auipc	ra,0xfffff
    800035b0:	09c080e7          	jalr	156(ra) # 80002648 <bwrite>
  brelse(buf);
    800035b4:	8526                	mv	a0,s1
    800035b6:	fffff097          	auipc	ra,0xfffff
    800035ba:	0d0080e7          	jalr	208(ra) # 80002686 <brelse>
}
    800035be:	60e2                	ld	ra,24(sp)
    800035c0:	6442                	ld	s0,16(sp)
    800035c2:	64a2                	ld	s1,8(sp)
    800035c4:	6902                	ld	s2,0(sp)
    800035c6:	6105                	addi	sp,sp,32
    800035c8:	8082                	ret

00000000800035ca <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ca:	00015797          	auipc	a5,0x15
    800035ce:	5d27a783          	lw	a5,1490(a5) # 80018b9c <log+0x2c>
    800035d2:	0af05d63          	blez	a5,8000368c <install_trans+0xc2>
{
    800035d6:	7139                	addi	sp,sp,-64
    800035d8:	fc06                	sd	ra,56(sp)
    800035da:	f822                	sd	s0,48(sp)
    800035dc:	f426                	sd	s1,40(sp)
    800035de:	f04a                	sd	s2,32(sp)
    800035e0:	ec4e                	sd	s3,24(sp)
    800035e2:	e852                	sd	s4,16(sp)
    800035e4:	e456                	sd	s5,8(sp)
    800035e6:	e05a                	sd	s6,0(sp)
    800035e8:	0080                	addi	s0,sp,64
    800035ea:	8b2a                	mv	s6,a0
    800035ec:	00015a97          	auipc	s5,0x15
    800035f0:	5b4a8a93          	addi	s5,s5,1460 # 80018ba0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035f6:	00015997          	auipc	s3,0x15
    800035fa:	57a98993          	addi	s3,s3,1402 # 80018b70 <log>
    800035fe:	a035                	j	8000362a <install_trans+0x60>
      bunpin(dbuf);
    80003600:	8526                	mv	a0,s1
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	15e080e7          	jalr	350(ra) # 80002760 <bunpin>
    brelse(lbuf);
    8000360a:	854a                	mv	a0,s2
    8000360c:	fffff097          	auipc	ra,0xfffff
    80003610:	07a080e7          	jalr	122(ra) # 80002686 <brelse>
    brelse(dbuf);
    80003614:	8526                	mv	a0,s1
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	070080e7          	jalr	112(ra) # 80002686 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000361e:	2a05                	addiw	s4,s4,1
    80003620:	0a91                	addi	s5,s5,4
    80003622:	02c9a783          	lw	a5,44(s3)
    80003626:	04fa5963          	bge	s4,a5,80003678 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000362a:	0189a583          	lw	a1,24(s3)
    8000362e:	014585bb          	addw	a1,a1,s4
    80003632:	2585                	addiw	a1,a1,1
    80003634:	0289a503          	lw	a0,40(s3)
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	f1e080e7          	jalr	-226(ra) # 80002556 <bread>
    80003640:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003642:	000aa583          	lw	a1,0(s5)
    80003646:	0289a503          	lw	a0,40(s3)
    8000364a:	fffff097          	auipc	ra,0xfffff
    8000364e:	f0c080e7          	jalr	-244(ra) # 80002556 <bread>
    80003652:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003654:	40000613          	li	a2,1024
    80003658:	05890593          	addi	a1,s2,88
    8000365c:	05850513          	addi	a0,a0,88
    80003660:	ffffd097          	auipc	ra,0xffffd
    80003664:	b78080e7          	jalr	-1160(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003668:	8526                	mv	a0,s1
    8000366a:	fffff097          	auipc	ra,0xfffff
    8000366e:	fde080e7          	jalr	-34(ra) # 80002648 <bwrite>
    if(recovering == 0)
    80003672:	f80b1ce3          	bnez	s6,8000360a <install_trans+0x40>
    80003676:	b769                	j	80003600 <install_trans+0x36>
}
    80003678:	70e2                	ld	ra,56(sp)
    8000367a:	7442                	ld	s0,48(sp)
    8000367c:	74a2                	ld	s1,40(sp)
    8000367e:	7902                	ld	s2,32(sp)
    80003680:	69e2                	ld	s3,24(sp)
    80003682:	6a42                	ld	s4,16(sp)
    80003684:	6aa2                	ld	s5,8(sp)
    80003686:	6b02                	ld	s6,0(sp)
    80003688:	6121                	addi	sp,sp,64
    8000368a:	8082                	ret
    8000368c:	8082                	ret

000000008000368e <initlog>:
{
    8000368e:	7179                	addi	sp,sp,-48
    80003690:	f406                	sd	ra,40(sp)
    80003692:	f022                	sd	s0,32(sp)
    80003694:	ec26                	sd	s1,24(sp)
    80003696:	e84a                	sd	s2,16(sp)
    80003698:	e44e                	sd	s3,8(sp)
    8000369a:	1800                	addi	s0,sp,48
    8000369c:	892a                	mv	s2,a0
    8000369e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036a0:	00015497          	auipc	s1,0x15
    800036a4:	4d048493          	addi	s1,s1,1232 # 80018b70 <log>
    800036a8:	00005597          	auipc	a1,0x5
    800036ac:	fa058593          	addi	a1,a1,-96 # 80008648 <syscalls+0x230>
    800036b0:	8526                	mv	a0,s1
    800036b2:	00003097          	auipc	ra,0x3
    800036b6:	c8a080e7          	jalr	-886(ra) # 8000633c <initlock>
  log.start = sb->logstart;
    800036ba:	0149a583          	lw	a1,20(s3)
    800036be:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036c0:	0109a783          	lw	a5,16(s3)
    800036c4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036c6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036ca:	854a                	mv	a0,s2
    800036cc:	fffff097          	auipc	ra,0xfffff
    800036d0:	e8a080e7          	jalr	-374(ra) # 80002556 <bread>
  log.lh.n = lh->n;
    800036d4:	4d3c                	lw	a5,88(a0)
    800036d6:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036d8:	02f05563          	blez	a5,80003702 <initlog+0x74>
    800036dc:	05c50713          	addi	a4,a0,92
    800036e0:	00015697          	auipc	a3,0x15
    800036e4:	4c068693          	addi	a3,a3,1216 # 80018ba0 <log+0x30>
    800036e8:	37fd                	addiw	a5,a5,-1
    800036ea:	1782                	slli	a5,a5,0x20
    800036ec:	9381                	srli	a5,a5,0x20
    800036ee:	078a                	slli	a5,a5,0x2
    800036f0:	06050613          	addi	a2,a0,96
    800036f4:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036f6:	4310                	lw	a2,0(a4)
    800036f8:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036fa:	0711                	addi	a4,a4,4
    800036fc:	0691                	addi	a3,a3,4
    800036fe:	fef71ce3          	bne	a4,a5,800036f6 <initlog+0x68>
  brelse(buf);
    80003702:	fffff097          	auipc	ra,0xfffff
    80003706:	f84080e7          	jalr	-124(ra) # 80002686 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000370a:	4505                	li	a0,1
    8000370c:	00000097          	auipc	ra,0x0
    80003710:	ebe080e7          	jalr	-322(ra) # 800035ca <install_trans>
  log.lh.n = 0;
    80003714:	00015797          	auipc	a5,0x15
    80003718:	4807a423          	sw	zero,1160(a5) # 80018b9c <log+0x2c>
  write_head(); // clear the log
    8000371c:	00000097          	auipc	ra,0x0
    80003720:	e34080e7          	jalr	-460(ra) # 80003550 <write_head>
}
    80003724:	70a2                	ld	ra,40(sp)
    80003726:	7402                	ld	s0,32(sp)
    80003728:	64e2                	ld	s1,24(sp)
    8000372a:	6942                	ld	s2,16(sp)
    8000372c:	69a2                	ld	s3,8(sp)
    8000372e:	6145                	addi	sp,sp,48
    80003730:	8082                	ret

0000000080003732 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003732:	1101                	addi	sp,sp,-32
    80003734:	ec06                	sd	ra,24(sp)
    80003736:	e822                	sd	s0,16(sp)
    80003738:	e426                	sd	s1,8(sp)
    8000373a:	e04a                	sd	s2,0(sp)
    8000373c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000373e:	00015517          	auipc	a0,0x15
    80003742:	43250513          	addi	a0,a0,1074 # 80018b70 <log>
    80003746:	00003097          	auipc	ra,0x3
    8000374a:	c86080e7          	jalr	-890(ra) # 800063cc <acquire>
  while(1){
    if(log.committing){
    8000374e:	00015497          	auipc	s1,0x15
    80003752:	42248493          	addi	s1,s1,1058 # 80018b70 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003756:	4979                	li	s2,30
    80003758:	a039                	j	80003766 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000375a:	85a6                	mv	a1,s1
    8000375c:	8526                	mv	a0,s1
    8000375e:	ffffe097          	auipc	ra,0xffffe
    80003762:	f52080e7          	jalr	-174(ra) # 800016b0 <sleep>
    if(log.committing){
    80003766:	50dc                	lw	a5,36(s1)
    80003768:	fbed                	bnez	a5,8000375a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000376a:	509c                	lw	a5,32(s1)
    8000376c:	0017871b          	addiw	a4,a5,1
    80003770:	0007069b          	sext.w	a3,a4
    80003774:	0027179b          	slliw	a5,a4,0x2
    80003778:	9fb9                	addw	a5,a5,a4
    8000377a:	0017979b          	slliw	a5,a5,0x1
    8000377e:	54d8                	lw	a4,44(s1)
    80003780:	9fb9                	addw	a5,a5,a4
    80003782:	00f95963          	bge	s2,a5,80003794 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003786:	85a6                	mv	a1,s1
    80003788:	8526                	mv	a0,s1
    8000378a:	ffffe097          	auipc	ra,0xffffe
    8000378e:	f26080e7          	jalr	-218(ra) # 800016b0 <sleep>
    80003792:	bfd1                	j	80003766 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003794:	00015517          	auipc	a0,0x15
    80003798:	3dc50513          	addi	a0,a0,988 # 80018b70 <log>
    8000379c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000379e:	00003097          	auipc	ra,0x3
    800037a2:	ce2080e7          	jalr	-798(ra) # 80006480 <release>
      break;
    }
  }
}
    800037a6:	60e2                	ld	ra,24(sp)
    800037a8:	6442                	ld	s0,16(sp)
    800037aa:	64a2                	ld	s1,8(sp)
    800037ac:	6902                	ld	s2,0(sp)
    800037ae:	6105                	addi	sp,sp,32
    800037b0:	8082                	ret

00000000800037b2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037b2:	7139                	addi	sp,sp,-64
    800037b4:	fc06                	sd	ra,56(sp)
    800037b6:	f822                	sd	s0,48(sp)
    800037b8:	f426                	sd	s1,40(sp)
    800037ba:	f04a                	sd	s2,32(sp)
    800037bc:	ec4e                	sd	s3,24(sp)
    800037be:	e852                	sd	s4,16(sp)
    800037c0:	e456                	sd	s5,8(sp)
    800037c2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037c4:	00015497          	auipc	s1,0x15
    800037c8:	3ac48493          	addi	s1,s1,940 # 80018b70 <log>
    800037cc:	8526                	mv	a0,s1
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	bfe080e7          	jalr	-1026(ra) # 800063cc <acquire>
  log.outstanding -= 1;
    800037d6:	509c                	lw	a5,32(s1)
    800037d8:	37fd                	addiw	a5,a5,-1
    800037da:	0007891b          	sext.w	s2,a5
    800037de:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037e0:	50dc                	lw	a5,36(s1)
    800037e2:	efb9                	bnez	a5,80003840 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037e4:	06091663          	bnez	s2,80003850 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800037e8:	00015497          	auipc	s1,0x15
    800037ec:	38848493          	addi	s1,s1,904 # 80018b70 <log>
    800037f0:	4785                	li	a5,1
    800037f2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037f4:	8526                	mv	a0,s1
    800037f6:	00003097          	auipc	ra,0x3
    800037fa:	c8a080e7          	jalr	-886(ra) # 80006480 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037fe:	54dc                	lw	a5,44(s1)
    80003800:	06f04763          	bgtz	a5,8000386e <end_op+0xbc>
    acquire(&log.lock);
    80003804:	00015497          	auipc	s1,0x15
    80003808:	36c48493          	addi	s1,s1,876 # 80018b70 <log>
    8000380c:	8526                	mv	a0,s1
    8000380e:	00003097          	auipc	ra,0x3
    80003812:	bbe080e7          	jalr	-1090(ra) # 800063cc <acquire>
    log.committing = 0;
    80003816:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000381a:	8526                	mv	a0,s1
    8000381c:	ffffe097          	auipc	ra,0xffffe
    80003820:	ef8080e7          	jalr	-264(ra) # 80001714 <wakeup>
    release(&log.lock);
    80003824:	8526                	mv	a0,s1
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	c5a080e7          	jalr	-934(ra) # 80006480 <release>
}
    8000382e:	70e2                	ld	ra,56(sp)
    80003830:	7442                	ld	s0,48(sp)
    80003832:	74a2                	ld	s1,40(sp)
    80003834:	7902                	ld	s2,32(sp)
    80003836:	69e2                	ld	s3,24(sp)
    80003838:	6a42                	ld	s4,16(sp)
    8000383a:	6aa2                	ld	s5,8(sp)
    8000383c:	6121                	addi	sp,sp,64
    8000383e:	8082                	ret
    panic("log.committing");
    80003840:	00005517          	auipc	a0,0x5
    80003844:	e1050513          	addi	a0,a0,-496 # 80008650 <syscalls+0x238>
    80003848:	00002097          	auipc	ra,0x2
    8000384c:	63a080e7          	jalr	1594(ra) # 80005e82 <panic>
    wakeup(&log);
    80003850:	00015497          	auipc	s1,0x15
    80003854:	32048493          	addi	s1,s1,800 # 80018b70 <log>
    80003858:	8526                	mv	a0,s1
    8000385a:	ffffe097          	auipc	ra,0xffffe
    8000385e:	eba080e7          	jalr	-326(ra) # 80001714 <wakeup>
  release(&log.lock);
    80003862:	8526                	mv	a0,s1
    80003864:	00003097          	auipc	ra,0x3
    80003868:	c1c080e7          	jalr	-996(ra) # 80006480 <release>
  if(do_commit){
    8000386c:	b7c9                	j	8000382e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000386e:	00015a97          	auipc	s5,0x15
    80003872:	332a8a93          	addi	s5,s5,818 # 80018ba0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003876:	00015a17          	auipc	s4,0x15
    8000387a:	2faa0a13          	addi	s4,s4,762 # 80018b70 <log>
    8000387e:	018a2583          	lw	a1,24(s4)
    80003882:	012585bb          	addw	a1,a1,s2
    80003886:	2585                	addiw	a1,a1,1
    80003888:	028a2503          	lw	a0,40(s4)
    8000388c:	fffff097          	auipc	ra,0xfffff
    80003890:	cca080e7          	jalr	-822(ra) # 80002556 <bread>
    80003894:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003896:	000aa583          	lw	a1,0(s5)
    8000389a:	028a2503          	lw	a0,40(s4)
    8000389e:	fffff097          	auipc	ra,0xfffff
    800038a2:	cb8080e7          	jalr	-840(ra) # 80002556 <bread>
    800038a6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038a8:	40000613          	li	a2,1024
    800038ac:	05850593          	addi	a1,a0,88
    800038b0:	05848513          	addi	a0,s1,88
    800038b4:	ffffd097          	auipc	ra,0xffffd
    800038b8:	924080e7          	jalr	-1756(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800038bc:	8526                	mv	a0,s1
    800038be:	fffff097          	auipc	ra,0xfffff
    800038c2:	d8a080e7          	jalr	-630(ra) # 80002648 <bwrite>
    brelse(from);
    800038c6:	854e                	mv	a0,s3
    800038c8:	fffff097          	auipc	ra,0xfffff
    800038cc:	dbe080e7          	jalr	-578(ra) # 80002686 <brelse>
    brelse(to);
    800038d0:	8526                	mv	a0,s1
    800038d2:	fffff097          	auipc	ra,0xfffff
    800038d6:	db4080e7          	jalr	-588(ra) # 80002686 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038da:	2905                	addiw	s2,s2,1
    800038dc:	0a91                	addi	s5,s5,4
    800038de:	02ca2783          	lw	a5,44(s4)
    800038e2:	f8f94ee3          	blt	s2,a5,8000387e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038e6:	00000097          	auipc	ra,0x0
    800038ea:	c6a080e7          	jalr	-918(ra) # 80003550 <write_head>
    install_trans(0); // Now install writes to home locations
    800038ee:	4501                	li	a0,0
    800038f0:	00000097          	auipc	ra,0x0
    800038f4:	cda080e7          	jalr	-806(ra) # 800035ca <install_trans>
    log.lh.n = 0;
    800038f8:	00015797          	auipc	a5,0x15
    800038fc:	2a07a223          	sw	zero,676(a5) # 80018b9c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003900:	00000097          	auipc	ra,0x0
    80003904:	c50080e7          	jalr	-944(ra) # 80003550 <write_head>
    80003908:	bdf5                	j	80003804 <end_op+0x52>

000000008000390a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000390a:	1101                	addi	sp,sp,-32
    8000390c:	ec06                	sd	ra,24(sp)
    8000390e:	e822                	sd	s0,16(sp)
    80003910:	e426                	sd	s1,8(sp)
    80003912:	e04a                	sd	s2,0(sp)
    80003914:	1000                	addi	s0,sp,32
    80003916:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003918:	00015917          	auipc	s2,0x15
    8000391c:	25890913          	addi	s2,s2,600 # 80018b70 <log>
    80003920:	854a                	mv	a0,s2
    80003922:	00003097          	auipc	ra,0x3
    80003926:	aaa080e7          	jalr	-1366(ra) # 800063cc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000392a:	02c92603          	lw	a2,44(s2)
    8000392e:	47f5                	li	a5,29
    80003930:	06c7c563          	blt	a5,a2,8000399a <log_write+0x90>
    80003934:	00015797          	auipc	a5,0x15
    80003938:	2587a783          	lw	a5,600(a5) # 80018b8c <log+0x1c>
    8000393c:	37fd                	addiw	a5,a5,-1
    8000393e:	04f65e63          	bge	a2,a5,8000399a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003942:	00015797          	auipc	a5,0x15
    80003946:	24e7a783          	lw	a5,590(a5) # 80018b90 <log+0x20>
    8000394a:	06f05063          	blez	a5,800039aa <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000394e:	4781                	li	a5,0
    80003950:	06c05563          	blez	a2,800039ba <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003954:	44cc                	lw	a1,12(s1)
    80003956:	00015717          	auipc	a4,0x15
    8000395a:	24a70713          	addi	a4,a4,586 # 80018ba0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000395e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003960:	4314                	lw	a3,0(a4)
    80003962:	04b68c63          	beq	a3,a1,800039ba <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003966:	2785                	addiw	a5,a5,1
    80003968:	0711                	addi	a4,a4,4
    8000396a:	fef61be3          	bne	a2,a5,80003960 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000396e:	0621                	addi	a2,a2,8
    80003970:	060a                	slli	a2,a2,0x2
    80003972:	00015797          	auipc	a5,0x15
    80003976:	1fe78793          	addi	a5,a5,510 # 80018b70 <log>
    8000397a:	963e                	add	a2,a2,a5
    8000397c:	44dc                	lw	a5,12(s1)
    8000397e:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003980:	8526                	mv	a0,s1
    80003982:	fffff097          	auipc	ra,0xfffff
    80003986:	da2080e7          	jalr	-606(ra) # 80002724 <bpin>
    log.lh.n++;
    8000398a:	00015717          	auipc	a4,0x15
    8000398e:	1e670713          	addi	a4,a4,486 # 80018b70 <log>
    80003992:	575c                	lw	a5,44(a4)
    80003994:	2785                	addiw	a5,a5,1
    80003996:	d75c                	sw	a5,44(a4)
    80003998:	a835                	j	800039d4 <log_write+0xca>
    panic("too big a transaction");
    8000399a:	00005517          	auipc	a0,0x5
    8000399e:	cc650513          	addi	a0,a0,-826 # 80008660 <syscalls+0x248>
    800039a2:	00002097          	auipc	ra,0x2
    800039a6:	4e0080e7          	jalr	1248(ra) # 80005e82 <panic>
    panic("log_write outside of trans");
    800039aa:	00005517          	auipc	a0,0x5
    800039ae:	cce50513          	addi	a0,a0,-818 # 80008678 <syscalls+0x260>
    800039b2:	00002097          	auipc	ra,0x2
    800039b6:	4d0080e7          	jalr	1232(ra) # 80005e82 <panic>
  log.lh.block[i] = b->blockno;
    800039ba:	00878713          	addi	a4,a5,8
    800039be:	00271693          	slli	a3,a4,0x2
    800039c2:	00015717          	auipc	a4,0x15
    800039c6:	1ae70713          	addi	a4,a4,430 # 80018b70 <log>
    800039ca:	9736                	add	a4,a4,a3
    800039cc:	44d4                	lw	a3,12(s1)
    800039ce:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039d0:	faf608e3          	beq	a2,a5,80003980 <log_write+0x76>
  }
  release(&log.lock);
    800039d4:	00015517          	auipc	a0,0x15
    800039d8:	19c50513          	addi	a0,a0,412 # 80018b70 <log>
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	aa4080e7          	jalr	-1372(ra) # 80006480 <release>
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6902                	ld	s2,0(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret

00000000800039f0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039f0:	1101                	addi	sp,sp,-32
    800039f2:	ec06                	sd	ra,24(sp)
    800039f4:	e822                	sd	s0,16(sp)
    800039f6:	e426                	sd	s1,8(sp)
    800039f8:	e04a                	sd	s2,0(sp)
    800039fa:	1000                	addi	s0,sp,32
    800039fc:	84aa                	mv	s1,a0
    800039fe:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a00:	00005597          	auipc	a1,0x5
    80003a04:	c9858593          	addi	a1,a1,-872 # 80008698 <syscalls+0x280>
    80003a08:	0521                	addi	a0,a0,8
    80003a0a:	00003097          	auipc	ra,0x3
    80003a0e:	932080e7          	jalr	-1742(ra) # 8000633c <initlock>
  lk->name = name;
    80003a12:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a16:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a1a:	0204a423          	sw	zero,40(s1)
}
    80003a1e:	60e2                	ld	ra,24(sp)
    80003a20:	6442                	ld	s0,16(sp)
    80003a22:	64a2                	ld	s1,8(sp)
    80003a24:	6902                	ld	s2,0(sp)
    80003a26:	6105                	addi	sp,sp,32
    80003a28:	8082                	ret

0000000080003a2a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a2a:	1101                	addi	sp,sp,-32
    80003a2c:	ec06                	sd	ra,24(sp)
    80003a2e:	e822                	sd	s0,16(sp)
    80003a30:	e426                	sd	s1,8(sp)
    80003a32:	e04a                	sd	s2,0(sp)
    80003a34:	1000                	addi	s0,sp,32
    80003a36:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a38:	00850913          	addi	s2,a0,8
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	98e080e7          	jalr	-1650(ra) # 800063cc <acquire>
  while (lk->locked) {
    80003a46:	409c                	lw	a5,0(s1)
    80003a48:	cb89                	beqz	a5,80003a5a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a4a:	85ca                	mv	a1,s2
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	ffffe097          	auipc	ra,0xffffe
    80003a52:	c62080e7          	jalr	-926(ra) # 800016b0 <sleep>
  while (lk->locked) {
    80003a56:	409c                	lw	a5,0(s1)
    80003a58:	fbed                	bnez	a5,80003a4a <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a5a:	4785                	li	a5,1
    80003a5c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a5e:	ffffd097          	auipc	ra,0xffffd
    80003a62:	514080e7          	jalr	1300(ra) # 80000f72 <myproc>
    80003a66:	591c                	lw	a5,48(a0)
    80003a68:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a6a:	854a                	mv	a0,s2
    80003a6c:	00003097          	auipc	ra,0x3
    80003a70:	a14080e7          	jalr	-1516(ra) # 80006480 <release>
}
    80003a74:	60e2                	ld	ra,24(sp)
    80003a76:	6442                	ld	s0,16(sp)
    80003a78:	64a2                	ld	s1,8(sp)
    80003a7a:	6902                	ld	s2,0(sp)
    80003a7c:	6105                	addi	sp,sp,32
    80003a7e:	8082                	ret

0000000080003a80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a80:	1101                	addi	sp,sp,-32
    80003a82:	ec06                	sd	ra,24(sp)
    80003a84:	e822                	sd	s0,16(sp)
    80003a86:	e426                	sd	s1,8(sp)
    80003a88:	e04a                	sd	s2,0(sp)
    80003a8a:	1000                	addi	s0,sp,32
    80003a8c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a8e:	00850913          	addi	s2,a0,8
    80003a92:	854a                	mv	a0,s2
    80003a94:	00003097          	auipc	ra,0x3
    80003a98:	938080e7          	jalr	-1736(ra) # 800063cc <acquire>
  lk->locked = 0;
    80003a9c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aa0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003aa4:	8526                	mv	a0,s1
    80003aa6:	ffffe097          	auipc	ra,0xffffe
    80003aaa:	c6e080e7          	jalr	-914(ra) # 80001714 <wakeup>
  release(&lk->lk);
    80003aae:	854a                	mv	a0,s2
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	9d0080e7          	jalr	-1584(ra) # 80006480 <release>
}
    80003ab8:	60e2                	ld	ra,24(sp)
    80003aba:	6442                	ld	s0,16(sp)
    80003abc:	64a2                	ld	s1,8(sp)
    80003abe:	6902                	ld	s2,0(sp)
    80003ac0:	6105                	addi	sp,sp,32
    80003ac2:	8082                	ret

0000000080003ac4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ac4:	7179                	addi	sp,sp,-48
    80003ac6:	f406                	sd	ra,40(sp)
    80003ac8:	f022                	sd	s0,32(sp)
    80003aca:	ec26                	sd	s1,24(sp)
    80003acc:	e84a                	sd	s2,16(sp)
    80003ace:	e44e                	sd	s3,8(sp)
    80003ad0:	1800                	addi	s0,sp,48
    80003ad2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ad4:	00850913          	addi	s2,a0,8
    80003ad8:	854a                	mv	a0,s2
    80003ada:	00003097          	auipc	ra,0x3
    80003ade:	8f2080e7          	jalr	-1806(ra) # 800063cc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ae2:	409c                	lw	a5,0(s1)
    80003ae4:	ef99                	bnez	a5,80003b02 <holdingsleep+0x3e>
    80003ae6:	4481                	li	s1,0
  release(&lk->lk);
    80003ae8:	854a                	mv	a0,s2
    80003aea:	00003097          	auipc	ra,0x3
    80003aee:	996080e7          	jalr	-1642(ra) # 80006480 <release>
  return r;
}
    80003af2:	8526                	mv	a0,s1
    80003af4:	70a2                	ld	ra,40(sp)
    80003af6:	7402                	ld	s0,32(sp)
    80003af8:	64e2                	ld	s1,24(sp)
    80003afa:	6942                	ld	s2,16(sp)
    80003afc:	69a2                	ld	s3,8(sp)
    80003afe:	6145                	addi	sp,sp,48
    80003b00:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b02:	0284a983          	lw	s3,40(s1)
    80003b06:	ffffd097          	auipc	ra,0xffffd
    80003b0a:	46c080e7          	jalr	1132(ra) # 80000f72 <myproc>
    80003b0e:	5904                	lw	s1,48(a0)
    80003b10:	413484b3          	sub	s1,s1,s3
    80003b14:	0014b493          	seqz	s1,s1
    80003b18:	bfc1                	j	80003ae8 <holdingsleep+0x24>

0000000080003b1a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b1a:	1141                	addi	sp,sp,-16
    80003b1c:	e406                	sd	ra,8(sp)
    80003b1e:	e022                	sd	s0,0(sp)
    80003b20:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b22:	00005597          	auipc	a1,0x5
    80003b26:	b8658593          	addi	a1,a1,-1146 # 800086a8 <syscalls+0x290>
    80003b2a:	00015517          	auipc	a0,0x15
    80003b2e:	18e50513          	addi	a0,a0,398 # 80018cb8 <ftable>
    80003b32:	00003097          	auipc	ra,0x3
    80003b36:	80a080e7          	jalr	-2038(ra) # 8000633c <initlock>
}
    80003b3a:	60a2                	ld	ra,8(sp)
    80003b3c:	6402                	ld	s0,0(sp)
    80003b3e:	0141                	addi	sp,sp,16
    80003b40:	8082                	ret

0000000080003b42 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b42:	1101                	addi	sp,sp,-32
    80003b44:	ec06                	sd	ra,24(sp)
    80003b46:	e822                	sd	s0,16(sp)
    80003b48:	e426                	sd	s1,8(sp)
    80003b4a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b4c:	00015517          	auipc	a0,0x15
    80003b50:	16c50513          	addi	a0,a0,364 # 80018cb8 <ftable>
    80003b54:	00003097          	auipc	ra,0x3
    80003b58:	878080e7          	jalr	-1928(ra) # 800063cc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b5c:	00015497          	auipc	s1,0x15
    80003b60:	17448493          	addi	s1,s1,372 # 80018cd0 <ftable+0x18>
    80003b64:	00016717          	auipc	a4,0x16
    80003b68:	10c70713          	addi	a4,a4,268 # 80019c70 <disk>
    if(f->ref == 0){
    80003b6c:	40dc                	lw	a5,4(s1)
    80003b6e:	cf99                	beqz	a5,80003b8c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b70:	02848493          	addi	s1,s1,40
    80003b74:	fee49ce3          	bne	s1,a4,80003b6c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b78:	00015517          	auipc	a0,0x15
    80003b7c:	14050513          	addi	a0,a0,320 # 80018cb8 <ftable>
    80003b80:	00003097          	auipc	ra,0x3
    80003b84:	900080e7          	jalr	-1792(ra) # 80006480 <release>
  return 0;
    80003b88:	4481                	li	s1,0
    80003b8a:	a819                	j	80003ba0 <filealloc+0x5e>
      f->ref = 1;
    80003b8c:	4785                	li	a5,1
    80003b8e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b90:	00015517          	auipc	a0,0x15
    80003b94:	12850513          	addi	a0,a0,296 # 80018cb8 <ftable>
    80003b98:	00003097          	auipc	ra,0x3
    80003b9c:	8e8080e7          	jalr	-1816(ra) # 80006480 <release>
}
    80003ba0:	8526                	mv	a0,s1
    80003ba2:	60e2                	ld	ra,24(sp)
    80003ba4:	6442                	ld	s0,16(sp)
    80003ba6:	64a2                	ld	s1,8(sp)
    80003ba8:	6105                	addi	sp,sp,32
    80003baa:	8082                	ret

0000000080003bac <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bac:	1101                	addi	sp,sp,-32
    80003bae:	ec06                	sd	ra,24(sp)
    80003bb0:	e822                	sd	s0,16(sp)
    80003bb2:	e426                	sd	s1,8(sp)
    80003bb4:	1000                	addi	s0,sp,32
    80003bb6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bb8:	00015517          	auipc	a0,0x15
    80003bbc:	10050513          	addi	a0,a0,256 # 80018cb8 <ftable>
    80003bc0:	00003097          	auipc	ra,0x3
    80003bc4:	80c080e7          	jalr	-2036(ra) # 800063cc <acquire>
  if(f->ref < 1)
    80003bc8:	40dc                	lw	a5,4(s1)
    80003bca:	02f05263          	blez	a5,80003bee <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bce:	2785                	addiw	a5,a5,1
    80003bd0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bd2:	00015517          	auipc	a0,0x15
    80003bd6:	0e650513          	addi	a0,a0,230 # 80018cb8 <ftable>
    80003bda:	00003097          	auipc	ra,0x3
    80003bde:	8a6080e7          	jalr	-1882(ra) # 80006480 <release>
  return f;
}
    80003be2:	8526                	mv	a0,s1
    80003be4:	60e2                	ld	ra,24(sp)
    80003be6:	6442                	ld	s0,16(sp)
    80003be8:	64a2                	ld	s1,8(sp)
    80003bea:	6105                	addi	sp,sp,32
    80003bec:	8082                	ret
    panic("filedup");
    80003bee:	00005517          	auipc	a0,0x5
    80003bf2:	ac250513          	addi	a0,a0,-1342 # 800086b0 <syscalls+0x298>
    80003bf6:	00002097          	auipc	ra,0x2
    80003bfa:	28c080e7          	jalr	652(ra) # 80005e82 <panic>

0000000080003bfe <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bfe:	7139                	addi	sp,sp,-64
    80003c00:	fc06                	sd	ra,56(sp)
    80003c02:	f822                	sd	s0,48(sp)
    80003c04:	f426                	sd	s1,40(sp)
    80003c06:	f04a                	sd	s2,32(sp)
    80003c08:	ec4e                	sd	s3,24(sp)
    80003c0a:	e852                	sd	s4,16(sp)
    80003c0c:	e456                	sd	s5,8(sp)
    80003c0e:	0080                	addi	s0,sp,64
    80003c10:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c12:	00015517          	auipc	a0,0x15
    80003c16:	0a650513          	addi	a0,a0,166 # 80018cb8 <ftable>
    80003c1a:	00002097          	auipc	ra,0x2
    80003c1e:	7b2080e7          	jalr	1970(ra) # 800063cc <acquire>
  if(f->ref < 1)
    80003c22:	40dc                	lw	a5,4(s1)
    80003c24:	06f05163          	blez	a5,80003c86 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c28:	37fd                	addiw	a5,a5,-1
    80003c2a:	0007871b          	sext.w	a4,a5
    80003c2e:	c0dc                	sw	a5,4(s1)
    80003c30:	06e04363          	bgtz	a4,80003c96 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c34:	0004a903          	lw	s2,0(s1)
    80003c38:	0094ca83          	lbu	s5,9(s1)
    80003c3c:	0104ba03          	ld	s4,16(s1)
    80003c40:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c44:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c48:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c4c:	00015517          	auipc	a0,0x15
    80003c50:	06c50513          	addi	a0,a0,108 # 80018cb8 <ftable>
    80003c54:	00003097          	auipc	ra,0x3
    80003c58:	82c080e7          	jalr	-2004(ra) # 80006480 <release>

  if(ff.type == FD_PIPE){
    80003c5c:	4785                	li	a5,1
    80003c5e:	04f90d63          	beq	s2,a5,80003cb8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c62:	3979                	addiw	s2,s2,-2
    80003c64:	4785                	li	a5,1
    80003c66:	0527e063          	bltu	a5,s2,80003ca6 <fileclose+0xa8>
    begin_op();
    80003c6a:	00000097          	auipc	ra,0x0
    80003c6e:	ac8080e7          	jalr	-1336(ra) # 80003732 <begin_op>
    iput(ff.ip);
    80003c72:	854e                	mv	a0,s3
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	2b6080e7          	jalr	694(ra) # 80002f2a <iput>
    end_op();
    80003c7c:	00000097          	auipc	ra,0x0
    80003c80:	b36080e7          	jalr	-1226(ra) # 800037b2 <end_op>
    80003c84:	a00d                	j	80003ca6 <fileclose+0xa8>
    panic("fileclose");
    80003c86:	00005517          	auipc	a0,0x5
    80003c8a:	a3250513          	addi	a0,a0,-1486 # 800086b8 <syscalls+0x2a0>
    80003c8e:	00002097          	auipc	ra,0x2
    80003c92:	1f4080e7          	jalr	500(ra) # 80005e82 <panic>
    release(&ftable.lock);
    80003c96:	00015517          	auipc	a0,0x15
    80003c9a:	02250513          	addi	a0,a0,34 # 80018cb8 <ftable>
    80003c9e:	00002097          	auipc	ra,0x2
    80003ca2:	7e2080e7          	jalr	2018(ra) # 80006480 <release>
  }
}
    80003ca6:	70e2                	ld	ra,56(sp)
    80003ca8:	7442                	ld	s0,48(sp)
    80003caa:	74a2                	ld	s1,40(sp)
    80003cac:	7902                	ld	s2,32(sp)
    80003cae:	69e2                	ld	s3,24(sp)
    80003cb0:	6a42                	ld	s4,16(sp)
    80003cb2:	6aa2                	ld	s5,8(sp)
    80003cb4:	6121                	addi	sp,sp,64
    80003cb6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cb8:	85d6                	mv	a1,s5
    80003cba:	8552                	mv	a0,s4
    80003cbc:	00000097          	auipc	ra,0x0
    80003cc0:	34c080e7          	jalr	844(ra) # 80004008 <pipeclose>
    80003cc4:	b7cd                	j	80003ca6 <fileclose+0xa8>

0000000080003cc6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cc6:	715d                	addi	sp,sp,-80
    80003cc8:	e486                	sd	ra,72(sp)
    80003cca:	e0a2                	sd	s0,64(sp)
    80003ccc:	fc26                	sd	s1,56(sp)
    80003cce:	f84a                	sd	s2,48(sp)
    80003cd0:	f44e                	sd	s3,40(sp)
    80003cd2:	0880                	addi	s0,sp,80
    80003cd4:	84aa                	mv	s1,a0
    80003cd6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cd8:	ffffd097          	auipc	ra,0xffffd
    80003cdc:	29a080e7          	jalr	666(ra) # 80000f72 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ce0:	409c                	lw	a5,0(s1)
    80003ce2:	37f9                	addiw	a5,a5,-2
    80003ce4:	4705                	li	a4,1
    80003ce6:	04f76763          	bltu	a4,a5,80003d34 <filestat+0x6e>
    80003cea:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cec:	6c88                	ld	a0,24(s1)
    80003cee:	fffff097          	auipc	ra,0xfffff
    80003cf2:	082080e7          	jalr	130(ra) # 80002d70 <ilock>
    stati(f->ip, &st);
    80003cf6:	fb840593          	addi	a1,s0,-72
    80003cfa:	6c88                	ld	a0,24(s1)
    80003cfc:	fffff097          	auipc	ra,0xfffff
    80003d00:	2fe080e7          	jalr	766(ra) # 80002ffa <stati>
    iunlock(f->ip);
    80003d04:	6c88                	ld	a0,24(s1)
    80003d06:	fffff097          	auipc	ra,0xfffff
    80003d0a:	12c080e7          	jalr	300(ra) # 80002e32 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d0e:	46e1                	li	a3,24
    80003d10:	fb840613          	addi	a2,s0,-72
    80003d14:	85ce                	mv	a1,s3
    80003d16:	05093503          	ld	a0,80(s2)
    80003d1a:	ffffd097          	auipc	ra,0xffffd
    80003d1e:	dfc080e7          	jalr	-516(ra) # 80000b16 <copyout>
    80003d22:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d26:	60a6                	ld	ra,72(sp)
    80003d28:	6406                	ld	s0,64(sp)
    80003d2a:	74e2                	ld	s1,56(sp)
    80003d2c:	7942                	ld	s2,48(sp)
    80003d2e:	79a2                	ld	s3,40(sp)
    80003d30:	6161                	addi	sp,sp,80
    80003d32:	8082                	ret
  return -1;
    80003d34:	557d                	li	a0,-1
    80003d36:	bfc5                	j	80003d26 <filestat+0x60>

0000000080003d38 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d38:	7179                	addi	sp,sp,-48
    80003d3a:	f406                	sd	ra,40(sp)
    80003d3c:	f022                	sd	s0,32(sp)
    80003d3e:	ec26                	sd	s1,24(sp)
    80003d40:	e84a                	sd	s2,16(sp)
    80003d42:	e44e                	sd	s3,8(sp)
    80003d44:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d46:	00854783          	lbu	a5,8(a0)
    80003d4a:	c3d5                	beqz	a5,80003dee <fileread+0xb6>
    80003d4c:	84aa                	mv	s1,a0
    80003d4e:	89ae                	mv	s3,a1
    80003d50:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d52:	411c                	lw	a5,0(a0)
    80003d54:	4705                	li	a4,1
    80003d56:	04e78963          	beq	a5,a4,80003da8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d5a:	470d                	li	a4,3
    80003d5c:	04e78d63          	beq	a5,a4,80003db6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d60:	4709                	li	a4,2
    80003d62:	06e79e63          	bne	a5,a4,80003dde <fileread+0xa6>
    ilock(f->ip);
    80003d66:	6d08                	ld	a0,24(a0)
    80003d68:	fffff097          	auipc	ra,0xfffff
    80003d6c:	008080e7          	jalr	8(ra) # 80002d70 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d70:	874a                	mv	a4,s2
    80003d72:	5094                	lw	a3,32(s1)
    80003d74:	864e                	mv	a2,s3
    80003d76:	4585                	li	a1,1
    80003d78:	6c88                	ld	a0,24(s1)
    80003d7a:	fffff097          	auipc	ra,0xfffff
    80003d7e:	2aa080e7          	jalr	682(ra) # 80003024 <readi>
    80003d82:	892a                	mv	s2,a0
    80003d84:	00a05563          	blez	a0,80003d8e <fileread+0x56>
      f->off += r;
    80003d88:	509c                	lw	a5,32(s1)
    80003d8a:	9fa9                	addw	a5,a5,a0
    80003d8c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d8e:	6c88                	ld	a0,24(s1)
    80003d90:	fffff097          	auipc	ra,0xfffff
    80003d94:	0a2080e7          	jalr	162(ra) # 80002e32 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d98:	854a                	mv	a0,s2
    80003d9a:	70a2                	ld	ra,40(sp)
    80003d9c:	7402                	ld	s0,32(sp)
    80003d9e:	64e2                	ld	s1,24(sp)
    80003da0:	6942                	ld	s2,16(sp)
    80003da2:	69a2                	ld	s3,8(sp)
    80003da4:	6145                	addi	sp,sp,48
    80003da6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003da8:	6908                	ld	a0,16(a0)
    80003daa:	00000097          	auipc	ra,0x0
    80003dae:	3ce080e7          	jalr	974(ra) # 80004178 <piperead>
    80003db2:	892a                	mv	s2,a0
    80003db4:	b7d5                	j	80003d98 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003db6:	02451783          	lh	a5,36(a0)
    80003dba:	03079693          	slli	a3,a5,0x30
    80003dbe:	92c1                	srli	a3,a3,0x30
    80003dc0:	4725                	li	a4,9
    80003dc2:	02d76863          	bltu	a4,a3,80003df2 <fileread+0xba>
    80003dc6:	0792                	slli	a5,a5,0x4
    80003dc8:	00015717          	auipc	a4,0x15
    80003dcc:	e5070713          	addi	a4,a4,-432 # 80018c18 <devsw>
    80003dd0:	97ba                	add	a5,a5,a4
    80003dd2:	639c                	ld	a5,0(a5)
    80003dd4:	c38d                	beqz	a5,80003df6 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003dd6:	4505                	li	a0,1
    80003dd8:	9782                	jalr	a5
    80003dda:	892a                	mv	s2,a0
    80003ddc:	bf75                	j	80003d98 <fileread+0x60>
    panic("fileread");
    80003dde:	00005517          	auipc	a0,0x5
    80003de2:	8ea50513          	addi	a0,a0,-1814 # 800086c8 <syscalls+0x2b0>
    80003de6:	00002097          	auipc	ra,0x2
    80003dea:	09c080e7          	jalr	156(ra) # 80005e82 <panic>
    return -1;
    80003dee:	597d                	li	s2,-1
    80003df0:	b765                	j	80003d98 <fileread+0x60>
      return -1;
    80003df2:	597d                	li	s2,-1
    80003df4:	b755                	j	80003d98 <fileread+0x60>
    80003df6:	597d                	li	s2,-1
    80003df8:	b745                	j	80003d98 <fileread+0x60>

0000000080003dfa <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dfa:	715d                	addi	sp,sp,-80
    80003dfc:	e486                	sd	ra,72(sp)
    80003dfe:	e0a2                	sd	s0,64(sp)
    80003e00:	fc26                	sd	s1,56(sp)
    80003e02:	f84a                	sd	s2,48(sp)
    80003e04:	f44e                	sd	s3,40(sp)
    80003e06:	f052                	sd	s4,32(sp)
    80003e08:	ec56                	sd	s5,24(sp)
    80003e0a:	e85a                	sd	s6,16(sp)
    80003e0c:	e45e                	sd	s7,8(sp)
    80003e0e:	e062                	sd	s8,0(sp)
    80003e10:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e12:	00954783          	lbu	a5,9(a0)
    80003e16:	10078663          	beqz	a5,80003f22 <filewrite+0x128>
    80003e1a:	892a                	mv	s2,a0
    80003e1c:	8aae                	mv	s5,a1
    80003e1e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e20:	411c                	lw	a5,0(a0)
    80003e22:	4705                	li	a4,1
    80003e24:	02e78263          	beq	a5,a4,80003e48 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e28:	470d                	li	a4,3
    80003e2a:	02e78663          	beq	a5,a4,80003e56 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e2e:	4709                	li	a4,2
    80003e30:	0ee79163          	bne	a5,a4,80003f12 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e34:	0ac05d63          	blez	a2,80003eee <filewrite+0xf4>
    int i = 0;
    80003e38:	4981                	li	s3,0
    80003e3a:	6b05                	lui	s6,0x1
    80003e3c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e40:	6b85                	lui	s7,0x1
    80003e42:	c00b8b9b          	addiw	s7,s7,-1024
    80003e46:	a861                	j	80003ede <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e48:	6908                	ld	a0,16(a0)
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	22e080e7          	jalr	558(ra) # 80004078 <pipewrite>
    80003e52:	8a2a                	mv	s4,a0
    80003e54:	a045                	j	80003ef4 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e56:	02451783          	lh	a5,36(a0)
    80003e5a:	03079693          	slli	a3,a5,0x30
    80003e5e:	92c1                	srli	a3,a3,0x30
    80003e60:	4725                	li	a4,9
    80003e62:	0cd76263          	bltu	a4,a3,80003f26 <filewrite+0x12c>
    80003e66:	0792                	slli	a5,a5,0x4
    80003e68:	00015717          	auipc	a4,0x15
    80003e6c:	db070713          	addi	a4,a4,-592 # 80018c18 <devsw>
    80003e70:	97ba                	add	a5,a5,a4
    80003e72:	679c                	ld	a5,8(a5)
    80003e74:	cbdd                	beqz	a5,80003f2a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e76:	4505                	li	a0,1
    80003e78:	9782                	jalr	a5
    80003e7a:	8a2a                	mv	s4,a0
    80003e7c:	a8a5                	j	80003ef4 <filewrite+0xfa>
    80003e7e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e82:	00000097          	auipc	ra,0x0
    80003e86:	8b0080e7          	jalr	-1872(ra) # 80003732 <begin_op>
      ilock(f->ip);
    80003e8a:	01893503          	ld	a0,24(s2)
    80003e8e:	fffff097          	auipc	ra,0xfffff
    80003e92:	ee2080e7          	jalr	-286(ra) # 80002d70 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e96:	8762                	mv	a4,s8
    80003e98:	02092683          	lw	a3,32(s2)
    80003e9c:	01598633          	add	a2,s3,s5
    80003ea0:	4585                	li	a1,1
    80003ea2:	01893503          	ld	a0,24(s2)
    80003ea6:	fffff097          	auipc	ra,0xfffff
    80003eaa:	276080e7          	jalr	630(ra) # 8000311c <writei>
    80003eae:	84aa                	mv	s1,a0
    80003eb0:	00a05763          	blez	a0,80003ebe <filewrite+0xc4>
        f->off += r;
    80003eb4:	02092783          	lw	a5,32(s2)
    80003eb8:	9fa9                	addw	a5,a5,a0
    80003eba:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ebe:	01893503          	ld	a0,24(s2)
    80003ec2:	fffff097          	auipc	ra,0xfffff
    80003ec6:	f70080e7          	jalr	-144(ra) # 80002e32 <iunlock>
      end_op();
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	8e8080e7          	jalr	-1816(ra) # 800037b2 <end_op>

      if(r != n1){
    80003ed2:	009c1f63          	bne	s8,s1,80003ef0 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ed6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003eda:	0149db63          	bge	s3,s4,80003ef0 <filewrite+0xf6>
      int n1 = n - i;
    80003ede:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003ee2:	84be                	mv	s1,a5
    80003ee4:	2781                	sext.w	a5,a5
    80003ee6:	f8fb5ce3          	bge	s6,a5,80003e7e <filewrite+0x84>
    80003eea:	84de                	mv	s1,s7
    80003eec:	bf49                	j	80003e7e <filewrite+0x84>
    int i = 0;
    80003eee:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ef0:	013a1f63          	bne	s4,s3,80003f0e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ef4:	8552                	mv	a0,s4
    80003ef6:	60a6                	ld	ra,72(sp)
    80003ef8:	6406                	ld	s0,64(sp)
    80003efa:	74e2                	ld	s1,56(sp)
    80003efc:	7942                	ld	s2,48(sp)
    80003efe:	79a2                	ld	s3,40(sp)
    80003f00:	7a02                	ld	s4,32(sp)
    80003f02:	6ae2                	ld	s5,24(sp)
    80003f04:	6b42                	ld	s6,16(sp)
    80003f06:	6ba2                	ld	s7,8(sp)
    80003f08:	6c02                	ld	s8,0(sp)
    80003f0a:	6161                	addi	sp,sp,80
    80003f0c:	8082                	ret
    ret = (i == n ? n : -1);
    80003f0e:	5a7d                	li	s4,-1
    80003f10:	b7d5                	j	80003ef4 <filewrite+0xfa>
    panic("filewrite");
    80003f12:	00004517          	auipc	a0,0x4
    80003f16:	7c650513          	addi	a0,a0,1990 # 800086d8 <syscalls+0x2c0>
    80003f1a:	00002097          	auipc	ra,0x2
    80003f1e:	f68080e7          	jalr	-152(ra) # 80005e82 <panic>
    return -1;
    80003f22:	5a7d                	li	s4,-1
    80003f24:	bfc1                	j	80003ef4 <filewrite+0xfa>
      return -1;
    80003f26:	5a7d                	li	s4,-1
    80003f28:	b7f1                	j	80003ef4 <filewrite+0xfa>
    80003f2a:	5a7d                	li	s4,-1
    80003f2c:	b7e1                	j	80003ef4 <filewrite+0xfa>

0000000080003f2e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f2e:	7179                	addi	sp,sp,-48
    80003f30:	f406                	sd	ra,40(sp)
    80003f32:	f022                	sd	s0,32(sp)
    80003f34:	ec26                	sd	s1,24(sp)
    80003f36:	e84a                	sd	s2,16(sp)
    80003f38:	e44e                	sd	s3,8(sp)
    80003f3a:	e052                	sd	s4,0(sp)
    80003f3c:	1800                	addi	s0,sp,48
    80003f3e:	84aa                	mv	s1,a0
    80003f40:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f42:	0005b023          	sd	zero,0(a1)
    80003f46:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f4a:	00000097          	auipc	ra,0x0
    80003f4e:	bf8080e7          	jalr	-1032(ra) # 80003b42 <filealloc>
    80003f52:	e088                	sd	a0,0(s1)
    80003f54:	c551                	beqz	a0,80003fe0 <pipealloc+0xb2>
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	bec080e7          	jalr	-1044(ra) # 80003b42 <filealloc>
    80003f5e:	00aa3023          	sd	a0,0(s4)
    80003f62:	c92d                	beqz	a0,80003fd4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f64:	ffffc097          	auipc	ra,0xffffc
    80003f68:	1b4080e7          	jalr	436(ra) # 80000118 <kalloc>
    80003f6c:	892a                	mv	s2,a0
    80003f6e:	c125                	beqz	a0,80003fce <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f70:	4985                	li	s3,1
    80003f72:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f76:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f7a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f7e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f82:	00004597          	auipc	a1,0x4
    80003f86:	76658593          	addi	a1,a1,1894 # 800086e8 <syscalls+0x2d0>
    80003f8a:	00002097          	auipc	ra,0x2
    80003f8e:	3b2080e7          	jalr	946(ra) # 8000633c <initlock>
  (*f0)->type = FD_PIPE;
    80003f92:	609c                	ld	a5,0(s1)
    80003f94:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f98:	609c                	ld	a5,0(s1)
    80003f9a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f9e:	609c                	ld	a5,0(s1)
    80003fa0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fa4:	609c                	ld	a5,0(s1)
    80003fa6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003faa:	000a3783          	ld	a5,0(s4)
    80003fae:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fb2:	000a3783          	ld	a5,0(s4)
    80003fb6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fba:	000a3783          	ld	a5,0(s4)
    80003fbe:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fc2:	000a3783          	ld	a5,0(s4)
    80003fc6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fca:	4501                	li	a0,0
    80003fcc:	a025                	j	80003ff4 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fce:	6088                	ld	a0,0(s1)
    80003fd0:	e501                	bnez	a0,80003fd8 <pipealloc+0xaa>
    80003fd2:	a039                	j	80003fe0 <pipealloc+0xb2>
    80003fd4:	6088                	ld	a0,0(s1)
    80003fd6:	c51d                	beqz	a0,80004004 <pipealloc+0xd6>
    fileclose(*f0);
    80003fd8:	00000097          	auipc	ra,0x0
    80003fdc:	c26080e7          	jalr	-986(ra) # 80003bfe <fileclose>
  if(*f1)
    80003fe0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fe4:	557d                	li	a0,-1
  if(*f1)
    80003fe6:	c799                	beqz	a5,80003ff4 <pipealloc+0xc6>
    fileclose(*f1);
    80003fe8:	853e                	mv	a0,a5
    80003fea:	00000097          	auipc	ra,0x0
    80003fee:	c14080e7          	jalr	-1004(ra) # 80003bfe <fileclose>
  return -1;
    80003ff2:	557d                	li	a0,-1
}
    80003ff4:	70a2                	ld	ra,40(sp)
    80003ff6:	7402                	ld	s0,32(sp)
    80003ff8:	64e2                	ld	s1,24(sp)
    80003ffa:	6942                	ld	s2,16(sp)
    80003ffc:	69a2                	ld	s3,8(sp)
    80003ffe:	6a02                	ld	s4,0(sp)
    80004000:	6145                	addi	sp,sp,48
    80004002:	8082                	ret
  return -1;
    80004004:	557d                	li	a0,-1
    80004006:	b7fd                	j	80003ff4 <pipealloc+0xc6>

0000000080004008 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004008:	1101                	addi	sp,sp,-32
    8000400a:	ec06                	sd	ra,24(sp)
    8000400c:	e822                	sd	s0,16(sp)
    8000400e:	e426                	sd	s1,8(sp)
    80004010:	e04a                	sd	s2,0(sp)
    80004012:	1000                	addi	s0,sp,32
    80004014:	84aa                	mv	s1,a0
    80004016:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004018:	00002097          	auipc	ra,0x2
    8000401c:	3b4080e7          	jalr	948(ra) # 800063cc <acquire>
  if(writable){
    80004020:	02090d63          	beqz	s2,8000405a <pipeclose+0x52>
    pi->writeopen = 0;
    80004024:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004028:	21848513          	addi	a0,s1,536
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	6e8080e7          	jalr	1768(ra) # 80001714 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004034:	2204b783          	ld	a5,544(s1)
    80004038:	eb95                	bnez	a5,8000406c <pipeclose+0x64>
    release(&pi->lock);
    8000403a:	8526                	mv	a0,s1
    8000403c:	00002097          	auipc	ra,0x2
    80004040:	444080e7          	jalr	1092(ra) # 80006480 <release>
    kfree((char*)pi);
    80004044:	8526                	mv	a0,s1
    80004046:	ffffc097          	auipc	ra,0xffffc
    8000404a:	fd6080e7          	jalr	-42(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000404e:	60e2                	ld	ra,24(sp)
    80004050:	6442                	ld	s0,16(sp)
    80004052:	64a2                	ld	s1,8(sp)
    80004054:	6902                	ld	s2,0(sp)
    80004056:	6105                	addi	sp,sp,32
    80004058:	8082                	ret
    pi->readopen = 0;
    8000405a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000405e:	21c48513          	addi	a0,s1,540
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	6b2080e7          	jalr	1714(ra) # 80001714 <wakeup>
    8000406a:	b7e9                	j	80004034 <pipeclose+0x2c>
    release(&pi->lock);
    8000406c:	8526                	mv	a0,s1
    8000406e:	00002097          	auipc	ra,0x2
    80004072:	412080e7          	jalr	1042(ra) # 80006480 <release>
}
    80004076:	bfe1                	j	8000404e <pipeclose+0x46>

0000000080004078 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004078:	7159                	addi	sp,sp,-112
    8000407a:	f486                	sd	ra,104(sp)
    8000407c:	f0a2                	sd	s0,96(sp)
    8000407e:	eca6                	sd	s1,88(sp)
    80004080:	e8ca                	sd	s2,80(sp)
    80004082:	e4ce                	sd	s3,72(sp)
    80004084:	e0d2                	sd	s4,64(sp)
    80004086:	fc56                	sd	s5,56(sp)
    80004088:	f85a                	sd	s6,48(sp)
    8000408a:	f45e                	sd	s7,40(sp)
    8000408c:	f062                	sd	s8,32(sp)
    8000408e:	ec66                	sd	s9,24(sp)
    80004090:	1880                	addi	s0,sp,112
    80004092:	84aa                	mv	s1,a0
    80004094:	8aae                	mv	s5,a1
    80004096:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	eda080e7          	jalr	-294(ra) # 80000f72 <myproc>
    800040a0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	328080e7          	jalr	808(ra) # 800063cc <acquire>
  while(i < n){
    800040ac:	0d405463          	blez	s4,80004174 <pipewrite+0xfc>
    800040b0:	8ba6                	mv	s7,s1
  int i = 0;
    800040b2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040b4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040b6:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040ba:	21c48c13          	addi	s8,s1,540
    800040be:	a08d                	j	80004120 <pipewrite+0xa8>
      release(&pi->lock);
    800040c0:	8526                	mv	a0,s1
    800040c2:	00002097          	auipc	ra,0x2
    800040c6:	3be080e7          	jalr	958(ra) # 80006480 <release>
      return -1;
    800040ca:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040cc:	854a                	mv	a0,s2
    800040ce:	70a6                	ld	ra,104(sp)
    800040d0:	7406                	ld	s0,96(sp)
    800040d2:	64e6                	ld	s1,88(sp)
    800040d4:	6946                	ld	s2,80(sp)
    800040d6:	69a6                	ld	s3,72(sp)
    800040d8:	6a06                	ld	s4,64(sp)
    800040da:	7ae2                	ld	s5,56(sp)
    800040dc:	7b42                	ld	s6,48(sp)
    800040de:	7ba2                	ld	s7,40(sp)
    800040e0:	7c02                	ld	s8,32(sp)
    800040e2:	6ce2                	ld	s9,24(sp)
    800040e4:	6165                	addi	sp,sp,112
    800040e6:	8082                	ret
      wakeup(&pi->nread);
    800040e8:	8566                	mv	a0,s9
    800040ea:	ffffd097          	auipc	ra,0xffffd
    800040ee:	62a080e7          	jalr	1578(ra) # 80001714 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040f2:	85de                	mv	a1,s7
    800040f4:	8562                	mv	a0,s8
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	5ba080e7          	jalr	1466(ra) # 800016b0 <sleep>
    800040fe:	a839                	j	8000411c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004100:	21c4a783          	lw	a5,540(s1)
    80004104:	0017871b          	addiw	a4,a5,1
    80004108:	20e4ae23          	sw	a4,540(s1)
    8000410c:	1ff7f793          	andi	a5,a5,511
    80004110:	97a6                	add	a5,a5,s1
    80004112:	f9f44703          	lbu	a4,-97(s0)
    80004116:	00e78c23          	sb	a4,24(a5)
      i++;
    8000411a:	2905                	addiw	s2,s2,1
  while(i < n){
    8000411c:	05495063          	bge	s2,s4,8000415c <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004120:	2204a783          	lw	a5,544(s1)
    80004124:	dfd1                	beqz	a5,800040c0 <pipewrite+0x48>
    80004126:	854e                	mv	a0,s3
    80004128:	ffffe097          	auipc	ra,0xffffe
    8000412c:	830080e7          	jalr	-2000(ra) # 80001958 <killed>
    80004130:	f941                	bnez	a0,800040c0 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004132:	2184a783          	lw	a5,536(s1)
    80004136:	21c4a703          	lw	a4,540(s1)
    8000413a:	2007879b          	addiw	a5,a5,512
    8000413e:	faf705e3          	beq	a4,a5,800040e8 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004142:	4685                	li	a3,1
    80004144:	01590633          	add	a2,s2,s5
    80004148:	f9f40593          	addi	a1,s0,-97
    8000414c:	0509b503          	ld	a0,80(s3)
    80004150:	ffffd097          	auipc	ra,0xffffd
    80004154:	a52080e7          	jalr	-1454(ra) # 80000ba2 <copyin>
    80004158:	fb6514e3          	bne	a0,s6,80004100 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000415c:	21848513          	addi	a0,s1,536
    80004160:	ffffd097          	auipc	ra,0xffffd
    80004164:	5b4080e7          	jalr	1460(ra) # 80001714 <wakeup>
  release(&pi->lock);
    80004168:	8526                	mv	a0,s1
    8000416a:	00002097          	auipc	ra,0x2
    8000416e:	316080e7          	jalr	790(ra) # 80006480 <release>
  return i;
    80004172:	bfa9                	j	800040cc <pipewrite+0x54>
  int i = 0;
    80004174:	4901                	li	s2,0
    80004176:	b7dd                	j	8000415c <pipewrite+0xe4>

0000000080004178 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004178:	715d                	addi	sp,sp,-80
    8000417a:	e486                	sd	ra,72(sp)
    8000417c:	e0a2                	sd	s0,64(sp)
    8000417e:	fc26                	sd	s1,56(sp)
    80004180:	f84a                	sd	s2,48(sp)
    80004182:	f44e                	sd	s3,40(sp)
    80004184:	f052                	sd	s4,32(sp)
    80004186:	ec56                	sd	s5,24(sp)
    80004188:	e85a                	sd	s6,16(sp)
    8000418a:	0880                	addi	s0,sp,80
    8000418c:	84aa                	mv	s1,a0
    8000418e:	892e                	mv	s2,a1
    80004190:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004192:	ffffd097          	auipc	ra,0xffffd
    80004196:	de0080e7          	jalr	-544(ra) # 80000f72 <myproc>
    8000419a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000419c:	8b26                	mv	s6,s1
    8000419e:	8526                	mv	a0,s1
    800041a0:	00002097          	auipc	ra,0x2
    800041a4:	22c080e7          	jalr	556(ra) # 800063cc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041a8:	2184a703          	lw	a4,536(s1)
    800041ac:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041b0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041b4:	02f71763          	bne	a4,a5,800041e2 <piperead+0x6a>
    800041b8:	2244a783          	lw	a5,548(s1)
    800041bc:	c39d                	beqz	a5,800041e2 <piperead+0x6a>
    if(killed(pr)){
    800041be:	8552                	mv	a0,s4
    800041c0:	ffffd097          	auipc	ra,0xffffd
    800041c4:	798080e7          	jalr	1944(ra) # 80001958 <killed>
    800041c8:	e941                	bnez	a0,80004258 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041ca:	85da                	mv	a1,s6
    800041cc:	854e                	mv	a0,s3
    800041ce:	ffffd097          	auipc	ra,0xffffd
    800041d2:	4e2080e7          	jalr	1250(ra) # 800016b0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041d6:	2184a703          	lw	a4,536(s1)
    800041da:	21c4a783          	lw	a5,540(s1)
    800041de:	fcf70de3          	beq	a4,a5,800041b8 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e2:	09505263          	blez	s5,80004266 <piperead+0xee>
    800041e6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041e8:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800041ea:	2184a783          	lw	a5,536(s1)
    800041ee:	21c4a703          	lw	a4,540(s1)
    800041f2:	02f70d63          	beq	a4,a5,8000422c <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041f6:	0017871b          	addiw	a4,a5,1
    800041fa:	20e4ac23          	sw	a4,536(s1)
    800041fe:	1ff7f793          	andi	a5,a5,511
    80004202:	97a6                	add	a5,a5,s1
    80004204:	0187c783          	lbu	a5,24(a5)
    80004208:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000420c:	4685                	li	a3,1
    8000420e:	fbf40613          	addi	a2,s0,-65
    80004212:	85ca                	mv	a1,s2
    80004214:	050a3503          	ld	a0,80(s4)
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	8fe080e7          	jalr	-1794(ra) # 80000b16 <copyout>
    80004220:	01650663          	beq	a0,s6,8000422c <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004224:	2985                	addiw	s3,s3,1
    80004226:	0905                	addi	s2,s2,1
    80004228:	fd3a91e3          	bne	s5,s3,800041ea <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000422c:	21c48513          	addi	a0,s1,540
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	4e4080e7          	jalr	1252(ra) # 80001714 <wakeup>
  release(&pi->lock);
    80004238:	8526                	mv	a0,s1
    8000423a:	00002097          	auipc	ra,0x2
    8000423e:	246080e7          	jalr	582(ra) # 80006480 <release>
  return i;
}
    80004242:	854e                	mv	a0,s3
    80004244:	60a6                	ld	ra,72(sp)
    80004246:	6406                	ld	s0,64(sp)
    80004248:	74e2                	ld	s1,56(sp)
    8000424a:	7942                	ld	s2,48(sp)
    8000424c:	79a2                	ld	s3,40(sp)
    8000424e:	7a02                	ld	s4,32(sp)
    80004250:	6ae2                	ld	s5,24(sp)
    80004252:	6b42                	ld	s6,16(sp)
    80004254:	6161                	addi	sp,sp,80
    80004256:	8082                	ret
      release(&pi->lock);
    80004258:	8526                	mv	a0,s1
    8000425a:	00002097          	auipc	ra,0x2
    8000425e:	226080e7          	jalr	550(ra) # 80006480 <release>
      return -1;
    80004262:	59fd                	li	s3,-1
    80004264:	bff9                	j	80004242 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004266:	4981                	li	s3,0
    80004268:	b7d1                	j	8000422c <piperead+0xb4>

000000008000426a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000426a:	1141                	addi	sp,sp,-16
    8000426c:	e422                	sd	s0,8(sp)
    8000426e:	0800                	addi	s0,sp,16
    80004270:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004272:	8905                	andi	a0,a0,1
    80004274:	c111                	beqz	a0,80004278 <flags2perm+0xe>
      perm = PTE_X;
    80004276:	4521                	li	a0,8
    if(flags & 0x2)
    80004278:	8b89                	andi	a5,a5,2
    8000427a:	c399                	beqz	a5,80004280 <flags2perm+0x16>
      perm |= PTE_W;
    8000427c:	00456513          	ori	a0,a0,4
    return perm;
}
    80004280:	6422                	ld	s0,8(sp)
    80004282:	0141                	addi	sp,sp,16
    80004284:	8082                	ret

0000000080004286 <exec>:

int
exec(char *path, char **argv)
{
    80004286:	df010113          	addi	sp,sp,-528
    8000428a:	20113423          	sd	ra,520(sp)
    8000428e:	20813023          	sd	s0,512(sp)
    80004292:	ffa6                	sd	s1,504(sp)
    80004294:	fbca                	sd	s2,496(sp)
    80004296:	f7ce                	sd	s3,488(sp)
    80004298:	f3d2                	sd	s4,480(sp)
    8000429a:	efd6                	sd	s5,472(sp)
    8000429c:	ebda                	sd	s6,464(sp)
    8000429e:	e7de                	sd	s7,456(sp)
    800042a0:	e3e2                	sd	s8,448(sp)
    800042a2:	ff66                	sd	s9,440(sp)
    800042a4:	fb6a                	sd	s10,432(sp)
    800042a6:	f76e                	sd	s11,424(sp)
    800042a8:	0c00                	addi	s0,sp,528
    800042aa:	84aa                	mv	s1,a0
    800042ac:	dea43c23          	sd	a0,-520(s0)
    800042b0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042b4:	ffffd097          	auipc	ra,0xffffd
    800042b8:	cbe080e7          	jalr	-834(ra) # 80000f72 <myproc>
    800042bc:	892a                	mv	s2,a0

  begin_op();
    800042be:	fffff097          	auipc	ra,0xfffff
    800042c2:	474080e7          	jalr	1140(ra) # 80003732 <begin_op>

  if((ip = namei(path)) == 0){
    800042c6:	8526                	mv	a0,s1
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	24e080e7          	jalr	590(ra) # 80003516 <namei>
    800042d0:	c92d                	beqz	a0,80004342 <exec+0xbc>
    800042d2:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042d4:	fffff097          	auipc	ra,0xfffff
    800042d8:	a9c080e7          	jalr	-1380(ra) # 80002d70 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))//读信息到文件header
    800042dc:	04000713          	li	a4,64
    800042e0:	4681                	li	a3,0
    800042e2:	e5040613          	addi	a2,s0,-432
    800042e6:	4581                	li	a1,0
    800042e8:	8526                	mv	a0,s1
    800042ea:	fffff097          	auipc	ra,0xfffff
    800042ee:	d3a080e7          	jalr	-710(ra) # 80003024 <readi>
    800042f2:	04000793          	li	a5,64
    800042f6:	00f51a63          	bne	a0,a5,8000430a <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042fa:	e5042703          	lw	a4,-432(s0)
    800042fe:	464c47b7          	lui	a5,0x464c4
    80004302:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004306:	04f70463          	beq	a4,a5,8000434e <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000430a:	8526                	mv	a0,s1
    8000430c:	fffff097          	auipc	ra,0xfffff
    80004310:	cc6080e7          	jalr	-826(ra) # 80002fd2 <iunlockput>
    end_op();
    80004314:	fffff097          	auipc	ra,0xfffff
    80004318:	49e080e7          	jalr	1182(ra) # 800037b2 <end_op>
  }
  return -1;
    8000431c:	557d                	li	a0,-1
}
    8000431e:	20813083          	ld	ra,520(sp)
    80004322:	20013403          	ld	s0,512(sp)
    80004326:	74fe                	ld	s1,504(sp)
    80004328:	795e                	ld	s2,496(sp)
    8000432a:	79be                	ld	s3,488(sp)
    8000432c:	7a1e                	ld	s4,480(sp)
    8000432e:	6afe                	ld	s5,472(sp)
    80004330:	6b5e                	ld	s6,464(sp)
    80004332:	6bbe                	ld	s7,456(sp)
    80004334:	6c1e                	ld	s8,448(sp)
    80004336:	7cfa                	ld	s9,440(sp)
    80004338:	7d5a                	ld	s10,432(sp)
    8000433a:	7dba                	ld	s11,424(sp)
    8000433c:	21010113          	addi	sp,sp,528
    80004340:	8082                	ret
    end_op();
    80004342:	fffff097          	auipc	ra,0xfffff
    80004346:	470080e7          	jalr	1136(ra) # 800037b2 <end_op>
    return -1;
    8000434a:	557d                	li	a0,-1
    8000434c:	bfc9                	j	8000431e <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000434e:	854a                	mv	a0,s2
    80004350:	ffffd097          	auipc	ra,0xffffd
    80004354:	ce6080e7          	jalr	-794(ra) # 80001036 <proc_pagetable>
    80004358:	8baa                	mv	s7,a0
    8000435a:	d945                	beqz	a0,8000430a <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000435c:	e7042983          	lw	s3,-400(s0)
    80004360:	e8845783          	lhu	a5,-376(s0)
    80004364:	c7ad                	beqz	a5,800043ce <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004366:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004368:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    8000436a:	6c85                	lui	s9,0x1
    8000436c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004370:	def43823          	sd	a5,-528(s0)
    80004374:	a4b1                	j	800045c0 <exec+0x33a>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004376:	00004517          	auipc	a0,0x4
    8000437a:	37a50513          	addi	a0,a0,890 # 800086f0 <syscalls+0x2d8>
    8000437e:	00002097          	auipc	ra,0x2
    80004382:	b04080e7          	jalr	-1276(ra) # 80005e82 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)//从文件向pa的物理地址读取n长度的数据(一页或指定长度)
    80004386:	8756                	mv	a4,s5
    80004388:	012d86bb          	addw	a3,s11,s2
    8000438c:	4581                	li	a1,0
    8000438e:	8526                	mv	a0,s1
    80004390:	fffff097          	auipc	ra,0xfffff
    80004394:	c94080e7          	jalr	-876(ra) # 80003024 <readi>
    80004398:	2501                	sext.w	a0,a0
    8000439a:	1caa9763          	bne	s5,a0,80004568 <exec+0x2e2>
  for(i = 0; i < sz; i += PGSIZE){
    8000439e:	6785                	lui	a5,0x1
    800043a0:	0127893b          	addw	s2,a5,s2
    800043a4:	77fd                	lui	a5,0xfffff
    800043a6:	01478a3b          	addw	s4,a5,s4
    800043aa:	21897263          	bgeu	s2,s8,800045ae <exec+0x328>
    pa = walkaddr(pagetable, va + i);
    800043ae:	02091593          	slli	a1,s2,0x20
    800043b2:	9181                	srli	a1,a1,0x20
    800043b4:	95ea                	add	a1,a1,s10
    800043b6:	855e                	mv	a0,s7
    800043b8:	ffffc097          	auipc	ra,0xffffc
    800043bc:	152080e7          	jalr	338(ra) # 8000050a <walkaddr>
    800043c0:	862a                	mv	a2,a0
    if(pa == 0)
    800043c2:	d955                	beqz	a0,80004376 <exec+0xf0>
      n = PGSIZE;
    800043c4:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800043c6:	fd9a70e3          	bgeu	s4,s9,80004386 <exec+0x100>
      n = sz - i;
    800043ca:	8ad2                	mv	s5,s4
    800043cc:	bf6d                	j	80004386 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043ce:	4a01                	li	s4,0
  iunlockput(ip);
    800043d0:	8526                	mv	a0,s1
    800043d2:	fffff097          	auipc	ra,0xfffff
    800043d6:	c00080e7          	jalr	-1024(ra) # 80002fd2 <iunlockput>
  end_op();
    800043da:	fffff097          	auipc	ra,0xfffff
    800043de:	3d8080e7          	jalr	984(ra) # 800037b2 <end_op>
  p = myproc();
    800043e2:	ffffd097          	auipc	ra,0xffffd
    800043e6:	b90080e7          	jalr	-1136(ra) # 80000f72 <myproc>
    800043ea:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043ec:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800043f0:	6785                	lui	a5,0x1
    800043f2:	17fd                	addi	a5,a5,-1
    800043f4:	9a3e                	add	s4,s4,a5
    800043f6:	757d                	lui	a0,0xfffff
    800043f8:	00aa77b3          	and	a5,s4,a0
    800043fc:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004400:	4691                	li	a3,4
    80004402:	6609                	lui	a2,0x2
    80004404:	963e                	add	a2,a2,a5
    80004406:	85be                	mv	a1,a5
    80004408:	855e                	mv	a0,s7
    8000440a:	ffffc097          	auipc	ra,0xffffc
    8000440e:	4b4080e7          	jalr	1204(ra) # 800008be <uvmalloc>
    80004412:	8b2a                	mv	s6,a0
  ip = 0;
    80004414:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004416:	14050963          	beqz	a0,80004568 <exec+0x2e2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000441a:	75f9                	lui	a1,0xffffe
    8000441c:	95aa                	add	a1,a1,a0
    8000441e:	855e                	mv	a0,s7
    80004420:	ffffc097          	auipc	ra,0xffffc
    80004424:	6c4080e7          	jalr	1732(ra) # 80000ae4 <uvmclear>
  stackbase = sp - PGSIZE;
    80004428:	7c7d                	lui	s8,0xfffff
    8000442a:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000442c:	e0043783          	ld	a5,-512(s0)
    80004430:	6388                	ld	a0,0(a5)
    80004432:	c535                	beqz	a0,8000449e <exec+0x218>
    80004434:	e9040993          	addi	s3,s0,-368
    80004438:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000443c:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000443e:	ffffc097          	auipc	ra,0xffffc
    80004442:	ebe080e7          	jalr	-322(ra) # 800002fc <strlen>
    80004446:	2505                	addiw	a0,a0,1
    80004448:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000444c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004450:	15896363          	bltu	s2,s8,80004596 <exec+0x310>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)//把参数放到栈里面
    80004454:	e0043d83          	ld	s11,-512(s0)
    80004458:	000dba03          	ld	s4,0(s11)
    8000445c:	8552                	mv	a0,s4
    8000445e:	ffffc097          	auipc	ra,0xffffc
    80004462:	e9e080e7          	jalr	-354(ra) # 800002fc <strlen>
    80004466:	0015069b          	addiw	a3,a0,1
    8000446a:	8652                	mv	a2,s4
    8000446c:	85ca                	mv	a1,s2
    8000446e:	855e                	mv	a0,s7
    80004470:	ffffc097          	auipc	ra,0xffffc
    80004474:	6a6080e7          	jalr	1702(ra) # 80000b16 <copyout>
    80004478:	12054363          	bltz	a0,8000459e <exec+0x318>
    ustack[argc] = sp;
    8000447c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004480:	0485                	addi	s1,s1,1
    80004482:	008d8793          	addi	a5,s11,8
    80004486:	e0f43023          	sd	a5,-512(s0)
    8000448a:	008db503          	ld	a0,8(s11)
    8000448e:	c911                	beqz	a0,800044a2 <exec+0x21c>
    if(argc >= MAXARG)
    80004490:	09a1                	addi	s3,s3,8
    80004492:	fb3c96e3          	bne	s9,s3,8000443e <exec+0x1b8>
  sz = sz1;
    80004496:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000449a:	4481                	li	s1,0
    8000449c:	a0f1                	j	80004568 <exec+0x2e2>
  sp = sz;
    8000449e:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800044a0:	4481                	li	s1,0
  ustack[argc] = 0;
    800044a2:	00349793          	slli	a5,s1,0x3
    800044a6:	f9040713          	addi	a4,s0,-112
    800044aa:	97ba                	add	a5,a5,a4
    800044ac:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800044b0:	00148693          	addi	a3,s1,1
    800044b4:	068e                	slli	a3,a3,0x3
    800044b6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044ba:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044be:	01897663          	bgeu	s2,s8,800044ca <exec+0x244>
  sz = sz1;
    800044c2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044c6:	4481                	li	s1,0
    800044c8:	a045                	j	80004568 <exec+0x2e2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)//参数地址入栈
    800044ca:	e9040613          	addi	a2,s0,-368
    800044ce:	85ca                	mv	a1,s2
    800044d0:	855e                	mv	a0,s7
    800044d2:	ffffc097          	auipc	ra,0xffffc
    800044d6:	644080e7          	jalr	1604(ra) # 80000b16 <copyout>
    800044da:	0c054663          	bltz	a0,800045a6 <exec+0x320>
  p->trapframe->a1 = sp;
    800044de:	058ab783          	ld	a5,88(s5)
    800044e2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044e6:	df843783          	ld	a5,-520(s0)
    800044ea:	0007c703          	lbu	a4,0(a5)
    800044ee:	cf11                	beqz	a4,8000450a <exec+0x284>
    800044f0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044f2:	02f00693          	li	a3,47
    800044f6:	a039                	j	80004504 <exec+0x27e>
      last = s+1;
    800044f8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044fc:	0785                	addi	a5,a5,1
    800044fe:	fff7c703          	lbu	a4,-1(a5)
    80004502:	c701                	beqz	a4,8000450a <exec+0x284>
    if(*s == '/')
    80004504:	fed71ce3          	bne	a4,a3,800044fc <exec+0x276>
    80004508:	bfc5                	j	800044f8 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    8000450a:	4641                	li	a2,16
    8000450c:	df843583          	ld	a1,-520(s0)
    80004510:	158a8513          	addi	a0,s5,344
    80004514:	ffffc097          	auipc	ra,0xffffc
    80004518:	db6080e7          	jalr	-586(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    8000451c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004520:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004524:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004528:	058ab783          	ld	a5,88(s5)
    8000452c:	e6843703          	ld	a4,-408(s0)
    80004530:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004532:	058ab783          	ld	a5,88(s5)
    80004536:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000453a:	85ea                	mv	a1,s10
    8000453c:	ffffd097          	auipc	ra,0xffffd
    80004540:	bc8080e7          	jalr	-1080(ra) # 80001104 <proc_freepagetable>
  if(p->pid==1)vmprint(p->pagetable,0);
    80004544:	030aa703          	lw	a4,48(s5)
    80004548:	4785                	li	a5,1
    8000454a:	00f70563          	beq	a4,a5,80004554 <exec+0x2ce>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000454e:	0004851b          	sext.w	a0,s1
    80004552:	b3f1                	j	8000431e <exec+0x98>
  if(p->pid==1)vmprint(p->pagetable,0);
    80004554:	4581                	li	a1,0
    80004556:	050ab503          	ld	a0,80(s5)
    8000455a:	ffffc097          	auipc	ra,0xffffc
    8000455e:	7d8080e7          	jalr	2008(ra) # 80000d32 <vmprint>
    80004562:	b7f5                	j	8000454e <exec+0x2c8>
    80004564:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004568:	e0843583          	ld	a1,-504(s0)
    8000456c:	855e                	mv	a0,s7
    8000456e:	ffffd097          	auipc	ra,0xffffd
    80004572:	b96080e7          	jalr	-1130(ra) # 80001104 <proc_freepagetable>
  if(ip){
    80004576:	d8049ae3          	bnez	s1,8000430a <exec+0x84>
  return -1;
    8000457a:	557d                	li	a0,-1
    8000457c:	b34d                	j	8000431e <exec+0x98>
    8000457e:	e1443423          	sd	s4,-504(s0)
    80004582:	b7dd                	j	80004568 <exec+0x2e2>
    80004584:	e1443423          	sd	s4,-504(s0)
    80004588:	b7c5                	j	80004568 <exec+0x2e2>
    8000458a:	e1443423          	sd	s4,-504(s0)
    8000458e:	bfe9                	j	80004568 <exec+0x2e2>
    80004590:	e1443423          	sd	s4,-504(s0)
    80004594:	bfd1                	j	80004568 <exec+0x2e2>
  sz = sz1;
    80004596:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000459a:	4481                	li	s1,0
    8000459c:	b7f1                	j	80004568 <exec+0x2e2>
  sz = sz1;
    8000459e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045a2:	4481                	li	s1,0
    800045a4:	b7d1                	j	80004568 <exec+0x2e2>
  sz = sz1;
    800045a6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045aa:	4481                	li	s1,0
    800045ac:	bf75                	j	80004568 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045ae:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045b2:	2b05                	addiw	s6,s6,1
    800045b4:	0389899b          	addiw	s3,s3,56
    800045b8:	e8845783          	lhu	a5,-376(s0)
    800045bc:	e0fb5ae3          	bge	s6,a5,800043d0 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045c0:	2981                	sext.w	s3,s3
    800045c2:	03800713          	li	a4,56
    800045c6:	86ce                	mv	a3,s3
    800045c8:	e1840613          	addi	a2,s0,-488
    800045cc:	4581                	li	a1,0
    800045ce:	8526                	mv	a0,s1
    800045d0:	fffff097          	auipc	ra,0xfffff
    800045d4:	a54080e7          	jalr	-1452(ra) # 80003024 <readi>
    800045d8:	03800793          	li	a5,56
    800045dc:	f8f514e3          	bne	a0,a5,80004564 <exec+0x2de>
    if(ph.type != ELF_PROG_LOAD)
    800045e0:	e1842783          	lw	a5,-488(s0)
    800045e4:	4705                	li	a4,1
    800045e6:	fce796e3          	bne	a5,a4,800045b2 <exec+0x32c>
    if(ph.memsz < ph.filesz)
    800045ea:	e4043903          	ld	s2,-448(s0)
    800045ee:	e3843783          	ld	a5,-456(s0)
    800045f2:	f8f966e3          	bltu	s2,a5,8000457e <exec+0x2f8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045f6:	e2843783          	ld	a5,-472(s0)
    800045fa:	993e                	add	s2,s2,a5
    800045fc:	f8f964e3          	bltu	s2,a5,80004584 <exec+0x2fe>
    if(ph.vaddr % PGSIZE != 0)
    80004600:	df043703          	ld	a4,-528(s0)
    80004604:	8ff9                	and	a5,a5,a4
    80004606:	f3d1                	bnez	a5,8000458a <exec+0x304>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004608:	e1c42503          	lw	a0,-484(s0)
    8000460c:	00000097          	auipc	ra,0x0
    80004610:	c5e080e7          	jalr	-930(ra) # 8000426a <flags2perm>
    80004614:	86aa                	mv	a3,a0
    80004616:	864a                	mv	a2,s2
    80004618:	85d2                	mv	a1,s4
    8000461a:	855e                	mv	a0,s7
    8000461c:	ffffc097          	auipc	ra,0xffffc
    80004620:	2a2080e7          	jalr	674(ra) # 800008be <uvmalloc>
    80004624:	e0a43423          	sd	a0,-504(s0)
    80004628:	d525                	beqz	a0,80004590 <exec+0x30a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000462a:	e2843d03          	ld	s10,-472(s0)
    8000462e:	e2042d83          	lw	s11,-480(s0)
    80004632:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004636:	f60c0ce3          	beqz	s8,800045ae <exec+0x328>
    8000463a:	8a62                	mv	s4,s8
    8000463c:	4901                	li	s2,0
    8000463e:	bb85                	j	800043ae <exec+0x128>

0000000080004640 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004640:	7179                	addi	sp,sp,-48
    80004642:	f406                	sd	ra,40(sp)
    80004644:	f022                	sd	s0,32(sp)
    80004646:	ec26                	sd	s1,24(sp)
    80004648:	e84a                	sd	s2,16(sp)
    8000464a:	1800                	addi	s0,sp,48
    8000464c:	892e                	mv	s2,a1
    8000464e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004650:	fdc40593          	addi	a1,s0,-36
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	ac8080e7          	jalr	-1336(ra) # 8000211c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000465c:	fdc42703          	lw	a4,-36(s0)
    80004660:	47bd                	li	a5,15
    80004662:	02e7eb63          	bltu	a5,a4,80004698 <argfd+0x58>
    80004666:	ffffd097          	auipc	ra,0xffffd
    8000466a:	90c080e7          	jalr	-1780(ra) # 80000f72 <myproc>
    8000466e:	fdc42703          	lw	a4,-36(s0)
    80004672:	01a70793          	addi	a5,a4,26
    80004676:	078e                	slli	a5,a5,0x3
    80004678:	953e                	add	a0,a0,a5
    8000467a:	611c                	ld	a5,0(a0)
    8000467c:	c385                	beqz	a5,8000469c <argfd+0x5c>
    return -1;
  if(pfd)
    8000467e:	00090463          	beqz	s2,80004686 <argfd+0x46>
    *pfd = fd;
    80004682:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004686:	4501                	li	a0,0
  if(pf)
    80004688:	c091                	beqz	s1,8000468c <argfd+0x4c>
    *pf = f;
    8000468a:	e09c                	sd	a5,0(s1)
}
    8000468c:	70a2                	ld	ra,40(sp)
    8000468e:	7402                	ld	s0,32(sp)
    80004690:	64e2                	ld	s1,24(sp)
    80004692:	6942                	ld	s2,16(sp)
    80004694:	6145                	addi	sp,sp,48
    80004696:	8082                	ret
    return -1;
    80004698:	557d                	li	a0,-1
    8000469a:	bfcd                	j	8000468c <argfd+0x4c>
    8000469c:	557d                	li	a0,-1
    8000469e:	b7fd                	j	8000468c <argfd+0x4c>

00000000800046a0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046a0:	1101                	addi	sp,sp,-32
    800046a2:	ec06                	sd	ra,24(sp)
    800046a4:	e822                	sd	s0,16(sp)
    800046a6:	e426                	sd	s1,8(sp)
    800046a8:	1000                	addi	s0,sp,32
    800046aa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046ac:	ffffd097          	auipc	ra,0xffffd
    800046b0:	8c6080e7          	jalr	-1850(ra) # 80000f72 <myproc>
    800046b4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046b6:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd0e0>
    800046ba:	4501                	li	a0,0
    800046bc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046be:	6398                	ld	a4,0(a5)
    800046c0:	cb19                	beqz	a4,800046d6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046c2:	2505                	addiw	a0,a0,1
    800046c4:	07a1                	addi	a5,a5,8
    800046c6:	fed51ce3          	bne	a0,a3,800046be <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046ca:	557d                	li	a0,-1
}
    800046cc:	60e2                	ld	ra,24(sp)
    800046ce:	6442                	ld	s0,16(sp)
    800046d0:	64a2                	ld	s1,8(sp)
    800046d2:	6105                	addi	sp,sp,32
    800046d4:	8082                	ret
      p->ofile[fd] = f;
    800046d6:	01a50793          	addi	a5,a0,26
    800046da:	078e                	slli	a5,a5,0x3
    800046dc:	963e                	add	a2,a2,a5
    800046de:	e204                	sd	s1,0(a2)
      return fd;
    800046e0:	b7f5                	j	800046cc <fdalloc+0x2c>

00000000800046e2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046e2:	715d                	addi	sp,sp,-80
    800046e4:	e486                	sd	ra,72(sp)
    800046e6:	e0a2                	sd	s0,64(sp)
    800046e8:	fc26                	sd	s1,56(sp)
    800046ea:	f84a                	sd	s2,48(sp)
    800046ec:	f44e                	sd	s3,40(sp)
    800046ee:	f052                	sd	s4,32(sp)
    800046f0:	ec56                	sd	s5,24(sp)
    800046f2:	e85a                	sd	s6,16(sp)
    800046f4:	0880                	addi	s0,sp,80
    800046f6:	8b2e                	mv	s6,a1
    800046f8:	89b2                	mv	s3,a2
    800046fa:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046fc:	fb040593          	addi	a1,s0,-80
    80004700:	fffff097          	auipc	ra,0xfffff
    80004704:	e34080e7          	jalr	-460(ra) # 80003534 <nameiparent>
    80004708:	84aa                	mv	s1,a0
    8000470a:	16050063          	beqz	a0,8000486a <create+0x188>
    return 0;

  ilock(dp);
    8000470e:	ffffe097          	auipc	ra,0xffffe
    80004712:	662080e7          	jalr	1634(ra) # 80002d70 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004716:	4601                	li	a2,0
    80004718:	fb040593          	addi	a1,s0,-80
    8000471c:	8526                	mv	a0,s1
    8000471e:	fffff097          	auipc	ra,0xfffff
    80004722:	b36080e7          	jalr	-1226(ra) # 80003254 <dirlookup>
    80004726:	8aaa                	mv	s5,a0
    80004728:	c931                	beqz	a0,8000477c <create+0x9a>
    iunlockput(dp);
    8000472a:	8526                	mv	a0,s1
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	8a6080e7          	jalr	-1882(ra) # 80002fd2 <iunlockput>
    ilock(ip);
    80004734:	8556                	mv	a0,s5
    80004736:	ffffe097          	auipc	ra,0xffffe
    8000473a:	63a080e7          	jalr	1594(ra) # 80002d70 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000473e:	000b059b          	sext.w	a1,s6
    80004742:	4789                	li	a5,2
    80004744:	02f59563          	bne	a1,a5,8000476e <create+0x8c>
    80004748:	044ad783          	lhu	a5,68(s5)
    8000474c:	37f9                	addiw	a5,a5,-2
    8000474e:	17c2                	slli	a5,a5,0x30
    80004750:	93c1                	srli	a5,a5,0x30
    80004752:	4705                	li	a4,1
    80004754:	00f76d63          	bltu	a4,a5,8000476e <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004758:	8556                	mv	a0,s5
    8000475a:	60a6                	ld	ra,72(sp)
    8000475c:	6406                	ld	s0,64(sp)
    8000475e:	74e2                	ld	s1,56(sp)
    80004760:	7942                	ld	s2,48(sp)
    80004762:	79a2                	ld	s3,40(sp)
    80004764:	7a02                	ld	s4,32(sp)
    80004766:	6ae2                	ld	s5,24(sp)
    80004768:	6b42                	ld	s6,16(sp)
    8000476a:	6161                	addi	sp,sp,80
    8000476c:	8082                	ret
    iunlockput(ip);
    8000476e:	8556                	mv	a0,s5
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	862080e7          	jalr	-1950(ra) # 80002fd2 <iunlockput>
    return 0;
    80004778:	4a81                	li	s5,0
    8000477a:	bff9                	j	80004758 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000477c:	85da                	mv	a1,s6
    8000477e:	4088                	lw	a0,0(s1)
    80004780:	ffffe097          	auipc	ra,0xffffe
    80004784:	454080e7          	jalr	1108(ra) # 80002bd4 <ialloc>
    80004788:	8a2a                	mv	s4,a0
    8000478a:	c921                	beqz	a0,800047da <create+0xf8>
  ilock(ip);
    8000478c:	ffffe097          	auipc	ra,0xffffe
    80004790:	5e4080e7          	jalr	1508(ra) # 80002d70 <ilock>
  ip->major = major;
    80004794:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004798:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000479c:	4785                	li	a5,1
    8000479e:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800047a2:	8552                	mv	a0,s4
    800047a4:	ffffe097          	auipc	ra,0xffffe
    800047a8:	502080e7          	jalr	1282(ra) # 80002ca6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047ac:	000b059b          	sext.w	a1,s6
    800047b0:	4785                	li	a5,1
    800047b2:	02f58b63          	beq	a1,a5,800047e8 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    800047b6:	004a2603          	lw	a2,4(s4)
    800047ba:	fb040593          	addi	a1,s0,-80
    800047be:	8526                	mv	a0,s1
    800047c0:	fffff097          	auipc	ra,0xfffff
    800047c4:	ca4080e7          	jalr	-860(ra) # 80003464 <dirlink>
    800047c8:	06054f63          	bltz	a0,80004846 <create+0x164>
  iunlockput(dp);
    800047cc:	8526                	mv	a0,s1
    800047ce:	fffff097          	auipc	ra,0xfffff
    800047d2:	804080e7          	jalr	-2044(ra) # 80002fd2 <iunlockput>
  return ip;
    800047d6:	8ad2                	mv	s5,s4
    800047d8:	b741                	j	80004758 <create+0x76>
    iunlockput(dp);
    800047da:	8526                	mv	a0,s1
    800047dc:	ffffe097          	auipc	ra,0xffffe
    800047e0:	7f6080e7          	jalr	2038(ra) # 80002fd2 <iunlockput>
    return 0;
    800047e4:	8ad2                	mv	s5,s4
    800047e6:	bf8d                	j	80004758 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047e8:	004a2603          	lw	a2,4(s4)
    800047ec:	00004597          	auipc	a1,0x4
    800047f0:	f2458593          	addi	a1,a1,-220 # 80008710 <syscalls+0x2f8>
    800047f4:	8552                	mv	a0,s4
    800047f6:	fffff097          	auipc	ra,0xfffff
    800047fa:	c6e080e7          	jalr	-914(ra) # 80003464 <dirlink>
    800047fe:	04054463          	bltz	a0,80004846 <create+0x164>
    80004802:	40d0                	lw	a2,4(s1)
    80004804:	00004597          	auipc	a1,0x4
    80004808:	95c58593          	addi	a1,a1,-1700 # 80008160 <etext+0x160>
    8000480c:	8552                	mv	a0,s4
    8000480e:	fffff097          	auipc	ra,0xfffff
    80004812:	c56080e7          	jalr	-938(ra) # 80003464 <dirlink>
    80004816:	02054863          	bltz	a0,80004846 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    8000481a:	004a2603          	lw	a2,4(s4)
    8000481e:	fb040593          	addi	a1,s0,-80
    80004822:	8526                	mv	a0,s1
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	c40080e7          	jalr	-960(ra) # 80003464 <dirlink>
    8000482c:	00054d63          	bltz	a0,80004846 <create+0x164>
    dp->nlink++;  // for ".."
    80004830:	04a4d783          	lhu	a5,74(s1)
    80004834:	2785                	addiw	a5,a5,1
    80004836:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000483a:	8526                	mv	a0,s1
    8000483c:	ffffe097          	auipc	ra,0xffffe
    80004840:	46a080e7          	jalr	1130(ra) # 80002ca6 <iupdate>
    80004844:	b761                	j	800047cc <create+0xea>
  ip->nlink = 0;
    80004846:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000484a:	8552                	mv	a0,s4
    8000484c:	ffffe097          	auipc	ra,0xffffe
    80004850:	45a080e7          	jalr	1114(ra) # 80002ca6 <iupdate>
  iunlockput(ip);
    80004854:	8552                	mv	a0,s4
    80004856:	ffffe097          	auipc	ra,0xffffe
    8000485a:	77c080e7          	jalr	1916(ra) # 80002fd2 <iunlockput>
  iunlockput(dp);
    8000485e:	8526                	mv	a0,s1
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	772080e7          	jalr	1906(ra) # 80002fd2 <iunlockput>
  return 0;
    80004868:	bdc5                	j	80004758 <create+0x76>
    return 0;
    8000486a:	8aaa                	mv	s5,a0
    8000486c:	b5f5                	j	80004758 <create+0x76>

000000008000486e <sys_dup>:
{
    8000486e:	7179                	addi	sp,sp,-48
    80004870:	f406                	sd	ra,40(sp)
    80004872:	f022                	sd	s0,32(sp)
    80004874:	ec26                	sd	s1,24(sp)
    80004876:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004878:	fd840613          	addi	a2,s0,-40
    8000487c:	4581                	li	a1,0
    8000487e:	4501                	li	a0,0
    80004880:	00000097          	auipc	ra,0x0
    80004884:	dc0080e7          	jalr	-576(ra) # 80004640 <argfd>
    return -1;
    80004888:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000488a:	02054363          	bltz	a0,800048b0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000488e:	fd843503          	ld	a0,-40(s0)
    80004892:	00000097          	auipc	ra,0x0
    80004896:	e0e080e7          	jalr	-498(ra) # 800046a0 <fdalloc>
    8000489a:	84aa                	mv	s1,a0
    return -1;
    8000489c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000489e:	00054963          	bltz	a0,800048b0 <sys_dup+0x42>
  filedup(f);
    800048a2:	fd843503          	ld	a0,-40(s0)
    800048a6:	fffff097          	auipc	ra,0xfffff
    800048aa:	306080e7          	jalr	774(ra) # 80003bac <filedup>
  return fd;
    800048ae:	87a6                	mv	a5,s1
}
    800048b0:	853e                	mv	a0,a5
    800048b2:	70a2                	ld	ra,40(sp)
    800048b4:	7402                	ld	s0,32(sp)
    800048b6:	64e2                	ld	s1,24(sp)
    800048b8:	6145                	addi	sp,sp,48
    800048ba:	8082                	ret

00000000800048bc <sys_read>:
{
    800048bc:	7179                	addi	sp,sp,-48
    800048be:	f406                	sd	ra,40(sp)
    800048c0:	f022                	sd	s0,32(sp)
    800048c2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048c4:	fd840593          	addi	a1,s0,-40
    800048c8:	4505                	li	a0,1
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	872080e7          	jalr	-1934(ra) # 8000213c <argaddr>
  argint(2, &n);
    800048d2:	fe440593          	addi	a1,s0,-28
    800048d6:	4509                	li	a0,2
    800048d8:	ffffe097          	auipc	ra,0xffffe
    800048dc:	844080e7          	jalr	-1980(ra) # 8000211c <argint>
  if(argfd(0, 0, &f) < 0)
    800048e0:	fe840613          	addi	a2,s0,-24
    800048e4:	4581                	li	a1,0
    800048e6:	4501                	li	a0,0
    800048e8:	00000097          	auipc	ra,0x0
    800048ec:	d58080e7          	jalr	-680(ra) # 80004640 <argfd>
    800048f0:	87aa                	mv	a5,a0
    return -1;
    800048f2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048f4:	0007cc63          	bltz	a5,8000490c <sys_read+0x50>
  return fileread(f, p, n);
    800048f8:	fe442603          	lw	a2,-28(s0)
    800048fc:	fd843583          	ld	a1,-40(s0)
    80004900:	fe843503          	ld	a0,-24(s0)
    80004904:	fffff097          	auipc	ra,0xfffff
    80004908:	434080e7          	jalr	1076(ra) # 80003d38 <fileread>
}
    8000490c:	70a2                	ld	ra,40(sp)
    8000490e:	7402                	ld	s0,32(sp)
    80004910:	6145                	addi	sp,sp,48
    80004912:	8082                	ret

0000000080004914 <sys_write>:
{
    80004914:	7179                	addi	sp,sp,-48
    80004916:	f406                	sd	ra,40(sp)
    80004918:	f022                	sd	s0,32(sp)
    8000491a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000491c:	fd840593          	addi	a1,s0,-40
    80004920:	4505                	li	a0,1
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	81a080e7          	jalr	-2022(ra) # 8000213c <argaddr>
  argint(2, &n);
    8000492a:	fe440593          	addi	a1,s0,-28
    8000492e:	4509                	li	a0,2
    80004930:	ffffd097          	auipc	ra,0xffffd
    80004934:	7ec080e7          	jalr	2028(ra) # 8000211c <argint>
  if(argfd(0, 0, &f) < 0)
    80004938:	fe840613          	addi	a2,s0,-24
    8000493c:	4581                	li	a1,0
    8000493e:	4501                	li	a0,0
    80004940:	00000097          	auipc	ra,0x0
    80004944:	d00080e7          	jalr	-768(ra) # 80004640 <argfd>
    80004948:	87aa                	mv	a5,a0
    return -1;
    8000494a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000494c:	0007cc63          	bltz	a5,80004964 <sys_write+0x50>
  return filewrite(f, p, n);
    80004950:	fe442603          	lw	a2,-28(s0)
    80004954:	fd843583          	ld	a1,-40(s0)
    80004958:	fe843503          	ld	a0,-24(s0)
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	49e080e7          	jalr	1182(ra) # 80003dfa <filewrite>
}
    80004964:	70a2                	ld	ra,40(sp)
    80004966:	7402                	ld	s0,32(sp)
    80004968:	6145                	addi	sp,sp,48
    8000496a:	8082                	ret

000000008000496c <sys_close>:
{
    8000496c:	1101                	addi	sp,sp,-32
    8000496e:	ec06                	sd	ra,24(sp)
    80004970:	e822                	sd	s0,16(sp)
    80004972:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004974:	fe040613          	addi	a2,s0,-32
    80004978:	fec40593          	addi	a1,s0,-20
    8000497c:	4501                	li	a0,0
    8000497e:	00000097          	auipc	ra,0x0
    80004982:	cc2080e7          	jalr	-830(ra) # 80004640 <argfd>
    return -1;
    80004986:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004988:	02054463          	bltz	a0,800049b0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000498c:	ffffc097          	auipc	ra,0xffffc
    80004990:	5e6080e7          	jalr	1510(ra) # 80000f72 <myproc>
    80004994:	fec42783          	lw	a5,-20(s0)
    80004998:	07e9                	addi	a5,a5,26
    8000499a:	078e                	slli	a5,a5,0x3
    8000499c:	97aa                	add	a5,a5,a0
    8000499e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800049a2:	fe043503          	ld	a0,-32(s0)
    800049a6:	fffff097          	auipc	ra,0xfffff
    800049aa:	258080e7          	jalr	600(ra) # 80003bfe <fileclose>
  return 0;
    800049ae:	4781                	li	a5,0
}
    800049b0:	853e                	mv	a0,a5
    800049b2:	60e2                	ld	ra,24(sp)
    800049b4:	6442                	ld	s0,16(sp)
    800049b6:	6105                	addi	sp,sp,32
    800049b8:	8082                	ret

00000000800049ba <sys_fstat>:
{
    800049ba:	1101                	addi	sp,sp,-32
    800049bc:	ec06                	sd	ra,24(sp)
    800049be:	e822                	sd	s0,16(sp)
    800049c0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049c2:	fe040593          	addi	a1,s0,-32
    800049c6:	4505                	li	a0,1
    800049c8:	ffffd097          	auipc	ra,0xffffd
    800049cc:	774080e7          	jalr	1908(ra) # 8000213c <argaddr>
  if(argfd(0, 0, &f) < 0)
    800049d0:	fe840613          	addi	a2,s0,-24
    800049d4:	4581                	li	a1,0
    800049d6:	4501                	li	a0,0
    800049d8:	00000097          	auipc	ra,0x0
    800049dc:	c68080e7          	jalr	-920(ra) # 80004640 <argfd>
    800049e0:	87aa                	mv	a5,a0
    return -1;
    800049e2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049e4:	0007ca63          	bltz	a5,800049f8 <sys_fstat+0x3e>
  return filestat(f, st);
    800049e8:	fe043583          	ld	a1,-32(s0)
    800049ec:	fe843503          	ld	a0,-24(s0)
    800049f0:	fffff097          	auipc	ra,0xfffff
    800049f4:	2d6080e7          	jalr	726(ra) # 80003cc6 <filestat>
}
    800049f8:	60e2                	ld	ra,24(sp)
    800049fa:	6442                	ld	s0,16(sp)
    800049fc:	6105                	addi	sp,sp,32
    800049fe:	8082                	ret

0000000080004a00 <sys_link>:
{
    80004a00:	7169                	addi	sp,sp,-304
    80004a02:	f606                	sd	ra,296(sp)
    80004a04:	f222                	sd	s0,288(sp)
    80004a06:	ee26                	sd	s1,280(sp)
    80004a08:	ea4a                	sd	s2,272(sp)
    80004a0a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a0c:	08000613          	li	a2,128
    80004a10:	ed040593          	addi	a1,s0,-304
    80004a14:	4501                	li	a0,0
    80004a16:	ffffd097          	auipc	ra,0xffffd
    80004a1a:	746080e7          	jalr	1862(ra) # 8000215c <argstr>
    return -1;
    80004a1e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a20:	10054e63          	bltz	a0,80004b3c <sys_link+0x13c>
    80004a24:	08000613          	li	a2,128
    80004a28:	f5040593          	addi	a1,s0,-176
    80004a2c:	4505                	li	a0,1
    80004a2e:	ffffd097          	auipc	ra,0xffffd
    80004a32:	72e080e7          	jalr	1838(ra) # 8000215c <argstr>
    return -1;
    80004a36:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a38:	10054263          	bltz	a0,80004b3c <sys_link+0x13c>
  begin_op();
    80004a3c:	fffff097          	auipc	ra,0xfffff
    80004a40:	cf6080e7          	jalr	-778(ra) # 80003732 <begin_op>
  if((ip = namei(old)) == 0){
    80004a44:	ed040513          	addi	a0,s0,-304
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	ace080e7          	jalr	-1330(ra) # 80003516 <namei>
    80004a50:	84aa                	mv	s1,a0
    80004a52:	c551                	beqz	a0,80004ade <sys_link+0xde>
  ilock(ip);
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	31c080e7          	jalr	796(ra) # 80002d70 <ilock>
  if(ip->type == T_DIR){
    80004a5c:	04449703          	lh	a4,68(s1)
    80004a60:	4785                	li	a5,1
    80004a62:	08f70463          	beq	a4,a5,80004aea <sys_link+0xea>
  ip->nlink++;
    80004a66:	04a4d783          	lhu	a5,74(s1)
    80004a6a:	2785                	addiw	a5,a5,1
    80004a6c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a70:	8526                	mv	a0,s1
    80004a72:	ffffe097          	auipc	ra,0xffffe
    80004a76:	234080e7          	jalr	564(ra) # 80002ca6 <iupdate>
  iunlock(ip);
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	3b6080e7          	jalr	950(ra) # 80002e32 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a84:	fd040593          	addi	a1,s0,-48
    80004a88:	f5040513          	addi	a0,s0,-176
    80004a8c:	fffff097          	auipc	ra,0xfffff
    80004a90:	aa8080e7          	jalr	-1368(ra) # 80003534 <nameiparent>
    80004a94:	892a                	mv	s2,a0
    80004a96:	c935                	beqz	a0,80004b0a <sys_link+0x10a>
  ilock(dp);
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	2d8080e7          	jalr	728(ra) # 80002d70 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004aa0:	00092703          	lw	a4,0(s2)
    80004aa4:	409c                	lw	a5,0(s1)
    80004aa6:	04f71d63          	bne	a4,a5,80004b00 <sys_link+0x100>
    80004aaa:	40d0                	lw	a2,4(s1)
    80004aac:	fd040593          	addi	a1,s0,-48
    80004ab0:	854a                	mv	a0,s2
    80004ab2:	fffff097          	auipc	ra,0xfffff
    80004ab6:	9b2080e7          	jalr	-1614(ra) # 80003464 <dirlink>
    80004aba:	04054363          	bltz	a0,80004b00 <sys_link+0x100>
  iunlockput(dp);
    80004abe:	854a                	mv	a0,s2
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	512080e7          	jalr	1298(ra) # 80002fd2 <iunlockput>
  iput(ip);
    80004ac8:	8526                	mv	a0,s1
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	460080e7          	jalr	1120(ra) # 80002f2a <iput>
  end_op();
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	ce0080e7          	jalr	-800(ra) # 800037b2 <end_op>
  return 0;
    80004ada:	4781                	li	a5,0
    80004adc:	a085                	j	80004b3c <sys_link+0x13c>
    end_op();
    80004ade:	fffff097          	auipc	ra,0xfffff
    80004ae2:	cd4080e7          	jalr	-812(ra) # 800037b2 <end_op>
    return -1;
    80004ae6:	57fd                	li	a5,-1
    80004ae8:	a891                	j	80004b3c <sys_link+0x13c>
    iunlockput(ip);
    80004aea:	8526                	mv	a0,s1
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	4e6080e7          	jalr	1254(ra) # 80002fd2 <iunlockput>
    end_op();
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	cbe080e7          	jalr	-834(ra) # 800037b2 <end_op>
    return -1;
    80004afc:	57fd                	li	a5,-1
    80004afe:	a83d                	j	80004b3c <sys_link+0x13c>
    iunlockput(dp);
    80004b00:	854a                	mv	a0,s2
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	4d0080e7          	jalr	1232(ra) # 80002fd2 <iunlockput>
  ilock(ip);
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	264080e7          	jalr	612(ra) # 80002d70 <ilock>
  ip->nlink--;
    80004b14:	04a4d783          	lhu	a5,74(s1)
    80004b18:	37fd                	addiw	a5,a5,-1
    80004b1a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b1e:	8526                	mv	a0,s1
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	186080e7          	jalr	390(ra) # 80002ca6 <iupdate>
  iunlockput(ip);
    80004b28:	8526                	mv	a0,s1
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	4a8080e7          	jalr	1192(ra) # 80002fd2 <iunlockput>
  end_op();
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	c80080e7          	jalr	-896(ra) # 800037b2 <end_op>
  return -1;
    80004b3a:	57fd                	li	a5,-1
}
    80004b3c:	853e                	mv	a0,a5
    80004b3e:	70b2                	ld	ra,296(sp)
    80004b40:	7412                	ld	s0,288(sp)
    80004b42:	64f2                	ld	s1,280(sp)
    80004b44:	6952                	ld	s2,272(sp)
    80004b46:	6155                	addi	sp,sp,304
    80004b48:	8082                	ret

0000000080004b4a <sys_unlink>:
{
    80004b4a:	7151                	addi	sp,sp,-240
    80004b4c:	f586                	sd	ra,232(sp)
    80004b4e:	f1a2                	sd	s0,224(sp)
    80004b50:	eda6                	sd	s1,216(sp)
    80004b52:	e9ca                	sd	s2,208(sp)
    80004b54:	e5ce                	sd	s3,200(sp)
    80004b56:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b58:	08000613          	li	a2,128
    80004b5c:	f3040593          	addi	a1,s0,-208
    80004b60:	4501                	li	a0,0
    80004b62:	ffffd097          	auipc	ra,0xffffd
    80004b66:	5fa080e7          	jalr	1530(ra) # 8000215c <argstr>
    80004b6a:	18054163          	bltz	a0,80004cec <sys_unlink+0x1a2>
  begin_op();
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	bc4080e7          	jalr	-1084(ra) # 80003732 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b76:	fb040593          	addi	a1,s0,-80
    80004b7a:	f3040513          	addi	a0,s0,-208
    80004b7e:	fffff097          	auipc	ra,0xfffff
    80004b82:	9b6080e7          	jalr	-1610(ra) # 80003534 <nameiparent>
    80004b86:	84aa                	mv	s1,a0
    80004b88:	c979                	beqz	a0,80004c5e <sys_unlink+0x114>
  ilock(dp);
    80004b8a:	ffffe097          	auipc	ra,0xffffe
    80004b8e:	1e6080e7          	jalr	486(ra) # 80002d70 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b92:	00004597          	auipc	a1,0x4
    80004b96:	b7e58593          	addi	a1,a1,-1154 # 80008710 <syscalls+0x2f8>
    80004b9a:	fb040513          	addi	a0,s0,-80
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	69c080e7          	jalr	1692(ra) # 8000323a <namecmp>
    80004ba6:	14050a63          	beqz	a0,80004cfa <sys_unlink+0x1b0>
    80004baa:	00003597          	auipc	a1,0x3
    80004bae:	5b658593          	addi	a1,a1,1462 # 80008160 <etext+0x160>
    80004bb2:	fb040513          	addi	a0,s0,-80
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	684080e7          	jalr	1668(ra) # 8000323a <namecmp>
    80004bbe:	12050e63          	beqz	a0,80004cfa <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bc2:	f2c40613          	addi	a2,s0,-212
    80004bc6:	fb040593          	addi	a1,s0,-80
    80004bca:	8526                	mv	a0,s1
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	688080e7          	jalr	1672(ra) # 80003254 <dirlookup>
    80004bd4:	892a                	mv	s2,a0
    80004bd6:	12050263          	beqz	a0,80004cfa <sys_unlink+0x1b0>
  ilock(ip);
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	196080e7          	jalr	406(ra) # 80002d70 <ilock>
  if(ip->nlink < 1)
    80004be2:	04a91783          	lh	a5,74(s2)
    80004be6:	08f05263          	blez	a5,80004c6a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bea:	04491703          	lh	a4,68(s2)
    80004bee:	4785                	li	a5,1
    80004bf0:	08f70563          	beq	a4,a5,80004c7a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bf4:	4641                	li	a2,16
    80004bf6:	4581                	li	a1,0
    80004bf8:	fc040513          	addi	a0,s0,-64
    80004bfc:	ffffb097          	auipc	ra,0xffffb
    80004c00:	57c080e7          	jalr	1404(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c04:	4741                	li	a4,16
    80004c06:	f2c42683          	lw	a3,-212(s0)
    80004c0a:	fc040613          	addi	a2,s0,-64
    80004c0e:	4581                	li	a1,0
    80004c10:	8526                	mv	a0,s1
    80004c12:	ffffe097          	auipc	ra,0xffffe
    80004c16:	50a080e7          	jalr	1290(ra) # 8000311c <writei>
    80004c1a:	47c1                	li	a5,16
    80004c1c:	0af51563          	bne	a0,a5,80004cc6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c20:	04491703          	lh	a4,68(s2)
    80004c24:	4785                	li	a5,1
    80004c26:	0af70863          	beq	a4,a5,80004cd6 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c2a:	8526                	mv	a0,s1
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	3a6080e7          	jalr	934(ra) # 80002fd2 <iunlockput>
  ip->nlink--;
    80004c34:	04a95783          	lhu	a5,74(s2)
    80004c38:	37fd                	addiw	a5,a5,-1
    80004c3a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c3e:	854a                	mv	a0,s2
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	066080e7          	jalr	102(ra) # 80002ca6 <iupdate>
  iunlockput(ip);
    80004c48:	854a                	mv	a0,s2
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	388080e7          	jalr	904(ra) # 80002fd2 <iunlockput>
  end_op();
    80004c52:	fffff097          	auipc	ra,0xfffff
    80004c56:	b60080e7          	jalr	-1184(ra) # 800037b2 <end_op>
  return 0;
    80004c5a:	4501                	li	a0,0
    80004c5c:	a84d                	j	80004d0e <sys_unlink+0x1c4>
    end_op();
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	b54080e7          	jalr	-1196(ra) # 800037b2 <end_op>
    return -1;
    80004c66:	557d                	li	a0,-1
    80004c68:	a05d                	j	80004d0e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c6a:	00004517          	auipc	a0,0x4
    80004c6e:	aae50513          	addi	a0,a0,-1362 # 80008718 <syscalls+0x300>
    80004c72:	00001097          	auipc	ra,0x1
    80004c76:	210080e7          	jalr	528(ra) # 80005e82 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c7a:	04c92703          	lw	a4,76(s2)
    80004c7e:	02000793          	li	a5,32
    80004c82:	f6e7f9e3          	bgeu	a5,a4,80004bf4 <sys_unlink+0xaa>
    80004c86:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c8a:	4741                	li	a4,16
    80004c8c:	86ce                	mv	a3,s3
    80004c8e:	f1840613          	addi	a2,s0,-232
    80004c92:	4581                	li	a1,0
    80004c94:	854a                	mv	a0,s2
    80004c96:	ffffe097          	auipc	ra,0xffffe
    80004c9a:	38e080e7          	jalr	910(ra) # 80003024 <readi>
    80004c9e:	47c1                	li	a5,16
    80004ca0:	00f51b63          	bne	a0,a5,80004cb6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ca4:	f1845783          	lhu	a5,-232(s0)
    80004ca8:	e7a1                	bnez	a5,80004cf0 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004caa:	29c1                	addiw	s3,s3,16
    80004cac:	04c92783          	lw	a5,76(s2)
    80004cb0:	fcf9ede3          	bltu	s3,a5,80004c8a <sys_unlink+0x140>
    80004cb4:	b781                	j	80004bf4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cb6:	00004517          	auipc	a0,0x4
    80004cba:	a7a50513          	addi	a0,a0,-1414 # 80008730 <syscalls+0x318>
    80004cbe:	00001097          	auipc	ra,0x1
    80004cc2:	1c4080e7          	jalr	452(ra) # 80005e82 <panic>
    panic("unlink: writei");
    80004cc6:	00004517          	auipc	a0,0x4
    80004cca:	a8250513          	addi	a0,a0,-1406 # 80008748 <syscalls+0x330>
    80004cce:	00001097          	auipc	ra,0x1
    80004cd2:	1b4080e7          	jalr	436(ra) # 80005e82 <panic>
    dp->nlink--;
    80004cd6:	04a4d783          	lhu	a5,74(s1)
    80004cda:	37fd                	addiw	a5,a5,-1
    80004cdc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ce0:	8526                	mv	a0,s1
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	fc4080e7          	jalr	-60(ra) # 80002ca6 <iupdate>
    80004cea:	b781                	j	80004c2a <sys_unlink+0xe0>
    return -1;
    80004cec:	557d                	li	a0,-1
    80004cee:	a005                	j	80004d0e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cf0:	854a                	mv	a0,s2
    80004cf2:	ffffe097          	auipc	ra,0xffffe
    80004cf6:	2e0080e7          	jalr	736(ra) # 80002fd2 <iunlockput>
  iunlockput(dp);
    80004cfa:	8526                	mv	a0,s1
    80004cfc:	ffffe097          	auipc	ra,0xffffe
    80004d00:	2d6080e7          	jalr	726(ra) # 80002fd2 <iunlockput>
  end_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	aae080e7          	jalr	-1362(ra) # 800037b2 <end_op>
  return -1;
    80004d0c:	557d                	li	a0,-1
}
    80004d0e:	70ae                	ld	ra,232(sp)
    80004d10:	740e                	ld	s0,224(sp)
    80004d12:	64ee                	ld	s1,216(sp)
    80004d14:	694e                	ld	s2,208(sp)
    80004d16:	69ae                	ld	s3,200(sp)
    80004d18:	616d                	addi	sp,sp,240
    80004d1a:	8082                	ret

0000000080004d1c <sys_open>:

uint64
sys_open(void)
{
    80004d1c:	7131                	addi	sp,sp,-192
    80004d1e:	fd06                	sd	ra,184(sp)
    80004d20:	f922                	sd	s0,176(sp)
    80004d22:	f526                	sd	s1,168(sp)
    80004d24:	f14a                	sd	s2,160(sp)
    80004d26:	ed4e                	sd	s3,152(sp)
    80004d28:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d2a:	f4c40593          	addi	a1,s0,-180
    80004d2e:	4505                	li	a0,1
    80004d30:	ffffd097          	auipc	ra,0xffffd
    80004d34:	3ec080e7          	jalr	1004(ra) # 8000211c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d38:	08000613          	li	a2,128
    80004d3c:	f5040593          	addi	a1,s0,-176
    80004d40:	4501                	li	a0,0
    80004d42:	ffffd097          	auipc	ra,0xffffd
    80004d46:	41a080e7          	jalr	1050(ra) # 8000215c <argstr>
    80004d4a:	87aa                	mv	a5,a0
    return -1;
    80004d4c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d4e:	0a07c963          	bltz	a5,80004e00 <sys_open+0xe4>

  begin_op();
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	9e0080e7          	jalr	-1568(ra) # 80003732 <begin_op>

  if(omode & O_CREATE){
    80004d5a:	f4c42783          	lw	a5,-180(s0)
    80004d5e:	2007f793          	andi	a5,a5,512
    80004d62:	cfc5                	beqz	a5,80004e1a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d64:	4681                	li	a3,0
    80004d66:	4601                	li	a2,0
    80004d68:	4589                	li	a1,2
    80004d6a:	f5040513          	addi	a0,s0,-176
    80004d6e:	00000097          	auipc	ra,0x0
    80004d72:	974080e7          	jalr	-1676(ra) # 800046e2 <create>
    80004d76:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d78:	c959                	beqz	a0,80004e0e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d7a:	04449703          	lh	a4,68(s1)
    80004d7e:	478d                	li	a5,3
    80004d80:	00f71763          	bne	a4,a5,80004d8e <sys_open+0x72>
    80004d84:	0464d703          	lhu	a4,70(s1)
    80004d88:	47a5                	li	a5,9
    80004d8a:	0ce7ed63          	bltu	a5,a4,80004e64 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	db4080e7          	jalr	-588(ra) # 80003b42 <filealloc>
    80004d96:	89aa                	mv	s3,a0
    80004d98:	10050363          	beqz	a0,80004e9e <sys_open+0x182>
    80004d9c:	00000097          	auipc	ra,0x0
    80004da0:	904080e7          	jalr	-1788(ra) # 800046a0 <fdalloc>
    80004da4:	892a                	mv	s2,a0
    80004da6:	0e054763          	bltz	a0,80004e94 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004daa:	04449703          	lh	a4,68(s1)
    80004dae:	478d                	li	a5,3
    80004db0:	0cf70563          	beq	a4,a5,80004e7a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004db4:	4789                	li	a5,2
    80004db6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004dba:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dbe:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dc2:	f4c42783          	lw	a5,-180(s0)
    80004dc6:	0017c713          	xori	a4,a5,1
    80004dca:	8b05                	andi	a4,a4,1
    80004dcc:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dd0:	0037f713          	andi	a4,a5,3
    80004dd4:	00e03733          	snez	a4,a4
    80004dd8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ddc:	4007f793          	andi	a5,a5,1024
    80004de0:	c791                	beqz	a5,80004dec <sys_open+0xd0>
    80004de2:	04449703          	lh	a4,68(s1)
    80004de6:	4789                	li	a5,2
    80004de8:	0af70063          	beq	a4,a5,80004e88 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004dec:	8526                	mv	a0,s1
    80004dee:	ffffe097          	auipc	ra,0xffffe
    80004df2:	044080e7          	jalr	68(ra) # 80002e32 <iunlock>
  end_op();
    80004df6:	fffff097          	auipc	ra,0xfffff
    80004dfa:	9bc080e7          	jalr	-1604(ra) # 800037b2 <end_op>

  return fd;
    80004dfe:	854a                	mv	a0,s2
}
    80004e00:	70ea                	ld	ra,184(sp)
    80004e02:	744a                	ld	s0,176(sp)
    80004e04:	74aa                	ld	s1,168(sp)
    80004e06:	790a                	ld	s2,160(sp)
    80004e08:	69ea                	ld	s3,152(sp)
    80004e0a:	6129                	addi	sp,sp,192
    80004e0c:	8082                	ret
      end_op();
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	9a4080e7          	jalr	-1628(ra) # 800037b2 <end_op>
      return -1;
    80004e16:	557d                	li	a0,-1
    80004e18:	b7e5                	j	80004e00 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e1a:	f5040513          	addi	a0,s0,-176
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	6f8080e7          	jalr	1784(ra) # 80003516 <namei>
    80004e26:	84aa                	mv	s1,a0
    80004e28:	c905                	beqz	a0,80004e58 <sys_open+0x13c>
    ilock(ip);
    80004e2a:	ffffe097          	auipc	ra,0xffffe
    80004e2e:	f46080e7          	jalr	-186(ra) # 80002d70 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e32:	04449703          	lh	a4,68(s1)
    80004e36:	4785                	li	a5,1
    80004e38:	f4f711e3          	bne	a4,a5,80004d7a <sys_open+0x5e>
    80004e3c:	f4c42783          	lw	a5,-180(s0)
    80004e40:	d7b9                	beqz	a5,80004d8e <sys_open+0x72>
      iunlockput(ip);
    80004e42:	8526                	mv	a0,s1
    80004e44:	ffffe097          	auipc	ra,0xffffe
    80004e48:	18e080e7          	jalr	398(ra) # 80002fd2 <iunlockput>
      end_op();
    80004e4c:	fffff097          	auipc	ra,0xfffff
    80004e50:	966080e7          	jalr	-1690(ra) # 800037b2 <end_op>
      return -1;
    80004e54:	557d                	li	a0,-1
    80004e56:	b76d                	j	80004e00 <sys_open+0xe4>
      end_op();
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	95a080e7          	jalr	-1702(ra) # 800037b2 <end_op>
      return -1;
    80004e60:	557d                	li	a0,-1
    80004e62:	bf79                	j	80004e00 <sys_open+0xe4>
    iunlockput(ip);
    80004e64:	8526                	mv	a0,s1
    80004e66:	ffffe097          	auipc	ra,0xffffe
    80004e6a:	16c080e7          	jalr	364(ra) # 80002fd2 <iunlockput>
    end_op();
    80004e6e:	fffff097          	auipc	ra,0xfffff
    80004e72:	944080e7          	jalr	-1724(ra) # 800037b2 <end_op>
    return -1;
    80004e76:	557d                	li	a0,-1
    80004e78:	b761                	j	80004e00 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e7a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e7e:	04649783          	lh	a5,70(s1)
    80004e82:	02f99223          	sh	a5,36(s3)
    80004e86:	bf25                	j	80004dbe <sys_open+0xa2>
    itrunc(ip);
    80004e88:	8526                	mv	a0,s1
    80004e8a:	ffffe097          	auipc	ra,0xffffe
    80004e8e:	ff4080e7          	jalr	-12(ra) # 80002e7e <itrunc>
    80004e92:	bfa9                	j	80004dec <sys_open+0xd0>
      fileclose(f);
    80004e94:	854e                	mv	a0,s3
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	d68080e7          	jalr	-664(ra) # 80003bfe <fileclose>
    iunlockput(ip);
    80004e9e:	8526                	mv	a0,s1
    80004ea0:	ffffe097          	auipc	ra,0xffffe
    80004ea4:	132080e7          	jalr	306(ra) # 80002fd2 <iunlockput>
    end_op();
    80004ea8:	fffff097          	auipc	ra,0xfffff
    80004eac:	90a080e7          	jalr	-1782(ra) # 800037b2 <end_op>
    return -1;
    80004eb0:	557d                	li	a0,-1
    80004eb2:	b7b9                	j	80004e00 <sys_open+0xe4>

0000000080004eb4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004eb4:	7175                	addi	sp,sp,-144
    80004eb6:	e506                	sd	ra,136(sp)
    80004eb8:	e122                	sd	s0,128(sp)
    80004eba:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ebc:	fffff097          	auipc	ra,0xfffff
    80004ec0:	876080e7          	jalr	-1930(ra) # 80003732 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ec4:	08000613          	li	a2,128
    80004ec8:	f7040593          	addi	a1,s0,-144
    80004ecc:	4501                	li	a0,0
    80004ece:	ffffd097          	auipc	ra,0xffffd
    80004ed2:	28e080e7          	jalr	654(ra) # 8000215c <argstr>
    80004ed6:	02054963          	bltz	a0,80004f08 <sys_mkdir+0x54>
    80004eda:	4681                	li	a3,0
    80004edc:	4601                	li	a2,0
    80004ede:	4585                	li	a1,1
    80004ee0:	f7040513          	addi	a0,s0,-144
    80004ee4:	fffff097          	auipc	ra,0xfffff
    80004ee8:	7fe080e7          	jalr	2046(ra) # 800046e2 <create>
    80004eec:	cd11                	beqz	a0,80004f08 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eee:	ffffe097          	auipc	ra,0xffffe
    80004ef2:	0e4080e7          	jalr	228(ra) # 80002fd2 <iunlockput>
  end_op();
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	8bc080e7          	jalr	-1860(ra) # 800037b2 <end_op>
  return 0;
    80004efe:	4501                	li	a0,0
}
    80004f00:	60aa                	ld	ra,136(sp)
    80004f02:	640a                	ld	s0,128(sp)
    80004f04:	6149                	addi	sp,sp,144
    80004f06:	8082                	ret
    end_op();
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	8aa080e7          	jalr	-1878(ra) # 800037b2 <end_op>
    return -1;
    80004f10:	557d                	li	a0,-1
    80004f12:	b7fd                	j	80004f00 <sys_mkdir+0x4c>

0000000080004f14 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f14:	7135                	addi	sp,sp,-160
    80004f16:	ed06                	sd	ra,152(sp)
    80004f18:	e922                	sd	s0,144(sp)
    80004f1a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f1c:	fffff097          	auipc	ra,0xfffff
    80004f20:	816080e7          	jalr	-2026(ra) # 80003732 <begin_op>
  argint(1, &major);
    80004f24:	f6c40593          	addi	a1,s0,-148
    80004f28:	4505                	li	a0,1
    80004f2a:	ffffd097          	auipc	ra,0xffffd
    80004f2e:	1f2080e7          	jalr	498(ra) # 8000211c <argint>
  argint(2, &minor);
    80004f32:	f6840593          	addi	a1,s0,-152
    80004f36:	4509                	li	a0,2
    80004f38:	ffffd097          	auipc	ra,0xffffd
    80004f3c:	1e4080e7          	jalr	484(ra) # 8000211c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f40:	08000613          	li	a2,128
    80004f44:	f7040593          	addi	a1,s0,-144
    80004f48:	4501                	li	a0,0
    80004f4a:	ffffd097          	auipc	ra,0xffffd
    80004f4e:	212080e7          	jalr	530(ra) # 8000215c <argstr>
    80004f52:	02054b63          	bltz	a0,80004f88 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f56:	f6841683          	lh	a3,-152(s0)
    80004f5a:	f6c41603          	lh	a2,-148(s0)
    80004f5e:	458d                	li	a1,3
    80004f60:	f7040513          	addi	a0,s0,-144
    80004f64:	fffff097          	auipc	ra,0xfffff
    80004f68:	77e080e7          	jalr	1918(ra) # 800046e2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f6c:	cd11                	beqz	a0,80004f88 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	064080e7          	jalr	100(ra) # 80002fd2 <iunlockput>
  end_op();
    80004f76:	fffff097          	auipc	ra,0xfffff
    80004f7a:	83c080e7          	jalr	-1988(ra) # 800037b2 <end_op>
  return 0;
    80004f7e:	4501                	li	a0,0
}
    80004f80:	60ea                	ld	ra,152(sp)
    80004f82:	644a                	ld	s0,144(sp)
    80004f84:	610d                	addi	sp,sp,160
    80004f86:	8082                	ret
    end_op();
    80004f88:	fffff097          	auipc	ra,0xfffff
    80004f8c:	82a080e7          	jalr	-2006(ra) # 800037b2 <end_op>
    return -1;
    80004f90:	557d                	li	a0,-1
    80004f92:	b7fd                	j	80004f80 <sys_mknod+0x6c>

0000000080004f94 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f94:	7135                	addi	sp,sp,-160
    80004f96:	ed06                	sd	ra,152(sp)
    80004f98:	e922                	sd	s0,144(sp)
    80004f9a:	e526                	sd	s1,136(sp)
    80004f9c:	e14a                	sd	s2,128(sp)
    80004f9e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fa0:	ffffc097          	auipc	ra,0xffffc
    80004fa4:	fd2080e7          	jalr	-46(ra) # 80000f72 <myproc>
    80004fa8:	892a                	mv	s2,a0
  
  begin_op();
    80004faa:	ffffe097          	auipc	ra,0xffffe
    80004fae:	788080e7          	jalr	1928(ra) # 80003732 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fb2:	08000613          	li	a2,128
    80004fb6:	f6040593          	addi	a1,s0,-160
    80004fba:	4501                	li	a0,0
    80004fbc:	ffffd097          	auipc	ra,0xffffd
    80004fc0:	1a0080e7          	jalr	416(ra) # 8000215c <argstr>
    80004fc4:	04054b63          	bltz	a0,8000501a <sys_chdir+0x86>
    80004fc8:	f6040513          	addi	a0,s0,-160
    80004fcc:	ffffe097          	auipc	ra,0xffffe
    80004fd0:	54a080e7          	jalr	1354(ra) # 80003516 <namei>
    80004fd4:	84aa                	mv	s1,a0
    80004fd6:	c131                	beqz	a0,8000501a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fd8:	ffffe097          	auipc	ra,0xffffe
    80004fdc:	d98080e7          	jalr	-616(ra) # 80002d70 <ilock>
  if(ip->type != T_DIR){
    80004fe0:	04449703          	lh	a4,68(s1)
    80004fe4:	4785                	li	a5,1
    80004fe6:	04f71063          	bne	a4,a5,80005026 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fea:	8526                	mv	a0,s1
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	e46080e7          	jalr	-442(ra) # 80002e32 <iunlock>
  iput(p->cwd);
    80004ff4:	15093503          	ld	a0,336(s2)
    80004ff8:	ffffe097          	auipc	ra,0xffffe
    80004ffc:	f32080e7          	jalr	-206(ra) # 80002f2a <iput>
  end_op();
    80005000:	ffffe097          	auipc	ra,0xffffe
    80005004:	7b2080e7          	jalr	1970(ra) # 800037b2 <end_op>
  p->cwd = ip;
    80005008:	14993823          	sd	s1,336(s2)
  return 0;
    8000500c:	4501                	li	a0,0
}
    8000500e:	60ea                	ld	ra,152(sp)
    80005010:	644a                	ld	s0,144(sp)
    80005012:	64aa                	ld	s1,136(sp)
    80005014:	690a                	ld	s2,128(sp)
    80005016:	610d                	addi	sp,sp,160
    80005018:	8082                	ret
    end_op();
    8000501a:	ffffe097          	auipc	ra,0xffffe
    8000501e:	798080e7          	jalr	1944(ra) # 800037b2 <end_op>
    return -1;
    80005022:	557d                	li	a0,-1
    80005024:	b7ed                	j	8000500e <sys_chdir+0x7a>
    iunlockput(ip);
    80005026:	8526                	mv	a0,s1
    80005028:	ffffe097          	auipc	ra,0xffffe
    8000502c:	faa080e7          	jalr	-86(ra) # 80002fd2 <iunlockput>
    end_op();
    80005030:	ffffe097          	auipc	ra,0xffffe
    80005034:	782080e7          	jalr	1922(ra) # 800037b2 <end_op>
    return -1;
    80005038:	557d                	li	a0,-1
    8000503a:	bfd1                	j	8000500e <sys_chdir+0x7a>

000000008000503c <sys_exec>:

uint64
sys_exec(void)
{
    8000503c:	7145                	addi	sp,sp,-464
    8000503e:	e786                	sd	ra,456(sp)
    80005040:	e3a2                	sd	s0,448(sp)
    80005042:	ff26                	sd	s1,440(sp)
    80005044:	fb4a                	sd	s2,432(sp)
    80005046:	f74e                	sd	s3,424(sp)
    80005048:	f352                	sd	s4,416(sp)
    8000504a:	ef56                	sd	s5,408(sp)
    8000504c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000504e:	e3840593          	addi	a1,s0,-456
    80005052:	4505                	li	a0,1
    80005054:	ffffd097          	auipc	ra,0xffffd
    80005058:	0e8080e7          	jalr	232(ra) # 8000213c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000505c:	08000613          	li	a2,128
    80005060:	f4040593          	addi	a1,s0,-192
    80005064:	4501                	li	a0,0
    80005066:	ffffd097          	auipc	ra,0xffffd
    8000506a:	0f6080e7          	jalr	246(ra) # 8000215c <argstr>
    8000506e:	87aa                	mv	a5,a0
    return -1;
    80005070:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005072:	0c07c263          	bltz	a5,80005136 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005076:	10000613          	li	a2,256
    8000507a:	4581                	li	a1,0
    8000507c:	e4040513          	addi	a0,s0,-448
    80005080:	ffffb097          	auipc	ra,0xffffb
    80005084:	0f8080e7          	jalr	248(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005088:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000508c:	89a6                	mv	s3,s1
    8000508e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005090:	02000a13          	li	s4,32
    80005094:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005098:	00391513          	slli	a0,s2,0x3
    8000509c:	e3040593          	addi	a1,s0,-464
    800050a0:	e3843783          	ld	a5,-456(s0)
    800050a4:	953e                	add	a0,a0,a5
    800050a6:	ffffd097          	auipc	ra,0xffffd
    800050aa:	fd8080e7          	jalr	-40(ra) # 8000207e <fetchaddr>
    800050ae:	02054a63          	bltz	a0,800050e2 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800050b2:	e3043783          	ld	a5,-464(s0)
    800050b6:	c3b9                	beqz	a5,800050fc <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050b8:	ffffb097          	auipc	ra,0xffffb
    800050bc:	060080e7          	jalr	96(ra) # 80000118 <kalloc>
    800050c0:	85aa                	mv	a1,a0
    800050c2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050c6:	cd11                	beqz	a0,800050e2 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050c8:	6605                	lui	a2,0x1
    800050ca:	e3043503          	ld	a0,-464(s0)
    800050ce:	ffffd097          	auipc	ra,0xffffd
    800050d2:	002080e7          	jalr	2(ra) # 800020d0 <fetchstr>
    800050d6:	00054663          	bltz	a0,800050e2 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800050da:	0905                	addi	s2,s2,1
    800050dc:	09a1                	addi	s3,s3,8
    800050de:	fb491be3          	bne	s2,s4,80005094 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050e2:	10048913          	addi	s2,s1,256
    800050e6:	6088                	ld	a0,0(s1)
    800050e8:	c531                	beqz	a0,80005134 <sys_exec+0xf8>
    kfree(argv[i]);
    800050ea:	ffffb097          	auipc	ra,0xffffb
    800050ee:	f32080e7          	jalr	-206(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f2:	04a1                	addi	s1,s1,8
    800050f4:	ff2499e3          	bne	s1,s2,800050e6 <sys_exec+0xaa>
  return -1;
    800050f8:	557d                	li	a0,-1
    800050fa:	a835                	j	80005136 <sys_exec+0xfa>
      argv[i] = 0;
    800050fc:	0a8e                	slli	s5,s5,0x3
    800050fe:	fc040793          	addi	a5,s0,-64
    80005102:	9abe                	add	s5,s5,a5
    80005104:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005108:	e4040593          	addi	a1,s0,-448
    8000510c:	f4040513          	addi	a0,s0,-192
    80005110:	fffff097          	auipc	ra,0xfffff
    80005114:	176080e7          	jalr	374(ra) # 80004286 <exec>
    80005118:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000511a:	10048993          	addi	s3,s1,256
    8000511e:	6088                	ld	a0,0(s1)
    80005120:	c901                	beqz	a0,80005130 <sys_exec+0xf4>
    kfree(argv[i]);
    80005122:	ffffb097          	auipc	ra,0xffffb
    80005126:	efa080e7          	jalr	-262(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000512a:	04a1                	addi	s1,s1,8
    8000512c:	ff3499e3          	bne	s1,s3,8000511e <sys_exec+0xe2>
  return ret;
    80005130:	854a                	mv	a0,s2
    80005132:	a011                	j	80005136 <sys_exec+0xfa>
  return -1;
    80005134:	557d                	li	a0,-1
}
    80005136:	60be                	ld	ra,456(sp)
    80005138:	641e                	ld	s0,448(sp)
    8000513a:	74fa                	ld	s1,440(sp)
    8000513c:	795a                	ld	s2,432(sp)
    8000513e:	79ba                	ld	s3,424(sp)
    80005140:	7a1a                	ld	s4,416(sp)
    80005142:	6afa                	ld	s5,408(sp)
    80005144:	6179                	addi	sp,sp,464
    80005146:	8082                	ret

0000000080005148 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005148:	7139                	addi	sp,sp,-64
    8000514a:	fc06                	sd	ra,56(sp)
    8000514c:	f822                	sd	s0,48(sp)
    8000514e:	f426                	sd	s1,40(sp)
    80005150:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005152:	ffffc097          	auipc	ra,0xffffc
    80005156:	e20080e7          	jalr	-480(ra) # 80000f72 <myproc>
    8000515a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000515c:	fd840593          	addi	a1,s0,-40
    80005160:	4501                	li	a0,0
    80005162:	ffffd097          	auipc	ra,0xffffd
    80005166:	fda080e7          	jalr	-38(ra) # 8000213c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000516a:	fc840593          	addi	a1,s0,-56
    8000516e:	fd040513          	addi	a0,s0,-48
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	dbc080e7          	jalr	-580(ra) # 80003f2e <pipealloc>
    return -1;
    8000517a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000517c:	0c054463          	bltz	a0,80005244 <sys_pipe+0xfc>
  fd0 = -1;
    80005180:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005184:	fd043503          	ld	a0,-48(s0)
    80005188:	fffff097          	auipc	ra,0xfffff
    8000518c:	518080e7          	jalr	1304(ra) # 800046a0 <fdalloc>
    80005190:	fca42223          	sw	a0,-60(s0)
    80005194:	08054b63          	bltz	a0,8000522a <sys_pipe+0xe2>
    80005198:	fc843503          	ld	a0,-56(s0)
    8000519c:	fffff097          	auipc	ra,0xfffff
    800051a0:	504080e7          	jalr	1284(ra) # 800046a0 <fdalloc>
    800051a4:	fca42023          	sw	a0,-64(s0)
    800051a8:	06054863          	bltz	a0,80005218 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051ac:	4691                	li	a3,4
    800051ae:	fc440613          	addi	a2,s0,-60
    800051b2:	fd843583          	ld	a1,-40(s0)
    800051b6:	68a8                	ld	a0,80(s1)
    800051b8:	ffffc097          	auipc	ra,0xffffc
    800051bc:	95e080e7          	jalr	-1698(ra) # 80000b16 <copyout>
    800051c0:	02054063          	bltz	a0,800051e0 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051c4:	4691                	li	a3,4
    800051c6:	fc040613          	addi	a2,s0,-64
    800051ca:	fd843583          	ld	a1,-40(s0)
    800051ce:	0591                	addi	a1,a1,4
    800051d0:	68a8                	ld	a0,80(s1)
    800051d2:	ffffc097          	auipc	ra,0xffffc
    800051d6:	944080e7          	jalr	-1724(ra) # 80000b16 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051da:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051dc:	06055463          	bgez	a0,80005244 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800051e0:	fc442783          	lw	a5,-60(s0)
    800051e4:	07e9                	addi	a5,a5,26
    800051e6:	078e                	slli	a5,a5,0x3
    800051e8:	97a6                	add	a5,a5,s1
    800051ea:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051ee:	fc042503          	lw	a0,-64(s0)
    800051f2:	0569                	addi	a0,a0,26
    800051f4:	050e                	slli	a0,a0,0x3
    800051f6:	94aa                	add	s1,s1,a0
    800051f8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051fc:	fd043503          	ld	a0,-48(s0)
    80005200:	fffff097          	auipc	ra,0xfffff
    80005204:	9fe080e7          	jalr	-1538(ra) # 80003bfe <fileclose>
    fileclose(wf);
    80005208:	fc843503          	ld	a0,-56(s0)
    8000520c:	fffff097          	auipc	ra,0xfffff
    80005210:	9f2080e7          	jalr	-1550(ra) # 80003bfe <fileclose>
    return -1;
    80005214:	57fd                	li	a5,-1
    80005216:	a03d                	j	80005244 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005218:	fc442783          	lw	a5,-60(s0)
    8000521c:	0007c763          	bltz	a5,8000522a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005220:	07e9                	addi	a5,a5,26
    80005222:	078e                	slli	a5,a5,0x3
    80005224:	94be                	add	s1,s1,a5
    80005226:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000522a:	fd043503          	ld	a0,-48(s0)
    8000522e:	fffff097          	auipc	ra,0xfffff
    80005232:	9d0080e7          	jalr	-1584(ra) # 80003bfe <fileclose>
    fileclose(wf);
    80005236:	fc843503          	ld	a0,-56(s0)
    8000523a:	fffff097          	auipc	ra,0xfffff
    8000523e:	9c4080e7          	jalr	-1596(ra) # 80003bfe <fileclose>
    return -1;
    80005242:	57fd                	li	a5,-1
}
    80005244:	853e                	mv	a0,a5
    80005246:	70e2                	ld	ra,56(sp)
    80005248:	7442                	ld	s0,48(sp)
    8000524a:	74a2                	ld	s1,40(sp)
    8000524c:	6121                	addi	sp,sp,64
    8000524e:	8082                	ret

0000000080005250 <kernelvec>:
    80005250:	7111                	addi	sp,sp,-256
    80005252:	e006                	sd	ra,0(sp)
    80005254:	e40a                	sd	sp,8(sp)
    80005256:	e80e                	sd	gp,16(sp)
    80005258:	ec12                	sd	tp,24(sp)
    8000525a:	f016                	sd	t0,32(sp)
    8000525c:	f41a                	sd	t1,40(sp)
    8000525e:	f81e                	sd	t2,48(sp)
    80005260:	fc22                	sd	s0,56(sp)
    80005262:	e0a6                	sd	s1,64(sp)
    80005264:	e4aa                	sd	a0,72(sp)
    80005266:	e8ae                	sd	a1,80(sp)
    80005268:	ecb2                	sd	a2,88(sp)
    8000526a:	f0b6                	sd	a3,96(sp)
    8000526c:	f4ba                	sd	a4,104(sp)
    8000526e:	f8be                	sd	a5,112(sp)
    80005270:	fcc2                	sd	a6,120(sp)
    80005272:	e146                	sd	a7,128(sp)
    80005274:	e54a                	sd	s2,136(sp)
    80005276:	e94e                	sd	s3,144(sp)
    80005278:	ed52                	sd	s4,152(sp)
    8000527a:	f156                	sd	s5,160(sp)
    8000527c:	f55a                	sd	s6,168(sp)
    8000527e:	f95e                	sd	s7,176(sp)
    80005280:	fd62                	sd	s8,184(sp)
    80005282:	e1e6                	sd	s9,192(sp)
    80005284:	e5ea                	sd	s10,200(sp)
    80005286:	e9ee                	sd	s11,208(sp)
    80005288:	edf2                	sd	t3,216(sp)
    8000528a:	f1f6                	sd	t4,224(sp)
    8000528c:	f5fa                	sd	t5,232(sp)
    8000528e:	f9fe                	sd	t6,240(sp)
    80005290:	cbbfc0ef          	jal	ra,80001f4a <kerneltrap>
    80005294:	6082                	ld	ra,0(sp)
    80005296:	6122                	ld	sp,8(sp)
    80005298:	61c2                	ld	gp,16(sp)
    8000529a:	7282                	ld	t0,32(sp)
    8000529c:	7322                	ld	t1,40(sp)
    8000529e:	73c2                	ld	t2,48(sp)
    800052a0:	7462                	ld	s0,56(sp)
    800052a2:	6486                	ld	s1,64(sp)
    800052a4:	6526                	ld	a0,72(sp)
    800052a6:	65c6                	ld	a1,80(sp)
    800052a8:	6666                	ld	a2,88(sp)
    800052aa:	7686                	ld	a3,96(sp)
    800052ac:	7726                	ld	a4,104(sp)
    800052ae:	77c6                	ld	a5,112(sp)
    800052b0:	7866                	ld	a6,120(sp)
    800052b2:	688a                	ld	a7,128(sp)
    800052b4:	692a                	ld	s2,136(sp)
    800052b6:	69ca                	ld	s3,144(sp)
    800052b8:	6a6a                	ld	s4,152(sp)
    800052ba:	7a8a                	ld	s5,160(sp)
    800052bc:	7b2a                	ld	s6,168(sp)
    800052be:	7bca                	ld	s7,176(sp)
    800052c0:	7c6a                	ld	s8,184(sp)
    800052c2:	6c8e                	ld	s9,192(sp)
    800052c4:	6d2e                	ld	s10,200(sp)
    800052c6:	6dce                	ld	s11,208(sp)
    800052c8:	6e6e                	ld	t3,216(sp)
    800052ca:	7e8e                	ld	t4,224(sp)
    800052cc:	7f2e                	ld	t5,232(sp)
    800052ce:	7fce                	ld	t6,240(sp)
    800052d0:	6111                	addi	sp,sp,256
    800052d2:	10200073          	sret
    800052d6:	00000013          	nop
    800052da:	00000013          	nop
    800052de:	0001                	nop

00000000800052e0 <timervec>:
    800052e0:	34051573          	csrrw	a0,mscratch,a0
    800052e4:	e10c                	sd	a1,0(a0)
    800052e6:	e510                	sd	a2,8(a0)
    800052e8:	e914                	sd	a3,16(a0)
    800052ea:	6d0c                	ld	a1,24(a0)
    800052ec:	7110                	ld	a2,32(a0)
    800052ee:	6194                	ld	a3,0(a1)
    800052f0:	96b2                	add	a3,a3,a2
    800052f2:	e194                	sd	a3,0(a1)
    800052f4:	4589                	li	a1,2
    800052f6:	14459073          	csrw	sip,a1
    800052fa:	6914                	ld	a3,16(a0)
    800052fc:	6510                	ld	a2,8(a0)
    800052fe:	610c                	ld	a1,0(a0)
    80005300:	34051573          	csrrw	a0,mscratch,a0
    80005304:	30200073          	mret
	...

000000008000530a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000530a:	1141                	addi	sp,sp,-16
    8000530c:	e422                	sd	s0,8(sp)
    8000530e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005310:	0c0007b7          	lui	a5,0xc000
    80005314:	4705                	li	a4,1
    80005316:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005318:	c3d8                	sw	a4,4(a5)
}
    8000531a:	6422                	ld	s0,8(sp)
    8000531c:	0141                	addi	sp,sp,16
    8000531e:	8082                	ret

0000000080005320 <plicinithart>:

void
plicinithart(void)
{
    80005320:	1141                	addi	sp,sp,-16
    80005322:	e406                	sd	ra,8(sp)
    80005324:	e022                	sd	s0,0(sp)
    80005326:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005328:	ffffc097          	auipc	ra,0xffffc
    8000532c:	c1e080e7          	jalr	-994(ra) # 80000f46 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005330:	0085171b          	slliw	a4,a0,0x8
    80005334:	0c0027b7          	lui	a5,0xc002
    80005338:	97ba                	add	a5,a5,a4
    8000533a:	40200713          	li	a4,1026
    8000533e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005342:	00d5151b          	slliw	a0,a0,0xd
    80005346:	0c2017b7          	lui	a5,0xc201
    8000534a:	953e                	add	a0,a0,a5
    8000534c:	00052023          	sw	zero,0(a0)
}
    80005350:	60a2                	ld	ra,8(sp)
    80005352:	6402                	ld	s0,0(sp)
    80005354:	0141                	addi	sp,sp,16
    80005356:	8082                	ret

0000000080005358 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005358:	1141                	addi	sp,sp,-16
    8000535a:	e406                	sd	ra,8(sp)
    8000535c:	e022                	sd	s0,0(sp)
    8000535e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005360:	ffffc097          	auipc	ra,0xffffc
    80005364:	be6080e7          	jalr	-1050(ra) # 80000f46 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005368:	00d5179b          	slliw	a5,a0,0xd
    8000536c:	0c201537          	lui	a0,0xc201
    80005370:	953e                	add	a0,a0,a5
  return irq;
}
    80005372:	4148                	lw	a0,4(a0)
    80005374:	60a2                	ld	ra,8(sp)
    80005376:	6402                	ld	s0,0(sp)
    80005378:	0141                	addi	sp,sp,16
    8000537a:	8082                	ret

000000008000537c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000537c:	1101                	addi	sp,sp,-32
    8000537e:	ec06                	sd	ra,24(sp)
    80005380:	e822                	sd	s0,16(sp)
    80005382:	e426                	sd	s1,8(sp)
    80005384:	1000                	addi	s0,sp,32
    80005386:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005388:	ffffc097          	auipc	ra,0xffffc
    8000538c:	bbe080e7          	jalr	-1090(ra) # 80000f46 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005390:	00d5151b          	slliw	a0,a0,0xd
    80005394:	0c2017b7          	lui	a5,0xc201
    80005398:	97aa                	add	a5,a5,a0
    8000539a:	c3c4                	sw	s1,4(a5)
}
    8000539c:	60e2                	ld	ra,24(sp)
    8000539e:	6442                	ld	s0,16(sp)
    800053a0:	64a2                	ld	s1,8(sp)
    800053a2:	6105                	addi	sp,sp,32
    800053a4:	8082                	ret

00000000800053a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053a6:	1141                	addi	sp,sp,-16
    800053a8:	e406                	sd	ra,8(sp)
    800053aa:	e022                	sd	s0,0(sp)
    800053ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ae:	479d                	li	a5,7
    800053b0:	04a7cc63          	blt	a5,a0,80005408 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800053b4:	00015797          	auipc	a5,0x15
    800053b8:	8bc78793          	addi	a5,a5,-1860 # 80019c70 <disk>
    800053bc:	97aa                	add	a5,a5,a0
    800053be:	0187c783          	lbu	a5,24(a5)
    800053c2:	ebb9                	bnez	a5,80005418 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053c4:	00451613          	slli	a2,a0,0x4
    800053c8:	00015797          	auipc	a5,0x15
    800053cc:	8a878793          	addi	a5,a5,-1880 # 80019c70 <disk>
    800053d0:	6394                	ld	a3,0(a5)
    800053d2:	96b2                	add	a3,a3,a2
    800053d4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053d8:	6398                	ld	a4,0(a5)
    800053da:	9732                	add	a4,a4,a2
    800053dc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053e0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053e4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053e8:	953e                	add	a0,a0,a5
    800053ea:	4785                	li	a5,1
    800053ec:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800053f0:	00015517          	auipc	a0,0x15
    800053f4:	89850513          	addi	a0,a0,-1896 # 80019c88 <disk+0x18>
    800053f8:	ffffc097          	auipc	ra,0xffffc
    800053fc:	31c080e7          	jalr	796(ra) # 80001714 <wakeup>
}
    80005400:	60a2                	ld	ra,8(sp)
    80005402:	6402                	ld	s0,0(sp)
    80005404:	0141                	addi	sp,sp,16
    80005406:	8082                	ret
    panic("free_desc 1");
    80005408:	00003517          	auipc	a0,0x3
    8000540c:	35050513          	addi	a0,a0,848 # 80008758 <syscalls+0x340>
    80005410:	00001097          	auipc	ra,0x1
    80005414:	a72080e7          	jalr	-1422(ra) # 80005e82 <panic>
    panic("free_desc 2");
    80005418:	00003517          	auipc	a0,0x3
    8000541c:	35050513          	addi	a0,a0,848 # 80008768 <syscalls+0x350>
    80005420:	00001097          	auipc	ra,0x1
    80005424:	a62080e7          	jalr	-1438(ra) # 80005e82 <panic>

0000000080005428 <virtio_disk_init>:
{
    80005428:	1101                	addi	sp,sp,-32
    8000542a:	ec06                	sd	ra,24(sp)
    8000542c:	e822                	sd	s0,16(sp)
    8000542e:	e426                	sd	s1,8(sp)
    80005430:	e04a                	sd	s2,0(sp)
    80005432:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005434:	00003597          	auipc	a1,0x3
    80005438:	34458593          	addi	a1,a1,836 # 80008778 <syscalls+0x360>
    8000543c:	00015517          	auipc	a0,0x15
    80005440:	95c50513          	addi	a0,a0,-1700 # 80019d98 <disk+0x128>
    80005444:	00001097          	auipc	ra,0x1
    80005448:	ef8080e7          	jalr	-264(ra) # 8000633c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000544c:	100017b7          	lui	a5,0x10001
    80005450:	4398                	lw	a4,0(a5)
    80005452:	2701                	sext.w	a4,a4
    80005454:	747277b7          	lui	a5,0x74727
    80005458:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000545c:	14f71e63          	bne	a4,a5,800055b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005460:	100017b7          	lui	a5,0x10001
    80005464:	43dc                	lw	a5,4(a5)
    80005466:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005468:	4709                	li	a4,2
    8000546a:	14e79763          	bne	a5,a4,800055b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000546e:	100017b7          	lui	a5,0x10001
    80005472:	479c                	lw	a5,8(a5)
    80005474:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005476:	14e79163          	bne	a5,a4,800055b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000547a:	100017b7          	lui	a5,0x10001
    8000547e:	47d8                	lw	a4,12(a5)
    80005480:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005482:	554d47b7          	lui	a5,0x554d4
    80005486:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000548a:	12f71763          	bne	a4,a5,800055b8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000548e:	100017b7          	lui	a5,0x10001
    80005492:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005496:	4705                	li	a4,1
    80005498:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000549a:	470d                	li	a4,3
    8000549c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000549e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054a0:	c7ffe737          	lui	a4,0xc7ffe
    800054a4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc76f>
    800054a8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054aa:	2701                	sext.w	a4,a4
    800054ac:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ae:	472d                	li	a4,11
    800054b0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054b2:	0707a903          	lw	s2,112(a5)
    800054b6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054b8:	00897793          	andi	a5,s2,8
    800054bc:	10078663          	beqz	a5,800055c8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054c0:	100017b7          	lui	a5,0x10001
    800054c4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054c8:	43fc                	lw	a5,68(a5)
    800054ca:	2781                	sext.w	a5,a5
    800054cc:	10079663          	bnez	a5,800055d8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054d0:	100017b7          	lui	a5,0x10001
    800054d4:	5bdc                	lw	a5,52(a5)
    800054d6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054d8:	10078863          	beqz	a5,800055e8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800054dc:	471d                	li	a4,7
    800054de:	10f77d63          	bgeu	a4,a5,800055f8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800054e2:	ffffb097          	auipc	ra,0xffffb
    800054e6:	c36080e7          	jalr	-970(ra) # 80000118 <kalloc>
    800054ea:	00014497          	auipc	s1,0x14
    800054ee:	78648493          	addi	s1,s1,1926 # 80019c70 <disk>
    800054f2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054f4:	ffffb097          	auipc	ra,0xffffb
    800054f8:	c24080e7          	jalr	-988(ra) # 80000118 <kalloc>
    800054fc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054fe:	ffffb097          	auipc	ra,0xffffb
    80005502:	c1a080e7          	jalr	-998(ra) # 80000118 <kalloc>
    80005506:	87aa                	mv	a5,a0
    80005508:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000550a:	6088                	ld	a0,0(s1)
    8000550c:	cd75                	beqz	a0,80005608 <virtio_disk_init+0x1e0>
    8000550e:	00014717          	auipc	a4,0x14
    80005512:	76a73703          	ld	a4,1898(a4) # 80019c78 <disk+0x8>
    80005516:	cb6d                	beqz	a4,80005608 <virtio_disk_init+0x1e0>
    80005518:	cbe5                	beqz	a5,80005608 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000551a:	6605                	lui	a2,0x1
    8000551c:	4581                	li	a1,0
    8000551e:	ffffb097          	auipc	ra,0xffffb
    80005522:	c5a080e7          	jalr	-934(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005526:	00014497          	auipc	s1,0x14
    8000552a:	74a48493          	addi	s1,s1,1866 # 80019c70 <disk>
    8000552e:	6605                	lui	a2,0x1
    80005530:	4581                	li	a1,0
    80005532:	6488                	ld	a0,8(s1)
    80005534:	ffffb097          	auipc	ra,0xffffb
    80005538:	c44080e7          	jalr	-956(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000553c:	6605                	lui	a2,0x1
    8000553e:	4581                	li	a1,0
    80005540:	6888                	ld	a0,16(s1)
    80005542:	ffffb097          	auipc	ra,0xffffb
    80005546:	c36080e7          	jalr	-970(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000554a:	100017b7          	lui	a5,0x10001
    8000554e:	4721                	li	a4,8
    80005550:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005552:	4098                	lw	a4,0(s1)
    80005554:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005558:	40d8                	lw	a4,4(s1)
    8000555a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000555e:	6498                	ld	a4,8(s1)
    80005560:	0007069b          	sext.w	a3,a4
    80005564:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005568:	9701                	srai	a4,a4,0x20
    8000556a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000556e:	6898                	ld	a4,16(s1)
    80005570:	0007069b          	sext.w	a3,a4
    80005574:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005578:	9701                	srai	a4,a4,0x20
    8000557a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000557e:	4685                	li	a3,1
    80005580:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005582:	4705                	li	a4,1
    80005584:	00d48c23          	sb	a3,24(s1)
    80005588:	00e48ca3          	sb	a4,25(s1)
    8000558c:	00e48d23          	sb	a4,26(s1)
    80005590:	00e48da3          	sb	a4,27(s1)
    80005594:	00e48e23          	sb	a4,28(s1)
    80005598:	00e48ea3          	sb	a4,29(s1)
    8000559c:	00e48f23          	sb	a4,30(s1)
    800055a0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055a4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055a8:	0727a823          	sw	s2,112(a5)
}
    800055ac:	60e2                	ld	ra,24(sp)
    800055ae:	6442                	ld	s0,16(sp)
    800055b0:	64a2                	ld	s1,8(sp)
    800055b2:	6902                	ld	s2,0(sp)
    800055b4:	6105                	addi	sp,sp,32
    800055b6:	8082                	ret
    panic("could not find virtio disk");
    800055b8:	00003517          	auipc	a0,0x3
    800055bc:	1d050513          	addi	a0,a0,464 # 80008788 <syscalls+0x370>
    800055c0:	00001097          	auipc	ra,0x1
    800055c4:	8c2080e7          	jalr	-1854(ra) # 80005e82 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055c8:	00003517          	auipc	a0,0x3
    800055cc:	1e050513          	addi	a0,a0,480 # 800087a8 <syscalls+0x390>
    800055d0:	00001097          	auipc	ra,0x1
    800055d4:	8b2080e7          	jalr	-1870(ra) # 80005e82 <panic>
    panic("virtio disk should not be ready");
    800055d8:	00003517          	auipc	a0,0x3
    800055dc:	1f050513          	addi	a0,a0,496 # 800087c8 <syscalls+0x3b0>
    800055e0:	00001097          	auipc	ra,0x1
    800055e4:	8a2080e7          	jalr	-1886(ra) # 80005e82 <panic>
    panic("virtio disk has no queue 0");
    800055e8:	00003517          	auipc	a0,0x3
    800055ec:	20050513          	addi	a0,a0,512 # 800087e8 <syscalls+0x3d0>
    800055f0:	00001097          	auipc	ra,0x1
    800055f4:	892080e7          	jalr	-1902(ra) # 80005e82 <panic>
    panic("virtio disk max queue too short");
    800055f8:	00003517          	auipc	a0,0x3
    800055fc:	21050513          	addi	a0,a0,528 # 80008808 <syscalls+0x3f0>
    80005600:	00001097          	auipc	ra,0x1
    80005604:	882080e7          	jalr	-1918(ra) # 80005e82 <panic>
    panic("virtio disk kalloc");
    80005608:	00003517          	auipc	a0,0x3
    8000560c:	22050513          	addi	a0,a0,544 # 80008828 <syscalls+0x410>
    80005610:	00001097          	auipc	ra,0x1
    80005614:	872080e7          	jalr	-1934(ra) # 80005e82 <panic>

0000000080005618 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005618:	7159                	addi	sp,sp,-112
    8000561a:	f486                	sd	ra,104(sp)
    8000561c:	f0a2                	sd	s0,96(sp)
    8000561e:	eca6                	sd	s1,88(sp)
    80005620:	e8ca                	sd	s2,80(sp)
    80005622:	e4ce                	sd	s3,72(sp)
    80005624:	e0d2                	sd	s4,64(sp)
    80005626:	fc56                	sd	s5,56(sp)
    80005628:	f85a                	sd	s6,48(sp)
    8000562a:	f45e                	sd	s7,40(sp)
    8000562c:	f062                	sd	s8,32(sp)
    8000562e:	ec66                	sd	s9,24(sp)
    80005630:	e86a                	sd	s10,16(sp)
    80005632:	1880                	addi	s0,sp,112
    80005634:	892a                	mv	s2,a0
    80005636:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005638:	00c52c83          	lw	s9,12(a0)
    8000563c:	001c9c9b          	slliw	s9,s9,0x1
    80005640:	1c82                	slli	s9,s9,0x20
    80005642:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005646:	00014517          	auipc	a0,0x14
    8000564a:	75250513          	addi	a0,a0,1874 # 80019d98 <disk+0x128>
    8000564e:	00001097          	auipc	ra,0x1
    80005652:	d7e080e7          	jalr	-642(ra) # 800063cc <acquire>
  for(int i = 0; i < 3; i++){
    80005656:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005658:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000565a:	00014b17          	auipc	s6,0x14
    8000565e:	616b0b13          	addi	s6,s6,1558 # 80019c70 <disk>
  for(int i = 0; i < 3; i++){
    80005662:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005664:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005666:	00014c17          	auipc	s8,0x14
    8000566a:	732c0c13          	addi	s8,s8,1842 # 80019d98 <disk+0x128>
    8000566e:	a8b5                	j	800056ea <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005670:	00fb06b3          	add	a3,s6,a5
    80005674:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005678:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000567a:	0207c563          	bltz	a5,800056a4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000567e:	2485                	addiw	s1,s1,1
    80005680:	0711                	addi	a4,a4,4
    80005682:	1f548a63          	beq	s1,s5,80005876 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005686:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005688:	00014697          	auipc	a3,0x14
    8000568c:	5e868693          	addi	a3,a3,1512 # 80019c70 <disk>
    80005690:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005692:	0186c583          	lbu	a1,24(a3)
    80005696:	fde9                	bnez	a1,80005670 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005698:	2785                	addiw	a5,a5,1
    8000569a:	0685                	addi	a3,a3,1
    8000569c:	ff779be3          	bne	a5,s7,80005692 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800056a0:	57fd                	li	a5,-1
    800056a2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800056a4:	02905a63          	blez	s1,800056d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056a8:	f9042503          	lw	a0,-112(s0)
    800056ac:	00000097          	auipc	ra,0x0
    800056b0:	cfa080e7          	jalr	-774(ra) # 800053a6 <free_desc>
      for(int j = 0; j < i; j++)
    800056b4:	4785                	li	a5,1
    800056b6:	0297d163          	bge	a5,s1,800056d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056ba:	f9442503          	lw	a0,-108(s0)
    800056be:	00000097          	auipc	ra,0x0
    800056c2:	ce8080e7          	jalr	-792(ra) # 800053a6 <free_desc>
      for(int j = 0; j < i; j++)
    800056c6:	4789                	li	a5,2
    800056c8:	0097d863          	bge	a5,s1,800056d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056cc:	f9842503          	lw	a0,-104(s0)
    800056d0:	00000097          	auipc	ra,0x0
    800056d4:	cd6080e7          	jalr	-810(ra) # 800053a6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056d8:	85e2                	mv	a1,s8
    800056da:	00014517          	auipc	a0,0x14
    800056de:	5ae50513          	addi	a0,a0,1454 # 80019c88 <disk+0x18>
    800056e2:	ffffc097          	auipc	ra,0xffffc
    800056e6:	fce080e7          	jalr	-50(ra) # 800016b0 <sleep>
  for(int i = 0; i < 3; i++){
    800056ea:	f9040713          	addi	a4,s0,-112
    800056ee:	84ce                	mv	s1,s3
    800056f0:	bf59                	j	80005686 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800056f2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800056f6:	00479693          	slli	a3,a5,0x4
    800056fa:	00014797          	auipc	a5,0x14
    800056fe:	57678793          	addi	a5,a5,1398 # 80019c70 <disk>
    80005702:	97b6                	add	a5,a5,a3
    80005704:	4685                	li	a3,1
    80005706:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005708:	00014597          	auipc	a1,0x14
    8000570c:	56858593          	addi	a1,a1,1384 # 80019c70 <disk>
    80005710:	00a60793          	addi	a5,a2,10
    80005714:	0792                	slli	a5,a5,0x4
    80005716:	97ae                	add	a5,a5,a1
    80005718:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000571c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005720:	f6070693          	addi	a3,a4,-160
    80005724:	619c                	ld	a5,0(a1)
    80005726:	97b6                	add	a5,a5,a3
    80005728:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000572a:	6188                	ld	a0,0(a1)
    8000572c:	96aa                	add	a3,a3,a0
    8000572e:	47c1                	li	a5,16
    80005730:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005732:	4785                	li	a5,1
    80005734:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005738:	f9442783          	lw	a5,-108(s0)
    8000573c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005740:	0792                	slli	a5,a5,0x4
    80005742:	953e                	add	a0,a0,a5
    80005744:	05890693          	addi	a3,s2,88
    80005748:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000574a:	6188                	ld	a0,0(a1)
    8000574c:	97aa                	add	a5,a5,a0
    8000574e:	40000693          	li	a3,1024
    80005752:	c794                	sw	a3,8(a5)
  if(write)
    80005754:	100d0d63          	beqz	s10,8000586e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005758:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000575c:	00c7d683          	lhu	a3,12(a5)
    80005760:	0016e693          	ori	a3,a3,1
    80005764:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005768:	f9842583          	lw	a1,-104(s0)
    8000576c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005770:	00014697          	auipc	a3,0x14
    80005774:	50068693          	addi	a3,a3,1280 # 80019c70 <disk>
    80005778:	00260793          	addi	a5,a2,2
    8000577c:	0792                	slli	a5,a5,0x4
    8000577e:	97b6                	add	a5,a5,a3
    80005780:	587d                	li	a6,-1
    80005782:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005786:	0592                	slli	a1,a1,0x4
    80005788:	952e                	add	a0,a0,a1
    8000578a:	f9070713          	addi	a4,a4,-112
    8000578e:	9736                	add	a4,a4,a3
    80005790:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005792:	6298                	ld	a4,0(a3)
    80005794:	972e                	add	a4,a4,a1
    80005796:	4585                	li	a1,1
    80005798:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000579a:	4509                	li	a0,2
    8000579c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800057a0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057a4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800057a8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057ac:	6698                	ld	a4,8(a3)
    800057ae:	00275783          	lhu	a5,2(a4)
    800057b2:	8b9d                	andi	a5,a5,7
    800057b4:	0786                	slli	a5,a5,0x1
    800057b6:	97ba                	add	a5,a5,a4
    800057b8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800057bc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057c0:	6698                	ld	a4,8(a3)
    800057c2:	00275783          	lhu	a5,2(a4)
    800057c6:	2785                	addiw	a5,a5,1
    800057c8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057cc:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057d0:	100017b7          	lui	a5,0x10001
    800057d4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057d8:	00492703          	lw	a4,4(s2)
    800057dc:	4785                	li	a5,1
    800057de:	02f71163          	bne	a4,a5,80005800 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800057e2:	00014997          	auipc	s3,0x14
    800057e6:	5b698993          	addi	s3,s3,1462 # 80019d98 <disk+0x128>
  while(b->disk == 1) {
    800057ea:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057ec:	85ce                	mv	a1,s3
    800057ee:	854a                	mv	a0,s2
    800057f0:	ffffc097          	auipc	ra,0xffffc
    800057f4:	ec0080e7          	jalr	-320(ra) # 800016b0 <sleep>
  while(b->disk == 1) {
    800057f8:	00492783          	lw	a5,4(s2)
    800057fc:	fe9788e3          	beq	a5,s1,800057ec <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005800:	f9042903          	lw	s2,-112(s0)
    80005804:	00290793          	addi	a5,s2,2
    80005808:	00479713          	slli	a4,a5,0x4
    8000580c:	00014797          	auipc	a5,0x14
    80005810:	46478793          	addi	a5,a5,1124 # 80019c70 <disk>
    80005814:	97ba                	add	a5,a5,a4
    80005816:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000581a:	00014997          	auipc	s3,0x14
    8000581e:	45698993          	addi	s3,s3,1110 # 80019c70 <disk>
    80005822:	00491713          	slli	a4,s2,0x4
    80005826:	0009b783          	ld	a5,0(s3)
    8000582a:	97ba                	add	a5,a5,a4
    8000582c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005830:	854a                	mv	a0,s2
    80005832:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005836:	00000097          	auipc	ra,0x0
    8000583a:	b70080e7          	jalr	-1168(ra) # 800053a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000583e:	8885                	andi	s1,s1,1
    80005840:	f0ed                	bnez	s1,80005822 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005842:	00014517          	auipc	a0,0x14
    80005846:	55650513          	addi	a0,a0,1366 # 80019d98 <disk+0x128>
    8000584a:	00001097          	auipc	ra,0x1
    8000584e:	c36080e7          	jalr	-970(ra) # 80006480 <release>
}
    80005852:	70a6                	ld	ra,104(sp)
    80005854:	7406                	ld	s0,96(sp)
    80005856:	64e6                	ld	s1,88(sp)
    80005858:	6946                	ld	s2,80(sp)
    8000585a:	69a6                	ld	s3,72(sp)
    8000585c:	6a06                	ld	s4,64(sp)
    8000585e:	7ae2                	ld	s5,56(sp)
    80005860:	7b42                	ld	s6,48(sp)
    80005862:	7ba2                	ld	s7,40(sp)
    80005864:	7c02                	ld	s8,32(sp)
    80005866:	6ce2                	ld	s9,24(sp)
    80005868:	6d42                	ld	s10,16(sp)
    8000586a:	6165                	addi	sp,sp,112
    8000586c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000586e:	4689                	li	a3,2
    80005870:	00d79623          	sh	a3,12(a5)
    80005874:	b5e5                	j	8000575c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005876:	f9042603          	lw	a2,-112(s0)
    8000587a:	00a60713          	addi	a4,a2,10
    8000587e:	0712                	slli	a4,a4,0x4
    80005880:	00014517          	auipc	a0,0x14
    80005884:	3f850513          	addi	a0,a0,1016 # 80019c78 <disk+0x8>
    80005888:	953a                	add	a0,a0,a4
  if(write)
    8000588a:	e60d14e3          	bnez	s10,800056f2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000588e:	00a60793          	addi	a5,a2,10
    80005892:	00479693          	slli	a3,a5,0x4
    80005896:	00014797          	auipc	a5,0x14
    8000589a:	3da78793          	addi	a5,a5,986 # 80019c70 <disk>
    8000589e:	97b6                	add	a5,a5,a3
    800058a0:	0007a423          	sw	zero,8(a5)
    800058a4:	b595                	j	80005708 <virtio_disk_rw+0xf0>

00000000800058a6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058a6:	1101                	addi	sp,sp,-32
    800058a8:	ec06                	sd	ra,24(sp)
    800058aa:	e822                	sd	s0,16(sp)
    800058ac:	e426                	sd	s1,8(sp)
    800058ae:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058b0:	00014497          	auipc	s1,0x14
    800058b4:	3c048493          	addi	s1,s1,960 # 80019c70 <disk>
    800058b8:	00014517          	auipc	a0,0x14
    800058bc:	4e050513          	addi	a0,a0,1248 # 80019d98 <disk+0x128>
    800058c0:	00001097          	auipc	ra,0x1
    800058c4:	b0c080e7          	jalr	-1268(ra) # 800063cc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058c8:	10001737          	lui	a4,0x10001
    800058cc:	533c                	lw	a5,96(a4)
    800058ce:	8b8d                	andi	a5,a5,3
    800058d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058d2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058d6:	689c                	ld	a5,16(s1)
    800058d8:	0204d703          	lhu	a4,32(s1)
    800058dc:	0027d783          	lhu	a5,2(a5)
    800058e0:	04f70863          	beq	a4,a5,80005930 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800058e4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058e8:	6898                	ld	a4,16(s1)
    800058ea:	0204d783          	lhu	a5,32(s1)
    800058ee:	8b9d                	andi	a5,a5,7
    800058f0:	078e                	slli	a5,a5,0x3
    800058f2:	97ba                	add	a5,a5,a4
    800058f4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058f6:	00278713          	addi	a4,a5,2
    800058fa:	0712                	slli	a4,a4,0x4
    800058fc:	9726                	add	a4,a4,s1
    800058fe:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005902:	e721                	bnez	a4,8000594a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005904:	0789                	addi	a5,a5,2
    80005906:	0792                	slli	a5,a5,0x4
    80005908:	97a6                	add	a5,a5,s1
    8000590a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000590c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005910:	ffffc097          	auipc	ra,0xffffc
    80005914:	e04080e7          	jalr	-508(ra) # 80001714 <wakeup>

    disk.used_idx += 1;
    80005918:	0204d783          	lhu	a5,32(s1)
    8000591c:	2785                	addiw	a5,a5,1
    8000591e:	17c2                	slli	a5,a5,0x30
    80005920:	93c1                	srli	a5,a5,0x30
    80005922:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005926:	6898                	ld	a4,16(s1)
    80005928:	00275703          	lhu	a4,2(a4)
    8000592c:	faf71ce3          	bne	a4,a5,800058e4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005930:	00014517          	auipc	a0,0x14
    80005934:	46850513          	addi	a0,a0,1128 # 80019d98 <disk+0x128>
    80005938:	00001097          	auipc	ra,0x1
    8000593c:	b48080e7          	jalr	-1208(ra) # 80006480 <release>
}
    80005940:	60e2                	ld	ra,24(sp)
    80005942:	6442                	ld	s0,16(sp)
    80005944:	64a2                	ld	s1,8(sp)
    80005946:	6105                	addi	sp,sp,32
    80005948:	8082                	ret
      panic("virtio_disk_intr status");
    8000594a:	00003517          	auipc	a0,0x3
    8000594e:	ef650513          	addi	a0,a0,-266 # 80008840 <syscalls+0x428>
    80005952:	00000097          	auipc	ra,0x0
    80005956:	530080e7          	jalr	1328(ra) # 80005e82 <panic>

000000008000595a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000595a:	1141                	addi	sp,sp,-16
    8000595c:	e422                	sd	s0,8(sp)
    8000595e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005960:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005964:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005968:	0037979b          	slliw	a5,a5,0x3
    8000596c:	02004737          	lui	a4,0x2004
    80005970:	97ba                	add	a5,a5,a4
    80005972:	0200c737          	lui	a4,0x200c
    80005976:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000597a:	000f4637          	lui	a2,0xf4
    8000597e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005982:	95b2                	add	a1,a1,a2
    80005984:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005986:	00269713          	slli	a4,a3,0x2
    8000598a:	9736                	add	a4,a4,a3
    8000598c:	00371693          	slli	a3,a4,0x3
    80005990:	00014717          	auipc	a4,0x14
    80005994:	42070713          	addi	a4,a4,1056 # 80019db0 <timer_scratch>
    80005998:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000599a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000599c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000599e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059a2:	00000797          	auipc	a5,0x0
    800059a6:	93e78793          	addi	a5,a5,-1730 # 800052e0 <timervec>
    800059aa:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059ae:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059b2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059b6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059ba:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059be:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059c2:	30479073          	csrw	mie,a5
}
    800059c6:	6422                	ld	s0,8(sp)
    800059c8:	0141                	addi	sp,sp,16
    800059ca:	8082                	ret

00000000800059cc <start>:
{
    800059cc:	1141                	addi	sp,sp,-16
    800059ce:	e406                	sd	ra,8(sp)
    800059d0:	e022                	sd	s0,0(sp)
    800059d2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059d4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059d8:	7779                	lui	a4,0xffffe
    800059da:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc80f>
    800059de:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059e0:	6705                	lui	a4,0x1
    800059e2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059e6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059e8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059ec:	ffffb797          	auipc	a5,0xffffb
    800059f0:	93a78793          	addi	a5,a5,-1734 # 80000326 <main>
    800059f4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059f8:	4781                	li	a5,0
    800059fa:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059fe:	67c1                	lui	a5,0x10
    80005a00:	17fd                	addi	a5,a5,-1
    80005a02:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a06:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a0a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a0e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a12:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a16:	57fd                	li	a5,-1
    80005a18:	83a9                	srli	a5,a5,0xa
    80005a1a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a1e:	47bd                	li	a5,15
    80005a20:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a24:	00000097          	auipc	ra,0x0
    80005a28:	f36080e7          	jalr	-202(ra) # 8000595a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a2c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a30:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a32:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a34:	30200073          	mret
}
    80005a38:	60a2                	ld	ra,8(sp)
    80005a3a:	6402                	ld	s0,0(sp)
    80005a3c:	0141                	addi	sp,sp,16
    80005a3e:	8082                	ret

0000000080005a40 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a40:	715d                	addi	sp,sp,-80
    80005a42:	e486                	sd	ra,72(sp)
    80005a44:	e0a2                	sd	s0,64(sp)
    80005a46:	fc26                	sd	s1,56(sp)
    80005a48:	f84a                	sd	s2,48(sp)
    80005a4a:	f44e                	sd	s3,40(sp)
    80005a4c:	f052                	sd	s4,32(sp)
    80005a4e:	ec56                	sd	s5,24(sp)
    80005a50:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a52:	04c05663          	blez	a2,80005a9e <consolewrite+0x5e>
    80005a56:	8a2a                	mv	s4,a0
    80005a58:	84ae                	mv	s1,a1
    80005a5a:	89b2                	mv	s3,a2
    80005a5c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a5e:	5afd                	li	s5,-1
    80005a60:	4685                	li	a3,1
    80005a62:	8626                	mv	a2,s1
    80005a64:	85d2                	mv	a1,s4
    80005a66:	fbf40513          	addi	a0,s0,-65
    80005a6a:	ffffc097          	auipc	ra,0xffffc
    80005a6e:	0a4080e7          	jalr	164(ra) # 80001b0e <either_copyin>
    80005a72:	01550c63          	beq	a0,s5,80005a8a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a76:	fbf44503          	lbu	a0,-65(s0)
    80005a7a:	00000097          	auipc	ra,0x0
    80005a7e:	794080e7          	jalr	1940(ra) # 8000620e <uartputc>
  for(i = 0; i < n; i++){
    80005a82:	2905                	addiw	s2,s2,1
    80005a84:	0485                	addi	s1,s1,1
    80005a86:	fd299de3          	bne	s3,s2,80005a60 <consolewrite+0x20>
  }

  return i;
}
    80005a8a:	854a                	mv	a0,s2
    80005a8c:	60a6                	ld	ra,72(sp)
    80005a8e:	6406                	ld	s0,64(sp)
    80005a90:	74e2                	ld	s1,56(sp)
    80005a92:	7942                	ld	s2,48(sp)
    80005a94:	79a2                	ld	s3,40(sp)
    80005a96:	7a02                	ld	s4,32(sp)
    80005a98:	6ae2                	ld	s5,24(sp)
    80005a9a:	6161                	addi	sp,sp,80
    80005a9c:	8082                	ret
  for(i = 0; i < n; i++){
    80005a9e:	4901                	li	s2,0
    80005aa0:	b7ed                	j	80005a8a <consolewrite+0x4a>

0000000080005aa2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005aa2:	7119                	addi	sp,sp,-128
    80005aa4:	fc86                	sd	ra,120(sp)
    80005aa6:	f8a2                	sd	s0,112(sp)
    80005aa8:	f4a6                	sd	s1,104(sp)
    80005aaa:	f0ca                	sd	s2,96(sp)
    80005aac:	ecce                	sd	s3,88(sp)
    80005aae:	e8d2                	sd	s4,80(sp)
    80005ab0:	e4d6                	sd	s5,72(sp)
    80005ab2:	e0da                	sd	s6,64(sp)
    80005ab4:	fc5e                	sd	s7,56(sp)
    80005ab6:	f862                	sd	s8,48(sp)
    80005ab8:	f466                	sd	s9,40(sp)
    80005aba:	f06a                	sd	s10,32(sp)
    80005abc:	ec6e                	sd	s11,24(sp)
    80005abe:	0100                	addi	s0,sp,128
    80005ac0:	8b2a                	mv	s6,a0
    80005ac2:	8aae                	mv	s5,a1
    80005ac4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ac6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005aca:	0001c517          	auipc	a0,0x1c
    80005ace:	42650513          	addi	a0,a0,1062 # 80021ef0 <cons>
    80005ad2:	00001097          	auipc	ra,0x1
    80005ad6:	8fa080e7          	jalr	-1798(ra) # 800063cc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ada:	0001c497          	auipc	s1,0x1c
    80005ade:	41648493          	addi	s1,s1,1046 # 80021ef0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ae2:	89a6                	mv	s3,s1
    80005ae4:	0001c917          	auipc	s2,0x1c
    80005ae8:	4a490913          	addi	s2,s2,1188 # 80021f88 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005aec:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005aee:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005af0:	4da9                	li	s11,10
  while(n > 0){
    80005af2:	07405b63          	blez	s4,80005b68 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005af6:	0984a783          	lw	a5,152(s1)
    80005afa:	09c4a703          	lw	a4,156(s1)
    80005afe:	02f71763          	bne	a4,a5,80005b2c <consoleread+0x8a>
      if(killed(myproc())){
    80005b02:	ffffb097          	auipc	ra,0xffffb
    80005b06:	470080e7          	jalr	1136(ra) # 80000f72 <myproc>
    80005b0a:	ffffc097          	auipc	ra,0xffffc
    80005b0e:	e4e080e7          	jalr	-434(ra) # 80001958 <killed>
    80005b12:	e535                	bnez	a0,80005b7e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005b14:	85ce                	mv	a1,s3
    80005b16:	854a                	mv	a0,s2
    80005b18:	ffffc097          	auipc	ra,0xffffc
    80005b1c:	b98080e7          	jalr	-1128(ra) # 800016b0 <sleep>
    while(cons.r == cons.w){
    80005b20:	0984a783          	lw	a5,152(s1)
    80005b24:	09c4a703          	lw	a4,156(s1)
    80005b28:	fcf70de3          	beq	a4,a5,80005b02 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b2c:	0017871b          	addiw	a4,a5,1
    80005b30:	08e4ac23          	sw	a4,152(s1)
    80005b34:	07f7f713          	andi	a4,a5,127
    80005b38:	9726                	add	a4,a4,s1
    80005b3a:	01874703          	lbu	a4,24(a4)
    80005b3e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005b42:	079c0663          	beq	s8,s9,80005bae <consoleread+0x10c>
    cbuf = c;
    80005b46:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b4a:	4685                	li	a3,1
    80005b4c:	f8f40613          	addi	a2,s0,-113
    80005b50:	85d6                	mv	a1,s5
    80005b52:	855a                	mv	a0,s6
    80005b54:	ffffc097          	auipc	ra,0xffffc
    80005b58:	f64080e7          	jalr	-156(ra) # 80001ab8 <either_copyout>
    80005b5c:	01a50663          	beq	a0,s10,80005b68 <consoleread+0xc6>
    dst++;
    80005b60:	0a85                	addi	s5,s5,1
    --n;
    80005b62:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b64:	f9bc17e3          	bne	s8,s11,80005af2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b68:	0001c517          	auipc	a0,0x1c
    80005b6c:	38850513          	addi	a0,a0,904 # 80021ef0 <cons>
    80005b70:	00001097          	auipc	ra,0x1
    80005b74:	910080e7          	jalr	-1776(ra) # 80006480 <release>

  return target - n;
    80005b78:	414b853b          	subw	a0,s7,s4
    80005b7c:	a811                	j	80005b90 <consoleread+0xee>
        release(&cons.lock);
    80005b7e:	0001c517          	auipc	a0,0x1c
    80005b82:	37250513          	addi	a0,a0,882 # 80021ef0 <cons>
    80005b86:	00001097          	auipc	ra,0x1
    80005b8a:	8fa080e7          	jalr	-1798(ra) # 80006480 <release>
        return -1;
    80005b8e:	557d                	li	a0,-1
}
    80005b90:	70e6                	ld	ra,120(sp)
    80005b92:	7446                	ld	s0,112(sp)
    80005b94:	74a6                	ld	s1,104(sp)
    80005b96:	7906                	ld	s2,96(sp)
    80005b98:	69e6                	ld	s3,88(sp)
    80005b9a:	6a46                	ld	s4,80(sp)
    80005b9c:	6aa6                	ld	s5,72(sp)
    80005b9e:	6b06                	ld	s6,64(sp)
    80005ba0:	7be2                	ld	s7,56(sp)
    80005ba2:	7c42                	ld	s8,48(sp)
    80005ba4:	7ca2                	ld	s9,40(sp)
    80005ba6:	7d02                	ld	s10,32(sp)
    80005ba8:	6de2                	ld	s11,24(sp)
    80005baa:	6109                	addi	sp,sp,128
    80005bac:	8082                	ret
      if(n < target){
    80005bae:	000a071b          	sext.w	a4,s4
    80005bb2:	fb777be3          	bgeu	a4,s7,80005b68 <consoleread+0xc6>
        cons.r--;
    80005bb6:	0001c717          	auipc	a4,0x1c
    80005bba:	3cf72923          	sw	a5,978(a4) # 80021f88 <cons+0x98>
    80005bbe:	b76d                	j	80005b68 <consoleread+0xc6>

0000000080005bc0 <consputc>:
{
    80005bc0:	1141                	addi	sp,sp,-16
    80005bc2:	e406                	sd	ra,8(sp)
    80005bc4:	e022                	sd	s0,0(sp)
    80005bc6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005bc8:	10000793          	li	a5,256
    80005bcc:	00f50a63          	beq	a0,a5,80005be0 <consputc+0x20>
    uartputc_sync(c);
    80005bd0:	00000097          	auipc	ra,0x0
    80005bd4:	564080e7          	jalr	1380(ra) # 80006134 <uartputc_sync>
}
    80005bd8:	60a2                	ld	ra,8(sp)
    80005bda:	6402                	ld	s0,0(sp)
    80005bdc:	0141                	addi	sp,sp,16
    80005bde:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005be0:	4521                	li	a0,8
    80005be2:	00000097          	auipc	ra,0x0
    80005be6:	552080e7          	jalr	1362(ra) # 80006134 <uartputc_sync>
    80005bea:	02000513          	li	a0,32
    80005bee:	00000097          	auipc	ra,0x0
    80005bf2:	546080e7          	jalr	1350(ra) # 80006134 <uartputc_sync>
    80005bf6:	4521                	li	a0,8
    80005bf8:	00000097          	auipc	ra,0x0
    80005bfc:	53c080e7          	jalr	1340(ra) # 80006134 <uartputc_sync>
    80005c00:	bfe1                	j	80005bd8 <consputc+0x18>

0000000080005c02 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c02:	1101                	addi	sp,sp,-32
    80005c04:	ec06                	sd	ra,24(sp)
    80005c06:	e822                	sd	s0,16(sp)
    80005c08:	e426                	sd	s1,8(sp)
    80005c0a:	e04a                	sd	s2,0(sp)
    80005c0c:	1000                	addi	s0,sp,32
    80005c0e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c10:	0001c517          	auipc	a0,0x1c
    80005c14:	2e050513          	addi	a0,a0,736 # 80021ef0 <cons>
    80005c18:	00000097          	auipc	ra,0x0
    80005c1c:	7b4080e7          	jalr	1972(ra) # 800063cc <acquire>

  switch(c){
    80005c20:	47d5                	li	a5,21
    80005c22:	0af48663          	beq	s1,a5,80005cce <consoleintr+0xcc>
    80005c26:	0297ca63          	blt	a5,s1,80005c5a <consoleintr+0x58>
    80005c2a:	47a1                	li	a5,8
    80005c2c:	0ef48763          	beq	s1,a5,80005d1a <consoleintr+0x118>
    80005c30:	47c1                	li	a5,16
    80005c32:	10f49a63          	bne	s1,a5,80005d46 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c36:	ffffc097          	auipc	ra,0xffffc
    80005c3a:	f2e080e7          	jalr	-210(ra) # 80001b64 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c3e:	0001c517          	auipc	a0,0x1c
    80005c42:	2b250513          	addi	a0,a0,690 # 80021ef0 <cons>
    80005c46:	00001097          	auipc	ra,0x1
    80005c4a:	83a080e7          	jalr	-1990(ra) # 80006480 <release>
}
    80005c4e:	60e2                	ld	ra,24(sp)
    80005c50:	6442                	ld	s0,16(sp)
    80005c52:	64a2                	ld	s1,8(sp)
    80005c54:	6902                	ld	s2,0(sp)
    80005c56:	6105                	addi	sp,sp,32
    80005c58:	8082                	ret
  switch(c){
    80005c5a:	07f00793          	li	a5,127
    80005c5e:	0af48e63          	beq	s1,a5,80005d1a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c62:	0001c717          	auipc	a4,0x1c
    80005c66:	28e70713          	addi	a4,a4,654 # 80021ef0 <cons>
    80005c6a:	0a072783          	lw	a5,160(a4)
    80005c6e:	09872703          	lw	a4,152(a4)
    80005c72:	9f99                	subw	a5,a5,a4
    80005c74:	07f00713          	li	a4,127
    80005c78:	fcf763e3          	bltu	a4,a5,80005c3e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c7c:	47b5                	li	a5,13
    80005c7e:	0cf48763          	beq	s1,a5,80005d4c <consoleintr+0x14a>
      consputc(c);
    80005c82:	8526                	mv	a0,s1
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	f3c080e7          	jalr	-196(ra) # 80005bc0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c8c:	0001c797          	auipc	a5,0x1c
    80005c90:	26478793          	addi	a5,a5,612 # 80021ef0 <cons>
    80005c94:	0a07a683          	lw	a3,160(a5)
    80005c98:	0016871b          	addiw	a4,a3,1
    80005c9c:	0007061b          	sext.w	a2,a4
    80005ca0:	0ae7a023          	sw	a4,160(a5)
    80005ca4:	07f6f693          	andi	a3,a3,127
    80005ca8:	97b6                	add	a5,a5,a3
    80005caa:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005cae:	47a9                	li	a5,10
    80005cb0:	0cf48563          	beq	s1,a5,80005d7a <consoleintr+0x178>
    80005cb4:	4791                	li	a5,4
    80005cb6:	0cf48263          	beq	s1,a5,80005d7a <consoleintr+0x178>
    80005cba:	0001c797          	auipc	a5,0x1c
    80005cbe:	2ce7a783          	lw	a5,718(a5) # 80021f88 <cons+0x98>
    80005cc2:	9f1d                	subw	a4,a4,a5
    80005cc4:	08000793          	li	a5,128
    80005cc8:	f6f71be3          	bne	a4,a5,80005c3e <consoleintr+0x3c>
    80005ccc:	a07d                	j	80005d7a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005cce:	0001c717          	auipc	a4,0x1c
    80005cd2:	22270713          	addi	a4,a4,546 # 80021ef0 <cons>
    80005cd6:	0a072783          	lw	a5,160(a4)
    80005cda:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cde:	0001c497          	auipc	s1,0x1c
    80005ce2:	21248493          	addi	s1,s1,530 # 80021ef0 <cons>
    while(cons.e != cons.w &&
    80005ce6:	4929                	li	s2,10
    80005ce8:	f4f70be3          	beq	a4,a5,80005c3e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cec:	37fd                	addiw	a5,a5,-1
    80005cee:	07f7f713          	andi	a4,a5,127
    80005cf2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cf4:	01874703          	lbu	a4,24(a4)
    80005cf8:	f52703e3          	beq	a4,s2,80005c3e <consoleintr+0x3c>
      cons.e--;
    80005cfc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d00:	10000513          	li	a0,256
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	ebc080e7          	jalr	-324(ra) # 80005bc0 <consputc>
    while(cons.e != cons.w &&
    80005d0c:	0a04a783          	lw	a5,160(s1)
    80005d10:	09c4a703          	lw	a4,156(s1)
    80005d14:	fcf71ce3          	bne	a4,a5,80005cec <consoleintr+0xea>
    80005d18:	b71d                	j	80005c3e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d1a:	0001c717          	auipc	a4,0x1c
    80005d1e:	1d670713          	addi	a4,a4,470 # 80021ef0 <cons>
    80005d22:	0a072783          	lw	a5,160(a4)
    80005d26:	09c72703          	lw	a4,156(a4)
    80005d2a:	f0f70ae3          	beq	a4,a5,80005c3e <consoleintr+0x3c>
      cons.e--;
    80005d2e:	37fd                	addiw	a5,a5,-1
    80005d30:	0001c717          	auipc	a4,0x1c
    80005d34:	26f72023          	sw	a5,608(a4) # 80021f90 <cons+0xa0>
      consputc(BACKSPACE);
    80005d38:	10000513          	li	a0,256
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	e84080e7          	jalr	-380(ra) # 80005bc0 <consputc>
    80005d44:	bded                	j	80005c3e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d46:	ee048ce3          	beqz	s1,80005c3e <consoleintr+0x3c>
    80005d4a:	bf21                	j	80005c62 <consoleintr+0x60>
      consputc(c);
    80005d4c:	4529                	li	a0,10
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	e72080e7          	jalr	-398(ra) # 80005bc0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d56:	0001c797          	auipc	a5,0x1c
    80005d5a:	19a78793          	addi	a5,a5,410 # 80021ef0 <cons>
    80005d5e:	0a07a703          	lw	a4,160(a5)
    80005d62:	0017069b          	addiw	a3,a4,1
    80005d66:	0006861b          	sext.w	a2,a3
    80005d6a:	0ad7a023          	sw	a3,160(a5)
    80005d6e:	07f77713          	andi	a4,a4,127
    80005d72:	97ba                	add	a5,a5,a4
    80005d74:	4729                	li	a4,10
    80005d76:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d7a:	0001c797          	auipc	a5,0x1c
    80005d7e:	20c7a923          	sw	a2,530(a5) # 80021f8c <cons+0x9c>
        wakeup(&cons.r);
    80005d82:	0001c517          	auipc	a0,0x1c
    80005d86:	20650513          	addi	a0,a0,518 # 80021f88 <cons+0x98>
    80005d8a:	ffffc097          	auipc	ra,0xffffc
    80005d8e:	98a080e7          	jalr	-1654(ra) # 80001714 <wakeup>
    80005d92:	b575                	j	80005c3e <consoleintr+0x3c>

0000000080005d94 <consoleinit>:

void
consoleinit(void)
{
    80005d94:	1141                	addi	sp,sp,-16
    80005d96:	e406                	sd	ra,8(sp)
    80005d98:	e022                	sd	s0,0(sp)
    80005d9a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d9c:	00003597          	auipc	a1,0x3
    80005da0:	abc58593          	addi	a1,a1,-1348 # 80008858 <syscalls+0x440>
    80005da4:	0001c517          	auipc	a0,0x1c
    80005da8:	14c50513          	addi	a0,a0,332 # 80021ef0 <cons>
    80005dac:	00000097          	auipc	ra,0x0
    80005db0:	590080e7          	jalr	1424(ra) # 8000633c <initlock>

  uartinit();
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	330080e7          	jalr	816(ra) # 800060e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dbc:	00013797          	auipc	a5,0x13
    80005dc0:	e5c78793          	addi	a5,a5,-420 # 80018c18 <devsw>
    80005dc4:	00000717          	auipc	a4,0x0
    80005dc8:	cde70713          	addi	a4,a4,-802 # 80005aa2 <consoleread>
    80005dcc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dce:	00000717          	auipc	a4,0x0
    80005dd2:	c7270713          	addi	a4,a4,-910 # 80005a40 <consolewrite>
    80005dd6:	ef98                	sd	a4,24(a5)
}
    80005dd8:	60a2                	ld	ra,8(sp)
    80005dda:	6402                	ld	s0,0(sp)
    80005ddc:	0141                	addi	sp,sp,16
    80005dde:	8082                	ret

0000000080005de0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005de0:	7179                	addi	sp,sp,-48
    80005de2:	f406                	sd	ra,40(sp)
    80005de4:	f022                	sd	s0,32(sp)
    80005de6:	ec26                	sd	s1,24(sp)
    80005de8:	e84a                	sd	s2,16(sp)
    80005dea:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005dec:	c219                	beqz	a2,80005df2 <printint+0x12>
    80005dee:	08054663          	bltz	a0,80005e7a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005df2:	2501                	sext.w	a0,a0
    80005df4:	4881                	li	a7,0
    80005df6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005dfa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005dfc:	2581                	sext.w	a1,a1
    80005dfe:	00003617          	auipc	a2,0x3
    80005e02:	a8a60613          	addi	a2,a2,-1398 # 80008888 <digits>
    80005e06:	883a                	mv	a6,a4
    80005e08:	2705                	addiw	a4,a4,1
    80005e0a:	02b577bb          	remuw	a5,a0,a1
    80005e0e:	1782                	slli	a5,a5,0x20
    80005e10:	9381                	srli	a5,a5,0x20
    80005e12:	97b2                	add	a5,a5,a2
    80005e14:	0007c783          	lbu	a5,0(a5)
    80005e18:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e1c:	0005079b          	sext.w	a5,a0
    80005e20:	02b5553b          	divuw	a0,a0,a1
    80005e24:	0685                	addi	a3,a3,1
    80005e26:	feb7f0e3          	bgeu	a5,a1,80005e06 <printint+0x26>

  if(sign)
    80005e2a:	00088b63          	beqz	a7,80005e40 <printint+0x60>
    buf[i++] = '-';
    80005e2e:	fe040793          	addi	a5,s0,-32
    80005e32:	973e                	add	a4,a4,a5
    80005e34:	02d00793          	li	a5,45
    80005e38:	fef70823          	sb	a5,-16(a4)
    80005e3c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e40:	02e05763          	blez	a4,80005e6e <printint+0x8e>
    80005e44:	fd040793          	addi	a5,s0,-48
    80005e48:	00e784b3          	add	s1,a5,a4
    80005e4c:	fff78913          	addi	s2,a5,-1
    80005e50:	993a                	add	s2,s2,a4
    80005e52:	377d                	addiw	a4,a4,-1
    80005e54:	1702                	slli	a4,a4,0x20
    80005e56:	9301                	srli	a4,a4,0x20
    80005e58:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e5c:	fff4c503          	lbu	a0,-1(s1)
    80005e60:	00000097          	auipc	ra,0x0
    80005e64:	d60080e7          	jalr	-672(ra) # 80005bc0 <consputc>
  while(--i >= 0)
    80005e68:	14fd                	addi	s1,s1,-1
    80005e6a:	ff2499e3          	bne	s1,s2,80005e5c <printint+0x7c>
}
    80005e6e:	70a2                	ld	ra,40(sp)
    80005e70:	7402                	ld	s0,32(sp)
    80005e72:	64e2                	ld	s1,24(sp)
    80005e74:	6942                	ld	s2,16(sp)
    80005e76:	6145                	addi	sp,sp,48
    80005e78:	8082                	ret
    x = -xx;
    80005e7a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e7e:	4885                	li	a7,1
    x = -xx;
    80005e80:	bf9d                	j	80005df6 <printint+0x16>

0000000080005e82 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e82:	1101                	addi	sp,sp,-32
    80005e84:	ec06                	sd	ra,24(sp)
    80005e86:	e822                	sd	s0,16(sp)
    80005e88:	e426                	sd	s1,8(sp)
    80005e8a:	1000                	addi	s0,sp,32
    80005e8c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e8e:	0001c797          	auipc	a5,0x1c
    80005e92:	1207a123          	sw	zero,290(a5) # 80021fb0 <pr+0x18>
  printf("panic: ");
    80005e96:	00003517          	auipc	a0,0x3
    80005e9a:	9ca50513          	addi	a0,a0,-1590 # 80008860 <syscalls+0x448>
    80005e9e:	00000097          	auipc	ra,0x0
    80005ea2:	02e080e7          	jalr	46(ra) # 80005ecc <printf>
  printf(s);
    80005ea6:	8526                	mv	a0,s1
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	024080e7          	jalr	36(ra) # 80005ecc <printf>
  printf("\n");
    80005eb0:	00002517          	auipc	a0,0x2
    80005eb4:	19850513          	addi	a0,a0,408 # 80008048 <etext+0x48>
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	014080e7          	jalr	20(ra) # 80005ecc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ec0:	4785                	li	a5,1
    80005ec2:	00003717          	auipc	a4,0x3
    80005ec6:	aaf72523          	sw	a5,-1366(a4) # 8000896c <panicked>
  for(;;)
    80005eca:	a001                	j	80005eca <panic+0x48>

0000000080005ecc <printf>:
{
    80005ecc:	7131                	addi	sp,sp,-192
    80005ece:	fc86                	sd	ra,120(sp)
    80005ed0:	f8a2                	sd	s0,112(sp)
    80005ed2:	f4a6                	sd	s1,104(sp)
    80005ed4:	f0ca                	sd	s2,96(sp)
    80005ed6:	ecce                	sd	s3,88(sp)
    80005ed8:	e8d2                	sd	s4,80(sp)
    80005eda:	e4d6                	sd	s5,72(sp)
    80005edc:	e0da                	sd	s6,64(sp)
    80005ede:	fc5e                	sd	s7,56(sp)
    80005ee0:	f862                	sd	s8,48(sp)
    80005ee2:	f466                	sd	s9,40(sp)
    80005ee4:	f06a                	sd	s10,32(sp)
    80005ee6:	ec6e                	sd	s11,24(sp)
    80005ee8:	0100                	addi	s0,sp,128
    80005eea:	8a2a                	mv	s4,a0
    80005eec:	e40c                	sd	a1,8(s0)
    80005eee:	e810                	sd	a2,16(s0)
    80005ef0:	ec14                	sd	a3,24(s0)
    80005ef2:	f018                	sd	a4,32(s0)
    80005ef4:	f41c                	sd	a5,40(s0)
    80005ef6:	03043823          	sd	a6,48(s0)
    80005efa:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005efe:	0001cd97          	auipc	s11,0x1c
    80005f02:	0b2dad83          	lw	s11,178(s11) # 80021fb0 <pr+0x18>
  if(locking)
    80005f06:	020d9b63          	bnez	s11,80005f3c <printf+0x70>
  if (fmt == 0)
    80005f0a:	040a0263          	beqz	s4,80005f4e <printf+0x82>
  va_start(ap, fmt);
    80005f0e:	00840793          	addi	a5,s0,8
    80005f12:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f16:	000a4503          	lbu	a0,0(s4)
    80005f1a:	16050263          	beqz	a0,8000607e <printf+0x1b2>
    80005f1e:	4481                	li	s1,0
    if(c != '%'){
    80005f20:	02500a93          	li	s5,37
    switch(c){
    80005f24:	07000b13          	li	s6,112
  consputc('x');
    80005f28:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f2a:	00003b97          	auipc	s7,0x3
    80005f2e:	95eb8b93          	addi	s7,s7,-1698 # 80008888 <digits>
    switch(c){
    80005f32:	07300c93          	li	s9,115
    80005f36:	06400c13          	li	s8,100
    80005f3a:	a82d                	j	80005f74 <printf+0xa8>
    acquire(&pr.lock);
    80005f3c:	0001c517          	auipc	a0,0x1c
    80005f40:	05c50513          	addi	a0,a0,92 # 80021f98 <pr>
    80005f44:	00000097          	auipc	ra,0x0
    80005f48:	488080e7          	jalr	1160(ra) # 800063cc <acquire>
    80005f4c:	bf7d                	j	80005f0a <printf+0x3e>
    panic("null fmt");
    80005f4e:	00003517          	auipc	a0,0x3
    80005f52:	92250513          	addi	a0,a0,-1758 # 80008870 <syscalls+0x458>
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	f2c080e7          	jalr	-212(ra) # 80005e82 <panic>
      consputc(c);
    80005f5e:	00000097          	auipc	ra,0x0
    80005f62:	c62080e7          	jalr	-926(ra) # 80005bc0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f66:	2485                	addiw	s1,s1,1
    80005f68:	009a07b3          	add	a5,s4,s1
    80005f6c:	0007c503          	lbu	a0,0(a5)
    80005f70:	10050763          	beqz	a0,8000607e <printf+0x1b2>
    if(c != '%'){
    80005f74:	ff5515e3          	bne	a0,s5,80005f5e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f78:	2485                	addiw	s1,s1,1
    80005f7a:	009a07b3          	add	a5,s4,s1
    80005f7e:	0007c783          	lbu	a5,0(a5)
    80005f82:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f86:	cfe5                	beqz	a5,8000607e <printf+0x1b2>
    switch(c){
    80005f88:	05678a63          	beq	a5,s6,80005fdc <printf+0x110>
    80005f8c:	02fb7663          	bgeu	s6,a5,80005fb8 <printf+0xec>
    80005f90:	09978963          	beq	a5,s9,80006022 <printf+0x156>
    80005f94:	07800713          	li	a4,120
    80005f98:	0ce79863          	bne	a5,a4,80006068 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f9c:	f8843783          	ld	a5,-120(s0)
    80005fa0:	00878713          	addi	a4,a5,8
    80005fa4:	f8e43423          	sd	a4,-120(s0)
    80005fa8:	4605                	li	a2,1
    80005faa:	85ea                	mv	a1,s10
    80005fac:	4388                	lw	a0,0(a5)
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	e32080e7          	jalr	-462(ra) # 80005de0 <printint>
      break;
    80005fb6:	bf45                	j	80005f66 <printf+0x9a>
    switch(c){
    80005fb8:	0b578263          	beq	a5,s5,8000605c <printf+0x190>
    80005fbc:	0b879663          	bne	a5,s8,80006068 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005fc0:	f8843783          	ld	a5,-120(s0)
    80005fc4:	00878713          	addi	a4,a5,8
    80005fc8:	f8e43423          	sd	a4,-120(s0)
    80005fcc:	4605                	li	a2,1
    80005fce:	45a9                	li	a1,10
    80005fd0:	4388                	lw	a0,0(a5)
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	e0e080e7          	jalr	-498(ra) # 80005de0 <printint>
      break;
    80005fda:	b771                	j	80005f66 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005fdc:	f8843783          	ld	a5,-120(s0)
    80005fe0:	00878713          	addi	a4,a5,8
    80005fe4:	f8e43423          	sd	a4,-120(s0)
    80005fe8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005fec:	03000513          	li	a0,48
    80005ff0:	00000097          	auipc	ra,0x0
    80005ff4:	bd0080e7          	jalr	-1072(ra) # 80005bc0 <consputc>
  consputc('x');
    80005ff8:	07800513          	li	a0,120
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	bc4080e7          	jalr	-1084(ra) # 80005bc0 <consputc>
    80006004:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006006:	03c9d793          	srli	a5,s3,0x3c
    8000600a:	97de                	add	a5,a5,s7
    8000600c:	0007c503          	lbu	a0,0(a5)
    80006010:	00000097          	auipc	ra,0x0
    80006014:	bb0080e7          	jalr	-1104(ra) # 80005bc0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006018:	0992                	slli	s3,s3,0x4
    8000601a:	397d                	addiw	s2,s2,-1
    8000601c:	fe0915e3          	bnez	s2,80006006 <printf+0x13a>
    80006020:	b799                	j	80005f66 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006022:	f8843783          	ld	a5,-120(s0)
    80006026:	00878713          	addi	a4,a5,8
    8000602a:	f8e43423          	sd	a4,-120(s0)
    8000602e:	0007b903          	ld	s2,0(a5)
    80006032:	00090e63          	beqz	s2,8000604e <printf+0x182>
      for(; *s; s++)
    80006036:	00094503          	lbu	a0,0(s2)
    8000603a:	d515                	beqz	a0,80005f66 <printf+0x9a>
        consputc(*s);
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	b84080e7          	jalr	-1148(ra) # 80005bc0 <consputc>
      for(; *s; s++)
    80006044:	0905                	addi	s2,s2,1
    80006046:	00094503          	lbu	a0,0(s2)
    8000604a:	f96d                	bnez	a0,8000603c <printf+0x170>
    8000604c:	bf29                	j	80005f66 <printf+0x9a>
        s = "(null)";
    8000604e:	00003917          	auipc	s2,0x3
    80006052:	81a90913          	addi	s2,s2,-2022 # 80008868 <syscalls+0x450>
      for(; *s; s++)
    80006056:	02800513          	li	a0,40
    8000605a:	b7cd                	j	8000603c <printf+0x170>
      consputc('%');
    8000605c:	8556                	mv	a0,s5
    8000605e:	00000097          	auipc	ra,0x0
    80006062:	b62080e7          	jalr	-1182(ra) # 80005bc0 <consputc>
      break;
    80006066:	b701                	j	80005f66 <printf+0x9a>
      consputc('%');
    80006068:	8556                	mv	a0,s5
    8000606a:	00000097          	auipc	ra,0x0
    8000606e:	b56080e7          	jalr	-1194(ra) # 80005bc0 <consputc>
      consputc(c);
    80006072:	854a                	mv	a0,s2
    80006074:	00000097          	auipc	ra,0x0
    80006078:	b4c080e7          	jalr	-1204(ra) # 80005bc0 <consputc>
      break;
    8000607c:	b5ed                	j	80005f66 <printf+0x9a>
  if(locking)
    8000607e:	020d9163          	bnez	s11,800060a0 <printf+0x1d4>
}
    80006082:	70e6                	ld	ra,120(sp)
    80006084:	7446                	ld	s0,112(sp)
    80006086:	74a6                	ld	s1,104(sp)
    80006088:	7906                	ld	s2,96(sp)
    8000608a:	69e6                	ld	s3,88(sp)
    8000608c:	6a46                	ld	s4,80(sp)
    8000608e:	6aa6                	ld	s5,72(sp)
    80006090:	6b06                	ld	s6,64(sp)
    80006092:	7be2                	ld	s7,56(sp)
    80006094:	7c42                	ld	s8,48(sp)
    80006096:	7ca2                	ld	s9,40(sp)
    80006098:	7d02                	ld	s10,32(sp)
    8000609a:	6de2                	ld	s11,24(sp)
    8000609c:	6129                	addi	sp,sp,192
    8000609e:	8082                	ret
    release(&pr.lock);
    800060a0:	0001c517          	auipc	a0,0x1c
    800060a4:	ef850513          	addi	a0,a0,-264 # 80021f98 <pr>
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	3d8080e7          	jalr	984(ra) # 80006480 <release>
}
    800060b0:	bfc9                	j	80006082 <printf+0x1b6>

00000000800060b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060b2:	1101                	addi	sp,sp,-32
    800060b4:	ec06                	sd	ra,24(sp)
    800060b6:	e822                	sd	s0,16(sp)
    800060b8:	e426                	sd	s1,8(sp)
    800060ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060bc:	0001c497          	auipc	s1,0x1c
    800060c0:	edc48493          	addi	s1,s1,-292 # 80021f98 <pr>
    800060c4:	00002597          	auipc	a1,0x2
    800060c8:	7bc58593          	addi	a1,a1,1980 # 80008880 <syscalls+0x468>
    800060cc:	8526                	mv	a0,s1
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	26e080e7          	jalr	622(ra) # 8000633c <initlock>
  pr.locking = 1;
    800060d6:	4785                	li	a5,1
    800060d8:	cc9c                	sw	a5,24(s1)
}
    800060da:	60e2                	ld	ra,24(sp)
    800060dc:	6442                	ld	s0,16(sp)
    800060de:	64a2                	ld	s1,8(sp)
    800060e0:	6105                	addi	sp,sp,32
    800060e2:	8082                	ret

00000000800060e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060e4:	1141                	addi	sp,sp,-16
    800060e6:	e406                	sd	ra,8(sp)
    800060e8:	e022                	sd	s0,0(sp)
    800060ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060ec:	100007b7          	lui	a5,0x10000
    800060f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060f4:	f8000713          	li	a4,-128
    800060f8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060fc:	470d                	li	a4,3
    800060fe:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006102:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006106:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000610a:	469d                	li	a3,7
    8000610c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006110:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006114:	00002597          	auipc	a1,0x2
    80006118:	78c58593          	addi	a1,a1,1932 # 800088a0 <digits+0x18>
    8000611c:	0001c517          	auipc	a0,0x1c
    80006120:	e9c50513          	addi	a0,a0,-356 # 80021fb8 <uart_tx_lock>
    80006124:	00000097          	auipc	ra,0x0
    80006128:	218080e7          	jalr	536(ra) # 8000633c <initlock>
}
    8000612c:	60a2                	ld	ra,8(sp)
    8000612e:	6402                	ld	s0,0(sp)
    80006130:	0141                	addi	sp,sp,16
    80006132:	8082                	ret

0000000080006134 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006134:	1101                	addi	sp,sp,-32
    80006136:	ec06                	sd	ra,24(sp)
    80006138:	e822                	sd	s0,16(sp)
    8000613a:	e426                	sd	s1,8(sp)
    8000613c:	1000                	addi	s0,sp,32
    8000613e:	84aa                	mv	s1,a0
  push_off();
    80006140:	00000097          	auipc	ra,0x0
    80006144:	240080e7          	jalr	576(ra) # 80006380 <push_off>

  if(panicked){
    80006148:	00003797          	auipc	a5,0x3
    8000614c:	8247a783          	lw	a5,-2012(a5) # 8000896c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006150:	10000737          	lui	a4,0x10000
  if(panicked){
    80006154:	c391                	beqz	a5,80006158 <uartputc_sync+0x24>
    for(;;)
    80006156:	a001                	j	80006156 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006158:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000615c:	0ff7f793          	andi	a5,a5,255
    80006160:	0207f793          	andi	a5,a5,32
    80006164:	dbf5                	beqz	a5,80006158 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006166:	0ff4f793          	andi	a5,s1,255
    8000616a:	10000737          	lui	a4,0x10000
    8000616e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006172:	00000097          	auipc	ra,0x0
    80006176:	2ae080e7          	jalr	686(ra) # 80006420 <pop_off>
}
    8000617a:	60e2                	ld	ra,24(sp)
    8000617c:	6442                	ld	s0,16(sp)
    8000617e:	64a2                	ld	s1,8(sp)
    80006180:	6105                	addi	sp,sp,32
    80006182:	8082                	ret

0000000080006184 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006184:	00002717          	auipc	a4,0x2
    80006188:	7ec73703          	ld	a4,2028(a4) # 80008970 <uart_tx_r>
    8000618c:	00002797          	auipc	a5,0x2
    80006190:	7ec7b783          	ld	a5,2028(a5) # 80008978 <uart_tx_w>
    80006194:	06e78c63          	beq	a5,a4,8000620c <uartstart+0x88>
{
    80006198:	7139                	addi	sp,sp,-64
    8000619a:	fc06                	sd	ra,56(sp)
    8000619c:	f822                	sd	s0,48(sp)
    8000619e:	f426                	sd	s1,40(sp)
    800061a0:	f04a                	sd	s2,32(sp)
    800061a2:	ec4e                	sd	s3,24(sp)
    800061a4:	e852                	sd	s4,16(sp)
    800061a6:	e456                	sd	s5,8(sp)
    800061a8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061aa:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061ae:	0001ca17          	auipc	s4,0x1c
    800061b2:	e0aa0a13          	addi	s4,s4,-502 # 80021fb8 <uart_tx_lock>
    uart_tx_r += 1;
    800061b6:	00002497          	auipc	s1,0x2
    800061ba:	7ba48493          	addi	s1,s1,1978 # 80008970 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061be:	00002997          	auipc	s3,0x2
    800061c2:	7ba98993          	addi	s3,s3,1978 # 80008978 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061c6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061ca:	0ff7f793          	andi	a5,a5,255
    800061ce:	0207f793          	andi	a5,a5,32
    800061d2:	c785                	beqz	a5,800061fa <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061d4:	01f77793          	andi	a5,a4,31
    800061d8:	97d2                	add	a5,a5,s4
    800061da:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800061de:	0705                	addi	a4,a4,1
    800061e0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061e2:	8526                	mv	a0,s1
    800061e4:	ffffb097          	auipc	ra,0xffffb
    800061e8:	530080e7          	jalr	1328(ra) # 80001714 <wakeup>
    
    WriteReg(THR, c);
    800061ec:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061f0:	6098                	ld	a4,0(s1)
    800061f2:	0009b783          	ld	a5,0(s3)
    800061f6:	fce798e3          	bne	a5,a4,800061c6 <uartstart+0x42>
  }
}
    800061fa:	70e2                	ld	ra,56(sp)
    800061fc:	7442                	ld	s0,48(sp)
    800061fe:	74a2                	ld	s1,40(sp)
    80006200:	7902                	ld	s2,32(sp)
    80006202:	69e2                	ld	s3,24(sp)
    80006204:	6a42                	ld	s4,16(sp)
    80006206:	6aa2                	ld	s5,8(sp)
    80006208:	6121                	addi	sp,sp,64
    8000620a:	8082                	ret
    8000620c:	8082                	ret

000000008000620e <uartputc>:
{
    8000620e:	7179                	addi	sp,sp,-48
    80006210:	f406                	sd	ra,40(sp)
    80006212:	f022                	sd	s0,32(sp)
    80006214:	ec26                	sd	s1,24(sp)
    80006216:	e84a                	sd	s2,16(sp)
    80006218:	e44e                	sd	s3,8(sp)
    8000621a:	e052                	sd	s4,0(sp)
    8000621c:	1800                	addi	s0,sp,48
    8000621e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006220:	0001c517          	auipc	a0,0x1c
    80006224:	d9850513          	addi	a0,a0,-616 # 80021fb8 <uart_tx_lock>
    80006228:	00000097          	auipc	ra,0x0
    8000622c:	1a4080e7          	jalr	420(ra) # 800063cc <acquire>
  if(panicked){
    80006230:	00002797          	auipc	a5,0x2
    80006234:	73c7a783          	lw	a5,1852(a5) # 8000896c <panicked>
    80006238:	e7c9                	bnez	a5,800062c2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000623a:	00002797          	auipc	a5,0x2
    8000623e:	73e7b783          	ld	a5,1854(a5) # 80008978 <uart_tx_w>
    80006242:	00002717          	auipc	a4,0x2
    80006246:	72e73703          	ld	a4,1838(a4) # 80008970 <uart_tx_r>
    8000624a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000624e:	0001ca17          	auipc	s4,0x1c
    80006252:	d6aa0a13          	addi	s4,s4,-662 # 80021fb8 <uart_tx_lock>
    80006256:	00002497          	auipc	s1,0x2
    8000625a:	71a48493          	addi	s1,s1,1818 # 80008970 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000625e:	00002917          	auipc	s2,0x2
    80006262:	71a90913          	addi	s2,s2,1818 # 80008978 <uart_tx_w>
    80006266:	00f71f63          	bne	a4,a5,80006284 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000626a:	85d2                	mv	a1,s4
    8000626c:	8526                	mv	a0,s1
    8000626e:	ffffb097          	auipc	ra,0xffffb
    80006272:	442080e7          	jalr	1090(ra) # 800016b0 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006276:	00093783          	ld	a5,0(s2)
    8000627a:	6098                	ld	a4,0(s1)
    8000627c:	02070713          	addi	a4,a4,32
    80006280:	fef705e3          	beq	a4,a5,8000626a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006284:	0001c497          	auipc	s1,0x1c
    80006288:	d3448493          	addi	s1,s1,-716 # 80021fb8 <uart_tx_lock>
    8000628c:	01f7f713          	andi	a4,a5,31
    80006290:	9726                	add	a4,a4,s1
    80006292:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006296:	0785                	addi	a5,a5,1
    80006298:	00002717          	auipc	a4,0x2
    8000629c:	6ef73023          	sd	a5,1760(a4) # 80008978 <uart_tx_w>
  uartstart();
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	ee4080e7          	jalr	-284(ra) # 80006184 <uartstart>
  release(&uart_tx_lock);
    800062a8:	8526                	mv	a0,s1
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	1d6080e7          	jalr	470(ra) # 80006480 <release>
}
    800062b2:	70a2                	ld	ra,40(sp)
    800062b4:	7402                	ld	s0,32(sp)
    800062b6:	64e2                	ld	s1,24(sp)
    800062b8:	6942                	ld	s2,16(sp)
    800062ba:	69a2                	ld	s3,8(sp)
    800062bc:	6a02                	ld	s4,0(sp)
    800062be:	6145                	addi	sp,sp,48
    800062c0:	8082                	ret
    for(;;)
    800062c2:	a001                	j	800062c2 <uartputc+0xb4>

00000000800062c4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062c4:	1141                	addi	sp,sp,-16
    800062c6:	e422                	sd	s0,8(sp)
    800062c8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062ca:	100007b7          	lui	a5,0x10000
    800062ce:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062d2:	8b85                	andi	a5,a5,1
    800062d4:	cb91                	beqz	a5,800062e8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800062d6:	100007b7          	lui	a5,0x10000
    800062da:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062de:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062e2:	6422                	ld	s0,8(sp)
    800062e4:	0141                	addi	sp,sp,16
    800062e6:	8082                	ret
    return -1;
    800062e8:	557d                	li	a0,-1
    800062ea:	bfe5                	j	800062e2 <uartgetc+0x1e>

00000000800062ec <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062ec:	1101                	addi	sp,sp,-32
    800062ee:	ec06                	sd	ra,24(sp)
    800062f0:	e822                	sd	s0,16(sp)
    800062f2:	e426                	sd	s1,8(sp)
    800062f4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062f6:	54fd                	li	s1,-1
    int c = uartgetc();
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	fcc080e7          	jalr	-52(ra) # 800062c4 <uartgetc>
    if(c == -1)
    80006300:	00950763          	beq	a0,s1,8000630e <uartintr+0x22>
      break;
    consoleintr(c);
    80006304:	00000097          	auipc	ra,0x0
    80006308:	8fe080e7          	jalr	-1794(ra) # 80005c02 <consoleintr>
  while(1){
    8000630c:	b7f5                	j	800062f8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000630e:	0001c497          	auipc	s1,0x1c
    80006312:	caa48493          	addi	s1,s1,-854 # 80021fb8 <uart_tx_lock>
    80006316:	8526                	mv	a0,s1
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	0b4080e7          	jalr	180(ra) # 800063cc <acquire>
  uartstart();
    80006320:	00000097          	auipc	ra,0x0
    80006324:	e64080e7          	jalr	-412(ra) # 80006184 <uartstart>
  release(&uart_tx_lock);
    80006328:	8526                	mv	a0,s1
    8000632a:	00000097          	auipc	ra,0x0
    8000632e:	156080e7          	jalr	342(ra) # 80006480 <release>
}
    80006332:	60e2                	ld	ra,24(sp)
    80006334:	6442                	ld	s0,16(sp)
    80006336:	64a2                	ld	s1,8(sp)
    80006338:	6105                	addi	sp,sp,32
    8000633a:	8082                	ret

000000008000633c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000633c:	1141                	addi	sp,sp,-16
    8000633e:	e422                	sd	s0,8(sp)
    80006340:	0800                	addi	s0,sp,16
  lk->name = name;
    80006342:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006344:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006348:	00053823          	sd	zero,16(a0)
}
    8000634c:	6422                	ld	s0,8(sp)
    8000634e:	0141                	addi	sp,sp,16
    80006350:	8082                	ret

0000000080006352 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006352:	411c                	lw	a5,0(a0)
    80006354:	e399                	bnez	a5,8000635a <holding+0x8>
    80006356:	4501                	li	a0,0
  return r;
}
    80006358:	8082                	ret
{
    8000635a:	1101                	addi	sp,sp,-32
    8000635c:	ec06                	sd	ra,24(sp)
    8000635e:	e822                	sd	s0,16(sp)
    80006360:	e426                	sd	s1,8(sp)
    80006362:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006364:	6904                	ld	s1,16(a0)
    80006366:	ffffb097          	auipc	ra,0xffffb
    8000636a:	bf0080e7          	jalr	-1040(ra) # 80000f56 <mycpu>
    8000636e:	40a48533          	sub	a0,s1,a0
    80006372:	00153513          	seqz	a0,a0
}
    80006376:	60e2                	ld	ra,24(sp)
    80006378:	6442                	ld	s0,16(sp)
    8000637a:	64a2                	ld	s1,8(sp)
    8000637c:	6105                	addi	sp,sp,32
    8000637e:	8082                	ret

0000000080006380 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006380:	1101                	addi	sp,sp,-32
    80006382:	ec06                	sd	ra,24(sp)
    80006384:	e822                	sd	s0,16(sp)
    80006386:	e426                	sd	s1,8(sp)
    80006388:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000638a:	100024f3          	csrr	s1,sstatus
    8000638e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006392:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006394:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006398:	ffffb097          	auipc	ra,0xffffb
    8000639c:	bbe080e7          	jalr	-1090(ra) # 80000f56 <mycpu>
    800063a0:	5d3c                	lw	a5,120(a0)
    800063a2:	cf89                	beqz	a5,800063bc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063a4:	ffffb097          	auipc	ra,0xffffb
    800063a8:	bb2080e7          	jalr	-1102(ra) # 80000f56 <mycpu>
    800063ac:	5d3c                	lw	a5,120(a0)
    800063ae:	2785                	addiw	a5,a5,1
    800063b0:	dd3c                	sw	a5,120(a0)
}
    800063b2:	60e2                	ld	ra,24(sp)
    800063b4:	6442                	ld	s0,16(sp)
    800063b6:	64a2                	ld	s1,8(sp)
    800063b8:	6105                	addi	sp,sp,32
    800063ba:	8082                	ret
    mycpu()->intena = old;
    800063bc:	ffffb097          	auipc	ra,0xffffb
    800063c0:	b9a080e7          	jalr	-1126(ra) # 80000f56 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063c4:	8085                	srli	s1,s1,0x1
    800063c6:	8885                	andi	s1,s1,1
    800063c8:	dd64                	sw	s1,124(a0)
    800063ca:	bfe9                	j	800063a4 <push_off+0x24>

00000000800063cc <acquire>:
{
    800063cc:	1101                	addi	sp,sp,-32
    800063ce:	ec06                	sd	ra,24(sp)
    800063d0:	e822                	sd	s0,16(sp)
    800063d2:	e426                	sd	s1,8(sp)
    800063d4:	1000                	addi	s0,sp,32
    800063d6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063d8:	00000097          	auipc	ra,0x0
    800063dc:	fa8080e7          	jalr	-88(ra) # 80006380 <push_off>
  if(holding(lk))
    800063e0:	8526                	mv	a0,s1
    800063e2:	00000097          	auipc	ra,0x0
    800063e6:	f70080e7          	jalr	-144(ra) # 80006352 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063ea:	4705                	li	a4,1
  if(holding(lk))
    800063ec:	e115                	bnez	a0,80006410 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063ee:	87ba                	mv	a5,a4
    800063f0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063f4:	2781                	sext.w	a5,a5
    800063f6:	ffe5                	bnez	a5,800063ee <acquire+0x22>
  __sync_synchronize();
    800063f8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063fc:	ffffb097          	auipc	ra,0xffffb
    80006400:	b5a080e7          	jalr	-1190(ra) # 80000f56 <mycpu>
    80006404:	e888                	sd	a0,16(s1)
}
    80006406:	60e2                	ld	ra,24(sp)
    80006408:	6442                	ld	s0,16(sp)
    8000640a:	64a2                	ld	s1,8(sp)
    8000640c:	6105                	addi	sp,sp,32
    8000640e:	8082                	ret
    panic("acquire");
    80006410:	00002517          	auipc	a0,0x2
    80006414:	49850513          	addi	a0,a0,1176 # 800088a8 <digits+0x20>
    80006418:	00000097          	auipc	ra,0x0
    8000641c:	a6a080e7          	jalr	-1430(ra) # 80005e82 <panic>

0000000080006420 <pop_off>:

void
pop_off(void)
{
    80006420:	1141                	addi	sp,sp,-16
    80006422:	e406                	sd	ra,8(sp)
    80006424:	e022                	sd	s0,0(sp)
    80006426:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006428:	ffffb097          	auipc	ra,0xffffb
    8000642c:	b2e080e7          	jalr	-1234(ra) # 80000f56 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006430:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006434:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006436:	e78d                	bnez	a5,80006460 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006438:	5d3c                	lw	a5,120(a0)
    8000643a:	02f05b63          	blez	a5,80006470 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000643e:	37fd                	addiw	a5,a5,-1
    80006440:	0007871b          	sext.w	a4,a5
    80006444:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006446:	eb09                	bnez	a4,80006458 <pop_off+0x38>
    80006448:	5d7c                	lw	a5,124(a0)
    8000644a:	c799                	beqz	a5,80006458 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000644c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006450:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006454:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006458:	60a2                	ld	ra,8(sp)
    8000645a:	6402                	ld	s0,0(sp)
    8000645c:	0141                	addi	sp,sp,16
    8000645e:	8082                	ret
    panic("pop_off - interruptible");
    80006460:	00002517          	auipc	a0,0x2
    80006464:	45050513          	addi	a0,a0,1104 # 800088b0 <digits+0x28>
    80006468:	00000097          	auipc	ra,0x0
    8000646c:	a1a080e7          	jalr	-1510(ra) # 80005e82 <panic>
    panic("pop_off");
    80006470:	00002517          	auipc	a0,0x2
    80006474:	45850513          	addi	a0,a0,1112 # 800088c8 <digits+0x40>
    80006478:	00000097          	auipc	ra,0x0
    8000647c:	a0a080e7          	jalr	-1526(ra) # 80005e82 <panic>

0000000080006480 <release>:
{
    80006480:	1101                	addi	sp,sp,-32
    80006482:	ec06                	sd	ra,24(sp)
    80006484:	e822                	sd	s0,16(sp)
    80006486:	e426                	sd	s1,8(sp)
    80006488:	1000                	addi	s0,sp,32
    8000648a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000648c:	00000097          	auipc	ra,0x0
    80006490:	ec6080e7          	jalr	-314(ra) # 80006352 <holding>
    80006494:	c115                	beqz	a0,800064b8 <release+0x38>
  lk->cpu = 0;
    80006496:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000649a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000649e:	0f50000f          	fence	iorw,ow
    800064a2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064a6:	00000097          	auipc	ra,0x0
    800064aa:	f7a080e7          	jalr	-134(ra) # 80006420 <pop_off>
}
    800064ae:	60e2                	ld	ra,24(sp)
    800064b0:	6442                	ld	s0,16(sp)
    800064b2:	64a2                	ld	s1,8(sp)
    800064b4:	6105                	addi	sp,sp,32
    800064b6:	8082                	ret
    panic("release");
    800064b8:	00002517          	auipc	a0,0x2
    800064bc:	41850513          	addi	a0,a0,1048 # 800088d0 <digits+0x48>
    800064c0:	00000097          	auipc	ra,0x0
    800064c4:	9c2080e7          	jalr	-1598(ra) # 80005e82 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
