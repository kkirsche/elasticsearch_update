[![Build Status](https://travis-ci.org/kkirsche/elasticsearch_update.svg?branch=master)](https://travis-ci.org/kkirsche/elasticsearch_update) [![Code Climate](https://codeclimate.com/github/kkirsche/elasticsearch_update/badges/gpa.svg)](https://codeclimate.com/github/kkirsche/elasticsearch_update) [![Test Coverage](https://codeclimate.com/github/kkirsche/elasticsearch_update/badges/coverage.svg)](https://codeclimate.com/github/kkirsche/elasticsearch_update)
# Elasticsearch Update v0.0.1

This gem allows users to easily update their 1.0 and later Elasticsearch instance on the local machine from one of the following formats.

1. .zip
2. .tar.gz
3. .deb
4. .rpm

Installation follows the upgrade recommendations of Elasticsearch found [here](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-upgrade.html).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'elasticsearch_update'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticsearch_update

## Usage

Begin the binary `update.rb` file and it will walk you through the upgrade process.

## Versioning

For transparency into my release cycle and in striving to maintain backward compatibility, Elasticsearch Update is maintained under [the Semantic Versioning guidelines](http://semver.org/). Sometimes I screw up, but I'll adhere to those rules whenever possible.

## Contributing

1. Fork it ( https://github.com/kkirsche/elasticsearch_update/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
