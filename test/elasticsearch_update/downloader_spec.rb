require 'minitest_helper'

module ElasticsearchUpdate
  class TestDownloader < Downloader
    def open(_url, &b)
      b.call StringIO.new "d377e39343e5cc277104beee349e1578dc50f7f8  elasticsearch-1.4.2.deb"
    end

    def abort(string)
      string
    end
  end

  # The TestDownloader class below tests the Downloader class from the library
  class TestDownloader
    describe 'Downloader', 'Used to download and verify Elasticsearch file' do
      it 'should initialize and correctly assign values.' do
        download = ElasticsearchUpdate::Download.new version: '1.4.2', extension: '.deb'

        downloader = TestDownloader.new(download, false)
        assert_kind_of ElasticsearchUpdate::Downloader, downloader

        downloader.download.base_url.must_equal 'download.elastic.co'
        downloader.download.extension.must_equal '.deb'
        downloader.download.version.must_equal '1.4.2'
        downloader.download.url.must_equal 'https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb'
        downloader.download.verify_url.must_equal 'https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb.sha1.txt'
      end

      it 'should retrieve the correct SHA1 value from Elasticsearch\'s website' do
        download = ElasticsearchUpdate::Download.new version: '1.4.2', extension: '.deb'

        mock_file = Minitest::Mock.new
        mock_file.expect(:read, 'd377e39343e5cc277104beee349e1578dc50f7f8  elasticsearch-1.4.2.deb')

        Kernel.stub :open, nil, mock_file do
          downloader = TestDownloader.new(download, true)
          downloader.download_remote_sha1.must_equal 'd377e39343e5cc277104beee349e1578dc50f7f8'
        end
      end

      it "should retrieve the verify the file's SHA1 value against Elasticsearch's" do
        download = ElasticsearchUpdate::Download.new version: '1.4.2', extension: '.deb'

        mock_file_obj = Minitest::Mock.new
        mock_result = 'd377e39343e5cc277104beee349e1578dc50f7f8'
        mock_file_obj.expect(:hexdigest, mock_result)

        mock_file = Minitest::Mock.new
        mock_file.expect(:path, 'fake/path')

        Digest::SHA1.stub :file, mock_file_obj do
          downloader = TestDownloader.new(download, true)
          downloader.update_file = mock_file
          downloader.verify_update_file.must_equal true
        end
      end

      it "should retrieve the verify the file's SHA1 value against Elasticsearch's" do
        download = ElasticsearchUpdate::Download.new version: '1.4.2', extension: '.deb'

        mock_file_obj = Minitest::Mock.new
        mock_result = '0'
        mock_file_obj.expect(:hexdigest, mock_result)

        mock_file = Minitest::Mock.new
        mock_file.expect(:path, 'fake/path')

        Digest::SHA1.stub :file, mock_file_obj do
          downloader = TestDownloader.new(download, true)
          downloader.update_file = mock_file
          downloader.verify_update_file.must_equal 'File was not downloaded correctly. Please try again.'
        end
      end

      it 'creates a tempfile to store the Elasticsearch deb file' do
        download = ElasticsearchUpdate::Download.new version: '1.4.2', extension: '.deb'

        downloader = TestDownloader.new(download, true)
        assert_kind_of Tempfile, downloader.download_file(true)
      end

      it 'writes a downloaded file' do
        download = ElasticsearchUpdate::Download.new version: '1.4.2', extension: '.deb'

        mock_resp = Minitest::Mock.new
        mock_resp.expect(:read_body, 'Test')

        mock_http = Minitest::Mock.new
        mock_http.expect(:request_get, mock_resp, [String])

        mock_file = Minitest::Mock.new
        mock_file.expect(:write, true, [String])
        mock_file.expect(:close, true)

        downloader = TestDownloader.new(download, true)
        Net::HTTP.stub :start, true, mock_http do
          downloader.write_file_from_url(mock_file, 'http://test.org')
        end
      end
    end
  end
end
