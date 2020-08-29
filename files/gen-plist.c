#include <unistd.h>
#include "buffer.h"
#include "exit.h"

extern void hier();

#define WHO "gen-plist"

void print(char *s)
{
    buffer_puts(buffer_1, s);
}

void print_owner(int uid)
{
#include "usertab.c"

    struct user *up;

    for (up = users; up->name; ++up)
        if (up->uid == uid) {
            buffer_puts(buffer_1, up->name);
            return;
        }
    _exit(111);
}

void print_group(int gid)
{
#include "grouptab.c"

    struct group *gp;

    for (gp = groups; gp->name; ++gp)
        if (gp->gid == gid) {
            buffer_puts(buffer_1, gp->name);
            return;
        }
    _exit(111);
}

/* fmt_oint and tooct paraphrased from fmt_xlong in fehQlibs fmt.c */
int
tooct(int num)
{
    return (num < 8) ? num + '0' : -1;
}

int fmt_oint(char *s, int o)
{
    int len = 1;
    int q = o;

    while (q > 7) {
        ++len;
        q /= 8;
    }
    s[len] = '\0';
    if (s) {
        s += len;
        do {
            *--s = tooct(o % 8);
            o /= 8;
        } while (o);
    }
    return len;
}

void print_mode(int mode)
{
    static char buf[100];

    fmt_oint(buf, mode);
    buffer_puts(buffer_1, "0");
    buffer_puts(buffer_1, buf);
}

void h(char *home,int uid,int gid,int mode)
{
}

void d(char *home,char *subdir,int uid,int gid,int mode)
{
    print("@dir(");
    print_owner(uid);
    print(",");
    print_group(gid);
    print(",");
    print_mode(mode);
    print(") ");
    print(subdir);
    print("\n");
}

void p(char *home,char *fifo,int uid,int gid,int mode)
{
}

void c(char *home,char *subdir,char *file,int uid,int gid,int mode)
{
    print("@(");
    print_owner(uid);
    print(",");
    print_group(gid);
    print(",");
    print_mode(mode);
    print(") ");

    if (*subdir) {
        print(subdir);
        print("/");
    }

    print(file);
    print("\n");
}

void z(char *home,char *file,int len,int uid,int gid,int mode)
{
    c(home, "", file, uid, gid, mode);
}

int main()
{
  hier();
  buffer_flush(buffer_1);
  _exit(0);
}
