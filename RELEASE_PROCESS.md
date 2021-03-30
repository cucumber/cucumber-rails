# How to release a new version of cucumber-rails

NB: This can only be done by authors who have access to the secrets repo.
If you require access to this speak to a member of the core team.

Before doing these tasks. Ensure you have done the following

- Check the changelog is up to date
- Check a release branch has been made and merged with the new version number

```shell
# This task will do the following
# - Sync up the secrets repo / local master.
# - Use docker container with authentication for pushing to rubygems
# - Build and push the latest version of the gem 
# - Cleanup the leftover gem
$ make release
```
