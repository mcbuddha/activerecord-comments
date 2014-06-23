$: << File.expand_path('../lib', __FILE__)

require 'yaml'
require 'pry'

require 'activerecord_comments'

DBCONF = YAML::load(IO.read(File.expand_path('../config/database.yml', __FILE__)))
ENV['DB'] ||= 'postgres'
ActiveRecord::Base.establish_connection DBCONF[ENV['DB']]

RSpec.configure do |c|
  c.around(:each) do |ex|
    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Schema.define do
        create_table :test do |t|
          t.string :field1
          t.integer :field2
        end
      end
    end
    ex.run
    ActiveRecord::Migration.suppress_messages { ActiveRecord::Schema.define { drop_table :test } }
  end
end
