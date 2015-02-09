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

      it 'should disable cluster allocation' do
        @es_client = Elasticsearch.new({ host: 'localhost', port: 9200 }, true)

        @mock_http = Minitest::Mock.new
        @mock_http.expect(:start, 200)

        Net::HTTP.stub :new, @mock_http do
          @es_client.disable_cluster_routing_allocation.must_equal 200
        end
      end

      it 'should enable cluster allocation' do
        @es_client = Elasticsearch.new({ host: 'localhost', port: 9200 }, true)

        @mock_http = Minitest::Mock.new
        @mock_http.expect(:start, 200)

        Net::HTTP.stub :new, @mock_http do
          @es_client.enable_cluster_routing_allocation.must_equal 200
        end
      end
    end
  end
end
