# bash_profile

My custom bash shell configuration.

## Keeping in sync

Remove the `.bash_profile` file form your home directory and create a symlink pointing to this file, e.g.

```
$ rm ~/.bash_profile
$ ln -s ~/Programming/bash_profile/.bash_profile ~/.bash_profile
$ source ~/.bash_profile
```

Going forward, opening `~/.bash_profile` to make changes will update the source controlled version.
