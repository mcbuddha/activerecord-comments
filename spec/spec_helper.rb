require 'yaml'
require 'pry'

$:.push File.expand_path('../lib', __FILE__)

DBCONF = YAML::load(IO.read(File.expand_path('../config/database.yml', __FILE__)))
ENV['DB'] ||= 'postgres'

require 'schema_comments'

RSpec.configure do |c|
  c.before(:suite) { ActiveRecord::Base.establish_connection(DBCONF[ENV['DB']]) }

  c.around(:each) do |ex|
    ActiveRecord::Schema.define do
      create_table :test do |t|
        t.string :field1
        t.integer :field2
      end
    end
    ex.run
    ActiveRecord::Schema.define { drop_table :test }
  end
end
