## Quick Intro

This project is a pg10/centos-7 version of vagrant-postgres9.6 (also centos 7)
Please see https://github.com/dgapitts/vagrant-postgres9.6 for more details

### Extra manual steps for root sar crontab 

```
# run system activity accounting tool every 1 minutes
*/1 * * * * /usr/lib64/sa/sa1 1 1
# generate a daily summary of process accounting at 23:53
53 23 * * * /usr/lib64/sa/sa2 -A
```

