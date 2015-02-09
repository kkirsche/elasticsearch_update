require 'minitest_helper'

module ElasticsearchUpdate
  class TestDownloader < Downloader
    def open(_url, &b)
      b.call StringIO.new "d377e39343e5cc277104beee349e1578dc50f7f8  elasticsearch-1.4.2.deb"
    end
  end

  # The TestDownloader class below tests the Downloader class from the library
  class TestDownloader < Minitest::Test
    describe 'Downloader', 'Used to download and verify Elasticsearch file' do

      it 'should initialize and correctly assign values.' do
        hash =
        {
          base_url: 'download.elasticsearch.org',
          version: '1.4.2',
          extension: '.deb'
        }

        @downloader = ElasticsearchUpdate::Downloader.new(hash, true)
        assert_kind_of ElasticsearchUpdate::Downloader, @downloader

        @downloader.base.must_equal 'download.elasticsearch.org'
        @downloader.extension.must_equal '.deb'
        @downloader.version.must_equal '1.4.2'
        @downloader.download_url.must_equal 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb'
        @downloader.verify_url.must_equal 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb.sha1.txt'
      end

      it 'should retrieve the correct SHA1 value from Elasticsearch\'s website' do
        hash =
        {
          base_url: 'download.elasticsearch.org',
          version: '1.4.2',
          extension: '.deb'
        }

        @mock_file = Minitest::Mock.new
        @mock_file.expect(:read, 'd377e39343e5cc277104beee349e1578dc50f7f8  elasticsearch-1.4.2.deb')

        Kernel.stub :open, nil, @mock_file do
          @downloader = TestDownloader.new(hash, true)
          @downloader.download_remote_sha1.must_equal 'd377e39343e5cc277104beee349e1578dc50f7f8'
        end
      end

      it "should retrieve the verify the file's SHA1 value against Elasticsearch's" do
        hash =
        {
          base_url: 'download.elasticsearch.org',
          version: '1.4.2',
          extension: '.deb'
        }

        @mock_result = StringIO.new 'd377e39343e5cc277104beee349e1578dc50f7f8  elasticsearch-1.4.2.deb'

        Digest::SHA1.stub :file, @mock_result do
          @downloader = TestDownloader.new(hash, true)
          @downloader.download_remote_sha1.must_equal 'd377e39343e5cc277104beee349e1578dc50f7f8'
        end
      end

      it 'creates a tempfile to store the Elasticsearch deb file' do
        hash =
        {
          base_url: 'download.elasticsearch.org',
          version: '1.4.2',
          extension: '.deb'
        }

        @downloader = ElasticsearchUpdate::Downloader.new(hash, true)
        assert_kind_of Tempfile, @downloader.download_file(true)
      end
    end
  end
end