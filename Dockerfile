FROM hexpm/elixir:1.13.4-erlang-25.0-ubuntu-focal-20211006

# Install debian packages
RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools postgresql-client
RUN apt-get install --yes git

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app