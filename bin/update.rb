#!/usr/bin/env ruby
require 'elasticsearch_update'

args = ARGV.dup
ARGV.clear
command = args.shift.strip rescue 'help'

ElasticsearchUpdate::Cli.start