FROM hexpm/elixir:1.12.1-erlang-24.0.2-ubuntu-focal-20210325

# Install debian packages
RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools postgresql-client
RUN apt-get install --yes git

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app