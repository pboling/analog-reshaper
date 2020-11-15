# Analog::Reshaper

## WARNING: This is an unfinished proof of concept.

Not production ready, and perhaps not even executable.  Half-baked, at best.

| Project                 |  AnonymousActiveRecord |
|------------------------ | ----------------------- |
| gem name                |  [analog-reshaper](https://rubygems.org/gems/analog-reshaper) |
| license                 |  [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT) |
| download rank           |  [![Downloads Today](https://img.shields.io/gem/rd/analog-reshaper.svg)](https://github.com/pboling/analog-reshaper) |
| version                 |  [![Version](https://img.shields.io/gem/v/analog-reshaper.svg)](https://rubygems.org/gems/analog-reshaper) |
| dependencies            |  [![Depfu](https://badges.depfu.com/badges/272ce0df3bc6df5cbea9354e2c3b65af/count.svg)](https://depfu.com/github/pboling/analog-reshaper?project_id=5614) |
| continuous integration  |  [![Build Status](https://travis-ci.org/pboling/analog-reshaper.svg?branch=master)](https://travis-ci.org/pboling/analog-reshaper) |
| test coverage           |  [![Test Coverage](https://api.codeclimate.com/v1/badges/ca0a12604ecc19f5e76d/test_coverage)](https://codeclimate.com/github/pboling/analog-reshaper/test_coverage) |
| maintainability         |  [![Maintainability](https://api.codeclimate.com/v1/badges/ca0a12604ecc19f5e76d/maintainability)](https://codeclimate.com/github/pboling/analog-reshaper/maintainability) |
| code triage             |  [![Open Source Helpers](https://www.codetriage.com/pboling/analog-reshaper/badges/users.svg)](https://www.codetriage.com/pboling/analog-reshaper) |
| homepage                |  [on Github.com][homepage], [on Railsbling.com][blogpage] |
| documentation           |  [on RDoc.info][documentation] |
| Spread ~♡ⓛⓞⓥⓔ♡~      |  [🌏](https://about.me/peter.boling), [👼](https://angel.co/peter-boling), [:shipit:](http://coderwall.com/pboling), [![Tweet Peter](https://img.shields.io/twitter/follow/galtzo.svg?style=social&label=Follow)](http://twitter.com/galtzo), [🌹](https://nationalprogressiveparty.org) |

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'analog-reshaper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install analog-reshaper

## Configuration

You probably won't need to require anything, but if you do:

```ruby
require 'analog/reshaper'
```

## Usage

The spec suite for this gem has some examples of usage.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Authors

[Peter H. Boling][peterboling] of [Rails Bling][railsbling] is the author.

## Contributors

See the [Network View](https://github.com/pboling/analog-reshaper/network) and the [CHANGELOG](https://github.com/pboling/analog-reshaper/blob/master/CHANGELOG.md)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
6. Create new Pull Request

Bug reports and pull requests are welcome on GitHub at https://github.com/pboling/anonymous_active_record. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the AnonymousActiveRecord project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pboling/anonymous_active_record/blob/master/CODE_OF_CONDUCT.md).

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver].
Violations of this scheme should be reported as bugs. Specifically,
if a minor or patch version is released that breaks backward
compatibility, a new version should be immediately released that
restores compatibility. Breaking changes to the public API will
only be introduced with new major versions.

As a result of this policy, you can (and should) specify a
dependency on this gem using the [Pessimistic Version Constraint][pvc] with two digits of precision.

For example in a `Gemfile`:

    gem 'analog-reshaper', '~> 1.0', group: :test

or in a `gemspec`

    spec.add_development_dependency 'analog-reshaper', '~> 1.0'

## Legal

* MIT License - See [LICENSE][license] file in this project [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT) 

* Copyright (c) 2018 [Peter H. Boling][peterboling] of [Rails Bling][railsbling]

[semver]: http://semver.org/
[pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[documentation]: http://rdoc.info/github/pboling/analog-reshaper/frames
[homepage]: https://github.com/pboling/analog-reshaper
[blogpage]: http://www.railsbling.com/tags/analog-reshaper/
[license]: LICENSE
[railsbling]: http://www.railsbling.com
[peterboling]: https://about.me/peter.boling
[refugees]: https://www.crowdrise.com/helprefugeeswithhopefortomorrowliberia/fundraiser/peterboling
[gplus]: https://plus.google.com/+PeterBoling/posts
[topcoder]: https://www.topcoder.com/members/pboling/
[angellist]: https://angel.co/peter-boling
[coderwall]: http://coderwall.com/pboling
[twitter]: http://twitter.com/galtzo
