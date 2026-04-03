# Arr-stack

This repo contains the docker-compose and various scripts that I use to deploy my local arr-stack.

# Set up instructions

Run the `setup.sh` script and it will create all the needed directories for the arr-stack to deploy.
Make changes to the `docker-compose.yml` file to adjust the containers that will be deployed.

# Features and Services

TBD

# "Roadmap"

It's not *technically* a roadmap, but the term does fit well enough.
I know most people are fairly happy with just getting the thing deployed and using it, but I like to tinker. So here is where I'll be documenting things I want to add to the stack that I think could improve the QoL of use here.

## Workflow Improvements

- [x] Use [Kapitan](https://github.com/kapicorp/kapitan) to generate a docker compose file from multiple settings files
- [x] Split out each docker container into it's own file for better customization and maintanence
- [ ] Add features/services description to README (potentially auto-generated?)
- [ ] Auto-update containers when available (not using renovate)

## Additional Services

- [ ] Implement [bookshelf](https://github.com/pennydreadful/bookshelf/pkgs/container/bookshelf)
- [ ] Implement [SuggestArr](https://github.com/giuseppe99barchetta/SuggestArr)
- [ ] Implement [reiverr](https://github.com/aleksilassila/reiverr?tab=readme-ov-file)
- [ ] Implement [seerr](https://github.com/seerr-team/seerr)

## General Improvements

- [ ] Implement some form of disk space monitoring/categorization
- [ ] Implement some form of log aggregation
- [ ] Implement some form of container performance monitoring/alerting
- [ ] Validate hardlinks are working correctly
- [ ] Find cleaning script for my usecase
