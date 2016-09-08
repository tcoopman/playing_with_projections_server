# Playing with Projections

[![Build Status](https://travis-ci.org/tcoopman/playing_with_projections_server.svg?branch=master)](https://travis-ci.org/tcoopman/playing_with_projections_server)

The latest version of the server can be found on: https://playing-with-projections.herokuapp.com 

This is the server for the workshop playing with projections: 

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
[![Stories in Ready](https://badge.waffle.io/michelgrootjans/playing_with_projections.svg?label=ready&title=Ready)](http://waffle.io/michelgrootjans/playing_with_projections)

Preparation of a workshop

## api

`/stream/:id`

`/stream/0` is used to test the clients
`/stream/1` is the default generated stream

## Heroku

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

## Testing

run `mix test`