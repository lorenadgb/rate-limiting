# README

Rate-limiting module that stops a particular requestor from making too many http requests within a particular period of time (one hour).

This solution implements a Rack middleware (RateLimit - Fixed Window) to process inbound responses.

## Dependencies

To run this project you need to have:

* Ruby 2.5.8 - You can use [RVM](http://rvm.io)
* Rails 6.0
* Redis 3.3

## Setup the project

1. `$ git clone git@github.com:lorenadgb/rate-limiting.git` - Clone the project
2. `$ cd rate-limiting` - Go into the project folder

## Getting started

The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/).

```console
$ docker-compose build
$ docker-compose up
```

## Running tests

`$ rake spec`

## Endpoints

#### GET /api/v1/home

`Example: http://localhost:3000/api/v1/home`

```
curl localhost:3000/api/v1/home
``` 

```
for ((i=0;i<=100;i++)); do   curl -v --header "Connection: keep-alive" "localhost:3000/api/v1/home"; done
```
