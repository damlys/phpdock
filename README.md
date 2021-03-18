# PHPdock

Docker starter for PHP projects

## 101

```shell
$ ln -s ./.examples/docker-compose.override.yml .

$ docker-compose build
$ docker-compose up --detach

$ docker-compose exec workspace bash -ce "
    composer install
    composer run-script build
    chown -R $(id -u):$(id -g) .
    composer run-script unit-tests
    composer run-script http-api-tests
  "

$ docker-compose exec workspace bash

$ docker-compose down --remove-orphans
```

Go to [http://127.0.0.1:8080](http://127.0.0.1:8080)
