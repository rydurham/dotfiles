
Fix legacy gpg keyring notice from apt-key:

https://colekcolek.com/2022/07/20/ubuntu-how-to-fix-key-is-stored-in-legacy-trusted-gpg-keyring-etc-apt-trusted-gpg/

To resolve this issue, we have to export GPG key from deprecated keyring.


## Get list of existing keys


```sh
$ sudo apt-key list
Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).
/etc/apt/trusted.gpg
--------------------
pub   rsa4096 2017-05-08 [SCEA]
      1EDD E2CD FC02 5D17 F6DA  9EC0 ADAE 6AD2 8A8F 901A
uid           [ unknown] Sublime HQ Pty Ltd <support@sublimetext.com>
sub   rsa4096 2017-05-08 [S]

pub   rsa2048 2015-10-28 [SC]
      BC52 8686 B50D 79E3 39D3  721C EB3E 94AD BE12 29CF
uid           [ unknown] Microsoft (Release signing) <gpgsecurity@microsoft.com>
```

## Export the key

```sh
$ sudo apt-key export BE1229CF | sudo gpg --dearmour -o /usr/share/keyrings/microsoft.gpg
```

Key BE1229CF is the last 8 digit taken from key list.

The following message will appear:

```sh
Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).
```

Now we can update our apt source file for the repository (e.g., /etc/apt/sources.list.d/microsoft.list), adding a signed-by tag:

```
deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge/ stable main
```

## Update apt to make sure the error message is gone

```sh
$ sudo apt update
...
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
All packages are up-to-date.
```

## Remove the original signature

```sh
sudo apt-key del BE1229CF
```

This can be done with each of the warning messages. Once done, apt will no longer complain.
