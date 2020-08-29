/* hard-coded usernames and ids based on /usr/ports/UIDs */

struct user {
    char *name;
    int uid;
} users[] = {
    { "alias",  81 },
    { "qmaild", 82 },
    { "qmaill", 83 },
    { "root",   0  },
    { "qmailp", 84 },
    { "qmailq", 85 },
    { "qmailr", 86 },
    { "qmails", 87 },
    { NULL,     -1 },
};
