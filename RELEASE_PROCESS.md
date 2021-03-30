# How to release a new version of cucumber-rails

NB: This can only be done by authors who have access to the secrets repo.
If you require access to this speak to a member of the core team.

Before doing these tasks. Ensure you have done the following

- Check the changelog is up to date
- Check a release branch has been made and merged with the new version number

```shell
# Sync up the secrets repo and local master. Use docker container with auth
$ make release
# Build the latest version of the gem. Push the gem to rubygems.org. Remove any generated files
$ make cut_and_push_gem
```
