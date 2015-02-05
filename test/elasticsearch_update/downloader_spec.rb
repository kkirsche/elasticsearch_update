require 'minitest_helper'

module TestElasticsearchUpdate
  # The TestDownloader class below tests the Downloader class from the library
  class TestDownloader < Minitest::Test
    describe 'Downloader', 'Used to download and verify Elasticsearch file' do
      def setup
        hash =
        {
          base_url: 'download.elasticsearch.org',
          version: '1.4.2',
          extension: '.deb'
        }

        @downloader = ElasticsearchUpdate::Downloader.new(hash)
      end

      it 'should initialize and correctly assign values.' do
        assert_kind_of ElasticsearchUpdate::Downloader, @downloader

        @downloader.base.must_equal 'download.elasticsearch.org'
        @downloader.extension.must_equal '.deb'
        @downloader.version.must_equal '1.4.2'
        @downloader.download_url.must_equal 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb'
        @downloader.verify_url.must_equal 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb.sha1.txt'
      end

      it 'should retrieve the correct SHA1 value from Elasticsearch\'s website' do
        @downloader.download_remote_sha1.must_equal 'd377e39343e5cc277104beee349e1578dc50f7f8'
      end

      it 'creates a tempfile to store the Elasticsearch deb file' do
        assert_kind_of Tempfile, @downloader.download_file(true)
      end
    end
  end
end