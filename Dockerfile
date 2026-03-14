FROM hexpm/elixir-arm64:1.19.5-erlang-28.4.1-alpine-3.20.9

RUN apk --update add postgresql-client
RUN apk add git
RUN apk add bash

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app
