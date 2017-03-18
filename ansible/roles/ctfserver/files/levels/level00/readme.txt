┌────────────────────┐
│ README             │
└────────────────────┘
┌───────────────────────────────────────────────────────────────────────────┐
│ Admin - meeh                                                              │
├──────────────────────────────────────────────────────────────────────────┬┘
│   IRC:     irc.echelon.i2p #ctfgreyhat  channel pw: HackTheWorld         │
│   Twitter: @mikalv                                                       │
│   Email:   meeh@greyhat.no                                               │
└──────────────────────────────────────────────────────────────────────────┘
┌───────────────────────────────────────────────────────────────────────────┐
│ Rules and System Info                                                     │
├──────────────────────────────────────────────────────────────────────────┬┘
│   1. Do not DoS this or any other system. Don't be a kiddy!              │
│   2. Do not connect to remote systems from this.                         │
│   3. Do not use too many resources. This is a very small server.         │
│   4. Do not spoil challenges (no writeups!), but helping newbs good.     │
│   5. Be excellent.                                                       │
├──────────────────────────────────────────────────────────────────────────┤
│   - levels can be found under /levels                                    │
│   - Your changes leaves with the ssh session, don't write to a file      │
|     expect it to be there in the next session. Except for /tmp           |
│   - Unused files and folders in /tmp are deleted after a few hours.      │
│   - If you want to have a specific tool installed, contact me.           │
│   - If you find bugs, please contact me.                                 │
└──────────────────────────────────────────────────────────────────────────┘
┌───────────────────────────────────────────────────────────────────────────┐
│ How it works...                                                           │
├──────────────────────────────────────────────────────────────────────────┬┘
│ This is a hacking game. The goal is to hack from level to level.         │
│                                                                          │
│ You are currently level00. The password of your current level can be     │
│ found in ~/.passwd                                                       │
│    + run `id` to display your current user id                            │
│    + display your current password `cat /home/level00/.passwd`           │
│                                                                          │
│ So your goal is to find the password for the next level (level01). With  │
│ the password you can then connect to the next level                      │
│    + `ssh level01@greyhat.no` to login with the found password           │
│                                                                          │
│ The level relevant files can be found under /levels                      │
│    + display the files for level0 `ls /levels/level00/`                  │
│                                                                          │
│ A good point to start is to read the "story" in your home folder. It     │
│ will give some motivation for the current level, it will tell you what   │
│ files are necessary and maybe give additional info.                      │
│    + display current story run the command `story`                       │
│                                                                          │
│ Sometimes there is a story recap available, which contains additional    │
│ information about the challenge that you just solved. Usually this means │
│ you will discover new tools or techniques how to solve a challenge. If   │
│ you have a particular nice solution that you would like to share,        │
│ contact me, and I might add it.                                          │
│    + display the demo recap `cat ~/recap.txt`                            │
│    + the recap for level00 is in `cat /home/level01/recap.txt`           │
│       (you need to get access to level1 before you can read it)          │
│                                                                          │
│ To show people that you made it to a particular level, you can add your  │
│ nickname, messages and secrets to the "iwashere" file. You can only read │
│ and append something to the file.                                        │
│    + show the world that you found this game:                            │
│      `echo "I made this. ~samuirai" >> ~/iwashere.txt`                   │
│    + look at who was in level00 `less ~/iwashere.txt` or                 |
|      `cat ~/iwashere.txt`                                                │
│                                                                          │
│ Most important point. Have fun. The worst thing that can happen is, that │
│ you accidentally learn something.                                        │
└──────────────────────────────────────────────────────────────────────────┘
┌───────────────────────────────────────────────────────────────────────────┐
│ Start                                                                     │
├──────────────────────────────────────────────────────────────────────────┬┘
│ 1. read the story for your current level                                 │
│     type the command `story`                                             │
│ 2. find the files in `ls /levels/level00`                                │
│ 3. create a working directory in /tmp to develop scripts and tools       │
│ 4. solve the challenge and get the password                              │
│ 5. login as level01                                                      │
│ 6. read the recap for this level                                         │
│     `cat ~/recap.txt`                                                    │
│ 7. read the story for level01 and solve the next challenge               │
└──────────────────────────────────────────────────────────────────────────┘
