require 'minitest_helper'

module ElasticsearchUpdate
  # The TestInstaller class below tests the Downloader class from the library
  class TestInstaller < Minitest::Test
    describe 'Installer', 'Used to install Elasticsearch file' do

      it 'should initialize and correctly assign values.' do
        @installer = ElasticsearchUpdate::Installer.new('test_password', '.deb', true)
        assert_kind_of ElasticsearchUpdate::Installer, @installer

        @installer.sudo_password.must_equal 'test_password'
        @installer.extension.must_equal '.deb'
      end

      it 'should install the .deb file' do
        @mock_file = Minitest::Mock.new
        @mock_file.expect(:path, '/path/to/file.deb')

        Kernel.stub :system, true do
          @installer = ElasticsearchUpdate::Installer.new('test_password', '.deb', true)
          response = @installer.install_file(@mock_file)

          response.must_equal true
        end
      end

      it 'should install the .rpm file' do
        @mock_file = Minitest::Mock.new
        @mock_file.expect(:path, '/path/to/file.rpm')

        Kernel.stub :system, true do
          @installer = ElasticsearchUpdate::Installer.new('test_password', '.rpm', true)
          response = @installer.install_file(@mock_file)

          response.must_equal true
        end
      end
    end
  end
end
