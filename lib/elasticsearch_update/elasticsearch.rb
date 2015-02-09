require 'logger'
require 'json'
require 'net/http'

module ElasticsearchUpdate
  # This class is in charge of retrieving and downloading data.
  class Elasticsearch
    attr_reader :es_host, :es_port
    def initialize(hash = { host: 'localhost', port: 9200 })
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO

      @log.debug('Logger created for Elasticsearch.')

      @es_host = hash[:host]
      @es_port = hash[:port]
    end

    def disable_cluster_routing_allocation
      @log.info('Disabling cluster routing allocation')

      begin
        req = Net::HTTP::Put.new('/_cluster/settings',
                                 'Content-Type' => 'application/javascript')
        req.body = { transient: { 'cluster.routing.allocation.enable' => 'none' } }
        req.body = req.body.to_json
        response = Net::HTTP.new(@es_host, @es_port).start {|http| http.request(req) }
      rescue Errno::ECONNREFUSED
        puts 'Connection could not be made to Elasticsearch at'
        puts @es_host + ':' + @es_port + '/_cluster/settings'
        abort('Please verify that Elasticsearch is available at this address.')
      end

      response
    end

    def enable_cluster_routing_allocation
      @log.info('Enabling cluster routing allocation')

      begin
        req = Net::HTTP::Put.new('/_cluster/settings',
                                 'Content-Type' => 'application/javascript')
        req.body = { transient: { 'cluster.routing.allocation.enable' => 'all' } }
        req.body = req.body.to_json
        response = Net::HTTP.new(@es_host, @es_port).start {|http| http.request(req) }
      rescue Errno::ECONNREFUSED
        puts 'Connection could not be made to Elasticsearch at'
        puts @es_host + ':' + @es_port + '/_cluster/settings'
        abort('Please verify that Elasticsearch is available at this address.')
      end

      response
    end

    def shutdown_local_node
      @log.info('Shutting down local node')
      @shutdown_uri = URI('http://' + @es_host + ':' + @es_port.to_s + '/_cluster/nodes/_local/_shutdown')
      response = Net::HTTP.post_form(@shutdown_uri, {})

      response
    end

    def start_elasticsearch_service(password)
      @log.info('Starting elasticsearch service')
      system('echo ' + password + ' | sudo -S service elasticsearch start')
    end

    def start_elasticsearch_binary(path)
      @log.info('Starting elasticsearch binary')
      system(path + 'bin/elasticsearch')
    end
  end
end
