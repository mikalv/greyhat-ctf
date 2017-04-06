TODO
=====

It's a lot.

* Update README.md
* Check http://docs.ansible.com/ansible/list_of_all_modules.html so u don't repeat.
* https://github.com/facebook/fbctf/wiki/Challenge-Overview - Try make a system like this?

Extend features todo
---------------------

* Create a generic service API for general tasks (non disassembly tasks like XSS)
* Highscore system
* Allow user to set user/pass after level login for highscore system
* Only some services actually needs to be "session based" until we got levels changing to ranomize the CTF and make writeups harder. Delay this.
* Focus on level00 service as PoC for a shared session service (It does not require any special arguments for the session).
* Rewrite all pacman tasks to "package", and rather select package list based on OS. Then we can test this out on Debian, Gentoo and other distros as well. It unlocks us from ArchLinux, even it's nice.
* Make a good way to remove old directories and files (deprecation), like a own cleanup.yml

Refactor todos
---------------

* Make a better tag system for ansible tasks, so we can update for example just all binaries for all levels, or all services, etc.
* Remove all tags labeled archlinux if it would work on multiple distros
* Place publicweb and related into own webserver role?
* Read levels from another directory other than git. (Got scripts to remove all levels from history)
  * Check here how to find ENV on localhost: http://stackoverflow.com/a/24124973/759341
  * Fetch levels from outside of ansible, but add it as a part of it in runtime or something.

Bug-ish todos
---------------
* Ansible: Kernel must be installed by hand in front.
* Ansible: Grub config must be manually edited in front.
* Ansible: Multilib support must be installed by hand in front.
* Ansible: Archlinux-keyring must be installed by hand in front.


System and security research
-----------------------------

* Find out how much open files a "session-fs" based session is creating
* Find about security issues that x86_64 introduces
* Find out what if someone executes x86_64, does it higher chance of root access?


Security & audit
-----------------

Some of the most critical places is the ctssh-wrapper.sh.j2 and newctfsession.sh.j2 templates under ctfserver, as well as the file ctfmod-arch-chroot.sh under files. Those three files are all executed 
and plays a big role in the level login system.

Some general rules are:
    * Don't trust environment variables these scripts don't set themself.
    * Hardcode the fullpath to every single binary, even "/usr/bin/echo".
    * Don't trust any predefined command or environment variable from user.
    * On error, KILL everything so the user don't get an unexpected shell.

