#!/usr/bin/env ruby
require 'elasticsearch_update'

ElasticsearchUpdate::Cli.start if __FILE__ == $PROGRAM_NAME

  # log.info('Re-enabling elasticsearch cluster routing allocation')
  # client.cluster.put_settings body:
  # { transient: { 'cluster.routing.allocation.enable' => 'all' } }

  # log.info('Deleting temporary files.')
  # update_file.unlink

# log.info('Upgrade complete. Please wait for rebalancing to complete before upgrading the next node')
