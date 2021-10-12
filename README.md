# PHPdock

Docker starter for PHP projects

## 101

```shell
$ ln -s ./.devcontainer/docker-compose.override.yml .
$ docker-compose build
$ docker-compose up --detach
$ docker-compose exec app bash -ce "
    composer install
    composer run-script build
    chown -R $(id -u):$(id -g) .
    composer run-script unit-tests
    composer run-script http-api-tests
  "
$ docker-compose exec app bash
```

Go to [http://127.0.0.1:38080](http://127.0.0.1:38080)

```shell
$ docker-compose down --remove-orphans
```
