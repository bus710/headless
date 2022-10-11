# The delay of cups daemon during poweroff

To reduce power off time of cups-browsed,

Run this command in the terminal 

```
sudo systemctl edit cups-browsed.service
```

And put these lines in the file

```
[Service] 
TimeoutStopSec=10
```
