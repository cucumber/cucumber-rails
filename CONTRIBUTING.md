## About to create a new Github Issue?

We appreciate that. But before you do, please learn our basic rules:

* This is not a support forum. If you have a question, please go to [The Cukes Google Group](http://groups.google.com/group/cukes).
* Do you have an idea for a new feature? Then don't expect it to be implemented unless you or someone else sends a [pull request](https://help.github.com/articles/using-pull-requests). You might be better to start a discussion on [the google group](http://groups.google.com/group/cukes).
* Reporting a bug? Please tell us:
  * which version of Cucumber you're using
  * which version of Ruby you're using
  * which version of Rails you're using (include all associated gems)
  * How to reproduce it. Bugs with a failing test in a [pull request](https://help.github.com/articles/using-pull-requests) get fixed much quicker. Some bugs may never be fixed.
* Want to paste some code or output? Put ``` on a line above and below your code/output. See [GFM](https://help.github.com/articles/github-flavored-markdown)'s *Fenced Code Blocks* for details.
* We love [pull requests](https://help.github.com/articles/using-pull-requests). But if you don't have a test to go with it we probably won't merge it.

# Contributing to cucumber-rails

This document is a guide for those maintaining Cucumber-Rails, and others who would like to submit patches.

## Note on Patches/Pull Requests

* Fork the project. Make a branch for your change.
* Make your feature addition or bug fix.
* Make sure your patch is well covered by tests. We don't accept changes to `cucumber-rails` that aren't tested.
* Please do not change the Rakefile, version, or CHANGELOG.
* Send us a pull request.

## Running tests

    gem install bundler
    bundle install
    bin/install_geckodriver.sh
    bin/install_webpacker.sh
    # Then to run tests on one version-specific Gemfile (e.g. gemfiles/rails_6_0.gemfile), run
    bundle exec appraisal rails_6_0 rake test
    # Or run tests across the full supported stack. Note that because we support many versions. This takes 5-10 minutes
    bundle exec rake appraisal

## Updating Appraisal gems / dependencies of cucumber-rails

To remove and rebuild the different gemfiles (for example, to update a rails version or its
dependencies), use the following:

    [bundle exec] appraisal update

If you've changed versions of the dependencies, you may find it helpful to forcefully clean
each appraisal's gem lock file in `gemfiles/`. You can do this using:

    [bundle exec] rake clean
    
## Release Process

* Make sure `CHANGELOG.md` is updated with the upcoming version number, and has entries for all fixes.
* No need to add a new version header at this point - this should be done when a new release is made, later.
* Make sure you have up-to-date and clean copy of `cucumber/cucumber.github.com.git` at the same level as cucumber repo.

Now release it

    bundle update
    bundle exec rake
    git commit -m "Release X.Y.Z"
    rake release
