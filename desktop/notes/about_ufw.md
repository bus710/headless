# UFW rules in general

To clear all:
```sh
$ sudo ufw reset
```

```sh
$ sudo ufw logging on # for /usr/log/ufw*

$ sudo ufw allow 2222
$ sudo ufw allow 443
$ sudo ufw allow 123
$ sudo ufw allow 80
$ sudo ufw allow 53
$ sudo ufw allow git
$ sudo ufw allow in http
$ sudo ufw allow out http
$ sudo ufw allow in https
$ sudo ufw allow out https

$ sudo ufw default deny incoming
$ sudo ufw default allow outgoing

$ sudo ufw status verbose # or numbered
$ sudo ufw delete N

$ sudo ufw enable

$ sudo ufw reload # if iptables files are edited
```
