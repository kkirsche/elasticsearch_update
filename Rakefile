require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test/"
  t.libs << "bin/"
  t.libs << "lib/"
  t.pattern = "test/elasticsearch_update/**/*_spec.rb"
end

task :default => :test