# require 'elasticsearch_update/version'
require 'highline/import'
require 'logger'
require 'digest/sha1'
require 'tempfile'

# This module updates a debian Elasticsearch instance
module ElasticsearchUpdate
  # This class is in charge of retrieving and downloading data.
  class Downloader
    def initialize
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO

      @log.debug('Logger created for Downloader.')
    end

    def download_elasticsearch(local_file, es_extension)
      es_version = version

      @log.info('Downloading Elasticsearch ' + es_extension + ' file.')
      @base = 'download.elasticsearch.org'
      Net::HTTP.start(@base) do |http|
        begin
          @file = 'elasticsearch-' + es_version + es_extension
          http.request_get(
            'https://' + @base + '/elasticsearch/elasticsearch/' + @file) do |resp|
            resp.read_body do |segment|
              local_file.write(segment)
            end
          end
        ensure
          local_file.close
        end

        verify_file(local_file, es_extension, es_version)
      end
    end

    def extension
      choose do |menu|
        menu.prompt = 'Which type of upgrade are we doing?  '

        menu.choice(:deb) { @choice = '.deb' }
        menu.choice(:zip) { @choice = '.zip' }
        menu.choice(:rpm) { @choice = '.rpm' }
        menu.choice(:tar) { @choice = '.tar.gz' }
      end

      @choice
    end

    def version
      ask('What version of Elasticsearch should we update to? ', String)
    end

    def verify_file(local_file, ext, vers)
      @log.info('Beginning downloaded file integrity check.')
      @sha1 = Digest::SHA1.file(local_file.path).hexdigest

      @sha1_file = Tempfile.new(['elasticsearch_sha1', '.txt'])

      @log.info('Downloading Elasticsearch SHA1.')
      @base = 'download.elasticsearch.org'
      Net::HTTP.start(@base) do |http|
        @file = 'elasticsearch-' + vers + ext + '.sha1.txt'
        http.request_get(
          'https://' + @base + '/elasticsearch/elasticsearch/' + @file) do |resp|
          resp.read_body do |segment|
            @sha1_file.write(segment)
          end
        end
      end

      @sha1_file.rewind

      contents = @sha1_file.read

      contents = contents.split(/\s\s/)

      @log.info('Verifying integrity downloaded file.')

      if contents[0] == @sha1
        true
      else
        abort('File was not downloaded correctly. Please try again.')
      end
    end
  end
end
