begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Rollenspiel'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'


load 'rails/tasks/statistics.rake'



Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end


task default: :test

desc 'Benchmark the rollenspiel role definitions'
task :bench do
  require 'benchmark'
  require File.expand_path("../test/dummy/config/environment.rb",  __FILE__)
  ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __FILE__)]
  ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __FILE__)
  n = 1000

  Benchmark.bm do |x|
    x.report "Plain" do
      s = Rollenspiel::RoleProvider::RoleStructure.new.tap do |builder|
        n.times do |i|
          builder.roles "foo#{i}", "bar#{i}", "baz#{i}"
          builder.roles "bat#{i}", "bo#{i}"
        end
      end
      s.layout
    end
    x.report "Inherits" do
      s = Rollenspiel::RoleProvider::RoleStructure.new.tap do |builder|
        n.times do |i|
          builder.roles "foo#{i}", inherits: ["bar#{i}", "baz#{i}"]
          builder.roles "faa#{i}", inherits: ["bar#{i}", "bat#{i}"]
        end
      end
      s.layout
    end
  end
end
