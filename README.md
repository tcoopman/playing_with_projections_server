
# Quizzy

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
[![Stories in Ready](https://badge.waffle.io/michelgrootjans/playing_with_projections.svg?label=ready&title=Ready)](http://waffle.io/michelgrootjans/playing_with_projections)

# Playing with Projections
Preparation of a workshop

## Server

The server implementation is a [phoenix](http://www.phoenixframework.org/) app.

background info (to create the project): `mix phoenix.new . --no-brunch --no-ecto --no-html --app quizzy`

To prepare the server:
```bash
cd server/elixir
mix deps.get
```

To run the server:

```bash
mix phoenix.server
```

to run the tests:
```bash
mix test
```
to run the test continuously:
```bash
mix test.watch
```

### api

`/stream/:id`

`/stream/0` is used to test the clients

### Heroku

url: https://playing-with-projections.herokuapp.com 
installation followed: http://www.phoenixframework.org/docs/heroku


## Generator

To prepare the generator:
```
cd generator
bundle install
```

To generate some data
```
ruby generate.rb
```

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## Heroku

https://playing-with-projections.herokuapp.com/