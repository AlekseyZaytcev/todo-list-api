[![Build Status](https://travis-ci.com/AlekseyZaytcev/todo-list-api.svg?branch=develop)](https://travis-ci.com/AlekseyZaytcev/todo-list-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/d4b950090969e9c2a773/maintainability)](https://codeclimate.com/github/AlekseyZaytcev/todo-list-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d4b950090969e9c2a773/test_coverage)](https://codeclimate.com/github/AlekseyZaytcev/todo-list-api/test_coverage)
![Website](https://img.shields.io/website?url=https%3A%2F%2Ftodolist-endpoints.herokuapp.com%2Fapi%2Fdocs%2Fv1%2Fdocumentation.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

# TODO-List Rails API

The idea of the project is a simple tool for productivity improvement. It let the user an ability to easy manage and control his own projects and tasks.
A Rails API application that provides endpoints for management next entities:
User > Projects > Tasks > Comments

#### Hosted on Heroku:
https://todolist-endpoints.herokuapp.com

[documentation](https://todolist-endpoints.herokuapp.com/api/docs/v1/documentation.html)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

#### You need:

- Ruby 2.6.3

- Bundler 2.0.2

- Aglio for documentation

- Postgresql

### Installing

#### Install Ruby:

```bash
$ rvm install 2.6.3
```

#### Install latest Bundler:

```bash
$ gem install bundler
```

#### Install Aglio:

```bash
$ npm i -g aglio
```

#### Install gem dependencies:

```bash
$ bundle install
```

#### Setup needed ENV variables:

Generate secret key for Devise JWT:

```bash
rails secret
```

Execute:

```bash
$ rails credentials:edit --environment development
```

```yml
DEVISE_JWT_SECRET_KEY: long_devise_secret_key

db:
  host: localhost
  port: 5432
  username: postgres
  password: postgres
```

Repeat this step for test environment.

#### Install Postgresql or run it with Docker:

```bash
$ docker run -it -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=todo_list_api_development --name todo_list_db -p 5432:5432 postgres
```

#### Run Docker container:

```bash
$ docker start todo_list_db
```

#### Generate documentation:

```bash
$ rails api:doc:open
```

## Running the tests

#### Execute:

```bash
$ rspec
```

## Start Rails server

```bash
$ rails s
```

## Built With

* [Rails](https://rubyonrails.org/) - The web framework used
* [Netflix/Fast JSON API](https://github.com/Netflix/fast_jsonapi) - JSON API serializer

## Authors

* **Aleksey Zaitcev** - *Initial work* - [AlekseyZaitcev](https://github.com/AlekseyZaitcev)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Hints

* Just code! And may the force be with you :D

