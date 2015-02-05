require 'minitest_helper'

module TestElasticsearchUpdate
  # The TestDownloader class below tests the Downloader class from the library
  class TestDownloader < Minitest::Test
    describe 'Downloader', 'Used to download and verify Elasticsearch file' do
      it 'should initialize without errors.' do
        @client = ElasticsearchUpdate::Downloader.new

        assert_kind_of ElasticsearchUpdate::Downloader, @client
      end
    end
  end
end