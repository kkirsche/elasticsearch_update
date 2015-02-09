require 'logger'

module ElasticsearchUpdate
  # This class is in charge of retrieving and downloading data.
  class Cli
    def self.start
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO

      @log.debug('Logger created for CLI.')

      wizard = ElasticsearchUpdate::Wizard.new

      es_client = ElasticsearchUpdate::Elasticsearch.new(wizard.es_location_hash)
      es_client.disable_cluster_routing_allocation
      es_client.shutdown_local_node

      downloader = ElasticsearchUpdate::Downloader.new(wizard.download_hash)
      file = downloader.download_file
      downloader.verify_update_file

      installer = ElasticsearchUpdate::Installer.new(wizard.sudo_password, downloader.extension)
      installer.install_file(file)

      es_client.start_elasticsearch(installer)
    end
  end
end
