# Just WoodpeckerCI Plugin

[![pulls](https://img.shields.io/docker/pulls/kokuwaio/just)](https://hub.docker.com/r/kokuwaio/just)
[![size](https://img.shields.io/docker/image-size/kokuwaio/just)](https://hub.docker.com/r/kokuwaio/just)
[![dockerfile](https://img.shields.io/badge/source-Dockerfile%20-blue)](https://git.kokuwa.io/woodpecker/just/src/branch/main/Dockerfile)
[![license](https://img.shields.io/badge/License-EUPL%201.2-blue)](https://git.kokuwa.io/woodpecker/just/src/branch/main/LICENSE)
[![prs](https://img.shields.io/gitea/pull-requests/open/woodpecker/just?gitea_url=https%3A%2F%2Fgit.kokuwa.io)](https://git.kokuwa.io/woodpecker/just/pulls)
[![issues](https://img.shields.io/gitea/issues/open/woodpecker/just?gitea_url=https%3A%2F%2Fgit.kokuwa.io)](https://git.kokuwa.io/woodpecker/just/issues)

A [WoodpeckerCI](https://woodpecker-ci.org) plugin for [just](https://github.com/casey/just) to lint justfiles.
Also usable with Gitlab, Github or locally, see examples for usage.

## Features

- searches for justfiles recursive
- runnable with local docker daemon

## Example

Woodpecker:

```yaml
steps:
  just:
    depends_on: []
    image: kokuwaio/just:1.44.0
    when:
      event: pull_request
      path: [.justfile]
```

Gitlab: (using script is needed because of <https://gitlab.com/gitlab-org/gitlab/-/issues/19717>)

```yaml
just:
  needs: []
  stage: lint
  image:
    name: kokuwaio/just:1.44.0
    entrypoint: [""]
  script: [/usr/bin/entrypoint.sh]
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      changes: ["**/.justfile"]
```

CLI:

```bash
docker run --rm --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/just:1.44.0
```

## Alternatives

| Image                                                   | Comment           |                                                            amd64                                                            |                                                            arm64                                                            |
| ------------------------------------------------------- | ----------------- | :-------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------: |
| [kokuwaio/just](https://hub.docker.com/r/kokuwaio/just) | Woodpecker plugin | [![size](https://img.shields.io/docker/image-size/kokuwaio/just?arch=amd64&label=)](https://hub.docker.com/r/kokuwaio/just) | [![size](https://img.shields.io/docker/image-size/kokuwaio/just?arch=arm64&label=)](https://hub.docker.com/r/kokuwaio/just) |
