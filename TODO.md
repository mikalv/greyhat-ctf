TODO
=====

It's a lot.

Refactor / Extend features
---------------------------

* Place publicweb and related into own webserver role?
* Create a generic service API for general tasks (non disassembly tasks like XSS)
* Highscore system
* Allow user to set user/pass after level login for highscore system


Security & audit
-----------------

Some of the most critical places is the ctssh-wrapper.sh.j2 and newctfsession.sh.j2 templates under ctfserver, as well as the file ctfmod-arch-chroot.sh under files. Those three files are all executed 
and plays a big role in the level login system.

Some general rules are:
    * Don't trust environment variables these scripts don't set themself.
    * Hardcode the fullpath to every single binary, even "/usr/bin/echo".
    * Don't trust any predefined command or environment variable from user.
    * On error, KILL everything so the user don't get an unexpected shell.

