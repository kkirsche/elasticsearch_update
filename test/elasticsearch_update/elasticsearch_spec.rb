require 'minitest_helper'

module ElasticsearchUpdate
  class TestElasticsearch < Elasticsearch
    def system(command)
      command
    end
  end
  # The TestInstaller class below tests the Downloader class from the library
  class TestElasticsearch
    describe 'Elasticsearch', 'Used to interact with Elasticsearch' do
      it 'should initialize without errors' do
        es_client = TestElasticsearch.new
        assert_kind_of Elasticsearch, es_client

        es_client.es_port.must_equal 9200
        es_client.es_host.must_equal 'localhost'
      end

      it 'should disable cluster allocation' do
        es_client = TestElasticsearch.new({ host: 'localhost', port: 9200 }, true)

        mock_http = Minitest::Mock.new
        mock_http.expect(:start, 200)

        Net::HTTP.stub :new, mock_http do
          es_client.cluster_routing_allocation('none').must_equal 200
        end
      end

      it 'should enable cluster allocation' do
        es_client = TestElasticsearch.new({ host: 'localhost', port: 9200 }, true)

        mock_http = Minitest::Mock.new
        mock_http.expect(:start, 200)

        Net::HTTP.stub :new, mock_http do
          es_client.cluster_routing_allocation('all').must_equal 200
        end
      end

      it 'should shutdown the local node' do
        es_client = TestElasticsearch.new({ host: 'localhost', port: 9200 }, true)

        Net::HTTP.stub :post_form, 200 do
          es_client.shutdown_local_node.must_equal 200
        end
      end

      it 'start elasticsearch service' do
        es_client = TestElasticsearch.new({ host: 'localhost', port: 9200 }, true)

        result = es_client.start_elasticsearch_service('test')

        result.must_equal 'echo test | sudo -S service elasticsearch start'
      end

      it 'start elasticsearch binary' do
        es_client = TestElasticsearch.new({ host: 'localhost', port: 9200 }, true)

        result = es_client.start_elasticsearch_binary('/path/to/elasticsearch/')

        result.must_equal '/path/to/elasticsearch/bin/elasticsearch'
      end

      it 'start elasticsearch service from the deb extension' do
        mock = Minitest::Mock.new
        mock.expect(:extension, '.deb')
        mock.expect(:sudo_password, 'test')

        es_client = TestElasticsearch.new({ host: 'localhost', port: 9200 }, true)

        result = es_client.start_elasticsearch(mock)

        result.must_equal 'echo test | sudo -S service elasticsearch start'
      end

      it 'start elasticsearch service from the rpm extension' do
        mock = Minitest::Mock.new
        mock.expect(:extension, '.rpm')
        mock.expect(:sudo_password, 'test')

        es_client = TestElasticsearch.new({ host: 'localhost', port: 9200 }, true)

        result = es_client.start_elasticsearch(mock)

        result.must_equal 'echo test | sudo -S service elasticsearch start'
      end
    end
  end
end
