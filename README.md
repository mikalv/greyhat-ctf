Capture The Flag!
=================
This will setup a ArchLinux installation ready to be used as a CTF server.
More TBA.


Requirements
------------
You will need the following in order to build the Live CD using
the scripts in this project:

* Mac OS X or Linux is supported for now.
* `git` -- for getting the files
* `pwgen` -- for generating random passwords
* `python` -- For Ansible
* `curl` -- for downloading packages and other files

Mini Ansible howto
-------------------

Learn ansible pothead!

`ansible-playbook -i inventory/hosts playbooks/prod_ctfservers.yml` is usually used to distribute ansible config.

For more verbose messages you can add `-v`, for even more verbosity add a v like this `-vv` or even more.

To not run the whole shit all the time, add `-t TAGNAME_FROM_TASK` where TAGNAME_FROM_TASK is usually something like `ctfserver`, `ctflevels`, `myretardedtag`, `install_packages` or whatever you define :)

To release a asm level would usually include these params;
`ansible-playbook -i inventory/hosts playbooks/prod_ctfservers.yml -t ctflevelcompile,ctfserver,ctfhomes,ctflevels -vvv`

How to add a new level
----------------------

1. Create the level itself and put it in ansible/roles/ctfserver/templates/levels/ and
   ansible/roles/ctfserver/files/levels/
2. Create a new user by updating ansible/group_vars/ctfserver.yml:
   - create a new 20 character password (f.ex pwgen -sn 20)
   - create a new password hash using the password generated in the previous step:
     python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.using(rounds=5000).hash(getpass.getpass())"
   - create a new entry for the user in the section called `ctfgame_userlevels_enabled`, using the previous user as a template:
     - Update the `pwclean` and `password` fields using the generated password and password hash
     - update the following fields in the previous user to `True`: `suidenabled`, `binary`, `binary_keep_source`
     - remember to update the `groups` field and add the user to its own group



Links
-----
* [Blog announcement of Capture The Flag, by Facebook](https://www.facebook.com/notes/facebook-ctf/facebook-ctf-is-now-open-source/525464774322241/)
* [Blog announcement of Capture The Flag, by Stripe](https://stripe.com/blog/capture-the-flag)
* [Blog announcement of Capture The Flag 2.0, by Stripe](https://stripe.com/blog/capture-the-flag-20)
* [The CTF ASCII art generator](http://patorjk.com/software/taag/#p=testall&f=Graffiti&t=CTF)
* http://io.smashthestack.org:84/
* [Arch Linux](https://www.archlinux.org/)
* [Ansible documentation](http://docs.ansible.com/)
* [Awesome CTF list](https://github.com/apsdehal/awesome-ctf)
* [Vulnhub - A place to get ideas](https://www.vulnhub.com/)
* [Exploit Exercises - Another place to get ideas](https://exploit-exercises.com/)
* [Github writeups repo - Yet another place to get ideas](https://github.com/smokeleeteveryday/CTF_WRITEUPS)


Todo
----
See TODO.md

