# PHPdock

Docker starter for PHP projects

## 101

```shell script
$ ln --symbolic ./.examples/.env .
$ ln --symbolic ./.examples/docker-compose.override.yml .

$ docker-compose build
$ docker-compose up --detach

$ docker-compose exec app composer install
$ docker-compose exec app chown --recursive 1000:1000 .

$ docker-compose exec app bash
```

Go to: http://127.0.0.1:38080
