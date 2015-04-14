require 'logger'
require 'digest/sha1'
require 'tempfile'
require 'open-uri'

module ElasticsearchUpdate
  # == Downloader
  # ElasticsearchUpdate::Downloader class is used to download the
  # Elasticsearch update file
  #
  # == Parameters
  #
  # Initilization requires a +hash+ and optional +test+ parameter.
  #
  # +hash+ is a ruby hash in the following format:
  # { host: String, port: Integer }
  #
  # +test+ is a boolean identifying whether or not we are in a test
  # if we are, we set the Logger to logging FATAL errors only.
  #
  # == Example
  #
  #    ElasticsearchUpdate::Downloader.new({ host: 'localhost', port: 9200 })
  class Downloader
    attr_reader :download
    attr_accessor :update_file
    # == initialize
    # Allows us to create an instance of the Downloader
    #
    # == Parameters
    #
    # initialize requires a +hash+ and optional +test+ parameter.
    #
    # +hash+ is a ruby hash in the following format:
    # { host: String, port: Integer }
    #
    # +test+ is a boolean identifying whether or not we are in a test
    # if we are, we set the Logger to logging FATAL errors only.
    #
    # == Example
    #
    #    ElasticsearchUpdate::Downloader.new({ host: 'localhost', port: 9200 })
    def initialize(download, test = false)
      @log = Logger.new(STDOUT)
      if test
        @log.level = Logger::FATAL
      else
        @log.level = Logger::INFO
      end

      @log.debug('Logger created for Downloader.')

      @download = download
    end

    # == write_file_from_url
    # Allows us to write data from a URL to a file.
    #
    # == Parameters
    #
    # write_file_from_url requires a +file+ to write to and a +url+ from which
    # to download the file from.
    #
    # +file+ is a ruby File or Tempfile object
    #
    # +url+ is a string for the URL.
    #
    # == Example
    #
    #    write_file_from_url(Tempfile.new('example'), http://foo.bar/file.zip)
    def write_file_from_url(file, url)
      Net::HTTP.start(@download.base_url) do |http|
        begin
          http.request_get(url) do |resp|
            resp.read_body do |segment|
              file.write(segment)
            end
          end
        ensure
          file.close
        end
      end
    end

    # == download_file
    # Begins the download process of the Elasticsearch update file.
    #
    # == Parameters
    #
    # download_file takes an optional boolean argument, named +test+.
    #
    # +test+ is an optional boolean which allows us to avoid actually writing to
    # a file while running our tests.
    #
    # == Example
    #
    #    # Not a test
    #    download_file
    #    # Test
    #    download_file(true)
    def download_file(test = false)
      @update_file = Tempfile.new(['elasticsearch_update_file', @download.extension])

      @log.info('Downloading file from url.')

      write_file_from_url(@update_file, @download.url) unless test

      @update_file
    end

    # == verify_update_file
    # Begins the verification process the Elasticsearch update file by
    # using the instance variables of the file and the downloaded SHA1 value.
    #
    # == Parameters
    #
    # verify_update_file takes no parameters.
    #
    # == Requires
    #
    # verify_update_file requires @update_file to be set as a file.
    #
    # == Example
    #
    #    verify_update_file
    def verify_update_file
      @log.info('Beginning integrity check of downloaded file .')
      @file_sha1 = Digest::SHA1.file(@update_file.path).hexdigest

      @log.info('Verifying integrity of downloaded file.')

      if download_remote_sha1 == @file_sha1
        @log.info('Integrity verified.')
        true
      else
        abort('File was not downloaded correctly. Please try again.')
      end
    end

    # == download_remote_sha1
    # Begins the download of the Elasticsearch update file SHA1 text file.
    # It then separates the SHA1 value from the filename.
    #
    # == Parameters
    #
    # download_remote_sha1 takes no parameters.
    #
    # == Requires
    #
    # download_remote_sha1 requires @download.verify_url to be set as a string to a
    # .txt file.
    #
    # == Example
    #
    #    download_remote_sha1
    def download_remote_sha1
      @log.info('Downloading Elasticsearch SHA1.')

      @remote_sha1 = ''
      open(@download.verify_url) do |file|
        @remote_sha1 = file.read
      end

      @remote_sha1 = @remote_sha1.split(/\s\s/)[0]

      @remote_sha1
    end
  end
end
