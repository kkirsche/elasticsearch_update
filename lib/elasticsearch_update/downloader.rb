require 'logger'
require 'digest/sha1'
require 'tempfile'

module ElasticsearchUpdate
  # This class is in charge of retrieving and downloading data.
  class Downloader
    attr_reader :extension, :base, :version, :download_url, :verify_url
    def initialize(hash, test = false)
      @log = Logger.new(STDOUT)
      if test
        @log.level = Logger::INFO
      else
        @log.level = Logger::FATAL
      end

      @log.debug('Logger created for Downloader.')

      @extension = hash[:extension]
      @base = hash[:base_url]
      @version = hash[:version]
      @download_url = 'https://' + @base + '/elasticsearch/elasticsearch/elasticsearch-' + @version + @extension
      @verify_url = 'https://' + @base + '/elasticsearch/elasticsearch/elasticsearch-' + @version + @extension + '.sha1.txt'
    end

    def write_file_from_url(file, url)
      Net::HTTP.start(@base) do |http|
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

    def download_file(test = false)
      @update_file = Tempfile.new(['elasticsearch_update_file', @extension])

      @log.info('Downloading file from url.')

      write_file_from_url(@update_file, @download_url) unless test

      @update_file
    end

    def verify_update_file
      @log.info('Beginning integrity check of downloaded file .')
      @sha1 = Digest::SHA1.file(@update_file.path).hexdigest

      @log.info('Verifying integrity of downloaded file.')

      if download_remote_sha1 == @sha1
        @log.info('Integrity verified.')
        true
      else
        abort('File was not downloaded correctly. Please try again.')
      end
    end

    def download_remote_sha1
      @sha1_file = Tempfile.new(['elasticsearch_sha1', '.txt'])

      @log.info('Downloading Elasticsearch SHA1.')
      write_file_from_url(@sha1_file, @verify_url)

      @sha1_file.open

      contents = @sha1_file.read

      contents = contents.split(/\s\s/)

      @sha1_file.unlink

      contents[0]
    end
  end
end
