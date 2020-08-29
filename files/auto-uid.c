/* auto-uid.c -- replacement for auto-uid.c that prints hardcoded values
 *
 * The original auto-uid looks up users using getpwname, but in the
 * FreeBSD ports system the users are not created until later.
 *
 * So this replaces the lookup with hardcoded numbers from /usr/ports/UIDs.
 */

#include <unistd.h>
#include "buffer.h"
#include "exit.h"
#include "scan.h"
#include "fmt.h"
#include "str.h"

char inbuf[256];
buffer b = BUFFER_INIT(write, 1, inbuf, sizeof(inbuf));

void
outs(char *s)
{
    if (buffer_puts(&b, s) == -1)
        _exit(111);
}

int
main(int argc, char **argv)
{
    char *varname;
    char *username;
    char strnum[FMT_ULONG];

    varname = argv[1];
    if (!varname)
        _exit(100);
    username = argv[2];
    if (!username)
        _exit(100);
    
#include "usertab.c"

    struct user *up;
    for (up = users; up->name; ++up)
        if (str_equal(up->name, username)) {
            strnum[fmt_ulong(strnum, (unsigned long)up->uid)] = 0;
            outs("int ");
            outs(varname);
            outs(" = ");
            outs(strnum);
            outs(";\n");
            if (buffer_flush(&b) == -1)
                _exit(111);
            _exit(0);
        }

    buffer_puts(buffer_2, "fatal: unable to find user ");
    buffer_puts(buffer_2, username);
    buffer_puts(buffer_2, "\n");
    buffer_flush(buffer_2);
    _exit(111);
}
