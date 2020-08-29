#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/stat.h>
#include "buffer.h"
#include "logmsg.h"
#include "open.h"
#include "exit.h"
#include "fifo.h"

extern void hier();

#define WHO "install"

int fdsourcedir = -1;

void h(char *home,int uid,int gid,int mode)
{
  if (mkdir(home,0700) == -1)
    if (errno != EEXIST)
      logmsg(WHO,111,FATAL,B("unable to mkdir: ",home));
  if (chown(home,uid,gid) == -1) {
    perror("h");
    fprintf(stderr, "errno=%d\n", errno);
    logmsg(WHO,111,FATAL,B("unable to chown: ",home));
  }
  if (chmod(home,mode) == -1)
    logmsg(WHO,111,FATAL,B("unable to chmod: ",home));
}

void d(char *home,char *subdir,int uid,int gid,int mode)
{
  if (chdir(home) == -1)
    logmsg(WHO,110,FATAL,B("unable to switch to: ",home));
  if (mkdir(subdir,0700) == -1)
    if (errno != EEXIST)
      logmsg(WHO,111,FATAL,B("unable to mkdir: ",home,"/",subdir));
  if (chown(subdir,uid,gid) == -1)
    logmsg(WHO,111,FATAL,B("unable to chown: ",home,"/",subdir));
  if (chmod(subdir,mode) == -1)
    logmsg(WHO,111,FATAL,B("unable to chmod: ",home,"/",subdir));
}

void p(char *home,char *fifo,int uid,int gid,int mode)
{
  if (chdir(home) == -1)
    logmsg(WHO,110,FATAL,B("unable to switch to: ",home));
  if (fifo_make(fifo,0700) == -1)
    if (errno != EEXIST)
      logmsg(WHO,111,FATAL,B("unable to mkfifo: ",home,"/",fifo));
  if (chown(fifo,uid,gid) == -1)
    logmsg(WHO,111,FATAL,B("unable to chown: ",home,"/",fifo));
  if (chmod(fifo,mode) == -1)
    logmsg(WHO,111,FATAL,B("unable to chmod: ",home,"/",fifo));
}

char inbuf[BUFFER_INSIZE];
buffer bi;
char outbuf[BUFFER_OUTSIZE];
buffer bo;

void c(char *home,char *subdir,char *file,int uid,int gid,int mode)
{
  int fdin;
  int fdout;

  if (fchdir(fdsourcedir) == -1)
    logmsg(WHO,110,FATAL,"unable to switch back to source directory: ");

  fdin = open_read(file);
  if (fdin == -1)
    logmsg(WHO,111,FATAL,B("unable to read: ",file));
  buffer_init(&bi,read,fdin,inbuf,sizeof(inbuf));

  if (chdir(home) == -1)
    logmsg(WHO,110,FATAL,B("unable to switch to: ",home));
  if (chdir(subdir) == -1)
    logmsg(WHO,110,FATAL,B("unable to switch to: ",home,"/",subdir));

  fdout = open_trunc(file);
  if (fdout == -1)
    logmsg(WHO,111,FATAL,B("unable to write .../",subdir,"/",file));
  buffer_init(&bo,write,fdout,outbuf,sizeof(outbuf));

  switch (buffer_copy(&bo,&bi)) {
    case -2:
      logmsg(WHO,111,FATAL,B("unable to read: ",file));
    case -3:
      logmsg(WHO,111,FATAL,B("unable to write .../",subdir,"/",file));
  }

  close(fdin);
  if (buffer_flush(&bo) == -1)
    logmsg(WHO,111,FATAL,B("unable to write .../",subdir,"/",file));
  if (fsync(fdout) == -1)
    logmsg(WHO,111,FATAL,B("unable to write .../",subdir,"/",file));
  if (close(fdout) == -1) /* NFS silliness */
    logmsg(WHO,111,FATAL,B("unable to write .../",subdir,"/",file));

  if (chown(file,uid,gid) == -1)
    logmsg(WHO,111,FATAL,B("unable to chown .../",subdir,"/",file));
  if (chmod(file,mode) == -1)
    logmsg(WHO,111,FATAL,B("unable to chmod .../",subdir,"/",file));
}

void z(char *home,char *file,int len,int uid,int gid,int mode)
{
  int fdout;

  if (chdir(home) == -1)
    logmsg(WHO,110,FATAL,B("unable to switch to: ",home));

  fdout = open_trunc(file);
  if (fdout == -1)
    logmsg(WHO,111,FATAL,B("unable to write: ",home,"/",file));
  buffer_init(&bo,write,fdout,outbuf,sizeof(outbuf));

  while (len-- > 0)
    if (buffer_put(&bo,"",1) == -1)
      logmsg(WHO,111,FATAL,B("unable to write: ",home,"/",file));

  if (buffer_flush(&bo) == -1)
    logmsg(WHO,111,FATAL,B("unable to write: ",home,"/",file));
  if (fsync(fdout) == -1)
    logmsg(WHO,111,FATAL,B("unable to write: ",home,"/",file));
  if (close(fdout) == -1) /* NFS silliness */
    logmsg(WHO,111,FATAL,B("unable to write: ",home,"/",file));

  if (chown(file,uid,gid) == -1)
    logmsg(WHO,111,FATAL,B("unable to chown: ",home,"/",file));
  if (chmod(file,mode) == -1)
    logmsg(WHO,111,FATAL,B("unable to chmod: ",home,"/",file));
}

int main()
{
  fdsourcedir = open_read(".");
  if (fdsourcedir == -1)
    logmsg(WHO,110,FATAL,"unable to open current directory: ");

  umask(077);
  hier();
  _exit(0);
}
