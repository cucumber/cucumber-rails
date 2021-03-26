# How to release a new version of cucumber-rails

NB: This can only be done by authors who have access to the secrets repo.
If you require access to this speak to a member of the core team.

```shell
$ git checkout master

```



// Notes

Start the docker container with secrets
Update dependencies
Update changelog
Release packages
The release commands will be done from a terminal session in the Docker container. This ensures a consistent release environment.

Get the secrets
In order to publish packages several secrets are required. Members of the core team can install keybase and join the cucumberbdd team to access these secrets.

Start the Cucumber docker container
All commands should be made from the Cucumber docker container. Start it:

make docker-run-with-secrets
You're now ready to make a release.