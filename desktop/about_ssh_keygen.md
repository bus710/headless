
Don't put any phrase to avoid being asked.

```
$ ssh-keygen -t rsa -b 2048 -v
$ ssh-copy-id -i .ssh/test.pub pi@192.168.1.76 -p 2222
$ ssh -p 2222 pi@192.168.1.76
```

