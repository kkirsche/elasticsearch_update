require 'minitest_helper'

module ElasticsearchUpdate
  # Test wizard overrides the Wizard class methods for testing.
  class TestWizard < Wizard
    def ask(_question, _type = String, &_block)
      'Question asked.'
    end

    def choose(&_block)
      @choice = '.deb'
    end
  end

  # The TestInstaller class below tests the Downloader class from the library
  class TestWizard
    describe 'Wizard', 'Used to ask questions on the command line' do
      it 'should initialize without errors' do
        wizard = TestWizard.new
        assert_kind_of Wizard, wizard
      end

      it "should ask for Elasticsearch's host" do
        wizard = TestWizard.new

        result = wizard.host

        result.must_equal 'Question asked.'
      end

      it 'should ask for the desired Elasticsearch version' do
        wizard = TestWizard.new

        result = wizard.version

        result.must_equal 'Question asked.'
      end

      it "should ask for Elasticsearch's port" do
        wizard = TestWizard.new

        result = wizard.port

        result.must_equal 'Question asked.'
      end

      it "should ask for Elasticsearch's location info" do
        wizard = TestWizard.new

        result = wizard.es_location_hash

        result.must_equal(host: 'Question asked.', port: 'Question asked.')
      end

      it "should ask for Elasticsearch's file system location" do
        wizard = TestWizard.new

        result = wizard.elasticsearch_fs_location

        result.must_equal 'Question asked.'
      end

      it "should ask for the system's sudo password" do
        wizard = TestWizard.new

        result = wizard.sudo_password

        result.must_equal 'Question asked.'
      end

      it 'should ask for the desired extension of the update file' do
        wizard = TestWizard.new

        @mock_menu = Minitest::Mock.new
        @mock_menu.expect(:prompt, true)
        @mock_menu.expect(:choice, '.deb')

        TestWizard.stub :choose, '.deb', @mock_menu do
          result = wizard.extension
          result.must_equal '.deb'
        end
      end

      it 'should return a download object' do
        wizard = TestWizard.new
        hash = {
          base_url: 'download.elastic.co',
          version: 'Question asked.',
          extension: '.deb',
          url: 'https://download.elastic.co/elasticsearch/elasticsearch/elast' \
               'icsearch-Question asked..deb',
          verify_url: 'https://download.elastic.co/elasticsearch/elasticsearc' \
                      'h/elasticsearch-Question asked..deb.sha1.txt'
        }

        result = wizard.download_hash
        assert_kind_of ElasticsearchUpdate::Download, result
      end

      it 'should return a hash version of the download object' do
        wizard = TestWizard.new
        hash = {
          base_url: 'download.elastic.co',
          version: 'Question asked.',
          extension: '.deb',
          url: 'https://download.elastic.co/elasticsearch/elasticsearch/elast' \
               'icsearch-Question asked..deb',
          verify_url: 'https://download.elastic.co/elasticsearch/elasticsearc' \
                      'h/elasticsearch-Question asked..deb.sha1.txt'
        }

        result = wizard.download_hash
        assert_kind_of ElasticsearchUpdate::Download, result
        result.to_h.must_equal hash
      end

      it 'should return an array version of the download object' do
        wizard = TestWizard.new
        array = [
          [:base_url, 'download.elastic.co'],
          [:version, 'Question asked.'],
          [:extension, '.deb'],
          [:url, 'https://download.elastic.co/elasticsearch/elasticsearch/ela' \
                 'sticsearch-Question asked..deb'],
          [:verify_url, 'https://download.elastic.co/elasticsearch/elasticsea' \
                 'rch/elasticsearch-Question asked..deb.sha1.txt']
        ]

        result = wizard.download_hash
        result.to_a.must_equal array
      end
    end
  end
end
