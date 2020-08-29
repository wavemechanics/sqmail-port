/* Hardcoded group names and ids based on /usr/ports/GIDs */

struct group {
char *name;
    int gid;
} groups[] = {
    { "wheel",    0 },
    { "qmail",    82 },
    { "qnofiles", 81 },
    { NULL,     -1 },
};
