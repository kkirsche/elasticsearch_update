require 'logger'

module ElasticsearchUpdate
  # == CLI
  # ElasticsearchUpdate::Cli class is used to begin application execution
  # and walks the user through the update process
  #
  # == Parameters
  #
  # Start takes no parameters or options.
  class Cli
    # Start the command line update process which calls all necessary
    # methods and classes to complete an Elasticsearch update.
    #
    # ==== Example
    #
    #    ElasticsearchUpdate::Cli.new
    def initialize
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO

      @log.debug('Logger created for CLI.')

      wizard = Wizard.new

      es_client = Elasticsearch.new wizard.es_location_hash
      es_client.cluster_routing_allocation('none')
      es_client.shutdown_local_node

      downloader = Downloader.new(wizard.prepare_for_download)
      file = downloader.download_file
      downloader.verify_update_file

      installer = Installer.new(wizard.sudo_password,
                                downloader.extension)
      installer.install_file(file)

      es_client.start_elasticsearch(installer)
      @log.info('Waiting for Elasticsearch to start.')
      sleep 10
      es_client.cluster_routing_allocation('all')
    end
  end
end
