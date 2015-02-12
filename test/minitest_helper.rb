require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'minitest/autorun'
require 'elasticsearch_update'

# ElasticsearchUpdate houses all tests for the
# Elasticsearch Updater and all associated library files
module ElasticsearchUpdate
end
