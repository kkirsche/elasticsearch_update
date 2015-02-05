require 'elasticsearch_update'

ElasticsearchUpdate::Cli.start if __FILE__ == $PROGRAM_NAME

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

# log.info('Upgrade complete. Please wait for rebalancing to complete before upgrading the next node')
