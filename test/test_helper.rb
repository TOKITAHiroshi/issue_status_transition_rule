require 'test/unit'
require 'active_support'
require 'active_record'
require 'active_record/fixtures'

# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

# Ensure that we are using the temporary fixture path
#Engines::Testing.set_fixture_path

require File.expand_path(File.dirname(__FILE__) + '/../init.rb')

plugin_test_dir = File.expand_path(File.dirname(__FILE__))

ActiveRecord::Base.logger = Logger.new(plugin_test_dir + "/debug.log")
ActiveRecord::Base.configurations = YAML::load(IO.read(plugin_test_dir + "/db/database.yml"))
ActiveRecord::Base.establish_connection(ENV["DB"] || "sqlite3mem")
ActiveRecord::Migration.verbose = false
load(File.join(plugin_test_dir, "db", "schema.rb"))

Dir["#{plugin_test_dir}/fixtures/*.rb"].each {|file| require file }

