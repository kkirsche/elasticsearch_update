[![Build Status](https://travis-ci.org/kkirsche/elasticsearch_update.svg?branch=master)](https://travis-ci.org/kkirsche/elasticsearch_update) [![Code Climate](https://codeclimate.com/github/kkirsche/elasticsearch_update/badges/gpa.svg)](https://codeclimate.com/github/kkirsche/elasticsearch_update) [![Test Coverage](https://codeclimate.com/github/kkirsche/elasticsearch_update/badges/coverage.svg)](https://codeclimate.com/github/kkirsche/elasticsearch_update) [![Dependency Status](https://gemnasium.com/kkirsche/elasticsearch_update.svg)](https://gemnasium.com/kkirsche/elasticsearch_update) [![Gem Version](https://badge.fury.io/rb/elasticsearch_update.svg)](http://badge.fury.io/rb/elasticsearch_update)
# Elasticsearch Update

This gem allows users to easily update their 1.0 and later Elasticsearch instance on the local machine from one of the following formats.

1. .zip (in progress)
2. .tar.gz (in progress)
3. .deb (complete)
4. .rpm (complete)

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

After installing the gem, execute the `elasticsearch_update` command and it will walk you through the upgrade process.

For development, execute `bundle exec bin/elasticsearch_update` and the gem will walk you through the upgrade process.

For testing, execute `rake test` and the gem will run the local tests.

## Versioning

For transparency into my release cycle and in striving to maintain backward compatibility, Elasticsearch Update is maintained under [the Semantic Versioning guidelines](http://semver.org/). Sometimes I screw up, but I'll adhere to those rules whenever possible.

## Contributing

1. Fork it ( https://github.com/kkirsche/elasticsearch_update/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Warning
Before performing an upgrade, it’s a good idea to back up the data on your system. This will allow you to roll back in the event of a problem with the upgrade. The upgrades sometimes include upgrades to the Lucene libraries used by Elasticsearch to access the index files, and after an index file has been updated to work with a new version of Lucene, it may not be accessible to the versions of Lucene present in earlier Elasticsearch releases. I am not responsible for any loss of data, damaged data, etc. caused by use of this gem.