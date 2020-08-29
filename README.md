# sqmail-port

This repo integrates [s/qmail](https://www.fehcom.de/ipnet/ucspi-ssl.html) into the FreeBSD ports system.

The contents of this repo should be visible under `/usr/local/ports/mail/sqmail`.

Most of the time the ports tree is owned by root, so you may not be able to directly clone this repo into the ports directory.

But some ideas:
* `git clone` as root, or
* create a symlink from the ports tree into a cloned directory in your home, or
* rsync from your home to a poudriere instance somewhere else

I use the third method and it works ok.

Once the `mail/sqmail` directory is populated, you can treat it as a normal port:

```
# cd /usr/ports/mail/sqmail
# make install
```

## Depends

[fehQlibs](https://github.com/wavemechanics/fehQlibs)

[feh-ucspi-ssl](https://github.com/wavemechanics/feh-ucspi-ssl-port)

`/usr/ports/sysutils/daemontools`

## References

https://www.fehcom.de/sqmail/sqmail.html

## Rough Edges

This port is quite complicated because the s/qmail build and installation system is not written with binary packaging in mind.
So there may be rough edges with this port.
It works for what I need, but you might run into something I've missed.
Please get in touch if you run into anything.