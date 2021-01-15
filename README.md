# PHPdock

Docker starter for PHP projects

## 101

```shell script
$ ln --symbolic ./.examples/.env .
$ ln --symbolic ./.examples/docker-compose.override.yml .

$ docker-compose build
$ docker-compose up --detach

$ docker-compose exec app bash -ce "
    composer install
    chown --recursive 1000:1000 .
    composer run-script unit-tests
    composer run-script http-api-tests
  "

$ docker-compose exec app bash

$ docker-compose down --volumes
```

Go to: [http://127.0.0.1:38080](http://127.0.0.1:38080)
