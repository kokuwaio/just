# https://just.systems/man/en/

[private]
@default:
    just --list --unsorted

# Run linter.
@lint:
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/just:1.46.0
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/shellcheck:v0.11.0
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/hadolint:v2.14.0
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/yamllint:v1.38.0
    docker run --rm --read-only --volume=$PWD:$PWD:rw --workdir=$PWD kokuwaio/markdownlint:0.47.0 --fix
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/renovate-config-validator:43
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD woodpeckerci/woodpecker-cli lint

# Build image with local docker daemon.
@build:
    docker buildx build . --platform=linux/amd64,linux/arm64

# Inspect image layers with `dive`.
@dive TARGET="":
    dive build . --target={{ TARGET }}

# Test created image.
@test:
    docker build . --tag=kokuwaio/just:dev
    docker run --rm --read-only --volume=$PWD/.justfile:$PWD/.justfile:ro         --workdir=$PWD kokuwaio/just:dev
    docker run --rm --read-only                                                   --workdir=$PWD kokuwaio/just:dev && echo 🌋 Should Fail && exit 1 || echo ✅ Failed correctly
    docker run --rm --read-only --volume=$PWD/.justfile.invalid:$PWD/.justfile:ro --workdir=$PWD kokuwaio/just:dev && echo 🌋 Should Fail && exit 1 || echo ✅ Failed correctly
    docker run --rm --read-only --volume=$PWD/.justfile.format:$PWD/.justfile:ro  --workdir=$PWD kokuwaio/just:dev && echo 🌋 Should Fail && exit 1 || echo ✅ Failed correctly
