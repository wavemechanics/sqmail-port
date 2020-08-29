#!/bin/sh

(
    ./gen-plist
    echo '@(root,qnofiles,0755) ssl'
    echo '@(root,wheel,0755) svc'
    echo '@(root,qnofiles,0755) example'
    echo '@(root,qnofiles,0755) doc'
    echo '@(root,qnofiles,0755) doc/Qmail'
    echo '@(root,qnofiles,0755) doc/Old'
) | sort -k2 -u | grep '^@dir' | sort -r -k2

(
    ./gen-plist

    echo "@(root,wheel,0644) ssl/ssl.env.template"
    echo "@(root,wheel,0644) example/services=d"
    echo "@(root,wheel,0644) example/mailer.conf"

    for f in run_log run_pop3d run_pop3sd run_qmqpd run_qmtpd run_qmtpsd run_send run_smtpd run_smtpsd run_smtpsub
    do
        echo "@(root,wheel,0644) example/$f"
    done

    for man in \
        bouncesaying.1 \
        columnt.1 \
        condredirect.1 \
        except.1 \
        fastforward.1 \
        forward.1 \
        maildir2mbox.1 \
        maildirmake.1 \
        maildirwatch.1 \
        mailsubj.1 \
        matchup.1 \
        newaliases.1 \
        newinclude.1 \
        preline.1 \
        printforward.1 \
        printmaillist.1 \
        qbiff.1 \
        qreceipt.1 \
        setforward.1 \
        setmaillist.1 \
        srsforward.1 \
        srsreverse.1 \
        xqp.1 \
        xrecipient.1 \
        xsender.1
    do
        echo "@(root,wheel,0644) man/man1/${man}.gz"
    done

    echo "@(root,wheel,0644) man/man3/datetime.3.gz"

    for man in \
        addresses.5 \
        dot-qmail.5 \
        envelopes.5 \
        maildir.5 \
        mbox.5 \
        qmail-control.5 \
        qmail-header.5 \
        qmail-log.5 \
        qmail-users.5 \
        tai64nfrac.5 \
        tcp-environ.5
    do
        echo "@(root,wheel,0644) man/man5/${man}.gz"
    done

    for man in \
        forgeries.7 \
        qmail-limits.7 \
        sqmail.7
    do
        echo "@(root,wheel,0644) man/man7/${man}.gz"
    done

    for man in \
        dnscname.8 \
        dnsfq.8 \
        dnsip.8 \
        dnsmxip.8 \
        dnsptr.8 \
        dnstxt.8 \
        hostname.8 \
        ipmeprint.8 \
        qmail-authuser.8 \
        qmail-badloadertypes.8 \
        qmail-badmimetypes.8 \
        qmail-clean.8 \
        qmail-command.8 \
        qmail-getpw.8 \
        qmail-inject.8 \
        qmail-local.8 \
        qmail-lspawn.8 \
        qmail-mfrules.8 \
        qmail-mrtg.8 \
        qmail-newmrh.8 \
        qmail-newu.8 \
        qmail-pop3d.8 \
        qmail-popup.8 \
        qmail-pw2u.8 \
        qmail-qmqpc.8 \
        qmail-qmqpd.8 \
        qmail-qmtpd.8 \
        qmail-qread.8 \
        qmail-qstat.8 \
        qmail-queue.8 \
        qmail-recipients.8 \
        qmail-remote.8 \
        qmail-rspawn.8 \
        qmail-send.8 \
        qmail-showctl.8 \
        qmail-smtpam.8 \
        qmail-smtpd.8 \
        qmail-start.8 \
        qmail-tcpok.8 \
        qmail-tcpto.8 \
        qmail-todo.8 \
        qmail-vmailuser.8 \
        spfquery.8 \
        splogger.8
    do
        echo "@(root,wheel,0644) man/man8/${man}.gz"
    done

    for doc in \
        BLURB \
        CHANGELOG \
        CHANGELOG_V3 \
        CONTRIBUTERS \
        EXTTODO \
        LICENSE \
        LOGGING \
        Old/PROPOSAL.mav \
        Old/README.djbdns \
        Old/README.mav \
        Old/README.qmq \
        Old/README.recipients \
        Old/README.wildmat \
        Qmail/BLURB \
        Qmail/FAQ \
        Qmail/INSTALL.alias \
        Qmail/INSTALL.ctl \
        Qmail/INSTALL.ids \
        Qmail/INSTALL.maildir \
        Qmail/INSTALL.mbox \
        Qmail/INSTALL.qmail \
        Qmail/INTERNALS \
        Qmail/PIC.local2alias \
        Qmail/PIC.local2ext \
        Qmail/PIC.local2local \
        Qmail/PIC.local2rem \
        Qmail/PIC.local2virt \
        Qmail/PIC.nullclient \
        Qmail/PIC.relaybad \
        Qmail/PIC.relaygood \
        Qmail/PIC.rem2local \
        Qmail/README \
        Qmail/REMOVE.binmail \
        Qmail/REMOVE.sendmail \
        Qmail/SYSDEPS \
        Qmail/TEST.deliver \
        Qmail/TEST.receive \
        Qmail/THANKS \
        Qmail/THOUGHTS \
        Qmail/TODO \
        README.clamav \
        README.smtpreply \
        TODO \
        smtpreplies
    do
        echo "@(root,wheel,0644) doc/${doc}"
    done
) | sort -k2 -u | grep -v '^@dir'

cat <<EOF
@sample control/badloadertypes.sample
@sample control/badmailfrom.sample
@sample control/badmimetypes.sample
@sample control/badrcptto.sample
@sample control/rules.qmtpd.cdb.sample
@sample control/rules.qmtpd.txt.sample
@sample control/rules.smtpd.cdb.sample
@sample control/rules.smtpd.txt.sample
@sample control/tlsdestinations.sample
EOF
