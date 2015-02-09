require "codeclimate-test-reporter"
require_relative('../bin/update.rb')
require 'minitest/autorun'
CodeClimate::TestReporter.start
# ElasticsearchUpdate houses all tests for the
# Elasticsearch Updater and all associated library files
module ElasticsearchUpdate
end
