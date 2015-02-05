require_relative '../lib/elasticsearch_update.rb'
require 'net/http'
require 'tempfile'
require 'logger'
require 'json'
require 'highline/import'

log = Logger.new(STDOUT)
log.level = Logger::INFO

log.debug('Logger created.')

log.info('Disabling cluster routing allocation')
@es_port = 9200
@es_host = 'localhost'
@settings_path = '/_cluster/settings'

begin
  req = Net::HTTP::Put.new(@settings_path, initheader = { 'Content-Type' => 'application/javascript'})
  req.body = { transient: { 'cluster.routing.allocation.enable' => 'none' } }
  req.body = req.body.to_json
  response = Net::HTTP.new(@es_host, @es_port).start {|http| http.request(req) }
rescue Errno::ECONNREFUSED
  puts 'Connection could not be made to Elasticsearch at'
  puts @es_host + ':' + @es_port.to_s + @settings_path
  abort('Please verify that Elasticsearch is available at this address.')
end

log.info('Shutting down local node')
@shutdown_uri = URI('http://' + @es_host + ':' + @es_port.to_s + '/_cluster/nodes/_local/_shutdown')
response = Net::HTTP.post_form(@shutdown_uri, {})

log.debug('Creating temporary file.')

begin
  update_file = Tempfile.new(['elasticsearch_update_file', '.deb'])

  downloader = ElasticsearchUpdate::Downloader.new

  downloader.download_elasticsearch(update_file)

  sudo_passwd = ask('What password should be used while updating Elasticsearch?') { |q| q.echo = "x" }

  # log.info('Updating elasticsearch from .deb file.')
  # command = 'echo ' + sudo_passwd + ' | sudo -S dpkg -i "' + update_file.path + '"'
  # puts command
  # command_result = system(command)

  # log.info('Starting elasticsearch service')
  # system('echo ' + sudo_passwd + ' | sudo -S service elasticsearch start')

  # log.debug('Establishing a new elasticsearch client link')
  # client = Elasticsearch::Client.new log: false

  # log.info('Re-enabling elasticsearch cluster routing allocation')
  # client.cluster.put_settings body:
  # { transient: { 'cluster.routing.allocation.enable' => 'all' } }

  # log.info('Deleting temporary files.')
  # update_file.unlink
ensure
  update_file.unlink
end

# log.info('Upgrade complete. Please wait for rebalancing to complete before upgrading the next node')
