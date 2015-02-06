require 'highline/import'

module ElasticsearchUpdate
  # This class is in charge of retrieving and downloading data.
  class Wizard

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
      ask('What version of Elasticsearch should we update to? (major.minor.path) ', String) { |q| q.validate = /\d\.\d\.\d/ }
    end

    def host
      response = ask('What is your Elasticsearch hostname? (Default: localhost) ', String)

      'localhost' if response == ''
    end

    def port
      response = ask('What is your Elasticsearch port? (Default: 9200) ', String)

      '9200' if response == ''
    end

    def es_location_hash
      {
        host: host,
        port: port
      }
    end

    def sudo_password
      ask('What password should be used while updating Elasticsearch?') { |q| q.echo = "x" }
    end

    def download_hash
      {
        base_url: 'download.elasticsearch.org',
        version: version,
        extension: extension
      }
    end
  end
end
