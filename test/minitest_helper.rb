require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require_relative('../bin/update.rb')
require 'minitest/autorun'

# ElasticsearchUpdate houses all tests for the
# Elasticsearch Updater and all associated library files
module ElasticsearchUpdate
end
