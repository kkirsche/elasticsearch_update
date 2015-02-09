require 'minitest_helper'

module ElasticsearchUpdate
  # The TestInstaller class below tests the Downloader class from the library
  class TestElasticsearch < Minitest::Test
    describe 'Elasticsearch', 'Used to interact with Elasticsearch' do

      it 'should initialize without errors' do
        @es_client = Elasticsearch.new
        assert_kind_of Elasticsearch, @es_client

        @es_client.es_port.must_equal 9200
        @es_client.es_host.must_equal 'localhost'
      end
    end
  end
end
