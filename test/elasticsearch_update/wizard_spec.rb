require 'minitest_helper'

module ElasticsearchUpdate
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

        result = wizard.extension

        result.must_equal '.deb'
      end

      it 'should create the download hash' do
        wizard = TestWizard.new

        result = wizard.download_hash

        result.must_equal(base_url: 'download.elasticsearch.org',
                          version: 'Question asked.',
                          extension: '.deb')
      end
    end
  end
end
