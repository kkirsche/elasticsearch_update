require 'logger'
require 'json'
require 'net/http'

module ElasticsearchUpdate
  # == Elasticsearch
  # ElasticsearchUpdate::Elasticsearch class is used to interact with
  # the local Elasticsearch instance.
  #
  # == Parameters
  #
  # Initilization takes an optional +hash+ and optional +test+ parameter.
  #
  # +hash+ is a ruby hash in the following format:
  # { host: String, port: Integer }
  #
  # +test+ is a boolean identifying whether or not we are in a test
  # if we are, we set the Logger to logging FATAL errors only.
  #
  # == Example
  #
  #    ElasticsearchUpdate::Elasticsearch.new({ host: 'localhost', port: 9200 })
  class Elasticsearch
    attr_reader :es_host, :es_port
    # == initialize
    # Allows us to create an instance of the Elasticsearch interaction client.
    #
    # == Parameters
    #
    # initialize takes an optional +hash+ and optional +test+ parameter.
    #
    # +hash+ is a ruby hash in the following format:
    # { host: String, port: Integer }
    #
    # +test+ is a boolean identifying whether or not we are in a test
    # if we are, we set the Logger to logging FATAL errors only.
    #
    # == Example
    #
    #    # Not a test, default host and port
    #    ElasticsearchUpdate::Elasticsearch.new
    #    # Not a test, manually set host and port
    #    ElasticsearchUpdate::Elasticsearch.new({ host: 'localhost', port: 9200 })
    #    # Test
    #    ElasticsearchUpdate::Elasticsearch.new({ host: 'localhost', port: 9200 }, true)
    def initialize(hash = { host: 'localhost', port: 9200 }, test = false)
      @log = Logger.new(STDOUT)
      if test
        @log.level = Logger::FATAL
      else
        @log.level = Logger::INFO
      end

      @log.debug('Logger created for Elasticsearch.')

      @es_host = hash[:host]
      @es_port = hash[:port]
    end

    # == cluster_routing_allocation
    # Allows us to enable or disable Elasticsearch's cluster routing allocation
    # setting via the HTTP API. Learn more in Elasticsearch's documentation:
    # http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-cluster.html
    #
    # == Parameters
    #
    # cluster_routing_allocation takes an optional +type+.
    #
    # +type+ is a String. Possible values include:
    # 'all' -- (default) Allows shard allocation for all kinds of shards.
    # 'primaries' -- Allows shard allocation only for primary shards.
    # 'new_primaries' -- Allows shard allocation only for primary shards for new indices.
    # 'none' -- No shard allocations of any kind are allowed for all indices.
    #
    # == Example
    #
    #    # Disabling shard allocation
    #    cluster_routing_allocation('none')
    #    # Allowing shard allocation
    #    cluster_routing_allocation('all')
    def cluster_routing_allocation(type)
      @log.info('Disabling cluster routing allocation')

      begin
        req = Net::HTTP::Put.new('/_cluster/settings',
                                 'Content-Type' => 'application/javascript')
        req.body = { transient: { 'cluster.routing.allocation.enable' => type } }
        req.body = req.body.to_json
        response = Net::HTTP.new(@es_host, @es_port).start {|http| http.request(req) }
      rescue Errno::ECONNREFUSED
        puts 'Connection could not be made to Elasticsearch at'
        puts @es_host + ':' + @es_port + '/_cluster/settings'
        abort('Please verify that Elasticsearch is available at this address.')
      end

      response
    end

    # == shutdown_local_node
    # Allows us to shutdown a the local Elasticsearch node via the HTTP API.
    # Requires @es_host and @es_port which were set during initialization.
    # Learn more in Elasticsearch's documentation:
    # http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cluster-nodes-shutdown.html
    #
    # == Parameters
    #
    # shutdown_local_node takes no parameters
    #
    # == Example
    #
    #    shutdown_local_node
    def shutdown_local_node
      @log.info('Shutting down local node')
      @shutdown_uri = URI('http://' + @es_host + ':' + @es_port.to_s + '/_cluster/nodes/_local/_shutdown')
      response = Net::HTTP.post_form(@shutdown_uri, {})

      response
    end

    # == start_elasticsearch_service
    # Allows us to begin the Linux Elasticsearch service
    #
    # == Parameters
    #
    # start_elasticsearch_service takes a sudo +password+ parameter as a String.
    #
    # == Example
    #
    #    start_elasticsearch_service('test_password')
    def start_elasticsearch_service(password)
      @log.info('Starting elasticsearch service')
      system('echo ' + password + ' | sudo -S service elasticsearch start')
    end

    # == start_elasticsearch_binary
    # Allows us to begin a Unix / Linux binary instance of Elasticsearch
    # Windows users require a slightly different command.
    #
    # == Parameters
    #
    # start_elasticsearch_binary takes a +path+ parameter as a String.
    #
    # == Example
    #
    #    start_elasticsearch_binary('/path/to/elasticsearch')
    def start_elasticsearch_binary(path)
      @log.info('Starting elasticsearch binary')
      system(path + 'bin/elasticsearch')
    end

    # == start_elasticsearch
    # Allows us to use the proper command when starting Elasticsearch.
    #
    # == Parameters
    #
    # start_elasticsearch takes a +installer+ parameter which is an instance of
    # ElasticsearchUpdate::Installer.
    #
    # == Example
    #
    #    installer = ElasticsearchUpdate::Installer.new('test_password', '.deb')
    #    start_elasticsearch(installer)
    def start_elasticsearch(installer_obj)
      case installer_obj.extension
      when '.zip'
        start_elasticsearch_binary(wizard.test)
      when '.deb'
        start_elasticsearch_service(installer_obj.sudo_password)
      when '.rpm'
        start_elasticsearch_service(installer_obj.sudo_password)
      when '.tar.gz'

      end
    end
  end
end
