# not-a-vpn
Bash script to manage a not-a-vpn via sshuttle

## Setting variables
`USER` SSH username on the remote host

`HOST` remote SSH host

`POST` remote SSH port

`SUBNETS` subnets to route through the not-a-vpn. 0/0 will route all traffic


`OPTIONS` options for the sshuttle command

`OPTIONS_ALT` alternative options for the sshuttle command, for example to also route traffic from connected machines using `-l 0.0.0.0:0`

The script creates the `REMOTE` variable automatically to pass to the `sshuttle -r` switch

## Modes
### not-a-vpn.sh start
Start sshuttle in deamon mode, using the options in `OPTIONS`

### not-a-vpn.sh start alt
Start sshuttle in deamon mode, using the alternative options in `OPTIONS_ALT`

### not-a-vpn.sh verbose
Start sshuttle in verbose (`-vv`) mode, using the options in `OPTIONS`

### not-a-vpn.sh verbose alt
Start sshuttle in verbose (`-vv`) mode, using the alternative options in `OPTIONS_ALT`

### not-a-vpn.sh check
Check if the sshuttle deamon is running by finding its PID from `sshuttle.pid`

### not-a-vpn.sh stop
Stop the sshuttle deamon by finding its PID from `sshuttle.pid` and killing the process.


