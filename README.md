# PHPdock

Docker starter for PHP projects

## Requirements

```shell
$ docker --version
Docker version 20.10.13, build a224086

$ kubectl version --client --short
Client Version: v1.22.5

$ skaffold version
v1.37.0
```

## Development

```shell
$ docker context use desktop-linux
$ kubectl config use-context docker-desktop

$ skaffold dev
$ kubectl --context=docker-desktop --namespace=default exec app -it -- bash
```

## Deployment

```shell
$
```
