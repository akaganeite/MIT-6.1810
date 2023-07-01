
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8e013103          	ld	sp,-1824(sp) # 800088e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	716050ef          	jal	ra,8000572c <start>

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
    80000034:	d7078793          	addi	a5,a5,-656 # 80021da0 <end>
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
    80000054:	8e090913          	addi	s2,s2,-1824 # 80008930 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	0d2080e7          	jalr	210(ra) # 8000612c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	172080e7          	jalr	370(ra) # 800061e0 <release>
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
    8000008e:	b58080e7          	jalr	-1192(ra) # 80005be2 <panic>

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
    800000f0:	84450513          	addi	a0,a0,-1980 # 80008930 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	fa8080e7          	jalr	-88(ra) # 8000609c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	ca050513          	addi	a0,a0,-864 # 80021da0 <end>
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
    80000126:	80e48493          	addi	s1,s1,-2034 # 80008930 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	000080e7          	jalr	ra # 8000612c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	7f650513          	addi	a0,a0,2038 # 80008930 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	09c080e7          	jalr	156(ra) # 800061e0 <release>

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
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	7ca50513          	addi	a0,a0,1994 # 80008930 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	072080e7          	jalr	114(ra) # 800061e0 <release>
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
    80000332:	afa080e7          	jalr	-1286(ra) # 80000e28 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	5ca70713          	addi	a4,a4,1482 # 80008900 <started>
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
    8000034e:	ade080e7          	jalr	-1314(ra) # 80000e28 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	8d0080e7          	jalr	-1840(ra) # 80005c2c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	780080e7          	jalr	1920(ra) # 80001aec <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	d0c080e7          	jalr	-756(ra) # 80005080 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fca080e7          	jalr	-54(ra) # 80001346 <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	770080e7          	jalr	1904(ra) # 80005af4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	a86080e7          	jalr	-1402(ra) # 80005e12 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	890080e7          	jalr	-1904(ra) # 80005c2c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	880080e7          	jalr	-1920(ra) # 80005c2c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	870080e7          	jalr	-1936(ra) # 80005c2c <printf>
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
    800003e0:	99a080e7          	jalr	-1638(ra) # 80000d76 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6e0080e7          	jalr	1760(ra) # 80001ac4 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	700080e7          	jalr	1792(ra) # 80001aec <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	c76080e7          	jalr	-906(ra) # 8000506a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	c84080e7          	jalr	-892(ra) # 80005080 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	e32080e7          	jalr	-462(ra) # 80002236 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	4d6080e7          	jalr	1238(ra) # 800028e2 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	474080e7          	jalr	1140(ra) # 80003888 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	d6c080e7          	jalr	-660(ra) # 80005188 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d08080e7          	jalr	-760(ra) # 8000112c <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	4cf72723          	sw	a5,1230(a4) # 80008900 <started>
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
    8000044a:	4c27b783          	ld	a5,1218(a5) # 80008908 <kernel_pagetable>
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
    80000492:	00005097          	auipc	ra,0x5
    80000496:	750080e7          	jalr	1872(ra) # 80005be2 <panic>
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
    8000058a:	00005097          	auipc	ra,0x5
    8000058e:	658080e7          	jalr	1624(ra) # 80005be2 <panic>
      panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00005097          	auipc	ra,0x5
    8000059e:	648080e7          	jalr	1608(ra) # 80005be2 <panic>
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
    80000614:	00005097          	auipc	ra,0x5
    80000618:	5ce080e7          	jalr	1486(ra) # 80005be2 <panic>

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
    800006e0:	606080e7          	jalr	1542(ra) # 80000ce2 <proc_mapstacks>
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
    80000706:	20a7b323          	sd	a0,518(a5) # 80008908 <kernel_pagetable>
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
    80000764:	482080e7          	jalr	1154(ra) # 80005be2 <panic>
      panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	472080e7          	jalr	1138(ra) # 80005be2 <panic>
      panic("uvmunmap: not mapped");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	462080e7          	jalr	1122(ra) # 80005be2 <panic>
      panic("uvmunmap: not a leaf");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	93850513          	addi	a0,a0,-1736 # 800080c0 <etext+0xc0>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	452080e7          	jalr	1106(ra) # 80005be2 <panic>
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
    80000872:	374080e7          	jalr	884(ra) # 80005be2 <panic>

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
    800009bc:	22a080e7          	jalr	554(ra) # 80005be2 <panic>
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
    80000a98:	14e080e7          	jalr	334(ra) # 80005be2 <panic>
      panic("uvmcopy: page not present");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	68c50513          	addi	a0,a0,1676 # 80008128 <etext+0x128>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	13e080e7          	jalr	318(ra) # 80005be2 <panic>
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
    80000b12:	0d4080e7          	jalr	212(ra) # 80005be2 <panic>

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
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3a:	6a85                	lui	s5,0x1
    80000b3c:	a015                	j	80000b60 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3e:	9562                	add	a0,a0,s8
    80000b40:	0004861b          	sext.w	a2,s1
    80000b44:	85d2                	mv	a1,s4
    80000b46:	41250533          	sub	a0,a0,s2
    80000b4a:	fffff097          	auipc	ra,0xfffff
    80000b4e:	68e080e7          	jalr	1678(ra) # 800001d8 <memmove>

    len -= n;
    80000b52:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b56:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b58:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5c:	02098263          	beqz	s3,80000b80 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b60:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
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

0000000080000ce2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000ce2:	7139                	addi	sp,sp,-64
    80000ce4:	fc06                	sd	ra,56(sp)
    80000ce6:	f822                	sd	s0,48(sp)
    80000ce8:	f426                	sd	s1,40(sp)
    80000cea:	f04a                	sd	s2,32(sp)
    80000cec:	ec4e                	sd	s3,24(sp)
    80000cee:	e852                	sd	s4,16(sp)
    80000cf0:	e456                	sd	s5,8(sp)
    80000cf2:	e05a                	sd	s6,0(sp)
    80000cf4:	0080                	addi	s0,sp,64
    80000cf6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf8:	00008497          	auipc	s1,0x8
    80000cfc:	08848493          	addi	s1,s1,136 # 80008d80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d00:	8b26                	mv	s6,s1
    80000d02:	00007a97          	auipc	s5,0x7
    80000d06:	2fea8a93          	addi	s5,s5,766 # 80008000 <etext>
    80000d0a:	01000937          	lui	s2,0x1000
    80000d0e:	197d                	addi	s2,s2,-1
    80000d10:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	0000ea17          	auipc	s4,0xe
    80000d16:	a6ea0a13          	addi	s4,s4,-1426 # 8000e780 <tickslock>
    char *pa = kalloc();
    80000d1a:	fffff097          	auipc	ra,0xfffff
    80000d1e:	3fe080e7          	jalr	1022(ra) # 80000118 <kalloc>
    80000d22:	862a                	mv	a2,a0
    if(pa == 0)
    80000d24:	c129                	beqz	a0,80000d66 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000d26:	416485b3          	sub	a1,s1,s6
    80000d2a:	858d                	srai	a1,a1,0x3
    80000d2c:	000ab783          	ld	a5,0(s5)
    80000d30:	02f585b3          	mul	a1,a1,a5
    80000d34:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d38:	4719                	li	a4,6
    80000d3a:	6685                	lui	a3,0x1
    80000d3c:	40b905b3          	sub	a1,s2,a1
    80000d40:	854e                	mv	a0,s3
    80000d42:	00000097          	auipc	ra,0x0
    80000d46:	8aa080e7          	jalr	-1878(ra) # 800005ec <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4a:	16848493          	addi	s1,s1,360
    80000d4e:	fd4496e3          	bne	s1,s4,80000d1a <proc_mapstacks+0x38>
  }
}
    80000d52:	70e2                	ld	ra,56(sp)
    80000d54:	7442                	ld	s0,48(sp)
    80000d56:	74a2                	ld	s1,40(sp)
    80000d58:	7902                	ld	s2,32(sp)
    80000d5a:	69e2                	ld	s3,24(sp)
    80000d5c:	6a42                	ld	s4,16(sp)
    80000d5e:	6aa2                	ld	s5,8(sp)
    80000d60:	6b02                	ld	s6,0(sp)
    80000d62:	6121                	addi	sp,sp,64
    80000d64:	8082                	ret
      panic("kalloc");
    80000d66:	00007517          	auipc	a0,0x7
    80000d6a:	3f250513          	addi	a0,a0,1010 # 80008158 <etext+0x158>
    80000d6e:	00005097          	auipc	ra,0x5
    80000d72:	e74080e7          	jalr	-396(ra) # 80005be2 <panic>

0000000080000d76 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d76:	7139                	addi	sp,sp,-64
    80000d78:	fc06                	sd	ra,56(sp)
    80000d7a:	f822                	sd	s0,48(sp)
    80000d7c:	f426                	sd	s1,40(sp)
    80000d7e:	f04a                	sd	s2,32(sp)
    80000d80:	ec4e                	sd	s3,24(sp)
    80000d82:	e852                	sd	s4,16(sp)
    80000d84:	e456                	sd	s5,8(sp)
    80000d86:	e05a                	sd	s6,0(sp)
    80000d88:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d8a:	00007597          	auipc	a1,0x7
    80000d8e:	3d658593          	addi	a1,a1,982 # 80008160 <etext+0x160>
    80000d92:	00008517          	auipc	a0,0x8
    80000d96:	bbe50513          	addi	a0,a0,-1090 # 80008950 <pid_lock>
    80000d9a:	00005097          	auipc	ra,0x5
    80000d9e:	302080e7          	jalr	770(ra) # 8000609c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da2:	00007597          	auipc	a1,0x7
    80000da6:	3c658593          	addi	a1,a1,966 # 80008168 <etext+0x168>
    80000daa:	00008517          	auipc	a0,0x8
    80000dae:	bbe50513          	addi	a0,a0,-1090 # 80008968 <wait_lock>
    80000db2:	00005097          	auipc	ra,0x5
    80000db6:	2ea080e7          	jalr	746(ra) # 8000609c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dba:	00008497          	auipc	s1,0x8
    80000dbe:	fc648493          	addi	s1,s1,-58 # 80008d80 <proc>
      initlock(&p->lock, "proc");
    80000dc2:	00007b17          	auipc	s6,0x7
    80000dc6:	3b6b0b13          	addi	s6,s6,950 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dca:	8aa6                	mv	s5,s1
    80000dcc:	00007a17          	auipc	s4,0x7
    80000dd0:	234a0a13          	addi	s4,s4,564 # 80008000 <etext>
    80000dd4:	01000937          	lui	s2,0x1000
    80000dd8:	197d                	addi	s2,s2,-1
    80000dda:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ddc:	0000e997          	auipc	s3,0xe
    80000de0:	9a498993          	addi	s3,s3,-1628 # 8000e780 <tickslock>
      initlock(&p->lock, "proc");
    80000de4:	85da                	mv	a1,s6
    80000de6:	8526                	mv	a0,s1
    80000de8:	00005097          	auipc	ra,0x5
    80000dec:	2b4080e7          	jalr	692(ra) # 8000609c <initlock>
      p->state = UNUSED;
    80000df0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df4:	415487b3          	sub	a5,s1,s5
    80000df8:	878d                	srai	a5,a5,0x3
    80000dfa:	000a3703          	ld	a4,0(s4)
    80000dfe:	02e787b3          	mul	a5,a5,a4
    80000e02:	00d7979b          	slliw	a5,a5,0xd
    80000e06:	40f907b3          	sub	a5,s2,a5
    80000e0a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0c:	16848493          	addi	s1,s1,360
    80000e10:	fd349ae3          	bne	s1,s3,80000de4 <procinit+0x6e>
  }
}
    80000e14:	70e2                	ld	ra,56(sp)
    80000e16:	7442                	ld	s0,48(sp)
    80000e18:	74a2                	ld	s1,40(sp)
    80000e1a:	7902                	ld	s2,32(sp)
    80000e1c:	69e2                	ld	s3,24(sp)
    80000e1e:	6a42                	ld	s4,16(sp)
    80000e20:	6aa2                	ld	s5,8(sp)
    80000e22:	6b02                	ld	s6,0(sp)
    80000e24:	6121                	addi	sp,sp,64
    80000e26:	8082                	ret

0000000080000e28 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e30:	2501                	sext.w	a0,a0
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
    80000e3e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e40:	2781                	sext.w	a5,a5
    80000e42:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e44:	00008517          	auipc	a0,0x8
    80000e48:	b3c50513          	addi	a0,a0,-1220 # 80008980 <cpus>
    80000e4c:	953e                	add	a0,a0,a5
    80000e4e:	6422                	ld	s0,8(sp)
    80000e50:	0141                	addi	sp,sp,16
    80000e52:	8082                	ret

0000000080000e54 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e54:	1101                	addi	sp,sp,-32
    80000e56:	ec06                	sd	ra,24(sp)
    80000e58:	e822                	sd	s0,16(sp)
    80000e5a:	e426                	sd	s1,8(sp)
    80000e5c:	1000                	addi	s0,sp,32
  push_off();
    80000e5e:	00005097          	auipc	ra,0x5
    80000e62:	282080e7          	jalr	642(ra) # 800060e0 <push_off>
    80000e66:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
    80000e6c:	00008717          	auipc	a4,0x8
    80000e70:	ae470713          	addi	a4,a4,-1308 # 80008950 <pid_lock>
    80000e74:	97ba                	add	a5,a5,a4
    80000e76:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e78:	00005097          	auipc	ra,0x5
    80000e7c:	308080e7          	jalr	776(ra) # 80006180 <pop_off>
  return p;
}
    80000e80:	8526                	mv	a0,s1
    80000e82:	60e2                	ld	ra,24(sp)
    80000e84:	6442                	ld	s0,16(sp)
    80000e86:	64a2                	ld	s1,8(sp)
    80000e88:	6105                	addi	sp,sp,32
    80000e8a:	8082                	ret

0000000080000e8c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e8c:	1141                	addi	sp,sp,-16
    80000e8e:	e406                	sd	ra,8(sp)
    80000e90:	e022                	sd	s0,0(sp)
    80000e92:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e94:	00000097          	auipc	ra,0x0
    80000e98:	fc0080e7          	jalr	-64(ra) # 80000e54 <myproc>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	344080e7          	jalr	836(ra) # 800061e0 <release>

  if (first) {
    80000ea4:	00008797          	auipc	a5,0x8
    80000ea8:	9ec7a783          	lw	a5,-1556(a5) # 80008890 <first.1680>
    80000eac:	eb89                	bnez	a5,80000ebe <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eae:	00001097          	auipc	ra,0x1
    80000eb2:	c56080e7          	jalr	-938(ra) # 80001b04 <usertrapret>
}
    80000eb6:	60a2                	ld	ra,8(sp)
    80000eb8:	6402                	ld	s0,0(sp)
    80000eba:	0141                	addi	sp,sp,16
    80000ebc:	8082                	ret
    first = 0;
    80000ebe:	00008797          	auipc	a5,0x8
    80000ec2:	9c07a923          	sw	zero,-1582(a5) # 80008890 <first.1680>
    fsinit(ROOTDEV);
    80000ec6:	4505                	li	a0,1
    80000ec8:	00002097          	auipc	ra,0x2
    80000ecc:	99a080e7          	jalr	-1638(ra) # 80002862 <fsinit>
    80000ed0:	bff9                	j	80000eae <forkret+0x22>

0000000080000ed2 <allocpid>:
{
    80000ed2:	1101                	addi	sp,sp,-32
    80000ed4:	ec06                	sd	ra,24(sp)
    80000ed6:	e822                	sd	s0,16(sp)
    80000ed8:	e426                	sd	s1,8(sp)
    80000eda:	e04a                	sd	s2,0(sp)
    80000edc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ede:	00008917          	auipc	s2,0x8
    80000ee2:	a7290913          	addi	s2,s2,-1422 # 80008950 <pid_lock>
    80000ee6:	854a                	mv	a0,s2
    80000ee8:	00005097          	auipc	ra,0x5
    80000eec:	244080e7          	jalr	580(ra) # 8000612c <acquire>
  pid = nextpid;
    80000ef0:	00008797          	auipc	a5,0x8
    80000ef4:	9a478793          	addi	a5,a5,-1628 # 80008894 <nextpid>
    80000ef8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000efa:	0014871b          	addiw	a4,s1,1
    80000efe:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f00:	854a                	mv	a0,s2
    80000f02:	00005097          	auipc	ra,0x5
    80000f06:	2de080e7          	jalr	734(ra) # 800061e0 <release>
}
    80000f0a:	8526                	mv	a0,s1
    80000f0c:	60e2                	ld	ra,24(sp)
    80000f0e:	6442                	ld	s0,16(sp)
    80000f10:	64a2                	ld	s1,8(sp)
    80000f12:	6902                	ld	s2,0(sp)
    80000f14:	6105                	addi	sp,sp,32
    80000f16:	8082                	ret

0000000080000f18 <proc_pagetable>:
{
    80000f18:	1101                	addi	sp,sp,-32
    80000f1a:	ec06                	sd	ra,24(sp)
    80000f1c:	e822                	sd	s0,16(sp)
    80000f1e:	e426                	sd	s1,8(sp)
    80000f20:	e04a                	sd	s2,0(sp)
    80000f22:	1000                	addi	s0,sp,32
    80000f24:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	8b0080e7          	jalr	-1872(ra) # 800007d6 <uvmcreate>
    80000f2e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f30:	c121                	beqz	a0,80000f70 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f32:	4729                	li	a4,10
    80000f34:	00006697          	auipc	a3,0x6
    80000f38:	0cc68693          	addi	a3,a3,204 # 80007000 <_trampoline>
    80000f3c:	6605                	lui	a2,0x1
    80000f3e:	040005b7          	lui	a1,0x4000
    80000f42:	15fd                	addi	a1,a1,-1
    80000f44:	05b2                	slli	a1,a1,0xc
    80000f46:	fffff097          	auipc	ra,0xfffff
    80000f4a:	606080e7          	jalr	1542(ra) # 8000054c <mappages>
    80000f4e:	02054863          	bltz	a0,80000f7e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f52:	4719                	li	a4,6
    80000f54:	05893683          	ld	a3,88(s2)
    80000f58:	6605                	lui	a2,0x1
    80000f5a:	020005b7          	lui	a1,0x2000
    80000f5e:	15fd                	addi	a1,a1,-1
    80000f60:	05b6                	slli	a1,a1,0xd
    80000f62:	8526                	mv	a0,s1
    80000f64:	fffff097          	auipc	ra,0xfffff
    80000f68:	5e8080e7          	jalr	1512(ra) # 8000054c <mappages>
    80000f6c:	02054163          	bltz	a0,80000f8e <proc_pagetable+0x76>
}
    80000f70:	8526                	mv	a0,s1
    80000f72:	60e2                	ld	ra,24(sp)
    80000f74:	6442                	ld	s0,16(sp)
    80000f76:	64a2                	ld	s1,8(sp)
    80000f78:	6902                	ld	s2,0(sp)
    80000f7a:	6105                	addi	sp,sp,32
    80000f7c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7e:	4581                	li	a1,0
    80000f80:	8526                	mv	a0,s1
    80000f82:	00000097          	auipc	ra,0x0
    80000f86:	a58080e7          	jalr	-1448(ra) # 800009da <uvmfree>
    return 0;
    80000f8a:	4481                	li	s1,0
    80000f8c:	b7d5                	j	80000f70 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8e:	4681                	li	a3,0
    80000f90:	4605                	li	a2,1
    80000f92:	040005b7          	lui	a1,0x4000
    80000f96:	15fd                	addi	a1,a1,-1
    80000f98:	05b2                	slli	a1,a1,0xc
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	fffff097          	auipc	ra,0xfffff
    80000fa0:	776080e7          	jalr	1910(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa4:	4581                	li	a1,0
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	00000097          	auipc	ra,0x0
    80000fac:	a32080e7          	jalr	-1486(ra) # 800009da <uvmfree>
    return 0;
    80000fb0:	4481                	li	s1,0
    80000fb2:	bf7d                	j	80000f70 <proc_pagetable+0x58>

0000000080000fb4 <proc_freepagetable>:
{
    80000fb4:	1101                	addi	sp,sp,-32
    80000fb6:	ec06                	sd	ra,24(sp)
    80000fb8:	e822                	sd	s0,16(sp)
    80000fba:	e426                	sd	s1,8(sp)
    80000fbc:	e04a                	sd	s2,0(sp)
    80000fbe:	1000                	addi	s0,sp,32
    80000fc0:	84aa                	mv	s1,a0
    80000fc2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc4:	4681                	li	a3,0
    80000fc6:	4605                	li	a2,1
    80000fc8:	040005b7          	lui	a1,0x4000
    80000fcc:	15fd                	addi	a1,a1,-1
    80000fce:	05b2                	slli	a1,a1,0xc
    80000fd0:	fffff097          	auipc	ra,0xfffff
    80000fd4:	742080e7          	jalr	1858(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd8:	4681                	li	a3,0
    80000fda:	4605                	li	a2,1
    80000fdc:	020005b7          	lui	a1,0x2000
    80000fe0:	15fd                	addi	a1,a1,-1
    80000fe2:	05b6                	slli	a1,a1,0xd
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	fffff097          	auipc	ra,0xfffff
    80000fea:	72c080e7          	jalr	1836(ra) # 80000712 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fee:	85ca                	mv	a1,s2
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	00000097          	auipc	ra,0x0
    80000ff6:	9e8080e7          	jalr	-1560(ra) # 800009da <uvmfree>
}
    80000ffa:	60e2                	ld	ra,24(sp)
    80000ffc:	6442                	ld	s0,16(sp)
    80000ffe:	64a2                	ld	s1,8(sp)
    80001000:	6902                	ld	s2,0(sp)
    80001002:	6105                	addi	sp,sp,32
    80001004:	8082                	ret

0000000080001006 <freeproc>:
{
    80001006:	1101                	addi	sp,sp,-32
    80001008:	ec06                	sd	ra,24(sp)
    8000100a:	e822                	sd	s0,16(sp)
    8000100c:	e426                	sd	s1,8(sp)
    8000100e:	1000                	addi	s0,sp,32
    80001010:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001012:	6d28                	ld	a0,88(a0)
    80001014:	c509                	beqz	a0,8000101e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	006080e7          	jalr	6(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001022:	68a8                	ld	a0,80(s1)
    80001024:	c511                	beqz	a0,80001030 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001026:	64ac                	ld	a1,72(s1)
    80001028:	00000097          	auipc	ra,0x0
    8000102c:	f8c080e7          	jalr	-116(ra) # 80000fb4 <proc_freepagetable>
  p->pagetable = 0;
    80001030:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001034:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001038:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001040:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001044:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001048:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001050:	0004ac23          	sw	zero,24(s1)
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6105                	addi	sp,sp,32
    8000105c:	8082                	ret

000000008000105e <allocproc>:
{
    8000105e:	1101                	addi	sp,sp,-32
    80001060:	ec06                	sd	ra,24(sp)
    80001062:	e822                	sd	s0,16(sp)
    80001064:	e426                	sd	s1,8(sp)
    80001066:	e04a                	sd	s2,0(sp)
    80001068:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000106a:	00008497          	auipc	s1,0x8
    8000106e:	d1648493          	addi	s1,s1,-746 # 80008d80 <proc>
    80001072:	0000d917          	auipc	s2,0xd
    80001076:	70e90913          	addi	s2,s2,1806 # 8000e780 <tickslock>
    acquire(&p->lock);
    8000107a:	8526                	mv	a0,s1
    8000107c:	00005097          	auipc	ra,0x5
    80001080:	0b0080e7          	jalr	176(ra) # 8000612c <acquire>
    if(p->state == UNUSED) {
    80001084:	4c9c                	lw	a5,24(s1)
    80001086:	cf81                	beqz	a5,8000109e <allocproc+0x40>
      release(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	156080e7          	jalr	342(ra) # 800061e0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001092:	16848493          	addi	s1,s1,360
    80001096:	ff2492e3          	bne	s1,s2,8000107a <allocproc+0x1c>
  return 0;
    8000109a:	4481                	li	s1,0
    8000109c:	a889                	j	800010ee <allocproc+0x90>
  p->pid = allocpid();
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	e34080e7          	jalr	-460(ra) # 80000ed2 <allocpid>
    800010a6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a8:	4785                	li	a5,1
    800010aa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	06c080e7          	jalr	108(ra) # 80000118 <kalloc>
    800010b4:	892a                	mv	s2,a0
    800010b6:	eca8                	sd	a0,88(s1)
    800010b8:	c131                	beqz	a0,800010fc <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ba:	8526                	mv	a0,s1
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	e5c080e7          	jalr	-420(ra) # 80000f18 <proc_pagetable>
    800010c4:	892a                	mv	s2,a0
    800010c6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c8:	c531                	beqz	a0,80001114 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ca:	07000613          	li	a2,112
    800010ce:	4581                	li	a1,0
    800010d0:	06048513          	addi	a0,s1,96
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	0a4080e7          	jalr	164(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010dc:	00000797          	auipc	a5,0x0
    800010e0:	db078793          	addi	a5,a5,-592 # 80000e8c <forkret>
    800010e4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e6:	60bc                	ld	a5,64(s1)
    800010e8:	6705                	lui	a4,0x1
    800010ea:	97ba                	add	a5,a5,a4
    800010ec:	f4bc                	sd	a5,104(s1)
}
    800010ee:	8526                	mv	a0,s1
    800010f0:	60e2                	ld	ra,24(sp)
    800010f2:	6442                	ld	s0,16(sp)
    800010f4:	64a2                	ld	s1,8(sp)
    800010f6:	6902                	ld	s2,0(sp)
    800010f8:	6105                	addi	sp,sp,32
    800010fa:	8082                	ret
    freeproc(p);
    800010fc:	8526                	mv	a0,s1
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	f08080e7          	jalr	-248(ra) # 80001006 <freeproc>
    release(&p->lock);
    80001106:	8526                	mv	a0,s1
    80001108:	00005097          	auipc	ra,0x5
    8000110c:	0d8080e7          	jalr	216(ra) # 800061e0 <release>
    return 0;
    80001110:	84ca                	mv	s1,s2
    80001112:	bff1                	j	800010ee <allocproc+0x90>
    freeproc(p);
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	ef0080e7          	jalr	-272(ra) # 80001006 <freeproc>
    release(&p->lock);
    8000111e:	8526                	mv	a0,s1
    80001120:	00005097          	auipc	ra,0x5
    80001124:	0c0080e7          	jalr	192(ra) # 800061e0 <release>
    return 0;
    80001128:	84ca                	mv	s1,s2
    8000112a:	b7d1                	j	800010ee <allocproc+0x90>

000000008000112c <userinit>:
{
    8000112c:	1101                	addi	sp,sp,-32
    8000112e:	ec06                	sd	ra,24(sp)
    80001130:	e822                	sd	s0,16(sp)
    80001132:	e426                	sd	s1,8(sp)
    80001134:	1000                	addi	s0,sp,32
  p = allocproc();
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	f28080e7          	jalr	-216(ra) # 8000105e <allocproc>
    8000113e:	84aa                	mv	s1,a0
  initproc = p;
    80001140:	00007797          	auipc	a5,0x7
    80001144:	7ca7b823          	sd	a0,2000(a5) # 80008910 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001148:	03400613          	li	a2,52
    8000114c:	00007597          	auipc	a1,0x7
    80001150:	75458593          	addi	a1,a1,1876 # 800088a0 <initcode>
    80001154:	6928                	ld	a0,80(a0)
    80001156:	fffff097          	auipc	ra,0xfffff
    8000115a:	6ae080e7          	jalr	1710(ra) # 80000804 <uvmfirst>
  p->sz = PGSIZE;
    8000115e:	6785                	lui	a5,0x1
    80001160:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001162:	6cb8                	ld	a4,88(s1)
    80001164:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001168:	6cb8                	ld	a4,88(s1)
    8000116a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116c:	4641                	li	a2,16
    8000116e:	00007597          	auipc	a1,0x7
    80001172:	01258593          	addi	a1,a1,18 # 80008180 <etext+0x180>
    80001176:	15848513          	addi	a0,s1,344
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	150080e7          	jalr	336(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001182:	00007517          	auipc	a0,0x7
    80001186:	00e50513          	addi	a0,a0,14 # 80008190 <etext+0x190>
    8000118a:	00002097          	auipc	ra,0x2
    8000118e:	0fa080e7          	jalr	250(ra) # 80003284 <namei>
    80001192:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001196:	478d                	li	a5,3
    80001198:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119a:	8526                	mv	a0,s1
    8000119c:	00005097          	auipc	ra,0x5
    800011a0:	044080e7          	jalr	68(ra) # 800061e0 <release>
}
    800011a4:	60e2                	ld	ra,24(sp)
    800011a6:	6442                	ld	s0,16(sp)
    800011a8:	64a2                	ld	s1,8(sp)
    800011aa:	6105                	addi	sp,sp,32
    800011ac:	8082                	ret

00000000800011ae <growproc>:
{
    800011ae:	1101                	addi	sp,sp,-32
    800011b0:	ec06                	sd	ra,24(sp)
    800011b2:	e822                	sd	s0,16(sp)
    800011b4:	e426                	sd	s1,8(sp)
    800011b6:	e04a                	sd	s2,0(sp)
    800011b8:	1000                	addi	s0,sp,32
    800011ba:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	c98080e7          	jalr	-872(ra) # 80000e54 <myproc>
    800011c4:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c6:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011c8:	01204c63          	bgtz	s2,800011e0 <growproc+0x32>
  } else if(n < 0){
    800011cc:	02094663          	bltz	s2,800011f8 <growproc+0x4a>
  p->sz = sz;
    800011d0:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d2:	4501                	li	a0,0
}
    800011d4:	60e2                	ld	ra,24(sp)
    800011d6:	6442                	ld	s0,16(sp)
    800011d8:	64a2                	ld	s1,8(sp)
    800011da:	6902                	ld	s2,0(sp)
    800011dc:	6105                	addi	sp,sp,32
    800011de:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011e0:	4691                	li	a3,4
    800011e2:	00b90633          	add	a2,s2,a1
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	6d6080e7          	jalr	1750(ra) # 800008be <uvmalloc>
    800011f0:	85aa                	mv	a1,a0
    800011f2:	fd79                	bnez	a0,800011d0 <growproc+0x22>
      return -1;
    800011f4:	557d                	li	a0,-1
    800011f6:	bff9                	j	800011d4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f8:	00b90633          	add	a2,s2,a1
    800011fc:	6928                	ld	a0,80(a0)
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	678080e7          	jalr	1656(ra) # 80000876 <uvmdealloc>
    80001206:	85aa                	mv	a1,a0
    80001208:	b7e1                	j	800011d0 <growproc+0x22>

000000008000120a <fork>:
{
    8000120a:	7179                	addi	sp,sp,-48
    8000120c:	f406                	sd	ra,40(sp)
    8000120e:	f022                	sd	s0,32(sp)
    80001210:	ec26                	sd	s1,24(sp)
    80001212:	e84a                	sd	s2,16(sp)
    80001214:	e44e                	sd	s3,8(sp)
    80001216:	e052                	sd	s4,0(sp)
    80001218:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	c3a080e7          	jalr	-966(ra) # 80000e54 <myproc>
    80001222:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001224:	00000097          	auipc	ra,0x0
    80001228:	e3a080e7          	jalr	-454(ra) # 8000105e <allocproc>
    8000122c:	10050b63          	beqz	a0,80001342 <fork+0x138>
    80001230:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001232:	04893603          	ld	a2,72(s2)
    80001236:	692c                	ld	a1,80(a0)
    80001238:	05093503          	ld	a0,80(s2)
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	7d6080e7          	jalr	2006(ra) # 80000a12 <uvmcopy>
    80001244:	04054663          	bltz	a0,80001290 <fork+0x86>
  np->sz = p->sz;
    80001248:	04893783          	ld	a5,72(s2)
    8000124c:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001250:	05893683          	ld	a3,88(s2)
    80001254:	87b6                	mv	a5,a3
    80001256:	0589b703          	ld	a4,88(s3)
    8000125a:	12068693          	addi	a3,a3,288
    8000125e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001262:	6788                	ld	a0,8(a5)
    80001264:	6b8c                	ld	a1,16(a5)
    80001266:	6f90                	ld	a2,24(a5)
    80001268:	01073023          	sd	a6,0(a4)
    8000126c:	e708                	sd	a0,8(a4)
    8000126e:	eb0c                	sd	a1,16(a4)
    80001270:	ef10                	sd	a2,24(a4)
    80001272:	02078793          	addi	a5,a5,32
    80001276:	02070713          	addi	a4,a4,32
    8000127a:	fed792e3          	bne	a5,a3,8000125e <fork+0x54>
  np->trapframe->a0 = 0;
    8000127e:	0589b783          	ld	a5,88(s3)
    80001282:	0607b823          	sd	zero,112(a5)
    80001286:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000128a:	15000a13          	li	s4,336
    8000128e:	a03d                	j	800012bc <fork+0xb2>
    freeproc(np);
    80001290:	854e                	mv	a0,s3
    80001292:	00000097          	auipc	ra,0x0
    80001296:	d74080e7          	jalr	-652(ra) # 80001006 <freeproc>
    release(&np->lock);
    8000129a:	854e                	mv	a0,s3
    8000129c:	00005097          	auipc	ra,0x5
    800012a0:	f44080e7          	jalr	-188(ra) # 800061e0 <release>
    return -1;
    800012a4:	5a7d                	li	s4,-1
    800012a6:	a069                	j	80001330 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012a8:	00002097          	auipc	ra,0x2
    800012ac:	672080e7          	jalr	1650(ra) # 8000391a <filedup>
    800012b0:	009987b3          	add	a5,s3,s1
    800012b4:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012b6:	04a1                	addi	s1,s1,8
    800012b8:	01448763          	beq	s1,s4,800012c6 <fork+0xbc>
    if(p->ofile[i])
    800012bc:	009907b3          	add	a5,s2,s1
    800012c0:	6388                	ld	a0,0(a5)
    800012c2:	f17d                	bnez	a0,800012a8 <fork+0x9e>
    800012c4:	bfcd                	j	800012b6 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012c6:	15093503          	ld	a0,336(s2)
    800012ca:	00001097          	auipc	ra,0x1
    800012ce:	7d6080e7          	jalr	2006(ra) # 80002aa0 <idup>
    800012d2:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012d6:	4641                	li	a2,16
    800012d8:	15890593          	addi	a1,s2,344
    800012dc:	15898513          	addi	a0,s3,344
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	fea080e7          	jalr	-22(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012e8:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800012ec:	854e                	mv	a0,s3
    800012ee:	00005097          	auipc	ra,0x5
    800012f2:	ef2080e7          	jalr	-270(ra) # 800061e0 <release>
  acquire(&wait_lock);
    800012f6:	00007497          	auipc	s1,0x7
    800012fa:	67248493          	addi	s1,s1,1650 # 80008968 <wait_lock>
    800012fe:	8526                	mv	a0,s1
    80001300:	00005097          	auipc	ra,0x5
    80001304:	e2c080e7          	jalr	-468(ra) # 8000612c <acquire>
  np->parent = p;
    80001308:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	ed2080e7          	jalr	-302(ra) # 800061e0 <release>
  acquire(&np->lock);
    80001316:	854e                	mv	a0,s3
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	e14080e7          	jalr	-492(ra) # 8000612c <acquire>
  np->state = RUNNABLE;
    80001320:	478d                	li	a5,3
    80001322:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001326:	854e                	mv	a0,s3
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	eb8080e7          	jalr	-328(ra) # 800061e0 <release>
}
    80001330:	8552                	mv	a0,s4
    80001332:	70a2                	ld	ra,40(sp)
    80001334:	7402                	ld	s0,32(sp)
    80001336:	64e2                	ld	s1,24(sp)
    80001338:	6942                	ld	s2,16(sp)
    8000133a:	69a2                	ld	s3,8(sp)
    8000133c:	6a02                	ld	s4,0(sp)
    8000133e:	6145                	addi	sp,sp,48
    80001340:	8082                	ret
    return -1;
    80001342:	5a7d                	li	s4,-1
    80001344:	b7f5                	j	80001330 <fork+0x126>

0000000080001346 <scheduler>:
{
    80001346:	7139                	addi	sp,sp,-64
    80001348:	fc06                	sd	ra,56(sp)
    8000134a:	f822                	sd	s0,48(sp)
    8000134c:	f426                	sd	s1,40(sp)
    8000134e:	f04a                	sd	s2,32(sp)
    80001350:	ec4e                	sd	s3,24(sp)
    80001352:	e852                	sd	s4,16(sp)
    80001354:	e456                	sd	s5,8(sp)
    80001356:	e05a                	sd	s6,0(sp)
    80001358:	0080                	addi	s0,sp,64
    8000135a:	8792                	mv	a5,tp
  int id = r_tp();
    8000135c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000135e:	00779a93          	slli	s5,a5,0x7
    80001362:	00007717          	auipc	a4,0x7
    80001366:	5ee70713          	addi	a4,a4,1518 # 80008950 <pid_lock>
    8000136a:	9756                	add	a4,a4,s5
    8000136c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001370:	00007717          	auipc	a4,0x7
    80001374:	61870713          	addi	a4,a4,1560 # 80008988 <cpus+0x8>
    80001378:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000137a:	498d                	li	s3,3
        p->state = RUNNING;
    8000137c:	4b11                	li	s6,4
        c->proc = p;
    8000137e:	079e                	slli	a5,a5,0x7
    80001380:	00007a17          	auipc	s4,0x7
    80001384:	5d0a0a13          	addi	s4,s4,1488 # 80008950 <pid_lock>
    80001388:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000138a:	0000d917          	auipc	s2,0xd
    8000138e:	3f690913          	addi	s2,s2,1014 # 8000e780 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001392:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001396:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000139a:	10079073          	csrw	sstatus,a5
    8000139e:	00008497          	auipc	s1,0x8
    800013a2:	9e248493          	addi	s1,s1,-1566 # 80008d80 <proc>
    800013a6:	a03d                	j	800013d4 <scheduler+0x8e>
        p->state = RUNNING;
    800013a8:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013ac:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013b0:	06048593          	addi	a1,s1,96
    800013b4:	8556                	mv	a0,s5
    800013b6:	00000097          	auipc	ra,0x0
    800013ba:	6a4080e7          	jalr	1700(ra) # 80001a5a <swtch>
        c->proc = 0;
    800013be:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013c2:	8526                	mv	a0,s1
    800013c4:	00005097          	auipc	ra,0x5
    800013c8:	e1c080e7          	jalr	-484(ra) # 800061e0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013cc:	16848493          	addi	s1,s1,360
    800013d0:	fd2481e3          	beq	s1,s2,80001392 <scheduler+0x4c>
      acquire(&p->lock);
    800013d4:	8526                	mv	a0,s1
    800013d6:	00005097          	auipc	ra,0x5
    800013da:	d56080e7          	jalr	-682(ra) # 8000612c <acquire>
      if(p->state == RUNNABLE) {
    800013de:	4c9c                	lw	a5,24(s1)
    800013e0:	ff3791e3          	bne	a5,s3,800013c2 <scheduler+0x7c>
    800013e4:	b7d1                	j	800013a8 <scheduler+0x62>

00000000800013e6 <sched>:
{
    800013e6:	7179                	addi	sp,sp,-48
    800013e8:	f406                	sd	ra,40(sp)
    800013ea:	f022                	sd	s0,32(sp)
    800013ec:	ec26                	sd	s1,24(sp)
    800013ee:	e84a                	sd	s2,16(sp)
    800013f0:	e44e                	sd	s3,8(sp)
    800013f2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f4:	00000097          	auipc	ra,0x0
    800013f8:	a60080e7          	jalr	-1440(ra) # 80000e54 <myproc>
    800013fc:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800013fe:	00005097          	auipc	ra,0x5
    80001402:	cb4080e7          	jalr	-844(ra) # 800060b2 <holding>
    80001406:	c93d                	beqz	a0,8000147c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001408:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000140a:	2781                	sext.w	a5,a5
    8000140c:	079e                	slli	a5,a5,0x7
    8000140e:	00007717          	auipc	a4,0x7
    80001412:	54270713          	addi	a4,a4,1346 # 80008950 <pid_lock>
    80001416:	97ba                	add	a5,a5,a4
    80001418:	0a87a703          	lw	a4,168(a5)
    8000141c:	4785                	li	a5,1
    8000141e:	06f71763          	bne	a4,a5,8000148c <sched+0xa6>
  if(p->state == RUNNING)
    80001422:	4c98                	lw	a4,24(s1)
    80001424:	4791                	li	a5,4
    80001426:	06f70b63          	beq	a4,a5,8000149c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000142e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001430:	efb5                	bnez	a5,800014ac <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001432:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001434:	00007917          	auipc	s2,0x7
    80001438:	51c90913          	addi	s2,s2,1308 # 80008950 <pid_lock>
    8000143c:	2781                	sext.w	a5,a5
    8000143e:	079e                	slli	a5,a5,0x7
    80001440:	97ca                	add	a5,a5,s2
    80001442:	0ac7a983          	lw	s3,172(a5)
    80001446:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001448:	2781                	sext.w	a5,a5
    8000144a:	079e                	slli	a5,a5,0x7
    8000144c:	00007597          	auipc	a1,0x7
    80001450:	53c58593          	addi	a1,a1,1340 # 80008988 <cpus+0x8>
    80001454:	95be                	add	a1,a1,a5
    80001456:	06048513          	addi	a0,s1,96
    8000145a:	00000097          	auipc	ra,0x0
    8000145e:	600080e7          	jalr	1536(ra) # 80001a5a <swtch>
    80001462:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001464:	2781                	sext.w	a5,a5
    80001466:	079e                	slli	a5,a5,0x7
    80001468:	97ca                	add	a5,a5,s2
    8000146a:	0b37a623          	sw	s3,172(a5)
}
    8000146e:	70a2                	ld	ra,40(sp)
    80001470:	7402                	ld	s0,32(sp)
    80001472:	64e2                	ld	s1,24(sp)
    80001474:	6942                	ld	s2,16(sp)
    80001476:	69a2                	ld	s3,8(sp)
    80001478:	6145                	addi	sp,sp,48
    8000147a:	8082                	ret
    panic("sched p->lock");
    8000147c:	00007517          	auipc	a0,0x7
    80001480:	d1c50513          	addi	a0,a0,-740 # 80008198 <etext+0x198>
    80001484:	00004097          	auipc	ra,0x4
    80001488:	75e080e7          	jalr	1886(ra) # 80005be2 <panic>
    panic("sched locks");
    8000148c:	00007517          	auipc	a0,0x7
    80001490:	d1c50513          	addi	a0,a0,-740 # 800081a8 <etext+0x1a8>
    80001494:	00004097          	auipc	ra,0x4
    80001498:	74e080e7          	jalr	1870(ra) # 80005be2 <panic>
    panic("sched running");
    8000149c:	00007517          	auipc	a0,0x7
    800014a0:	d1c50513          	addi	a0,a0,-740 # 800081b8 <etext+0x1b8>
    800014a4:	00004097          	auipc	ra,0x4
    800014a8:	73e080e7          	jalr	1854(ra) # 80005be2 <panic>
    panic("sched interruptible");
    800014ac:	00007517          	auipc	a0,0x7
    800014b0:	d1c50513          	addi	a0,a0,-740 # 800081c8 <etext+0x1c8>
    800014b4:	00004097          	auipc	ra,0x4
    800014b8:	72e080e7          	jalr	1838(ra) # 80005be2 <panic>

00000000800014bc <yield>:
{
    800014bc:	1101                	addi	sp,sp,-32
    800014be:	ec06                	sd	ra,24(sp)
    800014c0:	e822                	sd	s0,16(sp)
    800014c2:	e426                	sd	s1,8(sp)
    800014c4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	98e080e7          	jalr	-1650(ra) # 80000e54 <myproc>
    800014ce:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d0:	00005097          	auipc	ra,0x5
    800014d4:	c5c080e7          	jalr	-932(ra) # 8000612c <acquire>
  p->state = RUNNABLE;
    800014d8:	478d                	li	a5,3
    800014da:	cc9c                	sw	a5,24(s1)
  sched();
    800014dc:	00000097          	auipc	ra,0x0
    800014e0:	f0a080e7          	jalr	-246(ra) # 800013e6 <sched>
  release(&p->lock);
    800014e4:	8526                	mv	a0,s1
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	cfa080e7          	jalr	-774(ra) # 800061e0 <release>
}
    800014ee:	60e2                	ld	ra,24(sp)
    800014f0:	6442                	ld	s0,16(sp)
    800014f2:	64a2                	ld	s1,8(sp)
    800014f4:	6105                	addi	sp,sp,32
    800014f6:	8082                	ret

00000000800014f8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014f8:	7179                	addi	sp,sp,-48
    800014fa:	f406                	sd	ra,40(sp)
    800014fc:	f022                	sd	s0,32(sp)
    800014fe:	ec26                	sd	s1,24(sp)
    80001500:	e84a                	sd	s2,16(sp)
    80001502:	e44e                	sd	s3,8(sp)
    80001504:	1800                	addi	s0,sp,48
    80001506:	89aa                	mv	s3,a0
    80001508:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150a:	00000097          	auipc	ra,0x0
    8000150e:	94a080e7          	jalr	-1718(ra) # 80000e54 <myproc>
    80001512:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001514:	00005097          	auipc	ra,0x5
    80001518:	c18080e7          	jalr	-1000(ra) # 8000612c <acquire>
  release(lk);
    8000151c:	854a                	mv	a0,s2
    8000151e:	00005097          	auipc	ra,0x5
    80001522:	cc2080e7          	jalr	-830(ra) # 800061e0 <release>

  // Go to sleep.
  p->chan = chan;
    80001526:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152a:	4789                	li	a5,2
    8000152c:	cc9c                	sw	a5,24(s1)

  sched();
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	eb8080e7          	jalr	-328(ra) # 800013e6 <sched>

  // Tidy up.
  p->chan = 0;
    80001536:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153a:	8526                	mv	a0,s1
    8000153c:	00005097          	auipc	ra,0x5
    80001540:	ca4080e7          	jalr	-860(ra) # 800061e0 <release>
  acquire(lk);
    80001544:	854a                	mv	a0,s2
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	be6080e7          	jalr	-1050(ra) # 8000612c <acquire>
}
    8000154e:	70a2                	ld	ra,40(sp)
    80001550:	7402                	ld	s0,32(sp)
    80001552:	64e2                	ld	s1,24(sp)
    80001554:	6942                	ld	s2,16(sp)
    80001556:	69a2                	ld	s3,8(sp)
    80001558:	6145                	addi	sp,sp,48
    8000155a:	8082                	ret

000000008000155c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000155c:	7139                	addi	sp,sp,-64
    8000155e:	fc06                	sd	ra,56(sp)
    80001560:	f822                	sd	s0,48(sp)
    80001562:	f426                	sd	s1,40(sp)
    80001564:	f04a                	sd	s2,32(sp)
    80001566:	ec4e                	sd	s3,24(sp)
    80001568:	e852                	sd	s4,16(sp)
    8000156a:	e456                	sd	s5,8(sp)
    8000156c:	0080                	addi	s0,sp,64
    8000156e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001570:	00008497          	auipc	s1,0x8
    80001574:	81048493          	addi	s1,s1,-2032 # 80008d80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001578:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000157a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000157c:	0000d917          	auipc	s2,0xd
    80001580:	20490913          	addi	s2,s2,516 # 8000e780 <tickslock>
    80001584:	a821                	j	8000159c <wakeup+0x40>
        p->state = RUNNABLE;
    80001586:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000158a:	8526                	mv	a0,s1
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	c54080e7          	jalr	-940(ra) # 800061e0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001594:	16848493          	addi	s1,s1,360
    80001598:	03248463          	beq	s1,s2,800015c0 <wakeup+0x64>
    if(p != myproc()){
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	8b8080e7          	jalr	-1864(ra) # 80000e54 <myproc>
    800015a4:	fea488e3          	beq	s1,a0,80001594 <wakeup+0x38>
      acquire(&p->lock);
    800015a8:	8526                	mv	a0,s1
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	b82080e7          	jalr	-1150(ra) # 8000612c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015b2:	4c9c                	lw	a5,24(s1)
    800015b4:	fd379be3          	bne	a5,s3,8000158a <wakeup+0x2e>
    800015b8:	709c                	ld	a5,32(s1)
    800015ba:	fd4798e3          	bne	a5,s4,8000158a <wakeup+0x2e>
    800015be:	b7e1                	j	80001586 <wakeup+0x2a>
    }
  }
}
    800015c0:	70e2                	ld	ra,56(sp)
    800015c2:	7442                	ld	s0,48(sp)
    800015c4:	74a2                	ld	s1,40(sp)
    800015c6:	7902                	ld	s2,32(sp)
    800015c8:	69e2                	ld	s3,24(sp)
    800015ca:	6a42                	ld	s4,16(sp)
    800015cc:	6aa2                	ld	s5,8(sp)
    800015ce:	6121                	addi	sp,sp,64
    800015d0:	8082                	ret

00000000800015d2 <reparent>:
{
    800015d2:	7179                	addi	sp,sp,-48
    800015d4:	f406                	sd	ra,40(sp)
    800015d6:	f022                	sd	s0,32(sp)
    800015d8:	ec26                	sd	s1,24(sp)
    800015da:	e84a                	sd	s2,16(sp)
    800015dc:	e44e                	sd	s3,8(sp)
    800015de:	e052                	sd	s4,0(sp)
    800015e0:	1800                	addi	s0,sp,48
    800015e2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015e4:	00007497          	auipc	s1,0x7
    800015e8:	79c48493          	addi	s1,s1,1948 # 80008d80 <proc>
      pp->parent = initproc;
    800015ec:	00007a17          	auipc	s4,0x7
    800015f0:	324a0a13          	addi	s4,s4,804 # 80008910 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f4:	0000d997          	auipc	s3,0xd
    800015f8:	18c98993          	addi	s3,s3,396 # 8000e780 <tickslock>
    800015fc:	a029                	j	80001606 <reparent+0x34>
    800015fe:	16848493          	addi	s1,s1,360
    80001602:	01348d63          	beq	s1,s3,8000161c <reparent+0x4a>
    if(pp->parent == p){
    80001606:	7c9c                	ld	a5,56(s1)
    80001608:	ff279be3          	bne	a5,s2,800015fe <reparent+0x2c>
      pp->parent = initproc;
    8000160c:	000a3503          	ld	a0,0(s4)
    80001610:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001612:	00000097          	auipc	ra,0x0
    80001616:	f4a080e7          	jalr	-182(ra) # 8000155c <wakeup>
    8000161a:	b7d5                	j	800015fe <reparent+0x2c>
}
    8000161c:	70a2                	ld	ra,40(sp)
    8000161e:	7402                	ld	s0,32(sp)
    80001620:	64e2                	ld	s1,24(sp)
    80001622:	6942                	ld	s2,16(sp)
    80001624:	69a2                	ld	s3,8(sp)
    80001626:	6a02                	ld	s4,0(sp)
    80001628:	6145                	addi	sp,sp,48
    8000162a:	8082                	ret

000000008000162c <exit>:
{
    8000162c:	7179                	addi	sp,sp,-48
    8000162e:	f406                	sd	ra,40(sp)
    80001630:	f022                	sd	s0,32(sp)
    80001632:	ec26                	sd	s1,24(sp)
    80001634:	e84a                	sd	s2,16(sp)
    80001636:	e44e                	sd	s3,8(sp)
    80001638:	e052                	sd	s4,0(sp)
    8000163a:	1800                	addi	s0,sp,48
    8000163c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000163e:	00000097          	auipc	ra,0x0
    80001642:	816080e7          	jalr	-2026(ra) # 80000e54 <myproc>
    80001646:	89aa                	mv	s3,a0
  if(p == initproc)
    80001648:	00007797          	auipc	a5,0x7
    8000164c:	2c87b783          	ld	a5,712(a5) # 80008910 <initproc>
    80001650:	0d050493          	addi	s1,a0,208
    80001654:	15050913          	addi	s2,a0,336
    80001658:	02a79363          	bne	a5,a0,8000167e <exit+0x52>
    panic("init exiting");
    8000165c:	00007517          	auipc	a0,0x7
    80001660:	b8450513          	addi	a0,a0,-1148 # 800081e0 <etext+0x1e0>
    80001664:	00004097          	auipc	ra,0x4
    80001668:	57e080e7          	jalr	1406(ra) # 80005be2 <panic>
      fileclose(f);
    8000166c:	00002097          	auipc	ra,0x2
    80001670:	300080e7          	jalr	768(ra) # 8000396c <fileclose>
      p->ofile[fd] = 0;
    80001674:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001678:	04a1                	addi	s1,s1,8
    8000167a:	01248563          	beq	s1,s2,80001684 <exit+0x58>
    if(p->ofile[fd]){
    8000167e:	6088                	ld	a0,0(s1)
    80001680:	f575                	bnez	a0,8000166c <exit+0x40>
    80001682:	bfdd                	j	80001678 <exit+0x4c>
  begin_op();
    80001684:	00002097          	auipc	ra,0x2
    80001688:	e1c080e7          	jalr	-484(ra) # 800034a0 <begin_op>
  iput(p->cwd);
    8000168c:	1509b503          	ld	a0,336(s3)
    80001690:	00001097          	auipc	ra,0x1
    80001694:	608080e7          	jalr	1544(ra) # 80002c98 <iput>
  end_op();
    80001698:	00002097          	auipc	ra,0x2
    8000169c:	e88080e7          	jalr	-376(ra) # 80003520 <end_op>
  p->cwd = 0;
    800016a0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a4:	00007497          	auipc	s1,0x7
    800016a8:	2c448493          	addi	s1,s1,708 # 80008968 <wait_lock>
    800016ac:	8526                	mv	a0,s1
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	a7e080e7          	jalr	-1410(ra) # 8000612c <acquire>
  reparent(p);
    800016b6:	854e                	mv	a0,s3
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	f1a080e7          	jalr	-230(ra) # 800015d2 <reparent>
  wakeup(p->parent);
    800016c0:	0389b503          	ld	a0,56(s3)
    800016c4:	00000097          	auipc	ra,0x0
    800016c8:	e98080e7          	jalr	-360(ra) # 8000155c <wakeup>
  acquire(&p->lock);
    800016cc:	854e                	mv	a0,s3
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	a5e080e7          	jalr	-1442(ra) # 8000612c <acquire>
  p->xstate = status;
    800016d6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016da:	4795                	li	a5,5
    800016dc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e0:	8526                	mv	a0,s1
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	afe080e7          	jalr	-1282(ra) # 800061e0 <release>
  sched();
    800016ea:	00000097          	auipc	ra,0x0
    800016ee:	cfc080e7          	jalr	-772(ra) # 800013e6 <sched>
  panic("zombie exit");
    800016f2:	00007517          	auipc	a0,0x7
    800016f6:	afe50513          	addi	a0,a0,-1282 # 800081f0 <etext+0x1f0>
    800016fa:	00004097          	auipc	ra,0x4
    800016fe:	4e8080e7          	jalr	1256(ra) # 80005be2 <panic>

0000000080001702 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001702:	7179                	addi	sp,sp,-48
    80001704:	f406                	sd	ra,40(sp)
    80001706:	f022                	sd	s0,32(sp)
    80001708:	ec26                	sd	s1,24(sp)
    8000170a:	e84a                	sd	s2,16(sp)
    8000170c:	e44e                	sd	s3,8(sp)
    8000170e:	1800                	addi	s0,sp,48
    80001710:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001712:	00007497          	auipc	s1,0x7
    80001716:	66e48493          	addi	s1,s1,1646 # 80008d80 <proc>
    8000171a:	0000d997          	auipc	s3,0xd
    8000171e:	06698993          	addi	s3,s3,102 # 8000e780 <tickslock>
    acquire(&p->lock);
    80001722:	8526                	mv	a0,s1
    80001724:	00005097          	auipc	ra,0x5
    80001728:	a08080e7          	jalr	-1528(ra) # 8000612c <acquire>
    if(p->pid == pid){
    8000172c:	589c                	lw	a5,48(s1)
    8000172e:	01278d63          	beq	a5,s2,80001748 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001732:	8526                	mv	a0,s1
    80001734:	00005097          	auipc	ra,0x5
    80001738:	aac080e7          	jalr	-1364(ra) # 800061e0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000173c:	16848493          	addi	s1,s1,360
    80001740:	ff3491e3          	bne	s1,s3,80001722 <kill+0x20>
  }
  return -1;
    80001744:	557d                	li	a0,-1
    80001746:	a829                	j	80001760 <kill+0x5e>
      p->killed = 1;
    80001748:	4785                	li	a5,1
    8000174a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000174c:	4c98                	lw	a4,24(s1)
    8000174e:	4789                	li	a5,2
    80001750:	00f70f63          	beq	a4,a5,8000176e <kill+0x6c>
      release(&p->lock);
    80001754:	8526                	mv	a0,s1
    80001756:	00005097          	auipc	ra,0x5
    8000175a:	a8a080e7          	jalr	-1398(ra) # 800061e0 <release>
      return 0;
    8000175e:	4501                	li	a0,0
}
    80001760:	70a2                	ld	ra,40(sp)
    80001762:	7402                	ld	s0,32(sp)
    80001764:	64e2                	ld	s1,24(sp)
    80001766:	6942                	ld	s2,16(sp)
    80001768:	69a2                	ld	s3,8(sp)
    8000176a:	6145                	addi	sp,sp,48
    8000176c:	8082                	ret
        p->state = RUNNABLE;
    8000176e:	478d                	li	a5,3
    80001770:	cc9c                	sw	a5,24(s1)
    80001772:	b7cd                	j	80001754 <kill+0x52>

0000000080001774 <setkilled>:

void
setkilled(struct proc *p)
{
    80001774:	1101                	addi	sp,sp,-32
    80001776:	ec06                	sd	ra,24(sp)
    80001778:	e822                	sd	s0,16(sp)
    8000177a:	e426                	sd	s1,8(sp)
    8000177c:	1000                	addi	s0,sp,32
    8000177e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001780:	00005097          	auipc	ra,0x5
    80001784:	9ac080e7          	jalr	-1620(ra) # 8000612c <acquire>
  p->killed = 1;
    80001788:	4785                	li	a5,1
    8000178a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000178c:	8526                	mv	a0,s1
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	a52080e7          	jalr	-1454(ra) # 800061e0 <release>
}
    80001796:	60e2                	ld	ra,24(sp)
    80001798:	6442                	ld	s0,16(sp)
    8000179a:	64a2                	ld	s1,8(sp)
    8000179c:	6105                	addi	sp,sp,32
    8000179e:	8082                	ret

00000000800017a0 <killed>:

int
killed(struct proc *p)
{
    800017a0:	1101                	addi	sp,sp,-32
    800017a2:	ec06                	sd	ra,24(sp)
    800017a4:	e822                	sd	s0,16(sp)
    800017a6:	e426                	sd	s1,8(sp)
    800017a8:	e04a                	sd	s2,0(sp)
    800017aa:	1000                	addi	s0,sp,32
    800017ac:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017ae:	00005097          	auipc	ra,0x5
    800017b2:	97e080e7          	jalr	-1666(ra) # 8000612c <acquire>
  k = p->killed;
    800017b6:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017ba:	8526                	mv	a0,s1
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	a24080e7          	jalr	-1500(ra) # 800061e0 <release>
  return k;
}
    800017c4:	854a                	mv	a0,s2
    800017c6:	60e2                	ld	ra,24(sp)
    800017c8:	6442                	ld	s0,16(sp)
    800017ca:	64a2                	ld	s1,8(sp)
    800017cc:	6902                	ld	s2,0(sp)
    800017ce:	6105                	addi	sp,sp,32
    800017d0:	8082                	ret

00000000800017d2 <wait>:
{
    800017d2:	715d                	addi	sp,sp,-80
    800017d4:	e486                	sd	ra,72(sp)
    800017d6:	e0a2                	sd	s0,64(sp)
    800017d8:	fc26                	sd	s1,56(sp)
    800017da:	f84a                	sd	s2,48(sp)
    800017dc:	f44e                	sd	s3,40(sp)
    800017de:	f052                	sd	s4,32(sp)
    800017e0:	ec56                	sd	s5,24(sp)
    800017e2:	e85a                	sd	s6,16(sp)
    800017e4:	e45e                	sd	s7,8(sp)
    800017e6:	e062                	sd	s8,0(sp)
    800017e8:	0880                	addi	s0,sp,80
    800017ea:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017ec:	fffff097          	auipc	ra,0xfffff
    800017f0:	668080e7          	jalr	1640(ra) # 80000e54 <myproc>
    800017f4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017f6:	00007517          	auipc	a0,0x7
    800017fa:	17250513          	addi	a0,a0,370 # 80008968 <wait_lock>
    800017fe:	00005097          	auipc	ra,0x5
    80001802:	92e080e7          	jalr	-1746(ra) # 8000612c <acquire>
    havekids = 0;
    80001806:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001808:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000180a:	0000d997          	auipc	s3,0xd
    8000180e:	f7698993          	addi	s3,s3,-138 # 8000e780 <tickslock>
        havekids = 1;
    80001812:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001814:	00007c17          	auipc	s8,0x7
    80001818:	154c0c13          	addi	s8,s8,340 # 80008968 <wait_lock>
    havekids = 0;
    8000181c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000181e:	00007497          	auipc	s1,0x7
    80001822:	56248493          	addi	s1,s1,1378 # 80008d80 <proc>
    80001826:	a0bd                	j	80001894 <wait+0xc2>
          pid = pp->pid;
    80001828:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000182c:	000b0e63          	beqz	s6,80001848 <wait+0x76>
    80001830:	4691                	li	a3,4
    80001832:	02c48613          	addi	a2,s1,44
    80001836:	85da                	mv	a1,s6
    80001838:	05093503          	ld	a0,80(s2)
    8000183c:	fffff097          	auipc	ra,0xfffff
    80001840:	2da080e7          	jalr	730(ra) # 80000b16 <copyout>
    80001844:	02054563          	bltz	a0,8000186e <wait+0x9c>
          freeproc(pp);
    80001848:	8526                	mv	a0,s1
    8000184a:	fffff097          	auipc	ra,0xfffff
    8000184e:	7bc080e7          	jalr	1980(ra) # 80001006 <freeproc>
          release(&pp->lock);
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	98c080e7          	jalr	-1652(ra) # 800061e0 <release>
          release(&wait_lock);
    8000185c:	00007517          	auipc	a0,0x7
    80001860:	10c50513          	addi	a0,a0,268 # 80008968 <wait_lock>
    80001864:	00005097          	auipc	ra,0x5
    80001868:	97c080e7          	jalr	-1668(ra) # 800061e0 <release>
          return pid;
    8000186c:	a0b5                	j	800018d8 <wait+0x106>
            release(&pp->lock);
    8000186e:	8526                	mv	a0,s1
    80001870:	00005097          	auipc	ra,0x5
    80001874:	970080e7          	jalr	-1680(ra) # 800061e0 <release>
            release(&wait_lock);
    80001878:	00007517          	auipc	a0,0x7
    8000187c:	0f050513          	addi	a0,a0,240 # 80008968 <wait_lock>
    80001880:	00005097          	auipc	ra,0x5
    80001884:	960080e7          	jalr	-1696(ra) # 800061e0 <release>
            return -1;
    80001888:	59fd                	li	s3,-1
    8000188a:	a0b9                	j	800018d8 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000188c:	16848493          	addi	s1,s1,360
    80001890:	03348463          	beq	s1,s3,800018b8 <wait+0xe6>
      if(pp->parent == p){
    80001894:	7c9c                	ld	a5,56(s1)
    80001896:	ff279be3          	bne	a5,s2,8000188c <wait+0xba>
        acquire(&pp->lock);
    8000189a:	8526                	mv	a0,s1
    8000189c:	00005097          	auipc	ra,0x5
    800018a0:	890080e7          	jalr	-1904(ra) # 8000612c <acquire>
        if(pp->state == ZOMBIE){
    800018a4:	4c9c                	lw	a5,24(s1)
    800018a6:	f94781e3          	beq	a5,s4,80001828 <wait+0x56>
        release(&pp->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	934080e7          	jalr	-1740(ra) # 800061e0 <release>
        havekids = 1;
    800018b4:	8756                	mv	a4,s5
    800018b6:	bfd9                	j	8000188c <wait+0xba>
    if(!havekids || killed(p)){
    800018b8:	c719                	beqz	a4,800018c6 <wait+0xf4>
    800018ba:	854a                	mv	a0,s2
    800018bc:	00000097          	auipc	ra,0x0
    800018c0:	ee4080e7          	jalr	-284(ra) # 800017a0 <killed>
    800018c4:	c51d                	beqz	a0,800018f2 <wait+0x120>
      release(&wait_lock);
    800018c6:	00007517          	auipc	a0,0x7
    800018ca:	0a250513          	addi	a0,a0,162 # 80008968 <wait_lock>
    800018ce:	00005097          	auipc	ra,0x5
    800018d2:	912080e7          	jalr	-1774(ra) # 800061e0 <release>
      return -1;
    800018d6:	59fd                	li	s3,-1
}
    800018d8:	854e                	mv	a0,s3
    800018da:	60a6                	ld	ra,72(sp)
    800018dc:	6406                	ld	s0,64(sp)
    800018de:	74e2                	ld	s1,56(sp)
    800018e0:	7942                	ld	s2,48(sp)
    800018e2:	79a2                	ld	s3,40(sp)
    800018e4:	7a02                	ld	s4,32(sp)
    800018e6:	6ae2                	ld	s5,24(sp)
    800018e8:	6b42                	ld	s6,16(sp)
    800018ea:	6ba2                	ld	s7,8(sp)
    800018ec:	6c02                	ld	s8,0(sp)
    800018ee:	6161                	addi	sp,sp,80
    800018f0:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018f2:	85e2                	mv	a1,s8
    800018f4:	854a                	mv	a0,s2
    800018f6:	00000097          	auipc	ra,0x0
    800018fa:	c02080e7          	jalr	-1022(ra) # 800014f8 <sleep>
    havekids = 0;
    800018fe:	bf39                	j	8000181c <wait+0x4a>

0000000080001900 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001900:	7179                	addi	sp,sp,-48
    80001902:	f406                	sd	ra,40(sp)
    80001904:	f022                	sd	s0,32(sp)
    80001906:	ec26                	sd	s1,24(sp)
    80001908:	e84a                	sd	s2,16(sp)
    8000190a:	e44e                	sd	s3,8(sp)
    8000190c:	e052                	sd	s4,0(sp)
    8000190e:	1800                	addi	s0,sp,48
    80001910:	84aa                	mv	s1,a0
    80001912:	892e                	mv	s2,a1
    80001914:	89b2                	mv	s3,a2
    80001916:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001918:	fffff097          	auipc	ra,0xfffff
    8000191c:	53c080e7          	jalr	1340(ra) # 80000e54 <myproc>
  if(user_dst){
    80001920:	c08d                	beqz	s1,80001942 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001922:	86d2                	mv	a3,s4
    80001924:	864e                	mv	a2,s3
    80001926:	85ca                	mv	a1,s2
    80001928:	6928                	ld	a0,80(a0)
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	1ec080e7          	jalr	492(ra) # 80000b16 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001932:	70a2                	ld	ra,40(sp)
    80001934:	7402                	ld	s0,32(sp)
    80001936:	64e2                	ld	s1,24(sp)
    80001938:	6942                	ld	s2,16(sp)
    8000193a:	69a2                	ld	s3,8(sp)
    8000193c:	6a02                	ld	s4,0(sp)
    8000193e:	6145                	addi	sp,sp,48
    80001940:	8082                	ret
    memmove((char *)dst, src, len);
    80001942:	000a061b          	sext.w	a2,s4
    80001946:	85ce                	mv	a1,s3
    80001948:	854a                	mv	a0,s2
    8000194a:	fffff097          	auipc	ra,0xfffff
    8000194e:	88e080e7          	jalr	-1906(ra) # 800001d8 <memmove>
    return 0;
    80001952:	8526                	mv	a0,s1
    80001954:	bff9                	j	80001932 <either_copyout+0x32>

0000000080001956 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001956:	7179                	addi	sp,sp,-48
    80001958:	f406                	sd	ra,40(sp)
    8000195a:	f022                	sd	s0,32(sp)
    8000195c:	ec26                	sd	s1,24(sp)
    8000195e:	e84a                	sd	s2,16(sp)
    80001960:	e44e                	sd	s3,8(sp)
    80001962:	e052                	sd	s4,0(sp)
    80001964:	1800                	addi	s0,sp,48
    80001966:	892a                	mv	s2,a0
    80001968:	84ae                	mv	s1,a1
    8000196a:	89b2                	mv	s3,a2
    8000196c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196e:	fffff097          	auipc	ra,0xfffff
    80001972:	4e6080e7          	jalr	1254(ra) # 80000e54 <myproc>
  if(user_src){
    80001976:	c08d                	beqz	s1,80001998 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001978:	86d2                	mv	a3,s4
    8000197a:	864e                	mv	a2,s3
    8000197c:	85ca                	mv	a1,s2
    8000197e:	6928                	ld	a0,80(a0)
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	222080e7          	jalr	546(ra) # 80000ba2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001988:	70a2                	ld	ra,40(sp)
    8000198a:	7402                	ld	s0,32(sp)
    8000198c:	64e2                	ld	s1,24(sp)
    8000198e:	6942                	ld	s2,16(sp)
    80001990:	69a2                	ld	s3,8(sp)
    80001992:	6a02                	ld	s4,0(sp)
    80001994:	6145                	addi	sp,sp,48
    80001996:	8082                	ret
    memmove(dst, (char*)src, len);
    80001998:	000a061b          	sext.w	a2,s4
    8000199c:	85ce                	mv	a1,s3
    8000199e:	854a                	mv	a0,s2
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	838080e7          	jalr	-1992(ra) # 800001d8 <memmove>
    return 0;
    800019a8:	8526                	mv	a0,s1
    800019aa:	bff9                	j	80001988 <either_copyin+0x32>

00000000800019ac <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ac:	715d                	addi	sp,sp,-80
    800019ae:	e486                	sd	ra,72(sp)
    800019b0:	e0a2                	sd	s0,64(sp)
    800019b2:	fc26                	sd	s1,56(sp)
    800019b4:	f84a                	sd	s2,48(sp)
    800019b6:	f44e                	sd	s3,40(sp)
    800019b8:	f052                	sd	s4,32(sp)
    800019ba:	ec56                	sd	s5,24(sp)
    800019bc:	e85a                	sd	s6,16(sp)
    800019be:	e45e                	sd	s7,8(sp)
    800019c0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c2:	00006517          	auipc	a0,0x6
    800019c6:	68650513          	addi	a0,a0,1670 # 80008048 <etext+0x48>
    800019ca:	00004097          	auipc	ra,0x4
    800019ce:	262080e7          	jalr	610(ra) # 80005c2c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d2:	00007497          	auipc	s1,0x7
    800019d6:	50648493          	addi	s1,s1,1286 # 80008ed8 <proc+0x158>
    800019da:	0000d917          	auipc	s2,0xd
    800019de:	efe90913          	addi	s2,s2,-258 # 8000e8d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e4:	00007997          	auipc	s3,0x7
    800019e8:	81c98993          	addi	s3,s3,-2020 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ec:	00007a97          	auipc	s5,0x7
    800019f0:	81ca8a93          	addi	s5,s5,-2020 # 80008208 <etext+0x208>
    printf("\n");
    800019f4:	00006a17          	auipc	s4,0x6
    800019f8:	654a0a13          	addi	s4,s4,1620 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fc:	00007b97          	auipc	s7,0x7
    80001a00:	84cb8b93          	addi	s7,s7,-1972 # 80008248 <states.1724>
    80001a04:	a00d                	j	80001a26 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a06:	ed86a583          	lw	a1,-296(a3)
    80001a0a:	8556                	mv	a0,s5
    80001a0c:	00004097          	auipc	ra,0x4
    80001a10:	220080e7          	jalr	544(ra) # 80005c2c <printf>
    printf("\n");
    80001a14:	8552                	mv	a0,s4
    80001a16:	00004097          	auipc	ra,0x4
    80001a1a:	216080e7          	jalr	534(ra) # 80005c2c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1e:	16848493          	addi	s1,s1,360
    80001a22:	03248163          	beq	s1,s2,80001a44 <procdump+0x98>
    if(p->state == UNUSED)
    80001a26:	86a6                	mv	a3,s1
    80001a28:	ec04a783          	lw	a5,-320(s1)
    80001a2c:	dbed                	beqz	a5,80001a1e <procdump+0x72>
      state = "???";
    80001a2e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a30:	fcfb6be3          	bltu	s6,a5,80001a06 <procdump+0x5a>
    80001a34:	1782                	slli	a5,a5,0x20
    80001a36:	9381                	srli	a5,a5,0x20
    80001a38:	078e                	slli	a5,a5,0x3
    80001a3a:	97de                	add	a5,a5,s7
    80001a3c:	6390                	ld	a2,0(a5)
    80001a3e:	f661                	bnez	a2,80001a06 <procdump+0x5a>
      state = "???";
    80001a40:	864e                	mv	a2,s3
    80001a42:	b7d1                	j	80001a06 <procdump+0x5a>
  }
}
    80001a44:	60a6                	ld	ra,72(sp)
    80001a46:	6406                	ld	s0,64(sp)
    80001a48:	74e2                	ld	s1,56(sp)
    80001a4a:	7942                	ld	s2,48(sp)
    80001a4c:	79a2                	ld	s3,40(sp)
    80001a4e:	7a02                	ld	s4,32(sp)
    80001a50:	6ae2                	ld	s5,24(sp)
    80001a52:	6b42                	ld	s6,16(sp)
    80001a54:	6ba2                	ld	s7,8(sp)
    80001a56:	6161                	addi	sp,sp,80
    80001a58:	8082                	ret

0000000080001a5a <swtch>:
    80001a5a:	00153023          	sd	ra,0(a0)
    80001a5e:	00253423          	sd	sp,8(a0)
    80001a62:	e900                	sd	s0,16(a0)
    80001a64:	ed04                	sd	s1,24(a0)
    80001a66:	03253023          	sd	s2,32(a0)
    80001a6a:	03353423          	sd	s3,40(a0)
    80001a6e:	03453823          	sd	s4,48(a0)
    80001a72:	03553c23          	sd	s5,56(a0)
    80001a76:	05653023          	sd	s6,64(a0)
    80001a7a:	05753423          	sd	s7,72(a0)
    80001a7e:	05853823          	sd	s8,80(a0)
    80001a82:	05953c23          	sd	s9,88(a0)
    80001a86:	07a53023          	sd	s10,96(a0)
    80001a8a:	07b53423          	sd	s11,104(a0)
    80001a8e:	0005b083          	ld	ra,0(a1)
    80001a92:	0085b103          	ld	sp,8(a1)
    80001a96:	6980                	ld	s0,16(a1)
    80001a98:	6d84                	ld	s1,24(a1)
    80001a9a:	0205b903          	ld	s2,32(a1)
    80001a9e:	0285b983          	ld	s3,40(a1)
    80001aa2:	0305ba03          	ld	s4,48(a1)
    80001aa6:	0385ba83          	ld	s5,56(a1)
    80001aaa:	0405bb03          	ld	s6,64(a1)
    80001aae:	0485bb83          	ld	s7,72(a1)
    80001ab2:	0505bc03          	ld	s8,80(a1)
    80001ab6:	0585bc83          	ld	s9,88(a1)
    80001aba:	0605bd03          	ld	s10,96(a1)
    80001abe:	0685bd83          	ld	s11,104(a1)
    80001ac2:	8082                	ret

0000000080001ac4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac4:	1141                	addi	sp,sp,-16
    80001ac6:	e406                	sd	ra,8(sp)
    80001ac8:	e022                	sd	s0,0(sp)
    80001aca:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001acc:	00006597          	auipc	a1,0x6
    80001ad0:	7ac58593          	addi	a1,a1,1964 # 80008278 <states.1724+0x30>
    80001ad4:	0000d517          	auipc	a0,0xd
    80001ad8:	cac50513          	addi	a0,a0,-852 # 8000e780 <tickslock>
    80001adc:	00004097          	auipc	ra,0x4
    80001ae0:	5c0080e7          	jalr	1472(ra) # 8000609c <initlock>
}
    80001ae4:	60a2                	ld	ra,8(sp)
    80001ae6:	6402                	ld	s0,0(sp)
    80001ae8:	0141                	addi	sp,sp,16
    80001aea:	8082                	ret

0000000080001aec <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aec:	1141                	addi	sp,sp,-16
    80001aee:	e422                	sd	s0,8(sp)
    80001af0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af2:	00003797          	auipc	a5,0x3
    80001af6:	4be78793          	addi	a5,a5,1214 # 80004fb0 <kernelvec>
    80001afa:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001afe:	6422                	ld	s0,8(sp)
    80001b00:	0141                	addi	sp,sp,16
    80001b02:	8082                	ret

0000000080001b04 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b04:	1141                	addi	sp,sp,-16
    80001b06:	e406                	sd	ra,8(sp)
    80001b08:	e022                	sd	s0,0(sp)
    80001b0a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b0c:	fffff097          	auipc	ra,0xfffff
    80001b10:	348080e7          	jalr	840(ra) # 80000e54 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b14:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b18:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b1e:	00005617          	auipc	a2,0x5
    80001b22:	4e260613          	addi	a2,a2,1250 # 80007000 <_trampoline>
    80001b26:	00005697          	auipc	a3,0x5
    80001b2a:	4da68693          	addi	a3,a3,1242 # 80007000 <_trampoline>
    80001b2e:	8e91                	sub	a3,a3,a2
    80001b30:	040007b7          	lui	a5,0x4000
    80001b34:	17fd                	addi	a5,a5,-1
    80001b36:	07b2                	slli	a5,a5,0xc
    80001b38:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b3a:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b3e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b40:	180026f3          	csrr	a3,satp
    80001b44:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b46:	6d38                	ld	a4,88(a0)
    80001b48:	6134                	ld	a3,64(a0)
    80001b4a:	6585                	lui	a1,0x1
    80001b4c:	96ae                	add	a3,a3,a1
    80001b4e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b50:	6d38                	ld	a4,88(a0)
    80001b52:	00000697          	auipc	a3,0x0
    80001b56:	13068693          	addi	a3,a3,304 # 80001c82 <usertrap>
    80001b5a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b5c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b5e:	8692                	mv	a3,tp
    80001b60:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b62:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b66:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b6a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b72:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b74:	6f18                	ld	a4,24(a4)
    80001b76:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b7a:	6928                	ld	a0,80(a0)
    80001b7c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b7e:	00005717          	auipc	a4,0x5
    80001b82:	51e70713          	addi	a4,a4,1310 # 8000709c <userret>
    80001b86:	8f11                	sub	a4,a4,a2
    80001b88:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b8a:	577d                	li	a4,-1
    80001b8c:	177e                	slli	a4,a4,0x3f
    80001b8e:	8d59                	or	a0,a0,a4
    80001b90:	9782                	jalr	a5
}
    80001b92:	60a2                	ld	ra,8(sp)
    80001b94:	6402                	ld	s0,0(sp)
    80001b96:	0141                	addi	sp,sp,16
    80001b98:	8082                	ret

0000000080001b9a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b9a:	1101                	addi	sp,sp,-32
    80001b9c:	ec06                	sd	ra,24(sp)
    80001b9e:	e822                	sd	s0,16(sp)
    80001ba0:	e426                	sd	s1,8(sp)
    80001ba2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba4:	0000d497          	auipc	s1,0xd
    80001ba8:	bdc48493          	addi	s1,s1,-1060 # 8000e780 <tickslock>
    80001bac:	8526                	mv	a0,s1
    80001bae:	00004097          	auipc	ra,0x4
    80001bb2:	57e080e7          	jalr	1406(ra) # 8000612c <acquire>
  ticks++;
    80001bb6:	00007517          	auipc	a0,0x7
    80001bba:	d6250513          	addi	a0,a0,-670 # 80008918 <ticks>
    80001bbe:	411c                	lw	a5,0(a0)
    80001bc0:	2785                	addiw	a5,a5,1
    80001bc2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc4:	00000097          	auipc	ra,0x0
    80001bc8:	998080e7          	jalr	-1640(ra) # 8000155c <wakeup>
  release(&tickslock);
    80001bcc:	8526                	mv	a0,s1
    80001bce:	00004097          	auipc	ra,0x4
    80001bd2:	612080e7          	jalr	1554(ra) # 800061e0 <release>
}
    80001bd6:	60e2                	ld	ra,24(sp)
    80001bd8:	6442                	ld	s0,16(sp)
    80001bda:	64a2                	ld	s1,8(sp)
    80001bdc:	6105                	addi	sp,sp,32
    80001bde:	8082                	ret

0000000080001be0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001be0:	1101                	addi	sp,sp,-32
    80001be2:	ec06                	sd	ra,24(sp)
    80001be4:	e822                	sd	s0,16(sp)
    80001be6:	e426                	sd	s1,8(sp)
    80001be8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bea:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bee:	00074d63          	bltz	a4,80001c08 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bf2:	57fd                	li	a5,-1
    80001bf4:	17fe                	slli	a5,a5,0x3f
    80001bf6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bf8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bfa:	06f70363          	beq	a4,a5,80001c60 <devintr+0x80>
  }
}
    80001bfe:	60e2                	ld	ra,24(sp)
    80001c00:	6442                	ld	s0,16(sp)
    80001c02:	64a2                	ld	s1,8(sp)
    80001c04:	6105                	addi	sp,sp,32
    80001c06:	8082                	ret
     (scause & 0xff) == 9){
    80001c08:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c0c:	46a5                	li	a3,9
    80001c0e:	fed792e3          	bne	a5,a3,80001bf2 <devintr+0x12>
    int irq = plic_claim();
    80001c12:	00003097          	auipc	ra,0x3
    80001c16:	4a6080e7          	jalr	1190(ra) # 800050b8 <plic_claim>
    80001c1a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c1c:	47a9                	li	a5,10
    80001c1e:	02f50763          	beq	a0,a5,80001c4c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c22:	4785                	li	a5,1
    80001c24:	02f50963          	beq	a0,a5,80001c56 <devintr+0x76>
    return 1;
    80001c28:	4505                	li	a0,1
    } else if(irq){
    80001c2a:	d8f1                	beqz	s1,80001bfe <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c2c:	85a6                	mv	a1,s1
    80001c2e:	00006517          	auipc	a0,0x6
    80001c32:	65250513          	addi	a0,a0,1618 # 80008280 <states.1724+0x38>
    80001c36:	00004097          	auipc	ra,0x4
    80001c3a:	ff6080e7          	jalr	-10(ra) # 80005c2c <printf>
      plic_complete(irq);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	00003097          	auipc	ra,0x3
    80001c44:	49c080e7          	jalr	1180(ra) # 800050dc <plic_complete>
    return 1;
    80001c48:	4505                	li	a0,1
    80001c4a:	bf55                	j	80001bfe <devintr+0x1e>
      uartintr();
    80001c4c:	00004097          	auipc	ra,0x4
    80001c50:	400080e7          	jalr	1024(ra) # 8000604c <uartintr>
    80001c54:	b7ed                	j	80001c3e <devintr+0x5e>
      virtio_disk_intr();
    80001c56:	00004097          	auipc	ra,0x4
    80001c5a:	9b0080e7          	jalr	-1616(ra) # 80005606 <virtio_disk_intr>
    80001c5e:	b7c5                	j	80001c3e <devintr+0x5e>
    if(cpuid() == 0){
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	1c8080e7          	jalr	456(ra) # 80000e28 <cpuid>
    80001c68:	c901                	beqz	a0,80001c78 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c6a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c6e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c70:	14479073          	csrw	sip,a5
    return 2;
    80001c74:	4509                	li	a0,2
    80001c76:	b761                	j	80001bfe <devintr+0x1e>
      clockintr();
    80001c78:	00000097          	auipc	ra,0x0
    80001c7c:	f22080e7          	jalr	-222(ra) # 80001b9a <clockintr>
    80001c80:	b7ed                	j	80001c6a <devintr+0x8a>

0000000080001c82 <usertrap>:
{
    80001c82:	1101                	addi	sp,sp,-32
    80001c84:	ec06                	sd	ra,24(sp)
    80001c86:	e822                	sd	s0,16(sp)
    80001c88:	e426                	sd	s1,8(sp)
    80001c8a:	e04a                	sd	s2,0(sp)
    80001c8c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c92:	1007f793          	andi	a5,a5,256
    80001c96:	e3b1                	bnez	a5,80001cda <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c98:	00003797          	auipc	a5,0x3
    80001c9c:	31878793          	addi	a5,a5,792 # 80004fb0 <kernelvec>
    80001ca0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ca4:	fffff097          	auipc	ra,0xfffff
    80001ca8:	1b0080e7          	jalr	432(ra) # 80000e54 <myproc>
    80001cac:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cae:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb0:	14102773          	csrr	a4,sepc
    80001cb4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cba:	47a1                	li	a5,8
    80001cbc:	02f70763          	beq	a4,a5,80001cea <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cc0:	00000097          	auipc	ra,0x0
    80001cc4:	f20080e7          	jalr	-224(ra) # 80001be0 <devintr>
    80001cc8:	892a                	mv	s2,a0
    80001cca:	c151                	beqz	a0,80001d4e <usertrap+0xcc>
  if(killed(p))
    80001ccc:	8526                	mv	a0,s1
    80001cce:	00000097          	auipc	ra,0x0
    80001cd2:	ad2080e7          	jalr	-1326(ra) # 800017a0 <killed>
    80001cd6:	c929                	beqz	a0,80001d28 <usertrap+0xa6>
    80001cd8:	a099                	j	80001d1e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001cda:	00006517          	auipc	a0,0x6
    80001cde:	5c650513          	addi	a0,a0,1478 # 800082a0 <states.1724+0x58>
    80001ce2:	00004097          	auipc	ra,0x4
    80001ce6:	f00080e7          	jalr	-256(ra) # 80005be2 <panic>
    if(killed(p))
    80001cea:	00000097          	auipc	ra,0x0
    80001cee:	ab6080e7          	jalr	-1354(ra) # 800017a0 <killed>
    80001cf2:	e921                	bnez	a0,80001d42 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001cf4:	6cb8                	ld	a4,88(s1)
    80001cf6:	6f1c                	ld	a5,24(a4)
    80001cf8:	0791                	addi	a5,a5,4
    80001cfa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cfc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d00:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d04:	10079073          	csrw	sstatus,a5
    syscall();
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	2d4080e7          	jalr	724(ra) # 80001fdc <syscall>
  if(killed(p))
    80001d10:	8526                	mv	a0,s1
    80001d12:	00000097          	auipc	ra,0x0
    80001d16:	a8e080e7          	jalr	-1394(ra) # 800017a0 <killed>
    80001d1a:	c911                	beqz	a0,80001d2e <usertrap+0xac>
    80001d1c:	4901                	li	s2,0
    exit(-1);
    80001d1e:	557d                	li	a0,-1
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	90c080e7          	jalr	-1780(ra) # 8000162c <exit>
  if(which_dev == 2)
    80001d28:	4789                	li	a5,2
    80001d2a:	04f90f63          	beq	s2,a5,80001d88 <usertrap+0x106>
  usertrapret();
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	dd6080e7          	jalr	-554(ra) # 80001b04 <usertrapret>
}
    80001d36:	60e2                	ld	ra,24(sp)
    80001d38:	6442                	ld	s0,16(sp)
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	6902                	ld	s2,0(sp)
    80001d3e:	6105                	addi	sp,sp,32
    80001d40:	8082                	ret
      exit(-1);
    80001d42:	557d                	li	a0,-1
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	8e8080e7          	jalr	-1816(ra) # 8000162c <exit>
    80001d4c:	b765                	j	80001cf4 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d4e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d52:	5890                	lw	a2,48(s1)
    80001d54:	00006517          	auipc	a0,0x6
    80001d58:	56c50513          	addi	a0,a0,1388 # 800082c0 <states.1724+0x78>
    80001d5c:	00004097          	auipc	ra,0x4
    80001d60:	ed0080e7          	jalr	-304(ra) # 80005c2c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d64:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d68:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d6c:	00006517          	auipc	a0,0x6
    80001d70:	58450513          	addi	a0,a0,1412 # 800082f0 <states.1724+0xa8>
    80001d74:	00004097          	auipc	ra,0x4
    80001d78:	eb8080e7          	jalr	-328(ra) # 80005c2c <printf>
    setkilled(p);
    80001d7c:	8526                	mv	a0,s1
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	9f6080e7          	jalr	-1546(ra) # 80001774 <setkilled>
    80001d86:	b769                	j	80001d10 <usertrap+0x8e>
    yield();
    80001d88:	fffff097          	auipc	ra,0xfffff
    80001d8c:	734080e7          	jalr	1844(ra) # 800014bc <yield>
    80001d90:	bf79                	j	80001d2e <usertrap+0xac>

0000000080001d92 <kerneltrap>:
{
    80001d92:	7179                	addi	sp,sp,-48
    80001d94:	f406                	sd	ra,40(sp)
    80001d96:	f022                	sd	s0,32(sp)
    80001d98:	ec26                	sd	s1,24(sp)
    80001d9a:	e84a                	sd	s2,16(sp)
    80001d9c:	e44e                	sd	s3,8(sp)
    80001d9e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dac:	1004f793          	andi	a5,s1,256
    80001db0:	cb85                	beqz	a5,80001de0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001db6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001db8:	ef85                	bnez	a5,80001df0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dba:	00000097          	auipc	ra,0x0
    80001dbe:	e26080e7          	jalr	-474(ra) # 80001be0 <devintr>
    80001dc2:	cd1d                	beqz	a0,80001e00 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dc4:	4789                	li	a5,2
    80001dc6:	06f50a63          	beq	a0,a5,80001e3a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dca:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dce:	10049073          	csrw	sstatus,s1
}
    80001dd2:	70a2                	ld	ra,40(sp)
    80001dd4:	7402                	ld	s0,32(sp)
    80001dd6:	64e2                	ld	s1,24(sp)
    80001dd8:	6942                	ld	s2,16(sp)
    80001dda:	69a2                	ld	s3,8(sp)
    80001ddc:	6145                	addi	sp,sp,48
    80001dde:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de0:	00006517          	auipc	a0,0x6
    80001de4:	53050513          	addi	a0,a0,1328 # 80008310 <states.1724+0xc8>
    80001de8:	00004097          	auipc	ra,0x4
    80001dec:	dfa080e7          	jalr	-518(ra) # 80005be2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	54850513          	addi	a0,a0,1352 # 80008338 <states.1724+0xf0>
    80001df8:	00004097          	auipc	ra,0x4
    80001dfc:	dea080e7          	jalr	-534(ra) # 80005be2 <panic>
    printf("scause %p\n", scause);
    80001e00:	85ce                	mv	a1,s3
    80001e02:	00006517          	auipc	a0,0x6
    80001e06:	55650513          	addi	a0,a0,1366 # 80008358 <states.1724+0x110>
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	e22080e7          	jalr	-478(ra) # 80005c2c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e12:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e16:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e1a:	00006517          	auipc	a0,0x6
    80001e1e:	54e50513          	addi	a0,a0,1358 # 80008368 <states.1724+0x120>
    80001e22:	00004097          	auipc	ra,0x4
    80001e26:	e0a080e7          	jalr	-502(ra) # 80005c2c <printf>
    panic("kerneltrap");
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	55650513          	addi	a0,a0,1366 # 80008380 <states.1724+0x138>
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	db0080e7          	jalr	-592(ra) # 80005be2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	01a080e7          	jalr	26(ra) # 80000e54 <myproc>
    80001e42:	d541                	beqz	a0,80001dca <kerneltrap+0x38>
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	010080e7          	jalr	16(ra) # 80000e54 <myproc>
    80001e4c:	4d18                	lw	a4,24(a0)
    80001e4e:	4791                	li	a5,4
    80001e50:	f6f71de3          	bne	a4,a5,80001dca <kerneltrap+0x38>
    yield();
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	668080e7          	jalr	1640(ra) # 800014bc <yield>
    80001e5c:	b7bd                	j	80001dca <kerneltrap+0x38>

0000000080001e5e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e5e:	1101                	addi	sp,sp,-32
    80001e60:	ec06                	sd	ra,24(sp)
    80001e62:	e822                	sd	s0,16(sp)
    80001e64:	e426                	sd	s1,8(sp)
    80001e66:	1000                	addi	s0,sp,32
    80001e68:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	fea080e7          	jalr	-22(ra) # 80000e54 <myproc>
  switch (n) {
    80001e72:	4795                	li	a5,5
    80001e74:	0497e163          	bltu	a5,s1,80001eb6 <argraw+0x58>
    80001e78:	048a                	slli	s1,s1,0x2
    80001e7a:	00006717          	auipc	a4,0x6
    80001e7e:	53e70713          	addi	a4,a4,1342 # 800083b8 <states.1724+0x170>
    80001e82:	94ba                	add	s1,s1,a4
    80001e84:	409c                	lw	a5,0(s1)
    80001e86:	97ba                	add	a5,a5,a4
    80001e88:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e8a:	6d3c                	ld	a5,88(a0)
    80001e8c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e8e:	60e2                	ld	ra,24(sp)
    80001e90:	6442                	ld	s0,16(sp)
    80001e92:	64a2                	ld	s1,8(sp)
    80001e94:	6105                	addi	sp,sp,32
    80001e96:	8082                	ret
    return p->trapframe->a1;
    80001e98:	6d3c                	ld	a5,88(a0)
    80001e9a:	7fa8                	ld	a0,120(a5)
    80001e9c:	bfcd                	j	80001e8e <argraw+0x30>
    return p->trapframe->a2;
    80001e9e:	6d3c                	ld	a5,88(a0)
    80001ea0:	63c8                	ld	a0,128(a5)
    80001ea2:	b7f5                	j	80001e8e <argraw+0x30>
    return p->trapframe->a3;
    80001ea4:	6d3c                	ld	a5,88(a0)
    80001ea6:	67c8                	ld	a0,136(a5)
    80001ea8:	b7dd                	j	80001e8e <argraw+0x30>
    return p->trapframe->a4;
    80001eaa:	6d3c                	ld	a5,88(a0)
    80001eac:	6bc8                	ld	a0,144(a5)
    80001eae:	b7c5                	j	80001e8e <argraw+0x30>
    return p->trapframe->a5;
    80001eb0:	6d3c                	ld	a5,88(a0)
    80001eb2:	6fc8                	ld	a0,152(a5)
    80001eb4:	bfe9                	j	80001e8e <argraw+0x30>
  panic("argraw");
    80001eb6:	00006517          	auipc	a0,0x6
    80001eba:	4da50513          	addi	a0,a0,1242 # 80008390 <states.1724+0x148>
    80001ebe:	00004097          	auipc	ra,0x4
    80001ec2:	d24080e7          	jalr	-732(ra) # 80005be2 <panic>

0000000080001ec6 <fetchaddr>:
{
    80001ec6:	1101                	addi	sp,sp,-32
    80001ec8:	ec06                	sd	ra,24(sp)
    80001eca:	e822                	sd	s0,16(sp)
    80001ecc:	e426                	sd	s1,8(sp)
    80001ece:	e04a                	sd	s2,0(sp)
    80001ed0:	1000                	addi	s0,sp,32
    80001ed2:	84aa                	mv	s1,a0
    80001ed4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	f7e080e7          	jalr	-130(ra) # 80000e54 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ede:	653c                	ld	a5,72(a0)
    80001ee0:	02f4f863          	bgeu	s1,a5,80001f10 <fetchaddr+0x4a>
    80001ee4:	00848713          	addi	a4,s1,8
    80001ee8:	02e7e663          	bltu	a5,a4,80001f14 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001eec:	46a1                	li	a3,8
    80001eee:	8626                	mv	a2,s1
    80001ef0:	85ca                	mv	a1,s2
    80001ef2:	6928                	ld	a0,80(a0)
    80001ef4:	fffff097          	auipc	ra,0xfffff
    80001ef8:	cae080e7          	jalr	-850(ra) # 80000ba2 <copyin>
    80001efc:	00a03533          	snez	a0,a0
    80001f00:	40a00533          	neg	a0,a0
}
    80001f04:	60e2                	ld	ra,24(sp)
    80001f06:	6442                	ld	s0,16(sp)
    80001f08:	64a2                	ld	s1,8(sp)
    80001f0a:	6902                	ld	s2,0(sp)
    80001f0c:	6105                	addi	sp,sp,32
    80001f0e:	8082                	ret
    return -1;
    80001f10:	557d                	li	a0,-1
    80001f12:	bfcd                	j	80001f04 <fetchaddr+0x3e>
    80001f14:	557d                	li	a0,-1
    80001f16:	b7fd                	j	80001f04 <fetchaddr+0x3e>

0000000080001f18 <fetchstr>:
{
    80001f18:	7179                	addi	sp,sp,-48
    80001f1a:	f406                	sd	ra,40(sp)
    80001f1c:	f022                	sd	s0,32(sp)
    80001f1e:	ec26                	sd	s1,24(sp)
    80001f20:	e84a                	sd	s2,16(sp)
    80001f22:	e44e                	sd	s3,8(sp)
    80001f24:	1800                	addi	s0,sp,48
    80001f26:	892a                	mv	s2,a0
    80001f28:	84ae                	mv	s1,a1
    80001f2a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	f28080e7          	jalr	-216(ra) # 80000e54 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f34:	86ce                	mv	a3,s3
    80001f36:	864a                	mv	a2,s2
    80001f38:	85a6                	mv	a1,s1
    80001f3a:	6928                	ld	a0,80(a0)
    80001f3c:	fffff097          	auipc	ra,0xfffff
    80001f40:	cf2080e7          	jalr	-782(ra) # 80000c2e <copyinstr>
    80001f44:	00054e63          	bltz	a0,80001f60 <fetchstr+0x48>
  return strlen(buf);
    80001f48:	8526                	mv	a0,s1
    80001f4a:	ffffe097          	auipc	ra,0xffffe
    80001f4e:	3b2080e7          	jalr	946(ra) # 800002fc <strlen>
}
    80001f52:	70a2                	ld	ra,40(sp)
    80001f54:	7402                	ld	s0,32(sp)
    80001f56:	64e2                	ld	s1,24(sp)
    80001f58:	6942                	ld	s2,16(sp)
    80001f5a:	69a2                	ld	s3,8(sp)
    80001f5c:	6145                	addi	sp,sp,48
    80001f5e:	8082                	ret
    return -1;
    80001f60:	557d                	li	a0,-1
    80001f62:	bfc5                	j	80001f52 <fetchstr+0x3a>

0000000080001f64 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f64:	1101                	addi	sp,sp,-32
    80001f66:	ec06                	sd	ra,24(sp)
    80001f68:	e822                	sd	s0,16(sp)
    80001f6a:	e426                	sd	s1,8(sp)
    80001f6c:	1000                	addi	s0,sp,32
    80001f6e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f70:	00000097          	auipc	ra,0x0
    80001f74:	eee080e7          	jalr	-274(ra) # 80001e5e <argraw>
    80001f78:	c088                	sw	a0,0(s1)
}
    80001f7a:	60e2                	ld	ra,24(sp)
    80001f7c:	6442                	ld	s0,16(sp)
    80001f7e:	64a2                	ld	s1,8(sp)
    80001f80:	6105                	addi	sp,sp,32
    80001f82:	8082                	ret

0000000080001f84 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f84:	1101                	addi	sp,sp,-32
    80001f86:	ec06                	sd	ra,24(sp)
    80001f88:	e822                	sd	s0,16(sp)
    80001f8a:	e426                	sd	s1,8(sp)
    80001f8c:	1000                	addi	s0,sp,32
    80001f8e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f90:	00000097          	auipc	ra,0x0
    80001f94:	ece080e7          	jalr	-306(ra) # 80001e5e <argraw>
    80001f98:	e088                	sd	a0,0(s1)
}
    80001f9a:	60e2                	ld	ra,24(sp)
    80001f9c:	6442                	ld	s0,16(sp)
    80001f9e:	64a2                	ld	s1,8(sp)
    80001fa0:	6105                	addi	sp,sp,32
    80001fa2:	8082                	ret

0000000080001fa4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fa4:	7179                	addi	sp,sp,-48
    80001fa6:	f406                	sd	ra,40(sp)
    80001fa8:	f022                	sd	s0,32(sp)
    80001faa:	ec26                	sd	s1,24(sp)
    80001fac:	e84a                	sd	s2,16(sp)
    80001fae:	1800                	addi	s0,sp,48
    80001fb0:	84ae                	mv	s1,a1
    80001fb2:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fb4:	fd840593          	addi	a1,s0,-40
    80001fb8:	00000097          	auipc	ra,0x0
    80001fbc:	fcc080e7          	jalr	-52(ra) # 80001f84 <argaddr>
  return fetchstr(addr, buf, max);
    80001fc0:	864a                	mv	a2,s2
    80001fc2:	85a6                	mv	a1,s1
    80001fc4:	fd843503          	ld	a0,-40(s0)
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	f50080e7          	jalr	-176(ra) # 80001f18 <fetchstr>
}
    80001fd0:	70a2                	ld	ra,40(sp)
    80001fd2:	7402                	ld	s0,32(sp)
    80001fd4:	64e2                	ld	s1,24(sp)
    80001fd6:	6942                	ld	s2,16(sp)
    80001fd8:	6145                	addi	sp,sp,48
    80001fda:	8082                	ret

0000000080001fdc <syscall>:



void
syscall(void)
{
    80001fdc:	1101                	addi	sp,sp,-32
    80001fde:	ec06                	sd	ra,24(sp)
    80001fe0:	e822                	sd	s0,16(sp)
    80001fe2:	e426                	sd	s1,8(sp)
    80001fe4:	e04a                	sd	s2,0(sp)
    80001fe6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fe8:	fffff097          	auipc	ra,0xfffff
    80001fec:	e6c080e7          	jalr	-404(ra) # 80000e54 <myproc>
    80001ff0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ff2:	05853903          	ld	s2,88(a0)
    80001ff6:	0a893783          	ld	a5,168(s2)
    80001ffa:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001ffe:	37fd                	addiw	a5,a5,-1
    80002000:	4775                	li	a4,29
    80002002:	00f76f63          	bltu	a4,a5,80002020 <syscall+0x44>
    80002006:	00369713          	slli	a4,a3,0x3
    8000200a:	00006797          	auipc	a5,0x6
    8000200e:	3c678793          	addi	a5,a5,966 # 800083d0 <syscalls>
    80002012:	97ba                	add	a5,a5,a4
    80002014:	639c                	ld	a5,0(a5)
    80002016:	c789                	beqz	a5,80002020 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002018:	9782                	jalr	a5
    8000201a:	06a93823          	sd	a0,112(s2)
    8000201e:	a839                	j	8000203c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002020:	15848613          	addi	a2,s1,344
    80002024:	588c                	lw	a1,48(s1)
    80002026:	00006517          	auipc	a0,0x6
    8000202a:	37250513          	addi	a0,a0,882 # 80008398 <states.1724+0x150>
    8000202e:	00004097          	auipc	ra,0x4
    80002032:	bfe080e7          	jalr	-1026(ra) # 80005c2c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002036:	6cbc                	ld	a5,88(s1)
    80002038:	577d                	li	a4,-1
    8000203a:	fbb8                	sd	a4,112(a5)
  }
}
    8000203c:	60e2                	ld	ra,24(sp)
    8000203e:	6442                	ld	s0,16(sp)
    80002040:	64a2                	ld	s1,8(sp)
    80002042:	6902                	ld	s2,0(sp)
    80002044:	6105                	addi	sp,sp,32
    80002046:	8082                	ret

0000000080002048 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002048:	1101                	addi	sp,sp,-32
    8000204a:	ec06                	sd	ra,24(sp)
    8000204c:	e822                	sd	s0,16(sp)
    8000204e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002050:	fec40593          	addi	a1,s0,-20
    80002054:	4501                	li	a0,0
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	f0e080e7          	jalr	-242(ra) # 80001f64 <argint>
  exit(n);
    8000205e:	fec42503          	lw	a0,-20(s0)
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	5ca080e7          	jalr	1482(ra) # 8000162c <exit>
  return 0;  // not reached
}
    8000206a:	4501                	li	a0,0
    8000206c:	60e2                	ld	ra,24(sp)
    8000206e:	6442                	ld	s0,16(sp)
    80002070:	6105                	addi	sp,sp,32
    80002072:	8082                	ret

0000000080002074 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002074:	1141                	addi	sp,sp,-16
    80002076:	e406                	sd	ra,8(sp)
    80002078:	e022                	sd	s0,0(sp)
    8000207a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	dd8080e7          	jalr	-552(ra) # 80000e54 <myproc>
}
    80002084:	5908                	lw	a0,48(a0)
    80002086:	60a2                	ld	ra,8(sp)
    80002088:	6402                	ld	s0,0(sp)
    8000208a:	0141                	addi	sp,sp,16
    8000208c:	8082                	ret

000000008000208e <sys_fork>:

uint64
sys_fork(void)
{
    8000208e:	1141                	addi	sp,sp,-16
    80002090:	e406                	sd	ra,8(sp)
    80002092:	e022                	sd	s0,0(sp)
    80002094:	0800                	addi	s0,sp,16
  return fork();
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	174080e7          	jalr	372(ra) # 8000120a <fork>
}
    8000209e:	60a2                	ld	ra,8(sp)
    800020a0:	6402                	ld	s0,0(sp)
    800020a2:	0141                	addi	sp,sp,16
    800020a4:	8082                	ret

00000000800020a6 <sys_wait>:

uint64
sys_wait(void)
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020ae:	fe840593          	addi	a1,s0,-24
    800020b2:	4501                	li	a0,0
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	ed0080e7          	jalr	-304(ra) # 80001f84 <argaddr>
  return wait(p);
    800020bc:	fe843503          	ld	a0,-24(s0)
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	712080e7          	jalr	1810(ra) # 800017d2 <wait>
}
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	6105                	addi	sp,sp,32
    800020ce:	8082                	ret

00000000800020d0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d0:	7179                	addi	sp,sp,-48
    800020d2:	f406                	sd	ra,40(sp)
    800020d4:	f022                	sd	s0,32(sp)
    800020d6:	ec26                	sd	s1,24(sp)
    800020d8:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020da:	fdc40593          	addi	a1,s0,-36
    800020de:	4501                	li	a0,0
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	e84080e7          	jalr	-380(ra) # 80001f64 <argint>
  addr = myproc()->sz;
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	d6c080e7          	jalr	-660(ra) # 80000e54 <myproc>
    800020f0:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020f2:	fdc42503          	lw	a0,-36(s0)
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	0b8080e7          	jalr	184(ra) # 800011ae <growproc>
    800020fe:	00054863          	bltz	a0,8000210e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002102:	8526                	mv	a0,s1
    80002104:	70a2                	ld	ra,40(sp)
    80002106:	7402                	ld	s0,32(sp)
    80002108:	64e2                	ld	s1,24(sp)
    8000210a:	6145                	addi	sp,sp,48
    8000210c:	8082                	ret
    return -1;
    8000210e:	54fd                	li	s1,-1
    80002110:	bfcd                	j	80002102 <sys_sbrk+0x32>

0000000080002112 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002112:	7139                	addi	sp,sp,-64
    80002114:	fc06                	sd	ra,56(sp)
    80002116:	f822                	sd	s0,48(sp)
    80002118:	f426                	sd	s1,40(sp)
    8000211a:	f04a                	sd	s2,32(sp)
    8000211c:	ec4e                	sd	s3,24(sp)
    8000211e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    80002120:	fcc40593          	addi	a1,s0,-52
    80002124:	4501                	li	a0,0
    80002126:	00000097          	auipc	ra,0x0
    8000212a:	e3e080e7          	jalr	-450(ra) # 80001f64 <argint>
  acquire(&tickslock);
    8000212e:	0000c517          	auipc	a0,0xc
    80002132:	65250513          	addi	a0,a0,1618 # 8000e780 <tickslock>
    80002136:	00004097          	auipc	ra,0x4
    8000213a:	ff6080e7          	jalr	-10(ra) # 8000612c <acquire>
  ticks0 = ticks;
    8000213e:	00006917          	auipc	s2,0x6
    80002142:	7da92903          	lw	s2,2010(s2) # 80008918 <ticks>
  while(ticks - ticks0 < n){
    80002146:	fcc42783          	lw	a5,-52(s0)
    8000214a:	cf9d                	beqz	a5,80002188 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000214c:	0000c997          	auipc	s3,0xc
    80002150:	63498993          	addi	s3,s3,1588 # 8000e780 <tickslock>
    80002154:	00006497          	auipc	s1,0x6
    80002158:	7c448493          	addi	s1,s1,1988 # 80008918 <ticks>
    if(killed(myproc())){
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	cf8080e7          	jalr	-776(ra) # 80000e54 <myproc>
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	63c080e7          	jalr	1596(ra) # 800017a0 <killed>
    8000216c:	ed15                	bnez	a0,800021a8 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000216e:	85ce                	mv	a1,s3
    80002170:	8526                	mv	a0,s1
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	386080e7          	jalr	902(ra) # 800014f8 <sleep>
  while(ticks - ticks0 < n){
    8000217a:	409c                	lw	a5,0(s1)
    8000217c:	412787bb          	subw	a5,a5,s2
    80002180:	fcc42703          	lw	a4,-52(s0)
    80002184:	fce7ece3          	bltu	a5,a4,8000215c <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002188:	0000c517          	auipc	a0,0xc
    8000218c:	5f850513          	addi	a0,a0,1528 # 8000e780 <tickslock>
    80002190:	00004097          	auipc	ra,0x4
    80002194:	050080e7          	jalr	80(ra) # 800061e0 <release>
  return 0;
    80002198:	4501                	li	a0,0
}
    8000219a:	70e2                	ld	ra,56(sp)
    8000219c:	7442                	ld	s0,48(sp)
    8000219e:	74a2                	ld	s1,40(sp)
    800021a0:	7902                	ld	s2,32(sp)
    800021a2:	69e2                	ld	s3,24(sp)
    800021a4:	6121                	addi	sp,sp,64
    800021a6:	8082                	ret
      release(&tickslock);
    800021a8:	0000c517          	auipc	a0,0xc
    800021ac:	5d850513          	addi	a0,a0,1496 # 8000e780 <tickslock>
    800021b0:	00004097          	auipc	ra,0x4
    800021b4:	030080e7          	jalr	48(ra) # 800061e0 <release>
      return -1;
    800021b8:	557d                	li	a0,-1
    800021ba:	b7c5                	j	8000219a <sys_sleep+0x88>

00000000800021bc <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    800021bc:	1141                	addi	sp,sp,-16
    800021be:	e422                	sd	s0,8(sp)
    800021c0:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    800021c2:	4501                	li	a0,0
    800021c4:	6422                	ld	s0,8(sp)
    800021c6:	0141                	addi	sp,sp,16
    800021c8:	8082                	ret

00000000800021ca <sys_kill>:
#endif

uint64
sys_kill(void)
{
    800021ca:	1101                	addi	sp,sp,-32
    800021cc:	ec06                	sd	ra,24(sp)
    800021ce:	e822                	sd	s0,16(sp)
    800021d0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021d2:	fec40593          	addi	a1,s0,-20
    800021d6:	4501                	li	a0,0
    800021d8:	00000097          	auipc	ra,0x0
    800021dc:	d8c080e7          	jalr	-628(ra) # 80001f64 <argint>
  return kill(pid);
    800021e0:	fec42503          	lw	a0,-20(s0)
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	51e080e7          	jalr	1310(ra) # 80001702 <kill>
}
    800021ec:	60e2                	ld	ra,24(sp)
    800021ee:	6442                	ld	s0,16(sp)
    800021f0:	6105                	addi	sp,sp,32
    800021f2:	8082                	ret

00000000800021f4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021f4:	1101                	addi	sp,sp,-32
    800021f6:	ec06                	sd	ra,24(sp)
    800021f8:	e822                	sd	s0,16(sp)
    800021fa:	e426                	sd	s1,8(sp)
    800021fc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021fe:	0000c517          	auipc	a0,0xc
    80002202:	58250513          	addi	a0,a0,1410 # 8000e780 <tickslock>
    80002206:	00004097          	auipc	ra,0x4
    8000220a:	f26080e7          	jalr	-218(ra) # 8000612c <acquire>
  xticks = ticks;
    8000220e:	00006497          	auipc	s1,0x6
    80002212:	70a4a483          	lw	s1,1802(s1) # 80008918 <ticks>
  release(&tickslock);
    80002216:	0000c517          	auipc	a0,0xc
    8000221a:	56a50513          	addi	a0,a0,1386 # 8000e780 <tickslock>
    8000221e:	00004097          	auipc	ra,0x4
    80002222:	fc2080e7          	jalr	-62(ra) # 800061e0 <release>
  return xticks;
}
    80002226:	02049513          	slli	a0,s1,0x20
    8000222a:	9101                	srli	a0,a0,0x20
    8000222c:	60e2                	ld	ra,24(sp)
    8000222e:	6442                	ld	s0,16(sp)
    80002230:	64a2                	ld	s1,8(sp)
    80002232:	6105                	addi	sp,sp,32
    80002234:	8082                	ret

0000000080002236 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002236:	7179                	addi	sp,sp,-48
    80002238:	f406                	sd	ra,40(sp)
    8000223a:	f022                	sd	s0,32(sp)
    8000223c:	ec26                	sd	s1,24(sp)
    8000223e:	e84a                	sd	s2,16(sp)
    80002240:	e44e                	sd	s3,8(sp)
    80002242:	e052                	sd	s4,0(sp)
    80002244:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002246:	00006597          	auipc	a1,0x6
    8000224a:	28258593          	addi	a1,a1,642 # 800084c8 <syscalls+0xf8>
    8000224e:	0000c517          	auipc	a0,0xc
    80002252:	54a50513          	addi	a0,a0,1354 # 8000e798 <bcache>
    80002256:	00004097          	auipc	ra,0x4
    8000225a:	e46080e7          	jalr	-442(ra) # 8000609c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000225e:	00014797          	auipc	a5,0x14
    80002262:	53a78793          	addi	a5,a5,1338 # 80016798 <bcache+0x8000>
    80002266:	00014717          	auipc	a4,0x14
    8000226a:	79a70713          	addi	a4,a4,1946 # 80016a00 <bcache+0x8268>
    8000226e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002272:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002276:	0000c497          	auipc	s1,0xc
    8000227a:	53a48493          	addi	s1,s1,1338 # 8000e7b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000227e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002280:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002282:	00006a17          	auipc	s4,0x6
    80002286:	24ea0a13          	addi	s4,s4,590 # 800084d0 <syscalls+0x100>
    b->next = bcache.head.next;
    8000228a:	2b893783          	ld	a5,696(s2)
    8000228e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002290:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002294:	85d2                	mv	a1,s4
    80002296:	01048513          	addi	a0,s1,16
    8000229a:	00001097          	auipc	ra,0x1
    8000229e:	4c4080e7          	jalr	1220(ra) # 8000375e <initsleeplock>
    bcache.head.next->prev = b;
    800022a2:	2b893783          	ld	a5,696(s2)
    800022a6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022a8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022ac:	45848493          	addi	s1,s1,1112
    800022b0:	fd349de3          	bne	s1,s3,8000228a <binit+0x54>
  }
}
    800022b4:	70a2                	ld	ra,40(sp)
    800022b6:	7402                	ld	s0,32(sp)
    800022b8:	64e2                	ld	s1,24(sp)
    800022ba:	6942                	ld	s2,16(sp)
    800022bc:	69a2                	ld	s3,8(sp)
    800022be:	6a02                	ld	s4,0(sp)
    800022c0:	6145                	addi	sp,sp,48
    800022c2:	8082                	ret

00000000800022c4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022c4:	7179                	addi	sp,sp,-48
    800022c6:	f406                	sd	ra,40(sp)
    800022c8:	f022                	sd	s0,32(sp)
    800022ca:	ec26                	sd	s1,24(sp)
    800022cc:	e84a                	sd	s2,16(sp)
    800022ce:	e44e                	sd	s3,8(sp)
    800022d0:	1800                	addi	s0,sp,48
    800022d2:	89aa                	mv	s3,a0
    800022d4:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800022d6:	0000c517          	auipc	a0,0xc
    800022da:	4c250513          	addi	a0,a0,1218 # 8000e798 <bcache>
    800022de:	00004097          	auipc	ra,0x4
    800022e2:	e4e080e7          	jalr	-434(ra) # 8000612c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022e6:	00014497          	auipc	s1,0x14
    800022ea:	76a4b483          	ld	s1,1898(s1) # 80016a50 <bcache+0x82b8>
    800022ee:	00014797          	auipc	a5,0x14
    800022f2:	71278793          	addi	a5,a5,1810 # 80016a00 <bcache+0x8268>
    800022f6:	02f48f63          	beq	s1,a5,80002334 <bread+0x70>
    800022fa:	873e                	mv	a4,a5
    800022fc:	a021                	j	80002304 <bread+0x40>
    800022fe:	68a4                	ld	s1,80(s1)
    80002300:	02e48a63          	beq	s1,a4,80002334 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002304:	449c                	lw	a5,8(s1)
    80002306:	ff379ce3          	bne	a5,s3,800022fe <bread+0x3a>
    8000230a:	44dc                	lw	a5,12(s1)
    8000230c:	ff2799e3          	bne	a5,s2,800022fe <bread+0x3a>
      b->refcnt++;
    80002310:	40bc                	lw	a5,64(s1)
    80002312:	2785                	addiw	a5,a5,1
    80002314:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002316:	0000c517          	auipc	a0,0xc
    8000231a:	48250513          	addi	a0,a0,1154 # 8000e798 <bcache>
    8000231e:	00004097          	auipc	ra,0x4
    80002322:	ec2080e7          	jalr	-318(ra) # 800061e0 <release>
      acquiresleep(&b->lock);
    80002326:	01048513          	addi	a0,s1,16
    8000232a:	00001097          	auipc	ra,0x1
    8000232e:	46e080e7          	jalr	1134(ra) # 80003798 <acquiresleep>
      return b;
    80002332:	a8b9                	j	80002390 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002334:	00014497          	auipc	s1,0x14
    80002338:	7144b483          	ld	s1,1812(s1) # 80016a48 <bcache+0x82b0>
    8000233c:	00014797          	auipc	a5,0x14
    80002340:	6c478793          	addi	a5,a5,1732 # 80016a00 <bcache+0x8268>
    80002344:	00f48863          	beq	s1,a5,80002354 <bread+0x90>
    80002348:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000234a:	40bc                	lw	a5,64(s1)
    8000234c:	cf81                	beqz	a5,80002364 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000234e:	64a4                	ld	s1,72(s1)
    80002350:	fee49de3          	bne	s1,a4,8000234a <bread+0x86>
  panic("bget: no buffers");
    80002354:	00006517          	auipc	a0,0x6
    80002358:	18450513          	addi	a0,a0,388 # 800084d8 <syscalls+0x108>
    8000235c:	00004097          	auipc	ra,0x4
    80002360:	886080e7          	jalr	-1914(ra) # 80005be2 <panic>
      b->dev = dev;
    80002364:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002368:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000236c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002370:	4785                	li	a5,1
    80002372:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002374:	0000c517          	auipc	a0,0xc
    80002378:	42450513          	addi	a0,a0,1060 # 8000e798 <bcache>
    8000237c:	00004097          	auipc	ra,0x4
    80002380:	e64080e7          	jalr	-412(ra) # 800061e0 <release>
      acquiresleep(&b->lock);
    80002384:	01048513          	addi	a0,s1,16
    80002388:	00001097          	auipc	ra,0x1
    8000238c:	410080e7          	jalr	1040(ra) # 80003798 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002390:	409c                	lw	a5,0(s1)
    80002392:	cb89                	beqz	a5,800023a4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002394:	8526                	mv	a0,s1
    80002396:	70a2                	ld	ra,40(sp)
    80002398:	7402                	ld	s0,32(sp)
    8000239a:	64e2                	ld	s1,24(sp)
    8000239c:	6942                	ld	s2,16(sp)
    8000239e:	69a2                	ld	s3,8(sp)
    800023a0:	6145                	addi	sp,sp,48
    800023a2:	8082                	ret
    virtio_disk_rw(b, 0);
    800023a4:	4581                	li	a1,0
    800023a6:	8526                	mv	a0,s1
    800023a8:	00003097          	auipc	ra,0x3
    800023ac:	fd0080e7          	jalr	-48(ra) # 80005378 <virtio_disk_rw>
    b->valid = 1;
    800023b0:	4785                	li	a5,1
    800023b2:	c09c                	sw	a5,0(s1)
  return b;
    800023b4:	b7c5                	j	80002394 <bread+0xd0>

00000000800023b6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023b6:	1101                	addi	sp,sp,-32
    800023b8:	ec06                	sd	ra,24(sp)
    800023ba:	e822                	sd	s0,16(sp)
    800023bc:	e426                	sd	s1,8(sp)
    800023be:	1000                	addi	s0,sp,32
    800023c0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023c2:	0541                	addi	a0,a0,16
    800023c4:	00001097          	auipc	ra,0x1
    800023c8:	46e080e7          	jalr	1134(ra) # 80003832 <holdingsleep>
    800023cc:	cd01                	beqz	a0,800023e4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023ce:	4585                	li	a1,1
    800023d0:	8526                	mv	a0,s1
    800023d2:	00003097          	auipc	ra,0x3
    800023d6:	fa6080e7          	jalr	-90(ra) # 80005378 <virtio_disk_rw>
}
    800023da:	60e2                	ld	ra,24(sp)
    800023dc:	6442                	ld	s0,16(sp)
    800023de:	64a2                	ld	s1,8(sp)
    800023e0:	6105                	addi	sp,sp,32
    800023e2:	8082                	ret
    panic("bwrite");
    800023e4:	00006517          	auipc	a0,0x6
    800023e8:	10c50513          	addi	a0,a0,268 # 800084f0 <syscalls+0x120>
    800023ec:	00003097          	auipc	ra,0x3
    800023f0:	7f6080e7          	jalr	2038(ra) # 80005be2 <panic>

00000000800023f4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023f4:	1101                	addi	sp,sp,-32
    800023f6:	ec06                	sd	ra,24(sp)
    800023f8:	e822                	sd	s0,16(sp)
    800023fa:	e426                	sd	s1,8(sp)
    800023fc:	e04a                	sd	s2,0(sp)
    800023fe:	1000                	addi	s0,sp,32
    80002400:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002402:	01050913          	addi	s2,a0,16
    80002406:	854a                	mv	a0,s2
    80002408:	00001097          	auipc	ra,0x1
    8000240c:	42a080e7          	jalr	1066(ra) # 80003832 <holdingsleep>
    80002410:	c92d                	beqz	a0,80002482 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002412:	854a                	mv	a0,s2
    80002414:	00001097          	auipc	ra,0x1
    80002418:	3da080e7          	jalr	986(ra) # 800037ee <releasesleep>

  acquire(&bcache.lock);
    8000241c:	0000c517          	auipc	a0,0xc
    80002420:	37c50513          	addi	a0,a0,892 # 8000e798 <bcache>
    80002424:	00004097          	auipc	ra,0x4
    80002428:	d08080e7          	jalr	-760(ra) # 8000612c <acquire>
  b->refcnt--;
    8000242c:	40bc                	lw	a5,64(s1)
    8000242e:	37fd                	addiw	a5,a5,-1
    80002430:	0007871b          	sext.w	a4,a5
    80002434:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002436:	eb05                	bnez	a4,80002466 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002438:	68bc                	ld	a5,80(s1)
    8000243a:	64b8                	ld	a4,72(s1)
    8000243c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000243e:	64bc                	ld	a5,72(s1)
    80002440:	68b8                	ld	a4,80(s1)
    80002442:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002444:	00014797          	auipc	a5,0x14
    80002448:	35478793          	addi	a5,a5,852 # 80016798 <bcache+0x8000>
    8000244c:	2b87b703          	ld	a4,696(a5)
    80002450:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002452:	00014717          	auipc	a4,0x14
    80002456:	5ae70713          	addi	a4,a4,1454 # 80016a00 <bcache+0x8268>
    8000245a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000245c:	2b87b703          	ld	a4,696(a5)
    80002460:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002462:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002466:	0000c517          	auipc	a0,0xc
    8000246a:	33250513          	addi	a0,a0,818 # 8000e798 <bcache>
    8000246e:	00004097          	auipc	ra,0x4
    80002472:	d72080e7          	jalr	-654(ra) # 800061e0 <release>
}
    80002476:	60e2                	ld	ra,24(sp)
    80002478:	6442                	ld	s0,16(sp)
    8000247a:	64a2                	ld	s1,8(sp)
    8000247c:	6902                	ld	s2,0(sp)
    8000247e:	6105                	addi	sp,sp,32
    80002480:	8082                	ret
    panic("brelse");
    80002482:	00006517          	auipc	a0,0x6
    80002486:	07650513          	addi	a0,a0,118 # 800084f8 <syscalls+0x128>
    8000248a:	00003097          	auipc	ra,0x3
    8000248e:	758080e7          	jalr	1880(ra) # 80005be2 <panic>

0000000080002492 <bpin>:

void
bpin(struct buf *b) {
    80002492:	1101                	addi	sp,sp,-32
    80002494:	ec06                	sd	ra,24(sp)
    80002496:	e822                	sd	s0,16(sp)
    80002498:	e426                	sd	s1,8(sp)
    8000249a:	1000                	addi	s0,sp,32
    8000249c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000249e:	0000c517          	auipc	a0,0xc
    800024a2:	2fa50513          	addi	a0,a0,762 # 8000e798 <bcache>
    800024a6:	00004097          	auipc	ra,0x4
    800024aa:	c86080e7          	jalr	-890(ra) # 8000612c <acquire>
  b->refcnt++;
    800024ae:	40bc                	lw	a5,64(s1)
    800024b0:	2785                	addiw	a5,a5,1
    800024b2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024b4:	0000c517          	auipc	a0,0xc
    800024b8:	2e450513          	addi	a0,a0,740 # 8000e798 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	d24080e7          	jalr	-732(ra) # 800061e0 <release>
}
    800024c4:	60e2                	ld	ra,24(sp)
    800024c6:	6442                	ld	s0,16(sp)
    800024c8:	64a2                	ld	s1,8(sp)
    800024ca:	6105                	addi	sp,sp,32
    800024cc:	8082                	ret

00000000800024ce <bunpin>:

void
bunpin(struct buf *b) {
    800024ce:	1101                	addi	sp,sp,-32
    800024d0:	ec06                	sd	ra,24(sp)
    800024d2:	e822                	sd	s0,16(sp)
    800024d4:	e426                	sd	s1,8(sp)
    800024d6:	1000                	addi	s0,sp,32
    800024d8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024da:	0000c517          	auipc	a0,0xc
    800024de:	2be50513          	addi	a0,a0,702 # 8000e798 <bcache>
    800024e2:	00004097          	auipc	ra,0x4
    800024e6:	c4a080e7          	jalr	-950(ra) # 8000612c <acquire>
  b->refcnt--;
    800024ea:	40bc                	lw	a5,64(s1)
    800024ec:	37fd                	addiw	a5,a5,-1
    800024ee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024f0:	0000c517          	auipc	a0,0xc
    800024f4:	2a850513          	addi	a0,a0,680 # 8000e798 <bcache>
    800024f8:	00004097          	auipc	ra,0x4
    800024fc:	ce8080e7          	jalr	-792(ra) # 800061e0 <release>
}
    80002500:	60e2                	ld	ra,24(sp)
    80002502:	6442                	ld	s0,16(sp)
    80002504:	64a2                	ld	s1,8(sp)
    80002506:	6105                	addi	sp,sp,32
    80002508:	8082                	ret

000000008000250a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000250a:	1101                	addi	sp,sp,-32
    8000250c:	ec06                	sd	ra,24(sp)
    8000250e:	e822                	sd	s0,16(sp)
    80002510:	e426                	sd	s1,8(sp)
    80002512:	e04a                	sd	s2,0(sp)
    80002514:	1000                	addi	s0,sp,32
    80002516:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002518:	00d5d59b          	srliw	a1,a1,0xd
    8000251c:	00015797          	auipc	a5,0x15
    80002520:	9587a783          	lw	a5,-1704(a5) # 80016e74 <sb+0x1c>
    80002524:	9dbd                	addw	a1,a1,a5
    80002526:	00000097          	auipc	ra,0x0
    8000252a:	d9e080e7          	jalr	-610(ra) # 800022c4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000252e:	0074f713          	andi	a4,s1,7
    80002532:	4785                	li	a5,1
    80002534:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002538:	14ce                	slli	s1,s1,0x33
    8000253a:	90d9                	srli	s1,s1,0x36
    8000253c:	00950733          	add	a4,a0,s1
    80002540:	05874703          	lbu	a4,88(a4)
    80002544:	00e7f6b3          	and	a3,a5,a4
    80002548:	c69d                	beqz	a3,80002576 <bfree+0x6c>
    8000254a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000254c:	94aa                	add	s1,s1,a0
    8000254e:	fff7c793          	not	a5,a5
    80002552:	8ff9                	and	a5,a5,a4
    80002554:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002558:	00001097          	auipc	ra,0x1
    8000255c:	120080e7          	jalr	288(ra) # 80003678 <log_write>
  brelse(bp);
    80002560:	854a                	mv	a0,s2
    80002562:	00000097          	auipc	ra,0x0
    80002566:	e92080e7          	jalr	-366(ra) # 800023f4 <brelse>
}
    8000256a:	60e2                	ld	ra,24(sp)
    8000256c:	6442                	ld	s0,16(sp)
    8000256e:	64a2                	ld	s1,8(sp)
    80002570:	6902                	ld	s2,0(sp)
    80002572:	6105                	addi	sp,sp,32
    80002574:	8082                	ret
    panic("freeing free block");
    80002576:	00006517          	auipc	a0,0x6
    8000257a:	f8a50513          	addi	a0,a0,-118 # 80008500 <syscalls+0x130>
    8000257e:	00003097          	auipc	ra,0x3
    80002582:	664080e7          	jalr	1636(ra) # 80005be2 <panic>

0000000080002586 <balloc>:
{
    80002586:	711d                	addi	sp,sp,-96
    80002588:	ec86                	sd	ra,88(sp)
    8000258a:	e8a2                	sd	s0,80(sp)
    8000258c:	e4a6                	sd	s1,72(sp)
    8000258e:	e0ca                	sd	s2,64(sp)
    80002590:	fc4e                	sd	s3,56(sp)
    80002592:	f852                	sd	s4,48(sp)
    80002594:	f456                	sd	s5,40(sp)
    80002596:	f05a                	sd	s6,32(sp)
    80002598:	ec5e                	sd	s7,24(sp)
    8000259a:	e862                	sd	s8,16(sp)
    8000259c:	e466                	sd	s9,8(sp)
    8000259e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025a0:	00015797          	auipc	a5,0x15
    800025a4:	8bc7a783          	lw	a5,-1860(a5) # 80016e5c <sb+0x4>
    800025a8:	10078163          	beqz	a5,800026aa <balloc+0x124>
    800025ac:	8baa                	mv	s7,a0
    800025ae:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025b0:	00015b17          	auipc	s6,0x15
    800025b4:	8a8b0b13          	addi	s6,s6,-1880 # 80016e58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025b8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025ba:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025bc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025be:	6c89                	lui	s9,0x2
    800025c0:	a061                	j	80002648 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025c2:	974a                	add	a4,a4,s2
    800025c4:	8fd5                	or	a5,a5,a3
    800025c6:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025ca:	854a                	mv	a0,s2
    800025cc:	00001097          	auipc	ra,0x1
    800025d0:	0ac080e7          	jalr	172(ra) # 80003678 <log_write>
        brelse(bp);
    800025d4:	854a                	mv	a0,s2
    800025d6:	00000097          	auipc	ra,0x0
    800025da:	e1e080e7          	jalr	-482(ra) # 800023f4 <brelse>
  bp = bread(dev, bno);
    800025de:	85a6                	mv	a1,s1
    800025e0:	855e                	mv	a0,s7
    800025e2:	00000097          	auipc	ra,0x0
    800025e6:	ce2080e7          	jalr	-798(ra) # 800022c4 <bread>
    800025ea:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025ec:	40000613          	li	a2,1024
    800025f0:	4581                	li	a1,0
    800025f2:	05850513          	addi	a0,a0,88
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	b82080e7          	jalr	-1150(ra) # 80000178 <memset>
  log_write(bp);
    800025fe:	854a                	mv	a0,s2
    80002600:	00001097          	auipc	ra,0x1
    80002604:	078080e7          	jalr	120(ra) # 80003678 <log_write>
  brelse(bp);
    80002608:	854a                	mv	a0,s2
    8000260a:	00000097          	auipc	ra,0x0
    8000260e:	dea080e7          	jalr	-534(ra) # 800023f4 <brelse>
}
    80002612:	8526                	mv	a0,s1
    80002614:	60e6                	ld	ra,88(sp)
    80002616:	6446                	ld	s0,80(sp)
    80002618:	64a6                	ld	s1,72(sp)
    8000261a:	6906                	ld	s2,64(sp)
    8000261c:	79e2                	ld	s3,56(sp)
    8000261e:	7a42                	ld	s4,48(sp)
    80002620:	7aa2                	ld	s5,40(sp)
    80002622:	7b02                	ld	s6,32(sp)
    80002624:	6be2                	ld	s7,24(sp)
    80002626:	6c42                	ld	s8,16(sp)
    80002628:	6ca2                	ld	s9,8(sp)
    8000262a:	6125                	addi	sp,sp,96
    8000262c:	8082                	ret
    brelse(bp);
    8000262e:	854a                	mv	a0,s2
    80002630:	00000097          	auipc	ra,0x0
    80002634:	dc4080e7          	jalr	-572(ra) # 800023f4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002638:	015c87bb          	addw	a5,s9,s5
    8000263c:	00078a9b          	sext.w	s5,a5
    80002640:	004b2703          	lw	a4,4(s6)
    80002644:	06eaf363          	bgeu	s5,a4,800026aa <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002648:	41fad79b          	sraiw	a5,s5,0x1f
    8000264c:	0137d79b          	srliw	a5,a5,0x13
    80002650:	015787bb          	addw	a5,a5,s5
    80002654:	40d7d79b          	sraiw	a5,a5,0xd
    80002658:	01cb2583          	lw	a1,28(s6)
    8000265c:	9dbd                	addw	a1,a1,a5
    8000265e:	855e                	mv	a0,s7
    80002660:	00000097          	auipc	ra,0x0
    80002664:	c64080e7          	jalr	-924(ra) # 800022c4 <bread>
    80002668:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000266a:	004b2503          	lw	a0,4(s6)
    8000266e:	000a849b          	sext.w	s1,s5
    80002672:	8662                	mv	a2,s8
    80002674:	faa4fde3          	bgeu	s1,a0,8000262e <balloc+0xa8>
      m = 1 << (bi % 8);
    80002678:	41f6579b          	sraiw	a5,a2,0x1f
    8000267c:	01d7d69b          	srliw	a3,a5,0x1d
    80002680:	00c6873b          	addw	a4,a3,a2
    80002684:	00777793          	andi	a5,a4,7
    80002688:	9f95                	subw	a5,a5,a3
    8000268a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000268e:	4037571b          	sraiw	a4,a4,0x3
    80002692:	00e906b3          	add	a3,s2,a4
    80002696:	0586c683          	lbu	a3,88(a3)
    8000269a:	00d7f5b3          	and	a1,a5,a3
    8000269e:	d195                	beqz	a1,800025c2 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a0:	2605                	addiw	a2,a2,1
    800026a2:	2485                	addiw	s1,s1,1
    800026a4:	fd4618e3          	bne	a2,s4,80002674 <balloc+0xee>
    800026a8:	b759                	j	8000262e <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800026aa:	00006517          	auipc	a0,0x6
    800026ae:	e6e50513          	addi	a0,a0,-402 # 80008518 <syscalls+0x148>
    800026b2:	00003097          	auipc	ra,0x3
    800026b6:	57a080e7          	jalr	1402(ra) # 80005c2c <printf>
  return 0;
    800026ba:	4481                	li	s1,0
    800026bc:	bf99                	j	80002612 <balloc+0x8c>

00000000800026be <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026be:	7179                	addi	sp,sp,-48
    800026c0:	f406                	sd	ra,40(sp)
    800026c2:	f022                	sd	s0,32(sp)
    800026c4:	ec26                	sd	s1,24(sp)
    800026c6:	e84a                	sd	s2,16(sp)
    800026c8:	e44e                	sd	s3,8(sp)
    800026ca:	e052                	sd	s4,0(sp)
    800026cc:	1800                	addi	s0,sp,48
    800026ce:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026d0:	47ad                	li	a5,11
    800026d2:	02b7e763          	bltu	a5,a1,80002700 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800026d6:	02059493          	slli	s1,a1,0x20
    800026da:	9081                	srli	s1,s1,0x20
    800026dc:	048a                	slli	s1,s1,0x2
    800026de:	94aa                	add	s1,s1,a0
    800026e0:	0504a903          	lw	s2,80(s1)
    800026e4:	06091e63          	bnez	s2,80002760 <bmap+0xa2>
      addr = balloc(ip->dev);
    800026e8:	4108                	lw	a0,0(a0)
    800026ea:	00000097          	auipc	ra,0x0
    800026ee:	e9c080e7          	jalr	-356(ra) # 80002586 <balloc>
    800026f2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026f6:	06090563          	beqz	s2,80002760 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800026fa:	0524a823          	sw	s2,80(s1)
    800026fe:	a08d                	j	80002760 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002700:	ff45849b          	addiw	s1,a1,-12
    80002704:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002708:	0ff00793          	li	a5,255
    8000270c:	08e7e563          	bltu	a5,a4,80002796 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002710:	08052903          	lw	s2,128(a0)
    80002714:	00091d63          	bnez	s2,8000272e <bmap+0x70>
      addr = balloc(ip->dev);
    80002718:	4108                	lw	a0,0(a0)
    8000271a:	00000097          	auipc	ra,0x0
    8000271e:	e6c080e7          	jalr	-404(ra) # 80002586 <balloc>
    80002722:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002726:	02090d63          	beqz	s2,80002760 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000272a:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000272e:	85ca                	mv	a1,s2
    80002730:	0009a503          	lw	a0,0(s3)
    80002734:	00000097          	auipc	ra,0x0
    80002738:	b90080e7          	jalr	-1136(ra) # 800022c4 <bread>
    8000273c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000273e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002742:	02049593          	slli	a1,s1,0x20
    80002746:	9181                	srli	a1,a1,0x20
    80002748:	058a                	slli	a1,a1,0x2
    8000274a:	00b784b3          	add	s1,a5,a1
    8000274e:	0004a903          	lw	s2,0(s1)
    80002752:	02090063          	beqz	s2,80002772 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002756:	8552                	mv	a0,s4
    80002758:	00000097          	auipc	ra,0x0
    8000275c:	c9c080e7          	jalr	-868(ra) # 800023f4 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002760:	854a                	mv	a0,s2
    80002762:	70a2                	ld	ra,40(sp)
    80002764:	7402                	ld	s0,32(sp)
    80002766:	64e2                	ld	s1,24(sp)
    80002768:	6942                	ld	s2,16(sp)
    8000276a:	69a2                	ld	s3,8(sp)
    8000276c:	6a02                	ld	s4,0(sp)
    8000276e:	6145                	addi	sp,sp,48
    80002770:	8082                	ret
      addr = balloc(ip->dev);
    80002772:	0009a503          	lw	a0,0(s3)
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	e10080e7          	jalr	-496(ra) # 80002586 <balloc>
    8000277e:	0005091b          	sext.w	s2,a0
      if(addr){
    80002782:	fc090ae3          	beqz	s2,80002756 <bmap+0x98>
        a[bn] = addr;
    80002786:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000278a:	8552                	mv	a0,s4
    8000278c:	00001097          	auipc	ra,0x1
    80002790:	eec080e7          	jalr	-276(ra) # 80003678 <log_write>
    80002794:	b7c9                	j	80002756 <bmap+0x98>
  panic("bmap: out of range");
    80002796:	00006517          	auipc	a0,0x6
    8000279a:	d9a50513          	addi	a0,a0,-614 # 80008530 <syscalls+0x160>
    8000279e:	00003097          	auipc	ra,0x3
    800027a2:	444080e7          	jalr	1092(ra) # 80005be2 <panic>

00000000800027a6 <iget>:
{
    800027a6:	7179                	addi	sp,sp,-48
    800027a8:	f406                	sd	ra,40(sp)
    800027aa:	f022                	sd	s0,32(sp)
    800027ac:	ec26                	sd	s1,24(sp)
    800027ae:	e84a                	sd	s2,16(sp)
    800027b0:	e44e                	sd	s3,8(sp)
    800027b2:	e052                	sd	s4,0(sp)
    800027b4:	1800                	addi	s0,sp,48
    800027b6:	89aa                	mv	s3,a0
    800027b8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027ba:	00014517          	auipc	a0,0x14
    800027be:	6be50513          	addi	a0,a0,1726 # 80016e78 <itable>
    800027c2:	00004097          	auipc	ra,0x4
    800027c6:	96a080e7          	jalr	-1686(ra) # 8000612c <acquire>
  empty = 0;
    800027ca:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027cc:	00014497          	auipc	s1,0x14
    800027d0:	6c448493          	addi	s1,s1,1732 # 80016e90 <itable+0x18>
    800027d4:	00016697          	auipc	a3,0x16
    800027d8:	14c68693          	addi	a3,a3,332 # 80018920 <log>
    800027dc:	a039                	j	800027ea <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027de:	02090b63          	beqz	s2,80002814 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027e2:	08848493          	addi	s1,s1,136
    800027e6:	02d48a63          	beq	s1,a3,8000281a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027ea:	449c                	lw	a5,8(s1)
    800027ec:	fef059e3          	blez	a5,800027de <iget+0x38>
    800027f0:	4098                	lw	a4,0(s1)
    800027f2:	ff3716e3          	bne	a4,s3,800027de <iget+0x38>
    800027f6:	40d8                	lw	a4,4(s1)
    800027f8:	ff4713e3          	bne	a4,s4,800027de <iget+0x38>
      ip->ref++;
    800027fc:	2785                	addiw	a5,a5,1
    800027fe:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002800:	00014517          	auipc	a0,0x14
    80002804:	67850513          	addi	a0,a0,1656 # 80016e78 <itable>
    80002808:	00004097          	auipc	ra,0x4
    8000280c:	9d8080e7          	jalr	-1576(ra) # 800061e0 <release>
      return ip;
    80002810:	8926                	mv	s2,s1
    80002812:	a03d                	j	80002840 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002814:	f7f9                	bnez	a5,800027e2 <iget+0x3c>
    80002816:	8926                	mv	s2,s1
    80002818:	b7e9                	j	800027e2 <iget+0x3c>
  if(empty == 0)
    8000281a:	02090c63          	beqz	s2,80002852 <iget+0xac>
  ip->dev = dev;
    8000281e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002822:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002826:	4785                	li	a5,1
    80002828:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000282c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002830:	00014517          	auipc	a0,0x14
    80002834:	64850513          	addi	a0,a0,1608 # 80016e78 <itable>
    80002838:	00004097          	auipc	ra,0x4
    8000283c:	9a8080e7          	jalr	-1624(ra) # 800061e0 <release>
}
    80002840:	854a                	mv	a0,s2
    80002842:	70a2                	ld	ra,40(sp)
    80002844:	7402                	ld	s0,32(sp)
    80002846:	64e2                	ld	s1,24(sp)
    80002848:	6942                	ld	s2,16(sp)
    8000284a:	69a2                	ld	s3,8(sp)
    8000284c:	6a02                	ld	s4,0(sp)
    8000284e:	6145                	addi	sp,sp,48
    80002850:	8082                	ret
    panic("iget: no inodes");
    80002852:	00006517          	auipc	a0,0x6
    80002856:	cf650513          	addi	a0,a0,-778 # 80008548 <syscalls+0x178>
    8000285a:	00003097          	auipc	ra,0x3
    8000285e:	388080e7          	jalr	904(ra) # 80005be2 <panic>

0000000080002862 <fsinit>:
fsinit(int dev) {
    80002862:	7179                	addi	sp,sp,-48
    80002864:	f406                	sd	ra,40(sp)
    80002866:	f022                	sd	s0,32(sp)
    80002868:	ec26                	sd	s1,24(sp)
    8000286a:	e84a                	sd	s2,16(sp)
    8000286c:	e44e                	sd	s3,8(sp)
    8000286e:	1800                	addi	s0,sp,48
    80002870:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002872:	4585                	li	a1,1
    80002874:	00000097          	auipc	ra,0x0
    80002878:	a50080e7          	jalr	-1456(ra) # 800022c4 <bread>
    8000287c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000287e:	00014997          	auipc	s3,0x14
    80002882:	5da98993          	addi	s3,s3,1498 # 80016e58 <sb>
    80002886:	02000613          	li	a2,32
    8000288a:	05850593          	addi	a1,a0,88
    8000288e:	854e                	mv	a0,s3
    80002890:	ffffe097          	auipc	ra,0xffffe
    80002894:	948080e7          	jalr	-1720(ra) # 800001d8 <memmove>
  brelse(bp);
    80002898:	8526                	mv	a0,s1
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	b5a080e7          	jalr	-1190(ra) # 800023f4 <brelse>
  if(sb.magic != FSMAGIC)
    800028a2:	0009a703          	lw	a4,0(s3)
    800028a6:	102037b7          	lui	a5,0x10203
    800028aa:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028ae:	02f71263          	bne	a4,a5,800028d2 <fsinit+0x70>
  initlog(dev, &sb);
    800028b2:	00014597          	auipc	a1,0x14
    800028b6:	5a658593          	addi	a1,a1,1446 # 80016e58 <sb>
    800028ba:	854a                	mv	a0,s2
    800028bc:	00001097          	auipc	ra,0x1
    800028c0:	b40080e7          	jalr	-1216(ra) # 800033fc <initlog>
}
    800028c4:	70a2                	ld	ra,40(sp)
    800028c6:	7402                	ld	s0,32(sp)
    800028c8:	64e2                	ld	s1,24(sp)
    800028ca:	6942                	ld	s2,16(sp)
    800028cc:	69a2                	ld	s3,8(sp)
    800028ce:	6145                	addi	sp,sp,48
    800028d0:	8082                	ret
    panic("invalid file system");
    800028d2:	00006517          	auipc	a0,0x6
    800028d6:	c8650513          	addi	a0,a0,-890 # 80008558 <syscalls+0x188>
    800028da:	00003097          	auipc	ra,0x3
    800028de:	308080e7          	jalr	776(ra) # 80005be2 <panic>

00000000800028e2 <iinit>:
{
    800028e2:	7179                	addi	sp,sp,-48
    800028e4:	f406                	sd	ra,40(sp)
    800028e6:	f022                	sd	s0,32(sp)
    800028e8:	ec26                	sd	s1,24(sp)
    800028ea:	e84a                	sd	s2,16(sp)
    800028ec:	e44e                	sd	s3,8(sp)
    800028ee:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028f0:	00006597          	auipc	a1,0x6
    800028f4:	c8058593          	addi	a1,a1,-896 # 80008570 <syscalls+0x1a0>
    800028f8:	00014517          	auipc	a0,0x14
    800028fc:	58050513          	addi	a0,a0,1408 # 80016e78 <itable>
    80002900:	00003097          	auipc	ra,0x3
    80002904:	79c080e7          	jalr	1948(ra) # 8000609c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002908:	00014497          	auipc	s1,0x14
    8000290c:	59848493          	addi	s1,s1,1432 # 80016ea0 <itable+0x28>
    80002910:	00016997          	auipc	s3,0x16
    80002914:	02098993          	addi	s3,s3,32 # 80018930 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002918:	00006917          	auipc	s2,0x6
    8000291c:	c6090913          	addi	s2,s2,-928 # 80008578 <syscalls+0x1a8>
    80002920:	85ca                	mv	a1,s2
    80002922:	8526                	mv	a0,s1
    80002924:	00001097          	auipc	ra,0x1
    80002928:	e3a080e7          	jalr	-454(ra) # 8000375e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000292c:	08848493          	addi	s1,s1,136
    80002930:	ff3498e3          	bne	s1,s3,80002920 <iinit+0x3e>
}
    80002934:	70a2                	ld	ra,40(sp)
    80002936:	7402                	ld	s0,32(sp)
    80002938:	64e2                	ld	s1,24(sp)
    8000293a:	6942                	ld	s2,16(sp)
    8000293c:	69a2                	ld	s3,8(sp)
    8000293e:	6145                	addi	sp,sp,48
    80002940:	8082                	ret

0000000080002942 <ialloc>:
{
    80002942:	715d                	addi	sp,sp,-80
    80002944:	e486                	sd	ra,72(sp)
    80002946:	e0a2                	sd	s0,64(sp)
    80002948:	fc26                	sd	s1,56(sp)
    8000294a:	f84a                	sd	s2,48(sp)
    8000294c:	f44e                	sd	s3,40(sp)
    8000294e:	f052                	sd	s4,32(sp)
    80002950:	ec56                	sd	s5,24(sp)
    80002952:	e85a                	sd	s6,16(sp)
    80002954:	e45e                	sd	s7,8(sp)
    80002956:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002958:	00014717          	auipc	a4,0x14
    8000295c:	50c72703          	lw	a4,1292(a4) # 80016e64 <sb+0xc>
    80002960:	4785                	li	a5,1
    80002962:	04e7fa63          	bgeu	a5,a4,800029b6 <ialloc+0x74>
    80002966:	8aaa                	mv	s5,a0
    80002968:	8bae                	mv	s7,a1
    8000296a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000296c:	00014a17          	auipc	s4,0x14
    80002970:	4eca0a13          	addi	s4,s4,1260 # 80016e58 <sb>
    80002974:	00048b1b          	sext.w	s6,s1
    80002978:	0044d593          	srli	a1,s1,0x4
    8000297c:	018a2783          	lw	a5,24(s4)
    80002980:	9dbd                	addw	a1,a1,a5
    80002982:	8556                	mv	a0,s5
    80002984:	00000097          	auipc	ra,0x0
    80002988:	940080e7          	jalr	-1728(ra) # 800022c4 <bread>
    8000298c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000298e:	05850993          	addi	s3,a0,88
    80002992:	00f4f793          	andi	a5,s1,15
    80002996:	079a                	slli	a5,a5,0x6
    80002998:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000299a:	00099783          	lh	a5,0(s3)
    8000299e:	c3a1                	beqz	a5,800029de <ialloc+0x9c>
    brelse(bp);
    800029a0:	00000097          	auipc	ra,0x0
    800029a4:	a54080e7          	jalr	-1452(ra) # 800023f4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029a8:	0485                	addi	s1,s1,1
    800029aa:	00ca2703          	lw	a4,12(s4)
    800029ae:	0004879b          	sext.w	a5,s1
    800029b2:	fce7e1e3          	bltu	a5,a4,80002974 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800029b6:	00006517          	auipc	a0,0x6
    800029ba:	bca50513          	addi	a0,a0,-1078 # 80008580 <syscalls+0x1b0>
    800029be:	00003097          	auipc	ra,0x3
    800029c2:	26e080e7          	jalr	622(ra) # 80005c2c <printf>
  return 0;
    800029c6:	4501                	li	a0,0
}
    800029c8:	60a6                	ld	ra,72(sp)
    800029ca:	6406                	ld	s0,64(sp)
    800029cc:	74e2                	ld	s1,56(sp)
    800029ce:	7942                	ld	s2,48(sp)
    800029d0:	79a2                	ld	s3,40(sp)
    800029d2:	7a02                	ld	s4,32(sp)
    800029d4:	6ae2                	ld	s5,24(sp)
    800029d6:	6b42                	ld	s6,16(sp)
    800029d8:	6ba2                	ld	s7,8(sp)
    800029da:	6161                	addi	sp,sp,80
    800029dc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029de:	04000613          	li	a2,64
    800029e2:	4581                	li	a1,0
    800029e4:	854e                	mv	a0,s3
    800029e6:	ffffd097          	auipc	ra,0xffffd
    800029ea:	792080e7          	jalr	1938(ra) # 80000178 <memset>
      dip->type = type;
    800029ee:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029f2:	854a                	mv	a0,s2
    800029f4:	00001097          	auipc	ra,0x1
    800029f8:	c84080e7          	jalr	-892(ra) # 80003678 <log_write>
      brelse(bp);
    800029fc:	854a                	mv	a0,s2
    800029fe:	00000097          	auipc	ra,0x0
    80002a02:	9f6080e7          	jalr	-1546(ra) # 800023f4 <brelse>
      return iget(dev, inum);
    80002a06:	85da                	mv	a1,s6
    80002a08:	8556                	mv	a0,s5
    80002a0a:	00000097          	auipc	ra,0x0
    80002a0e:	d9c080e7          	jalr	-612(ra) # 800027a6 <iget>
    80002a12:	bf5d                	j	800029c8 <ialloc+0x86>

0000000080002a14 <iupdate>:
{
    80002a14:	1101                	addi	sp,sp,-32
    80002a16:	ec06                	sd	ra,24(sp)
    80002a18:	e822                	sd	s0,16(sp)
    80002a1a:	e426                	sd	s1,8(sp)
    80002a1c:	e04a                	sd	s2,0(sp)
    80002a1e:	1000                	addi	s0,sp,32
    80002a20:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a22:	415c                	lw	a5,4(a0)
    80002a24:	0047d79b          	srliw	a5,a5,0x4
    80002a28:	00014597          	auipc	a1,0x14
    80002a2c:	4485a583          	lw	a1,1096(a1) # 80016e70 <sb+0x18>
    80002a30:	9dbd                	addw	a1,a1,a5
    80002a32:	4108                	lw	a0,0(a0)
    80002a34:	00000097          	auipc	ra,0x0
    80002a38:	890080e7          	jalr	-1904(ra) # 800022c4 <bread>
    80002a3c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a3e:	05850793          	addi	a5,a0,88
    80002a42:	40c8                	lw	a0,4(s1)
    80002a44:	893d                	andi	a0,a0,15
    80002a46:	051a                	slli	a0,a0,0x6
    80002a48:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a4a:	04449703          	lh	a4,68(s1)
    80002a4e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a52:	04649703          	lh	a4,70(s1)
    80002a56:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a5a:	04849703          	lh	a4,72(s1)
    80002a5e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002a62:	04a49703          	lh	a4,74(s1)
    80002a66:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002a6a:	44f8                	lw	a4,76(s1)
    80002a6c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a6e:	03400613          	li	a2,52
    80002a72:	05048593          	addi	a1,s1,80
    80002a76:	0531                	addi	a0,a0,12
    80002a78:	ffffd097          	auipc	ra,0xffffd
    80002a7c:	760080e7          	jalr	1888(ra) # 800001d8 <memmove>
  log_write(bp);
    80002a80:	854a                	mv	a0,s2
    80002a82:	00001097          	auipc	ra,0x1
    80002a86:	bf6080e7          	jalr	-1034(ra) # 80003678 <log_write>
  brelse(bp);
    80002a8a:	854a                	mv	a0,s2
    80002a8c:	00000097          	auipc	ra,0x0
    80002a90:	968080e7          	jalr	-1688(ra) # 800023f4 <brelse>
}
    80002a94:	60e2                	ld	ra,24(sp)
    80002a96:	6442                	ld	s0,16(sp)
    80002a98:	64a2                	ld	s1,8(sp)
    80002a9a:	6902                	ld	s2,0(sp)
    80002a9c:	6105                	addi	sp,sp,32
    80002a9e:	8082                	ret

0000000080002aa0 <idup>:
{
    80002aa0:	1101                	addi	sp,sp,-32
    80002aa2:	ec06                	sd	ra,24(sp)
    80002aa4:	e822                	sd	s0,16(sp)
    80002aa6:	e426                	sd	s1,8(sp)
    80002aa8:	1000                	addi	s0,sp,32
    80002aaa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002aac:	00014517          	auipc	a0,0x14
    80002ab0:	3cc50513          	addi	a0,a0,972 # 80016e78 <itable>
    80002ab4:	00003097          	auipc	ra,0x3
    80002ab8:	678080e7          	jalr	1656(ra) # 8000612c <acquire>
  ip->ref++;
    80002abc:	449c                	lw	a5,8(s1)
    80002abe:	2785                	addiw	a5,a5,1
    80002ac0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ac2:	00014517          	auipc	a0,0x14
    80002ac6:	3b650513          	addi	a0,a0,950 # 80016e78 <itable>
    80002aca:	00003097          	auipc	ra,0x3
    80002ace:	716080e7          	jalr	1814(ra) # 800061e0 <release>
}
    80002ad2:	8526                	mv	a0,s1
    80002ad4:	60e2                	ld	ra,24(sp)
    80002ad6:	6442                	ld	s0,16(sp)
    80002ad8:	64a2                	ld	s1,8(sp)
    80002ada:	6105                	addi	sp,sp,32
    80002adc:	8082                	ret

0000000080002ade <ilock>:
{
    80002ade:	1101                	addi	sp,sp,-32
    80002ae0:	ec06                	sd	ra,24(sp)
    80002ae2:	e822                	sd	s0,16(sp)
    80002ae4:	e426                	sd	s1,8(sp)
    80002ae6:	e04a                	sd	s2,0(sp)
    80002ae8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002aea:	c115                	beqz	a0,80002b0e <ilock+0x30>
    80002aec:	84aa                	mv	s1,a0
    80002aee:	451c                	lw	a5,8(a0)
    80002af0:	00f05f63          	blez	a5,80002b0e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002af4:	0541                	addi	a0,a0,16
    80002af6:	00001097          	auipc	ra,0x1
    80002afa:	ca2080e7          	jalr	-862(ra) # 80003798 <acquiresleep>
  if(ip->valid == 0){
    80002afe:	40bc                	lw	a5,64(s1)
    80002b00:	cf99                	beqz	a5,80002b1e <ilock+0x40>
}
    80002b02:	60e2                	ld	ra,24(sp)
    80002b04:	6442                	ld	s0,16(sp)
    80002b06:	64a2                	ld	s1,8(sp)
    80002b08:	6902                	ld	s2,0(sp)
    80002b0a:	6105                	addi	sp,sp,32
    80002b0c:	8082                	ret
    panic("ilock");
    80002b0e:	00006517          	auipc	a0,0x6
    80002b12:	a8a50513          	addi	a0,a0,-1398 # 80008598 <syscalls+0x1c8>
    80002b16:	00003097          	auipc	ra,0x3
    80002b1a:	0cc080e7          	jalr	204(ra) # 80005be2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b1e:	40dc                	lw	a5,4(s1)
    80002b20:	0047d79b          	srliw	a5,a5,0x4
    80002b24:	00014597          	auipc	a1,0x14
    80002b28:	34c5a583          	lw	a1,844(a1) # 80016e70 <sb+0x18>
    80002b2c:	9dbd                	addw	a1,a1,a5
    80002b2e:	4088                	lw	a0,0(s1)
    80002b30:	fffff097          	auipc	ra,0xfffff
    80002b34:	794080e7          	jalr	1940(ra) # 800022c4 <bread>
    80002b38:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b3a:	05850593          	addi	a1,a0,88
    80002b3e:	40dc                	lw	a5,4(s1)
    80002b40:	8bbd                	andi	a5,a5,15
    80002b42:	079a                	slli	a5,a5,0x6
    80002b44:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b46:	00059783          	lh	a5,0(a1)
    80002b4a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b4e:	00259783          	lh	a5,2(a1)
    80002b52:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b56:	00459783          	lh	a5,4(a1)
    80002b5a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b5e:	00659783          	lh	a5,6(a1)
    80002b62:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b66:	459c                	lw	a5,8(a1)
    80002b68:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b6a:	03400613          	li	a2,52
    80002b6e:	05b1                	addi	a1,a1,12
    80002b70:	05048513          	addi	a0,s1,80
    80002b74:	ffffd097          	auipc	ra,0xffffd
    80002b78:	664080e7          	jalr	1636(ra) # 800001d8 <memmove>
    brelse(bp);
    80002b7c:	854a                	mv	a0,s2
    80002b7e:	00000097          	auipc	ra,0x0
    80002b82:	876080e7          	jalr	-1930(ra) # 800023f4 <brelse>
    ip->valid = 1;
    80002b86:	4785                	li	a5,1
    80002b88:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b8a:	04449783          	lh	a5,68(s1)
    80002b8e:	fbb5                	bnez	a5,80002b02 <ilock+0x24>
      panic("ilock: no type");
    80002b90:	00006517          	auipc	a0,0x6
    80002b94:	a1050513          	addi	a0,a0,-1520 # 800085a0 <syscalls+0x1d0>
    80002b98:	00003097          	auipc	ra,0x3
    80002b9c:	04a080e7          	jalr	74(ra) # 80005be2 <panic>

0000000080002ba0 <iunlock>:
{
    80002ba0:	1101                	addi	sp,sp,-32
    80002ba2:	ec06                	sd	ra,24(sp)
    80002ba4:	e822                	sd	s0,16(sp)
    80002ba6:	e426                	sd	s1,8(sp)
    80002ba8:	e04a                	sd	s2,0(sp)
    80002baa:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bac:	c905                	beqz	a0,80002bdc <iunlock+0x3c>
    80002bae:	84aa                	mv	s1,a0
    80002bb0:	01050913          	addi	s2,a0,16
    80002bb4:	854a                	mv	a0,s2
    80002bb6:	00001097          	auipc	ra,0x1
    80002bba:	c7c080e7          	jalr	-900(ra) # 80003832 <holdingsleep>
    80002bbe:	cd19                	beqz	a0,80002bdc <iunlock+0x3c>
    80002bc0:	449c                	lw	a5,8(s1)
    80002bc2:	00f05d63          	blez	a5,80002bdc <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bc6:	854a                	mv	a0,s2
    80002bc8:	00001097          	auipc	ra,0x1
    80002bcc:	c26080e7          	jalr	-986(ra) # 800037ee <releasesleep>
}
    80002bd0:	60e2                	ld	ra,24(sp)
    80002bd2:	6442                	ld	s0,16(sp)
    80002bd4:	64a2                	ld	s1,8(sp)
    80002bd6:	6902                	ld	s2,0(sp)
    80002bd8:	6105                	addi	sp,sp,32
    80002bda:	8082                	ret
    panic("iunlock");
    80002bdc:	00006517          	auipc	a0,0x6
    80002be0:	9d450513          	addi	a0,a0,-1580 # 800085b0 <syscalls+0x1e0>
    80002be4:	00003097          	auipc	ra,0x3
    80002be8:	ffe080e7          	jalr	-2(ra) # 80005be2 <panic>

0000000080002bec <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bec:	7179                	addi	sp,sp,-48
    80002bee:	f406                	sd	ra,40(sp)
    80002bf0:	f022                	sd	s0,32(sp)
    80002bf2:	ec26                	sd	s1,24(sp)
    80002bf4:	e84a                	sd	s2,16(sp)
    80002bf6:	e44e                	sd	s3,8(sp)
    80002bf8:	e052                	sd	s4,0(sp)
    80002bfa:	1800                	addi	s0,sp,48
    80002bfc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002bfe:	05050493          	addi	s1,a0,80
    80002c02:	08050913          	addi	s2,a0,128
    80002c06:	a021                	j	80002c0e <itrunc+0x22>
    80002c08:	0491                	addi	s1,s1,4
    80002c0a:	01248d63          	beq	s1,s2,80002c24 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c0e:	408c                	lw	a1,0(s1)
    80002c10:	dde5                	beqz	a1,80002c08 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c12:	0009a503          	lw	a0,0(s3)
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	8f4080e7          	jalr	-1804(ra) # 8000250a <bfree>
      ip->addrs[i] = 0;
    80002c1e:	0004a023          	sw	zero,0(s1)
    80002c22:	b7dd                	j	80002c08 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c24:	0809a583          	lw	a1,128(s3)
    80002c28:	e185                	bnez	a1,80002c48 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c2a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c2e:	854e                	mv	a0,s3
    80002c30:	00000097          	auipc	ra,0x0
    80002c34:	de4080e7          	jalr	-540(ra) # 80002a14 <iupdate>
}
    80002c38:	70a2                	ld	ra,40(sp)
    80002c3a:	7402                	ld	s0,32(sp)
    80002c3c:	64e2                	ld	s1,24(sp)
    80002c3e:	6942                	ld	s2,16(sp)
    80002c40:	69a2                	ld	s3,8(sp)
    80002c42:	6a02                	ld	s4,0(sp)
    80002c44:	6145                	addi	sp,sp,48
    80002c46:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c48:	0009a503          	lw	a0,0(s3)
    80002c4c:	fffff097          	auipc	ra,0xfffff
    80002c50:	678080e7          	jalr	1656(ra) # 800022c4 <bread>
    80002c54:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c56:	05850493          	addi	s1,a0,88
    80002c5a:	45850913          	addi	s2,a0,1112
    80002c5e:	a811                	j	80002c72 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002c60:	0009a503          	lw	a0,0(s3)
    80002c64:	00000097          	auipc	ra,0x0
    80002c68:	8a6080e7          	jalr	-1882(ra) # 8000250a <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002c6c:	0491                	addi	s1,s1,4
    80002c6e:	01248563          	beq	s1,s2,80002c78 <itrunc+0x8c>
      if(a[j])
    80002c72:	408c                	lw	a1,0(s1)
    80002c74:	dde5                	beqz	a1,80002c6c <itrunc+0x80>
    80002c76:	b7ed                	j	80002c60 <itrunc+0x74>
    brelse(bp);
    80002c78:	8552                	mv	a0,s4
    80002c7a:	fffff097          	auipc	ra,0xfffff
    80002c7e:	77a080e7          	jalr	1914(ra) # 800023f4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c82:	0809a583          	lw	a1,128(s3)
    80002c86:	0009a503          	lw	a0,0(s3)
    80002c8a:	00000097          	auipc	ra,0x0
    80002c8e:	880080e7          	jalr	-1920(ra) # 8000250a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c92:	0809a023          	sw	zero,128(s3)
    80002c96:	bf51                	j	80002c2a <itrunc+0x3e>

0000000080002c98 <iput>:
{
    80002c98:	1101                	addi	sp,sp,-32
    80002c9a:	ec06                	sd	ra,24(sp)
    80002c9c:	e822                	sd	s0,16(sp)
    80002c9e:	e426                	sd	s1,8(sp)
    80002ca0:	e04a                	sd	s2,0(sp)
    80002ca2:	1000                	addi	s0,sp,32
    80002ca4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ca6:	00014517          	auipc	a0,0x14
    80002caa:	1d250513          	addi	a0,a0,466 # 80016e78 <itable>
    80002cae:	00003097          	auipc	ra,0x3
    80002cb2:	47e080e7          	jalr	1150(ra) # 8000612c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cb6:	4498                	lw	a4,8(s1)
    80002cb8:	4785                	li	a5,1
    80002cba:	02f70363          	beq	a4,a5,80002ce0 <iput+0x48>
  ip->ref--;
    80002cbe:	449c                	lw	a5,8(s1)
    80002cc0:	37fd                	addiw	a5,a5,-1
    80002cc2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cc4:	00014517          	auipc	a0,0x14
    80002cc8:	1b450513          	addi	a0,a0,436 # 80016e78 <itable>
    80002ccc:	00003097          	auipc	ra,0x3
    80002cd0:	514080e7          	jalr	1300(ra) # 800061e0 <release>
}
    80002cd4:	60e2                	ld	ra,24(sp)
    80002cd6:	6442                	ld	s0,16(sp)
    80002cd8:	64a2                	ld	s1,8(sp)
    80002cda:	6902                	ld	s2,0(sp)
    80002cdc:	6105                	addi	sp,sp,32
    80002cde:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ce0:	40bc                	lw	a5,64(s1)
    80002ce2:	dff1                	beqz	a5,80002cbe <iput+0x26>
    80002ce4:	04a49783          	lh	a5,74(s1)
    80002ce8:	fbf9                	bnez	a5,80002cbe <iput+0x26>
    acquiresleep(&ip->lock);
    80002cea:	01048913          	addi	s2,s1,16
    80002cee:	854a                	mv	a0,s2
    80002cf0:	00001097          	auipc	ra,0x1
    80002cf4:	aa8080e7          	jalr	-1368(ra) # 80003798 <acquiresleep>
    release(&itable.lock);
    80002cf8:	00014517          	auipc	a0,0x14
    80002cfc:	18050513          	addi	a0,a0,384 # 80016e78 <itable>
    80002d00:	00003097          	auipc	ra,0x3
    80002d04:	4e0080e7          	jalr	1248(ra) # 800061e0 <release>
    itrunc(ip);
    80002d08:	8526                	mv	a0,s1
    80002d0a:	00000097          	auipc	ra,0x0
    80002d0e:	ee2080e7          	jalr	-286(ra) # 80002bec <itrunc>
    ip->type = 0;
    80002d12:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d16:	8526                	mv	a0,s1
    80002d18:	00000097          	auipc	ra,0x0
    80002d1c:	cfc080e7          	jalr	-772(ra) # 80002a14 <iupdate>
    ip->valid = 0;
    80002d20:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d24:	854a                	mv	a0,s2
    80002d26:	00001097          	auipc	ra,0x1
    80002d2a:	ac8080e7          	jalr	-1336(ra) # 800037ee <releasesleep>
    acquire(&itable.lock);
    80002d2e:	00014517          	auipc	a0,0x14
    80002d32:	14a50513          	addi	a0,a0,330 # 80016e78 <itable>
    80002d36:	00003097          	auipc	ra,0x3
    80002d3a:	3f6080e7          	jalr	1014(ra) # 8000612c <acquire>
    80002d3e:	b741                	j	80002cbe <iput+0x26>

0000000080002d40 <iunlockput>:
{
    80002d40:	1101                	addi	sp,sp,-32
    80002d42:	ec06                	sd	ra,24(sp)
    80002d44:	e822                	sd	s0,16(sp)
    80002d46:	e426                	sd	s1,8(sp)
    80002d48:	1000                	addi	s0,sp,32
    80002d4a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d4c:	00000097          	auipc	ra,0x0
    80002d50:	e54080e7          	jalr	-428(ra) # 80002ba0 <iunlock>
  iput(ip);
    80002d54:	8526                	mv	a0,s1
    80002d56:	00000097          	auipc	ra,0x0
    80002d5a:	f42080e7          	jalr	-190(ra) # 80002c98 <iput>
}
    80002d5e:	60e2                	ld	ra,24(sp)
    80002d60:	6442                	ld	s0,16(sp)
    80002d62:	64a2                	ld	s1,8(sp)
    80002d64:	6105                	addi	sp,sp,32
    80002d66:	8082                	ret

0000000080002d68 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d68:	1141                	addi	sp,sp,-16
    80002d6a:	e422                	sd	s0,8(sp)
    80002d6c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d6e:	411c                	lw	a5,0(a0)
    80002d70:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d72:	415c                	lw	a5,4(a0)
    80002d74:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d76:	04451783          	lh	a5,68(a0)
    80002d7a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d7e:	04a51783          	lh	a5,74(a0)
    80002d82:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d86:	04c56783          	lwu	a5,76(a0)
    80002d8a:	e99c                	sd	a5,16(a1)
}
    80002d8c:	6422                	ld	s0,8(sp)
    80002d8e:	0141                	addi	sp,sp,16
    80002d90:	8082                	ret

0000000080002d92 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d92:	457c                	lw	a5,76(a0)
    80002d94:	0ed7e963          	bltu	a5,a3,80002e86 <readi+0xf4>
{
    80002d98:	7159                	addi	sp,sp,-112
    80002d9a:	f486                	sd	ra,104(sp)
    80002d9c:	f0a2                	sd	s0,96(sp)
    80002d9e:	eca6                	sd	s1,88(sp)
    80002da0:	e8ca                	sd	s2,80(sp)
    80002da2:	e4ce                	sd	s3,72(sp)
    80002da4:	e0d2                	sd	s4,64(sp)
    80002da6:	fc56                	sd	s5,56(sp)
    80002da8:	f85a                	sd	s6,48(sp)
    80002daa:	f45e                	sd	s7,40(sp)
    80002dac:	f062                	sd	s8,32(sp)
    80002dae:	ec66                	sd	s9,24(sp)
    80002db0:	e86a                	sd	s10,16(sp)
    80002db2:	e46e                	sd	s11,8(sp)
    80002db4:	1880                	addi	s0,sp,112
    80002db6:	8b2a                	mv	s6,a0
    80002db8:	8bae                	mv	s7,a1
    80002dba:	8a32                	mv	s4,a2
    80002dbc:	84b6                	mv	s1,a3
    80002dbe:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002dc0:	9f35                	addw	a4,a4,a3
    return 0;
    80002dc2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dc4:	0ad76063          	bltu	a4,a3,80002e64 <readi+0xd2>
  if(off + n > ip->size)
    80002dc8:	00e7f463          	bgeu	a5,a4,80002dd0 <readi+0x3e>
    n = ip->size - off;
    80002dcc:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dd0:	0a0a8963          	beqz	s5,80002e82 <readi+0xf0>
    80002dd4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dd6:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dda:	5c7d                	li	s8,-1
    80002ddc:	a82d                	j	80002e16 <readi+0x84>
    80002dde:	020d1d93          	slli	s11,s10,0x20
    80002de2:	020ddd93          	srli	s11,s11,0x20
    80002de6:	05890613          	addi	a2,s2,88
    80002dea:	86ee                	mv	a3,s11
    80002dec:	963a                	add	a2,a2,a4
    80002dee:	85d2                	mv	a1,s4
    80002df0:	855e                	mv	a0,s7
    80002df2:	fffff097          	auipc	ra,0xfffff
    80002df6:	b0e080e7          	jalr	-1266(ra) # 80001900 <either_copyout>
    80002dfa:	05850d63          	beq	a0,s8,80002e54 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002dfe:	854a                	mv	a0,s2
    80002e00:	fffff097          	auipc	ra,0xfffff
    80002e04:	5f4080e7          	jalr	1524(ra) # 800023f4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e08:	013d09bb          	addw	s3,s10,s3
    80002e0c:	009d04bb          	addw	s1,s10,s1
    80002e10:	9a6e                	add	s4,s4,s11
    80002e12:	0559f763          	bgeu	s3,s5,80002e60 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e16:	00a4d59b          	srliw	a1,s1,0xa
    80002e1a:	855a                	mv	a0,s6
    80002e1c:	00000097          	auipc	ra,0x0
    80002e20:	8a2080e7          	jalr	-1886(ra) # 800026be <bmap>
    80002e24:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e28:	cd85                	beqz	a1,80002e60 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e2a:	000b2503          	lw	a0,0(s6)
    80002e2e:	fffff097          	auipc	ra,0xfffff
    80002e32:	496080e7          	jalr	1174(ra) # 800022c4 <bread>
    80002e36:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e38:	3ff4f713          	andi	a4,s1,1023
    80002e3c:	40ec87bb          	subw	a5,s9,a4
    80002e40:	413a86bb          	subw	a3,s5,s3
    80002e44:	8d3e                	mv	s10,a5
    80002e46:	2781                	sext.w	a5,a5
    80002e48:	0006861b          	sext.w	a2,a3
    80002e4c:	f8f679e3          	bgeu	a2,a5,80002dde <readi+0x4c>
    80002e50:	8d36                	mv	s10,a3
    80002e52:	b771                	j	80002dde <readi+0x4c>
      brelse(bp);
    80002e54:	854a                	mv	a0,s2
    80002e56:	fffff097          	auipc	ra,0xfffff
    80002e5a:	59e080e7          	jalr	1438(ra) # 800023f4 <brelse>
      tot = -1;
    80002e5e:	59fd                	li	s3,-1
  }
  return tot;
    80002e60:	0009851b          	sext.w	a0,s3
}
    80002e64:	70a6                	ld	ra,104(sp)
    80002e66:	7406                	ld	s0,96(sp)
    80002e68:	64e6                	ld	s1,88(sp)
    80002e6a:	6946                	ld	s2,80(sp)
    80002e6c:	69a6                	ld	s3,72(sp)
    80002e6e:	6a06                	ld	s4,64(sp)
    80002e70:	7ae2                	ld	s5,56(sp)
    80002e72:	7b42                	ld	s6,48(sp)
    80002e74:	7ba2                	ld	s7,40(sp)
    80002e76:	7c02                	ld	s8,32(sp)
    80002e78:	6ce2                	ld	s9,24(sp)
    80002e7a:	6d42                	ld	s10,16(sp)
    80002e7c:	6da2                	ld	s11,8(sp)
    80002e7e:	6165                	addi	sp,sp,112
    80002e80:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e82:	89d6                	mv	s3,s5
    80002e84:	bff1                	j	80002e60 <readi+0xce>
    return 0;
    80002e86:	4501                	li	a0,0
}
    80002e88:	8082                	ret

0000000080002e8a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e8a:	457c                	lw	a5,76(a0)
    80002e8c:	10d7e863          	bltu	a5,a3,80002f9c <writei+0x112>
{
    80002e90:	7159                	addi	sp,sp,-112
    80002e92:	f486                	sd	ra,104(sp)
    80002e94:	f0a2                	sd	s0,96(sp)
    80002e96:	eca6                	sd	s1,88(sp)
    80002e98:	e8ca                	sd	s2,80(sp)
    80002e9a:	e4ce                	sd	s3,72(sp)
    80002e9c:	e0d2                	sd	s4,64(sp)
    80002e9e:	fc56                	sd	s5,56(sp)
    80002ea0:	f85a                	sd	s6,48(sp)
    80002ea2:	f45e                	sd	s7,40(sp)
    80002ea4:	f062                	sd	s8,32(sp)
    80002ea6:	ec66                	sd	s9,24(sp)
    80002ea8:	e86a                	sd	s10,16(sp)
    80002eaa:	e46e                	sd	s11,8(sp)
    80002eac:	1880                	addi	s0,sp,112
    80002eae:	8aaa                	mv	s5,a0
    80002eb0:	8bae                	mv	s7,a1
    80002eb2:	8a32                	mv	s4,a2
    80002eb4:	8936                	mv	s2,a3
    80002eb6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eb8:	00e687bb          	addw	a5,a3,a4
    80002ebc:	0ed7e263          	bltu	a5,a3,80002fa0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ec0:	00043737          	lui	a4,0x43
    80002ec4:	0ef76063          	bltu	a4,a5,80002fa4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ec8:	0c0b0863          	beqz	s6,80002f98 <writei+0x10e>
    80002ecc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ece:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ed2:	5c7d                	li	s8,-1
    80002ed4:	a091                	j	80002f18 <writei+0x8e>
    80002ed6:	020d1d93          	slli	s11,s10,0x20
    80002eda:	020ddd93          	srli	s11,s11,0x20
    80002ede:	05848513          	addi	a0,s1,88
    80002ee2:	86ee                	mv	a3,s11
    80002ee4:	8652                	mv	a2,s4
    80002ee6:	85de                	mv	a1,s7
    80002ee8:	953a                	add	a0,a0,a4
    80002eea:	fffff097          	auipc	ra,0xfffff
    80002eee:	a6c080e7          	jalr	-1428(ra) # 80001956 <either_copyin>
    80002ef2:	07850263          	beq	a0,s8,80002f56 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ef6:	8526                	mv	a0,s1
    80002ef8:	00000097          	auipc	ra,0x0
    80002efc:	780080e7          	jalr	1920(ra) # 80003678 <log_write>
    brelse(bp);
    80002f00:	8526                	mv	a0,s1
    80002f02:	fffff097          	auipc	ra,0xfffff
    80002f06:	4f2080e7          	jalr	1266(ra) # 800023f4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f0a:	013d09bb          	addw	s3,s10,s3
    80002f0e:	012d093b          	addw	s2,s10,s2
    80002f12:	9a6e                	add	s4,s4,s11
    80002f14:	0569f663          	bgeu	s3,s6,80002f60 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f18:	00a9559b          	srliw	a1,s2,0xa
    80002f1c:	8556                	mv	a0,s5
    80002f1e:	fffff097          	auipc	ra,0xfffff
    80002f22:	7a0080e7          	jalr	1952(ra) # 800026be <bmap>
    80002f26:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f2a:	c99d                	beqz	a1,80002f60 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f2c:	000aa503          	lw	a0,0(s5)
    80002f30:	fffff097          	auipc	ra,0xfffff
    80002f34:	394080e7          	jalr	916(ra) # 800022c4 <bread>
    80002f38:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3a:	3ff97713          	andi	a4,s2,1023
    80002f3e:	40ec87bb          	subw	a5,s9,a4
    80002f42:	413b06bb          	subw	a3,s6,s3
    80002f46:	8d3e                	mv	s10,a5
    80002f48:	2781                	sext.w	a5,a5
    80002f4a:	0006861b          	sext.w	a2,a3
    80002f4e:	f8f674e3          	bgeu	a2,a5,80002ed6 <writei+0x4c>
    80002f52:	8d36                	mv	s10,a3
    80002f54:	b749                	j	80002ed6 <writei+0x4c>
      brelse(bp);
    80002f56:	8526                	mv	a0,s1
    80002f58:	fffff097          	auipc	ra,0xfffff
    80002f5c:	49c080e7          	jalr	1180(ra) # 800023f4 <brelse>
  }

  if(off > ip->size)
    80002f60:	04caa783          	lw	a5,76(s5)
    80002f64:	0127f463          	bgeu	a5,s2,80002f6c <writei+0xe2>
    ip->size = off;
    80002f68:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f6c:	8556                	mv	a0,s5
    80002f6e:	00000097          	auipc	ra,0x0
    80002f72:	aa6080e7          	jalr	-1370(ra) # 80002a14 <iupdate>

  return tot;
    80002f76:	0009851b          	sext.w	a0,s3
}
    80002f7a:	70a6                	ld	ra,104(sp)
    80002f7c:	7406                	ld	s0,96(sp)
    80002f7e:	64e6                	ld	s1,88(sp)
    80002f80:	6946                	ld	s2,80(sp)
    80002f82:	69a6                	ld	s3,72(sp)
    80002f84:	6a06                	ld	s4,64(sp)
    80002f86:	7ae2                	ld	s5,56(sp)
    80002f88:	7b42                	ld	s6,48(sp)
    80002f8a:	7ba2                	ld	s7,40(sp)
    80002f8c:	7c02                	ld	s8,32(sp)
    80002f8e:	6ce2                	ld	s9,24(sp)
    80002f90:	6d42                	ld	s10,16(sp)
    80002f92:	6da2                	ld	s11,8(sp)
    80002f94:	6165                	addi	sp,sp,112
    80002f96:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f98:	89da                	mv	s3,s6
    80002f9a:	bfc9                	j	80002f6c <writei+0xe2>
    return -1;
    80002f9c:	557d                	li	a0,-1
}
    80002f9e:	8082                	ret
    return -1;
    80002fa0:	557d                	li	a0,-1
    80002fa2:	bfe1                	j	80002f7a <writei+0xf0>
    return -1;
    80002fa4:	557d                	li	a0,-1
    80002fa6:	bfd1                	j	80002f7a <writei+0xf0>

0000000080002fa8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fa8:	1141                	addi	sp,sp,-16
    80002faa:	e406                	sd	ra,8(sp)
    80002fac:	e022                	sd	s0,0(sp)
    80002fae:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fb0:	4639                	li	a2,14
    80002fb2:	ffffd097          	auipc	ra,0xffffd
    80002fb6:	29e080e7          	jalr	670(ra) # 80000250 <strncmp>
}
    80002fba:	60a2                	ld	ra,8(sp)
    80002fbc:	6402                	ld	s0,0(sp)
    80002fbe:	0141                	addi	sp,sp,16
    80002fc0:	8082                	ret

0000000080002fc2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fc2:	7139                	addi	sp,sp,-64
    80002fc4:	fc06                	sd	ra,56(sp)
    80002fc6:	f822                	sd	s0,48(sp)
    80002fc8:	f426                	sd	s1,40(sp)
    80002fca:	f04a                	sd	s2,32(sp)
    80002fcc:	ec4e                	sd	s3,24(sp)
    80002fce:	e852                	sd	s4,16(sp)
    80002fd0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fd2:	04451703          	lh	a4,68(a0)
    80002fd6:	4785                	li	a5,1
    80002fd8:	00f71a63          	bne	a4,a5,80002fec <dirlookup+0x2a>
    80002fdc:	892a                	mv	s2,a0
    80002fde:	89ae                	mv	s3,a1
    80002fe0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe2:	457c                	lw	a5,76(a0)
    80002fe4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fe6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe8:	e79d                	bnez	a5,80003016 <dirlookup+0x54>
    80002fea:	a8a5                	j	80003062 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002fec:	00005517          	auipc	a0,0x5
    80002ff0:	5cc50513          	addi	a0,a0,1484 # 800085b8 <syscalls+0x1e8>
    80002ff4:	00003097          	auipc	ra,0x3
    80002ff8:	bee080e7          	jalr	-1042(ra) # 80005be2 <panic>
      panic("dirlookup read");
    80002ffc:	00005517          	auipc	a0,0x5
    80003000:	5d450513          	addi	a0,a0,1492 # 800085d0 <syscalls+0x200>
    80003004:	00003097          	auipc	ra,0x3
    80003008:	bde080e7          	jalr	-1058(ra) # 80005be2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000300c:	24c1                	addiw	s1,s1,16
    8000300e:	04c92783          	lw	a5,76(s2)
    80003012:	04f4f763          	bgeu	s1,a5,80003060 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003016:	4741                	li	a4,16
    80003018:	86a6                	mv	a3,s1
    8000301a:	fc040613          	addi	a2,s0,-64
    8000301e:	4581                	li	a1,0
    80003020:	854a                	mv	a0,s2
    80003022:	00000097          	auipc	ra,0x0
    80003026:	d70080e7          	jalr	-656(ra) # 80002d92 <readi>
    8000302a:	47c1                	li	a5,16
    8000302c:	fcf518e3          	bne	a0,a5,80002ffc <dirlookup+0x3a>
    if(de.inum == 0)
    80003030:	fc045783          	lhu	a5,-64(s0)
    80003034:	dfe1                	beqz	a5,8000300c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003036:	fc240593          	addi	a1,s0,-62
    8000303a:	854e                	mv	a0,s3
    8000303c:	00000097          	auipc	ra,0x0
    80003040:	f6c080e7          	jalr	-148(ra) # 80002fa8 <namecmp>
    80003044:	f561                	bnez	a0,8000300c <dirlookup+0x4a>
      if(poff)
    80003046:	000a0463          	beqz	s4,8000304e <dirlookup+0x8c>
        *poff = off;
    8000304a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000304e:	fc045583          	lhu	a1,-64(s0)
    80003052:	00092503          	lw	a0,0(s2)
    80003056:	fffff097          	auipc	ra,0xfffff
    8000305a:	750080e7          	jalr	1872(ra) # 800027a6 <iget>
    8000305e:	a011                	j	80003062 <dirlookup+0xa0>
  return 0;
    80003060:	4501                	li	a0,0
}
    80003062:	70e2                	ld	ra,56(sp)
    80003064:	7442                	ld	s0,48(sp)
    80003066:	74a2                	ld	s1,40(sp)
    80003068:	7902                	ld	s2,32(sp)
    8000306a:	69e2                	ld	s3,24(sp)
    8000306c:	6a42                	ld	s4,16(sp)
    8000306e:	6121                	addi	sp,sp,64
    80003070:	8082                	ret

0000000080003072 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003072:	711d                	addi	sp,sp,-96
    80003074:	ec86                	sd	ra,88(sp)
    80003076:	e8a2                	sd	s0,80(sp)
    80003078:	e4a6                	sd	s1,72(sp)
    8000307a:	e0ca                	sd	s2,64(sp)
    8000307c:	fc4e                	sd	s3,56(sp)
    8000307e:	f852                	sd	s4,48(sp)
    80003080:	f456                	sd	s5,40(sp)
    80003082:	f05a                	sd	s6,32(sp)
    80003084:	ec5e                	sd	s7,24(sp)
    80003086:	e862                	sd	s8,16(sp)
    80003088:	e466                	sd	s9,8(sp)
    8000308a:	1080                	addi	s0,sp,96
    8000308c:	84aa                	mv	s1,a0
    8000308e:	8b2e                	mv	s6,a1
    80003090:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003092:	00054703          	lbu	a4,0(a0)
    80003096:	02f00793          	li	a5,47
    8000309a:	02f70363          	beq	a4,a5,800030c0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000309e:	ffffe097          	auipc	ra,0xffffe
    800030a2:	db6080e7          	jalr	-586(ra) # 80000e54 <myproc>
    800030a6:	15053503          	ld	a0,336(a0)
    800030aa:	00000097          	auipc	ra,0x0
    800030ae:	9f6080e7          	jalr	-1546(ra) # 80002aa0 <idup>
    800030b2:	89aa                	mv	s3,a0
  while(*path == '/')
    800030b4:	02f00913          	li	s2,47
  len = path - s;
    800030b8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800030ba:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030bc:	4c05                	li	s8,1
    800030be:	a865                	j	80003176 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800030c0:	4585                	li	a1,1
    800030c2:	4505                	li	a0,1
    800030c4:	fffff097          	auipc	ra,0xfffff
    800030c8:	6e2080e7          	jalr	1762(ra) # 800027a6 <iget>
    800030cc:	89aa                	mv	s3,a0
    800030ce:	b7dd                	j	800030b4 <namex+0x42>
      iunlockput(ip);
    800030d0:	854e                	mv	a0,s3
    800030d2:	00000097          	auipc	ra,0x0
    800030d6:	c6e080e7          	jalr	-914(ra) # 80002d40 <iunlockput>
      return 0;
    800030da:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030dc:	854e                	mv	a0,s3
    800030de:	60e6                	ld	ra,88(sp)
    800030e0:	6446                	ld	s0,80(sp)
    800030e2:	64a6                	ld	s1,72(sp)
    800030e4:	6906                	ld	s2,64(sp)
    800030e6:	79e2                	ld	s3,56(sp)
    800030e8:	7a42                	ld	s4,48(sp)
    800030ea:	7aa2                	ld	s5,40(sp)
    800030ec:	7b02                	ld	s6,32(sp)
    800030ee:	6be2                	ld	s7,24(sp)
    800030f0:	6c42                	ld	s8,16(sp)
    800030f2:	6ca2                	ld	s9,8(sp)
    800030f4:	6125                	addi	sp,sp,96
    800030f6:	8082                	ret
      iunlock(ip);
    800030f8:	854e                	mv	a0,s3
    800030fa:	00000097          	auipc	ra,0x0
    800030fe:	aa6080e7          	jalr	-1370(ra) # 80002ba0 <iunlock>
      return ip;
    80003102:	bfe9                	j	800030dc <namex+0x6a>
      iunlockput(ip);
    80003104:	854e                	mv	a0,s3
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	c3a080e7          	jalr	-966(ra) # 80002d40 <iunlockput>
      return 0;
    8000310e:	89d2                	mv	s3,s4
    80003110:	b7f1                	j	800030dc <namex+0x6a>
  len = path - s;
    80003112:	40b48633          	sub	a2,s1,a1
    80003116:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000311a:	094cd463          	bge	s9,s4,800031a2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000311e:	4639                	li	a2,14
    80003120:	8556                	mv	a0,s5
    80003122:	ffffd097          	auipc	ra,0xffffd
    80003126:	0b6080e7          	jalr	182(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000312a:	0004c783          	lbu	a5,0(s1)
    8000312e:	01279763          	bne	a5,s2,8000313c <namex+0xca>
    path++;
    80003132:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003134:	0004c783          	lbu	a5,0(s1)
    80003138:	ff278de3          	beq	a5,s2,80003132 <namex+0xc0>
    ilock(ip);
    8000313c:	854e                	mv	a0,s3
    8000313e:	00000097          	auipc	ra,0x0
    80003142:	9a0080e7          	jalr	-1632(ra) # 80002ade <ilock>
    if(ip->type != T_DIR){
    80003146:	04499783          	lh	a5,68(s3)
    8000314a:	f98793e3          	bne	a5,s8,800030d0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000314e:	000b0563          	beqz	s6,80003158 <namex+0xe6>
    80003152:	0004c783          	lbu	a5,0(s1)
    80003156:	d3cd                	beqz	a5,800030f8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003158:	865e                	mv	a2,s7
    8000315a:	85d6                	mv	a1,s5
    8000315c:	854e                	mv	a0,s3
    8000315e:	00000097          	auipc	ra,0x0
    80003162:	e64080e7          	jalr	-412(ra) # 80002fc2 <dirlookup>
    80003166:	8a2a                	mv	s4,a0
    80003168:	dd51                	beqz	a0,80003104 <namex+0x92>
    iunlockput(ip);
    8000316a:	854e                	mv	a0,s3
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	bd4080e7          	jalr	-1068(ra) # 80002d40 <iunlockput>
    ip = next;
    80003174:	89d2                	mv	s3,s4
  while(*path == '/')
    80003176:	0004c783          	lbu	a5,0(s1)
    8000317a:	05279763          	bne	a5,s2,800031c8 <namex+0x156>
    path++;
    8000317e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003180:	0004c783          	lbu	a5,0(s1)
    80003184:	ff278de3          	beq	a5,s2,8000317e <namex+0x10c>
  if(*path == 0)
    80003188:	c79d                	beqz	a5,800031b6 <namex+0x144>
    path++;
    8000318a:	85a6                	mv	a1,s1
  len = path - s;
    8000318c:	8a5e                	mv	s4,s7
    8000318e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003190:	01278963          	beq	a5,s2,800031a2 <namex+0x130>
    80003194:	dfbd                	beqz	a5,80003112 <namex+0xa0>
    path++;
    80003196:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003198:	0004c783          	lbu	a5,0(s1)
    8000319c:	ff279ce3          	bne	a5,s2,80003194 <namex+0x122>
    800031a0:	bf8d                	j	80003112 <namex+0xa0>
    memmove(name, s, len);
    800031a2:	2601                	sext.w	a2,a2
    800031a4:	8556                	mv	a0,s5
    800031a6:	ffffd097          	auipc	ra,0xffffd
    800031aa:	032080e7          	jalr	50(ra) # 800001d8 <memmove>
    name[len] = 0;
    800031ae:	9a56                	add	s4,s4,s5
    800031b0:	000a0023          	sb	zero,0(s4)
    800031b4:	bf9d                	j	8000312a <namex+0xb8>
  if(nameiparent){
    800031b6:	f20b03e3          	beqz	s6,800030dc <namex+0x6a>
    iput(ip);
    800031ba:	854e                	mv	a0,s3
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	adc080e7          	jalr	-1316(ra) # 80002c98 <iput>
    return 0;
    800031c4:	4981                	li	s3,0
    800031c6:	bf19                	j	800030dc <namex+0x6a>
  if(*path == 0)
    800031c8:	d7fd                	beqz	a5,800031b6 <namex+0x144>
  while(*path != '/' && *path != 0)
    800031ca:	0004c783          	lbu	a5,0(s1)
    800031ce:	85a6                	mv	a1,s1
    800031d0:	b7d1                	j	80003194 <namex+0x122>

00000000800031d2 <dirlink>:
{
    800031d2:	7139                	addi	sp,sp,-64
    800031d4:	fc06                	sd	ra,56(sp)
    800031d6:	f822                	sd	s0,48(sp)
    800031d8:	f426                	sd	s1,40(sp)
    800031da:	f04a                	sd	s2,32(sp)
    800031dc:	ec4e                	sd	s3,24(sp)
    800031de:	e852                	sd	s4,16(sp)
    800031e0:	0080                	addi	s0,sp,64
    800031e2:	892a                	mv	s2,a0
    800031e4:	8a2e                	mv	s4,a1
    800031e6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031e8:	4601                	li	a2,0
    800031ea:	00000097          	auipc	ra,0x0
    800031ee:	dd8080e7          	jalr	-552(ra) # 80002fc2 <dirlookup>
    800031f2:	e93d                	bnez	a0,80003268 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f4:	04c92483          	lw	s1,76(s2)
    800031f8:	c49d                	beqz	s1,80003226 <dirlink+0x54>
    800031fa:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031fc:	4741                	li	a4,16
    800031fe:	86a6                	mv	a3,s1
    80003200:	fc040613          	addi	a2,s0,-64
    80003204:	4581                	li	a1,0
    80003206:	854a                	mv	a0,s2
    80003208:	00000097          	auipc	ra,0x0
    8000320c:	b8a080e7          	jalr	-1142(ra) # 80002d92 <readi>
    80003210:	47c1                	li	a5,16
    80003212:	06f51163          	bne	a0,a5,80003274 <dirlink+0xa2>
    if(de.inum == 0)
    80003216:	fc045783          	lhu	a5,-64(s0)
    8000321a:	c791                	beqz	a5,80003226 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000321c:	24c1                	addiw	s1,s1,16
    8000321e:	04c92783          	lw	a5,76(s2)
    80003222:	fcf4ede3          	bltu	s1,a5,800031fc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003226:	4639                	li	a2,14
    80003228:	85d2                	mv	a1,s4
    8000322a:	fc240513          	addi	a0,s0,-62
    8000322e:	ffffd097          	auipc	ra,0xffffd
    80003232:	05e080e7          	jalr	94(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003236:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000323a:	4741                	li	a4,16
    8000323c:	86a6                	mv	a3,s1
    8000323e:	fc040613          	addi	a2,s0,-64
    80003242:	4581                	li	a1,0
    80003244:	854a                	mv	a0,s2
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	c44080e7          	jalr	-956(ra) # 80002e8a <writei>
    8000324e:	1541                	addi	a0,a0,-16
    80003250:	00a03533          	snez	a0,a0
    80003254:	40a00533          	neg	a0,a0
}
    80003258:	70e2                	ld	ra,56(sp)
    8000325a:	7442                	ld	s0,48(sp)
    8000325c:	74a2                	ld	s1,40(sp)
    8000325e:	7902                	ld	s2,32(sp)
    80003260:	69e2                	ld	s3,24(sp)
    80003262:	6a42                	ld	s4,16(sp)
    80003264:	6121                	addi	sp,sp,64
    80003266:	8082                	ret
    iput(ip);
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	a30080e7          	jalr	-1488(ra) # 80002c98 <iput>
    return -1;
    80003270:	557d                	li	a0,-1
    80003272:	b7dd                	j	80003258 <dirlink+0x86>
      panic("dirlink read");
    80003274:	00005517          	auipc	a0,0x5
    80003278:	36c50513          	addi	a0,a0,876 # 800085e0 <syscalls+0x210>
    8000327c:	00003097          	auipc	ra,0x3
    80003280:	966080e7          	jalr	-1690(ra) # 80005be2 <panic>

0000000080003284 <namei>:

struct inode*
namei(char *path)
{
    80003284:	1101                	addi	sp,sp,-32
    80003286:	ec06                	sd	ra,24(sp)
    80003288:	e822                	sd	s0,16(sp)
    8000328a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000328c:	fe040613          	addi	a2,s0,-32
    80003290:	4581                	li	a1,0
    80003292:	00000097          	auipc	ra,0x0
    80003296:	de0080e7          	jalr	-544(ra) # 80003072 <namex>
}
    8000329a:	60e2                	ld	ra,24(sp)
    8000329c:	6442                	ld	s0,16(sp)
    8000329e:	6105                	addi	sp,sp,32
    800032a0:	8082                	ret

00000000800032a2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032a2:	1141                	addi	sp,sp,-16
    800032a4:	e406                	sd	ra,8(sp)
    800032a6:	e022                	sd	s0,0(sp)
    800032a8:	0800                	addi	s0,sp,16
    800032aa:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032ac:	4585                	li	a1,1
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	dc4080e7          	jalr	-572(ra) # 80003072 <namex>
}
    800032b6:	60a2                	ld	ra,8(sp)
    800032b8:	6402                	ld	s0,0(sp)
    800032ba:	0141                	addi	sp,sp,16
    800032bc:	8082                	ret

00000000800032be <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032be:	1101                	addi	sp,sp,-32
    800032c0:	ec06                	sd	ra,24(sp)
    800032c2:	e822                	sd	s0,16(sp)
    800032c4:	e426                	sd	s1,8(sp)
    800032c6:	e04a                	sd	s2,0(sp)
    800032c8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032ca:	00015917          	auipc	s2,0x15
    800032ce:	65690913          	addi	s2,s2,1622 # 80018920 <log>
    800032d2:	01892583          	lw	a1,24(s2)
    800032d6:	02892503          	lw	a0,40(s2)
    800032da:	fffff097          	auipc	ra,0xfffff
    800032de:	fea080e7          	jalr	-22(ra) # 800022c4 <bread>
    800032e2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032e4:	02c92683          	lw	a3,44(s2)
    800032e8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032ea:	02d05763          	blez	a3,80003318 <write_head+0x5a>
    800032ee:	00015797          	auipc	a5,0x15
    800032f2:	66278793          	addi	a5,a5,1634 # 80018950 <log+0x30>
    800032f6:	05c50713          	addi	a4,a0,92
    800032fa:	36fd                	addiw	a3,a3,-1
    800032fc:	1682                	slli	a3,a3,0x20
    800032fe:	9281                	srli	a3,a3,0x20
    80003300:	068a                	slli	a3,a3,0x2
    80003302:	00015617          	auipc	a2,0x15
    80003306:	65260613          	addi	a2,a2,1618 # 80018954 <log+0x34>
    8000330a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000330c:	4390                	lw	a2,0(a5)
    8000330e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003310:	0791                	addi	a5,a5,4
    80003312:	0711                	addi	a4,a4,4
    80003314:	fed79ce3          	bne	a5,a3,8000330c <write_head+0x4e>
  }
  bwrite(buf);
    80003318:	8526                	mv	a0,s1
    8000331a:	fffff097          	auipc	ra,0xfffff
    8000331e:	09c080e7          	jalr	156(ra) # 800023b6 <bwrite>
  brelse(buf);
    80003322:	8526                	mv	a0,s1
    80003324:	fffff097          	auipc	ra,0xfffff
    80003328:	0d0080e7          	jalr	208(ra) # 800023f4 <brelse>
}
    8000332c:	60e2                	ld	ra,24(sp)
    8000332e:	6442                	ld	s0,16(sp)
    80003330:	64a2                	ld	s1,8(sp)
    80003332:	6902                	ld	s2,0(sp)
    80003334:	6105                	addi	sp,sp,32
    80003336:	8082                	ret

0000000080003338 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003338:	00015797          	auipc	a5,0x15
    8000333c:	6147a783          	lw	a5,1556(a5) # 8001894c <log+0x2c>
    80003340:	0af05d63          	blez	a5,800033fa <install_trans+0xc2>
{
    80003344:	7139                	addi	sp,sp,-64
    80003346:	fc06                	sd	ra,56(sp)
    80003348:	f822                	sd	s0,48(sp)
    8000334a:	f426                	sd	s1,40(sp)
    8000334c:	f04a                	sd	s2,32(sp)
    8000334e:	ec4e                	sd	s3,24(sp)
    80003350:	e852                	sd	s4,16(sp)
    80003352:	e456                	sd	s5,8(sp)
    80003354:	e05a                	sd	s6,0(sp)
    80003356:	0080                	addi	s0,sp,64
    80003358:	8b2a                	mv	s6,a0
    8000335a:	00015a97          	auipc	s5,0x15
    8000335e:	5f6a8a93          	addi	s5,s5,1526 # 80018950 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003362:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003364:	00015997          	auipc	s3,0x15
    80003368:	5bc98993          	addi	s3,s3,1468 # 80018920 <log>
    8000336c:	a035                	j	80003398 <install_trans+0x60>
      bunpin(dbuf);
    8000336e:	8526                	mv	a0,s1
    80003370:	fffff097          	auipc	ra,0xfffff
    80003374:	15e080e7          	jalr	350(ra) # 800024ce <bunpin>
    brelse(lbuf);
    80003378:	854a                	mv	a0,s2
    8000337a:	fffff097          	auipc	ra,0xfffff
    8000337e:	07a080e7          	jalr	122(ra) # 800023f4 <brelse>
    brelse(dbuf);
    80003382:	8526                	mv	a0,s1
    80003384:	fffff097          	auipc	ra,0xfffff
    80003388:	070080e7          	jalr	112(ra) # 800023f4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000338c:	2a05                	addiw	s4,s4,1
    8000338e:	0a91                	addi	s5,s5,4
    80003390:	02c9a783          	lw	a5,44(s3)
    80003394:	04fa5963          	bge	s4,a5,800033e6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003398:	0189a583          	lw	a1,24(s3)
    8000339c:	014585bb          	addw	a1,a1,s4
    800033a0:	2585                	addiw	a1,a1,1
    800033a2:	0289a503          	lw	a0,40(s3)
    800033a6:	fffff097          	auipc	ra,0xfffff
    800033aa:	f1e080e7          	jalr	-226(ra) # 800022c4 <bread>
    800033ae:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033b0:	000aa583          	lw	a1,0(s5)
    800033b4:	0289a503          	lw	a0,40(s3)
    800033b8:	fffff097          	auipc	ra,0xfffff
    800033bc:	f0c080e7          	jalr	-244(ra) # 800022c4 <bread>
    800033c0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033c2:	40000613          	li	a2,1024
    800033c6:	05890593          	addi	a1,s2,88
    800033ca:	05850513          	addi	a0,a0,88
    800033ce:	ffffd097          	auipc	ra,0xffffd
    800033d2:	e0a080e7          	jalr	-502(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033d6:	8526                	mv	a0,s1
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	fde080e7          	jalr	-34(ra) # 800023b6 <bwrite>
    if(recovering == 0)
    800033e0:	f80b1ce3          	bnez	s6,80003378 <install_trans+0x40>
    800033e4:	b769                	j	8000336e <install_trans+0x36>
}
    800033e6:	70e2                	ld	ra,56(sp)
    800033e8:	7442                	ld	s0,48(sp)
    800033ea:	74a2                	ld	s1,40(sp)
    800033ec:	7902                	ld	s2,32(sp)
    800033ee:	69e2                	ld	s3,24(sp)
    800033f0:	6a42                	ld	s4,16(sp)
    800033f2:	6aa2                	ld	s5,8(sp)
    800033f4:	6b02                	ld	s6,0(sp)
    800033f6:	6121                	addi	sp,sp,64
    800033f8:	8082                	ret
    800033fa:	8082                	ret

00000000800033fc <initlog>:
{
    800033fc:	7179                	addi	sp,sp,-48
    800033fe:	f406                	sd	ra,40(sp)
    80003400:	f022                	sd	s0,32(sp)
    80003402:	ec26                	sd	s1,24(sp)
    80003404:	e84a                	sd	s2,16(sp)
    80003406:	e44e                	sd	s3,8(sp)
    80003408:	1800                	addi	s0,sp,48
    8000340a:	892a                	mv	s2,a0
    8000340c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000340e:	00015497          	auipc	s1,0x15
    80003412:	51248493          	addi	s1,s1,1298 # 80018920 <log>
    80003416:	00005597          	auipc	a1,0x5
    8000341a:	1da58593          	addi	a1,a1,474 # 800085f0 <syscalls+0x220>
    8000341e:	8526                	mv	a0,s1
    80003420:	00003097          	auipc	ra,0x3
    80003424:	c7c080e7          	jalr	-900(ra) # 8000609c <initlock>
  log.start = sb->logstart;
    80003428:	0149a583          	lw	a1,20(s3)
    8000342c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000342e:	0109a783          	lw	a5,16(s3)
    80003432:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003434:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003438:	854a                	mv	a0,s2
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	e8a080e7          	jalr	-374(ra) # 800022c4 <bread>
  log.lh.n = lh->n;
    80003442:	4d3c                	lw	a5,88(a0)
    80003444:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003446:	02f05563          	blez	a5,80003470 <initlog+0x74>
    8000344a:	05c50713          	addi	a4,a0,92
    8000344e:	00015697          	auipc	a3,0x15
    80003452:	50268693          	addi	a3,a3,1282 # 80018950 <log+0x30>
    80003456:	37fd                	addiw	a5,a5,-1
    80003458:	1782                	slli	a5,a5,0x20
    8000345a:	9381                	srli	a5,a5,0x20
    8000345c:	078a                	slli	a5,a5,0x2
    8000345e:	06050613          	addi	a2,a0,96
    80003462:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003464:	4310                	lw	a2,0(a4)
    80003466:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003468:	0711                	addi	a4,a4,4
    8000346a:	0691                	addi	a3,a3,4
    8000346c:	fef71ce3          	bne	a4,a5,80003464 <initlog+0x68>
  brelse(buf);
    80003470:	fffff097          	auipc	ra,0xfffff
    80003474:	f84080e7          	jalr	-124(ra) # 800023f4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003478:	4505                	li	a0,1
    8000347a:	00000097          	auipc	ra,0x0
    8000347e:	ebe080e7          	jalr	-322(ra) # 80003338 <install_trans>
  log.lh.n = 0;
    80003482:	00015797          	auipc	a5,0x15
    80003486:	4c07a523          	sw	zero,1226(a5) # 8001894c <log+0x2c>
  write_head(); // clear the log
    8000348a:	00000097          	auipc	ra,0x0
    8000348e:	e34080e7          	jalr	-460(ra) # 800032be <write_head>
}
    80003492:	70a2                	ld	ra,40(sp)
    80003494:	7402                	ld	s0,32(sp)
    80003496:	64e2                	ld	s1,24(sp)
    80003498:	6942                	ld	s2,16(sp)
    8000349a:	69a2                	ld	s3,8(sp)
    8000349c:	6145                	addi	sp,sp,48
    8000349e:	8082                	ret

00000000800034a0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034a0:	1101                	addi	sp,sp,-32
    800034a2:	ec06                	sd	ra,24(sp)
    800034a4:	e822                	sd	s0,16(sp)
    800034a6:	e426                	sd	s1,8(sp)
    800034a8:	e04a                	sd	s2,0(sp)
    800034aa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034ac:	00015517          	auipc	a0,0x15
    800034b0:	47450513          	addi	a0,a0,1140 # 80018920 <log>
    800034b4:	00003097          	auipc	ra,0x3
    800034b8:	c78080e7          	jalr	-904(ra) # 8000612c <acquire>
  while(1){
    if(log.committing){
    800034bc:	00015497          	auipc	s1,0x15
    800034c0:	46448493          	addi	s1,s1,1124 # 80018920 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034c4:	4979                	li	s2,30
    800034c6:	a039                	j	800034d4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034c8:	85a6                	mv	a1,s1
    800034ca:	8526                	mv	a0,s1
    800034cc:	ffffe097          	auipc	ra,0xffffe
    800034d0:	02c080e7          	jalr	44(ra) # 800014f8 <sleep>
    if(log.committing){
    800034d4:	50dc                	lw	a5,36(s1)
    800034d6:	fbed                	bnez	a5,800034c8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034d8:	509c                	lw	a5,32(s1)
    800034da:	0017871b          	addiw	a4,a5,1
    800034de:	0007069b          	sext.w	a3,a4
    800034e2:	0027179b          	slliw	a5,a4,0x2
    800034e6:	9fb9                	addw	a5,a5,a4
    800034e8:	0017979b          	slliw	a5,a5,0x1
    800034ec:	54d8                	lw	a4,44(s1)
    800034ee:	9fb9                	addw	a5,a5,a4
    800034f0:	00f95963          	bge	s2,a5,80003502 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034f4:	85a6                	mv	a1,s1
    800034f6:	8526                	mv	a0,s1
    800034f8:	ffffe097          	auipc	ra,0xffffe
    800034fc:	000080e7          	jalr	ra # 800014f8 <sleep>
    80003500:	bfd1                	j	800034d4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003502:	00015517          	auipc	a0,0x15
    80003506:	41e50513          	addi	a0,a0,1054 # 80018920 <log>
    8000350a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000350c:	00003097          	auipc	ra,0x3
    80003510:	cd4080e7          	jalr	-812(ra) # 800061e0 <release>
      break;
    }
  }
}
    80003514:	60e2                	ld	ra,24(sp)
    80003516:	6442                	ld	s0,16(sp)
    80003518:	64a2                	ld	s1,8(sp)
    8000351a:	6902                	ld	s2,0(sp)
    8000351c:	6105                	addi	sp,sp,32
    8000351e:	8082                	ret

0000000080003520 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003520:	7139                	addi	sp,sp,-64
    80003522:	fc06                	sd	ra,56(sp)
    80003524:	f822                	sd	s0,48(sp)
    80003526:	f426                	sd	s1,40(sp)
    80003528:	f04a                	sd	s2,32(sp)
    8000352a:	ec4e                	sd	s3,24(sp)
    8000352c:	e852                	sd	s4,16(sp)
    8000352e:	e456                	sd	s5,8(sp)
    80003530:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003532:	00015497          	auipc	s1,0x15
    80003536:	3ee48493          	addi	s1,s1,1006 # 80018920 <log>
    8000353a:	8526                	mv	a0,s1
    8000353c:	00003097          	auipc	ra,0x3
    80003540:	bf0080e7          	jalr	-1040(ra) # 8000612c <acquire>
  log.outstanding -= 1;
    80003544:	509c                	lw	a5,32(s1)
    80003546:	37fd                	addiw	a5,a5,-1
    80003548:	0007891b          	sext.w	s2,a5
    8000354c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000354e:	50dc                	lw	a5,36(s1)
    80003550:	efb9                	bnez	a5,800035ae <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003552:	06091663          	bnez	s2,800035be <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003556:	00015497          	auipc	s1,0x15
    8000355a:	3ca48493          	addi	s1,s1,970 # 80018920 <log>
    8000355e:	4785                	li	a5,1
    80003560:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003562:	8526                	mv	a0,s1
    80003564:	00003097          	auipc	ra,0x3
    80003568:	c7c080e7          	jalr	-900(ra) # 800061e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000356c:	54dc                	lw	a5,44(s1)
    8000356e:	06f04763          	bgtz	a5,800035dc <end_op+0xbc>
    acquire(&log.lock);
    80003572:	00015497          	auipc	s1,0x15
    80003576:	3ae48493          	addi	s1,s1,942 # 80018920 <log>
    8000357a:	8526                	mv	a0,s1
    8000357c:	00003097          	auipc	ra,0x3
    80003580:	bb0080e7          	jalr	-1104(ra) # 8000612c <acquire>
    log.committing = 0;
    80003584:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003588:	8526                	mv	a0,s1
    8000358a:	ffffe097          	auipc	ra,0xffffe
    8000358e:	fd2080e7          	jalr	-46(ra) # 8000155c <wakeup>
    release(&log.lock);
    80003592:	8526                	mv	a0,s1
    80003594:	00003097          	auipc	ra,0x3
    80003598:	c4c080e7          	jalr	-948(ra) # 800061e0 <release>
}
    8000359c:	70e2                	ld	ra,56(sp)
    8000359e:	7442                	ld	s0,48(sp)
    800035a0:	74a2                	ld	s1,40(sp)
    800035a2:	7902                	ld	s2,32(sp)
    800035a4:	69e2                	ld	s3,24(sp)
    800035a6:	6a42                	ld	s4,16(sp)
    800035a8:	6aa2                	ld	s5,8(sp)
    800035aa:	6121                	addi	sp,sp,64
    800035ac:	8082                	ret
    panic("log.committing");
    800035ae:	00005517          	auipc	a0,0x5
    800035b2:	04a50513          	addi	a0,a0,74 # 800085f8 <syscalls+0x228>
    800035b6:	00002097          	auipc	ra,0x2
    800035ba:	62c080e7          	jalr	1580(ra) # 80005be2 <panic>
    wakeup(&log);
    800035be:	00015497          	auipc	s1,0x15
    800035c2:	36248493          	addi	s1,s1,866 # 80018920 <log>
    800035c6:	8526                	mv	a0,s1
    800035c8:	ffffe097          	auipc	ra,0xffffe
    800035cc:	f94080e7          	jalr	-108(ra) # 8000155c <wakeup>
  release(&log.lock);
    800035d0:	8526                	mv	a0,s1
    800035d2:	00003097          	auipc	ra,0x3
    800035d6:	c0e080e7          	jalr	-1010(ra) # 800061e0 <release>
  if(do_commit){
    800035da:	b7c9                	j	8000359c <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035dc:	00015a97          	auipc	s5,0x15
    800035e0:	374a8a93          	addi	s5,s5,884 # 80018950 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035e4:	00015a17          	auipc	s4,0x15
    800035e8:	33ca0a13          	addi	s4,s4,828 # 80018920 <log>
    800035ec:	018a2583          	lw	a1,24(s4)
    800035f0:	012585bb          	addw	a1,a1,s2
    800035f4:	2585                	addiw	a1,a1,1
    800035f6:	028a2503          	lw	a0,40(s4)
    800035fa:	fffff097          	auipc	ra,0xfffff
    800035fe:	cca080e7          	jalr	-822(ra) # 800022c4 <bread>
    80003602:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003604:	000aa583          	lw	a1,0(s5)
    80003608:	028a2503          	lw	a0,40(s4)
    8000360c:	fffff097          	auipc	ra,0xfffff
    80003610:	cb8080e7          	jalr	-840(ra) # 800022c4 <bread>
    80003614:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003616:	40000613          	li	a2,1024
    8000361a:	05850593          	addi	a1,a0,88
    8000361e:	05848513          	addi	a0,s1,88
    80003622:	ffffd097          	auipc	ra,0xffffd
    80003626:	bb6080e7          	jalr	-1098(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000362a:	8526                	mv	a0,s1
    8000362c:	fffff097          	auipc	ra,0xfffff
    80003630:	d8a080e7          	jalr	-630(ra) # 800023b6 <bwrite>
    brelse(from);
    80003634:	854e                	mv	a0,s3
    80003636:	fffff097          	auipc	ra,0xfffff
    8000363a:	dbe080e7          	jalr	-578(ra) # 800023f4 <brelse>
    brelse(to);
    8000363e:	8526                	mv	a0,s1
    80003640:	fffff097          	auipc	ra,0xfffff
    80003644:	db4080e7          	jalr	-588(ra) # 800023f4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003648:	2905                	addiw	s2,s2,1
    8000364a:	0a91                	addi	s5,s5,4
    8000364c:	02ca2783          	lw	a5,44(s4)
    80003650:	f8f94ee3          	blt	s2,a5,800035ec <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003654:	00000097          	auipc	ra,0x0
    80003658:	c6a080e7          	jalr	-918(ra) # 800032be <write_head>
    install_trans(0); // Now install writes to home locations
    8000365c:	4501                	li	a0,0
    8000365e:	00000097          	auipc	ra,0x0
    80003662:	cda080e7          	jalr	-806(ra) # 80003338 <install_trans>
    log.lh.n = 0;
    80003666:	00015797          	auipc	a5,0x15
    8000366a:	2e07a323          	sw	zero,742(a5) # 8001894c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000366e:	00000097          	auipc	ra,0x0
    80003672:	c50080e7          	jalr	-944(ra) # 800032be <write_head>
    80003676:	bdf5                	j	80003572 <end_op+0x52>

0000000080003678 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003678:	1101                	addi	sp,sp,-32
    8000367a:	ec06                	sd	ra,24(sp)
    8000367c:	e822                	sd	s0,16(sp)
    8000367e:	e426                	sd	s1,8(sp)
    80003680:	e04a                	sd	s2,0(sp)
    80003682:	1000                	addi	s0,sp,32
    80003684:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003686:	00015917          	auipc	s2,0x15
    8000368a:	29a90913          	addi	s2,s2,666 # 80018920 <log>
    8000368e:	854a                	mv	a0,s2
    80003690:	00003097          	auipc	ra,0x3
    80003694:	a9c080e7          	jalr	-1380(ra) # 8000612c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003698:	02c92603          	lw	a2,44(s2)
    8000369c:	47f5                	li	a5,29
    8000369e:	06c7c563          	blt	a5,a2,80003708 <log_write+0x90>
    800036a2:	00015797          	auipc	a5,0x15
    800036a6:	29a7a783          	lw	a5,666(a5) # 8001893c <log+0x1c>
    800036aa:	37fd                	addiw	a5,a5,-1
    800036ac:	04f65e63          	bge	a2,a5,80003708 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036b0:	00015797          	auipc	a5,0x15
    800036b4:	2907a783          	lw	a5,656(a5) # 80018940 <log+0x20>
    800036b8:	06f05063          	blez	a5,80003718 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036bc:	4781                	li	a5,0
    800036be:	06c05563          	blez	a2,80003728 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036c2:	44cc                	lw	a1,12(s1)
    800036c4:	00015717          	auipc	a4,0x15
    800036c8:	28c70713          	addi	a4,a4,652 # 80018950 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036cc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036ce:	4314                	lw	a3,0(a4)
    800036d0:	04b68c63          	beq	a3,a1,80003728 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036d4:	2785                	addiw	a5,a5,1
    800036d6:	0711                	addi	a4,a4,4
    800036d8:	fef61be3          	bne	a2,a5,800036ce <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036dc:	0621                	addi	a2,a2,8
    800036de:	060a                	slli	a2,a2,0x2
    800036e0:	00015797          	auipc	a5,0x15
    800036e4:	24078793          	addi	a5,a5,576 # 80018920 <log>
    800036e8:	963e                	add	a2,a2,a5
    800036ea:	44dc                	lw	a5,12(s1)
    800036ec:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036ee:	8526                	mv	a0,s1
    800036f0:	fffff097          	auipc	ra,0xfffff
    800036f4:	da2080e7          	jalr	-606(ra) # 80002492 <bpin>
    log.lh.n++;
    800036f8:	00015717          	auipc	a4,0x15
    800036fc:	22870713          	addi	a4,a4,552 # 80018920 <log>
    80003700:	575c                	lw	a5,44(a4)
    80003702:	2785                	addiw	a5,a5,1
    80003704:	d75c                	sw	a5,44(a4)
    80003706:	a835                	j	80003742 <log_write+0xca>
    panic("too big a transaction");
    80003708:	00005517          	auipc	a0,0x5
    8000370c:	f0050513          	addi	a0,a0,-256 # 80008608 <syscalls+0x238>
    80003710:	00002097          	auipc	ra,0x2
    80003714:	4d2080e7          	jalr	1234(ra) # 80005be2 <panic>
    panic("log_write outside of trans");
    80003718:	00005517          	auipc	a0,0x5
    8000371c:	f0850513          	addi	a0,a0,-248 # 80008620 <syscalls+0x250>
    80003720:	00002097          	auipc	ra,0x2
    80003724:	4c2080e7          	jalr	1218(ra) # 80005be2 <panic>
  log.lh.block[i] = b->blockno;
    80003728:	00878713          	addi	a4,a5,8
    8000372c:	00271693          	slli	a3,a4,0x2
    80003730:	00015717          	auipc	a4,0x15
    80003734:	1f070713          	addi	a4,a4,496 # 80018920 <log>
    80003738:	9736                	add	a4,a4,a3
    8000373a:	44d4                	lw	a3,12(s1)
    8000373c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000373e:	faf608e3          	beq	a2,a5,800036ee <log_write+0x76>
  }
  release(&log.lock);
    80003742:	00015517          	auipc	a0,0x15
    80003746:	1de50513          	addi	a0,a0,478 # 80018920 <log>
    8000374a:	00003097          	auipc	ra,0x3
    8000374e:	a96080e7          	jalr	-1386(ra) # 800061e0 <release>
}
    80003752:	60e2                	ld	ra,24(sp)
    80003754:	6442                	ld	s0,16(sp)
    80003756:	64a2                	ld	s1,8(sp)
    80003758:	6902                	ld	s2,0(sp)
    8000375a:	6105                	addi	sp,sp,32
    8000375c:	8082                	ret

000000008000375e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000375e:	1101                	addi	sp,sp,-32
    80003760:	ec06                	sd	ra,24(sp)
    80003762:	e822                	sd	s0,16(sp)
    80003764:	e426                	sd	s1,8(sp)
    80003766:	e04a                	sd	s2,0(sp)
    80003768:	1000                	addi	s0,sp,32
    8000376a:	84aa                	mv	s1,a0
    8000376c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000376e:	00005597          	auipc	a1,0x5
    80003772:	ed258593          	addi	a1,a1,-302 # 80008640 <syscalls+0x270>
    80003776:	0521                	addi	a0,a0,8
    80003778:	00003097          	auipc	ra,0x3
    8000377c:	924080e7          	jalr	-1756(ra) # 8000609c <initlock>
  lk->name = name;
    80003780:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003784:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003788:	0204a423          	sw	zero,40(s1)
}
    8000378c:	60e2                	ld	ra,24(sp)
    8000378e:	6442                	ld	s0,16(sp)
    80003790:	64a2                	ld	s1,8(sp)
    80003792:	6902                	ld	s2,0(sp)
    80003794:	6105                	addi	sp,sp,32
    80003796:	8082                	ret

0000000080003798 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003798:	1101                	addi	sp,sp,-32
    8000379a:	ec06                	sd	ra,24(sp)
    8000379c:	e822                	sd	s0,16(sp)
    8000379e:	e426                	sd	s1,8(sp)
    800037a0:	e04a                	sd	s2,0(sp)
    800037a2:	1000                	addi	s0,sp,32
    800037a4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037a6:	00850913          	addi	s2,a0,8
    800037aa:	854a                	mv	a0,s2
    800037ac:	00003097          	auipc	ra,0x3
    800037b0:	980080e7          	jalr	-1664(ra) # 8000612c <acquire>
  while (lk->locked) {
    800037b4:	409c                	lw	a5,0(s1)
    800037b6:	cb89                	beqz	a5,800037c8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037b8:	85ca                	mv	a1,s2
    800037ba:	8526                	mv	a0,s1
    800037bc:	ffffe097          	auipc	ra,0xffffe
    800037c0:	d3c080e7          	jalr	-708(ra) # 800014f8 <sleep>
  while (lk->locked) {
    800037c4:	409c                	lw	a5,0(s1)
    800037c6:	fbed                	bnez	a5,800037b8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037c8:	4785                	li	a5,1
    800037ca:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037cc:	ffffd097          	auipc	ra,0xffffd
    800037d0:	688080e7          	jalr	1672(ra) # 80000e54 <myproc>
    800037d4:	591c                	lw	a5,48(a0)
    800037d6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037d8:	854a                	mv	a0,s2
    800037da:	00003097          	auipc	ra,0x3
    800037de:	a06080e7          	jalr	-1530(ra) # 800061e0 <release>
}
    800037e2:	60e2                	ld	ra,24(sp)
    800037e4:	6442                	ld	s0,16(sp)
    800037e6:	64a2                	ld	s1,8(sp)
    800037e8:	6902                	ld	s2,0(sp)
    800037ea:	6105                	addi	sp,sp,32
    800037ec:	8082                	ret

00000000800037ee <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037ee:	1101                	addi	sp,sp,-32
    800037f0:	ec06                	sd	ra,24(sp)
    800037f2:	e822                	sd	s0,16(sp)
    800037f4:	e426                	sd	s1,8(sp)
    800037f6:	e04a                	sd	s2,0(sp)
    800037f8:	1000                	addi	s0,sp,32
    800037fa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037fc:	00850913          	addi	s2,a0,8
    80003800:	854a                	mv	a0,s2
    80003802:	00003097          	auipc	ra,0x3
    80003806:	92a080e7          	jalr	-1750(ra) # 8000612c <acquire>
  lk->locked = 0;
    8000380a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000380e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003812:	8526                	mv	a0,s1
    80003814:	ffffe097          	auipc	ra,0xffffe
    80003818:	d48080e7          	jalr	-696(ra) # 8000155c <wakeup>
  release(&lk->lk);
    8000381c:	854a                	mv	a0,s2
    8000381e:	00003097          	auipc	ra,0x3
    80003822:	9c2080e7          	jalr	-1598(ra) # 800061e0 <release>
}
    80003826:	60e2                	ld	ra,24(sp)
    80003828:	6442                	ld	s0,16(sp)
    8000382a:	64a2                	ld	s1,8(sp)
    8000382c:	6902                	ld	s2,0(sp)
    8000382e:	6105                	addi	sp,sp,32
    80003830:	8082                	ret

0000000080003832 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003832:	7179                	addi	sp,sp,-48
    80003834:	f406                	sd	ra,40(sp)
    80003836:	f022                	sd	s0,32(sp)
    80003838:	ec26                	sd	s1,24(sp)
    8000383a:	e84a                	sd	s2,16(sp)
    8000383c:	e44e                	sd	s3,8(sp)
    8000383e:	1800                	addi	s0,sp,48
    80003840:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003842:	00850913          	addi	s2,a0,8
    80003846:	854a                	mv	a0,s2
    80003848:	00003097          	auipc	ra,0x3
    8000384c:	8e4080e7          	jalr	-1820(ra) # 8000612c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003850:	409c                	lw	a5,0(s1)
    80003852:	ef99                	bnez	a5,80003870 <holdingsleep+0x3e>
    80003854:	4481                	li	s1,0
  release(&lk->lk);
    80003856:	854a                	mv	a0,s2
    80003858:	00003097          	auipc	ra,0x3
    8000385c:	988080e7          	jalr	-1656(ra) # 800061e0 <release>
  return r;
}
    80003860:	8526                	mv	a0,s1
    80003862:	70a2                	ld	ra,40(sp)
    80003864:	7402                	ld	s0,32(sp)
    80003866:	64e2                	ld	s1,24(sp)
    80003868:	6942                	ld	s2,16(sp)
    8000386a:	69a2                	ld	s3,8(sp)
    8000386c:	6145                	addi	sp,sp,48
    8000386e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003870:	0284a983          	lw	s3,40(s1)
    80003874:	ffffd097          	auipc	ra,0xffffd
    80003878:	5e0080e7          	jalr	1504(ra) # 80000e54 <myproc>
    8000387c:	5904                	lw	s1,48(a0)
    8000387e:	413484b3          	sub	s1,s1,s3
    80003882:	0014b493          	seqz	s1,s1
    80003886:	bfc1                	j	80003856 <holdingsleep+0x24>

0000000080003888 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003888:	1141                	addi	sp,sp,-16
    8000388a:	e406                	sd	ra,8(sp)
    8000388c:	e022                	sd	s0,0(sp)
    8000388e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003890:	00005597          	auipc	a1,0x5
    80003894:	dc058593          	addi	a1,a1,-576 # 80008650 <syscalls+0x280>
    80003898:	00015517          	auipc	a0,0x15
    8000389c:	1d050513          	addi	a0,a0,464 # 80018a68 <ftable>
    800038a0:	00002097          	auipc	ra,0x2
    800038a4:	7fc080e7          	jalr	2044(ra) # 8000609c <initlock>
}
    800038a8:	60a2                	ld	ra,8(sp)
    800038aa:	6402                	ld	s0,0(sp)
    800038ac:	0141                	addi	sp,sp,16
    800038ae:	8082                	ret

00000000800038b0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038b0:	1101                	addi	sp,sp,-32
    800038b2:	ec06                	sd	ra,24(sp)
    800038b4:	e822                	sd	s0,16(sp)
    800038b6:	e426                	sd	s1,8(sp)
    800038b8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038ba:	00015517          	auipc	a0,0x15
    800038be:	1ae50513          	addi	a0,a0,430 # 80018a68 <ftable>
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	86a080e7          	jalr	-1942(ra) # 8000612c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038ca:	00015497          	auipc	s1,0x15
    800038ce:	1b648493          	addi	s1,s1,438 # 80018a80 <ftable+0x18>
    800038d2:	00016717          	auipc	a4,0x16
    800038d6:	14e70713          	addi	a4,a4,334 # 80019a20 <disk>
    if(f->ref == 0){
    800038da:	40dc                	lw	a5,4(s1)
    800038dc:	cf99                	beqz	a5,800038fa <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038de:	02848493          	addi	s1,s1,40
    800038e2:	fee49ce3          	bne	s1,a4,800038da <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038e6:	00015517          	auipc	a0,0x15
    800038ea:	18250513          	addi	a0,a0,386 # 80018a68 <ftable>
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	8f2080e7          	jalr	-1806(ra) # 800061e0 <release>
  return 0;
    800038f6:	4481                	li	s1,0
    800038f8:	a819                	j	8000390e <filealloc+0x5e>
      f->ref = 1;
    800038fa:	4785                	li	a5,1
    800038fc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800038fe:	00015517          	auipc	a0,0x15
    80003902:	16a50513          	addi	a0,a0,362 # 80018a68 <ftable>
    80003906:	00003097          	auipc	ra,0x3
    8000390a:	8da080e7          	jalr	-1830(ra) # 800061e0 <release>
}
    8000390e:	8526                	mv	a0,s1
    80003910:	60e2                	ld	ra,24(sp)
    80003912:	6442                	ld	s0,16(sp)
    80003914:	64a2                	ld	s1,8(sp)
    80003916:	6105                	addi	sp,sp,32
    80003918:	8082                	ret

000000008000391a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000391a:	1101                	addi	sp,sp,-32
    8000391c:	ec06                	sd	ra,24(sp)
    8000391e:	e822                	sd	s0,16(sp)
    80003920:	e426                	sd	s1,8(sp)
    80003922:	1000                	addi	s0,sp,32
    80003924:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003926:	00015517          	auipc	a0,0x15
    8000392a:	14250513          	addi	a0,a0,322 # 80018a68 <ftable>
    8000392e:	00002097          	auipc	ra,0x2
    80003932:	7fe080e7          	jalr	2046(ra) # 8000612c <acquire>
  if(f->ref < 1)
    80003936:	40dc                	lw	a5,4(s1)
    80003938:	02f05263          	blez	a5,8000395c <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000393c:	2785                	addiw	a5,a5,1
    8000393e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003940:	00015517          	auipc	a0,0x15
    80003944:	12850513          	addi	a0,a0,296 # 80018a68 <ftable>
    80003948:	00003097          	auipc	ra,0x3
    8000394c:	898080e7          	jalr	-1896(ra) # 800061e0 <release>
  return f;
}
    80003950:	8526                	mv	a0,s1
    80003952:	60e2                	ld	ra,24(sp)
    80003954:	6442                	ld	s0,16(sp)
    80003956:	64a2                	ld	s1,8(sp)
    80003958:	6105                	addi	sp,sp,32
    8000395a:	8082                	ret
    panic("filedup");
    8000395c:	00005517          	auipc	a0,0x5
    80003960:	cfc50513          	addi	a0,a0,-772 # 80008658 <syscalls+0x288>
    80003964:	00002097          	auipc	ra,0x2
    80003968:	27e080e7          	jalr	638(ra) # 80005be2 <panic>

000000008000396c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000396c:	7139                	addi	sp,sp,-64
    8000396e:	fc06                	sd	ra,56(sp)
    80003970:	f822                	sd	s0,48(sp)
    80003972:	f426                	sd	s1,40(sp)
    80003974:	f04a                	sd	s2,32(sp)
    80003976:	ec4e                	sd	s3,24(sp)
    80003978:	e852                	sd	s4,16(sp)
    8000397a:	e456                	sd	s5,8(sp)
    8000397c:	0080                	addi	s0,sp,64
    8000397e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003980:	00015517          	auipc	a0,0x15
    80003984:	0e850513          	addi	a0,a0,232 # 80018a68 <ftable>
    80003988:	00002097          	auipc	ra,0x2
    8000398c:	7a4080e7          	jalr	1956(ra) # 8000612c <acquire>
  if(f->ref < 1)
    80003990:	40dc                	lw	a5,4(s1)
    80003992:	06f05163          	blez	a5,800039f4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003996:	37fd                	addiw	a5,a5,-1
    80003998:	0007871b          	sext.w	a4,a5
    8000399c:	c0dc                	sw	a5,4(s1)
    8000399e:	06e04363          	bgtz	a4,80003a04 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039a2:	0004a903          	lw	s2,0(s1)
    800039a6:	0094ca83          	lbu	s5,9(s1)
    800039aa:	0104ba03          	ld	s4,16(s1)
    800039ae:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039b2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039b6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039ba:	00015517          	auipc	a0,0x15
    800039be:	0ae50513          	addi	a0,a0,174 # 80018a68 <ftable>
    800039c2:	00003097          	auipc	ra,0x3
    800039c6:	81e080e7          	jalr	-2018(ra) # 800061e0 <release>

  if(ff.type == FD_PIPE){
    800039ca:	4785                	li	a5,1
    800039cc:	04f90d63          	beq	s2,a5,80003a26 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039d0:	3979                	addiw	s2,s2,-2
    800039d2:	4785                	li	a5,1
    800039d4:	0527e063          	bltu	a5,s2,80003a14 <fileclose+0xa8>
    begin_op();
    800039d8:	00000097          	auipc	ra,0x0
    800039dc:	ac8080e7          	jalr	-1336(ra) # 800034a0 <begin_op>
    iput(ff.ip);
    800039e0:	854e                	mv	a0,s3
    800039e2:	fffff097          	auipc	ra,0xfffff
    800039e6:	2b6080e7          	jalr	694(ra) # 80002c98 <iput>
    end_op();
    800039ea:	00000097          	auipc	ra,0x0
    800039ee:	b36080e7          	jalr	-1226(ra) # 80003520 <end_op>
    800039f2:	a00d                	j	80003a14 <fileclose+0xa8>
    panic("fileclose");
    800039f4:	00005517          	auipc	a0,0x5
    800039f8:	c6c50513          	addi	a0,a0,-916 # 80008660 <syscalls+0x290>
    800039fc:	00002097          	auipc	ra,0x2
    80003a00:	1e6080e7          	jalr	486(ra) # 80005be2 <panic>
    release(&ftable.lock);
    80003a04:	00015517          	auipc	a0,0x15
    80003a08:	06450513          	addi	a0,a0,100 # 80018a68 <ftable>
    80003a0c:	00002097          	auipc	ra,0x2
    80003a10:	7d4080e7          	jalr	2004(ra) # 800061e0 <release>
  }
}
    80003a14:	70e2                	ld	ra,56(sp)
    80003a16:	7442                	ld	s0,48(sp)
    80003a18:	74a2                	ld	s1,40(sp)
    80003a1a:	7902                	ld	s2,32(sp)
    80003a1c:	69e2                	ld	s3,24(sp)
    80003a1e:	6a42                	ld	s4,16(sp)
    80003a20:	6aa2                	ld	s5,8(sp)
    80003a22:	6121                	addi	sp,sp,64
    80003a24:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a26:	85d6                	mv	a1,s5
    80003a28:	8552                	mv	a0,s4
    80003a2a:	00000097          	auipc	ra,0x0
    80003a2e:	34c080e7          	jalr	844(ra) # 80003d76 <pipeclose>
    80003a32:	b7cd                	j	80003a14 <fileclose+0xa8>

0000000080003a34 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a34:	715d                	addi	sp,sp,-80
    80003a36:	e486                	sd	ra,72(sp)
    80003a38:	e0a2                	sd	s0,64(sp)
    80003a3a:	fc26                	sd	s1,56(sp)
    80003a3c:	f84a                	sd	s2,48(sp)
    80003a3e:	f44e                	sd	s3,40(sp)
    80003a40:	0880                	addi	s0,sp,80
    80003a42:	84aa                	mv	s1,a0
    80003a44:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a46:	ffffd097          	auipc	ra,0xffffd
    80003a4a:	40e080e7          	jalr	1038(ra) # 80000e54 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a4e:	409c                	lw	a5,0(s1)
    80003a50:	37f9                	addiw	a5,a5,-2
    80003a52:	4705                	li	a4,1
    80003a54:	04f76763          	bltu	a4,a5,80003aa2 <filestat+0x6e>
    80003a58:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a5a:	6c88                	ld	a0,24(s1)
    80003a5c:	fffff097          	auipc	ra,0xfffff
    80003a60:	082080e7          	jalr	130(ra) # 80002ade <ilock>
    stati(f->ip, &st);
    80003a64:	fb840593          	addi	a1,s0,-72
    80003a68:	6c88                	ld	a0,24(s1)
    80003a6a:	fffff097          	auipc	ra,0xfffff
    80003a6e:	2fe080e7          	jalr	766(ra) # 80002d68 <stati>
    iunlock(f->ip);
    80003a72:	6c88                	ld	a0,24(s1)
    80003a74:	fffff097          	auipc	ra,0xfffff
    80003a78:	12c080e7          	jalr	300(ra) # 80002ba0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a7c:	46e1                	li	a3,24
    80003a7e:	fb840613          	addi	a2,s0,-72
    80003a82:	85ce                	mv	a1,s3
    80003a84:	05093503          	ld	a0,80(s2)
    80003a88:	ffffd097          	auipc	ra,0xffffd
    80003a8c:	08e080e7          	jalr	142(ra) # 80000b16 <copyout>
    80003a90:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a94:	60a6                	ld	ra,72(sp)
    80003a96:	6406                	ld	s0,64(sp)
    80003a98:	74e2                	ld	s1,56(sp)
    80003a9a:	7942                	ld	s2,48(sp)
    80003a9c:	79a2                	ld	s3,40(sp)
    80003a9e:	6161                	addi	sp,sp,80
    80003aa0:	8082                	ret
  return -1;
    80003aa2:	557d                	li	a0,-1
    80003aa4:	bfc5                	j	80003a94 <filestat+0x60>

0000000080003aa6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003aa6:	7179                	addi	sp,sp,-48
    80003aa8:	f406                	sd	ra,40(sp)
    80003aaa:	f022                	sd	s0,32(sp)
    80003aac:	ec26                	sd	s1,24(sp)
    80003aae:	e84a                	sd	s2,16(sp)
    80003ab0:	e44e                	sd	s3,8(sp)
    80003ab2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ab4:	00854783          	lbu	a5,8(a0)
    80003ab8:	c3d5                	beqz	a5,80003b5c <fileread+0xb6>
    80003aba:	84aa                	mv	s1,a0
    80003abc:	89ae                	mv	s3,a1
    80003abe:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ac0:	411c                	lw	a5,0(a0)
    80003ac2:	4705                	li	a4,1
    80003ac4:	04e78963          	beq	a5,a4,80003b16 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ac8:	470d                	li	a4,3
    80003aca:	04e78d63          	beq	a5,a4,80003b24 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ace:	4709                	li	a4,2
    80003ad0:	06e79e63          	bne	a5,a4,80003b4c <fileread+0xa6>
    ilock(f->ip);
    80003ad4:	6d08                	ld	a0,24(a0)
    80003ad6:	fffff097          	auipc	ra,0xfffff
    80003ada:	008080e7          	jalr	8(ra) # 80002ade <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ade:	874a                	mv	a4,s2
    80003ae0:	5094                	lw	a3,32(s1)
    80003ae2:	864e                	mv	a2,s3
    80003ae4:	4585                	li	a1,1
    80003ae6:	6c88                	ld	a0,24(s1)
    80003ae8:	fffff097          	auipc	ra,0xfffff
    80003aec:	2aa080e7          	jalr	682(ra) # 80002d92 <readi>
    80003af0:	892a                	mv	s2,a0
    80003af2:	00a05563          	blez	a0,80003afc <fileread+0x56>
      f->off += r;
    80003af6:	509c                	lw	a5,32(s1)
    80003af8:	9fa9                	addw	a5,a5,a0
    80003afa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003afc:	6c88                	ld	a0,24(s1)
    80003afe:	fffff097          	auipc	ra,0xfffff
    80003b02:	0a2080e7          	jalr	162(ra) # 80002ba0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b06:	854a                	mv	a0,s2
    80003b08:	70a2                	ld	ra,40(sp)
    80003b0a:	7402                	ld	s0,32(sp)
    80003b0c:	64e2                	ld	s1,24(sp)
    80003b0e:	6942                	ld	s2,16(sp)
    80003b10:	69a2                	ld	s3,8(sp)
    80003b12:	6145                	addi	sp,sp,48
    80003b14:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b16:	6908                	ld	a0,16(a0)
    80003b18:	00000097          	auipc	ra,0x0
    80003b1c:	3ce080e7          	jalr	974(ra) # 80003ee6 <piperead>
    80003b20:	892a                	mv	s2,a0
    80003b22:	b7d5                	j	80003b06 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b24:	02451783          	lh	a5,36(a0)
    80003b28:	03079693          	slli	a3,a5,0x30
    80003b2c:	92c1                	srli	a3,a3,0x30
    80003b2e:	4725                	li	a4,9
    80003b30:	02d76863          	bltu	a4,a3,80003b60 <fileread+0xba>
    80003b34:	0792                	slli	a5,a5,0x4
    80003b36:	00015717          	auipc	a4,0x15
    80003b3a:	e9270713          	addi	a4,a4,-366 # 800189c8 <devsw>
    80003b3e:	97ba                	add	a5,a5,a4
    80003b40:	639c                	ld	a5,0(a5)
    80003b42:	c38d                	beqz	a5,80003b64 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b44:	4505                	li	a0,1
    80003b46:	9782                	jalr	a5
    80003b48:	892a                	mv	s2,a0
    80003b4a:	bf75                	j	80003b06 <fileread+0x60>
    panic("fileread");
    80003b4c:	00005517          	auipc	a0,0x5
    80003b50:	b2450513          	addi	a0,a0,-1244 # 80008670 <syscalls+0x2a0>
    80003b54:	00002097          	auipc	ra,0x2
    80003b58:	08e080e7          	jalr	142(ra) # 80005be2 <panic>
    return -1;
    80003b5c:	597d                	li	s2,-1
    80003b5e:	b765                	j	80003b06 <fileread+0x60>
      return -1;
    80003b60:	597d                	li	s2,-1
    80003b62:	b755                	j	80003b06 <fileread+0x60>
    80003b64:	597d                	li	s2,-1
    80003b66:	b745                	j	80003b06 <fileread+0x60>

0000000080003b68 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b68:	715d                	addi	sp,sp,-80
    80003b6a:	e486                	sd	ra,72(sp)
    80003b6c:	e0a2                	sd	s0,64(sp)
    80003b6e:	fc26                	sd	s1,56(sp)
    80003b70:	f84a                	sd	s2,48(sp)
    80003b72:	f44e                	sd	s3,40(sp)
    80003b74:	f052                	sd	s4,32(sp)
    80003b76:	ec56                	sd	s5,24(sp)
    80003b78:	e85a                	sd	s6,16(sp)
    80003b7a:	e45e                	sd	s7,8(sp)
    80003b7c:	e062                	sd	s8,0(sp)
    80003b7e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b80:	00954783          	lbu	a5,9(a0)
    80003b84:	10078663          	beqz	a5,80003c90 <filewrite+0x128>
    80003b88:	892a                	mv	s2,a0
    80003b8a:	8aae                	mv	s5,a1
    80003b8c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b8e:	411c                	lw	a5,0(a0)
    80003b90:	4705                	li	a4,1
    80003b92:	02e78263          	beq	a5,a4,80003bb6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b96:	470d                	li	a4,3
    80003b98:	02e78663          	beq	a5,a4,80003bc4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b9c:	4709                	li	a4,2
    80003b9e:	0ee79163          	bne	a5,a4,80003c80 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ba2:	0ac05d63          	blez	a2,80003c5c <filewrite+0xf4>
    int i = 0;
    80003ba6:	4981                	li	s3,0
    80003ba8:	6b05                	lui	s6,0x1
    80003baa:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003bae:	6b85                	lui	s7,0x1
    80003bb0:	c00b8b9b          	addiw	s7,s7,-1024
    80003bb4:	a861                	j	80003c4c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003bb6:	6908                	ld	a0,16(a0)
    80003bb8:	00000097          	auipc	ra,0x0
    80003bbc:	22e080e7          	jalr	558(ra) # 80003de6 <pipewrite>
    80003bc0:	8a2a                	mv	s4,a0
    80003bc2:	a045                	j	80003c62 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bc4:	02451783          	lh	a5,36(a0)
    80003bc8:	03079693          	slli	a3,a5,0x30
    80003bcc:	92c1                	srli	a3,a3,0x30
    80003bce:	4725                	li	a4,9
    80003bd0:	0cd76263          	bltu	a4,a3,80003c94 <filewrite+0x12c>
    80003bd4:	0792                	slli	a5,a5,0x4
    80003bd6:	00015717          	auipc	a4,0x15
    80003bda:	df270713          	addi	a4,a4,-526 # 800189c8 <devsw>
    80003bde:	97ba                	add	a5,a5,a4
    80003be0:	679c                	ld	a5,8(a5)
    80003be2:	cbdd                	beqz	a5,80003c98 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003be4:	4505                	li	a0,1
    80003be6:	9782                	jalr	a5
    80003be8:	8a2a                	mv	s4,a0
    80003bea:	a8a5                	j	80003c62 <filewrite+0xfa>
    80003bec:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003bf0:	00000097          	auipc	ra,0x0
    80003bf4:	8b0080e7          	jalr	-1872(ra) # 800034a0 <begin_op>
      ilock(f->ip);
    80003bf8:	01893503          	ld	a0,24(s2)
    80003bfc:	fffff097          	auipc	ra,0xfffff
    80003c00:	ee2080e7          	jalr	-286(ra) # 80002ade <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c04:	8762                	mv	a4,s8
    80003c06:	02092683          	lw	a3,32(s2)
    80003c0a:	01598633          	add	a2,s3,s5
    80003c0e:	4585                	li	a1,1
    80003c10:	01893503          	ld	a0,24(s2)
    80003c14:	fffff097          	auipc	ra,0xfffff
    80003c18:	276080e7          	jalr	630(ra) # 80002e8a <writei>
    80003c1c:	84aa                	mv	s1,a0
    80003c1e:	00a05763          	blez	a0,80003c2c <filewrite+0xc4>
        f->off += r;
    80003c22:	02092783          	lw	a5,32(s2)
    80003c26:	9fa9                	addw	a5,a5,a0
    80003c28:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c2c:	01893503          	ld	a0,24(s2)
    80003c30:	fffff097          	auipc	ra,0xfffff
    80003c34:	f70080e7          	jalr	-144(ra) # 80002ba0 <iunlock>
      end_op();
    80003c38:	00000097          	auipc	ra,0x0
    80003c3c:	8e8080e7          	jalr	-1816(ra) # 80003520 <end_op>

      if(r != n1){
    80003c40:	009c1f63          	bne	s8,s1,80003c5e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003c44:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c48:	0149db63          	bge	s3,s4,80003c5e <filewrite+0xf6>
      int n1 = n - i;
    80003c4c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003c50:	84be                	mv	s1,a5
    80003c52:	2781                	sext.w	a5,a5
    80003c54:	f8fb5ce3          	bge	s6,a5,80003bec <filewrite+0x84>
    80003c58:	84de                	mv	s1,s7
    80003c5a:	bf49                	j	80003bec <filewrite+0x84>
    int i = 0;
    80003c5c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c5e:	013a1f63          	bne	s4,s3,80003c7c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c62:	8552                	mv	a0,s4
    80003c64:	60a6                	ld	ra,72(sp)
    80003c66:	6406                	ld	s0,64(sp)
    80003c68:	74e2                	ld	s1,56(sp)
    80003c6a:	7942                	ld	s2,48(sp)
    80003c6c:	79a2                	ld	s3,40(sp)
    80003c6e:	7a02                	ld	s4,32(sp)
    80003c70:	6ae2                	ld	s5,24(sp)
    80003c72:	6b42                	ld	s6,16(sp)
    80003c74:	6ba2                	ld	s7,8(sp)
    80003c76:	6c02                	ld	s8,0(sp)
    80003c78:	6161                	addi	sp,sp,80
    80003c7a:	8082                	ret
    ret = (i == n ? n : -1);
    80003c7c:	5a7d                	li	s4,-1
    80003c7e:	b7d5                	j	80003c62 <filewrite+0xfa>
    panic("filewrite");
    80003c80:	00005517          	auipc	a0,0x5
    80003c84:	a0050513          	addi	a0,a0,-1536 # 80008680 <syscalls+0x2b0>
    80003c88:	00002097          	auipc	ra,0x2
    80003c8c:	f5a080e7          	jalr	-166(ra) # 80005be2 <panic>
    return -1;
    80003c90:	5a7d                	li	s4,-1
    80003c92:	bfc1                	j	80003c62 <filewrite+0xfa>
      return -1;
    80003c94:	5a7d                	li	s4,-1
    80003c96:	b7f1                	j	80003c62 <filewrite+0xfa>
    80003c98:	5a7d                	li	s4,-1
    80003c9a:	b7e1                	j	80003c62 <filewrite+0xfa>

0000000080003c9c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003c9c:	7179                	addi	sp,sp,-48
    80003c9e:	f406                	sd	ra,40(sp)
    80003ca0:	f022                	sd	s0,32(sp)
    80003ca2:	ec26                	sd	s1,24(sp)
    80003ca4:	e84a                	sd	s2,16(sp)
    80003ca6:	e44e                	sd	s3,8(sp)
    80003ca8:	e052                	sd	s4,0(sp)
    80003caa:	1800                	addi	s0,sp,48
    80003cac:	84aa                	mv	s1,a0
    80003cae:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cb0:	0005b023          	sd	zero,0(a1)
    80003cb4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cb8:	00000097          	auipc	ra,0x0
    80003cbc:	bf8080e7          	jalr	-1032(ra) # 800038b0 <filealloc>
    80003cc0:	e088                	sd	a0,0(s1)
    80003cc2:	c551                	beqz	a0,80003d4e <pipealloc+0xb2>
    80003cc4:	00000097          	auipc	ra,0x0
    80003cc8:	bec080e7          	jalr	-1044(ra) # 800038b0 <filealloc>
    80003ccc:	00aa3023          	sd	a0,0(s4)
    80003cd0:	c92d                	beqz	a0,80003d42 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cd2:	ffffc097          	auipc	ra,0xffffc
    80003cd6:	446080e7          	jalr	1094(ra) # 80000118 <kalloc>
    80003cda:	892a                	mv	s2,a0
    80003cdc:	c125                	beqz	a0,80003d3c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003cde:	4985                	li	s3,1
    80003ce0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ce4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ce8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003cec:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003cf0:	00005597          	auipc	a1,0x5
    80003cf4:	9a058593          	addi	a1,a1,-1632 # 80008690 <syscalls+0x2c0>
    80003cf8:	00002097          	auipc	ra,0x2
    80003cfc:	3a4080e7          	jalr	932(ra) # 8000609c <initlock>
  (*f0)->type = FD_PIPE;
    80003d00:	609c                	ld	a5,0(s1)
    80003d02:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d06:	609c                	ld	a5,0(s1)
    80003d08:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d0c:	609c                	ld	a5,0(s1)
    80003d0e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d12:	609c                	ld	a5,0(s1)
    80003d14:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d18:	000a3783          	ld	a5,0(s4)
    80003d1c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d20:	000a3783          	ld	a5,0(s4)
    80003d24:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d28:	000a3783          	ld	a5,0(s4)
    80003d2c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d30:	000a3783          	ld	a5,0(s4)
    80003d34:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d38:	4501                	li	a0,0
    80003d3a:	a025                	j	80003d62 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d3c:	6088                	ld	a0,0(s1)
    80003d3e:	e501                	bnez	a0,80003d46 <pipealloc+0xaa>
    80003d40:	a039                	j	80003d4e <pipealloc+0xb2>
    80003d42:	6088                	ld	a0,0(s1)
    80003d44:	c51d                	beqz	a0,80003d72 <pipealloc+0xd6>
    fileclose(*f0);
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	c26080e7          	jalr	-986(ra) # 8000396c <fileclose>
  if(*f1)
    80003d4e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d52:	557d                	li	a0,-1
  if(*f1)
    80003d54:	c799                	beqz	a5,80003d62 <pipealloc+0xc6>
    fileclose(*f1);
    80003d56:	853e                	mv	a0,a5
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	c14080e7          	jalr	-1004(ra) # 8000396c <fileclose>
  return -1;
    80003d60:	557d                	li	a0,-1
}
    80003d62:	70a2                	ld	ra,40(sp)
    80003d64:	7402                	ld	s0,32(sp)
    80003d66:	64e2                	ld	s1,24(sp)
    80003d68:	6942                	ld	s2,16(sp)
    80003d6a:	69a2                	ld	s3,8(sp)
    80003d6c:	6a02                	ld	s4,0(sp)
    80003d6e:	6145                	addi	sp,sp,48
    80003d70:	8082                	ret
  return -1;
    80003d72:	557d                	li	a0,-1
    80003d74:	b7fd                	j	80003d62 <pipealloc+0xc6>

0000000080003d76 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d76:	1101                	addi	sp,sp,-32
    80003d78:	ec06                	sd	ra,24(sp)
    80003d7a:	e822                	sd	s0,16(sp)
    80003d7c:	e426                	sd	s1,8(sp)
    80003d7e:	e04a                	sd	s2,0(sp)
    80003d80:	1000                	addi	s0,sp,32
    80003d82:	84aa                	mv	s1,a0
    80003d84:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d86:	00002097          	auipc	ra,0x2
    80003d8a:	3a6080e7          	jalr	934(ra) # 8000612c <acquire>
  if(writable){
    80003d8e:	02090d63          	beqz	s2,80003dc8 <pipeclose+0x52>
    pi->writeopen = 0;
    80003d92:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d96:	21848513          	addi	a0,s1,536
    80003d9a:	ffffd097          	auipc	ra,0xffffd
    80003d9e:	7c2080e7          	jalr	1986(ra) # 8000155c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003da2:	2204b783          	ld	a5,544(s1)
    80003da6:	eb95                	bnez	a5,80003dda <pipeclose+0x64>
    release(&pi->lock);
    80003da8:	8526                	mv	a0,s1
    80003daa:	00002097          	auipc	ra,0x2
    80003dae:	436080e7          	jalr	1078(ra) # 800061e0 <release>
    kfree((char*)pi);
    80003db2:	8526                	mv	a0,s1
    80003db4:	ffffc097          	auipc	ra,0xffffc
    80003db8:	268080e7          	jalr	616(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003dbc:	60e2                	ld	ra,24(sp)
    80003dbe:	6442                	ld	s0,16(sp)
    80003dc0:	64a2                	ld	s1,8(sp)
    80003dc2:	6902                	ld	s2,0(sp)
    80003dc4:	6105                	addi	sp,sp,32
    80003dc6:	8082                	ret
    pi->readopen = 0;
    80003dc8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003dcc:	21c48513          	addi	a0,s1,540
    80003dd0:	ffffd097          	auipc	ra,0xffffd
    80003dd4:	78c080e7          	jalr	1932(ra) # 8000155c <wakeup>
    80003dd8:	b7e9                	j	80003da2 <pipeclose+0x2c>
    release(&pi->lock);
    80003dda:	8526                	mv	a0,s1
    80003ddc:	00002097          	auipc	ra,0x2
    80003de0:	404080e7          	jalr	1028(ra) # 800061e0 <release>
}
    80003de4:	bfe1                	j	80003dbc <pipeclose+0x46>

0000000080003de6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003de6:	7159                	addi	sp,sp,-112
    80003de8:	f486                	sd	ra,104(sp)
    80003dea:	f0a2                	sd	s0,96(sp)
    80003dec:	eca6                	sd	s1,88(sp)
    80003dee:	e8ca                	sd	s2,80(sp)
    80003df0:	e4ce                	sd	s3,72(sp)
    80003df2:	e0d2                	sd	s4,64(sp)
    80003df4:	fc56                	sd	s5,56(sp)
    80003df6:	f85a                	sd	s6,48(sp)
    80003df8:	f45e                	sd	s7,40(sp)
    80003dfa:	f062                	sd	s8,32(sp)
    80003dfc:	ec66                	sd	s9,24(sp)
    80003dfe:	1880                	addi	s0,sp,112
    80003e00:	84aa                	mv	s1,a0
    80003e02:	8aae                	mv	s5,a1
    80003e04:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e06:	ffffd097          	auipc	ra,0xffffd
    80003e0a:	04e080e7          	jalr	78(ra) # 80000e54 <myproc>
    80003e0e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e10:	8526                	mv	a0,s1
    80003e12:	00002097          	auipc	ra,0x2
    80003e16:	31a080e7          	jalr	794(ra) # 8000612c <acquire>
  while(i < n){
    80003e1a:	0d405463          	blez	s4,80003ee2 <pipewrite+0xfc>
    80003e1e:	8ba6                	mv	s7,s1
  int i = 0;
    80003e20:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e22:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e24:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e28:	21c48c13          	addi	s8,s1,540
    80003e2c:	a08d                	j	80003e8e <pipewrite+0xa8>
      release(&pi->lock);
    80003e2e:	8526                	mv	a0,s1
    80003e30:	00002097          	auipc	ra,0x2
    80003e34:	3b0080e7          	jalr	944(ra) # 800061e0 <release>
      return -1;
    80003e38:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e3a:	854a                	mv	a0,s2
    80003e3c:	70a6                	ld	ra,104(sp)
    80003e3e:	7406                	ld	s0,96(sp)
    80003e40:	64e6                	ld	s1,88(sp)
    80003e42:	6946                	ld	s2,80(sp)
    80003e44:	69a6                	ld	s3,72(sp)
    80003e46:	6a06                	ld	s4,64(sp)
    80003e48:	7ae2                	ld	s5,56(sp)
    80003e4a:	7b42                	ld	s6,48(sp)
    80003e4c:	7ba2                	ld	s7,40(sp)
    80003e4e:	7c02                	ld	s8,32(sp)
    80003e50:	6ce2                	ld	s9,24(sp)
    80003e52:	6165                	addi	sp,sp,112
    80003e54:	8082                	ret
      wakeup(&pi->nread);
    80003e56:	8566                	mv	a0,s9
    80003e58:	ffffd097          	auipc	ra,0xffffd
    80003e5c:	704080e7          	jalr	1796(ra) # 8000155c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e60:	85de                	mv	a1,s7
    80003e62:	8562                	mv	a0,s8
    80003e64:	ffffd097          	auipc	ra,0xffffd
    80003e68:	694080e7          	jalr	1684(ra) # 800014f8 <sleep>
    80003e6c:	a839                	j	80003e8a <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e6e:	21c4a783          	lw	a5,540(s1)
    80003e72:	0017871b          	addiw	a4,a5,1
    80003e76:	20e4ae23          	sw	a4,540(s1)
    80003e7a:	1ff7f793          	andi	a5,a5,511
    80003e7e:	97a6                	add	a5,a5,s1
    80003e80:	f9f44703          	lbu	a4,-97(s0)
    80003e84:	00e78c23          	sb	a4,24(a5)
      i++;
    80003e88:	2905                	addiw	s2,s2,1
  while(i < n){
    80003e8a:	05495063          	bge	s2,s4,80003eca <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003e8e:	2204a783          	lw	a5,544(s1)
    80003e92:	dfd1                	beqz	a5,80003e2e <pipewrite+0x48>
    80003e94:	854e                	mv	a0,s3
    80003e96:	ffffe097          	auipc	ra,0xffffe
    80003e9a:	90a080e7          	jalr	-1782(ra) # 800017a0 <killed>
    80003e9e:	f941                	bnez	a0,80003e2e <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ea0:	2184a783          	lw	a5,536(s1)
    80003ea4:	21c4a703          	lw	a4,540(s1)
    80003ea8:	2007879b          	addiw	a5,a5,512
    80003eac:	faf705e3          	beq	a4,a5,80003e56 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eb0:	4685                	li	a3,1
    80003eb2:	01590633          	add	a2,s2,s5
    80003eb6:	f9f40593          	addi	a1,s0,-97
    80003eba:	0509b503          	ld	a0,80(s3)
    80003ebe:	ffffd097          	auipc	ra,0xffffd
    80003ec2:	ce4080e7          	jalr	-796(ra) # 80000ba2 <copyin>
    80003ec6:	fb6514e3          	bne	a0,s6,80003e6e <pipewrite+0x88>
  wakeup(&pi->nread);
    80003eca:	21848513          	addi	a0,s1,536
    80003ece:	ffffd097          	auipc	ra,0xffffd
    80003ed2:	68e080e7          	jalr	1678(ra) # 8000155c <wakeup>
  release(&pi->lock);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	00002097          	auipc	ra,0x2
    80003edc:	308080e7          	jalr	776(ra) # 800061e0 <release>
  return i;
    80003ee0:	bfa9                	j	80003e3a <pipewrite+0x54>
  int i = 0;
    80003ee2:	4901                	li	s2,0
    80003ee4:	b7dd                	j	80003eca <pipewrite+0xe4>

0000000080003ee6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ee6:	715d                	addi	sp,sp,-80
    80003ee8:	e486                	sd	ra,72(sp)
    80003eea:	e0a2                	sd	s0,64(sp)
    80003eec:	fc26                	sd	s1,56(sp)
    80003eee:	f84a                	sd	s2,48(sp)
    80003ef0:	f44e                	sd	s3,40(sp)
    80003ef2:	f052                	sd	s4,32(sp)
    80003ef4:	ec56                	sd	s5,24(sp)
    80003ef6:	e85a                	sd	s6,16(sp)
    80003ef8:	0880                	addi	s0,sp,80
    80003efa:	84aa                	mv	s1,a0
    80003efc:	892e                	mv	s2,a1
    80003efe:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f00:	ffffd097          	auipc	ra,0xffffd
    80003f04:	f54080e7          	jalr	-172(ra) # 80000e54 <myproc>
    80003f08:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f0a:	8b26                	mv	s6,s1
    80003f0c:	8526                	mv	a0,s1
    80003f0e:	00002097          	auipc	ra,0x2
    80003f12:	21e080e7          	jalr	542(ra) # 8000612c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f16:	2184a703          	lw	a4,536(s1)
    80003f1a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f1e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f22:	02f71763          	bne	a4,a5,80003f50 <piperead+0x6a>
    80003f26:	2244a783          	lw	a5,548(s1)
    80003f2a:	c39d                	beqz	a5,80003f50 <piperead+0x6a>
    if(killed(pr)){
    80003f2c:	8552                	mv	a0,s4
    80003f2e:	ffffe097          	auipc	ra,0xffffe
    80003f32:	872080e7          	jalr	-1934(ra) # 800017a0 <killed>
    80003f36:	e941                	bnez	a0,80003fc6 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f38:	85da                	mv	a1,s6
    80003f3a:	854e                	mv	a0,s3
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	5bc080e7          	jalr	1468(ra) # 800014f8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f44:	2184a703          	lw	a4,536(s1)
    80003f48:	21c4a783          	lw	a5,540(s1)
    80003f4c:	fcf70de3          	beq	a4,a5,80003f26 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f50:	09505263          	blez	s5,80003fd4 <piperead+0xee>
    80003f54:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f56:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003f58:	2184a783          	lw	a5,536(s1)
    80003f5c:	21c4a703          	lw	a4,540(s1)
    80003f60:	02f70d63          	beq	a4,a5,80003f9a <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f64:	0017871b          	addiw	a4,a5,1
    80003f68:	20e4ac23          	sw	a4,536(s1)
    80003f6c:	1ff7f793          	andi	a5,a5,511
    80003f70:	97a6                	add	a5,a5,s1
    80003f72:	0187c783          	lbu	a5,24(a5)
    80003f76:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f7a:	4685                	li	a3,1
    80003f7c:	fbf40613          	addi	a2,s0,-65
    80003f80:	85ca                	mv	a1,s2
    80003f82:	050a3503          	ld	a0,80(s4)
    80003f86:	ffffd097          	auipc	ra,0xffffd
    80003f8a:	b90080e7          	jalr	-1136(ra) # 80000b16 <copyout>
    80003f8e:	01650663          	beq	a0,s6,80003f9a <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f92:	2985                	addiw	s3,s3,1
    80003f94:	0905                	addi	s2,s2,1
    80003f96:	fd3a91e3          	bne	s5,s3,80003f58 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f9a:	21c48513          	addi	a0,s1,540
    80003f9e:	ffffd097          	auipc	ra,0xffffd
    80003fa2:	5be080e7          	jalr	1470(ra) # 8000155c <wakeup>
  release(&pi->lock);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	00002097          	auipc	ra,0x2
    80003fac:	238080e7          	jalr	568(ra) # 800061e0 <release>
  return i;
}
    80003fb0:	854e                	mv	a0,s3
    80003fb2:	60a6                	ld	ra,72(sp)
    80003fb4:	6406                	ld	s0,64(sp)
    80003fb6:	74e2                	ld	s1,56(sp)
    80003fb8:	7942                	ld	s2,48(sp)
    80003fba:	79a2                	ld	s3,40(sp)
    80003fbc:	7a02                	ld	s4,32(sp)
    80003fbe:	6ae2                	ld	s5,24(sp)
    80003fc0:	6b42                	ld	s6,16(sp)
    80003fc2:	6161                	addi	sp,sp,80
    80003fc4:	8082                	ret
      release(&pi->lock);
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	00002097          	auipc	ra,0x2
    80003fcc:	218080e7          	jalr	536(ra) # 800061e0 <release>
      return -1;
    80003fd0:	59fd                	li	s3,-1
    80003fd2:	bff9                	j	80003fb0 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fd4:	4981                	li	s3,0
    80003fd6:	b7d1                	j	80003f9a <piperead+0xb4>

0000000080003fd8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003fd8:	1141                	addi	sp,sp,-16
    80003fda:	e422                	sd	s0,8(sp)
    80003fdc:	0800                	addi	s0,sp,16
    80003fde:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003fe0:	8905                	andi	a0,a0,1
    80003fe2:	c111                	beqz	a0,80003fe6 <flags2perm+0xe>
      perm = PTE_X;
    80003fe4:	4521                	li	a0,8
    if(flags & 0x2)
    80003fe6:	8b89                	andi	a5,a5,2
    80003fe8:	c399                	beqz	a5,80003fee <flags2perm+0x16>
      perm |= PTE_W;
    80003fea:	00456513          	ori	a0,a0,4
    return perm;
}
    80003fee:	6422                	ld	s0,8(sp)
    80003ff0:	0141                	addi	sp,sp,16
    80003ff2:	8082                	ret

0000000080003ff4 <exec>:

int
exec(char *path, char **argv)
{
    80003ff4:	df010113          	addi	sp,sp,-528
    80003ff8:	20113423          	sd	ra,520(sp)
    80003ffc:	20813023          	sd	s0,512(sp)
    80004000:	ffa6                	sd	s1,504(sp)
    80004002:	fbca                	sd	s2,496(sp)
    80004004:	f7ce                	sd	s3,488(sp)
    80004006:	f3d2                	sd	s4,480(sp)
    80004008:	efd6                	sd	s5,472(sp)
    8000400a:	ebda                	sd	s6,464(sp)
    8000400c:	e7de                	sd	s7,456(sp)
    8000400e:	e3e2                	sd	s8,448(sp)
    80004010:	ff66                	sd	s9,440(sp)
    80004012:	fb6a                	sd	s10,432(sp)
    80004014:	f76e                	sd	s11,424(sp)
    80004016:	0c00                	addi	s0,sp,528
    80004018:	84aa                	mv	s1,a0
    8000401a:	dea43c23          	sd	a0,-520(s0)
    8000401e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004022:	ffffd097          	auipc	ra,0xffffd
    80004026:	e32080e7          	jalr	-462(ra) # 80000e54 <myproc>
    8000402a:	892a                	mv	s2,a0

  begin_op();
    8000402c:	fffff097          	auipc	ra,0xfffff
    80004030:	474080e7          	jalr	1140(ra) # 800034a0 <begin_op>

  if((ip = namei(path)) == 0){
    80004034:	8526                	mv	a0,s1
    80004036:	fffff097          	auipc	ra,0xfffff
    8000403a:	24e080e7          	jalr	590(ra) # 80003284 <namei>
    8000403e:	c92d                	beqz	a0,800040b0 <exec+0xbc>
    80004040:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004042:	fffff097          	auipc	ra,0xfffff
    80004046:	a9c080e7          	jalr	-1380(ra) # 80002ade <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000404a:	04000713          	li	a4,64
    8000404e:	4681                	li	a3,0
    80004050:	e5040613          	addi	a2,s0,-432
    80004054:	4581                	li	a1,0
    80004056:	8526                	mv	a0,s1
    80004058:	fffff097          	auipc	ra,0xfffff
    8000405c:	d3a080e7          	jalr	-710(ra) # 80002d92 <readi>
    80004060:	04000793          	li	a5,64
    80004064:	00f51a63          	bne	a0,a5,80004078 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004068:	e5042703          	lw	a4,-432(s0)
    8000406c:	464c47b7          	lui	a5,0x464c4
    80004070:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004074:	04f70463          	beq	a4,a5,800040bc <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004078:	8526                	mv	a0,s1
    8000407a:	fffff097          	auipc	ra,0xfffff
    8000407e:	cc6080e7          	jalr	-826(ra) # 80002d40 <iunlockput>
    end_op();
    80004082:	fffff097          	auipc	ra,0xfffff
    80004086:	49e080e7          	jalr	1182(ra) # 80003520 <end_op>
  }
  return -1;
    8000408a:	557d                	li	a0,-1
}
    8000408c:	20813083          	ld	ra,520(sp)
    80004090:	20013403          	ld	s0,512(sp)
    80004094:	74fe                	ld	s1,504(sp)
    80004096:	795e                	ld	s2,496(sp)
    80004098:	79be                	ld	s3,488(sp)
    8000409a:	7a1e                	ld	s4,480(sp)
    8000409c:	6afe                	ld	s5,472(sp)
    8000409e:	6b5e                	ld	s6,464(sp)
    800040a0:	6bbe                	ld	s7,456(sp)
    800040a2:	6c1e                	ld	s8,448(sp)
    800040a4:	7cfa                	ld	s9,440(sp)
    800040a6:	7d5a                	ld	s10,432(sp)
    800040a8:	7dba                	ld	s11,424(sp)
    800040aa:	21010113          	addi	sp,sp,528
    800040ae:	8082                	ret
    end_op();
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	470080e7          	jalr	1136(ra) # 80003520 <end_op>
    return -1;
    800040b8:	557d                	li	a0,-1
    800040ba:	bfc9                	j	8000408c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800040bc:	854a                	mv	a0,s2
    800040be:	ffffd097          	auipc	ra,0xffffd
    800040c2:	e5a080e7          	jalr	-422(ra) # 80000f18 <proc_pagetable>
    800040c6:	8baa                	mv	s7,a0
    800040c8:	d945                	beqz	a0,80004078 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040ca:	e7042983          	lw	s3,-400(s0)
    800040ce:	e8845783          	lhu	a5,-376(s0)
    800040d2:	c7ad                	beqz	a5,8000413c <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040d4:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040d6:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800040d8:	6c85                	lui	s9,0x1
    800040da:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800040de:	def43823          	sd	a5,-528(s0)
    800040e2:	ac0d                	j	80004314 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800040e4:	00004517          	auipc	a0,0x4
    800040e8:	5b450513          	addi	a0,a0,1460 # 80008698 <syscalls+0x2c8>
    800040ec:	00002097          	auipc	ra,0x2
    800040f0:	af6080e7          	jalr	-1290(ra) # 80005be2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040f4:	8756                	mv	a4,s5
    800040f6:	012d86bb          	addw	a3,s11,s2
    800040fa:	4581                	li	a1,0
    800040fc:	8526                	mv	a0,s1
    800040fe:	fffff097          	auipc	ra,0xfffff
    80004102:	c94080e7          	jalr	-876(ra) # 80002d92 <readi>
    80004106:	2501                	sext.w	a0,a0
    80004108:	1aaa9a63          	bne	s5,a0,800042bc <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    8000410c:	6785                	lui	a5,0x1
    8000410e:	0127893b          	addw	s2,a5,s2
    80004112:	77fd                	lui	a5,0xfffff
    80004114:	01478a3b          	addw	s4,a5,s4
    80004118:	1f897563          	bgeu	s2,s8,80004302 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    8000411c:	02091593          	slli	a1,s2,0x20
    80004120:	9181                	srli	a1,a1,0x20
    80004122:	95ea                	add	a1,a1,s10
    80004124:	855e                	mv	a0,s7
    80004126:	ffffc097          	auipc	ra,0xffffc
    8000412a:	3e4080e7          	jalr	996(ra) # 8000050a <walkaddr>
    8000412e:	862a                	mv	a2,a0
    if(pa == 0)
    80004130:	d955                	beqz	a0,800040e4 <exec+0xf0>
      n = PGSIZE;
    80004132:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004134:	fd9a70e3          	bgeu	s4,s9,800040f4 <exec+0x100>
      n = sz - i;
    80004138:	8ad2                	mv	s5,s4
    8000413a:	bf6d                	j	800040f4 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000413c:	4a01                	li	s4,0
  iunlockput(ip);
    8000413e:	8526                	mv	a0,s1
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	c00080e7          	jalr	-1024(ra) # 80002d40 <iunlockput>
  end_op();
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	3d8080e7          	jalr	984(ra) # 80003520 <end_op>
  p = myproc();
    80004150:	ffffd097          	auipc	ra,0xffffd
    80004154:	d04080e7          	jalr	-764(ra) # 80000e54 <myproc>
    80004158:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000415a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000415e:	6785                	lui	a5,0x1
    80004160:	17fd                	addi	a5,a5,-1
    80004162:	9a3e                	add	s4,s4,a5
    80004164:	757d                	lui	a0,0xfffff
    80004166:	00aa77b3          	and	a5,s4,a0
    8000416a:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000416e:	4691                	li	a3,4
    80004170:	6609                	lui	a2,0x2
    80004172:	963e                	add	a2,a2,a5
    80004174:	85be                	mv	a1,a5
    80004176:	855e                	mv	a0,s7
    80004178:	ffffc097          	auipc	ra,0xffffc
    8000417c:	746080e7          	jalr	1862(ra) # 800008be <uvmalloc>
    80004180:	8b2a                	mv	s6,a0
  ip = 0;
    80004182:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004184:	12050c63          	beqz	a0,800042bc <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004188:	75f9                	lui	a1,0xffffe
    8000418a:	95aa                	add	a1,a1,a0
    8000418c:	855e                	mv	a0,s7
    8000418e:	ffffd097          	auipc	ra,0xffffd
    80004192:	956080e7          	jalr	-1706(ra) # 80000ae4 <uvmclear>
  stackbase = sp - PGSIZE;
    80004196:	7c7d                	lui	s8,0xfffff
    80004198:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000419a:	e0043783          	ld	a5,-512(s0)
    8000419e:	6388                	ld	a0,0(a5)
    800041a0:	c535                	beqz	a0,8000420c <exec+0x218>
    800041a2:	e9040993          	addi	s3,s0,-368
    800041a6:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041aa:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800041ac:	ffffc097          	auipc	ra,0xffffc
    800041b0:	150080e7          	jalr	336(ra) # 800002fc <strlen>
    800041b4:	2505                	addiw	a0,a0,1
    800041b6:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041ba:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800041be:	13896663          	bltu	s2,s8,800042ea <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041c2:	e0043d83          	ld	s11,-512(s0)
    800041c6:	000dba03          	ld	s4,0(s11)
    800041ca:	8552                	mv	a0,s4
    800041cc:	ffffc097          	auipc	ra,0xffffc
    800041d0:	130080e7          	jalr	304(ra) # 800002fc <strlen>
    800041d4:	0015069b          	addiw	a3,a0,1
    800041d8:	8652                	mv	a2,s4
    800041da:	85ca                	mv	a1,s2
    800041dc:	855e                	mv	a0,s7
    800041de:	ffffd097          	auipc	ra,0xffffd
    800041e2:	938080e7          	jalr	-1736(ra) # 80000b16 <copyout>
    800041e6:	10054663          	bltz	a0,800042f2 <exec+0x2fe>
    ustack[argc] = sp;
    800041ea:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800041ee:	0485                	addi	s1,s1,1
    800041f0:	008d8793          	addi	a5,s11,8
    800041f4:	e0f43023          	sd	a5,-512(s0)
    800041f8:	008db503          	ld	a0,8(s11)
    800041fc:	c911                	beqz	a0,80004210 <exec+0x21c>
    if(argc >= MAXARG)
    800041fe:	09a1                	addi	s3,s3,8
    80004200:	fb3c96e3          	bne	s9,s3,800041ac <exec+0x1b8>
  sz = sz1;
    80004204:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004208:	4481                	li	s1,0
    8000420a:	a84d                	j	800042bc <exec+0x2c8>
  sp = sz;
    8000420c:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000420e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004210:	00349793          	slli	a5,s1,0x3
    80004214:	f9040713          	addi	a4,s0,-112
    80004218:	97ba                	add	a5,a5,a4
    8000421a:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000421e:	00148693          	addi	a3,s1,1
    80004222:	068e                	slli	a3,a3,0x3
    80004224:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004228:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000422c:	01897663          	bgeu	s2,s8,80004238 <exec+0x244>
  sz = sz1;
    80004230:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004234:	4481                	li	s1,0
    80004236:	a059                	j	800042bc <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004238:	e9040613          	addi	a2,s0,-368
    8000423c:	85ca                	mv	a1,s2
    8000423e:	855e                	mv	a0,s7
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	8d6080e7          	jalr	-1834(ra) # 80000b16 <copyout>
    80004248:	0a054963          	bltz	a0,800042fa <exec+0x306>
  p->trapframe->a1 = sp;
    8000424c:	058ab783          	ld	a5,88(s5)
    80004250:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004254:	df843783          	ld	a5,-520(s0)
    80004258:	0007c703          	lbu	a4,0(a5)
    8000425c:	cf11                	beqz	a4,80004278 <exec+0x284>
    8000425e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004260:	02f00693          	li	a3,47
    80004264:	a039                	j	80004272 <exec+0x27e>
      last = s+1;
    80004266:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000426a:	0785                	addi	a5,a5,1
    8000426c:	fff7c703          	lbu	a4,-1(a5)
    80004270:	c701                	beqz	a4,80004278 <exec+0x284>
    if(*s == '/')
    80004272:	fed71ce3          	bne	a4,a3,8000426a <exec+0x276>
    80004276:	bfc5                	j	80004266 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004278:	4641                	li	a2,16
    8000427a:	df843583          	ld	a1,-520(s0)
    8000427e:	158a8513          	addi	a0,s5,344
    80004282:	ffffc097          	auipc	ra,0xffffc
    80004286:	048080e7          	jalr	72(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    8000428a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000428e:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004292:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004296:	058ab783          	ld	a5,88(s5)
    8000429a:	e6843703          	ld	a4,-408(s0)
    8000429e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042a0:	058ab783          	ld	a5,88(s5)
    800042a4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042a8:	85ea                	mv	a1,s10
    800042aa:	ffffd097          	auipc	ra,0xffffd
    800042ae:	d0a080e7          	jalr	-758(ra) # 80000fb4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042b2:	0004851b          	sext.w	a0,s1
    800042b6:	bbd9                	j	8000408c <exec+0x98>
    800042b8:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800042bc:	e0843583          	ld	a1,-504(s0)
    800042c0:	855e                	mv	a0,s7
    800042c2:	ffffd097          	auipc	ra,0xffffd
    800042c6:	cf2080e7          	jalr	-782(ra) # 80000fb4 <proc_freepagetable>
  if(ip){
    800042ca:	da0497e3          	bnez	s1,80004078 <exec+0x84>
  return -1;
    800042ce:	557d                	li	a0,-1
    800042d0:	bb75                	j	8000408c <exec+0x98>
    800042d2:	e1443423          	sd	s4,-504(s0)
    800042d6:	b7dd                	j	800042bc <exec+0x2c8>
    800042d8:	e1443423          	sd	s4,-504(s0)
    800042dc:	b7c5                	j	800042bc <exec+0x2c8>
    800042de:	e1443423          	sd	s4,-504(s0)
    800042e2:	bfe9                	j	800042bc <exec+0x2c8>
    800042e4:	e1443423          	sd	s4,-504(s0)
    800042e8:	bfd1                	j	800042bc <exec+0x2c8>
  sz = sz1;
    800042ea:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042ee:	4481                	li	s1,0
    800042f0:	b7f1                	j	800042bc <exec+0x2c8>
  sz = sz1;
    800042f2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042f6:	4481                	li	s1,0
    800042f8:	b7d1                	j	800042bc <exec+0x2c8>
  sz = sz1;
    800042fa:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042fe:	4481                	li	s1,0
    80004300:	bf75                	j	800042bc <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004302:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004306:	2b05                	addiw	s6,s6,1
    80004308:	0389899b          	addiw	s3,s3,56
    8000430c:	e8845783          	lhu	a5,-376(s0)
    80004310:	e2fb57e3          	bge	s6,a5,8000413e <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004314:	2981                	sext.w	s3,s3
    80004316:	03800713          	li	a4,56
    8000431a:	86ce                	mv	a3,s3
    8000431c:	e1840613          	addi	a2,s0,-488
    80004320:	4581                	li	a1,0
    80004322:	8526                	mv	a0,s1
    80004324:	fffff097          	auipc	ra,0xfffff
    80004328:	a6e080e7          	jalr	-1426(ra) # 80002d92 <readi>
    8000432c:	03800793          	li	a5,56
    80004330:	f8f514e3          	bne	a0,a5,800042b8 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004334:	e1842783          	lw	a5,-488(s0)
    80004338:	4705                	li	a4,1
    8000433a:	fce796e3          	bne	a5,a4,80004306 <exec+0x312>
    if(ph.memsz < ph.filesz)
    8000433e:	e4043903          	ld	s2,-448(s0)
    80004342:	e3843783          	ld	a5,-456(s0)
    80004346:	f8f966e3          	bltu	s2,a5,800042d2 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000434a:	e2843783          	ld	a5,-472(s0)
    8000434e:	993e                	add	s2,s2,a5
    80004350:	f8f964e3          	bltu	s2,a5,800042d8 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    80004354:	df043703          	ld	a4,-528(s0)
    80004358:	8ff9                	and	a5,a5,a4
    8000435a:	f3d1                	bnez	a5,800042de <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000435c:	e1c42503          	lw	a0,-484(s0)
    80004360:	00000097          	auipc	ra,0x0
    80004364:	c78080e7          	jalr	-904(ra) # 80003fd8 <flags2perm>
    80004368:	86aa                	mv	a3,a0
    8000436a:	864a                	mv	a2,s2
    8000436c:	85d2                	mv	a1,s4
    8000436e:	855e                	mv	a0,s7
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	54e080e7          	jalr	1358(ra) # 800008be <uvmalloc>
    80004378:	e0a43423          	sd	a0,-504(s0)
    8000437c:	d525                	beqz	a0,800042e4 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000437e:	e2843d03          	ld	s10,-472(s0)
    80004382:	e2042d83          	lw	s11,-480(s0)
    80004386:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000438a:	f60c0ce3          	beqz	s8,80004302 <exec+0x30e>
    8000438e:	8a62                	mv	s4,s8
    80004390:	4901                	li	s2,0
    80004392:	b369                	j	8000411c <exec+0x128>

0000000080004394 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004394:	7179                	addi	sp,sp,-48
    80004396:	f406                	sd	ra,40(sp)
    80004398:	f022                	sd	s0,32(sp)
    8000439a:	ec26                	sd	s1,24(sp)
    8000439c:	e84a                	sd	s2,16(sp)
    8000439e:	1800                	addi	s0,sp,48
    800043a0:	892e                	mv	s2,a1
    800043a2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800043a4:	fdc40593          	addi	a1,s0,-36
    800043a8:	ffffe097          	auipc	ra,0xffffe
    800043ac:	bbc080e7          	jalr	-1092(ra) # 80001f64 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043b0:	fdc42703          	lw	a4,-36(s0)
    800043b4:	47bd                	li	a5,15
    800043b6:	02e7eb63          	bltu	a5,a4,800043ec <argfd+0x58>
    800043ba:	ffffd097          	auipc	ra,0xffffd
    800043be:	a9a080e7          	jalr	-1382(ra) # 80000e54 <myproc>
    800043c2:	fdc42703          	lw	a4,-36(s0)
    800043c6:	01a70793          	addi	a5,a4,26
    800043ca:	078e                	slli	a5,a5,0x3
    800043cc:	953e                	add	a0,a0,a5
    800043ce:	611c                	ld	a5,0(a0)
    800043d0:	c385                	beqz	a5,800043f0 <argfd+0x5c>
    return -1;
  if(pfd)
    800043d2:	00090463          	beqz	s2,800043da <argfd+0x46>
    *pfd = fd;
    800043d6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043da:	4501                	li	a0,0
  if(pf)
    800043dc:	c091                	beqz	s1,800043e0 <argfd+0x4c>
    *pf = f;
    800043de:	e09c                	sd	a5,0(s1)
}
    800043e0:	70a2                	ld	ra,40(sp)
    800043e2:	7402                	ld	s0,32(sp)
    800043e4:	64e2                	ld	s1,24(sp)
    800043e6:	6942                	ld	s2,16(sp)
    800043e8:	6145                	addi	sp,sp,48
    800043ea:	8082                	ret
    return -1;
    800043ec:	557d                	li	a0,-1
    800043ee:	bfcd                	j	800043e0 <argfd+0x4c>
    800043f0:	557d                	li	a0,-1
    800043f2:	b7fd                	j	800043e0 <argfd+0x4c>

00000000800043f4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800043f4:	1101                	addi	sp,sp,-32
    800043f6:	ec06                	sd	ra,24(sp)
    800043f8:	e822                	sd	s0,16(sp)
    800043fa:	e426                	sd	s1,8(sp)
    800043fc:	1000                	addi	s0,sp,32
    800043fe:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004400:	ffffd097          	auipc	ra,0xffffd
    80004404:	a54080e7          	jalr	-1452(ra) # 80000e54 <myproc>
    80004408:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000440a:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd330>
    8000440e:	4501                	li	a0,0
    80004410:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004412:	6398                	ld	a4,0(a5)
    80004414:	cb19                	beqz	a4,8000442a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004416:	2505                	addiw	a0,a0,1
    80004418:	07a1                	addi	a5,a5,8
    8000441a:	fed51ce3          	bne	a0,a3,80004412 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000441e:	557d                	li	a0,-1
}
    80004420:	60e2                	ld	ra,24(sp)
    80004422:	6442                	ld	s0,16(sp)
    80004424:	64a2                	ld	s1,8(sp)
    80004426:	6105                	addi	sp,sp,32
    80004428:	8082                	ret
      p->ofile[fd] = f;
    8000442a:	01a50793          	addi	a5,a0,26
    8000442e:	078e                	slli	a5,a5,0x3
    80004430:	963e                	add	a2,a2,a5
    80004432:	e204                	sd	s1,0(a2)
      return fd;
    80004434:	b7f5                	j	80004420 <fdalloc+0x2c>

0000000080004436 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004436:	715d                	addi	sp,sp,-80
    80004438:	e486                	sd	ra,72(sp)
    8000443a:	e0a2                	sd	s0,64(sp)
    8000443c:	fc26                	sd	s1,56(sp)
    8000443e:	f84a                	sd	s2,48(sp)
    80004440:	f44e                	sd	s3,40(sp)
    80004442:	f052                	sd	s4,32(sp)
    80004444:	ec56                	sd	s5,24(sp)
    80004446:	e85a                	sd	s6,16(sp)
    80004448:	0880                	addi	s0,sp,80
    8000444a:	8b2e                	mv	s6,a1
    8000444c:	89b2                	mv	s3,a2
    8000444e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004450:	fb040593          	addi	a1,s0,-80
    80004454:	fffff097          	auipc	ra,0xfffff
    80004458:	e4e080e7          	jalr	-434(ra) # 800032a2 <nameiparent>
    8000445c:	84aa                	mv	s1,a0
    8000445e:	16050063          	beqz	a0,800045be <create+0x188>
    return 0;

  ilock(dp);
    80004462:	ffffe097          	auipc	ra,0xffffe
    80004466:	67c080e7          	jalr	1660(ra) # 80002ade <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000446a:	4601                	li	a2,0
    8000446c:	fb040593          	addi	a1,s0,-80
    80004470:	8526                	mv	a0,s1
    80004472:	fffff097          	auipc	ra,0xfffff
    80004476:	b50080e7          	jalr	-1200(ra) # 80002fc2 <dirlookup>
    8000447a:	8aaa                	mv	s5,a0
    8000447c:	c931                	beqz	a0,800044d0 <create+0x9a>
    iunlockput(dp);
    8000447e:	8526                	mv	a0,s1
    80004480:	fffff097          	auipc	ra,0xfffff
    80004484:	8c0080e7          	jalr	-1856(ra) # 80002d40 <iunlockput>
    ilock(ip);
    80004488:	8556                	mv	a0,s5
    8000448a:	ffffe097          	auipc	ra,0xffffe
    8000448e:	654080e7          	jalr	1620(ra) # 80002ade <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004492:	000b059b          	sext.w	a1,s6
    80004496:	4789                	li	a5,2
    80004498:	02f59563          	bne	a1,a5,800044c2 <create+0x8c>
    8000449c:	044ad783          	lhu	a5,68(s5)
    800044a0:	37f9                	addiw	a5,a5,-2
    800044a2:	17c2                	slli	a5,a5,0x30
    800044a4:	93c1                	srli	a5,a5,0x30
    800044a6:	4705                	li	a4,1
    800044a8:	00f76d63          	bltu	a4,a5,800044c2 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800044ac:	8556                	mv	a0,s5
    800044ae:	60a6                	ld	ra,72(sp)
    800044b0:	6406                	ld	s0,64(sp)
    800044b2:	74e2                	ld	s1,56(sp)
    800044b4:	7942                	ld	s2,48(sp)
    800044b6:	79a2                	ld	s3,40(sp)
    800044b8:	7a02                	ld	s4,32(sp)
    800044ba:	6ae2                	ld	s5,24(sp)
    800044bc:	6b42                	ld	s6,16(sp)
    800044be:	6161                	addi	sp,sp,80
    800044c0:	8082                	ret
    iunlockput(ip);
    800044c2:	8556                	mv	a0,s5
    800044c4:	fffff097          	auipc	ra,0xfffff
    800044c8:	87c080e7          	jalr	-1924(ra) # 80002d40 <iunlockput>
    return 0;
    800044cc:	4a81                	li	s5,0
    800044ce:	bff9                	j	800044ac <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800044d0:	85da                	mv	a1,s6
    800044d2:	4088                	lw	a0,0(s1)
    800044d4:	ffffe097          	auipc	ra,0xffffe
    800044d8:	46e080e7          	jalr	1134(ra) # 80002942 <ialloc>
    800044dc:	8a2a                	mv	s4,a0
    800044de:	c921                	beqz	a0,8000452e <create+0xf8>
  ilock(ip);
    800044e0:	ffffe097          	auipc	ra,0xffffe
    800044e4:	5fe080e7          	jalr	1534(ra) # 80002ade <ilock>
  ip->major = major;
    800044e8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800044ec:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800044f0:	4785                	li	a5,1
    800044f2:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800044f6:	8552                	mv	a0,s4
    800044f8:	ffffe097          	auipc	ra,0xffffe
    800044fc:	51c080e7          	jalr	1308(ra) # 80002a14 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004500:	000b059b          	sext.w	a1,s6
    80004504:	4785                	li	a5,1
    80004506:	02f58b63          	beq	a1,a5,8000453c <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    8000450a:	004a2603          	lw	a2,4(s4)
    8000450e:	fb040593          	addi	a1,s0,-80
    80004512:	8526                	mv	a0,s1
    80004514:	fffff097          	auipc	ra,0xfffff
    80004518:	cbe080e7          	jalr	-834(ra) # 800031d2 <dirlink>
    8000451c:	06054f63          	bltz	a0,8000459a <create+0x164>
  iunlockput(dp);
    80004520:	8526                	mv	a0,s1
    80004522:	fffff097          	auipc	ra,0xfffff
    80004526:	81e080e7          	jalr	-2018(ra) # 80002d40 <iunlockput>
  return ip;
    8000452a:	8ad2                	mv	s5,s4
    8000452c:	b741                	j	800044ac <create+0x76>
    iunlockput(dp);
    8000452e:	8526                	mv	a0,s1
    80004530:	fffff097          	auipc	ra,0xfffff
    80004534:	810080e7          	jalr	-2032(ra) # 80002d40 <iunlockput>
    return 0;
    80004538:	8ad2                	mv	s5,s4
    8000453a:	bf8d                	j	800044ac <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000453c:	004a2603          	lw	a2,4(s4)
    80004540:	00004597          	auipc	a1,0x4
    80004544:	17858593          	addi	a1,a1,376 # 800086b8 <syscalls+0x2e8>
    80004548:	8552                	mv	a0,s4
    8000454a:	fffff097          	auipc	ra,0xfffff
    8000454e:	c88080e7          	jalr	-888(ra) # 800031d2 <dirlink>
    80004552:	04054463          	bltz	a0,8000459a <create+0x164>
    80004556:	40d0                	lw	a2,4(s1)
    80004558:	00004597          	auipc	a1,0x4
    8000455c:	16858593          	addi	a1,a1,360 # 800086c0 <syscalls+0x2f0>
    80004560:	8552                	mv	a0,s4
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	c70080e7          	jalr	-912(ra) # 800031d2 <dirlink>
    8000456a:	02054863          	bltz	a0,8000459a <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    8000456e:	004a2603          	lw	a2,4(s4)
    80004572:	fb040593          	addi	a1,s0,-80
    80004576:	8526                	mv	a0,s1
    80004578:	fffff097          	auipc	ra,0xfffff
    8000457c:	c5a080e7          	jalr	-934(ra) # 800031d2 <dirlink>
    80004580:	00054d63          	bltz	a0,8000459a <create+0x164>
    dp->nlink++;  // for ".."
    80004584:	04a4d783          	lhu	a5,74(s1)
    80004588:	2785                	addiw	a5,a5,1
    8000458a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000458e:	8526                	mv	a0,s1
    80004590:	ffffe097          	auipc	ra,0xffffe
    80004594:	484080e7          	jalr	1156(ra) # 80002a14 <iupdate>
    80004598:	b761                	j	80004520 <create+0xea>
  ip->nlink = 0;
    8000459a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000459e:	8552                	mv	a0,s4
    800045a0:	ffffe097          	auipc	ra,0xffffe
    800045a4:	474080e7          	jalr	1140(ra) # 80002a14 <iupdate>
  iunlockput(ip);
    800045a8:	8552                	mv	a0,s4
    800045aa:	ffffe097          	auipc	ra,0xffffe
    800045ae:	796080e7          	jalr	1942(ra) # 80002d40 <iunlockput>
  iunlockput(dp);
    800045b2:	8526                	mv	a0,s1
    800045b4:	ffffe097          	auipc	ra,0xffffe
    800045b8:	78c080e7          	jalr	1932(ra) # 80002d40 <iunlockput>
  return 0;
    800045bc:	bdc5                	j	800044ac <create+0x76>
    return 0;
    800045be:	8aaa                	mv	s5,a0
    800045c0:	b5f5                	j	800044ac <create+0x76>

00000000800045c2 <sys_dup>:
{
    800045c2:	7179                	addi	sp,sp,-48
    800045c4:	f406                	sd	ra,40(sp)
    800045c6:	f022                	sd	s0,32(sp)
    800045c8:	ec26                	sd	s1,24(sp)
    800045ca:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045cc:	fd840613          	addi	a2,s0,-40
    800045d0:	4581                	li	a1,0
    800045d2:	4501                	li	a0,0
    800045d4:	00000097          	auipc	ra,0x0
    800045d8:	dc0080e7          	jalr	-576(ra) # 80004394 <argfd>
    return -1;
    800045dc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045de:	02054363          	bltz	a0,80004604 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800045e2:	fd843503          	ld	a0,-40(s0)
    800045e6:	00000097          	auipc	ra,0x0
    800045ea:	e0e080e7          	jalr	-498(ra) # 800043f4 <fdalloc>
    800045ee:	84aa                	mv	s1,a0
    return -1;
    800045f0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045f2:	00054963          	bltz	a0,80004604 <sys_dup+0x42>
  filedup(f);
    800045f6:	fd843503          	ld	a0,-40(s0)
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	320080e7          	jalr	800(ra) # 8000391a <filedup>
  return fd;
    80004602:	87a6                	mv	a5,s1
}
    80004604:	853e                	mv	a0,a5
    80004606:	70a2                	ld	ra,40(sp)
    80004608:	7402                	ld	s0,32(sp)
    8000460a:	64e2                	ld	s1,24(sp)
    8000460c:	6145                	addi	sp,sp,48
    8000460e:	8082                	ret

0000000080004610 <sys_read>:
{
    80004610:	7179                	addi	sp,sp,-48
    80004612:	f406                	sd	ra,40(sp)
    80004614:	f022                	sd	s0,32(sp)
    80004616:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004618:	fd840593          	addi	a1,s0,-40
    8000461c:	4505                	li	a0,1
    8000461e:	ffffe097          	auipc	ra,0xffffe
    80004622:	966080e7          	jalr	-1690(ra) # 80001f84 <argaddr>
  argint(2, &n);
    80004626:	fe440593          	addi	a1,s0,-28
    8000462a:	4509                	li	a0,2
    8000462c:	ffffe097          	auipc	ra,0xffffe
    80004630:	938080e7          	jalr	-1736(ra) # 80001f64 <argint>
  if(argfd(0, 0, &f) < 0)
    80004634:	fe840613          	addi	a2,s0,-24
    80004638:	4581                	li	a1,0
    8000463a:	4501                	li	a0,0
    8000463c:	00000097          	auipc	ra,0x0
    80004640:	d58080e7          	jalr	-680(ra) # 80004394 <argfd>
    80004644:	87aa                	mv	a5,a0
    return -1;
    80004646:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004648:	0007cc63          	bltz	a5,80004660 <sys_read+0x50>
  return fileread(f, p, n);
    8000464c:	fe442603          	lw	a2,-28(s0)
    80004650:	fd843583          	ld	a1,-40(s0)
    80004654:	fe843503          	ld	a0,-24(s0)
    80004658:	fffff097          	auipc	ra,0xfffff
    8000465c:	44e080e7          	jalr	1102(ra) # 80003aa6 <fileread>
}
    80004660:	70a2                	ld	ra,40(sp)
    80004662:	7402                	ld	s0,32(sp)
    80004664:	6145                	addi	sp,sp,48
    80004666:	8082                	ret

0000000080004668 <sys_write>:
{
    80004668:	7179                	addi	sp,sp,-48
    8000466a:	f406                	sd	ra,40(sp)
    8000466c:	f022                	sd	s0,32(sp)
    8000466e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004670:	fd840593          	addi	a1,s0,-40
    80004674:	4505                	li	a0,1
    80004676:	ffffe097          	auipc	ra,0xffffe
    8000467a:	90e080e7          	jalr	-1778(ra) # 80001f84 <argaddr>
  argint(2, &n);
    8000467e:	fe440593          	addi	a1,s0,-28
    80004682:	4509                	li	a0,2
    80004684:	ffffe097          	auipc	ra,0xffffe
    80004688:	8e0080e7          	jalr	-1824(ra) # 80001f64 <argint>
  if(argfd(0, 0, &f) < 0)
    8000468c:	fe840613          	addi	a2,s0,-24
    80004690:	4581                	li	a1,0
    80004692:	4501                	li	a0,0
    80004694:	00000097          	auipc	ra,0x0
    80004698:	d00080e7          	jalr	-768(ra) # 80004394 <argfd>
    8000469c:	87aa                	mv	a5,a0
    return -1;
    8000469e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046a0:	0007cc63          	bltz	a5,800046b8 <sys_write+0x50>
  return filewrite(f, p, n);
    800046a4:	fe442603          	lw	a2,-28(s0)
    800046a8:	fd843583          	ld	a1,-40(s0)
    800046ac:	fe843503          	ld	a0,-24(s0)
    800046b0:	fffff097          	auipc	ra,0xfffff
    800046b4:	4b8080e7          	jalr	1208(ra) # 80003b68 <filewrite>
}
    800046b8:	70a2                	ld	ra,40(sp)
    800046ba:	7402                	ld	s0,32(sp)
    800046bc:	6145                	addi	sp,sp,48
    800046be:	8082                	ret

00000000800046c0 <sys_close>:
{
    800046c0:	1101                	addi	sp,sp,-32
    800046c2:	ec06                	sd	ra,24(sp)
    800046c4:	e822                	sd	s0,16(sp)
    800046c6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046c8:	fe040613          	addi	a2,s0,-32
    800046cc:	fec40593          	addi	a1,s0,-20
    800046d0:	4501                	li	a0,0
    800046d2:	00000097          	auipc	ra,0x0
    800046d6:	cc2080e7          	jalr	-830(ra) # 80004394 <argfd>
    return -1;
    800046da:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046dc:	02054463          	bltz	a0,80004704 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046e0:	ffffc097          	auipc	ra,0xffffc
    800046e4:	774080e7          	jalr	1908(ra) # 80000e54 <myproc>
    800046e8:	fec42783          	lw	a5,-20(s0)
    800046ec:	07e9                	addi	a5,a5,26
    800046ee:	078e                	slli	a5,a5,0x3
    800046f0:	97aa                	add	a5,a5,a0
    800046f2:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800046f6:	fe043503          	ld	a0,-32(s0)
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	272080e7          	jalr	626(ra) # 8000396c <fileclose>
  return 0;
    80004702:	4781                	li	a5,0
}
    80004704:	853e                	mv	a0,a5
    80004706:	60e2                	ld	ra,24(sp)
    80004708:	6442                	ld	s0,16(sp)
    8000470a:	6105                	addi	sp,sp,32
    8000470c:	8082                	ret

000000008000470e <sys_fstat>:
{
    8000470e:	1101                	addi	sp,sp,-32
    80004710:	ec06                	sd	ra,24(sp)
    80004712:	e822                	sd	s0,16(sp)
    80004714:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004716:	fe040593          	addi	a1,s0,-32
    8000471a:	4505                	li	a0,1
    8000471c:	ffffe097          	auipc	ra,0xffffe
    80004720:	868080e7          	jalr	-1944(ra) # 80001f84 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004724:	fe840613          	addi	a2,s0,-24
    80004728:	4581                	li	a1,0
    8000472a:	4501                	li	a0,0
    8000472c:	00000097          	auipc	ra,0x0
    80004730:	c68080e7          	jalr	-920(ra) # 80004394 <argfd>
    80004734:	87aa                	mv	a5,a0
    return -1;
    80004736:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004738:	0007ca63          	bltz	a5,8000474c <sys_fstat+0x3e>
  return filestat(f, st);
    8000473c:	fe043583          	ld	a1,-32(s0)
    80004740:	fe843503          	ld	a0,-24(s0)
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	2f0080e7          	jalr	752(ra) # 80003a34 <filestat>
}
    8000474c:	60e2                	ld	ra,24(sp)
    8000474e:	6442                	ld	s0,16(sp)
    80004750:	6105                	addi	sp,sp,32
    80004752:	8082                	ret

0000000080004754 <sys_link>:
{
    80004754:	7169                	addi	sp,sp,-304
    80004756:	f606                	sd	ra,296(sp)
    80004758:	f222                	sd	s0,288(sp)
    8000475a:	ee26                	sd	s1,280(sp)
    8000475c:	ea4a                	sd	s2,272(sp)
    8000475e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004760:	08000613          	li	a2,128
    80004764:	ed040593          	addi	a1,s0,-304
    80004768:	4501                	li	a0,0
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	83a080e7          	jalr	-1990(ra) # 80001fa4 <argstr>
    return -1;
    80004772:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004774:	10054e63          	bltz	a0,80004890 <sys_link+0x13c>
    80004778:	08000613          	li	a2,128
    8000477c:	f5040593          	addi	a1,s0,-176
    80004780:	4505                	li	a0,1
    80004782:	ffffe097          	auipc	ra,0xffffe
    80004786:	822080e7          	jalr	-2014(ra) # 80001fa4 <argstr>
    return -1;
    8000478a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000478c:	10054263          	bltz	a0,80004890 <sys_link+0x13c>
  begin_op();
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	d10080e7          	jalr	-752(ra) # 800034a0 <begin_op>
  if((ip = namei(old)) == 0){
    80004798:	ed040513          	addi	a0,s0,-304
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	ae8080e7          	jalr	-1304(ra) # 80003284 <namei>
    800047a4:	84aa                	mv	s1,a0
    800047a6:	c551                	beqz	a0,80004832 <sys_link+0xde>
  ilock(ip);
    800047a8:	ffffe097          	auipc	ra,0xffffe
    800047ac:	336080e7          	jalr	822(ra) # 80002ade <ilock>
  if(ip->type == T_DIR){
    800047b0:	04449703          	lh	a4,68(s1)
    800047b4:	4785                	li	a5,1
    800047b6:	08f70463          	beq	a4,a5,8000483e <sys_link+0xea>
  ip->nlink++;
    800047ba:	04a4d783          	lhu	a5,74(s1)
    800047be:	2785                	addiw	a5,a5,1
    800047c0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047c4:	8526                	mv	a0,s1
    800047c6:	ffffe097          	auipc	ra,0xffffe
    800047ca:	24e080e7          	jalr	590(ra) # 80002a14 <iupdate>
  iunlock(ip);
    800047ce:	8526                	mv	a0,s1
    800047d0:	ffffe097          	auipc	ra,0xffffe
    800047d4:	3d0080e7          	jalr	976(ra) # 80002ba0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047d8:	fd040593          	addi	a1,s0,-48
    800047dc:	f5040513          	addi	a0,s0,-176
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	ac2080e7          	jalr	-1342(ra) # 800032a2 <nameiparent>
    800047e8:	892a                	mv	s2,a0
    800047ea:	c935                	beqz	a0,8000485e <sys_link+0x10a>
  ilock(dp);
    800047ec:	ffffe097          	auipc	ra,0xffffe
    800047f0:	2f2080e7          	jalr	754(ra) # 80002ade <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800047f4:	00092703          	lw	a4,0(s2)
    800047f8:	409c                	lw	a5,0(s1)
    800047fa:	04f71d63          	bne	a4,a5,80004854 <sys_link+0x100>
    800047fe:	40d0                	lw	a2,4(s1)
    80004800:	fd040593          	addi	a1,s0,-48
    80004804:	854a                	mv	a0,s2
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	9cc080e7          	jalr	-1588(ra) # 800031d2 <dirlink>
    8000480e:	04054363          	bltz	a0,80004854 <sys_link+0x100>
  iunlockput(dp);
    80004812:	854a                	mv	a0,s2
    80004814:	ffffe097          	auipc	ra,0xffffe
    80004818:	52c080e7          	jalr	1324(ra) # 80002d40 <iunlockput>
  iput(ip);
    8000481c:	8526                	mv	a0,s1
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	47a080e7          	jalr	1146(ra) # 80002c98 <iput>
  end_op();
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	cfa080e7          	jalr	-774(ra) # 80003520 <end_op>
  return 0;
    8000482e:	4781                	li	a5,0
    80004830:	a085                	j	80004890 <sys_link+0x13c>
    end_op();
    80004832:	fffff097          	auipc	ra,0xfffff
    80004836:	cee080e7          	jalr	-786(ra) # 80003520 <end_op>
    return -1;
    8000483a:	57fd                	li	a5,-1
    8000483c:	a891                	j	80004890 <sys_link+0x13c>
    iunlockput(ip);
    8000483e:	8526                	mv	a0,s1
    80004840:	ffffe097          	auipc	ra,0xffffe
    80004844:	500080e7          	jalr	1280(ra) # 80002d40 <iunlockput>
    end_op();
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	cd8080e7          	jalr	-808(ra) # 80003520 <end_op>
    return -1;
    80004850:	57fd                	li	a5,-1
    80004852:	a83d                	j	80004890 <sys_link+0x13c>
    iunlockput(dp);
    80004854:	854a                	mv	a0,s2
    80004856:	ffffe097          	auipc	ra,0xffffe
    8000485a:	4ea080e7          	jalr	1258(ra) # 80002d40 <iunlockput>
  ilock(ip);
    8000485e:	8526                	mv	a0,s1
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	27e080e7          	jalr	638(ra) # 80002ade <ilock>
  ip->nlink--;
    80004868:	04a4d783          	lhu	a5,74(s1)
    8000486c:	37fd                	addiw	a5,a5,-1
    8000486e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004872:	8526                	mv	a0,s1
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	1a0080e7          	jalr	416(ra) # 80002a14 <iupdate>
  iunlockput(ip);
    8000487c:	8526                	mv	a0,s1
    8000487e:	ffffe097          	auipc	ra,0xffffe
    80004882:	4c2080e7          	jalr	1218(ra) # 80002d40 <iunlockput>
  end_op();
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	c9a080e7          	jalr	-870(ra) # 80003520 <end_op>
  return -1;
    8000488e:	57fd                	li	a5,-1
}
    80004890:	853e                	mv	a0,a5
    80004892:	70b2                	ld	ra,296(sp)
    80004894:	7412                	ld	s0,288(sp)
    80004896:	64f2                	ld	s1,280(sp)
    80004898:	6952                	ld	s2,272(sp)
    8000489a:	6155                	addi	sp,sp,304
    8000489c:	8082                	ret

000000008000489e <sys_unlink>:
{
    8000489e:	7151                	addi	sp,sp,-240
    800048a0:	f586                	sd	ra,232(sp)
    800048a2:	f1a2                	sd	s0,224(sp)
    800048a4:	eda6                	sd	s1,216(sp)
    800048a6:	e9ca                	sd	s2,208(sp)
    800048a8:	e5ce                	sd	s3,200(sp)
    800048aa:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048ac:	08000613          	li	a2,128
    800048b0:	f3040593          	addi	a1,s0,-208
    800048b4:	4501                	li	a0,0
    800048b6:	ffffd097          	auipc	ra,0xffffd
    800048ba:	6ee080e7          	jalr	1774(ra) # 80001fa4 <argstr>
    800048be:	18054163          	bltz	a0,80004a40 <sys_unlink+0x1a2>
  begin_op();
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	bde080e7          	jalr	-1058(ra) # 800034a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048ca:	fb040593          	addi	a1,s0,-80
    800048ce:	f3040513          	addi	a0,s0,-208
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	9d0080e7          	jalr	-1584(ra) # 800032a2 <nameiparent>
    800048da:	84aa                	mv	s1,a0
    800048dc:	c979                	beqz	a0,800049b2 <sys_unlink+0x114>
  ilock(dp);
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	200080e7          	jalr	512(ra) # 80002ade <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048e6:	00004597          	auipc	a1,0x4
    800048ea:	dd258593          	addi	a1,a1,-558 # 800086b8 <syscalls+0x2e8>
    800048ee:	fb040513          	addi	a0,s0,-80
    800048f2:	ffffe097          	auipc	ra,0xffffe
    800048f6:	6b6080e7          	jalr	1718(ra) # 80002fa8 <namecmp>
    800048fa:	14050a63          	beqz	a0,80004a4e <sys_unlink+0x1b0>
    800048fe:	00004597          	auipc	a1,0x4
    80004902:	dc258593          	addi	a1,a1,-574 # 800086c0 <syscalls+0x2f0>
    80004906:	fb040513          	addi	a0,s0,-80
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	69e080e7          	jalr	1694(ra) # 80002fa8 <namecmp>
    80004912:	12050e63          	beqz	a0,80004a4e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004916:	f2c40613          	addi	a2,s0,-212
    8000491a:	fb040593          	addi	a1,s0,-80
    8000491e:	8526                	mv	a0,s1
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	6a2080e7          	jalr	1698(ra) # 80002fc2 <dirlookup>
    80004928:	892a                	mv	s2,a0
    8000492a:	12050263          	beqz	a0,80004a4e <sys_unlink+0x1b0>
  ilock(ip);
    8000492e:	ffffe097          	auipc	ra,0xffffe
    80004932:	1b0080e7          	jalr	432(ra) # 80002ade <ilock>
  if(ip->nlink < 1)
    80004936:	04a91783          	lh	a5,74(s2)
    8000493a:	08f05263          	blez	a5,800049be <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000493e:	04491703          	lh	a4,68(s2)
    80004942:	4785                	li	a5,1
    80004944:	08f70563          	beq	a4,a5,800049ce <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004948:	4641                	li	a2,16
    8000494a:	4581                	li	a1,0
    8000494c:	fc040513          	addi	a0,s0,-64
    80004950:	ffffc097          	auipc	ra,0xffffc
    80004954:	828080e7          	jalr	-2008(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004958:	4741                	li	a4,16
    8000495a:	f2c42683          	lw	a3,-212(s0)
    8000495e:	fc040613          	addi	a2,s0,-64
    80004962:	4581                	li	a1,0
    80004964:	8526                	mv	a0,s1
    80004966:	ffffe097          	auipc	ra,0xffffe
    8000496a:	524080e7          	jalr	1316(ra) # 80002e8a <writei>
    8000496e:	47c1                	li	a5,16
    80004970:	0af51563          	bne	a0,a5,80004a1a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004974:	04491703          	lh	a4,68(s2)
    80004978:	4785                	li	a5,1
    8000497a:	0af70863          	beq	a4,a5,80004a2a <sys_unlink+0x18c>
  iunlockput(dp);
    8000497e:	8526                	mv	a0,s1
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	3c0080e7          	jalr	960(ra) # 80002d40 <iunlockput>
  ip->nlink--;
    80004988:	04a95783          	lhu	a5,74(s2)
    8000498c:	37fd                	addiw	a5,a5,-1
    8000498e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004992:	854a                	mv	a0,s2
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	080080e7          	jalr	128(ra) # 80002a14 <iupdate>
  iunlockput(ip);
    8000499c:	854a                	mv	a0,s2
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	3a2080e7          	jalr	930(ra) # 80002d40 <iunlockput>
  end_op();
    800049a6:	fffff097          	auipc	ra,0xfffff
    800049aa:	b7a080e7          	jalr	-1158(ra) # 80003520 <end_op>
  return 0;
    800049ae:	4501                	li	a0,0
    800049b0:	a84d                	j	80004a62 <sys_unlink+0x1c4>
    end_op();
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	b6e080e7          	jalr	-1170(ra) # 80003520 <end_op>
    return -1;
    800049ba:	557d                	li	a0,-1
    800049bc:	a05d                	j	80004a62 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049be:	00004517          	auipc	a0,0x4
    800049c2:	d0a50513          	addi	a0,a0,-758 # 800086c8 <syscalls+0x2f8>
    800049c6:	00001097          	auipc	ra,0x1
    800049ca:	21c080e7          	jalr	540(ra) # 80005be2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049ce:	04c92703          	lw	a4,76(s2)
    800049d2:	02000793          	li	a5,32
    800049d6:	f6e7f9e3          	bgeu	a5,a4,80004948 <sys_unlink+0xaa>
    800049da:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049de:	4741                	li	a4,16
    800049e0:	86ce                	mv	a3,s3
    800049e2:	f1840613          	addi	a2,s0,-232
    800049e6:	4581                	li	a1,0
    800049e8:	854a                	mv	a0,s2
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	3a8080e7          	jalr	936(ra) # 80002d92 <readi>
    800049f2:	47c1                	li	a5,16
    800049f4:	00f51b63          	bne	a0,a5,80004a0a <sys_unlink+0x16c>
    if(de.inum != 0)
    800049f8:	f1845783          	lhu	a5,-232(s0)
    800049fc:	e7a1                	bnez	a5,80004a44 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049fe:	29c1                	addiw	s3,s3,16
    80004a00:	04c92783          	lw	a5,76(s2)
    80004a04:	fcf9ede3          	bltu	s3,a5,800049de <sys_unlink+0x140>
    80004a08:	b781                	j	80004948 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a0a:	00004517          	auipc	a0,0x4
    80004a0e:	cd650513          	addi	a0,a0,-810 # 800086e0 <syscalls+0x310>
    80004a12:	00001097          	auipc	ra,0x1
    80004a16:	1d0080e7          	jalr	464(ra) # 80005be2 <panic>
    panic("unlink: writei");
    80004a1a:	00004517          	auipc	a0,0x4
    80004a1e:	cde50513          	addi	a0,a0,-802 # 800086f8 <syscalls+0x328>
    80004a22:	00001097          	auipc	ra,0x1
    80004a26:	1c0080e7          	jalr	448(ra) # 80005be2 <panic>
    dp->nlink--;
    80004a2a:	04a4d783          	lhu	a5,74(s1)
    80004a2e:	37fd                	addiw	a5,a5,-1
    80004a30:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	fde080e7          	jalr	-34(ra) # 80002a14 <iupdate>
    80004a3e:	b781                	j	8000497e <sys_unlink+0xe0>
    return -1;
    80004a40:	557d                	li	a0,-1
    80004a42:	a005                	j	80004a62 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a44:	854a                	mv	a0,s2
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	2fa080e7          	jalr	762(ra) # 80002d40 <iunlockput>
  iunlockput(dp);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	2f0080e7          	jalr	752(ra) # 80002d40 <iunlockput>
  end_op();
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	ac8080e7          	jalr	-1336(ra) # 80003520 <end_op>
  return -1;
    80004a60:	557d                	li	a0,-1
}
    80004a62:	70ae                	ld	ra,232(sp)
    80004a64:	740e                	ld	s0,224(sp)
    80004a66:	64ee                	ld	s1,216(sp)
    80004a68:	694e                	ld	s2,208(sp)
    80004a6a:	69ae                	ld	s3,200(sp)
    80004a6c:	616d                	addi	sp,sp,240
    80004a6e:	8082                	ret

0000000080004a70 <sys_open>:

uint64
sys_open(void)
{
    80004a70:	7131                	addi	sp,sp,-192
    80004a72:	fd06                	sd	ra,184(sp)
    80004a74:	f922                	sd	s0,176(sp)
    80004a76:	f526                	sd	s1,168(sp)
    80004a78:	f14a                	sd	s2,160(sp)
    80004a7a:	ed4e                	sd	s3,152(sp)
    80004a7c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a7e:	f4c40593          	addi	a1,s0,-180
    80004a82:	4505                	li	a0,1
    80004a84:	ffffd097          	auipc	ra,0xffffd
    80004a88:	4e0080e7          	jalr	1248(ra) # 80001f64 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a8c:	08000613          	li	a2,128
    80004a90:	f5040593          	addi	a1,s0,-176
    80004a94:	4501                	li	a0,0
    80004a96:	ffffd097          	auipc	ra,0xffffd
    80004a9a:	50e080e7          	jalr	1294(ra) # 80001fa4 <argstr>
    80004a9e:	87aa                	mv	a5,a0
    return -1;
    80004aa0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004aa2:	0a07c963          	bltz	a5,80004b54 <sys_open+0xe4>

  begin_op();
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	9fa080e7          	jalr	-1542(ra) # 800034a0 <begin_op>

  if(omode & O_CREATE){
    80004aae:	f4c42783          	lw	a5,-180(s0)
    80004ab2:	2007f793          	andi	a5,a5,512
    80004ab6:	cfc5                	beqz	a5,80004b6e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ab8:	4681                	li	a3,0
    80004aba:	4601                	li	a2,0
    80004abc:	4589                	li	a1,2
    80004abe:	f5040513          	addi	a0,s0,-176
    80004ac2:	00000097          	auipc	ra,0x0
    80004ac6:	974080e7          	jalr	-1676(ra) # 80004436 <create>
    80004aca:	84aa                	mv	s1,a0
    if(ip == 0){
    80004acc:	c959                	beqz	a0,80004b62 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ace:	04449703          	lh	a4,68(s1)
    80004ad2:	478d                	li	a5,3
    80004ad4:	00f71763          	bne	a4,a5,80004ae2 <sys_open+0x72>
    80004ad8:	0464d703          	lhu	a4,70(s1)
    80004adc:	47a5                	li	a5,9
    80004ade:	0ce7ed63          	bltu	a5,a4,80004bb8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	dce080e7          	jalr	-562(ra) # 800038b0 <filealloc>
    80004aea:	89aa                	mv	s3,a0
    80004aec:	10050363          	beqz	a0,80004bf2 <sys_open+0x182>
    80004af0:	00000097          	auipc	ra,0x0
    80004af4:	904080e7          	jalr	-1788(ra) # 800043f4 <fdalloc>
    80004af8:	892a                	mv	s2,a0
    80004afa:	0e054763          	bltz	a0,80004be8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004afe:	04449703          	lh	a4,68(s1)
    80004b02:	478d                	li	a5,3
    80004b04:	0cf70563          	beq	a4,a5,80004bce <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b08:	4789                	li	a5,2
    80004b0a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b0e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b12:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b16:	f4c42783          	lw	a5,-180(s0)
    80004b1a:	0017c713          	xori	a4,a5,1
    80004b1e:	8b05                	andi	a4,a4,1
    80004b20:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b24:	0037f713          	andi	a4,a5,3
    80004b28:	00e03733          	snez	a4,a4
    80004b2c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b30:	4007f793          	andi	a5,a5,1024
    80004b34:	c791                	beqz	a5,80004b40 <sys_open+0xd0>
    80004b36:	04449703          	lh	a4,68(s1)
    80004b3a:	4789                	li	a5,2
    80004b3c:	0af70063          	beq	a4,a5,80004bdc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	05e080e7          	jalr	94(ra) # 80002ba0 <iunlock>
  end_op();
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	9d6080e7          	jalr	-1578(ra) # 80003520 <end_op>

  return fd;
    80004b52:	854a                	mv	a0,s2
}
    80004b54:	70ea                	ld	ra,184(sp)
    80004b56:	744a                	ld	s0,176(sp)
    80004b58:	74aa                	ld	s1,168(sp)
    80004b5a:	790a                	ld	s2,160(sp)
    80004b5c:	69ea                	ld	s3,152(sp)
    80004b5e:	6129                	addi	sp,sp,192
    80004b60:	8082                	ret
      end_op();
    80004b62:	fffff097          	auipc	ra,0xfffff
    80004b66:	9be080e7          	jalr	-1602(ra) # 80003520 <end_op>
      return -1;
    80004b6a:	557d                	li	a0,-1
    80004b6c:	b7e5                	j	80004b54 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b6e:	f5040513          	addi	a0,s0,-176
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	712080e7          	jalr	1810(ra) # 80003284 <namei>
    80004b7a:	84aa                	mv	s1,a0
    80004b7c:	c905                	beqz	a0,80004bac <sys_open+0x13c>
    ilock(ip);
    80004b7e:	ffffe097          	auipc	ra,0xffffe
    80004b82:	f60080e7          	jalr	-160(ra) # 80002ade <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b86:	04449703          	lh	a4,68(s1)
    80004b8a:	4785                	li	a5,1
    80004b8c:	f4f711e3          	bne	a4,a5,80004ace <sys_open+0x5e>
    80004b90:	f4c42783          	lw	a5,-180(s0)
    80004b94:	d7b9                	beqz	a5,80004ae2 <sys_open+0x72>
      iunlockput(ip);
    80004b96:	8526                	mv	a0,s1
    80004b98:	ffffe097          	auipc	ra,0xffffe
    80004b9c:	1a8080e7          	jalr	424(ra) # 80002d40 <iunlockput>
      end_op();
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	980080e7          	jalr	-1664(ra) # 80003520 <end_op>
      return -1;
    80004ba8:	557d                	li	a0,-1
    80004baa:	b76d                	j	80004b54 <sys_open+0xe4>
      end_op();
    80004bac:	fffff097          	auipc	ra,0xfffff
    80004bb0:	974080e7          	jalr	-1676(ra) # 80003520 <end_op>
      return -1;
    80004bb4:	557d                	li	a0,-1
    80004bb6:	bf79                	j	80004b54 <sys_open+0xe4>
    iunlockput(ip);
    80004bb8:	8526                	mv	a0,s1
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	186080e7          	jalr	390(ra) # 80002d40 <iunlockput>
    end_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	95e080e7          	jalr	-1698(ra) # 80003520 <end_op>
    return -1;
    80004bca:	557d                	li	a0,-1
    80004bcc:	b761                	j	80004b54 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004bce:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004bd2:	04649783          	lh	a5,70(s1)
    80004bd6:	02f99223          	sh	a5,36(s3)
    80004bda:	bf25                	j	80004b12 <sys_open+0xa2>
    itrunc(ip);
    80004bdc:	8526                	mv	a0,s1
    80004bde:	ffffe097          	auipc	ra,0xffffe
    80004be2:	00e080e7          	jalr	14(ra) # 80002bec <itrunc>
    80004be6:	bfa9                	j	80004b40 <sys_open+0xd0>
      fileclose(f);
    80004be8:	854e                	mv	a0,s3
    80004bea:	fffff097          	auipc	ra,0xfffff
    80004bee:	d82080e7          	jalr	-638(ra) # 8000396c <fileclose>
    iunlockput(ip);
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	14c080e7          	jalr	332(ra) # 80002d40 <iunlockput>
    end_op();
    80004bfc:	fffff097          	auipc	ra,0xfffff
    80004c00:	924080e7          	jalr	-1756(ra) # 80003520 <end_op>
    return -1;
    80004c04:	557d                	li	a0,-1
    80004c06:	b7b9                	j	80004b54 <sys_open+0xe4>

0000000080004c08 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c08:	7175                	addi	sp,sp,-144
    80004c0a:	e506                	sd	ra,136(sp)
    80004c0c:	e122                	sd	s0,128(sp)
    80004c0e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c10:	fffff097          	auipc	ra,0xfffff
    80004c14:	890080e7          	jalr	-1904(ra) # 800034a0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c18:	08000613          	li	a2,128
    80004c1c:	f7040593          	addi	a1,s0,-144
    80004c20:	4501                	li	a0,0
    80004c22:	ffffd097          	auipc	ra,0xffffd
    80004c26:	382080e7          	jalr	898(ra) # 80001fa4 <argstr>
    80004c2a:	02054963          	bltz	a0,80004c5c <sys_mkdir+0x54>
    80004c2e:	4681                	li	a3,0
    80004c30:	4601                	li	a2,0
    80004c32:	4585                	li	a1,1
    80004c34:	f7040513          	addi	a0,s0,-144
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	7fe080e7          	jalr	2046(ra) # 80004436 <create>
    80004c40:	cd11                	beqz	a0,80004c5c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	0fe080e7          	jalr	254(ra) # 80002d40 <iunlockput>
  end_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	8d6080e7          	jalr	-1834(ra) # 80003520 <end_op>
  return 0;
    80004c52:	4501                	li	a0,0
}
    80004c54:	60aa                	ld	ra,136(sp)
    80004c56:	640a                	ld	s0,128(sp)
    80004c58:	6149                	addi	sp,sp,144
    80004c5a:	8082                	ret
    end_op();
    80004c5c:	fffff097          	auipc	ra,0xfffff
    80004c60:	8c4080e7          	jalr	-1852(ra) # 80003520 <end_op>
    return -1;
    80004c64:	557d                	li	a0,-1
    80004c66:	b7fd                	j	80004c54 <sys_mkdir+0x4c>

0000000080004c68 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c68:	7135                	addi	sp,sp,-160
    80004c6a:	ed06                	sd	ra,152(sp)
    80004c6c:	e922                	sd	s0,144(sp)
    80004c6e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	830080e7          	jalr	-2000(ra) # 800034a0 <begin_op>
  argint(1, &major);
    80004c78:	f6c40593          	addi	a1,s0,-148
    80004c7c:	4505                	li	a0,1
    80004c7e:	ffffd097          	auipc	ra,0xffffd
    80004c82:	2e6080e7          	jalr	742(ra) # 80001f64 <argint>
  argint(2, &minor);
    80004c86:	f6840593          	addi	a1,s0,-152
    80004c8a:	4509                	li	a0,2
    80004c8c:	ffffd097          	auipc	ra,0xffffd
    80004c90:	2d8080e7          	jalr	728(ra) # 80001f64 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c94:	08000613          	li	a2,128
    80004c98:	f7040593          	addi	a1,s0,-144
    80004c9c:	4501                	li	a0,0
    80004c9e:	ffffd097          	auipc	ra,0xffffd
    80004ca2:	306080e7          	jalr	774(ra) # 80001fa4 <argstr>
    80004ca6:	02054b63          	bltz	a0,80004cdc <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004caa:	f6841683          	lh	a3,-152(s0)
    80004cae:	f6c41603          	lh	a2,-148(s0)
    80004cb2:	458d                	li	a1,3
    80004cb4:	f7040513          	addi	a0,s0,-144
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	77e080e7          	jalr	1918(ra) # 80004436 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cc0:	cd11                	beqz	a0,80004cdc <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cc2:	ffffe097          	auipc	ra,0xffffe
    80004cc6:	07e080e7          	jalr	126(ra) # 80002d40 <iunlockput>
  end_op();
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	856080e7          	jalr	-1962(ra) # 80003520 <end_op>
  return 0;
    80004cd2:	4501                	li	a0,0
}
    80004cd4:	60ea                	ld	ra,152(sp)
    80004cd6:	644a                	ld	s0,144(sp)
    80004cd8:	610d                	addi	sp,sp,160
    80004cda:	8082                	ret
    end_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	844080e7          	jalr	-1980(ra) # 80003520 <end_op>
    return -1;
    80004ce4:	557d                	li	a0,-1
    80004ce6:	b7fd                	j	80004cd4 <sys_mknod+0x6c>

0000000080004ce8 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ce8:	7135                	addi	sp,sp,-160
    80004cea:	ed06                	sd	ra,152(sp)
    80004cec:	e922                	sd	s0,144(sp)
    80004cee:	e526                	sd	s1,136(sp)
    80004cf0:	e14a                	sd	s2,128(sp)
    80004cf2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004cf4:	ffffc097          	auipc	ra,0xffffc
    80004cf8:	160080e7          	jalr	352(ra) # 80000e54 <myproc>
    80004cfc:	892a                	mv	s2,a0
  
  begin_op();
    80004cfe:	ffffe097          	auipc	ra,0xffffe
    80004d02:	7a2080e7          	jalr	1954(ra) # 800034a0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d06:	08000613          	li	a2,128
    80004d0a:	f6040593          	addi	a1,s0,-160
    80004d0e:	4501                	li	a0,0
    80004d10:	ffffd097          	auipc	ra,0xffffd
    80004d14:	294080e7          	jalr	660(ra) # 80001fa4 <argstr>
    80004d18:	04054b63          	bltz	a0,80004d6e <sys_chdir+0x86>
    80004d1c:	f6040513          	addi	a0,s0,-160
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	564080e7          	jalr	1380(ra) # 80003284 <namei>
    80004d28:	84aa                	mv	s1,a0
    80004d2a:	c131                	beqz	a0,80004d6e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d2c:	ffffe097          	auipc	ra,0xffffe
    80004d30:	db2080e7          	jalr	-590(ra) # 80002ade <ilock>
  if(ip->type != T_DIR){
    80004d34:	04449703          	lh	a4,68(s1)
    80004d38:	4785                	li	a5,1
    80004d3a:	04f71063          	bne	a4,a5,80004d7a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d3e:	8526                	mv	a0,s1
    80004d40:	ffffe097          	auipc	ra,0xffffe
    80004d44:	e60080e7          	jalr	-416(ra) # 80002ba0 <iunlock>
  iput(p->cwd);
    80004d48:	15093503          	ld	a0,336(s2)
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	f4c080e7          	jalr	-180(ra) # 80002c98 <iput>
  end_op();
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	7cc080e7          	jalr	1996(ra) # 80003520 <end_op>
  p->cwd = ip;
    80004d5c:	14993823          	sd	s1,336(s2)
  return 0;
    80004d60:	4501                	li	a0,0
}
    80004d62:	60ea                	ld	ra,152(sp)
    80004d64:	644a                	ld	s0,144(sp)
    80004d66:	64aa                	ld	s1,136(sp)
    80004d68:	690a                	ld	s2,128(sp)
    80004d6a:	610d                	addi	sp,sp,160
    80004d6c:	8082                	ret
    end_op();
    80004d6e:	ffffe097          	auipc	ra,0xffffe
    80004d72:	7b2080e7          	jalr	1970(ra) # 80003520 <end_op>
    return -1;
    80004d76:	557d                	li	a0,-1
    80004d78:	b7ed                	j	80004d62 <sys_chdir+0x7a>
    iunlockput(ip);
    80004d7a:	8526                	mv	a0,s1
    80004d7c:	ffffe097          	auipc	ra,0xffffe
    80004d80:	fc4080e7          	jalr	-60(ra) # 80002d40 <iunlockput>
    end_op();
    80004d84:	ffffe097          	auipc	ra,0xffffe
    80004d88:	79c080e7          	jalr	1948(ra) # 80003520 <end_op>
    return -1;
    80004d8c:	557d                	li	a0,-1
    80004d8e:	bfd1                	j	80004d62 <sys_chdir+0x7a>

0000000080004d90 <sys_exec>:

uint64
sys_exec(void)
{
    80004d90:	7145                	addi	sp,sp,-464
    80004d92:	e786                	sd	ra,456(sp)
    80004d94:	e3a2                	sd	s0,448(sp)
    80004d96:	ff26                	sd	s1,440(sp)
    80004d98:	fb4a                	sd	s2,432(sp)
    80004d9a:	f74e                	sd	s3,424(sp)
    80004d9c:	f352                	sd	s4,416(sp)
    80004d9e:	ef56                	sd	s5,408(sp)
    80004da0:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004da2:	e3840593          	addi	a1,s0,-456
    80004da6:	4505                	li	a0,1
    80004da8:	ffffd097          	auipc	ra,0xffffd
    80004dac:	1dc080e7          	jalr	476(ra) # 80001f84 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004db0:	08000613          	li	a2,128
    80004db4:	f4040593          	addi	a1,s0,-192
    80004db8:	4501                	li	a0,0
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	1ea080e7          	jalr	490(ra) # 80001fa4 <argstr>
    80004dc2:	87aa                	mv	a5,a0
    return -1;
    80004dc4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004dc6:	0c07c263          	bltz	a5,80004e8a <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004dca:	10000613          	li	a2,256
    80004dce:	4581                	li	a1,0
    80004dd0:	e4040513          	addi	a0,s0,-448
    80004dd4:	ffffb097          	auipc	ra,0xffffb
    80004dd8:	3a4080e7          	jalr	932(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ddc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004de0:	89a6                	mv	s3,s1
    80004de2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004de4:	02000a13          	li	s4,32
    80004de8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004dec:	00391513          	slli	a0,s2,0x3
    80004df0:	e3040593          	addi	a1,s0,-464
    80004df4:	e3843783          	ld	a5,-456(s0)
    80004df8:	953e                	add	a0,a0,a5
    80004dfa:	ffffd097          	auipc	ra,0xffffd
    80004dfe:	0cc080e7          	jalr	204(ra) # 80001ec6 <fetchaddr>
    80004e02:	02054a63          	bltz	a0,80004e36 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e06:	e3043783          	ld	a5,-464(s0)
    80004e0a:	c3b9                	beqz	a5,80004e50 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e0c:	ffffb097          	auipc	ra,0xffffb
    80004e10:	30c080e7          	jalr	780(ra) # 80000118 <kalloc>
    80004e14:	85aa                	mv	a1,a0
    80004e16:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e1a:	cd11                	beqz	a0,80004e36 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e1c:	6605                	lui	a2,0x1
    80004e1e:	e3043503          	ld	a0,-464(s0)
    80004e22:	ffffd097          	auipc	ra,0xffffd
    80004e26:	0f6080e7          	jalr	246(ra) # 80001f18 <fetchstr>
    80004e2a:	00054663          	bltz	a0,80004e36 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004e2e:	0905                	addi	s2,s2,1
    80004e30:	09a1                	addi	s3,s3,8
    80004e32:	fb491be3          	bne	s2,s4,80004de8 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e36:	10048913          	addi	s2,s1,256
    80004e3a:	6088                	ld	a0,0(s1)
    80004e3c:	c531                	beqz	a0,80004e88 <sys_exec+0xf8>
    kfree(argv[i]);
    80004e3e:	ffffb097          	auipc	ra,0xffffb
    80004e42:	1de080e7          	jalr	478(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e46:	04a1                	addi	s1,s1,8
    80004e48:	ff2499e3          	bne	s1,s2,80004e3a <sys_exec+0xaa>
  return -1;
    80004e4c:	557d                	li	a0,-1
    80004e4e:	a835                	j	80004e8a <sys_exec+0xfa>
      argv[i] = 0;
    80004e50:	0a8e                	slli	s5,s5,0x3
    80004e52:	fc040793          	addi	a5,s0,-64
    80004e56:	9abe                	add	s5,s5,a5
    80004e58:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e5c:	e4040593          	addi	a1,s0,-448
    80004e60:	f4040513          	addi	a0,s0,-192
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	190080e7          	jalr	400(ra) # 80003ff4 <exec>
    80004e6c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e6e:	10048993          	addi	s3,s1,256
    80004e72:	6088                	ld	a0,0(s1)
    80004e74:	c901                	beqz	a0,80004e84 <sys_exec+0xf4>
    kfree(argv[i]);
    80004e76:	ffffb097          	auipc	ra,0xffffb
    80004e7a:	1a6080e7          	jalr	422(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e7e:	04a1                	addi	s1,s1,8
    80004e80:	ff3499e3          	bne	s1,s3,80004e72 <sys_exec+0xe2>
  return ret;
    80004e84:	854a                	mv	a0,s2
    80004e86:	a011                	j	80004e8a <sys_exec+0xfa>
  return -1;
    80004e88:	557d                	li	a0,-1
}
    80004e8a:	60be                	ld	ra,456(sp)
    80004e8c:	641e                	ld	s0,448(sp)
    80004e8e:	74fa                	ld	s1,440(sp)
    80004e90:	795a                	ld	s2,432(sp)
    80004e92:	79ba                	ld	s3,424(sp)
    80004e94:	7a1a                	ld	s4,416(sp)
    80004e96:	6afa                	ld	s5,408(sp)
    80004e98:	6179                	addi	sp,sp,464
    80004e9a:	8082                	ret

0000000080004e9c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e9c:	7139                	addi	sp,sp,-64
    80004e9e:	fc06                	sd	ra,56(sp)
    80004ea0:	f822                	sd	s0,48(sp)
    80004ea2:	f426                	sd	s1,40(sp)
    80004ea4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004ea6:	ffffc097          	auipc	ra,0xffffc
    80004eaa:	fae080e7          	jalr	-82(ra) # 80000e54 <myproc>
    80004eae:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004eb0:	fd840593          	addi	a1,s0,-40
    80004eb4:	4501                	li	a0,0
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	0ce080e7          	jalr	206(ra) # 80001f84 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004ebe:	fc840593          	addi	a1,s0,-56
    80004ec2:	fd040513          	addi	a0,s0,-48
    80004ec6:	fffff097          	auipc	ra,0xfffff
    80004eca:	dd6080e7          	jalr	-554(ra) # 80003c9c <pipealloc>
    return -1;
    80004ece:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ed0:	0c054463          	bltz	a0,80004f98 <sys_pipe+0xfc>
  fd0 = -1;
    80004ed4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004ed8:	fd043503          	ld	a0,-48(s0)
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	518080e7          	jalr	1304(ra) # 800043f4 <fdalloc>
    80004ee4:	fca42223          	sw	a0,-60(s0)
    80004ee8:	08054b63          	bltz	a0,80004f7e <sys_pipe+0xe2>
    80004eec:	fc843503          	ld	a0,-56(s0)
    80004ef0:	fffff097          	auipc	ra,0xfffff
    80004ef4:	504080e7          	jalr	1284(ra) # 800043f4 <fdalloc>
    80004ef8:	fca42023          	sw	a0,-64(s0)
    80004efc:	06054863          	bltz	a0,80004f6c <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f00:	4691                	li	a3,4
    80004f02:	fc440613          	addi	a2,s0,-60
    80004f06:	fd843583          	ld	a1,-40(s0)
    80004f0a:	68a8                	ld	a0,80(s1)
    80004f0c:	ffffc097          	auipc	ra,0xffffc
    80004f10:	c0a080e7          	jalr	-1014(ra) # 80000b16 <copyout>
    80004f14:	02054063          	bltz	a0,80004f34 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f18:	4691                	li	a3,4
    80004f1a:	fc040613          	addi	a2,s0,-64
    80004f1e:	fd843583          	ld	a1,-40(s0)
    80004f22:	0591                	addi	a1,a1,4
    80004f24:	68a8                	ld	a0,80(s1)
    80004f26:	ffffc097          	auipc	ra,0xffffc
    80004f2a:	bf0080e7          	jalr	-1040(ra) # 80000b16 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f2e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f30:	06055463          	bgez	a0,80004f98 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f34:	fc442783          	lw	a5,-60(s0)
    80004f38:	07e9                	addi	a5,a5,26
    80004f3a:	078e                	slli	a5,a5,0x3
    80004f3c:	97a6                	add	a5,a5,s1
    80004f3e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f42:	fc042503          	lw	a0,-64(s0)
    80004f46:	0569                	addi	a0,a0,26
    80004f48:	050e                	slli	a0,a0,0x3
    80004f4a:	94aa                	add	s1,s1,a0
    80004f4c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f50:	fd043503          	ld	a0,-48(s0)
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	a18080e7          	jalr	-1512(ra) # 8000396c <fileclose>
    fileclose(wf);
    80004f5c:	fc843503          	ld	a0,-56(s0)
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	a0c080e7          	jalr	-1524(ra) # 8000396c <fileclose>
    return -1;
    80004f68:	57fd                	li	a5,-1
    80004f6a:	a03d                	j	80004f98 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004f6c:	fc442783          	lw	a5,-60(s0)
    80004f70:	0007c763          	bltz	a5,80004f7e <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004f74:	07e9                	addi	a5,a5,26
    80004f76:	078e                	slli	a5,a5,0x3
    80004f78:	94be                	add	s1,s1,a5
    80004f7a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f7e:	fd043503          	ld	a0,-48(s0)
    80004f82:	fffff097          	auipc	ra,0xfffff
    80004f86:	9ea080e7          	jalr	-1558(ra) # 8000396c <fileclose>
    fileclose(wf);
    80004f8a:	fc843503          	ld	a0,-56(s0)
    80004f8e:	fffff097          	auipc	ra,0xfffff
    80004f92:	9de080e7          	jalr	-1570(ra) # 8000396c <fileclose>
    return -1;
    80004f96:	57fd                	li	a5,-1
}
    80004f98:	853e                	mv	a0,a5
    80004f9a:	70e2                	ld	ra,56(sp)
    80004f9c:	7442                	ld	s0,48(sp)
    80004f9e:	74a2                	ld	s1,40(sp)
    80004fa0:	6121                	addi	sp,sp,64
    80004fa2:	8082                	ret
	...

0000000080004fb0 <kernelvec>:
    80004fb0:	7111                	addi	sp,sp,-256
    80004fb2:	e006                	sd	ra,0(sp)
    80004fb4:	e40a                	sd	sp,8(sp)
    80004fb6:	e80e                	sd	gp,16(sp)
    80004fb8:	ec12                	sd	tp,24(sp)
    80004fba:	f016                	sd	t0,32(sp)
    80004fbc:	f41a                	sd	t1,40(sp)
    80004fbe:	f81e                	sd	t2,48(sp)
    80004fc0:	fc22                	sd	s0,56(sp)
    80004fc2:	e0a6                	sd	s1,64(sp)
    80004fc4:	e4aa                	sd	a0,72(sp)
    80004fc6:	e8ae                	sd	a1,80(sp)
    80004fc8:	ecb2                	sd	a2,88(sp)
    80004fca:	f0b6                	sd	a3,96(sp)
    80004fcc:	f4ba                	sd	a4,104(sp)
    80004fce:	f8be                	sd	a5,112(sp)
    80004fd0:	fcc2                	sd	a6,120(sp)
    80004fd2:	e146                	sd	a7,128(sp)
    80004fd4:	e54a                	sd	s2,136(sp)
    80004fd6:	e94e                	sd	s3,144(sp)
    80004fd8:	ed52                	sd	s4,152(sp)
    80004fda:	f156                	sd	s5,160(sp)
    80004fdc:	f55a                	sd	s6,168(sp)
    80004fde:	f95e                	sd	s7,176(sp)
    80004fe0:	fd62                	sd	s8,184(sp)
    80004fe2:	e1e6                	sd	s9,192(sp)
    80004fe4:	e5ea                	sd	s10,200(sp)
    80004fe6:	e9ee                	sd	s11,208(sp)
    80004fe8:	edf2                	sd	t3,216(sp)
    80004fea:	f1f6                	sd	t4,224(sp)
    80004fec:	f5fa                	sd	t5,232(sp)
    80004fee:	f9fe                	sd	t6,240(sp)
    80004ff0:	da3fc0ef          	jal	ra,80001d92 <kerneltrap>
    80004ff4:	6082                	ld	ra,0(sp)
    80004ff6:	6122                	ld	sp,8(sp)
    80004ff8:	61c2                	ld	gp,16(sp)
    80004ffa:	7282                	ld	t0,32(sp)
    80004ffc:	7322                	ld	t1,40(sp)
    80004ffe:	73c2                	ld	t2,48(sp)
    80005000:	7462                	ld	s0,56(sp)
    80005002:	6486                	ld	s1,64(sp)
    80005004:	6526                	ld	a0,72(sp)
    80005006:	65c6                	ld	a1,80(sp)
    80005008:	6666                	ld	a2,88(sp)
    8000500a:	7686                	ld	a3,96(sp)
    8000500c:	7726                	ld	a4,104(sp)
    8000500e:	77c6                	ld	a5,112(sp)
    80005010:	7866                	ld	a6,120(sp)
    80005012:	688a                	ld	a7,128(sp)
    80005014:	692a                	ld	s2,136(sp)
    80005016:	69ca                	ld	s3,144(sp)
    80005018:	6a6a                	ld	s4,152(sp)
    8000501a:	7a8a                	ld	s5,160(sp)
    8000501c:	7b2a                	ld	s6,168(sp)
    8000501e:	7bca                	ld	s7,176(sp)
    80005020:	7c6a                	ld	s8,184(sp)
    80005022:	6c8e                	ld	s9,192(sp)
    80005024:	6d2e                	ld	s10,200(sp)
    80005026:	6dce                	ld	s11,208(sp)
    80005028:	6e6e                	ld	t3,216(sp)
    8000502a:	7e8e                	ld	t4,224(sp)
    8000502c:	7f2e                	ld	t5,232(sp)
    8000502e:	7fce                	ld	t6,240(sp)
    80005030:	6111                	addi	sp,sp,256
    80005032:	10200073          	sret
    80005036:	00000013          	nop
    8000503a:	00000013          	nop
    8000503e:	0001                	nop

0000000080005040 <timervec>:
    80005040:	34051573          	csrrw	a0,mscratch,a0
    80005044:	e10c                	sd	a1,0(a0)
    80005046:	e510                	sd	a2,8(a0)
    80005048:	e914                	sd	a3,16(a0)
    8000504a:	6d0c                	ld	a1,24(a0)
    8000504c:	7110                	ld	a2,32(a0)
    8000504e:	6194                	ld	a3,0(a1)
    80005050:	96b2                	add	a3,a3,a2
    80005052:	e194                	sd	a3,0(a1)
    80005054:	4589                	li	a1,2
    80005056:	14459073          	csrw	sip,a1
    8000505a:	6914                	ld	a3,16(a0)
    8000505c:	6510                	ld	a2,8(a0)
    8000505e:	610c                	ld	a1,0(a0)
    80005060:	34051573          	csrrw	a0,mscratch,a0
    80005064:	30200073          	mret
	...

000000008000506a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000506a:	1141                	addi	sp,sp,-16
    8000506c:	e422                	sd	s0,8(sp)
    8000506e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005070:	0c0007b7          	lui	a5,0xc000
    80005074:	4705                	li	a4,1
    80005076:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005078:	c3d8                	sw	a4,4(a5)
}
    8000507a:	6422                	ld	s0,8(sp)
    8000507c:	0141                	addi	sp,sp,16
    8000507e:	8082                	ret

0000000080005080 <plicinithart>:

void
plicinithart(void)
{
    80005080:	1141                	addi	sp,sp,-16
    80005082:	e406                	sd	ra,8(sp)
    80005084:	e022                	sd	s0,0(sp)
    80005086:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005088:	ffffc097          	auipc	ra,0xffffc
    8000508c:	da0080e7          	jalr	-608(ra) # 80000e28 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005090:	0085171b          	slliw	a4,a0,0x8
    80005094:	0c0027b7          	lui	a5,0xc002
    80005098:	97ba                	add	a5,a5,a4
    8000509a:	40200713          	li	a4,1026
    8000509e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050a2:	00d5151b          	slliw	a0,a0,0xd
    800050a6:	0c2017b7          	lui	a5,0xc201
    800050aa:	953e                	add	a0,a0,a5
    800050ac:	00052023          	sw	zero,0(a0)
}
    800050b0:	60a2                	ld	ra,8(sp)
    800050b2:	6402                	ld	s0,0(sp)
    800050b4:	0141                	addi	sp,sp,16
    800050b6:	8082                	ret

00000000800050b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050b8:	1141                	addi	sp,sp,-16
    800050ba:	e406                	sd	ra,8(sp)
    800050bc:	e022                	sd	s0,0(sp)
    800050be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	d68080e7          	jalr	-664(ra) # 80000e28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050c8:	00d5179b          	slliw	a5,a0,0xd
    800050cc:	0c201537          	lui	a0,0xc201
    800050d0:	953e                	add	a0,a0,a5
  return irq;
}
    800050d2:	4148                	lw	a0,4(a0)
    800050d4:	60a2                	ld	ra,8(sp)
    800050d6:	6402                	ld	s0,0(sp)
    800050d8:	0141                	addi	sp,sp,16
    800050da:	8082                	ret

00000000800050dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050dc:	1101                	addi	sp,sp,-32
    800050de:	ec06                	sd	ra,24(sp)
    800050e0:	e822                	sd	s0,16(sp)
    800050e2:	e426                	sd	s1,8(sp)
    800050e4:	1000                	addi	s0,sp,32
    800050e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	d40080e7          	jalr	-704(ra) # 80000e28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800050f0:	00d5151b          	slliw	a0,a0,0xd
    800050f4:	0c2017b7          	lui	a5,0xc201
    800050f8:	97aa                	add	a5,a5,a0
    800050fa:	c3c4                	sw	s1,4(a5)
}
    800050fc:	60e2                	ld	ra,24(sp)
    800050fe:	6442                	ld	s0,16(sp)
    80005100:	64a2                	ld	s1,8(sp)
    80005102:	6105                	addi	sp,sp,32
    80005104:	8082                	ret

0000000080005106 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005106:	1141                	addi	sp,sp,-16
    80005108:	e406                	sd	ra,8(sp)
    8000510a:	e022                	sd	s0,0(sp)
    8000510c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000510e:	479d                	li	a5,7
    80005110:	04a7cc63          	blt	a5,a0,80005168 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005114:	00015797          	auipc	a5,0x15
    80005118:	90c78793          	addi	a5,a5,-1780 # 80019a20 <disk>
    8000511c:	97aa                	add	a5,a5,a0
    8000511e:	0187c783          	lbu	a5,24(a5)
    80005122:	ebb9                	bnez	a5,80005178 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005124:	00451613          	slli	a2,a0,0x4
    80005128:	00015797          	auipc	a5,0x15
    8000512c:	8f878793          	addi	a5,a5,-1800 # 80019a20 <disk>
    80005130:	6394                	ld	a3,0(a5)
    80005132:	96b2                	add	a3,a3,a2
    80005134:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005138:	6398                	ld	a4,0(a5)
    8000513a:	9732                	add	a4,a4,a2
    8000513c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005140:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005144:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005148:	953e                	add	a0,a0,a5
    8000514a:	4785                	li	a5,1
    8000514c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005150:	00015517          	auipc	a0,0x15
    80005154:	8e850513          	addi	a0,a0,-1816 # 80019a38 <disk+0x18>
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	404080e7          	jalr	1028(ra) # 8000155c <wakeup>
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	addi	sp,sp,16
    80005166:	8082                	ret
    panic("free_desc 1");
    80005168:	00003517          	auipc	a0,0x3
    8000516c:	5a050513          	addi	a0,a0,1440 # 80008708 <syscalls+0x338>
    80005170:	00001097          	auipc	ra,0x1
    80005174:	a72080e7          	jalr	-1422(ra) # 80005be2 <panic>
    panic("free_desc 2");
    80005178:	00003517          	auipc	a0,0x3
    8000517c:	5a050513          	addi	a0,a0,1440 # 80008718 <syscalls+0x348>
    80005180:	00001097          	auipc	ra,0x1
    80005184:	a62080e7          	jalr	-1438(ra) # 80005be2 <panic>

0000000080005188 <virtio_disk_init>:
{
    80005188:	1101                	addi	sp,sp,-32
    8000518a:	ec06                	sd	ra,24(sp)
    8000518c:	e822                	sd	s0,16(sp)
    8000518e:	e426                	sd	s1,8(sp)
    80005190:	e04a                	sd	s2,0(sp)
    80005192:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005194:	00003597          	auipc	a1,0x3
    80005198:	59458593          	addi	a1,a1,1428 # 80008728 <syscalls+0x358>
    8000519c:	00015517          	auipc	a0,0x15
    800051a0:	9ac50513          	addi	a0,a0,-1620 # 80019b48 <disk+0x128>
    800051a4:	00001097          	auipc	ra,0x1
    800051a8:	ef8080e7          	jalr	-264(ra) # 8000609c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051ac:	100017b7          	lui	a5,0x10001
    800051b0:	4398                	lw	a4,0(a5)
    800051b2:	2701                	sext.w	a4,a4
    800051b4:	747277b7          	lui	a5,0x74727
    800051b8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051bc:	14f71e63          	bne	a4,a5,80005318 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051c0:	100017b7          	lui	a5,0x10001
    800051c4:	43dc                	lw	a5,4(a5)
    800051c6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051c8:	4709                	li	a4,2
    800051ca:	14e79763          	bne	a5,a4,80005318 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051ce:	100017b7          	lui	a5,0x10001
    800051d2:	479c                	lw	a5,8(a5)
    800051d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051d6:	14e79163          	bne	a5,a4,80005318 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051da:	100017b7          	lui	a5,0x10001
    800051de:	47d8                	lw	a4,12(a5)
    800051e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051e2:	554d47b7          	lui	a5,0x554d4
    800051e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800051ea:	12f71763          	bne	a4,a5,80005318 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051ee:	100017b7          	lui	a5,0x10001
    800051f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051f6:	4705                	li	a4,1
    800051f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051fa:	470d                	li	a4,3
    800051fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800051fe:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005200:	c7ffe737          	lui	a4,0xc7ffe
    80005204:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9bf>
    80005208:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000520a:	2701                	sext.w	a4,a4
    8000520c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520e:	472d                	li	a4,11
    80005210:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005212:	0707a903          	lw	s2,112(a5)
    80005216:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005218:	00897793          	andi	a5,s2,8
    8000521c:	10078663          	beqz	a5,80005328 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005220:	100017b7          	lui	a5,0x10001
    80005224:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005228:	43fc                	lw	a5,68(a5)
    8000522a:	2781                	sext.w	a5,a5
    8000522c:	10079663          	bnez	a5,80005338 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005230:	100017b7          	lui	a5,0x10001
    80005234:	5bdc                	lw	a5,52(a5)
    80005236:	2781                	sext.w	a5,a5
  if(max == 0)
    80005238:	10078863          	beqz	a5,80005348 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000523c:	471d                	li	a4,7
    8000523e:	10f77d63          	bgeu	a4,a5,80005358 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005242:	ffffb097          	auipc	ra,0xffffb
    80005246:	ed6080e7          	jalr	-298(ra) # 80000118 <kalloc>
    8000524a:	00014497          	auipc	s1,0x14
    8000524e:	7d648493          	addi	s1,s1,2006 # 80019a20 <disk>
    80005252:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005254:	ffffb097          	auipc	ra,0xffffb
    80005258:	ec4080e7          	jalr	-316(ra) # 80000118 <kalloc>
    8000525c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000525e:	ffffb097          	auipc	ra,0xffffb
    80005262:	eba080e7          	jalr	-326(ra) # 80000118 <kalloc>
    80005266:	87aa                	mv	a5,a0
    80005268:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000526a:	6088                	ld	a0,0(s1)
    8000526c:	cd75                	beqz	a0,80005368 <virtio_disk_init+0x1e0>
    8000526e:	00014717          	auipc	a4,0x14
    80005272:	7ba73703          	ld	a4,1978(a4) # 80019a28 <disk+0x8>
    80005276:	cb6d                	beqz	a4,80005368 <virtio_disk_init+0x1e0>
    80005278:	cbe5                	beqz	a5,80005368 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000527a:	6605                	lui	a2,0x1
    8000527c:	4581                	li	a1,0
    8000527e:	ffffb097          	auipc	ra,0xffffb
    80005282:	efa080e7          	jalr	-262(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005286:	00014497          	auipc	s1,0x14
    8000528a:	79a48493          	addi	s1,s1,1946 # 80019a20 <disk>
    8000528e:	6605                	lui	a2,0x1
    80005290:	4581                	li	a1,0
    80005292:	6488                	ld	a0,8(s1)
    80005294:	ffffb097          	auipc	ra,0xffffb
    80005298:	ee4080e7          	jalr	-284(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000529c:	6605                	lui	a2,0x1
    8000529e:	4581                	li	a1,0
    800052a0:	6888                	ld	a0,16(s1)
    800052a2:	ffffb097          	auipc	ra,0xffffb
    800052a6:	ed6080e7          	jalr	-298(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052aa:	100017b7          	lui	a5,0x10001
    800052ae:	4721                	li	a4,8
    800052b0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052b2:	4098                	lw	a4,0(s1)
    800052b4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052b8:	40d8                	lw	a4,4(s1)
    800052ba:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052be:	6498                	ld	a4,8(s1)
    800052c0:	0007069b          	sext.w	a3,a4
    800052c4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052c8:	9701                	srai	a4,a4,0x20
    800052ca:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052ce:	6898                	ld	a4,16(s1)
    800052d0:	0007069b          	sext.w	a3,a4
    800052d4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052d8:	9701                	srai	a4,a4,0x20
    800052da:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052de:	4685                	li	a3,1
    800052e0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800052e2:	4705                	li	a4,1
    800052e4:	00d48c23          	sb	a3,24(s1)
    800052e8:	00e48ca3          	sb	a4,25(s1)
    800052ec:	00e48d23          	sb	a4,26(s1)
    800052f0:	00e48da3          	sb	a4,27(s1)
    800052f4:	00e48e23          	sb	a4,28(s1)
    800052f8:	00e48ea3          	sb	a4,29(s1)
    800052fc:	00e48f23          	sb	a4,30(s1)
    80005300:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005304:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005308:	0727a823          	sw	s2,112(a5)
}
    8000530c:	60e2                	ld	ra,24(sp)
    8000530e:	6442                	ld	s0,16(sp)
    80005310:	64a2                	ld	s1,8(sp)
    80005312:	6902                	ld	s2,0(sp)
    80005314:	6105                	addi	sp,sp,32
    80005316:	8082                	ret
    panic("could not find virtio disk");
    80005318:	00003517          	auipc	a0,0x3
    8000531c:	42050513          	addi	a0,a0,1056 # 80008738 <syscalls+0x368>
    80005320:	00001097          	auipc	ra,0x1
    80005324:	8c2080e7          	jalr	-1854(ra) # 80005be2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005328:	00003517          	auipc	a0,0x3
    8000532c:	43050513          	addi	a0,a0,1072 # 80008758 <syscalls+0x388>
    80005330:	00001097          	auipc	ra,0x1
    80005334:	8b2080e7          	jalr	-1870(ra) # 80005be2 <panic>
    panic("virtio disk should not be ready");
    80005338:	00003517          	auipc	a0,0x3
    8000533c:	44050513          	addi	a0,a0,1088 # 80008778 <syscalls+0x3a8>
    80005340:	00001097          	auipc	ra,0x1
    80005344:	8a2080e7          	jalr	-1886(ra) # 80005be2 <panic>
    panic("virtio disk has no queue 0");
    80005348:	00003517          	auipc	a0,0x3
    8000534c:	45050513          	addi	a0,a0,1104 # 80008798 <syscalls+0x3c8>
    80005350:	00001097          	auipc	ra,0x1
    80005354:	892080e7          	jalr	-1902(ra) # 80005be2 <panic>
    panic("virtio disk max queue too short");
    80005358:	00003517          	auipc	a0,0x3
    8000535c:	46050513          	addi	a0,a0,1120 # 800087b8 <syscalls+0x3e8>
    80005360:	00001097          	auipc	ra,0x1
    80005364:	882080e7          	jalr	-1918(ra) # 80005be2 <panic>
    panic("virtio disk kalloc");
    80005368:	00003517          	auipc	a0,0x3
    8000536c:	47050513          	addi	a0,a0,1136 # 800087d8 <syscalls+0x408>
    80005370:	00001097          	auipc	ra,0x1
    80005374:	872080e7          	jalr	-1934(ra) # 80005be2 <panic>

0000000080005378 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005378:	7159                	addi	sp,sp,-112
    8000537a:	f486                	sd	ra,104(sp)
    8000537c:	f0a2                	sd	s0,96(sp)
    8000537e:	eca6                	sd	s1,88(sp)
    80005380:	e8ca                	sd	s2,80(sp)
    80005382:	e4ce                	sd	s3,72(sp)
    80005384:	e0d2                	sd	s4,64(sp)
    80005386:	fc56                	sd	s5,56(sp)
    80005388:	f85a                	sd	s6,48(sp)
    8000538a:	f45e                	sd	s7,40(sp)
    8000538c:	f062                	sd	s8,32(sp)
    8000538e:	ec66                	sd	s9,24(sp)
    80005390:	e86a                	sd	s10,16(sp)
    80005392:	1880                	addi	s0,sp,112
    80005394:	892a                	mv	s2,a0
    80005396:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005398:	00c52c83          	lw	s9,12(a0)
    8000539c:	001c9c9b          	slliw	s9,s9,0x1
    800053a0:	1c82                	slli	s9,s9,0x20
    800053a2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053a6:	00014517          	auipc	a0,0x14
    800053aa:	7a250513          	addi	a0,a0,1954 # 80019b48 <disk+0x128>
    800053ae:	00001097          	auipc	ra,0x1
    800053b2:	d7e080e7          	jalr	-642(ra) # 8000612c <acquire>
  for(int i = 0; i < 3; i++){
    800053b6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053b8:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800053ba:	00014b17          	auipc	s6,0x14
    800053be:	666b0b13          	addi	s6,s6,1638 # 80019a20 <disk>
  for(int i = 0; i < 3; i++){
    800053c2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053c4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053c6:	00014c17          	auipc	s8,0x14
    800053ca:	782c0c13          	addi	s8,s8,1922 # 80019b48 <disk+0x128>
    800053ce:	a8b5                	j	8000544a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800053d0:	00fb06b3          	add	a3,s6,a5
    800053d4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800053d8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800053da:	0207c563          	bltz	a5,80005404 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800053de:	2485                	addiw	s1,s1,1
    800053e0:	0711                	addi	a4,a4,4
    800053e2:	1f548a63          	beq	s1,s5,800055d6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800053e6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800053e8:	00014697          	auipc	a3,0x14
    800053ec:	63868693          	addi	a3,a3,1592 # 80019a20 <disk>
    800053f0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800053f2:	0186c583          	lbu	a1,24(a3)
    800053f6:	fde9                	bnez	a1,800053d0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800053f8:	2785                	addiw	a5,a5,1
    800053fa:	0685                	addi	a3,a3,1
    800053fc:	ff779be3          	bne	a5,s7,800053f2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005400:	57fd                	li	a5,-1
    80005402:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005404:	02905a63          	blez	s1,80005438 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005408:	f9042503          	lw	a0,-112(s0)
    8000540c:	00000097          	auipc	ra,0x0
    80005410:	cfa080e7          	jalr	-774(ra) # 80005106 <free_desc>
      for(int j = 0; j < i; j++)
    80005414:	4785                	li	a5,1
    80005416:	0297d163          	bge	a5,s1,80005438 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000541a:	f9442503          	lw	a0,-108(s0)
    8000541e:	00000097          	auipc	ra,0x0
    80005422:	ce8080e7          	jalr	-792(ra) # 80005106 <free_desc>
      for(int j = 0; j < i; j++)
    80005426:	4789                	li	a5,2
    80005428:	0097d863          	bge	a5,s1,80005438 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000542c:	f9842503          	lw	a0,-104(s0)
    80005430:	00000097          	auipc	ra,0x0
    80005434:	cd6080e7          	jalr	-810(ra) # 80005106 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005438:	85e2                	mv	a1,s8
    8000543a:	00014517          	auipc	a0,0x14
    8000543e:	5fe50513          	addi	a0,a0,1534 # 80019a38 <disk+0x18>
    80005442:	ffffc097          	auipc	ra,0xffffc
    80005446:	0b6080e7          	jalr	182(ra) # 800014f8 <sleep>
  for(int i = 0; i < 3; i++){
    8000544a:	f9040713          	addi	a4,s0,-112
    8000544e:	84ce                	mv	s1,s3
    80005450:	bf59                	j	800053e6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005452:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005456:	00479693          	slli	a3,a5,0x4
    8000545a:	00014797          	auipc	a5,0x14
    8000545e:	5c678793          	addi	a5,a5,1478 # 80019a20 <disk>
    80005462:	97b6                	add	a5,a5,a3
    80005464:	4685                	li	a3,1
    80005466:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005468:	00014597          	auipc	a1,0x14
    8000546c:	5b858593          	addi	a1,a1,1464 # 80019a20 <disk>
    80005470:	00a60793          	addi	a5,a2,10
    80005474:	0792                	slli	a5,a5,0x4
    80005476:	97ae                	add	a5,a5,a1
    80005478:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000547c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005480:	f6070693          	addi	a3,a4,-160
    80005484:	619c                	ld	a5,0(a1)
    80005486:	97b6                	add	a5,a5,a3
    80005488:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000548a:	6188                	ld	a0,0(a1)
    8000548c:	96aa                	add	a3,a3,a0
    8000548e:	47c1                	li	a5,16
    80005490:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005492:	4785                	li	a5,1
    80005494:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005498:	f9442783          	lw	a5,-108(s0)
    8000549c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054a0:	0792                	slli	a5,a5,0x4
    800054a2:	953e                	add	a0,a0,a5
    800054a4:	05890693          	addi	a3,s2,88
    800054a8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800054aa:	6188                	ld	a0,0(a1)
    800054ac:	97aa                	add	a5,a5,a0
    800054ae:	40000693          	li	a3,1024
    800054b2:	c794                	sw	a3,8(a5)
  if(write)
    800054b4:	100d0d63          	beqz	s10,800055ce <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054b8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054bc:	00c7d683          	lhu	a3,12(a5)
    800054c0:	0016e693          	ori	a3,a3,1
    800054c4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800054c8:	f9842583          	lw	a1,-104(s0)
    800054cc:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054d0:	00014697          	auipc	a3,0x14
    800054d4:	55068693          	addi	a3,a3,1360 # 80019a20 <disk>
    800054d8:	00260793          	addi	a5,a2,2
    800054dc:	0792                	slli	a5,a5,0x4
    800054de:	97b6                	add	a5,a5,a3
    800054e0:	587d                	li	a6,-1
    800054e2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054e6:	0592                	slli	a1,a1,0x4
    800054e8:	952e                	add	a0,a0,a1
    800054ea:	f9070713          	addi	a4,a4,-112
    800054ee:	9736                	add	a4,a4,a3
    800054f0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800054f2:	6298                	ld	a4,0(a3)
    800054f4:	972e                	add	a4,a4,a1
    800054f6:	4585                	li	a1,1
    800054f8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054fa:	4509                	li	a0,2
    800054fc:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005500:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005504:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005508:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000550c:	6698                	ld	a4,8(a3)
    8000550e:	00275783          	lhu	a5,2(a4)
    80005512:	8b9d                	andi	a5,a5,7
    80005514:	0786                	slli	a5,a5,0x1
    80005516:	97ba                	add	a5,a5,a4
    80005518:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000551c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005520:	6698                	ld	a4,8(a3)
    80005522:	00275783          	lhu	a5,2(a4)
    80005526:	2785                	addiw	a5,a5,1
    80005528:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000552c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005530:	100017b7          	lui	a5,0x10001
    80005534:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005538:	00492703          	lw	a4,4(s2)
    8000553c:	4785                	li	a5,1
    8000553e:	02f71163          	bne	a4,a5,80005560 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005542:	00014997          	auipc	s3,0x14
    80005546:	60698993          	addi	s3,s3,1542 # 80019b48 <disk+0x128>
  while(b->disk == 1) {
    8000554a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000554c:	85ce                	mv	a1,s3
    8000554e:	854a                	mv	a0,s2
    80005550:	ffffc097          	auipc	ra,0xffffc
    80005554:	fa8080e7          	jalr	-88(ra) # 800014f8 <sleep>
  while(b->disk == 1) {
    80005558:	00492783          	lw	a5,4(s2)
    8000555c:	fe9788e3          	beq	a5,s1,8000554c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005560:	f9042903          	lw	s2,-112(s0)
    80005564:	00290793          	addi	a5,s2,2
    80005568:	00479713          	slli	a4,a5,0x4
    8000556c:	00014797          	auipc	a5,0x14
    80005570:	4b478793          	addi	a5,a5,1204 # 80019a20 <disk>
    80005574:	97ba                	add	a5,a5,a4
    80005576:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000557a:	00014997          	auipc	s3,0x14
    8000557e:	4a698993          	addi	s3,s3,1190 # 80019a20 <disk>
    80005582:	00491713          	slli	a4,s2,0x4
    80005586:	0009b783          	ld	a5,0(s3)
    8000558a:	97ba                	add	a5,a5,a4
    8000558c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005590:	854a                	mv	a0,s2
    80005592:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005596:	00000097          	auipc	ra,0x0
    8000559a:	b70080e7          	jalr	-1168(ra) # 80005106 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000559e:	8885                	andi	s1,s1,1
    800055a0:	f0ed                	bnez	s1,80005582 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055a2:	00014517          	auipc	a0,0x14
    800055a6:	5a650513          	addi	a0,a0,1446 # 80019b48 <disk+0x128>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	c36080e7          	jalr	-970(ra) # 800061e0 <release>
}
    800055b2:	70a6                	ld	ra,104(sp)
    800055b4:	7406                	ld	s0,96(sp)
    800055b6:	64e6                	ld	s1,88(sp)
    800055b8:	6946                	ld	s2,80(sp)
    800055ba:	69a6                	ld	s3,72(sp)
    800055bc:	6a06                	ld	s4,64(sp)
    800055be:	7ae2                	ld	s5,56(sp)
    800055c0:	7b42                	ld	s6,48(sp)
    800055c2:	7ba2                	ld	s7,40(sp)
    800055c4:	7c02                	ld	s8,32(sp)
    800055c6:	6ce2                	ld	s9,24(sp)
    800055c8:	6d42                	ld	s10,16(sp)
    800055ca:	6165                	addi	sp,sp,112
    800055cc:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800055ce:	4689                	li	a3,2
    800055d0:	00d79623          	sh	a3,12(a5)
    800055d4:	b5e5                	j	800054bc <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055d6:	f9042603          	lw	a2,-112(s0)
    800055da:	00a60713          	addi	a4,a2,10
    800055de:	0712                	slli	a4,a4,0x4
    800055e0:	00014517          	auipc	a0,0x14
    800055e4:	44850513          	addi	a0,a0,1096 # 80019a28 <disk+0x8>
    800055e8:	953a                	add	a0,a0,a4
  if(write)
    800055ea:	e60d14e3          	bnez	s10,80005452 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800055ee:	00a60793          	addi	a5,a2,10
    800055f2:	00479693          	slli	a3,a5,0x4
    800055f6:	00014797          	auipc	a5,0x14
    800055fa:	42a78793          	addi	a5,a5,1066 # 80019a20 <disk>
    800055fe:	97b6                	add	a5,a5,a3
    80005600:	0007a423          	sw	zero,8(a5)
    80005604:	b595                	j	80005468 <virtio_disk_rw+0xf0>

0000000080005606 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005606:	1101                	addi	sp,sp,-32
    80005608:	ec06                	sd	ra,24(sp)
    8000560a:	e822                	sd	s0,16(sp)
    8000560c:	e426                	sd	s1,8(sp)
    8000560e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005610:	00014497          	auipc	s1,0x14
    80005614:	41048493          	addi	s1,s1,1040 # 80019a20 <disk>
    80005618:	00014517          	auipc	a0,0x14
    8000561c:	53050513          	addi	a0,a0,1328 # 80019b48 <disk+0x128>
    80005620:	00001097          	auipc	ra,0x1
    80005624:	b0c080e7          	jalr	-1268(ra) # 8000612c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005628:	10001737          	lui	a4,0x10001
    8000562c:	533c                	lw	a5,96(a4)
    8000562e:	8b8d                	andi	a5,a5,3
    80005630:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005632:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005636:	689c                	ld	a5,16(s1)
    80005638:	0204d703          	lhu	a4,32(s1)
    8000563c:	0027d783          	lhu	a5,2(a5)
    80005640:	04f70863          	beq	a4,a5,80005690 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005644:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005648:	6898                	ld	a4,16(s1)
    8000564a:	0204d783          	lhu	a5,32(s1)
    8000564e:	8b9d                	andi	a5,a5,7
    80005650:	078e                	slli	a5,a5,0x3
    80005652:	97ba                	add	a5,a5,a4
    80005654:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005656:	00278713          	addi	a4,a5,2
    8000565a:	0712                	slli	a4,a4,0x4
    8000565c:	9726                	add	a4,a4,s1
    8000565e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005662:	e721                	bnez	a4,800056aa <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005664:	0789                	addi	a5,a5,2
    80005666:	0792                	slli	a5,a5,0x4
    80005668:	97a6                	add	a5,a5,s1
    8000566a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000566c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005670:	ffffc097          	auipc	ra,0xffffc
    80005674:	eec080e7          	jalr	-276(ra) # 8000155c <wakeup>

    disk.used_idx += 1;
    80005678:	0204d783          	lhu	a5,32(s1)
    8000567c:	2785                	addiw	a5,a5,1
    8000567e:	17c2                	slli	a5,a5,0x30
    80005680:	93c1                	srli	a5,a5,0x30
    80005682:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005686:	6898                	ld	a4,16(s1)
    80005688:	00275703          	lhu	a4,2(a4)
    8000568c:	faf71ce3          	bne	a4,a5,80005644 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005690:	00014517          	auipc	a0,0x14
    80005694:	4b850513          	addi	a0,a0,1208 # 80019b48 <disk+0x128>
    80005698:	00001097          	auipc	ra,0x1
    8000569c:	b48080e7          	jalr	-1208(ra) # 800061e0 <release>
}
    800056a0:	60e2                	ld	ra,24(sp)
    800056a2:	6442                	ld	s0,16(sp)
    800056a4:	64a2                	ld	s1,8(sp)
    800056a6:	6105                	addi	sp,sp,32
    800056a8:	8082                	ret
      panic("virtio_disk_intr status");
    800056aa:	00003517          	auipc	a0,0x3
    800056ae:	14650513          	addi	a0,a0,326 # 800087f0 <syscalls+0x420>
    800056b2:	00000097          	auipc	ra,0x0
    800056b6:	530080e7          	jalr	1328(ra) # 80005be2 <panic>

00000000800056ba <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056ba:	1141                	addi	sp,sp,-16
    800056bc:	e422                	sd	s0,8(sp)
    800056be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056c0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056c4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056c8:	0037979b          	slliw	a5,a5,0x3
    800056cc:	02004737          	lui	a4,0x2004
    800056d0:	97ba                	add	a5,a5,a4
    800056d2:	0200c737          	lui	a4,0x200c
    800056d6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800056da:	000f4637          	lui	a2,0xf4
    800056de:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800056e2:	95b2                	add	a1,a1,a2
    800056e4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800056e6:	00269713          	slli	a4,a3,0x2
    800056ea:	9736                	add	a4,a4,a3
    800056ec:	00371693          	slli	a3,a4,0x3
    800056f0:	00014717          	auipc	a4,0x14
    800056f4:	47070713          	addi	a4,a4,1136 # 80019b60 <timer_scratch>
    800056f8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800056fa:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800056fc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056fe:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005702:	00000797          	auipc	a5,0x0
    80005706:	93e78793          	addi	a5,a5,-1730 # 80005040 <timervec>
    8000570a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000570e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005712:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005716:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000571a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000571e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005722:	30479073          	csrw	mie,a5
}
    80005726:	6422                	ld	s0,8(sp)
    80005728:	0141                	addi	sp,sp,16
    8000572a:	8082                	ret

000000008000572c <start>:
{
    8000572c:	1141                	addi	sp,sp,-16
    8000572e:	e406                	sd	ra,8(sp)
    80005730:	e022                	sd	s0,0(sp)
    80005732:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005734:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005738:	7779                	lui	a4,0xffffe
    8000573a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca5f>
    8000573e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005740:	6705                	lui	a4,0x1
    80005742:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005746:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005748:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000574c:	ffffb797          	auipc	a5,0xffffb
    80005750:	bda78793          	addi	a5,a5,-1062 # 80000326 <main>
    80005754:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005758:	4781                	li	a5,0
    8000575a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000575e:	67c1                	lui	a5,0x10
    80005760:	17fd                	addi	a5,a5,-1
    80005762:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005766:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000576a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000576e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005772:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005776:	57fd                	li	a5,-1
    80005778:	83a9                	srli	a5,a5,0xa
    8000577a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000577e:	47bd                	li	a5,15
    80005780:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005784:	00000097          	auipc	ra,0x0
    80005788:	f36080e7          	jalr	-202(ra) # 800056ba <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000578c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005790:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005792:	823e                	mv	tp,a5
  asm volatile("mret");
    80005794:	30200073          	mret
}
    80005798:	60a2                	ld	ra,8(sp)
    8000579a:	6402                	ld	s0,0(sp)
    8000579c:	0141                	addi	sp,sp,16
    8000579e:	8082                	ret

00000000800057a0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057a0:	715d                	addi	sp,sp,-80
    800057a2:	e486                	sd	ra,72(sp)
    800057a4:	e0a2                	sd	s0,64(sp)
    800057a6:	fc26                	sd	s1,56(sp)
    800057a8:	f84a                	sd	s2,48(sp)
    800057aa:	f44e                	sd	s3,40(sp)
    800057ac:	f052                	sd	s4,32(sp)
    800057ae:	ec56                	sd	s5,24(sp)
    800057b0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057b2:	04c05663          	blez	a2,800057fe <consolewrite+0x5e>
    800057b6:	8a2a                	mv	s4,a0
    800057b8:	84ae                	mv	s1,a1
    800057ba:	89b2                	mv	s3,a2
    800057bc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057be:	5afd                	li	s5,-1
    800057c0:	4685                	li	a3,1
    800057c2:	8626                	mv	a2,s1
    800057c4:	85d2                	mv	a1,s4
    800057c6:	fbf40513          	addi	a0,s0,-65
    800057ca:	ffffc097          	auipc	ra,0xffffc
    800057ce:	18c080e7          	jalr	396(ra) # 80001956 <either_copyin>
    800057d2:	01550c63          	beq	a0,s5,800057ea <consolewrite+0x4a>
      break;
    uartputc(c);
    800057d6:	fbf44503          	lbu	a0,-65(s0)
    800057da:	00000097          	auipc	ra,0x0
    800057de:	794080e7          	jalr	1940(ra) # 80005f6e <uartputc>
  for(i = 0; i < n; i++){
    800057e2:	2905                	addiw	s2,s2,1
    800057e4:	0485                	addi	s1,s1,1
    800057e6:	fd299de3          	bne	s3,s2,800057c0 <consolewrite+0x20>
  }

  return i;
}
    800057ea:	854a                	mv	a0,s2
    800057ec:	60a6                	ld	ra,72(sp)
    800057ee:	6406                	ld	s0,64(sp)
    800057f0:	74e2                	ld	s1,56(sp)
    800057f2:	7942                	ld	s2,48(sp)
    800057f4:	79a2                	ld	s3,40(sp)
    800057f6:	7a02                	ld	s4,32(sp)
    800057f8:	6ae2                	ld	s5,24(sp)
    800057fa:	6161                	addi	sp,sp,80
    800057fc:	8082                	ret
  for(i = 0; i < n; i++){
    800057fe:	4901                	li	s2,0
    80005800:	b7ed                	j	800057ea <consolewrite+0x4a>

0000000080005802 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005802:	7119                	addi	sp,sp,-128
    80005804:	fc86                	sd	ra,120(sp)
    80005806:	f8a2                	sd	s0,112(sp)
    80005808:	f4a6                	sd	s1,104(sp)
    8000580a:	f0ca                	sd	s2,96(sp)
    8000580c:	ecce                	sd	s3,88(sp)
    8000580e:	e8d2                	sd	s4,80(sp)
    80005810:	e4d6                	sd	s5,72(sp)
    80005812:	e0da                	sd	s6,64(sp)
    80005814:	fc5e                	sd	s7,56(sp)
    80005816:	f862                	sd	s8,48(sp)
    80005818:	f466                	sd	s9,40(sp)
    8000581a:	f06a                	sd	s10,32(sp)
    8000581c:	ec6e                	sd	s11,24(sp)
    8000581e:	0100                	addi	s0,sp,128
    80005820:	8b2a                	mv	s6,a0
    80005822:	8aae                	mv	s5,a1
    80005824:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005826:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000582a:	0001c517          	auipc	a0,0x1c
    8000582e:	47650513          	addi	a0,a0,1142 # 80021ca0 <cons>
    80005832:	00001097          	auipc	ra,0x1
    80005836:	8fa080e7          	jalr	-1798(ra) # 8000612c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000583a:	0001c497          	auipc	s1,0x1c
    8000583e:	46648493          	addi	s1,s1,1126 # 80021ca0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005842:	89a6                	mv	s3,s1
    80005844:	0001c917          	auipc	s2,0x1c
    80005848:	4f490913          	addi	s2,s2,1268 # 80021d38 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000584c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000584e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005850:	4da9                	li	s11,10
  while(n > 0){
    80005852:	07405b63          	blez	s4,800058c8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005856:	0984a783          	lw	a5,152(s1)
    8000585a:	09c4a703          	lw	a4,156(s1)
    8000585e:	02f71763          	bne	a4,a5,8000588c <consoleread+0x8a>
      if(killed(myproc())){
    80005862:	ffffb097          	auipc	ra,0xffffb
    80005866:	5f2080e7          	jalr	1522(ra) # 80000e54 <myproc>
    8000586a:	ffffc097          	auipc	ra,0xffffc
    8000586e:	f36080e7          	jalr	-202(ra) # 800017a0 <killed>
    80005872:	e535                	bnez	a0,800058de <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005874:	85ce                	mv	a1,s3
    80005876:	854a                	mv	a0,s2
    80005878:	ffffc097          	auipc	ra,0xffffc
    8000587c:	c80080e7          	jalr	-896(ra) # 800014f8 <sleep>
    while(cons.r == cons.w){
    80005880:	0984a783          	lw	a5,152(s1)
    80005884:	09c4a703          	lw	a4,156(s1)
    80005888:	fcf70de3          	beq	a4,a5,80005862 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000588c:	0017871b          	addiw	a4,a5,1
    80005890:	08e4ac23          	sw	a4,152(s1)
    80005894:	07f7f713          	andi	a4,a5,127
    80005898:	9726                	add	a4,a4,s1
    8000589a:	01874703          	lbu	a4,24(a4)
    8000589e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800058a2:	079c0663          	beq	s8,s9,8000590e <consoleread+0x10c>
    cbuf = c;
    800058a6:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058aa:	4685                	li	a3,1
    800058ac:	f8f40613          	addi	a2,s0,-113
    800058b0:	85d6                	mv	a1,s5
    800058b2:	855a                	mv	a0,s6
    800058b4:	ffffc097          	auipc	ra,0xffffc
    800058b8:	04c080e7          	jalr	76(ra) # 80001900 <either_copyout>
    800058bc:	01a50663          	beq	a0,s10,800058c8 <consoleread+0xc6>
    dst++;
    800058c0:	0a85                	addi	s5,s5,1
    --n;
    800058c2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800058c4:	f9bc17e3          	bne	s8,s11,80005852 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058c8:	0001c517          	auipc	a0,0x1c
    800058cc:	3d850513          	addi	a0,a0,984 # 80021ca0 <cons>
    800058d0:	00001097          	auipc	ra,0x1
    800058d4:	910080e7          	jalr	-1776(ra) # 800061e0 <release>

  return target - n;
    800058d8:	414b853b          	subw	a0,s7,s4
    800058dc:	a811                	j	800058f0 <consoleread+0xee>
        release(&cons.lock);
    800058de:	0001c517          	auipc	a0,0x1c
    800058e2:	3c250513          	addi	a0,a0,962 # 80021ca0 <cons>
    800058e6:	00001097          	auipc	ra,0x1
    800058ea:	8fa080e7          	jalr	-1798(ra) # 800061e0 <release>
        return -1;
    800058ee:	557d                	li	a0,-1
}
    800058f0:	70e6                	ld	ra,120(sp)
    800058f2:	7446                	ld	s0,112(sp)
    800058f4:	74a6                	ld	s1,104(sp)
    800058f6:	7906                	ld	s2,96(sp)
    800058f8:	69e6                	ld	s3,88(sp)
    800058fa:	6a46                	ld	s4,80(sp)
    800058fc:	6aa6                	ld	s5,72(sp)
    800058fe:	6b06                	ld	s6,64(sp)
    80005900:	7be2                	ld	s7,56(sp)
    80005902:	7c42                	ld	s8,48(sp)
    80005904:	7ca2                	ld	s9,40(sp)
    80005906:	7d02                	ld	s10,32(sp)
    80005908:	6de2                	ld	s11,24(sp)
    8000590a:	6109                	addi	sp,sp,128
    8000590c:	8082                	ret
      if(n < target){
    8000590e:	000a071b          	sext.w	a4,s4
    80005912:	fb777be3          	bgeu	a4,s7,800058c8 <consoleread+0xc6>
        cons.r--;
    80005916:	0001c717          	auipc	a4,0x1c
    8000591a:	42f72123          	sw	a5,1058(a4) # 80021d38 <cons+0x98>
    8000591e:	b76d                	j	800058c8 <consoleread+0xc6>

0000000080005920 <consputc>:
{
    80005920:	1141                	addi	sp,sp,-16
    80005922:	e406                	sd	ra,8(sp)
    80005924:	e022                	sd	s0,0(sp)
    80005926:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005928:	10000793          	li	a5,256
    8000592c:	00f50a63          	beq	a0,a5,80005940 <consputc+0x20>
    uartputc_sync(c);
    80005930:	00000097          	auipc	ra,0x0
    80005934:	564080e7          	jalr	1380(ra) # 80005e94 <uartputc_sync>
}
    80005938:	60a2                	ld	ra,8(sp)
    8000593a:	6402                	ld	s0,0(sp)
    8000593c:	0141                	addi	sp,sp,16
    8000593e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005940:	4521                	li	a0,8
    80005942:	00000097          	auipc	ra,0x0
    80005946:	552080e7          	jalr	1362(ra) # 80005e94 <uartputc_sync>
    8000594a:	02000513          	li	a0,32
    8000594e:	00000097          	auipc	ra,0x0
    80005952:	546080e7          	jalr	1350(ra) # 80005e94 <uartputc_sync>
    80005956:	4521                	li	a0,8
    80005958:	00000097          	auipc	ra,0x0
    8000595c:	53c080e7          	jalr	1340(ra) # 80005e94 <uartputc_sync>
    80005960:	bfe1                	j	80005938 <consputc+0x18>

0000000080005962 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005962:	1101                	addi	sp,sp,-32
    80005964:	ec06                	sd	ra,24(sp)
    80005966:	e822                	sd	s0,16(sp)
    80005968:	e426                	sd	s1,8(sp)
    8000596a:	e04a                	sd	s2,0(sp)
    8000596c:	1000                	addi	s0,sp,32
    8000596e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005970:	0001c517          	auipc	a0,0x1c
    80005974:	33050513          	addi	a0,a0,816 # 80021ca0 <cons>
    80005978:	00000097          	auipc	ra,0x0
    8000597c:	7b4080e7          	jalr	1972(ra) # 8000612c <acquire>

  switch(c){
    80005980:	47d5                	li	a5,21
    80005982:	0af48663          	beq	s1,a5,80005a2e <consoleintr+0xcc>
    80005986:	0297ca63          	blt	a5,s1,800059ba <consoleintr+0x58>
    8000598a:	47a1                	li	a5,8
    8000598c:	0ef48763          	beq	s1,a5,80005a7a <consoleintr+0x118>
    80005990:	47c1                	li	a5,16
    80005992:	10f49a63          	bne	s1,a5,80005aa6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005996:	ffffc097          	auipc	ra,0xffffc
    8000599a:	016080e7          	jalr	22(ra) # 800019ac <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000599e:	0001c517          	auipc	a0,0x1c
    800059a2:	30250513          	addi	a0,a0,770 # 80021ca0 <cons>
    800059a6:	00001097          	auipc	ra,0x1
    800059aa:	83a080e7          	jalr	-1990(ra) # 800061e0 <release>
}
    800059ae:	60e2                	ld	ra,24(sp)
    800059b0:	6442                	ld	s0,16(sp)
    800059b2:	64a2                	ld	s1,8(sp)
    800059b4:	6902                	ld	s2,0(sp)
    800059b6:	6105                	addi	sp,sp,32
    800059b8:	8082                	ret
  switch(c){
    800059ba:	07f00793          	li	a5,127
    800059be:	0af48e63          	beq	s1,a5,80005a7a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800059c2:	0001c717          	auipc	a4,0x1c
    800059c6:	2de70713          	addi	a4,a4,734 # 80021ca0 <cons>
    800059ca:	0a072783          	lw	a5,160(a4)
    800059ce:	09872703          	lw	a4,152(a4)
    800059d2:	9f99                	subw	a5,a5,a4
    800059d4:	07f00713          	li	a4,127
    800059d8:	fcf763e3          	bltu	a4,a5,8000599e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800059dc:	47b5                	li	a5,13
    800059de:	0cf48763          	beq	s1,a5,80005aac <consoleintr+0x14a>
      consputc(c);
    800059e2:	8526                	mv	a0,s1
    800059e4:	00000097          	auipc	ra,0x0
    800059e8:	f3c080e7          	jalr	-196(ra) # 80005920 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800059ec:	0001c797          	auipc	a5,0x1c
    800059f0:	2b478793          	addi	a5,a5,692 # 80021ca0 <cons>
    800059f4:	0a07a683          	lw	a3,160(a5)
    800059f8:	0016871b          	addiw	a4,a3,1
    800059fc:	0007061b          	sext.w	a2,a4
    80005a00:	0ae7a023          	sw	a4,160(a5)
    80005a04:	07f6f693          	andi	a3,a3,127
    80005a08:	97b6                	add	a5,a5,a3
    80005a0a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a0e:	47a9                	li	a5,10
    80005a10:	0cf48563          	beq	s1,a5,80005ada <consoleintr+0x178>
    80005a14:	4791                	li	a5,4
    80005a16:	0cf48263          	beq	s1,a5,80005ada <consoleintr+0x178>
    80005a1a:	0001c797          	auipc	a5,0x1c
    80005a1e:	31e7a783          	lw	a5,798(a5) # 80021d38 <cons+0x98>
    80005a22:	9f1d                	subw	a4,a4,a5
    80005a24:	08000793          	li	a5,128
    80005a28:	f6f71be3          	bne	a4,a5,8000599e <consoleintr+0x3c>
    80005a2c:	a07d                	j	80005ada <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a2e:	0001c717          	auipc	a4,0x1c
    80005a32:	27270713          	addi	a4,a4,626 # 80021ca0 <cons>
    80005a36:	0a072783          	lw	a5,160(a4)
    80005a3a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a3e:	0001c497          	auipc	s1,0x1c
    80005a42:	26248493          	addi	s1,s1,610 # 80021ca0 <cons>
    while(cons.e != cons.w &&
    80005a46:	4929                	li	s2,10
    80005a48:	f4f70be3          	beq	a4,a5,8000599e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a4c:	37fd                	addiw	a5,a5,-1
    80005a4e:	07f7f713          	andi	a4,a5,127
    80005a52:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a54:	01874703          	lbu	a4,24(a4)
    80005a58:	f52703e3          	beq	a4,s2,8000599e <consoleintr+0x3c>
      cons.e--;
    80005a5c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a60:	10000513          	li	a0,256
    80005a64:	00000097          	auipc	ra,0x0
    80005a68:	ebc080e7          	jalr	-324(ra) # 80005920 <consputc>
    while(cons.e != cons.w &&
    80005a6c:	0a04a783          	lw	a5,160(s1)
    80005a70:	09c4a703          	lw	a4,156(s1)
    80005a74:	fcf71ce3          	bne	a4,a5,80005a4c <consoleintr+0xea>
    80005a78:	b71d                	j	8000599e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a7a:	0001c717          	auipc	a4,0x1c
    80005a7e:	22670713          	addi	a4,a4,550 # 80021ca0 <cons>
    80005a82:	0a072783          	lw	a5,160(a4)
    80005a86:	09c72703          	lw	a4,156(a4)
    80005a8a:	f0f70ae3          	beq	a4,a5,8000599e <consoleintr+0x3c>
      cons.e--;
    80005a8e:	37fd                	addiw	a5,a5,-1
    80005a90:	0001c717          	auipc	a4,0x1c
    80005a94:	2af72823          	sw	a5,688(a4) # 80021d40 <cons+0xa0>
      consputc(BACKSPACE);
    80005a98:	10000513          	li	a0,256
    80005a9c:	00000097          	auipc	ra,0x0
    80005aa0:	e84080e7          	jalr	-380(ra) # 80005920 <consputc>
    80005aa4:	bded                	j	8000599e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005aa6:	ee048ce3          	beqz	s1,8000599e <consoleintr+0x3c>
    80005aaa:	bf21                	j	800059c2 <consoleintr+0x60>
      consputc(c);
    80005aac:	4529                	li	a0,10
    80005aae:	00000097          	auipc	ra,0x0
    80005ab2:	e72080e7          	jalr	-398(ra) # 80005920 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ab6:	0001c797          	auipc	a5,0x1c
    80005aba:	1ea78793          	addi	a5,a5,490 # 80021ca0 <cons>
    80005abe:	0a07a703          	lw	a4,160(a5)
    80005ac2:	0017069b          	addiw	a3,a4,1
    80005ac6:	0006861b          	sext.w	a2,a3
    80005aca:	0ad7a023          	sw	a3,160(a5)
    80005ace:	07f77713          	andi	a4,a4,127
    80005ad2:	97ba                	add	a5,a5,a4
    80005ad4:	4729                	li	a4,10
    80005ad6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ada:	0001c797          	auipc	a5,0x1c
    80005ade:	26c7a123          	sw	a2,610(a5) # 80021d3c <cons+0x9c>
        wakeup(&cons.r);
    80005ae2:	0001c517          	auipc	a0,0x1c
    80005ae6:	25650513          	addi	a0,a0,598 # 80021d38 <cons+0x98>
    80005aea:	ffffc097          	auipc	ra,0xffffc
    80005aee:	a72080e7          	jalr	-1422(ra) # 8000155c <wakeup>
    80005af2:	b575                	j	8000599e <consoleintr+0x3c>

0000000080005af4 <consoleinit>:

void
consoleinit(void)
{
    80005af4:	1141                	addi	sp,sp,-16
    80005af6:	e406                	sd	ra,8(sp)
    80005af8:	e022                	sd	s0,0(sp)
    80005afa:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005afc:	00003597          	auipc	a1,0x3
    80005b00:	d0c58593          	addi	a1,a1,-756 # 80008808 <syscalls+0x438>
    80005b04:	0001c517          	auipc	a0,0x1c
    80005b08:	19c50513          	addi	a0,a0,412 # 80021ca0 <cons>
    80005b0c:	00000097          	auipc	ra,0x0
    80005b10:	590080e7          	jalr	1424(ra) # 8000609c <initlock>

  uartinit();
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	330080e7          	jalr	816(ra) # 80005e44 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b1c:	00013797          	auipc	a5,0x13
    80005b20:	eac78793          	addi	a5,a5,-340 # 800189c8 <devsw>
    80005b24:	00000717          	auipc	a4,0x0
    80005b28:	cde70713          	addi	a4,a4,-802 # 80005802 <consoleread>
    80005b2c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b2e:	00000717          	auipc	a4,0x0
    80005b32:	c7270713          	addi	a4,a4,-910 # 800057a0 <consolewrite>
    80005b36:	ef98                	sd	a4,24(a5)
}
    80005b38:	60a2                	ld	ra,8(sp)
    80005b3a:	6402                	ld	s0,0(sp)
    80005b3c:	0141                	addi	sp,sp,16
    80005b3e:	8082                	ret

0000000080005b40 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b40:	7179                	addi	sp,sp,-48
    80005b42:	f406                	sd	ra,40(sp)
    80005b44:	f022                	sd	s0,32(sp)
    80005b46:	ec26                	sd	s1,24(sp)
    80005b48:	e84a                	sd	s2,16(sp)
    80005b4a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b4c:	c219                	beqz	a2,80005b52 <printint+0x12>
    80005b4e:	08054663          	bltz	a0,80005bda <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005b52:	2501                	sext.w	a0,a0
    80005b54:	4881                	li	a7,0
    80005b56:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b5a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b5c:	2581                	sext.w	a1,a1
    80005b5e:	00003617          	auipc	a2,0x3
    80005b62:	cda60613          	addi	a2,a2,-806 # 80008838 <digits>
    80005b66:	883a                	mv	a6,a4
    80005b68:	2705                	addiw	a4,a4,1
    80005b6a:	02b577bb          	remuw	a5,a0,a1
    80005b6e:	1782                	slli	a5,a5,0x20
    80005b70:	9381                	srli	a5,a5,0x20
    80005b72:	97b2                	add	a5,a5,a2
    80005b74:	0007c783          	lbu	a5,0(a5)
    80005b78:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b7c:	0005079b          	sext.w	a5,a0
    80005b80:	02b5553b          	divuw	a0,a0,a1
    80005b84:	0685                	addi	a3,a3,1
    80005b86:	feb7f0e3          	bgeu	a5,a1,80005b66 <printint+0x26>

  if(sign)
    80005b8a:	00088b63          	beqz	a7,80005ba0 <printint+0x60>
    buf[i++] = '-';
    80005b8e:	fe040793          	addi	a5,s0,-32
    80005b92:	973e                	add	a4,a4,a5
    80005b94:	02d00793          	li	a5,45
    80005b98:	fef70823          	sb	a5,-16(a4)
    80005b9c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ba0:	02e05763          	blez	a4,80005bce <printint+0x8e>
    80005ba4:	fd040793          	addi	a5,s0,-48
    80005ba8:	00e784b3          	add	s1,a5,a4
    80005bac:	fff78913          	addi	s2,a5,-1
    80005bb0:	993a                	add	s2,s2,a4
    80005bb2:	377d                	addiw	a4,a4,-1
    80005bb4:	1702                	slli	a4,a4,0x20
    80005bb6:	9301                	srli	a4,a4,0x20
    80005bb8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bbc:	fff4c503          	lbu	a0,-1(s1)
    80005bc0:	00000097          	auipc	ra,0x0
    80005bc4:	d60080e7          	jalr	-672(ra) # 80005920 <consputc>
  while(--i >= 0)
    80005bc8:	14fd                	addi	s1,s1,-1
    80005bca:	ff2499e3          	bne	s1,s2,80005bbc <printint+0x7c>
}
    80005bce:	70a2                	ld	ra,40(sp)
    80005bd0:	7402                	ld	s0,32(sp)
    80005bd2:	64e2                	ld	s1,24(sp)
    80005bd4:	6942                	ld	s2,16(sp)
    80005bd6:	6145                	addi	sp,sp,48
    80005bd8:	8082                	ret
    x = -xx;
    80005bda:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005bde:	4885                	li	a7,1
    x = -xx;
    80005be0:	bf9d                	j	80005b56 <printint+0x16>

0000000080005be2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005be2:	1101                	addi	sp,sp,-32
    80005be4:	ec06                	sd	ra,24(sp)
    80005be6:	e822                	sd	s0,16(sp)
    80005be8:	e426                	sd	s1,8(sp)
    80005bea:	1000                	addi	s0,sp,32
    80005bec:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005bee:	0001c797          	auipc	a5,0x1c
    80005bf2:	1607a923          	sw	zero,370(a5) # 80021d60 <pr+0x18>
  printf("panic: ");
    80005bf6:	00003517          	auipc	a0,0x3
    80005bfa:	c1a50513          	addi	a0,a0,-998 # 80008810 <syscalls+0x440>
    80005bfe:	00000097          	auipc	ra,0x0
    80005c02:	02e080e7          	jalr	46(ra) # 80005c2c <printf>
  printf(s);
    80005c06:	8526                	mv	a0,s1
    80005c08:	00000097          	auipc	ra,0x0
    80005c0c:	024080e7          	jalr	36(ra) # 80005c2c <printf>
  printf("\n");
    80005c10:	00002517          	auipc	a0,0x2
    80005c14:	43850513          	addi	a0,a0,1080 # 80008048 <etext+0x48>
    80005c18:	00000097          	auipc	ra,0x0
    80005c1c:	014080e7          	jalr	20(ra) # 80005c2c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c20:	4785                	li	a5,1
    80005c22:	00003717          	auipc	a4,0x3
    80005c26:	cef72d23          	sw	a5,-774(a4) # 8000891c <panicked>
  for(;;)
    80005c2a:	a001                	j	80005c2a <panic+0x48>

0000000080005c2c <printf>:
{
    80005c2c:	7131                	addi	sp,sp,-192
    80005c2e:	fc86                	sd	ra,120(sp)
    80005c30:	f8a2                	sd	s0,112(sp)
    80005c32:	f4a6                	sd	s1,104(sp)
    80005c34:	f0ca                	sd	s2,96(sp)
    80005c36:	ecce                	sd	s3,88(sp)
    80005c38:	e8d2                	sd	s4,80(sp)
    80005c3a:	e4d6                	sd	s5,72(sp)
    80005c3c:	e0da                	sd	s6,64(sp)
    80005c3e:	fc5e                	sd	s7,56(sp)
    80005c40:	f862                	sd	s8,48(sp)
    80005c42:	f466                	sd	s9,40(sp)
    80005c44:	f06a                	sd	s10,32(sp)
    80005c46:	ec6e                	sd	s11,24(sp)
    80005c48:	0100                	addi	s0,sp,128
    80005c4a:	8a2a                	mv	s4,a0
    80005c4c:	e40c                	sd	a1,8(s0)
    80005c4e:	e810                	sd	a2,16(s0)
    80005c50:	ec14                	sd	a3,24(s0)
    80005c52:	f018                	sd	a4,32(s0)
    80005c54:	f41c                	sd	a5,40(s0)
    80005c56:	03043823          	sd	a6,48(s0)
    80005c5a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c5e:	0001cd97          	auipc	s11,0x1c
    80005c62:	102dad83          	lw	s11,258(s11) # 80021d60 <pr+0x18>
  if(locking)
    80005c66:	020d9b63          	bnez	s11,80005c9c <printf+0x70>
  if (fmt == 0)
    80005c6a:	040a0263          	beqz	s4,80005cae <printf+0x82>
  va_start(ap, fmt);
    80005c6e:	00840793          	addi	a5,s0,8
    80005c72:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c76:	000a4503          	lbu	a0,0(s4)
    80005c7a:	16050263          	beqz	a0,80005dde <printf+0x1b2>
    80005c7e:	4481                	li	s1,0
    if(c != '%'){
    80005c80:	02500a93          	li	s5,37
    switch(c){
    80005c84:	07000b13          	li	s6,112
  consputc('x');
    80005c88:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c8a:	00003b97          	auipc	s7,0x3
    80005c8e:	baeb8b93          	addi	s7,s7,-1106 # 80008838 <digits>
    switch(c){
    80005c92:	07300c93          	li	s9,115
    80005c96:	06400c13          	li	s8,100
    80005c9a:	a82d                	j	80005cd4 <printf+0xa8>
    acquire(&pr.lock);
    80005c9c:	0001c517          	auipc	a0,0x1c
    80005ca0:	0ac50513          	addi	a0,a0,172 # 80021d48 <pr>
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	488080e7          	jalr	1160(ra) # 8000612c <acquire>
    80005cac:	bf7d                	j	80005c6a <printf+0x3e>
    panic("null fmt");
    80005cae:	00003517          	auipc	a0,0x3
    80005cb2:	b7250513          	addi	a0,a0,-1166 # 80008820 <syscalls+0x450>
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	f2c080e7          	jalr	-212(ra) # 80005be2 <panic>
      consputc(c);
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	c62080e7          	jalr	-926(ra) # 80005920 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cc6:	2485                	addiw	s1,s1,1
    80005cc8:	009a07b3          	add	a5,s4,s1
    80005ccc:	0007c503          	lbu	a0,0(a5)
    80005cd0:	10050763          	beqz	a0,80005dde <printf+0x1b2>
    if(c != '%'){
    80005cd4:	ff5515e3          	bne	a0,s5,80005cbe <printf+0x92>
    c = fmt[++i] & 0xff;
    80005cd8:	2485                	addiw	s1,s1,1
    80005cda:	009a07b3          	add	a5,s4,s1
    80005cde:	0007c783          	lbu	a5,0(a5)
    80005ce2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005ce6:	cfe5                	beqz	a5,80005dde <printf+0x1b2>
    switch(c){
    80005ce8:	05678a63          	beq	a5,s6,80005d3c <printf+0x110>
    80005cec:	02fb7663          	bgeu	s6,a5,80005d18 <printf+0xec>
    80005cf0:	09978963          	beq	a5,s9,80005d82 <printf+0x156>
    80005cf4:	07800713          	li	a4,120
    80005cf8:	0ce79863          	bne	a5,a4,80005dc8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005cfc:	f8843783          	ld	a5,-120(s0)
    80005d00:	00878713          	addi	a4,a5,8
    80005d04:	f8e43423          	sd	a4,-120(s0)
    80005d08:	4605                	li	a2,1
    80005d0a:	85ea                	mv	a1,s10
    80005d0c:	4388                	lw	a0,0(a5)
    80005d0e:	00000097          	auipc	ra,0x0
    80005d12:	e32080e7          	jalr	-462(ra) # 80005b40 <printint>
      break;
    80005d16:	bf45                	j	80005cc6 <printf+0x9a>
    switch(c){
    80005d18:	0b578263          	beq	a5,s5,80005dbc <printf+0x190>
    80005d1c:	0b879663          	bne	a5,s8,80005dc8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005d20:	f8843783          	ld	a5,-120(s0)
    80005d24:	00878713          	addi	a4,a5,8
    80005d28:	f8e43423          	sd	a4,-120(s0)
    80005d2c:	4605                	li	a2,1
    80005d2e:	45a9                	li	a1,10
    80005d30:	4388                	lw	a0,0(a5)
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	e0e080e7          	jalr	-498(ra) # 80005b40 <printint>
      break;
    80005d3a:	b771                	j	80005cc6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d3c:	f8843783          	ld	a5,-120(s0)
    80005d40:	00878713          	addi	a4,a5,8
    80005d44:	f8e43423          	sd	a4,-120(s0)
    80005d48:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005d4c:	03000513          	li	a0,48
    80005d50:	00000097          	auipc	ra,0x0
    80005d54:	bd0080e7          	jalr	-1072(ra) # 80005920 <consputc>
  consputc('x');
    80005d58:	07800513          	li	a0,120
    80005d5c:	00000097          	auipc	ra,0x0
    80005d60:	bc4080e7          	jalr	-1084(ra) # 80005920 <consputc>
    80005d64:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d66:	03c9d793          	srli	a5,s3,0x3c
    80005d6a:	97de                	add	a5,a5,s7
    80005d6c:	0007c503          	lbu	a0,0(a5)
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	bb0080e7          	jalr	-1104(ra) # 80005920 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d78:	0992                	slli	s3,s3,0x4
    80005d7a:	397d                	addiw	s2,s2,-1
    80005d7c:	fe0915e3          	bnez	s2,80005d66 <printf+0x13a>
    80005d80:	b799                	j	80005cc6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d82:	f8843783          	ld	a5,-120(s0)
    80005d86:	00878713          	addi	a4,a5,8
    80005d8a:	f8e43423          	sd	a4,-120(s0)
    80005d8e:	0007b903          	ld	s2,0(a5)
    80005d92:	00090e63          	beqz	s2,80005dae <printf+0x182>
      for(; *s; s++)
    80005d96:	00094503          	lbu	a0,0(s2)
    80005d9a:	d515                	beqz	a0,80005cc6 <printf+0x9a>
        consputc(*s);
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	b84080e7          	jalr	-1148(ra) # 80005920 <consputc>
      for(; *s; s++)
    80005da4:	0905                	addi	s2,s2,1
    80005da6:	00094503          	lbu	a0,0(s2)
    80005daa:	f96d                	bnez	a0,80005d9c <printf+0x170>
    80005dac:	bf29                	j	80005cc6 <printf+0x9a>
        s = "(null)";
    80005dae:	00003917          	auipc	s2,0x3
    80005db2:	a6a90913          	addi	s2,s2,-1430 # 80008818 <syscalls+0x448>
      for(; *s; s++)
    80005db6:	02800513          	li	a0,40
    80005dba:	b7cd                	j	80005d9c <printf+0x170>
      consputc('%');
    80005dbc:	8556                	mv	a0,s5
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	b62080e7          	jalr	-1182(ra) # 80005920 <consputc>
      break;
    80005dc6:	b701                	j	80005cc6 <printf+0x9a>
      consputc('%');
    80005dc8:	8556                	mv	a0,s5
    80005dca:	00000097          	auipc	ra,0x0
    80005dce:	b56080e7          	jalr	-1194(ra) # 80005920 <consputc>
      consputc(c);
    80005dd2:	854a                	mv	a0,s2
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	b4c080e7          	jalr	-1204(ra) # 80005920 <consputc>
      break;
    80005ddc:	b5ed                	j	80005cc6 <printf+0x9a>
  if(locking)
    80005dde:	020d9163          	bnez	s11,80005e00 <printf+0x1d4>
}
    80005de2:	70e6                	ld	ra,120(sp)
    80005de4:	7446                	ld	s0,112(sp)
    80005de6:	74a6                	ld	s1,104(sp)
    80005de8:	7906                	ld	s2,96(sp)
    80005dea:	69e6                	ld	s3,88(sp)
    80005dec:	6a46                	ld	s4,80(sp)
    80005dee:	6aa6                	ld	s5,72(sp)
    80005df0:	6b06                	ld	s6,64(sp)
    80005df2:	7be2                	ld	s7,56(sp)
    80005df4:	7c42                	ld	s8,48(sp)
    80005df6:	7ca2                	ld	s9,40(sp)
    80005df8:	7d02                	ld	s10,32(sp)
    80005dfa:	6de2                	ld	s11,24(sp)
    80005dfc:	6129                	addi	sp,sp,192
    80005dfe:	8082                	ret
    release(&pr.lock);
    80005e00:	0001c517          	auipc	a0,0x1c
    80005e04:	f4850513          	addi	a0,a0,-184 # 80021d48 <pr>
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	3d8080e7          	jalr	984(ra) # 800061e0 <release>
}
    80005e10:	bfc9                	j	80005de2 <printf+0x1b6>

0000000080005e12 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e12:	1101                	addi	sp,sp,-32
    80005e14:	ec06                	sd	ra,24(sp)
    80005e16:	e822                	sd	s0,16(sp)
    80005e18:	e426                	sd	s1,8(sp)
    80005e1a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e1c:	0001c497          	auipc	s1,0x1c
    80005e20:	f2c48493          	addi	s1,s1,-212 # 80021d48 <pr>
    80005e24:	00003597          	auipc	a1,0x3
    80005e28:	a0c58593          	addi	a1,a1,-1524 # 80008830 <syscalls+0x460>
    80005e2c:	8526                	mv	a0,s1
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	26e080e7          	jalr	622(ra) # 8000609c <initlock>
  pr.locking = 1;
    80005e36:	4785                	li	a5,1
    80005e38:	cc9c                	sw	a5,24(s1)
}
    80005e3a:	60e2                	ld	ra,24(sp)
    80005e3c:	6442                	ld	s0,16(sp)
    80005e3e:	64a2                	ld	s1,8(sp)
    80005e40:	6105                	addi	sp,sp,32
    80005e42:	8082                	ret

0000000080005e44 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e44:	1141                	addi	sp,sp,-16
    80005e46:	e406                	sd	ra,8(sp)
    80005e48:	e022                	sd	s0,0(sp)
    80005e4a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e4c:	100007b7          	lui	a5,0x10000
    80005e50:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e54:	f8000713          	li	a4,-128
    80005e58:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e5c:	470d                	li	a4,3
    80005e5e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e62:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e66:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e6a:	469d                	li	a3,7
    80005e6c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e70:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e74:	00003597          	auipc	a1,0x3
    80005e78:	9dc58593          	addi	a1,a1,-1572 # 80008850 <digits+0x18>
    80005e7c:	0001c517          	auipc	a0,0x1c
    80005e80:	eec50513          	addi	a0,a0,-276 # 80021d68 <uart_tx_lock>
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	218080e7          	jalr	536(ra) # 8000609c <initlock>
}
    80005e8c:	60a2                	ld	ra,8(sp)
    80005e8e:	6402                	ld	s0,0(sp)
    80005e90:	0141                	addi	sp,sp,16
    80005e92:	8082                	ret

0000000080005e94 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e94:	1101                	addi	sp,sp,-32
    80005e96:	ec06                	sd	ra,24(sp)
    80005e98:	e822                	sd	s0,16(sp)
    80005e9a:	e426                	sd	s1,8(sp)
    80005e9c:	1000                	addi	s0,sp,32
    80005e9e:	84aa                	mv	s1,a0
  push_off();
    80005ea0:	00000097          	auipc	ra,0x0
    80005ea4:	240080e7          	jalr	576(ra) # 800060e0 <push_off>

  if(panicked){
    80005ea8:	00003797          	auipc	a5,0x3
    80005eac:	a747a783          	lw	a5,-1420(a5) # 8000891c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005eb0:	10000737          	lui	a4,0x10000
  if(panicked){
    80005eb4:	c391                	beqz	a5,80005eb8 <uartputc_sync+0x24>
    for(;;)
    80005eb6:	a001                	j	80005eb6 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005eb8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005ebc:	0ff7f793          	andi	a5,a5,255
    80005ec0:	0207f793          	andi	a5,a5,32
    80005ec4:	dbf5                	beqz	a5,80005eb8 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005ec6:	0ff4f793          	andi	a5,s1,255
    80005eca:	10000737          	lui	a4,0x10000
    80005ece:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	2ae080e7          	jalr	686(ra) # 80006180 <pop_off>
}
    80005eda:	60e2                	ld	ra,24(sp)
    80005edc:	6442                	ld	s0,16(sp)
    80005ede:	64a2                	ld	s1,8(sp)
    80005ee0:	6105                	addi	sp,sp,32
    80005ee2:	8082                	ret

0000000080005ee4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005ee4:	00003717          	auipc	a4,0x3
    80005ee8:	a3c73703          	ld	a4,-1476(a4) # 80008920 <uart_tx_r>
    80005eec:	00003797          	auipc	a5,0x3
    80005ef0:	a3c7b783          	ld	a5,-1476(a5) # 80008928 <uart_tx_w>
    80005ef4:	06e78c63          	beq	a5,a4,80005f6c <uartstart+0x88>
{
    80005ef8:	7139                	addi	sp,sp,-64
    80005efa:	fc06                	sd	ra,56(sp)
    80005efc:	f822                	sd	s0,48(sp)
    80005efe:	f426                	sd	s1,40(sp)
    80005f00:	f04a                	sd	s2,32(sp)
    80005f02:	ec4e                	sd	s3,24(sp)
    80005f04:	e852                	sd	s4,16(sp)
    80005f06:	e456                	sd	s5,8(sp)
    80005f08:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f0a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f0e:	0001ca17          	auipc	s4,0x1c
    80005f12:	e5aa0a13          	addi	s4,s4,-422 # 80021d68 <uart_tx_lock>
    uart_tx_r += 1;
    80005f16:	00003497          	auipc	s1,0x3
    80005f1a:	a0a48493          	addi	s1,s1,-1526 # 80008920 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f1e:	00003997          	auipc	s3,0x3
    80005f22:	a0a98993          	addi	s3,s3,-1526 # 80008928 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f26:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f2a:	0ff7f793          	andi	a5,a5,255
    80005f2e:	0207f793          	andi	a5,a5,32
    80005f32:	c785                	beqz	a5,80005f5a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f34:	01f77793          	andi	a5,a4,31
    80005f38:	97d2                	add	a5,a5,s4
    80005f3a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005f3e:	0705                	addi	a4,a4,1
    80005f40:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f42:	8526                	mv	a0,s1
    80005f44:	ffffb097          	auipc	ra,0xffffb
    80005f48:	618080e7          	jalr	1560(ra) # 8000155c <wakeup>
    
    WriteReg(THR, c);
    80005f4c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f50:	6098                	ld	a4,0(s1)
    80005f52:	0009b783          	ld	a5,0(s3)
    80005f56:	fce798e3          	bne	a5,a4,80005f26 <uartstart+0x42>
  }
}
    80005f5a:	70e2                	ld	ra,56(sp)
    80005f5c:	7442                	ld	s0,48(sp)
    80005f5e:	74a2                	ld	s1,40(sp)
    80005f60:	7902                	ld	s2,32(sp)
    80005f62:	69e2                	ld	s3,24(sp)
    80005f64:	6a42                	ld	s4,16(sp)
    80005f66:	6aa2                	ld	s5,8(sp)
    80005f68:	6121                	addi	sp,sp,64
    80005f6a:	8082                	ret
    80005f6c:	8082                	ret

0000000080005f6e <uartputc>:
{
    80005f6e:	7179                	addi	sp,sp,-48
    80005f70:	f406                	sd	ra,40(sp)
    80005f72:	f022                	sd	s0,32(sp)
    80005f74:	ec26                	sd	s1,24(sp)
    80005f76:	e84a                	sd	s2,16(sp)
    80005f78:	e44e                	sd	s3,8(sp)
    80005f7a:	e052                	sd	s4,0(sp)
    80005f7c:	1800                	addi	s0,sp,48
    80005f7e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80005f80:	0001c517          	auipc	a0,0x1c
    80005f84:	de850513          	addi	a0,a0,-536 # 80021d68 <uart_tx_lock>
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	1a4080e7          	jalr	420(ra) # 8000612c <acquire>
  if(panicked){
    80005f90:	00003797          	auipc	a5,0x3
    80005f94:	98c7a783          	lw	a5,-1652(a5) # 8000891c <panicked>
    80005f98:	e7c9                	bnez	a5,80006022 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f9a:	00003797          	auipc	a5,0x3
    80005f9e:	98e7b783          	ld	a5,-1650(a5) # 80008928 <uart_tx_w>
    80005fa2:	00003717          	auipc	a4,0x3
    80005fa6:	97e73703          	ld	a4,-1666(a4) # 80008920 <uart_tx_r>
    80005faa:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005fae:	0001ca17          	auipc	s4,0x1c
    80005fb2:	dbaa0a13          	addi	s4,s4,-582 # 80021d68 <uart_tx_lock>
    80005fb6:	00003497          	auipc	s1,0x3
    80005fba:	96a48493          	addi	s1,s1,-1686 # 80008920 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fbe:	00003917          	auipc	s2,0x3
    80005fc2:	96a90913          	addi	s2,s2,-1686 # 80008928 <uart_tx_w>
    80005fc6:	00f71f63          	bne	a4,a5,80005fe4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005fca:	85d2                	mv	a1,s4
    80005fcc:	8526                	mv	a0,s1
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	52a080e7          	jalr	1322(ra) # 800014f8 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fd6:	00093783          	ld	a5,0(s2)
    80005fda:	6098                	ld	a4,0(s1)
    80005fdc:	02070713          	addi	a4,a4,32
    80005fe0:	fef705e3          	beq	a4,a5,80005fca <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005fe4:	0001c497          	auipc	s1,0x1c
    80005fe8:	d8448493          	addi	s1,s1,-636 # 80021d68 <uart_tx_lock>
    80005fec:	01f7f713          	andi	a4,a5,31
    80005ff0:	9726                	add	a4,a4,s1
    80005ff2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80005ff6:	0785                	addi	a5,a5,1
    80005ff8:	00003717          	auipc	a4,0x3
    80005ffc:	92f73823          	sd	a5,-1744(a4) # 80008928 <uart_tx_w>
  uartstart();
    80006000:	00000097          	auipc	ra,0x0
    80006004:	ee4080e7          	jalr	-284(ra) # 80005ee4 <uartstart>
  release(&uart_tx_lock);
    80006008:	8526                	mv	a0,s1
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	1d6080e7          	jalr	470(ra) # 800061e0 <release>
}
    80006012:	70a2                	ld	ra,40(sp)
    80006014:	7402                	ld	s0,32(sp)
    80006016:	64e2                	ld	s1,24(sp)
    80006018:	6942                	ld	s2,16(sp)
    8000601a:	69a2                	ld	s3,8(sp)
    8000601c:	6a02                	ld	s4,0(sp)
    8000601e:	6145                	addi	sp,sp,48
    80006020:	8082                	ret
    for(;;)
    80006022:	a001                	j	80006022 <uartputc+0xb4>

0000000080006024 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006024:	1141                	addi	sp,sp,-16
    80006026:	e422                	sd	s0,8(sp)
    80006028:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000602a:	100007b7          	lui	a5,0x10000
    8000602e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006032:	8b85                	andi	a5,a5,1
    80006034:	cb91                	beqz	a5,80006048 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006036:	100007b7          	lui	a5,0x10000
    8000603a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000603e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006042:	6422                	ld	s0,8(sp)
    80006044:	0141                	addi	sp,sp,16
    80006046:	8082                	ret
    return -1;
    80006048:	557d                	li	a0,-1
    8000604a:	bfe5                	j	80006042 <uartgetc+0x1e>

000000008000604c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000604c:	1101                	addi	sp,sp,-32
    8000604e:	ec06                	sd	ra,24(sp)
    80006050:	e822                	sd	s0,16(sp)
    80006052:	e426                	sd	s1,8(sp)
    80006054:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006056:	54fd                	li	s1,-1
    int c = uartgetc();
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	fcc080e7          	jalr	-52(ra) # 80006024 <uartgetc>
    if(c == -1)
    80006060:	00950763          	beq	a0,s1,8000606e <uartintr+0x22>
      break;
    consoleintr(c);
    80006064:	00000097          	auipc	ra,0x0
    80006068:	8fe080e7          	jalr	-1794(ra) # 80005962 <consoleintr>
  while(1){
    8000606c:	b7f5                	j	80006058 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000606e:	0001c497          	auipc	s1,0x1c
    80006072:	cfa48493          	addi	s1,s1,-774 # 80021d68 <uart_tx_lock>
    80006076:	8526                	mv	a0,s1
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	0b4080e7          	jalr	180(ra) # 8000612c <acquire>
  uartstart();
    80006080:	00000097          	auipc	ra,0x0
    80006084:	e64080e7          	jalr	-412(ra) # 80005ee4 <uartstart>
  release(&uart_tx_lock);
    80006088:	8526                	mv	a0,s1
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	156080e7          	jalr	342(ra) # 800061e0 <release>
}
    80006092:	60e2                	ld	ra,24(sp)
    80006094:	6442                	ld	s0,16(sp)
    80006096:	64a2                	ld	s1,8(sp)
    80006098:	6105                	addi	sp,sp,32
    8000609a:	8082                	ret

000000008000609c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000609c:	1141                	addi	sp,sp,-16
    8000609e:	e422                	sd	s0,8(sp)
    800060a0:	0800                	addi	s0,sp,16
  lk->name = name;
    800060a2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060a4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060a8:	00053823          	sd	zero,16(a0)
}
    800060ac:	6422                	ld	s0,8(sp)
    800060ae:	0141                	addi	sp,sp,16
    800060b0:	8082                	ret

00000000800060b2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060b2:	411c                	lw	a5,0(a0)
    800060b4:	e399                	bnez	a5,800060ba <holding+0x8>
    800060b6:	4501                	li	a0,0
  return r;
}
    800060b8:	8082                	ret
{
    800060ba:	1101                	addi	sp,sp,-32
    800060bc:	ec06                	sd	ra,24(sp)
    800060be:	e822                	sd	s0,16(sp)
    800060c0:	e426                	sd	s1,8(sp)
    800060c2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800060c4:	6904                	ld	s1,16(a0)
    800060c6:	ffffb097          	auipc	ra,0xffffb
    800060ca:	d72080e7          	jalr	-654(ra) # 80000e38 <mycpu>
    800060ce:	40a48533          	sub	a0,s1,a0
    800060d2:	00153513          	seqz	a0,a0
}
    800060d6:	60e2                	ld	ra,24(sp)
    800060d8:	6442                	ld	s0,16(sp)
    800060da:	64a2                	ld	s1,8(sp)
    800060dc:	6105                	addi	sp,sp,32
    800060de:	8082                	ret

00000000800060e0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800060e0:	1101                	addi	sp,sp,-32
    800060e2:	ec06                	sd	ra,24(sp)
    800060e4:	e822                	sd	s0,16(sp)
    800060e6:	e426                	sd	s1,8(sp)
    800060e8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060ea:	100024f3          	csrr	s1,sstatus
    800060ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800060f2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060f4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800060f8:	ffffb097          	auipc	ra,0xffffb
    800060fc:	d40080e7          	jalr	-704(ra) # 80000e38 <mycpu>
    80006100:	5d3c                	lw	a5,120(a0)
    80006102:	cf89                	beqz	a5,8000611c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006104:	ffffb097          	auipc	ra,0xffffb
    80006108:	d34080e7          	jalr	-716(ra) # 80000e38 <mycpu>
    8000610c:	5d3c                	lw	a5,120(a0)
    8000610e:	2785                	addiw	a5,a5,1
    80006110:	dd3c                	sw	a5,120(a0)
}
    80006112:	60e2                	ld	ra,24(sp)
    80006114:	6442                	ld	s0,16(sp)
    80006116:	64a2                	ld	s1,8(sp)
    80006118:	6105                	addi	sp,sp,32
    8000611a:	8082                	ret
    mycpu()->intena = old;
    8000611c:	ffffb097          	auipc	ra,0xffffb
    80006120:	d1c080e7          	jalr	-740(ra) # 80000e38 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006124:	8085                	srli	s1,s1,0x1
    80006126:	8885                	andi	s1,s1,1
    80006128:	dd64                	sw	s1,124(a0)
    8000612a:	bfe9                	j	80006104 <push_off+0x24>

000000008000612c <acquire>:
{
    8000612c:	1101                	addi	sp,sp,-32
    8000612e:	ec06                	sd	ra,24(sp)
    80006130:	e822                	sd	s0,16(sp)
    80006132:	e426                	sd	s1,8(sp)
    80006134:	1000                	addi	s0,sp,32
    80006136:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	fa8080e7          	jalr	-88(ra) # 800060e0 <push_off>
  if(holding(lk))
    80006140:	8526                	mv	a0,s1
    80006142:	00000097          	auipc	ra,0x0
    80006146:	f70080e7          	jalr	-144(ra) # 800060b2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000614a:	4705                	li	a4,1
  if(holding(lk))
    8000614c:	e115                	bnez	a0,80006170 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000614e:	87ba                	mv	a5,a4
    80006150:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006154:	2781                	sext.w	a5,a5
    80006156:	ffe5                	bnez	a5,8000614e <acquire+0x22>
  __sync_synchronize();
    80006158:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000615c:	ffffb097          	auipc	ra,0xffffb
    80006160:	cdc080e7          	jalr	-804(ra) # 80000e38 <mycpu>
    80006164:	e888                	sd	a0,16(s1)
}
    80006166:	60e2                	ld	ra,24(sp)
    80006168:	6442                	ld	s0,16(sp)
    8000616a:	64a2                	ld	s1,8(sp)
    8000616c:	6105                	addi	sp,sp,32
    8000616e:	8082                	ret
    panic("acquire");
    80006170:	00002517          	auipc	a0,0x2
    80006174:	6e850513          	addi	a0,a0,1768 # 80008858 <digits+0x20>
    80006178:	00000097          	auipc	ra,0x0
    8000617c:	a6a080e7          	jalr	-1430(ra) # 80005be2 <panic>

0000000080006180 <pop_off>:

void
pop_off(void)
{
    80006180:	1141                	addi	sp,sp,-16
    80006182:	e406                	sd	ra,8(sp)
    80006184:	e022                	sd	s0,0(sp)
    80006186:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006188:	ffffb097          	auipc	ra,0xffffb
    8000618c:	cb0080e7          	jalr	-848(ra) # 80000e38 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006190:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006194:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006196:	e78d                	bnez	a5,800061c0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006198:	5d3c                	lw	a5,120(a0)
    8000619a:	02f05b63          	blez	a5,800061d0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000619e:	37fd                	addiw	a5,a5,-1
    800061a0:	0007871b          	sext.w	a4,a5
    800061a4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061a6:	eb09                	bnez	a4,800061b8 <pop_off+0x38>
    800061a8:	5d7c                	lw	a5,124(a0)
    800061aa:	c799                	beqz	a5,800061b8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061b4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800061b8:	60a2                	ld	ra,8(sp)
    800061ba:	6402                	ld	s0,0(sp)
    800061bc:	0141                	addi	sp,sp,16
    800061be:	8082                	ret
    panic("pop_off - interruptible");
    800061c0:	00002517          	auipc	a0,0x2
    800061c4:	6a050513          	addi	a0,a0,1696 # 80008860 <digits+0x28>
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	a1a080e7          	jalr	-1510(ra) # 80005be2 <panic>
    panic("pop_off");
    800061d0:	00002517          	auipc	a0,0x2
    800061d4:	6a850513          	addi	a0,a0,1704 # 80008878 <digits+0x40>
    800061d8:	00000097          	auipc	ra,0x0
    800061dc:	a0a080e7          	jalr	-1526(ra) # 80005be2 <panic>

00000000800061e0 <release>:
{
    800061e0:	1101                	addi	sp,sp,-32
    800061e2:	ec06                	sd	ra,24(sp)
    800061e4:	e822                	sd	s0,16(sp)
    800061e6:	e426                	sd	s1,8(sp)
    800061e8:	1000                	addi	s0,sp,32
    800061ea:	84aa                	mv	s1,a0
  if(!holding(lk))
    800061ec:	00000097          	auipc	ra,0x0
    800061f0:	ec6080e7          	jalr	-314(ra) # 800060b2 <holding>
    800061f4:	c115                	beqz	a0,80006218 <release+0x38>
  lk->cpu = 0;
    800061f6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800061fa:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800061fe:	0f50000f          	fence	iorw,ow
    80006202:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006206:	00000097          	auipc	ra,0x0
    8000620a:	f7a080e7          	jalr	-134(ra) # 80006180 <pop_off>
}
    8000620e:	60e2                	ld	ra,24(sp)
    80006210:	6442                	ld	s0,16(sp)
    80006212:	64a2                	ld	s1,8(sp)
    80006214:	6105                	addi	sp,sp,32
    80006216:	8082                	ret
    panic("release");
    80006218:	00002517          	auipc	a0,0x2
    8000621c:	66850513          	addi	a0,a0,1640 # 80008880 <digits+0x48>
    80006220:	00000097          	auipc	ra,0x0
    80006224:	9c2080e7          	jalr	-1598(ra) # 80005be2 <panic>
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
