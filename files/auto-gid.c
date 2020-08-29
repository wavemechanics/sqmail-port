/* auto-gid.c -- replacement for auto-gid.c that prints hardcoded values
 *
 * The original auto-gid looks up groups using getgrnam, but in the
 * FreeBSD ports system the groups are not created until later.
 *
 * So this replaces the lookup with hardcoded numbers from /usr/ports/GIDs.
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
    char *groupname;
    char strnum[FMT_ULONG];

    varname = argv[1];
    if (!varname)
        _exit(100);
    groupname = argv[2];
    if (!groupname)
        _exit(100);

#include "grouptab.c"

    struct group *gp;
    for (gp = groups; gp->name; ++gp)
        if (str_equal(gp->name, groupname)) {
            strnum[fmt_ulong(strnum, (unsigned long)gp->gid)] = 0;
            outs("int ");
            outs(varname);
            outs(" = ");
            outs(strnum);
            outs(";\n");
            if (buffer_flush(&b) == -1)
                _exit(111);
            _exit(0);
        }

    buffer_puts(buffer_2, "fatal: unable to find group ");
    buffer_puts(buffer_2, groupname);
    buffer_puts(buffer_2, "\n");
    buffer_flush(buffer_2);
    _exit(111);
}
