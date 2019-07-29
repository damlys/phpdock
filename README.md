PHPdock
===

Docker starter for PHP

## Requirements

Docker client and server

```
$ docker version 
Client:
 Version:           18.09.5
 ...

Server: Docker Engine - Community
 Engine:
  Version:          18.09.5
  ...
```

Working Docker Engine

```
$ docker container run --rm hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

...
```

Docker Compose tool

```
$ docker-compose version --short 
1.23.2
```

*Note:*
Docker Compose v2 manifests are designed to work
with standalone Docker Engine and do not
require Docker Swarm mode

```
$ docker info --format="{{.Swarm.LocalNodeState}}"
inactive
```
