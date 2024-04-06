FROM hexpm/elixir:1.16.2-erlang-26.1.2-alpine-3.16.9

RUN apk --update add postgresql-client
RUN apk add git
RUN apk add bash

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app
