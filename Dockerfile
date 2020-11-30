FROM hexpm/elixir:1.11.1-erlang-23.1.1-ubuntu-focal-20200703

# Install debian packages
RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools postgresql-client

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app