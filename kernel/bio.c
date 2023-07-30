  // Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

// struct {
//   struct spinlock lock;
//   struct buf buf[NBUF];

//   // Linked list of all buffers, through prev/next.
//   // Sorted by how recently the buffer was used.
//   // head.next is most recent, head.prev is least.
//   struct buf head;
// } bcache;

#define BUCKSIZE 13

struct buf buf[NBUF];
struct spinlock lock;
struct spinlock pre_lock;
struct buck{
  struct spinlock lock;
  struct buf head;
};
//hashmap
struct buck bucket[BUCKSIZE]; 

void hook(struct buf* dst,int index)
{
  struct buf *tmp=&bucket[index].head;
  while(tmp->next)tmp=tmp->next;
  tmp->next=dst;
  dst->next=0;
};



void
binit(void)
{
  struct buf *b;

  initlock(&lock, "bcache");
  initlock(&pre_lock,"deadlockprevention");
  printf("%d\n",NBUF);
  for(int i=0;i<BUCKSIZE;i++)
  {
    initlock(&bucket[i].lock,"bcache.bucket");
    //bucket->head->next=0;
  }
  // Create linked list of buffers
  
  int index=0;
  for(b = buf; b < buf+NBUF; b++){
    initsleeplock(&b->lock, "buffer");
    hook(b,index);
    index=(index+1)%BUCKSIZE;
  }
  printf("1\n");
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;
  int b_num=blockno%BUCKSIZE;
  b=&bucket[b_num].head;
  acquire(&bucket[b_num].lock);
  while(b)//找现成
  {
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      //release(&lock);
      release(&bucket[b_num].lock);
      acquiresleep(&b->lock);
      return b;
    }
    b=b->next;
  }
  //本bucket重新分配
  b=&bucket[b_num].head;
  while(b)
  {
    if(b->refcnt==0)
    {
      b->dev = dev;//初始化
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      release(&bucket[b_num].lock);
      acquiresleep(&b->lock);
      return b;
    }
    b=b->next;
  }
  //另寻bucket重新分配
  acquire(&pre_lock);
  release(&bucket[b_num].lock);
  acquire(&lock);
  release(&pre_lock);

  for(int i=0;i<BUCKSIZE;i++)
  {
    if(i==b_num)continue;
    acquire(&bucket[i].lock);
    struct buf *tmp=&bucket[i].head;//双指针一起查找
    b=bucket[i].head.next;
    while(b){
      if(b->refcnt==0)
      {
        tmp->next=b->next;//在bucket i中去掉buf
        release(&bucket[i].lock);
        acquire(&bucket[b_num].lock);
        b->dev = dev;//初始化
        b->blockno = blockno;
        b->valid = 0;
        b->refcnt = 1;
        hook(b,b_num);//把b连接在正确hash的bucket里面
        release(&bucket[b_num].lock);


        release(&lock);//释放锁，返回
        acquiresleep(&b->lock);
        return b;
      }
      tmp=tmp->next;
      b=b->next;
    }
    release(&bucket[i].lock);
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);
  int b_num=b->blockno%BUCKSIZE;
  acquire(&bucket[b_num].lock);
  b->refcnt--;
  release(&bucket[b_num].lock);
}

void
bpin(struct buf *b) {
  acquire(&bucket[b->blockno%BUCKSIZE].lock);
  b->refcnt++;
  release(&bucket[b->blockno%BUCKSIZE].lock);
}

void
bunpin(struct buf *b) {
  acquire(&bucket[b->blockno%BUCKSIZE].lock);
  b->refcnt--;
  release(&bucket[b->blockno%BUCKSIZE].lock);
}


