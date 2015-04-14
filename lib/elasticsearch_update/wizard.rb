require 'highline/import'

module ElasticsearchUpdate
  # == Wizard
  # ElasticsearchUpdate::Wizard class is used to ask questions
  # to the user using the highline gem.
  #
  # == Parameters
  #
  # Initilization requires no parameters.
  #
  # == Example
  #
  #    ElasticsearchUpdate::Wizard.new
  class Wizard
    # == extension
    # extension is used to provide a menu to the user asking which file
    # type they would like to use when updating Elasticsearch
    #
    # == Parameters
    #
    # Requires no parameters.
    #
    # == Returns
    #
    # Returns +@choice+ which is a string containing either:
    # 1. '.deb'
    # 2. '.rpm'
    #
    # == Example
    #
    #    wizard = ElasticsearchUpdate::Wizard.new
    #    extension = wizard.extension
    def extension
      choose do |menu|
        menu.prompt = 'Which type of upgrade are we doing?  '

        menu.choice(:deb) { @choice = '.deb' }
        # menu.choice(:zip) { @choice = '.zip' }
        menu.choice(:rpm) { @choice = '.rpm' }
        # menu.choice(:tar) { @choice = '.tar.gz' }
      end

      @choice
    end

    # == version
    # version is used to ask the user which version of Elasticsearch
    # they would like to use.
    #
    # == Parameters
    #
    # Requires no parameters.
    #
    # == Returns
    #
    # Returns a string containing a version number. Ex: '1.4.3'
    #
    # == Example
    #
    #    wizard = ElasticsearchUpdate::Wizard.new
    #    version = wizard.version
    def version
      ask('What version of Elasticsearch should we update to? (major.minor.path) ', String) { |q| q.validate = /\d\.\d\.\d/ }
    end

    # == host
    # host is used to ask the user the hostname of Elasticsearch so we
    # can interact with it over it's HTTP API.
    #
    # == Parameters
    #
    # Requires no parameters.
    #
    # == Returns
    #
    # Returns a string containing the hostname. Ex: 'localhost'
    #
    # == Example
    #
    #    wizard = ElasticsearchUpdate::Wizard.new
    #    host = wizard.host
    def host
      response = ask('What is your Elasticsearch hostname? (Default: localhost) ', String)
      response = 'localhost' if response == ''

      response
    end

    # == port
    # port is used to ask the user the port of Elasticsearch so we
    # can interact with it over it's HTTP API.
    #
    # == Parameters
    #
    # Requires no parameters.
    #
    # == Returns
    #
    # Returns a string containing the port. Ex: '9200'
    #
    # == Example
    #
    #    wizard = ElasticsearchUpdate::Wizard.new
    #    port = wizard.port
    def port
      response = ask('What is your Elasticsearch port? (Default: 9200) ', String)

      response = '9200' if response == ''

      response
    end

    # == es_location_hash
    # es_location_hash is used construct the location hash used by other
    # gem classes.
    #
    # == Parameters
    #
    # Requires no parameters.
    #
    # == Returns
    #
    # Returns a hash containing the host and port.
    # Ex: { host: 'localhost', port: 9200 }
    #
    # == Example
    #
    #    wizard = ElasticsearchUpdate::Wizard.new
    #    location_hash = wizard.es_location_hash
    def es_location_hash
      {
        host: host,
        port: port
      }
    end

    # == elasticsearch_fs_location
    # elasticsearch_fs_location is used to find where the Elasticsearch
    # binary file is so that we can update from .zip or .tar.gz and
    # successfully start elasticsearch after the update
    #
    # == Parameters
    #
    # Requires no parameters.
    #
    # == Returns
    #
    # Returns a string containing path.
    # Ex: '/path/to/elasticsearch/'
    #
    # == Example
    #
    #    wizard = ElasticsearchUpdate::Wizard.new
    #    fs_location = wizard.elasticsearch_fs_location
    def elasticsearch_fs_location
      ask('In what directory does Elasticsearch run? ', String)
    end

    # == sudo_password
    # sudo_password is used to get the sudo password for use while installing
    # the updated Elasticsearch files. Echo's "x" for each keypress.
    #
    # == Parameters
    #
    # Requires no parameters.
    #
    # == Returns
    #
    # Returns a string containing the password.
    # Ex: 'example_password'
    #
    # == Example
    #
    #    wizard = ElasticsearchUpdate::Wizard.new
    #    password = wizard.sudo_password
    def sudo_password
      ask('What password should be used while updating Elasticsearch? ') { |q| q.echo = "x" }
    end

    # == download_hash
    # download_hash is used to construct the hash used by the Downloader
    #
    # == Parameters
    #
    # Requires no parameters.
    #
    # == Returns
    #
    # Returns a hash containing the base_url, version, and extension.
    #
    # == Example
    #
    #    wizard = ElasticsearchUpdate::Wizard.new
    #    hash = wizard.download_hash
    def download_hash
      {
        base_url: 'download.elastic.co',
        version: version,
        extension: extension
      }
    end
  end
end
